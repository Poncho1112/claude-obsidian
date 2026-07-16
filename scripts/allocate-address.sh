#!/usr/bin/env bash
# allocate-address.sh — atomic creation-order address allocation for the vault.
#
# Reserves the next address of the form c-NNNNNN and increments the counter
# under an exclusive lock. Prefers flock (Linux/WSL/CI); on hosts without flock
# (e.g. Git-Bash on Windows) it falls back to an atomic mkdir mutex with the
# same 5s timeout and age-based stale-lock recovery. On missing counter file,
# recovers by scanning the vault for the highest existing c-NNNNNN in page
# frontmatter and resuming from max+1. Never silently resets to 1 in a
# non-empty vault.
#
# Usage:
#   ./scripts/allocate-address.sh           # prints the reserved address (e.g. c-000042) to stdout
#   ./scripts/allocate-address.sh --peek    # prints the next value without incrementing
#   ./scripts/allocate-address.sh --rebuild # recomputes counter from max observed and exits
#
# Exit codes:
#   0 — success
#   1 — lock acquisition failed (another writer is holding the lock)
#   2 — vault-meta directory missing and cannot be created
#   3 — counter value corrupt or non-numeric

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COUNTER_FILE="${VAULT_ROOT}/.vault-meta/address-counter.txt"
LOCK_FILE="${VAULT_ROOT}/.vault-meta/.address.lock"
LOCK_DIR="${LOCK_FILE}.d"
WIKI_DIR="${VAULT_ROOT}/wiki"
STALE_AFTER_SEC="${STALE_AFTER_SEC:-30}"

MODE="${1:-allocate}"

mkdir -p "$(dirname "$COUNTER_FILE")" || {
  echo "ERR: cannot create .vault-meta/" >&2
  exit 2
}

# --- Portable exclusive lock (5s timeout) ---------------------------------
# flock is unavailable in some POSIX-ish environments (notably Git-Bash on
# Windows). Prefer it where present; otherwise use an atomic mkdir mutex.
_locked_by_mkdir=0

release_lock() {
  if [ "$_locked_by_mkdir" -eq 1 ]; then
    rmdir "$LOCK_DIR" 2>/dev/null || true
    _locked_by_mkdir=0
  fi
}

if command -v flock >/dev/null 2>&1; then
  # flock releases automatically when fd 9 closes at process exit.
  exec 9>"$LOCK_FILE"
  if ! flock -x -w 5 9; then
    echo "ERR: could not acquire address allocator lock within 5s" >&2
    exit 1
  fi
else
  # mkdir is atomic: it fails if the directory already exists, giving us a
  # race-free mutex. A crashed holder is reclaimed after STALE_AFTER_SEC.
  waited=0
  until mkdir "$LOCK_DIR" 2>/dev/null; do
    if [ -d "$LOCK_DIR" ]; then
      lock_mtime="$(stat -c %Y "$LOCK_DIR" 2>/dev/null || echo 0)"
      age=$(( $(date +%s) - lock_mtime ))
      if [ "$age" -ge "$STALE_AFTER_SEC" ]; then
        rmdir "$LOCK_DIR" 2>/dev/null || true
        continue
      fi
    fi
    if [ "$waited" -ge 5 ]; then
      echo "ERR: could not acquire address allocator lock within 5s" >&2
      exit 1
    fi
    sleep 1
    waited=$((waited + 1))
  done
  _locked_by_mkdir=1
  trap release_lock EXIT
fi

scan_max_c_address() {
  # Emit the largest NNNNNN from "address: c-NNNNNN" lines that appear inside
  # the FIRST YAML frontmatter block of each wiki .md file. Code-block examples
  # and body prose are excluded. Returns 0 if none found.
  if [ ! -d "$WIKI_DIR" ]; then
    echo 0
    return
  fi
  find "$WIKI_DIR" -type f -name '*.md' -print0 2>/dev/null \
    | xargs -0 awk '
        FNR == 1 { state = "pre"; next_is_fm = ($0 == "---") ? 1 : 0 }
        FNR == 1 && $0 == "---" { state = "fm"; next }
        state == "fm" && $0 == "---" { state = "body"; nextfile }
        state == "fm" && match($0, /^address:[[:space:]]+c-[0-9]{6}[[:space:]]*$/) {
          if (match($0, /c-[0-9]{6}/)) {
            print substr($0, RSTART, RLENGTH)
          }
        }
      ' 2>/dev/null \
    | sed 's/^c-0*//;s/^$/0/' \
    | sort -n \
    | tail -1 \
    | awk 'BEGIN{n=0} {n=$0} END{print (n+0)}'
}

read_or_recover_counter() {
  if [ ! -f "$COUNTER_FILE" ]; then
    local max_c
    max_c="$(scan_max_c_address)"
    echo $((max_c + 1)) > "$COUNTER_FILE"
    echo "INFO: counter file missing; recovered from vault scan, set to $((max_c + 1))" >&2
  fi
  local raw
  raw="$(cat "$COUNTER_FILE")"
  if ! [[ "$raw" =~ ^[0-9]+$ ]]; then
    echo "ERR: counter file content is not a positive integer: $raw" >&2
    exit 3
  fi
  echo "$raw"
}

case "$MODE" in
  --peek)
    read_or_recover_counter
    ;;
  --rebuild)
    max_c="$(scan_max_c_address)"
    echo $((max_c + 1)) > "$COUNTER_FILE"
    echo "Counter rebuilt: next = $((max_c + 1))"
    ;;
  allocate|"")
    current="$(read_or_recover_counter)"
    next=$((current + 1))
    echo "$next" > "$COUNTER_FILE"
    printf 'c-%06d\n' "$current"
    ;;
  *)
    echo "ERR: unknown mode: $MODE" >&2
    echo "Usage: $0 [allocate|--peek|--rebuild]" >&2
    exit 3
    ;;
esac
