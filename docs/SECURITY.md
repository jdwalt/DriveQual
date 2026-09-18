<!-- SPDX-License-Identifier: Apache-2.0 -->
# Safety, security and technical limitations

**DriveQual destroys data.** A command targets a WHOLE physical block device, not a partition. The first 4 KiB test write is destructive, even if later SMART testing or a long write never starts. The USB F3 probe is also destructive. A disk that was interrupted or failed is not certified sanitized or qualified.

The main safeguard is independent boot/log storage, identifying a target from a fresh `lsblk` map, rejecting the mounted system drive and its descendants, checking holders for RAID/LVM use, binding to stable by-id and rechecking device path/model/serial/size/mount and block-backed root/log location before writes. These checks reduce operator error; they cannot prevent every race, deliberately misleading hardware identifier, firmware defect or administrator override. No special support for mdraid, LVM, multipath, USB bridges without unique IDs, NVMe or rotational USB HDD is claimed. Nonrotational USB media are experimental and may be flash sticks or USB-attached SSDs; the interface does not reliably differentiate them. Inspect the actual hardware before invoking the destructive profile.

## Sanitization terminology

A complete logical overwrite and zero-verifying readback is not the same as manufacturer ATA Secure Erase, NVMe sanitize, cryptographic erase or physical destruction. Even a successful test cannot inspect inaccessible remapped sectors or controller-managed flash blocks. NIST SP 800-88 Rev. 2 warns that ordinary overwrite is inadequate for flash spare cells/wear levelling and should not be treated as a stronger purge method. Select the appropriate technique for data sensitivity and media, independently of this qualification tool: https://csrc.nist.gov/pubs/sp/800/88/r2/final

## Health assessment terminology

SMART attributes are vendor-specific. Some raw numbers are not sector counts, and SMART status PASS is not a lifetime guarantee. Historical stable reallocations create REVIEW rather than automatic REJECT; a rise during a test produces a more severe result. CRC growth merits cable/path investigation. Partial or malformed SMART histories must never be silently represented as proof of passing a self-test. The tool does not validate all vendor attributes or every possible kernel I/O error.

## Isolation and privacy

A salvaged disk may contain sensitive or malicious data. Run offline or isolated and disable automount; inspect files only when necessary and intentionally. The tool does not mount target filesystems or send logs to any network service. Session evidence can contain serials, previous partition labels and host names. Do not commit `/drivequal` content, archives, photos of labels or other private infrastructure information to a public repository. Back up your logs separately.

## Maintenance policy

Do not edit installed scripts while drives are being qualified. Save a known-working version before upgrading, run the non-destructive smoke suite, and validate each release candidate on expendable media first. If the host loses power, the script may not be able to close its logs, remove runtime state or attest to a complete overwrite. Treat the drive as incomplete and review the last confirmed stage.
