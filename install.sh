#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
set -euo pipefail

if (( EUID != 0 )); then
    echo 'Run: sudo bash install.sh' >&2
    exit 1
fi
BASE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
for f in drivequal drivequal-status drivequal-hostmon; do
    [[ -f "$BASE/$f" ]] || { echo "Missing: $BASE/$f" >&2; exit 1; }
    bash -n "$BASE/$f"
done

shopt -s nullglob
states=(/run/drivequal/state/*.state)
if ((${#states[@]})); then
    echo 'REFUSING: qualifier runtime state exists; do not update during a run.' >&2
    printf '  %s\n' "${states[@]}" >&2
    echo 'Finish jobs and investigate stale states before installing.' >&2
    exit 2
fi

stamp="$(date +%Y%m%dT%H%M%S)"
mkdir -p /usr/local/bin /usr/local/sbin /usr/local/share/drivequal-backups
backup="/usr/local/share/drivequal-backups/$stamp"
mkdir -p "$backup"
for f in drivequal drivequal-status; do
    [[ -e "/usr/local/bin/$f" ]] && cp -a "/usr/local/bin/$f" "$backup/$f" || true
done
[[ -e /usr/local/sbin/drivequal-hostmon ]] && cp -a /usr/local/sbin/drivequal-hostmon "$backup/drivequal-hostmon" || true

install -m 0755 "$BASE/drivequal-hostmon" /usr/local/sbin/drivequal-hostmon
install -m 0755 "$BASE/drivequal" /usr/local/bin/drivequal
install -m 0755 "$BASE/drivequal-status" /usr/local/bin/drivequal-status
printf 'Installed %s\n' "$(/usr/local/bin/drivequal --version)"
printf 'Previous command backups (if any): %s\n' "$backup"
echo 'Next: run a fresh lsblk map and test on one expendable drive.'
