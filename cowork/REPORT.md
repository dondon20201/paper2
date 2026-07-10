# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — **STEP 0 GATE: PASSED, NARROW. Step 0 closed.**
**Dispatch #:** 004
**Date:** 2026-07-10

## What was done

Step 0b″ executed exactly as preregistered. Calibration phase (seed family
1000+i, disjoint from evaluation): 7-point ρ_sens truth grid × 3 configs ×
20 replicates with ρ_level 0.4 / ρ_d′ 0.3; linear shrinkage maps fitted per
config (quadratic terms n.s. at p = 0.30/0.83/0.81 — linear justified;
residual plot + underlying data saved). Correction frozen — ρ̂c = (ρ̂ − a)/b
with delta-method SEs (fit SE/b² + calibration-vcov term, as declared) —
then evaluated blind on fresh seeds (20260711 main R = 30; 777 spot R = 15)
across the full 0b′ scenario suite at 200/200, 200/100, and the previously
untested 100/100. Pre-declared decision tree executed mechanically.
`fit_latent()` extended to return SEs and the ρ_sens–ρ_level sampling
covariance (needed for corrected-gap CIs); shared sim machinery factored into
`R/gate_harness.R` (02's script-local copies untouched — its committed record
stands).

## Files changed / created

- `R/parcels.R` — fit_latent now returns SEs + cov(rs, rl)
- `R/gate_harness.R` — shared gate simulation harness (new)
- `analysis/03_calibrated_gate.R` — calibration + blind evaluation + decision tree
- `results/step0b2_SIMULATION_{calibration_replicates,calibration_coefs,eval_replicates,eval_summary}.csv`, `_meta.json`
- `figures/step0b2_SIMULATION_calibration_residuals.png` (underlying data in results/)
- `results/STEP0B2_FINAL_REPORT.md` (new; the closing report), `results/STEP0_REPORT.md` (final verdict block), `PROGRESS.md`

## Commits

- `7ebfc4c` — docs: dispatch 004 from Cowork
- `375770e` — feat: step 0b″ — calibrated latent-estimator gate, final round
- `67f3c40` — docs: step 0b″ final report — GATE PASSED, NARROW; step 0 closed
- final `docs:` commit — this report + session-log line

Task 4 (remote): **SKIPPED — still no URL.** Fifteen commits, no backup.

## Results

All SIMULATION, computed this session. Calibration slopes: 0.75 (200/200),
0.94 (200/100), 0.76 (100/100).

**Blind-evaluation scoreboard (corrected estimator, main seed):**
- **200/200: ALL criteria PASS** — GAP ρ_sens bias −0.029, coverage 28/30,
  gap>0 30/30; NULL gap bias +0.044, CI∋0 29/30; ZERO-SENS −0.056;
  DCONF +0.045; 0% bad fits; CI-honesty 1.34× median width, 0 narrower.
- **200/100: fails ONE criterion** — GAP ρ_sens bias −0.081 vs ±0.07 (the
  correction under-corrected this seed's draws; uncorrected same cell −0.10).
  Everything else passes. Spot-check seed: 200/100 passes everything.
  Genuinely borderline; the preregistration names the main seed decisive, so
  it FAILS. No post-hoc rescue attempted.
- **100/100: fails TWO** (GAP bias +0.089, NULL gap bias +0.075) — clear.

**Decision tree branch (pre-declared): GATE PASSED, NARROW.** memory×vision
(200/200) sole confirmatory pair; four 200/100 pairs + Calories×GDP
descriptive only, with simulation-measured bias bands (±0.09–0.10 on ρ_sens).

**Power caveat for expectation-setting:** at true gap 0.4, the corrected gap
CI excludes zero in 18/30 (60%) at 200/200 (direction right 30/30). The
confirmatory test is unbiased and honest but not high-powered — a "CI
includes zero" outcome on real data is a live possibility and will be
reported as exactly that.

**Locked Step 1+ design (STEP0B2_FINAL_REPORT.md §3):** level = mean
confidence (raw; bias ≤ 0.006 everywhere); sensitivity = AUROC2 only,
d′-partialed, K = 4 exchangeable-parcel CFA; frozen 200/200 correction
(a = 0.040, b = 0.75) with delta-method CIs; confirmatory quantity = corrected
gap on memory×vision; descriptive tier with bias bands; floor elements
(level generalization, reliability curves, both spurious-gap demonstrations)
ride along regardless.

## Issues & blockers

1. None blocking — Step 0 is closed with a definite, preregistration-selected
   design. Step 1 awaits a Cowork dispatch.
2. Honest wrinkle to carry into the paper's methods: 200/100 straddles the
   bias bar (fails main seed by 0.011, passes spot seed). It is correctly
   OUT of the confirmatory tier under the prereg — but the bias bands we
   attach to the descriptive tier should quote both seeds' values, not just
   the worse one.
3. Backup STILL missing. Fifteen commits on one machine. Fourth reminder.

## Questions / decisions needed for planning

- Step 1 dispatch: suggest it covers (i) real-data per-subject component
  estimation (level, d′-partialed AUROC2 parcels) for all four domains,
  (ii) reliability/trials-needed analysis (Step 2 of BRIEF), and only then
  (iii) the confirmatory memory×vision test in a separate dispatch — keeps
  the confirmatory analysis single-shot and clean.
- Should the descriptive-tier bias bands be frozen NOW from
  step0b2_SIMULATION_eval_summary.csv (my suggestion: yes, quote ±0.09 for
  200/100, ±0.10 for 100/100, both-seed values in a footnote) so Step 3+
  can't be accused of choosing bands after seeing real data?
- GitHub remote URL (fourth ask).
