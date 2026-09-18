<!-- SPDX-License-Identifier: Apache-2.0 -->
# Contributing to DriveQual

DriveQual overwrites whole physical drives. Please propose safety-related changes
with a clear explanation of their failure modes and tests. Do not submit code
that silently relaxes boot-drive, mount, holder, identity or logging protection.

Before opening a pull request:

1. Run `bash tests/smoke.sh` (it touches only temporary regular files).
2. Describe whether you physically tested the change; never imply a disk was
   tested when you only ran syntax or simulated checks.
3. Include sanitized evidence and a reproducible scenario where practical.
   **Never** submit real serial numbers, unredacted SMART logs, credentials or
   unknown-media contents. Redact before attaching anything.
4. Identify any source or inspiration for copied code and preserve third-party
   notices/licenses. Do not paste code of uncertain provenance.
5. State meaningful AI assistance when relevant. Do not claim copyright in
   material you do not have rights to license.
6. Explain compatibility implications for direct SATA HDD/SSD and the
   experimental USB profile. Disposition labels are not reliability guarantees.

Unless explicitly stated otherwise, an intentional contribution submitted for
inclusion in DriveQual is offered under the repository's Apache License 2.0,
subject to Section 5 of that license. Contributors retain rights in their own
contributions. There is no additional contributor license agreement.
