<!-- SPDX-License-Identifier: Apache-2.0 -->
# Pre-publication review | 2026-09-18

## Confirmed field lessons carried forward

- Separate independent workers permit mixed-capacity disks and rapid turnover of smaller SSDs while larger HDDs run for hours.
- Device letters change on reboot. A fresh map, stable by-id binding, multiple identity checks, boot/mount exclusion and one active lock per target are essential.
- The time prompt stays even when connected; an incorrect system clock previously misfiled sessions under an old date.
- SMART long before full write preserves evidence of incoming unreadable sectors, but a 4 KiB *destructive* probe first avoids wasting a long test on an unwritable target.
- `hdparm -I` ATA Security `frozen` is not a password lock when `not enabled` and `not locked` are also reported.
- Historical stable CRC counts are not proof of new defects; growing CRC warrants cable/path review. Stable historical reallocation is REVIEW.
- SSD firmware can return inconsistent self-test history; unsupported/ambiguous evidence must be explicit REVIEW, not a false PASS.
- A previous prototype wrote two full 1 TB drives successfully and then exited on sequential Bash `PIPESTATUS` assignments. The status array must be copied in **one** assignment. Completed writing alone is not completed qualification.
- Per-drive temperatures need stage context across long/write/read/short; the host logger should sample compactly at 60 seconds and stop when the last worker exits.
- A dashboard that clears the screen before a blocking `vmstat` call blinks; the next frame should be gathered before clearing.
- A lower-RPM fan with an overly restrictive shroud performed worse than open airflow. Cooling should be measured, not inferred from shroud appearance.

## Changes made in this repository

- Version-consistent worker, host logger, and status dashboard.
- README, security limitations, installation safety and release-candidate hardware test plan.
- Explicitly supported transport policy; unsupported storage topologies refuse rather than quietly skipping tests.
- No by-path fallback for an unidentified replacement device. A USB device needs serial-backed by-id identity and unique reported serial among attached USB disks.
- Mounted descendants and active kernel holders protected; mounted boot and log backing rechecked before critical stages; read-only check extends to USB before F3's destructive probe.
- Unique session creation prevents collisions during fast launches or an incorrect clock.
- Explicit capture of SMART exit-status bitmasks (including checksum caveats, current prefailure and historical error/self-test flags), with conservative REVIEW/REJECT behavior.
- Conservative SMART test polling watchdogs and clearer terminology about logical overwrite versus flash purge.
- Repository `.gitignore`, non-destructive file-only regression suite and GitHub CI skeleton.

## 2026-09-18 license/provenance pass

- Owner selected Apache License 2.0. Added the full unmodified license,
  project NOTICE, short SPDX headers, contribution guidance, and a bounded
  third-party inventory in `docs/THIRD-PARTY.md`.
- Static file/provenance scan found no identifiable copied third-party code or
  vendored libraries/binaries. Runtime programs are separate installations;
  `actions/checkout@v4` is MIT-licensed and pulled by CI rather than bundled.
- Fixed a documentation mismatch: nonrotational USB detection cannot reliably
  tell USB flash sticks from USB-attached SSDs; USB support stays experimental.
- No external originality database or legal opinion was obtained; contributors
  must declare and preserve provenance for future copied snippets.

## Validation performed here

- Bash parser checks for all three tools and installer.
- Non-root CLI version/help check.
- Bash pipeline regression reproducing the old `PIPESTATUS` failure mode and testing the one-assignment fix.
- Exact-length zero write and zero-read comparison using a temporary *ordinary file*, plus deliberately corrupted-byte detection.
- Archive/package structure review and scan to keep prior real drive logs and serial numbers out of the new repository.

**Not performed here:** writing to or even opening a real disk, boot-device safety exercising on the actual OptiPlex, validating USB serial/fraud behavior, confirming SMART long/short watchdogs on hardware, or proving full-batch host-monitor shutdown. This is a release candidate, not a signed-off stable public release. Complete `docs/TEST-PLAN.md` before tagging stable.

## Publication hold points

1. Validate on one already-sanitized direct-SATA HDD or SSD before a multidevice batch.
2. Verify a boot-disk refusal and an active-duplicate refusal.
3. Verify concurrent worker completion and automatic host monitor END; test USB on disposable flash separately if that profile will be advertised.
4. Apache License 2.0 chosen; `LICENSE`, `NOTICE`, SPDX identifiers and the third-party audit added.
5. Review `git status` for private logs and identifiers, then create/push the repository.
