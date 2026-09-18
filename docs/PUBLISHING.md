<!-- SPDX-License-Identifier: Apache-2.0 -->
# GitHub publishing checklist

1. License selected: **Apache License 2.0**. Ship the unmodified top-level `LICENSE` plus `NOTICE`; keep SPDX source headers. See `docs/THIRD-PARTY.md` for the repository-scope dependency review.
2. Maintain a **private repository** until release-candidate physical tests are complete. Do not mark the project stable or create a public GitHub release before recording results in `docs/TEST-PLAN.md`.
3. Owner/repository has been created as `jdwalt/DriveQual`. Keep public/private visibility unchanged without explicit owner approval.
4. Review `git status` and `git diff --cached` carefully. Do not commit logs, serials, private system details, screenshots of disks, `/drivequal` data or historical tarballs. `.gitignore` is not a security control by itself.
5. Commit and push the reviewed **source files**. Check that GitHub shows all expected paths, license detection and the CI smoke-test status. GitHub Actions is limited to non-destructive regular-file tests.
6. Before a public stable release, complete the tests in `docs/TEST-PLAN.md`, including SATA HDD/SSD, boot/refusal safety and monitor lifecycle. Keep USB support clearly experimental until independently validated.
7. Later tags and release notes must state that all operations are destructive and that logical zero verification is not a certified secure purge of SSD/flash memory.
