<!-- SPDX-License-Identifier: Apache-2.0 -->
# Third-party code and licensing review

Review date: 2026-09-18. Scope: the **files in this source repository**, not the
operating system or historical logs. A static inventory and attribution scan is
not a guarantee that every line is original or that all output is copyrightable.

## Included material

- Project Bash programs, install script, tests, Markdown documents and workflow
  YAML: developed for DriveQual with AI assistance, with human direction, tests,
  editorial selection and revisions. No externally sourced code was identified
  as copied into these files during the repository review.
- `LICENSE`: unmodified text of the Apache License, Version 2.0 (the standard
  public license text; it is not original DriveQual source code).
- `NOTICE`: project attribution and provenance disclosure.
- No vendored binaries, downloaded libraries, embedded third-party modules,
  photographs, disk logs or sample SMART captures are distributed here.

## External tools invoked or used for building

DriveQual invokes separately installed programs rather than bundling or copying
their code. Runtime requirements include Bash; Linux/udev and core system tools
such as `lsblk`, `blockdev`, `findmnt`, `flock`, `dd`, `cmp`, `tee`, `sha256sum`,
`awk`, `sed`, `grep`, `partprobe`, `fdisk`, `wipefs` and `udevadm`; `smartctl`
(smartmontools); `hdparm`; `jq`; and, for the experimental USB profile, `f3probe`
(f3). The host monitor/dashboard use tools such as `sensors`, `vmstat`, `free`,
`ps`, `df`, `journalctl` and `systemd-inhibit` where available. These programs
are installed independently from the user's distribution, each with its own
copyright and license. The Apache-2.0 grant for DriveQual does **not** relicense
these external programs; distributors who bundle dependencies must review the
actual packaged versions and their license obligations.

The GitHub Actions workflow references `actions/checkout@v4`, a third-party
GitHub Action distributed under the MIT license (copyright GitHub, Inc. and
contributors). The action is retrieved for CI and is **not copied into this
repository**. Upstream license: <https://github.com/actions/checkout/blob/v4/LICENSE>.

The README cites external technical guidance and documentation, such as NIST.
A link and brief technical paraphrase do not incorporate the source document's
text into DriveQual's source distribution.

## Review performed / limitations

- Enumerated source package files, confirmed they are text, scanned for other
  copyright/license headers, license blocks, third-party code markers, URLs,
  package downloads, sensitive identifiers and vendored binaries.
- Identified the workflow action's upstream MIT license.
- Found **no identifiable embedded third-party implementation** requiring an
  additional license copy or preserved third-party attribution in this package.
- This is a source/provenance review, **not** a definitive originality search,
  infringement clearance, or legal opinion. Any future copied snippet or
  bundled dependency must be reviewed before merging, keeping its license and
  notices intact. Contributors should identify third-party provenance in PRs.
