<!-- SPDX-License-Identifier: Apache-2.0 -->
# Changelog

## 2.2.0-rc1 (2026-09-18, release candidate)

- Chose Apache License 2.0, added `LICENSE`/`NOTICE`, SPDX headers and dependency/provenance review.
- Clarified that nonrotational USB media detection cannot distinguish flash sticks from USB-attached SSDs; USB profile remains experimental.

- Consolidates the field-developed worker, automatic shared monitor and live dashboard into one repository.
- Allows only directly attached SATA HDD/SSD and serial-identified USB flash. Refuses unknown/unsupported profiles including NVMe, USB HDD, dm/RAID holders and missing USB identity.
- Adds a rechecked, fail-closed gate for mounts, holders and boot/log backing before each critical stage, and a block read-only check before USB probing.
- Uses unique session directories to avoid log collisions after date/time resets.
- Preserves and records smartctl bitmask exit codes; health ambiguity on direct SATA is REVIEW, not PASS.
- Terminology corrected: verified logical overwrite is **not** certified secure erasure, especially for SSD/flash.
- Includes conservative installer, safety docs, a release-candidate hardware test plan and non-destructive smoke tests.

## 2.1.1 (field prototype)

- Fixed lost `PIPESTATUS` after a completed 1 TB zero write and in the USB probe path.
- Added 4 KiB destructive write/read preflight before the long test.
- Dashboard gathers host measurements before screen redraw.

## 2.1 (field prototype)

- Independent per-drive state, temperature logs, shared compact host monitor and status dashboard.
- Full zero-verifying readback and SMART delta classifications.
- SSD firmware advisory behavior for incomplete SMART self-test history.

## Early development

- Successfully qualified concurrent HDDs and SSDs; identified historical stable reallocation as REVIEW and historical stable CRC as non-growing evidence.
- Identified limitations of pre-write-only temperature logging, noisy host logs, clock drift and accidental live script updates.
