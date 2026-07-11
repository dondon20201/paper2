# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 009
**Date:** 2026-07-10
**From:** Cowork — 008 AUDITED AND CONFIRMED (gate scoreboard re-derived exactly; real-data ICCs independently reproduced by MoM to ≤0.007: 0.4433/0.3309 vs LMM 0.4427/0.3373; both ipsative exhibits reproduced to 4 decimals; figure CSVs match committed sources value-for-value; push verified local=origin=c4da7b0). Step 4 is in the can. This dispatch is **Step 5a: CONFIDENCE DATABASE — FETCH, PROVENANCE, AND PREREGISTERED STUDY SELECTION.** It is the external dataset's own Step-0-style gate: NO level-vs-sensitivity contrast is computed in this dispatch — that is dispatch 010, preregistered after we can see what survives selection. Same two-stage firewall logic that protected 006.

## Objective
(A) Fetch the Confidence Database (Rahnev et al. 2020, osf.io/s46pr) from its official OSF source and establish provenance (manifest of md5s + sizes, committed; raw data itself stays OUT of git). (B) Build a complete structural inventory of every study file — including explicit records of files that fail to parse. (C) Apply the preregistered selection criteria below MECHANICALLY to produce the candidate multi-task study list for Step 5. (D) For SELECTED studies only: per subject-task measurement summaries and split-half reliabilities — the inputs Cowork needs to preregister the 010 contrast. HARD FIREWALL: no cross-task correlation, covariance, or gap of any kind anywhere in this dispatch.

## Preregistered decisions (fixed now — argue in the report if one looks wrong; do not change it)

### Part A — fetch + provenance (`analysis/11_confdb_fetch.R` or .R + helper script; Code's choice of download mechanics, documented)
- Source: the OSF project osf.io/s46pr ONLY (Rahnev et al. 2020, Nat Hum Behav 4:317–325). Record the exact download URLs/API calls and access date in the manifest. If OSF offers a versioned/registered snapshot, prefer it and record the version.
- Raw files land in `data/raw/confidence_db/` — **gitignored** (~244 MB; the .gitignore entry is part of this dispatch). What IS committed: `results/step11_CONFDB_manifest.csv` — one row per downloaded file: filename, bytes, md5, download timestamp, source URL.
- Also fetch the database's study-information/metadata sheet if present; it is an input to the inventory, never a substitute for verifying the files themselves.
- If the download is partial (some files 404/timeout): retry twice, then record the misses explicitly in the manifest with status=MISSING and proceed — a complete accounting of an incomplete download is acceptable; a silent gap is not.

### Part B — structural inventory (`analysis/12_confdb_inventory.R`)
- Parse EVERY study CSV defensively. Per study file, record into `results/step11_CONFDB_inventory.csv`: filename; parse status (OK / FAILED with reason); n rows; columns present (against the CD's documented standard: Subj_idx, Stimulus, Response, Confidence, RT_dec, RT_conf, Task, Training, etc.); n subjects; whether a Task/task-like column with ≥2 distinct values within subjects exists; per-task trial counts (min/median/max per subject); confidence scale as OBSERVED (n distinct values, min, max, integer vs continuous); whether trial-level accuracy is present or derivable (Stimulus vs Response comparable); % missing confidence; training-trial flags present y/n.
- Parse failures and oddball formats are RECORDED, not silently repaired. If a file needs a bespoke fix to parse, the fix is described in the inventory row.
- No measurement statistics in Part B beyond structure (no AUROC2, no reliabilities, nothing about how good anyone's metacognition is).

### Part C — mechanical selection (`analysis/12_confdb_inventory.R`, same script, separate output)
Selection criteria, applied as literal filters to inventory fields — no judgment calls, no peeking at anything downstream of structure. A study is SELECTED iff ALL of:
1. **S1 multi-task within-subject:** the study has ≥2 distinct tasks and ≥40 subjects who each have ≥60 clean trials (non-training, non-missing confidence, accuracy derivable) in EACH of at least 2 tasks. (Rationale on file: 40×2 is the floor where a correlation CI is even interpretable; 60 trials is below Lund's 100–200 and will show in reliability — that is priced in by design and reported, not hidden.)
2. **S2 usable confidence:** ≥3 distinct observed confidence values per qualifying task (binary confidence cannot support AUROC2 meaningfully).
3. **S3 objective accuracy:** trial-level correctness present or derivable from Stimulus/Response for every qualifying task.
4. **S4 not maintainer-flagged:** if the CD metadata flags a study as problematic/excluded, it is out (record the flag verbatim; if no flag system exists, S4 auto-passes and the report says so).
- Output `results/step11_CONFDB_selection.csv`: one row per study, each criterion's pass/fail with the numbers that decided it, and the final SELECTED flag. Borderline is not a category — the numbers decide. If the criteria select zero or very few studies, that is a reportable outcome; do NOT loosen criteria in-flight (Cowork re-preregisters any loosening in a future dispatch, in writing, before it runs).

### Part D — measurement pass on SELECTED studies only (`analysis/13_confdb_measures.R`)
- Cleaning per preregistration: drop training trials where flagged; drop missing-confidence trials; accuracy from Stimulus/Response equality unless the study documents otherwise (document per study).
- Per subject-task: n trials, mean accuracy, LEVEL = mean confidence normalized to [0,1] by the study's own observed scale range (record the normalization per study), raw AUROC2 (no d′-partialing here — d′-hats and any partialing get preregistered in 010 where the estimator is chosen), and a same-task d′-hat for later use.
- Per task: split-half (odd/even trial) reliability, Spearman-Brown corrected, with subject-bootstrap CIs (B=500), for LEVEL and AUROC2. Save all to `results/step11_CONFDB_measures.csv` and `results/step11_CONFDB_reliability.csv`.
- **FIREWALL (binding, as in 005): no cross-task quantity of any kind.** No correlation, covariance, regression, or difference between tasks' measures, per study or pooled. The measures CSV is one row per subject×task with no cross-task columns. The report must state the firewall held, and the scripts must be organized so an auditor can verify it by reading them (as in 005).

### Part E — housekeeping
1. `.gitignore` entry for `data/raw/confidence_db/`; confirm no raw CD file is staged (`git status` proof in report).
2. Update PROGRESS.md; overwrite `cowork/REPORT.md` per protocol (include: download stats, parse-failure count, selection funnel counts — N files → N parsed → N multi-task → N selected — and the reliability headlines for selected studies); session-log line; final `docs:` commit; push; HEAD hash in the report.
3. Remind Ben `renv::snapshot()` if any package was added.

## Constraints
- Every reported number computed this run from the verified files, labeled REALDATA-EXTERNAL (CONFDB) + status per BRIEF §3, saved under results/.
- Selection is mechanical; the criteria above are frozen. Zero-selected is a valid outcome.
- The firewall is absolute: any cross-task statistic in this dispatch is a protocol violation, even "just to take a look."
- If OSF is unreachable or the download infeasible on Dondon, STOP and report — do not source the data from mirrors, papers, or memory.

## Acceptance criteria
- Manifest CSV committed with md5s for every obtained file and explicit MISSING rows for any gaps; raw data absent from git (`git status` clean with data/raw/confidence_db/ ignored).
- Inventory CSV covers every downloaded file (parse failures explicit). Selection CSV shows per-criterion numbers and mechanical SELECTED flags; funnel counts in the report.
- Measures + reliability CSVs exist for selected studies only, one row per subject×task / per task; NO cross-task quantities anywhere (auditable in scripts).
- PROGRESS.md updated; report complete; push confirmed with HEAD hash.
