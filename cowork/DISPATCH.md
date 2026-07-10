# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 001
**Date:** 2026-07-10
**From:** Cowork — scope v2 (BRIEF.md) adoption

## Objective
Turn this scaffolded folder into a git repo, and complete STEP 0a of BRIEF.md: fetch and verify the primary dataset. This is the provenance half of the Step 0 gate; the recovery/separability half (Step 0b) comes in dispatch 002.

## Context
Read `BRIEF.md` (repo root) in full first — it is the authoritative research brief and its from-scratch mandate is binding: no prior scripts, results, or numbers may be reused or consulted; all data fetched fresh; all code written new in this repo. CLAUDE.md carries the working rules.

## Tasks
1. Verify you are in `C:\Dev\paper2` and that it is NOT already a git repo (`git rev-parse --git-dir` should fail). Stop and ask if it is.
2. `git init`. Add `.gitattributes` at repo root containing `* text=auto`.
3. Create `results/` and `manuscript/` directories (with .gitkeep) to complete the BRIEF-aligned structure.
4. `git status` — expect: BRIEF.md, CLAUDE.md, PROGRESS.md, README.md, .gitignore, .gitattributes, cowork/DISPATCH.md, cowork/REPORT.md, and .gitkeep files (data/raw, data/processed, R, analysis, figures, results, manuscript). `_inbox/` must NOT appear (gitignored — if it appears, stop and ask). Anything else unexpected: stop and ask.
5. Commit as: `chore: initial scaffold — brief, two-agent workflow, project structure`
6. STEP 0a — data provenance (write a fresh script, e.g. `analysis/00_fetch_verify.R` or equivalent):
   a. **Do NOT git-clone the full repo on this Windows machine.** The repo contains TWO files differing only in filename case (`metacognition_TrialData_master.csv` — WRONG file, md5 653437023bcee998481bc33a77fd2729, 11,451,520 bytes — vs `metacognition_trialData_master.csv` — CORRECT file), and a full clone on case-insensitive NTFS will collide them, leaving you with an arbitrary one. Instead download the two needed files directly at the PINNED commit (raw URLs are case-sensitive, so this is safe):
      - https://raw.githubusercontent.com/embodied-computation-group/dg-metacognition/0c38aba4eb720a143d126b7c7d4c313a900bc536/data_summary/metacognition_trialData_master.csv
      - https://raw.githubusercontent.com/embodied-computation-group/dg-metacognition/0c38aba4eb720a143d126b7c7d4c313a900bc536/data_summary/mle_fit_data_wide.csv
      Record the pinned commit (0c38aba4eb720a143d126b7c7d4c313a900bc536, 2024-06-28; verified as current HEAD on 2026-07-10).
   b. Compute md5 of the trial CSV. Expected: `500b2e6e1eb0e47e717feba5b912ad9f` (11,837,935 bytes). If it differs — especially if it is 653437... — you fetched the wrong-case file; stop and fix. If it differs for any other reason, verify the structure below still holds and REPORT the discrepancy prominently; if structure also differs, STOP.
   c. Verify structure from the raw file (expected values independently re-verified by Cowork on 2026-07-10): 193,200 rows; 322 subjects; four modalities (memory, Calories, GDP, vision); confidence integers 1–7; median trials per subject ≈200 for memory and vision but ≈100 for Calories and GDP (the trivia tasks — do NOT treat ~100 as a mismatch); 11 columns: subject, modality, trial, signal, response, accuracy, confidence, rt, rt_conf, contrast, repeat_exclude. Report actual counts, not the expected ones.
   d. Reproduce ONE basic summary with your own code — use per-domain MEAN CONFIDENCE and per-domain mean accuracy — and compare against the shipped `mle_fit_data_wide.csv` (`avg_conf_*` columns) as an EXTERNAL cross-check only. Expect close agreement on mean confidence (within ~0.05; their file has 320 subjects vs 322 raw — two exclusions — and uses per-subject means). CAUTION: do NOT expect a simple equal-variance d′ to match their `da_*` columns numerically — their "da" is a different SDT quantity and runs ~0.2 LOWER than naive d′; compare only the rank-order of domains for d′-like measures. A numeric d′ mismatch is a known definitional difference, NOT a data problem. Save your computed table to `results/step0a_basic_summary.csv`.
   e. Store the raw CSVs under `data/raw/lund2025/` (the trial CSV is ~11.8 MB: gitignore it, and commit a `data/raw/lund2025/README.md` recording URLs, pinned commit hash, md5s, sizes, and fetch date; the small mle_fit_data_wide.csv may be committed).
7. Commit Step 0a work as: `feat: step 0a — fetch and verify Lund 2025 trial data`
8. OPTIONAL — only if Ben provides a GitHub remote URL when he runs this dispatch: `git remote add origin <url>` then `git push -u origin master` (retry up to 4x with backoff on network errors). If no URL is given, skip and mark as skipped in the report.
9. Report per protocol: overwrite `cowork/REPORT.md` (include the md5 result, actual structure counts, and the basic-summary comparison), append a session-log line to `PROGRESS.md`, final `docs:` commit.

## Constraints
- FROM-SCRATCH MANDATE: do not download, open, or consult anything from the old project (no metacog_newmachine.zip, no old scripts/results), and nothing from `_inbox/` enters the analysis.
- Do NOT proceed to Step 0b (recovery/separability simulations) or any later step — that is dispatch 002, designed by Cowork first.
- Do not touch `C:\Dev\cogsci`.
- No numbers in the report that your own code did not just compute.

## Acceptance criteria
- `git status` clean after final commit; `_inbox/` and the raw CSV untracked/ignored; provenance README committed.
- md5 + structure verification results stated explicitly in REPORT.md (match or mismatch, with actual values).
- `results/step0a_basic_summary.csv` exists and is committed.
- REPORT.md filled per template.
