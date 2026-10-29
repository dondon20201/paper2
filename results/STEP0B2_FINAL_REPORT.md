# STEP 0b″ FINAL REPORT — Calibrated Latent-Estimator Gate (closes Step 0)

**Project:** Confidence Level vs Confidence Informativeness (paper2/metacog)
**Date:** 2026-07-10 · **Dispatch:** 004 · **Code:** `analysis/03_calibrated_gate.R`, `R/gate_harness.R`, `R/parcels.R`
**Everything below is SIMULATION** (`results/step0b2_SIMULATION_*`). The decision
tree was pre-declared in `cowork/DISPATCH.md` #004 before any run; criteria were
not adjusted. Train/test discipline: calibration seeds 1000+i; evaluation seeds
20260711 (main, R = 30) and 777 (spot-check, R = 15) — disjoint; the correction
was frozen before evaluation.

---

## VERDICT (pre-declared decision tree, executed mechanically)

**STEP 0 GATE: PASSED, NARROW.**
memory×vision (200/200 trials) is the **sole confirmatory pair** for the thesis
test; all other domain pairs are **descriptive only, reported with their
simulation-measured bias bands**. Step 0 is now closed permanently — no further
gate rounds (per the dispatch, every outcome mapped to a design; this is the
branch the numbers selected).

Config pass map (corrected estimator, main evaluation seed):
**200/200 PASS (all 10 criteria) · 200/100 FAIL (1 of 10) · 100/100 FAIL (2 of 10)**

## 1. Calibration (training phase) — VERIFIED (SIMULATION)

Grid: true ρ_sens ∈ {0, …, 0.6} × 3 configs × 20 replicates (ρ_level = 0.4,
ρ_d′ = 0.3 so d′-partialing stayed engaged). Fitted mapping
E[latent estimate] = a + b·(realized truth), per config:

| Config | intercept a | slope b (SE) | resid SD | quadratic term p |
|---|---|---|---|---|
| 200/200 | +0.040 | 0.75 (0.052) | 0.12 | 0.30 |
| 200/100 | −0.015 | 0.94 (0.069) | 0.16 | 0.83 |
| 100/100 | +0.034 | 0.76 (0.092) | 0.22 | 0.81 |

**Functional form:** linear, as pre-specified-by-default — no quadratic term
approaches significance (residual plot:
`figures/step0b2_SIMULATION_calibration_residuals.png`; underlying data
`results/step0b2_SIMULATION_calibration_replicates.csv`). Corrected estimator:
ρ̂c = (ρ̂ − a)/b, with **delta-method** SEs combining the fit SE (scaled 1/b)
and the calibration coefficients' vcov — as declared.

## 2. Blind evaluation scoreboard (corrected estimator, fresh seeds)

| Criterion | 200/200 | 200/100 | 100/100 |
|---|---|---|---|
| a. GAP ρ_sens median bias ≤ ±0.07 | −0.029 ✓ | **−0.081 ✗** | **+0.089 ✗** |
| a. GAP coverage ≥ 25/30 | 28 ✓ | 29 ✓ | 30 ✓ |
| a. GAP gap>0 ≥ 27/30 | 30 ✓ | 30 ✓ | 28 ✓ |
| b. NULL gap median bias ≤ ±0.07 | +0.044 ✓ | −0.048 ✓ | **+0.075 ✗** |
| b. NULL gap CI ∋ 0 ≥ 25/30 | 29 ✓ | 29 ✓ | 30 ✓ |
| c. ZERO-SENS |median| ≤ 0.07 | 0.056 ✓ | 0.010 ✓ | 0.048 ✓ |
| d. D′-CONF median < 0.10 | 0.045 ✓ | 0.038 ✓ | −0.079 ✓ |
| e. Bad fits ≤ 20% | 0% ✓ | 3.3% ✓ | 0% ✓ |
| f. CI honesty (never narrower) | 1.34×, 0 ✓ | 1.07×, 0 ✓ | 1.34×, 0 ✓ |
| **All pass** | **YES** | NO | NO |

Notes the reader should not miss:
- **Corrected CIs are honest everywhere**: coverage 28–30/30 in every cell,
  widths 1.07–1.35× the uncorrected ones, zero replicates narrower (criterion
  f explicitly designed to catch a fake-precision correction).
- **200/100 is genuinely borderline, and the pre-specification decides:** it
  failed on the main seed by 0.011 on one criterion (GAP bias −0.081; the
  uncorrected bias same cell was −0.10, i.e. the correction under-corrected
  this seed's draws) and PASSED outright on the spot-check seed. The main
  evaluation seed was declared decisive in advance, so 200/100 fails.
  Honest characterization: corrected-estimator bias at 200/100 straddles the
  ±0.07 bar rather than sitting clearly inside it.
- **100/100 fails clearly** (two bias criteria, both seeds directionally
  consistent) — the Calories×GDP pair cannot carry a confirmatory claim.
- **Power at the confirmatory config:** with true gap 0.4, the corrected gap
  CI excluded zero in 18/30 replicates (~60%); the gap's SIGN was right in
  30/30. The correction buys unbiasedness and honest coverage at the price of
  power — a real-data null on the gap CI will therefore be reported as
  "not excluded," never as "absent."

## 3. The exact Step 1+ design this locks in

Per the PASSED-NARROW branch:

- **Measures:** confidence LEVEL = mean confidence (validated 0b);
  SENSITIVITY = AUROC2 only (gamma retired in 0b for set-point leakage),
  **always d′-partialed** (0b′ DCONF finding).
- **Estimator:** exchangeable-parcel latent CFA (equal loadings/residuals,
  K = 4 parcels at 200 trials), d′-partialed, with the **frozen 200/200
  calibration correction** (a = 0.040, b = 0.75) and delta-method CIs, exactly
  as validated here.
- **Confirmatory thesis test (one pair):** memory×vision — corrected latent
  ρ_level vs corrected... [level needs no correction: measured level bias
  ≤ 0.006 in every cell of 0b′ and 0b″; ρ_level enters raw] — the
  confirmatory quantity is the corrected gap with its delta-method CI.
- **Descriptive tier:** the four 200/100 pairs and Calories×GDP (100/100),
  each reported with its simulation-measured bias band from this round's
  evaluation tables (±0.09 for 200/100, ±0.09–0.10 for 100/100 on ρ_sens;
  gap bands likewise from `step0b2_SIMULATION_eval_summary.csv`), clearly
  labeled non-confirmatory.
- **Floor elements ride along regardless** (per BRIEF §5): level
  generalization (bulletproof measure), the reliability/trials-needed
  findings from 0b, and the two spurious-gap demonstrations (raw AND
  uncorrected-latent) as methodological results.

## 4. Claim-status ledger for this round

- Calibration mappings, evaluation scoreboard, decision branch: **VERIFIED
  (SIMULATION, this run, code shown).**
- "200/100 estimates carry ±0.09 bias bands": VERIFIED (SIMULATION) — and is
  the reason that tier is non-confirmatory.
- Nothing here is an empirical claim about the Lund data; Step 0 contains NO
  real-data thesis analysis. Real-data touches remain the two declared
  calibration reads (accuracy range).

**STEP 0: CLOSED. GATE PASSED, NARROW. Step 1 may proceed under the design in
§3 once Cowork dispatches it.**
