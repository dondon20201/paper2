# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 002
**Date:** 2026-07-10
**From:** Cowork — Step 0a graded PASS (independently cross-checked); proceeding to Step 0b

## Objective
Complete the Step 0 gate: build and run the recovery/separability simulation (BRIEF.md Step 0b), then produce the standalone STEP 0 REPORT combining 0a + 0b for Ben to judge before any real-data analysis. Plus small housekeeping (renv, optional remote).

## Context
Dispatch 001 passed: data provenance VERIFIED, and Cowork independently reproduced your structure counts and per-domain means in a separate environment with separate code — the numbers agree to ~0.01. Your avg_conf offset finding (~0.02–0.06, undocumented upstream preprocessing) is accepted as an external-pipeline difference; carry it as a provenance footnote. Answers to your questions: yes, renv init goes in this dispatch (task 1); remote push is task 5 if Ben supplies a URL; mle md5 pinning as you recorded it is fine.

## Tasks

1. HOUSEKEEPING: initialize renv and snapshot after installing whatever packages this dispatch needs. Commit the lockfile.

2. STEP 0b — recovery & separability simulation (`analysis/01_recovery_separability.R`, all new code; simulation only, unmistakably labeled as such in every output):

   **Design (requirements, not a straitjacket — improve freely but meet every gate):**
   a. Build a generative simulator where each simulated subject has TWO independent planted traits per domain: a confidence LEVEL/set-point (shifts where confidence lands on the 1–7 scale, independent of accuracy) and a metacognitive SENSITIVITY (how strongly confidence tracks trial-level correctness). An SDT-style construction is natural (trial evidence → accuracy; confidence from evidence magnitude scaled by sensitivity, shifted by set-point, cut into 1–7 by fixed thresholds), but the requirement is functional: the two knobs must be mechanistically separate in the generator.
   b. SIMULATOR SELF-CHECK before any recovery claim (the lesson from the old project's buggy simulator): holding sensitivity fixed while varying planted level must move generated mean confidence monotonically while leaving generated accuracy and (approximately) generated AUROC2 flat; and vice versa (varying sensitivity moves AUROC2, not mean confidence — if your construction couples them, quantify and report the coupling). Also confirm generated accuracy matches its target. Save this check's numbers.
   c. Match the real data's scale: 322 subjects, conf 1–7, and run recovery at BOTH ~200 trials (memory/vision) and ~100 trials (Calories/GDP).
   d. RECOVERY: estimate each subject's level (mean confidence) and sensitivity (AUROC2 AND gamma) from the simulated trials; correlate estimated vs planted across subjects. Bootstrap CIs on every recovery correlation. PREREGISTERED PASS CRITERIA: level recovery r ≥ 0.9 at both trial counts; sensitivity recovery r ≥ 0.7 at 200 trials (report the 100-trial value with CI whatever it is — if it is much lower, that is the trial-limitation finding, not a failure).
   e. SEPARABILITY / LEAKAGE (the decisive check): correlation between ESTIMATED level and PLANTED sensitivity, and between ESTIMATED sensitivity and PLANTED level (traits planted independently). PASS: |r| < 0.10 with CI covering 0 for both directions at 200 trials. If leakage exceeds this, the components are not cleanly separable with these estimators → per BRIEF.md, STOP after reporting; do not proceed to Step 1.
   f. THESIS-DETECTABILITY scenario: simulate a population where planted LEVEL correlates across two domains at rho = 0.6 while planted SENSITIVITY correlates at rho = 0.2 (both at realistic trial counts). Verify the estimated cross-domain correlations recover the gap (level-correlation estimate > sensitivity-correlation estimate, each within its bootstrap CI of truth). Also run the null scenario (both rho = 0.4, no gap) and confirm no spurious gap appears. This proves the Step 3 design can detect — and does not invent — the thesis pattern.
   g. Fixed, reported seeds; sensitivity of conclusions spot-checked on a second seed. Save all outputs to `results/step0b_*.csv/json`.

3. STEP 0 REPORT: write `results/STEP0_REPORT.md` — standalone, readable by Ben — combining: 0a provenance verdict (from dispatch 001), the simulator self-check, recovery results with CIs, separability/leakage results, thesis-detectability results, and an explicit overall verdict: GATE PASSED / GATE FAILED (+ what failing means). Every number labeled per the claim rules. Commit it.

4. Update `PROGRESS.md` next-steps per your outcome.

5. OPTIONAL — only if Ben provides a GitHub remote URL at run time: add remote, push all commits (retry 4x with backoff). Otherwise skip and note.

6. Report per protocol: overwrite `cowork/REPORT.md`, append session-log line to `PROGRESS.md`, final `docs:` commit.

## Constraints
- NO real-data thesis analysis yet (no cross-domain correlations on the Lund data) — that is Step 1+, gated on this dispatch's verdict. The only real-data touch allowed: reading empirical accuracy/d′ ranges to calibrate simulator targets (say so if you do).
- FROM-SCRATCH MANDATE stands: nothing consulted or reused from the old project.
- Simulation outputs must be impossible to mistake for empirical results (file names, headers, report labels all say SIMULATION).
- All pass criteria above are fixed BEFORE running (this dispatch is the preregistration). If you believe a criterion is wrongly calibrated, say so in the report and give your reasoning — do not silently change it.

## Acceptance criteria
- Simulator self-check saved and passing (or coupling quantified + discussed).
- Recovery + leakage + detectability numbers all have bootstrap CIs and fixed seeds; second-seed spot-check reported.
- `results/STEP0_REPORT.md` exists, is standalone-readable, and states GATE PASSED or GATE FAILED explicitly.
- renv.lock committed; `git status` clean after final commit.
- REPORT.md filled per template.
