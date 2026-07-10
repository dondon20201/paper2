# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 008
**Date:** 2026-07-10
**From:** Cowork — 007 AUDITED AND CONFIRMED (independent MoM re-derivation matched all five pairs ≤0.005; GitHub push verified: local master = origin/master = 863d0e5 at audit). The confirmatory result (006) and descriptive tier (007) are in the can. This dispatch is **BRIEF Step 4: the NON-IPSATIVE MULTILEVEL DECOMPOSITION**, plus the landscape figure work Ben approved at the close of session 2. Everything here is NON-CONFIRMATORY: 006 remains the paper's only confirmatory test and nothing below may be phrased as upgrading or overturning it.

## Objective
(A) Prove, in simulation, that a trial-level multilevel model can recover and separate a planted person-level confidence set-point share and a planted person-level sensitivity share (the Step 4 gate). (B) If and only if the gate passes, fit the same model to the real data and report which component's variance is carried at the person level vs the person×domain level — the BRIEF's "which component carries the cross-domain covariance," without naive mean subtraction. (C) Produce the approved landscape figure + exploratory gap-vs-reliability scatter from COMMITTED results files (no recomputation). (D) Housekeeping: commit the session-02 note, fold its PROGRESS lines, push.

Parts C and D run regardless of the gate outcome. Part B runs ONLY if the Part A gate passes — a gate FAIL is a complete, reportable result and the dispatch still succeeds.

## Preregistered design (fixed now — argue in the report if something looks wrong; do not change it)

### The model (identical in simulation and real data)
Trial-level Gaussian LMM (lme4::lmer, REML), confidence on its raw 1–7 scale (consistent with the locked LEVEL definition):

`conf ~ 0 + domain + domain:acc_dc + (1 + acc_dc | subject) + (1 + acc_dc | subject_domain)`

- `acc_dc` = trial accuracy minus the DOMAIN mean accuracy (fixed, domain-level centering — never subject-level; that is the ipsative artifact this step exists to avoid).
- `subject_domain` = explicit interaction factor (subject × domain).
- Fixed `domain` and `domain:acc_dc` absorb domain-level means and domain-level resolution, so the random effects are person deviations.
- Interpretation: random intercepts = set-point (person-general u_s vs domain-specific v_sd); random accuracy slopes = confidence resolution (person-general w_s vs domain-specific z_sd). NOTE for all write-ups: the slope is a RESOLUTION measure (Δconf correct−incorrect), a different estimand from Step 3's AUROC2 latents — never present the two as the same quantity.
- Estimation: `lmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))`.

### Quantities
- ICC_level = σ²_int,subject / (σ²_int,subject + σ²_int,subject_domain)
- ICC_sens  = σ²_slope,subject / (σ²_slope,subject + σ²_slope,subject_domain)
- Δ_ICC = ICC_level − ICC_sens
- Report all variance components, the ICCs, and Δ_ICC, each with a CI (method below). Two significant figures in prose; full precision in CSVs.

### Convergence/singularity decision ladder (pre-declared; record the rung used every time)
1. M1: full model above (correlated intercept+slope within each level).
2. If M1 non-converged or singular (`isSingular`, tol 1e-4): M2 = same with `||` (uncorrelated) at both levels.
3. If M2 fails: M3 = drop the random slope at the level where its variance collapses; the corresponding ICC is NOT ESTIMABLE — report that with diagnostics; do not improvise further. On real data, landing on M3 means ICC_sens (or ICC_level) is UNSTABLE — a reportable finding, not a bug to fix.

### CI method (both parts)
Subject-level nonparametric cluster bootstrap: resample subjects with replacement (a resampled subject brings all their domains/trials), refit at the same ladder rung as the point estimate (allow rung escalation per resample; count them), percentile CIs. Target B=500. Time one fit first: if projected bootstrap time exceeds ~2.5 h, drop to B=200; if still over, B=100 and label the CIs LOW-RESOLUTION. Record actual B, per-fit time, and the count of failed/singular resamples in the meta JSON; if >10% of resamples fail, label the CI UNSTABLE.

### Part A — recovery + separability gate (SIMULATION, script `analysis/08_step4_recovery_gate.R`)
Simulate at real-data scale (322 subjects; trials per domain 200/200/100/100; domain accuracy rates ≈ observed: memory .77, vision .72, Calories .71, GDP .70; accuracy exogenous Bernoulli). Generative model = the LMM's own data-generating process, then discretize: round conf* to integers and clamp to 1–7 (discretization + clamping is exactly the distortion the gate must survive). Plant variance components to hit target ICCs; magnitudes matched to real data (person intercept SD ≈ 0.8 on the 1–7 scale, total intercept SD partitioned by ICC_level; mean resolution slope ≈ 0.8 with slope SDs partitioned by ICC_sens; residual SD ≈ 1.2). Document planted values in the meta JSON.

Cells (ICC_level, ICC_sens): (0.8, 0.2), (0.8, 0.5), (0.5, 0.2), (0.5, 0.5), (0.2, 0.8). 10 replicates per cell, seeds = 20260710 + replicate index within cell (record all).

PASS criteria (ALL must hold):
1. Recovery: |mean(ICC_hat) − planted| ≤ 0.10 for each component in every cell.
2. Separability/leakage: changing one planted ICC while holding the other fixed (the (0.8,·) vs (0.5,·) pairs, and (·,0.2) vs (·,0.5) pairs) moves the OTHER component's mean estimate by ≤ 0.10.
3. Sign: in cells with planted |Δ_ICC| ≥ 0.3, sign(Δ_ICC_hat) is correct in ≥ 9/10 replicates.
4. ≥ 9/10 replicates per cell converge at rung M1 or M2.
If ANY criterion fails: STOP Part B, write the gate report with the failure spelled out, and proceed to Parts C–D. Do not weaken a criterion to pass.

Ipsative-artifact exhibit (runs inside Part A, descriptive, not pass/fail): in the (0.5, 0.5) cell, ALSO compute the naive ipsative analysis — subtract each simulated subject's grand mean confidence, correlate the centered domain means across the 6 domain pairs. Under this null-structured world the mechanical negative correlation (theory: ≈ −1/3 for 4 domains) should appear while the LMM recovers the planted shares. Save both numbers side by side (`results/step8_SIMULATION_ipsative_exhibit.csv`) — this is a methods exhibit for the paper.

Part A outputs: `results/step8_SIMULATION_step4gate_recovery.csv` (per replicate: cell, planted, estimates, rung, converged), `results/step8_SIMULATION_step4gate_summary.csv` (per cell: means, biases, leakage deltas, PASS flags per criterion, overall PASS/FAIL), `results/step8_SIMULATION_step4gate_meta.json` (design, planted magnitudes, seeds, runtimes), the ipsative exhibit CSV.

### Part B — real data (script `analysis/09_step4_multilevel.R`; gate-conditional)
- Provenance guards as in 006/007: raw CSV md5 `500b2e6e1eb0e47e717feba5b912ad9f`, git-clean check on inputs.
- Trials: primary trial set, same rules as step1 (exclude repeat-flagged trials, drop missing confidence). Subject-domains: exactly those present in `results/step1_REALDATA_subject_measures.csv` primary rows (no new exclusion decisions).
- Fit the ladder; point estimates + bootstrap CIs for all variance components, ICC_level, ICC_sens, Δ_ICC.
- Preregistered robustness (secondary, labeled as such): R1 = refit with confidence z-scored WITHIN DOMAIN (domain-level standardization — still non-ipsative); report ICCs side by side. R2 (optional, non-blocking) = ordinal cumulative-link mixed model (`ordinal::clmm`) with the same random structure IF a single fit completes within ~60 min; otherwise report SKIPPED (runtime) — that is acceptable.
- Preregistered diagnostics (exploratory, labeled): correlate subject-level slope BLUPs with each subject's mean d′-hat, and subject_domain slope BLUPs with the matching d′-hat from step1 (the LMM slope is NOT d′-partialed — quantify the confound rather than pretending it away; ties to the standing d′-reliability caution already logged for the limitations section).
- Real-data ipsative exhibit: same naive mean-subtraction computation on the real data (6 pairwise centered-bias correlations) reported NEXT TO the multilevel decomposition (`results/step9_REALDATA_ipsative_exhibit.csv`) — frame strictly as "what the artifact-prone analysis would have said."
- WORDING (binding): the tier label is `STEP4_MULTILEVEL (preregistered, NON-CONFIRMATORY)`. ICCs are variance-share generalizability indices — a different estimand from Step 3's latent correlations; the MD must say so explicitly. If Δ_ICC's CI excludes 0, that is a preregistered secondary finding stated with hedges; if it does not, write "a Δ_ICC of zero is not excluded" (never "there is no difference"). Nothing here confirms, disconfirms, or re-tests 006.

Part B outputs: `results/step9_REALDATA_step4_multilevel.csv` (components, ICCs, Δ_ICC, CIs, rung, B, diagnostics counts), `results/step9_REALDATA_step4_multilevel.md` (readable summary with the preregistered wording + honest-reading paragraph), `results/step9_REALDATA_step4_diagnostics.csv` (robustness refits, BLUP–d′ correlations), the ipsative exhibit CSV.

### Part C — landscape figure + exploratory scatter (script `analysis/10_landscape_figures.R`; unconditional)
Per Ben's decision (session-02 note, measurement-lens framing). ALL numbers read from COMMITTED results files; the script must assert the read values match these (from the audited reports) and stop on mismatch — no recomputation anywhere:
- step6 (mem×vis, CONFIRMATORY, corrected): ρ_level 0.422, gap 0.113 [−0.138, 0.364].
- step7 (NON-CONFIRMATORY, uncorrected, gap ± frozen band): mem×Cal 0.375 / −0.020 ± .09; mem×GDP 0.323 / −0.133 ± .09; vis×Cal 0.450 / 0.194 ± .09; vis×GDP 0.464 / 0.296 ± .09; Cal×GDP 0.473 / 0.237 ± .10.

Figure 1 (landscape), `figures/fig_landscape.pdf` + `.png` (300 dpi): six pairs on the x-axis (order: mem×vis, mem×Cal, mem×GDP, vis×Cal, vis×GDP, Cal×GDP); two aligned panels — top: ρ_level with CI whiskers; bottom: gap with CI whiskers PLUS a visually distinct shaded systematic-band rectangle (±0.09/±0.10) on the five descriptive pairs (mem×vis gets no band — it is corrected — and is visually marked CONFIRMATORY; the other five marked NON-CONFIRMATORY); horizontal zero line on the gap panel. Caption text drafted in the MD companion: bands are systematic-bias allowances, not CIs; vision×GDP's CI excludes 0 but its lower bound lies inside its band, so no nonzero-gap claim is made. Underlying data → `results/fig_landscape_data.csv`.

Figure S1 (exploratory scatter), `figures/figS_gap_vs_reliability.pdf` + `.png`: x = geometric mean of the pair's two AUROC2 PARCEL reliabilities exactly as committed in `results/step2_REALDATA_reliability.csv` (kind = parcel_reliability: memory 0.546, vision 0.273, Calories 0.306, GDP 0.242 — assert on read; caption must state these are raw pre-partialing parcel reliabilities); y = the same six gap values as Figure 1. Six labeled points. NO fitted line, NO correlation, NO test — the attenuation reading is interpretation, and the caption says EXPLORATORY explicitly. Underlying data → `results/figS_gap_vs_reliability_data.csv`.

### Part D — housekeeping
1. Commit `cowork/sessions/2026-07-10-session-02.md` (currently uncommitted) and fold its "For PROGRESS.md" lines into PROGRESS.md.
2. `renv::install("lme4")` (and `ordinal` only if attempting R2); remind Ben to run `renv::snapshot()`; commit the updated lockfile.
3. Update PROGRESS.md with this dispatch's outcome; overwrite `cowork/REPORT.md` per protocol; session-log line; final `docs:` commit.
4. Push; report the pushed HEAD hash (Cowork verifies origin/master advanced at audit).

## Constraints
- Every number: computed this run (or read from a committed file with an assertion), labeled SIMULATION vs REALDATA and VERIFIED/etc. per BRIEF §3, saved under results/.
- The gate is hard: no real-data fit on a failed gate. A FAIL, a NOT-ESTIMABLE ICC, or a SKIPPED robustness check are all acceptable reportable outcomes.
- Never phrase Step 4 output as a test of the thesis or as revising 006. The "null not excluded" wording rule stands everywhere.
- Preregistered decisions are fixed; if one is wrong, say so in REPORT.md and stop rather than silently deviating.

## Acceptance criteria
- step8 gate CSVs + meta exist with an explicit overall PASS/FAIL and per-criterion flags; ipsative exhibits (sim, and real if Part B ran) exist.
- If gate PASSED: step9 CSV/MD exist with ICCs + Δ_ICC + CIs, rung, B, robustness, diagnostics, and the preregistered wording. If gate FAILED: REPORT.md says so plainly and Part B artifacts are absent by design.
- Both figures exist (pdf+png) with underlying-data CSVs; every plotted value asserted against committed results files; captions carry the NON-CONFIRMATORY/EXPLORATORY labels.
- Session-02 note committed; PROGRESS.md folded + updated; renv.lock updated if packages added; `git status` clean; push confirmed with HEAD hash in REPORT.md.
