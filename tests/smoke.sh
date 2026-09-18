#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# No root, no block device writes. Tests temporary REGULAR FILES only.
set -euo pipefail
base="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
for f in drivequal drivequal-hostmon drivequal-status install.sh; do
    bash -n "$base/$f"
done
[[ "$(bash "$base/drivequal" --version)" == 'drivequal 2.2.0-rc1' ]]
bash "$base/drivequal" --help | grep -q 'destructive qualification'

# Original regression: PIPESTATUS must be captured in a *single* assignment.
bash -c 'set -uo pipefail; (exit 7) | (exit 0); r=("${PIPESTATUS[@]}"); (( ${#r[@]} == 2 && r[0] == 7 && r[1] == 0 ))'

work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT
# All dd output targets here are disposable regular files under $work.
head -c 12345 /dev/urandom > "$work/regular-file"
bytes="$(wc -c < "$work/regular-file")"
dd if=/dev/zero of="$work/regular-file" bs=4096 count="$bytes" iflag=count_bytes conv=fsync status=none
[[ "$(wc -c < "$work/regular-file")" -eq "$bytes" ]]
if ! cmp -n "$bytes" "$work/regular-file" /dev/zero >/dev/null; then
    echo 'FAIL: all-zero regular-file verification did not pass' >&2
    exit 1
fi
printf '\001' | dd of="$work/regular-file" bs=1 seek=8000 conv=notrunc status=none
if cmp -n "$bytes" "$work/regular-file" /dev/zero >/dev/null; then
    echo 'FAIL: intentionally corrupted regular file was not detected' >&2
    exit 1
fi

if command -v shellcheck >/dev/null 2>&1; then
    # ShellCheck advisory: its exit code is not a syntax safety test.
    echo 'ShellCheck installed; running advisory analysis...'
    shellcheck -S warning "$base/drivequal" "$base/drivequal-hostmon" "$base/drivequal-status" "$base/install.sh" || true
fi
# Repository licensing/package sanity; does not establish third-party provenance.
for f in LICENSE NOTICE docs/THIRD-PARTY.md CONTRIBUTING.md; do
    [[ -s "$base/$f" ]] || { echo "FAIL: missing or empty $f" >&2; exit 1; }
done
grep -q 'Apache License' "$base/LICENSE"
grep -q 'Version 2.0, January 2004' "$base/LICENSE"
for f in drivequal drivequal-hostmon drivequal-status install.sh tests/smoke.sh; do
    grep -q '^# SPDX-License-Identifier: Apache-2.0$' "$base/$f" || {
        echo "FAIL: missing SPDX header in $f" >&2; exit 1;
    }
done
printf 'PASS: Bash syntax, version/help, PIPESTATUS regression, regular-file verification and packaging checks.\n' 
printf 'NOT tested: real devices, boot protection, SMART, USB, temperature, or long-duration execution.\n'
