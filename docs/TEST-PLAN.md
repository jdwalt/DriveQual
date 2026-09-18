<!-- SPDX-License-Identifier: Apache-2.0 -->
# Release candidate validation plan

All tests involving real block devices must use **explicitly disposable media** on a dedicated bench. The shipped `tests/smoke.sh` checks syntax, CLI basics, the pipeline-status regression, exact-count logical overwrite and zero-verification on ordinary temporary files. It does NOT exercise physical drive safety, ATA security, SMART device behavior, USB capacity fraud, multiday execution, unplug/disconnect handling or firmware variations.

## Before a real-media qualification

1. Confirm correct date/time after full power removal and CMOS replacement; note timezone.
2. Confirm boot SSD is separate; run fresh `lsblk` showing model, serial, size, transport and mountpoints.
3. Confirm desktop automount is off; remove/unmount any volume before beginning.
4. Save previous installed scripts; confirm `drivequal --version` reports `2.2.0-rc1` and `bash tests/smoke.sh` passes.
5. Verify `/drivequal` is mounted/writable on storage that is NOT the target, and archive prior results externally.

## Physical-device checks (not yet complete for v2.2.0-rc1)

| Case | Expected result | Record |
|---|---|---|
| Try to select boot disk | REFUSING before any write | terminal and serial redacted |
| Start twice against one target | second run refuses duplicate, first continues | terminal |
| SATA HDD known clean | preflight, SMART long, exact full write, zero-verified full readback, short SMART, final PASS | session folder |
| SATA HDD with historical reallocation | stable history → REVIEW, no new media errors | baseline/final delta |
| SATA HDD with historic CRC | stable old CRC → no CRC escalation; growth → REVIEW | delta, cabling notes |
| Direct SATA SSD | one full logical write/read; SMART anomalies lead REVIEW, not misleading PASS | session and NAND wear values if available |
| Nonrotational USB device with reliable serial | Verify physical medium; F3 probe then verified overwrite; no mandatory SMART | session |
| USB flash with absent/non-unique serial | refuse prior to destructive work | terminal |
| USB rotational or NVMe target | explicit unsupported/refusal | terminal |
| A mounted partition or md/LVM holder | refuse before testing/writing | terminal |
| Unwritable spare disk | stop at read-only/probe gate, not after hours of SMART long | result |
| Interrupt spare-drive test | loud abnormal termination, session remains `active` | interruption log |
| Concurrent SATA jobs | independent logs; one monitor; dashboard stable refresh | 3 sessions + host log |
| SSD finishes while HDD works | completed worker disappears; host monitor remains | host log and status |
| Last worker finishes | host monitor records END and exits | host log |

**Stop on the first surprise.** Compare the actual last stage, result, exact byte counts and SMART before/after. Do not count a run successful simply because its shell exited zero. Do not test the interrupt/identity edge cases on drives containing irreplaceable data.

Before creating a stable GitHub release, capture hardware-tested evidence for at least SATA HDD, SATA SSD, USB flash (if advertising USB support), boot protection, duplicate protection and clean monitor shutdown; then update this document with dated results. Do not publish the actual drive serials.
