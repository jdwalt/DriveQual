<!-- SPDX-License-Identifier: Apache-2.0 -->
# DriveQual

**Linux used-drive intake and qualification, release candidate `2.2.0-rc1`.** A deliberately destructive, log-first workflow for a dedicated, isolated qualification workstation. This is a field-tested design undergoing a final release-candidate validation, **not a certified sanitization product or a guarantee of remaining drive life**.

> **DATA LOSS WARNING:** `sudo drivequal /dev/sdX` overwrites the selected **entire physical disk**, starting with a destructive 4 KiB probe. It destroys the existing partition table and files. `sdX` can change between boots or swaps. Never run it on a drive containing data you intend to retain. This tool requires root and assumes you have already decided the entire target may be erased.

## Quick start: installation for beginners

These instructions are for Debian 13 or a compatible Linux system. Install dependencies while connected to the internet. DriveQual can subsequently operate offline.

### 1. Download DriveQual

```bash
sudo apt update
sudo apt install git

git clone https://github.com/jdwalt/DriveQual.git
cd DriveQual
```

### 2. Install dependencies

```bash
sudo apt install smartmontools hdparm jq util-linux \
  coreutils gawk fdisk parted f3 lm-sensors procps systemd
```

The `f3` package is only required for experimental USB-flash testing.

### 3. Test and install

```bash
bash tests/smoke.sh
sudo bash install.sh
drivequal --version
```

Expected version: `drivequal 2.2.0-rc1`.

**Warning:** Installation does not erase any drives. Running `sudo drivequal sdb` begins destructive qualification of the selected physical disk. Identify the correct disk before running it. See the operator workflow below.

## Supported media

| Profile | Current process | Status |
|---|---|---|
| Direct SATA HDD | Security/SMART baseline → 4 KiB write/read probe → SMART long → full zero overwrite → full zero-verified readback → SMART short → SMART delta | Main workflow; v2.2 release candidate |
| Direct SATA SSD | Same, with conservative review for missing or malformed self-test evidence | Main workflow; ONE full overwrite, not repetitive endurance testing |
| Nonrotational USB block device with a reported unique serial/by-id | Identity and block checks → destructive F3 capacity probe → full zero overwrite → full zero-verified readback → available SMART | Experimental; requires `f3`. Cannot reliably distinguish flash sticks from USB-attached SSDs; physically verify the target first. |
| NVMe, rotational USB HDD, RAID/LVM-backed disks, unidentified/ambiguous devices | Refused | Not supported by this release |

USB devices without a reliable unique reported serial and by-id link are deliberately refused. **Warning:** USB bridges can advertise an SSD as nonrotational USB storage; the script cannot reliably differentiate it from a flash stick. Treat the USB profile as experimental and identify the physical device yourself. A physical port path alone cannot prove which piece of flash media is present. Never hot-swap *the drive being qualified*; replacing an unrelated, completed drive after its worker exits is fine.

## Tested environment and prerequisites

Designed around Debian 13 Xfce, with direct SATA targets and a separate USB-attached boot/log SSD. Fully offline **operation** is supported after dependencies are installed. Other Linux distributions and storage topologies have not been qualified.

Install prerequisites while online, using your distribution's package names:

```bash
sudo apt update
sudo apt install smartmontools hdparm jq util-linux coreutils gawk \
  fdisk parted f3 lm-sensors procps systemd
```

`f3` is only needed for the USB-flash profile. On Debian the tools `hwclock` and time syncing may need separately installed packages, but `hwclock` is not required to run DriveQual. Correct the system clock before starting; the operator is prompted to verify it. The monitor attempts `systemd-inhibit` when available; confirm that suspend is disabled for long tests.

The log root is `/drivequal` and must be writable on a drive **other than** every qualification target. A conventional locally mounted block-backed root/log filesystem is required; unsupported exotic root/log storage is rejected. Disable automatic mounting of unknown media in your desktop settings. If you examine files beforehand, do so deliberately on an isolated workstation and unmount all target filesystems before qualifying.

## Install or update

**Finish all existing qualifier jobs first.** Extract this repository and run:

```bash
bash tests/smoke.sh       # non-destructive test: writes temporary regular files only
sudo bash install.sh     # backs up installed commands, then installs

drivequal --version
```

Expected version is `drivequal 2.2.0-rc1`.

The three installed commands are:

- `/usr/local/bin/drivequal` for starting a qualification (requires `sudo`).
- `/usr/local/bin/drivequal-status` for the interactive dashboard (normal user).
- `/usr/local/sbin/drivequal-hostmon` for the shared background monitor (started automatically by the first qualifier).

The installer refuses to replace commands while a `/run/drivequal/state/*.state` entry exists, including stale entries; inspect rather than removing a state file while a job could still be running.

## Operator workflow

After a reboot, especially when changing disks:

```bash
date
lsblk -o NAME,PATH,MODEL,SERIAL,SIZE,ROTA,TRAN,FSTYPE,MOUNTPOINTS
```

Identify the *actual* target by serial, model and capacity. For example, if **this boot** shows the disposable target at `/dev/sdb`:

```bash
sudo drivequal sdb
```

It shows the target and stable identity, prompts for correct time and a source label (`OSUSED` by default), then proceeds without a second destructive confirmation. **The invocation authorizes overwriting the selected disk.** Launch another independent disk in a second terminal, and open:

```bash
drivequal-status
```

The dashboard refreshes every 10 seconds; the host monitor logs once per 60 seconds and quits after the last qualifier exits. The disk workers continue if you close the dashboard. Do not unplug, eject, power off or repartition a device while its worker is active. Keep the workstation awake and on reliable power throughout long runs.

### Result and records

One session directory per drive, with stage-specific evidence:

```text
/drivequal/
  active/                # running or abnormally interrupted
  completed/             # PASS
  review/                # REVIEW
  rejected/              # REJECT
  host-monitor/          # per-batch host and drive CSV + host log
```

Each session includes `baseline/identity.txt`, `baseline/hdparm-I.txt` (SATA), SMART text/JSON, `probe/`, `long-test/`, `zero-write/`, `readback/`, `short-test/`, `final/result.txt`, `final/delta.txt` (where applicable), `session.log`, and `temperature.csv` where supported. Copy finished logs to another machine/backup; the boot SSD alone is **not** a permanent archive. Do **not** publish your own unredacted session logs with this source repository: they include serial numbers, mount names, host information, and sometimes prior partition details.

`PASS` means the implemented tests completed successfully and available monitored health checks met the criteria. `REVIEW` means an advisory or incomplete/ambiguous evidence requires human disposition; it does not necessarily mean a dead drive. `REJECT` means a significant test failure was observed. Historical reallocations are REVIEW even if stable; growth in interface CRC is REVIEW because it may implicate cabling rather than media. No result guarantees future reliability.

### Overwrite versus certified sanitization

The full pass writes zero to **every user-addressable logical byte** and reads it back to compare against zeros. It does **not** prove that remapped sectors, SSD overprovisioned NAND, flash controller spare blocks, hidden areas, or firmware-managed storage were physically purged. Do not describe it as a certified secure erase or use it alone for sensitive-data disposal. Choose an applicable manufacturer/standards-based sanitize, crypto-erase or destruction process for those purposes. See [Security and limitations](docs/SECURITY.md), [review and evidence](docs/RELEASE-REVIEW.md), and [NIST SP 800-88 Rev. 2](https://csrc.nist.gov/pubs/sp/800/88/r2/final).

## Failure handling

- Any failure to verify device identity, mounts, holder relationships, root/log backing, write permission or logs stops the next destructive stage.
- A tiny 4 KiB zero write and read verification runs **before** SATA SMART long, saving time on unwritable drives. It is already destructive; a stopped preflight leaves the original disk partly changed.
- Unexpected termination leaves the session under `/drivequal/active` with an abnormal-termination report when the trap can run. A power loss may leave no such report. **Do not assume an interrupted disk is sanitized or qualified.**
- SMART JSON/status can be incomplete on odd OEM SSD firmware. Explicit failures still stop; ambiguous self-test history creates REVIEW, not an automatic PASS.
- A direct SATA drive reporting enabled/locked ATA Security stops before writing. `frozen` with `not enabled` is not a password lock.

Read the [test plan](docs/TEST-PLAN.md) before treating this candidate as a public stable release. Report problems with *redacted* logs and the script version.

## Attribution, license and contribution

Licensed under the **Apache License, Version 2.0**. See [LICENSE](LICENSE) and [NOTICE](NOTICE). Free use, modification, redistribution and commercial use are permitted subject to the license terms, including preservation of required notices and prominent modification notices.

DriveQual was conceived, directed, tested and refined by Jack Walter. Implementation and documentation were developed with AI assistance using OpenAI's ChatGPT. This attribution does not imply that every generated line is independently copyrightable or that OpenAI endorses this project. See the [third-party review](docs/THIRD-PARTY.md) and [contribution guide](CONTRIBUTING.md).

Do not put drive-test logs, actual serial numbers, private system details, or personal information in the repository. See the [publishing checklist](docs/PUBLISHING.md).
