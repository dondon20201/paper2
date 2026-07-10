# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 004
**Date:** 2026-07-10
**From:** Cowork — 0b′ audited (all claims verified against replicates, both seeds); Ben chose one more gate round. This is Step 0b″, the FINAL gate round: it ends in a definite design, whatever the numbers say.

## Objective
Preregister and test a bias-corrected latent estimator on all three real trial configurations (200/200, 200/100, 100/100). The decision tree below is fixed in advance — every outcome maps to a design, so no further gate rounds follow this one.

## Context
0b′ status accepted: 200/200 fully validated (d′-partialed variant primary); single failure = NULL-scenario spurious gap bias +0.082/+0.096 at 200/100 (bar ±0.07); bias is multiplicative shrinkage of latent ρ_sens growing with truth, direction-known. 100/100 (Calories×GDP) untested. Your convergence fix (exchangeability constraints) and d′-partialing carry forward unchanged.

## Tasks

1. STEP 0b″ — calibrated estimator (`analysis/03_calibrated_gate.R`, extending the 0b′ harness):

   **Correction (train/test discipline — the correction may never be graded on the simulations that built it):**
   a. CALIBRATION (training): for each trial config, simulate a grid of true ρ_sens ∈ {0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6} (ρ_level fixed 0.4, ρ_d′ 0.3 to keep partialing engaged), R=20 replicates per grid point, calibration seed family (e.g. 1000+i). Fit the mapping E[latent estimate | truth] per config (linear unless the grid clearly says otherwise — justify the functional form from the grid, plot residuals to a file). Invert it to define the corrected estimator; propagate calibration + estimation uncertainty into the corrected CI (bootstrap or delta method — state which).
   b. EVALUATION (testing): rerun the full 0b′ scenario suite (GAP, NULL-GAP, ZERO-SENS, D′-CONF) with FRESH seeds (main 20260711, spot-check 777) at ALL THREE configs: 200/200, 200/100, **100/100**. R=30 per cell (15 spot-check). Apply the corrected estimator blind — no peeking back at calibration runs.

   **Preregistered criteria per config (same bars as 0b′, applied to the corrected estimator):**
   - GAP: median ρ_sens bias ≤ ±0.07; coverage ≥ 25/30; gap>0 in ≥ 27/30.
   - NULL-GAP: median gap bias ≤ ±0.07; gap CI ∋ 0 in ≥ 25/30.
   - ZERO-SENS: |median ρ_sens| ≤ 0.07.
   - D′-CONF: spurious ρ_sens < 0.10.
   - Convergence: inadmissible/non-converged ≤ 20% per cell.
   - CI honesty: corrected CIs must not be narrower than uncorrected ones (a correction that shrinks uncertainty is wrong by construction — flag if it happens).

   **PRE-DECLARED DECISION TREE (fixed now; execute the branch the numbers select):**
   - ALL configs pass → GATE PASSED, full design: thesis test on all 6 domain pairs, corrected d′-partialed latent estimator.
   - 200/200 + 200/100 pass, 100/100 fails → GATE PASSED WITH SCOPE RESTRICTION: 5 pairs primary; Calories×GDP reported only with its simulation-measured bias band, no standalone claim.
   - Only 200/200 passes → GATE PASSED, NARROW: memory×vision is the sole confirmatory pair; other pairs descriptive with bias bands; paper leans harder on the floor elements.
   - 200/200 fails under the corrected estimator (regression vs 0b′) → GATE FAILED OUTRIGHT: revert to the UNCORRECTED estimator's validated 200/200-only design (0b′ already passed it) and fold in the floor reframe.

2. Update `results/STEP0_REPORT.md` verdict block and write `results/STEP0B2_FINAL_REPORT.md`: calibration curve (form + fit + residuals), full scoreboard for all three configs, the branch selected by the decision tree, and the exact Step 1+ design that results (measures, estimator, which pairs confirmatory). This closes Step 0 permanently.

3. Update PROGRESS.md accordingly.

4. OPTIONAL — GitHub remote if Ben provides a URL (still no backup; keep reminding).

5. Report per protocol: overwrite `cowork/REPORT.md`, session-log line, final `docs:` commit.

## Constraints
- Still NO real-data thesis analysis. Calibration/evaluation are simulation only; declared real-data touches limited to simulator calibration as before.
- Train/test separation is absolute: calibration seeds and evaluation seeds disjoint; the correction is frozen before evaluation runs.
- No criterion adjustments mid-run. If a criterion looks miscalibrated, run as written and argue in the report.
- Simulation labeling as before. Keep runtime sane; reduce R to 20 with a note if it balloons.

## Acceptance criteria
- Calibration artifacts saved (grid results, fitted mapping, residual check).
- Evaluation scoreboard for all 3 configs × 4 scenarios, fresh seeds, both variants (corrected primary, uncorrected for comparison).
- STEP0B2_FINAL_REPORT.md states the selected branch and the final Step 1+ design explicitly.
- `git status` clean; REPORT.md per template.
