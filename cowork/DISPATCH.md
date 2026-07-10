# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 003
**Date:** 2026-07-10
**From:** Cowork — Step 0b audited & accepted as an honest FAIL; this is Step 0b′ (revised gate, your option (a), with (b) as the standing floor)

## Objective
Determine whether a LATENT-variable estimator can recover the cross-domain sensitivity correlation and the level-vs-sensitivity gap without bias at realistic trial counts. If yes, the thesis test is redesigned around it and the gate passes; if no, the paper reframes to the validated floor (level generalization + quantified measurement-limits + the spurious-gap demonstration). Either outcome ends Step 0 with a definite verdict.

## Context
Cowork audited dispatch 002 against the raw results files: all claims verified, preregistered criteria correctly applied, FAIL accepted. Consequences now binding: **gamma is dropped as a primary sensitivity measure** (set-point leakage −0.18/−0.15 across seeds); AUROC2 stands (clean leakage, known noise); the naive raw-correlation contrast is dead (invents the thesis under null); mean-confidence level measure is validated. You may REUSE your own dispatch-002 simulator and estimator code — it passed its self-checks and is this project's own validated code (the from-scratch mandate bars only the OLD project's code).

## Tasks

1. STEP 0b′ — latent-estimator gate (`analysis/02_latent_gate.R`, extending your harness; everything SIMULATION-labeled as before):

   **Estimator under test (primary):** parcel-based latent correlation. Per simulated subject per domain, split trials into K interleaved parcels (K=4 at 200 trials; K=2 at 100 — justify or revise K in the report), compute AUROC2 per parcel, and fit a two-domain CFA/SEM (each domain's latent sensitivity indicated by its parcels; lavaan or equivalent) to estimate the LATENT cross-domain sensitivity correlation. Same machinery for level (mean-conf parcels) so the gap is estimated within one framework. If lavaan is unusable on Dondon, a clearly-documented equivalent (e.g. correlation-attenuation via parcel-based reliability inside a bootstrap) is acceptable — say so.

   **Scenarios (population ρ values; replicate R=30 per scenario per trial-config, fresh traits each replicate; trial configs 200/200 and 200/100):**
   - GAP: ρ_level 0.6, ρ_sens 0.2
   - NULL-GAP: ρ_level 0.4, ρ_sens 0.4
   - ZERO-SENS: ρ_level 0.4, ρ_sens 0.0
   - D′-CONFOUND (new, critical): ρ_dprime 0.4, ρ_sens 0.0, ρ_level 0.0 — real subjects' type-1 ability DOES correlate across domains, and AUROC2 carries a d′ confound (~0.33, your dispatch-002 measurement). Does the latent estimator convert cross-domain d′ correlation into a spurious sensitivity correlation?

   **Preregistered criteria (against each replicate's REALIZED trait correlations; also report the realized-vs-population deviation you observed in 002 — explain it, it looked larger than sampling error and is probably your trait-transformation/copula, quantify to confirm it is benign):**
   a. GAP: median bias of latent ρ_sens across replicates within ±0.07; 95% CI coverage of realized truth ≥ 25/30 replicates; estimated latent gap positive in ≥ 27/30.
   b. NULL-GAP: median estimated latent gap within ±0.07 of realized (~0); gap CI covers 0 in ≥ 25/30.
   c. ZERO-SENS: median latent ρ_sens within ±0.07 of 0.
   d. D′-CONFOUND: median spurious latent ρ_sens < 0.10. If this fails, add d′-partialing (residualize parcel AUROC2 on estimated d′, or include d′ as a covariate), rerun scenario D and A, and report both raw and partialed variants — partialed becomes primary if it passes.
   e. Convergence/inadmissibility bookkeeping: report the % of replicates with Heywood cases / non-convergence; > 20% in any scenario = that config FAILS regardless of bias.

2. Write `results/STEP0B_PRIME_REPORT.md` (standalone addendum; update STEP0_REPORT.md's verdict block to point at it): scenario tables with bias/coverage/convergence, the K-choice justification, the realized-vs-population correlation explanation, and an explicit final verdict: **STEP 0 GATE: PASSED WITH REVISED DESIGN (latent contrast, AUROC2 + level, estimator as validated here)** or **STEP 0 GATE: FAILED → floor reframe**. State which thesis test (exact estimator + measures) Step 1+ will use if passed.

3. Update PROGRESS.md status/next-steps per the verdict.

4. OPTIONAL — GitHub remote if Ben provides a URL at run time (repo still has no backup; remind him in your summary).

5. Report per protocol: overwrite `cowork/REPORT.md`, append session-log line, final `docs:` commit.

## Constraints
- Still NO real-data thesis analysis. Real-data touches allowed only for simulator calibration, declared explicitly (as in 002).
- Preregistration discipline unchanged: criteria above are fixed before running; if you believe one is miscalibrated, run it as written and argue in the report.
- Simulation labeling unchanged (file names, headers, data_type columns).
- Keep runtime sane (~this is 30×2×4 SEM fits on small matrices — should be minutes, not hours). If it balloons, reduce R to 20 and say so.

## Acceptance criteria
- All four scenarios run at both trial configs with fixed seeds + second-seed spot-check of the headline verdict.
- STEP0B_PRIME_REPORT.md exists, is standalone-readable, states the gate verdict explicitly, and every number has a CI and a status label.
- `git status` clean after final commit; REPORT.md filled per template.
