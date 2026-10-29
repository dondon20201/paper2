# STEP 0b′ REPORT — Latent-Estimator Gate (addendum to STEP0_REPORT.md)

**Project:** Confidence Level vs Confidence Informativeness (paper2/metacog)
**Date:** 2026-07-10 · **Dispatch:** 003 · **Code:** `analysis/02_latent_gate.R`, `R/parcels.R`
**Everything below is SIMULATION** (planted truth; files `results/step0bprime_SIMULATION_*`).
Pre-specified criteria were fixed in `cowork/DISPATCH.md` #003 before running and
were not adjusted. Seeds: 20260710 (30 replicates/cell), 42424242 (15, spot-check).

---

## VERDICT

**STEP 0b′: FAILED per pre-specification — by one criterion, in one trial
configuration, by 0.012.** Consequently **STEP 0 GATE overall: FAILED** as the
criteria were written. The scoreboard (primary variant = d′-partialed, which
the pre-specification itself promoted; see §3):

| Criterion | 200/200 | 200/100 |
|---|---|---|
| a. GAP: ρ_sens median bias ≤ ±0.07 | +0.029 ✓ | +0.010 ✓ |
| a. GAP: CI coverage ≥ 25/30 | 28/30 ✓ | 29/30 ✓ |
| a. GAP: gap > 0 in ≥ 27/30 | 29/30 ✓ | 28/30 ✓ |
| b. NULL: gap median bias ≤ ±0.07 | +0.051 ✓ | **+0.082 ✗** |
| b. NULL: gap CI ∋ 0 ≥ 25/30 | 29/30 ✓ | 27/30 ✓ |
| c. ZERO-SENS: |median ρ_sens| ≤ 0.07 | 0.041 ✓ | 0.015 ✓ |
| d. D′-CONF: spurious ρ_sens < 0.10 | −0.004 ✓ | +0.029 ✓ |
| e. Non-convergence ≤ 20% | 0% ✓ | 0% ✓ |
| **All pass** | **YES** | **NO** |

The single failure replicates on the second seed (+0.096), so it is a real,
small systematic bias, not noise — diagnosis in §4.

## 1. The estimator (and the K-choice justification the dispatch asked for)

Per subject per domain: interleaved parcels of trials (assignment by trial
index mod K), AUROC2 and mean confidence per parcel; then ONE two-domain,
four-factor CFA (sensitivity + level per domain; lavaan 0.6-21, ML) whose
labeled factor correlations are latent ρ_sens and ρ_level, with
gap := ρ_level − ρ_sens as a defined parameter (delta-method CI from the same
fit).

- **K = 4 at 200 trials and K = 2 at 100** (the dispatch's proposal) is kept,
  with one refinement it forced: 50-trial AUROC2 parcels have reliability
  ≈ 0.15–0.2, and an UNCONSTRAINED 2-indicator factor on such parcels is
  empirically underidentified — the first smoke fit produced loadings of
  24.2 and 0.006 with a residual variance of −463 and a singular information
  matrix (documented in dispatch REPORT).
- **Fix, principled rather than ad hoc:** interleaved parcels are
  EXCHANGEABLE by construction, so equal loadings and equal residual
  variances within each factor are true in the population, and imposing them
  both identifies the K = 2 factor and stabilizes everything else. With these
  constraints: **480/480 replicates converged admissibly** (bounded-ML
  fallback existed but the bookkeeping shows 0% bad cells). K = 4 at 100
  trials (25-trial parcels) was not needed given this.

## 2. Scenario results (partialed primary; medians over 30 replicates)

| Scenario (ρ_level, ρ_sens, ρ_d′) | Config | latent ρ_sens (bias) | latent ρ_level (bias) | gap (bias) |
|---|---|---|---|---|
| GAP (.6, .2, 0) | 200/200 | 0.19 (+0.029) | 0.585 (−0.006) | 0.40 (−0.030) |
| GAP | 200/100 | 0.20 (+0.010) | 0.602 (−0.002) | 0.39 (−0.018) |
| NULL (.4, .4, 0) | 200/200 | 0.33 (−0.050) | 0.412 (−0.006) | 0.058 (+0.051) |
| NULL | 200/100 | 0.26 (−0.090) | 0.407 (−0.004) | 0.087 (**+0.082**) |
| ZERO-SENS (.4, 0, 0) | 200/200 | 0.041 (+0.061) | 0.388 (−0.004) | — |
| ZERO-SENS | 200/100 | 0.015 (+0.033) | 0.403 (−0.003) | — |
| D′-CONF (0, 0, .4) | 200/200 | −0.004 | 0.004 | — |
| D′-CONF | 200/100 | +0.029 | −0.016 | — |

Power note (not a criterion): at true gap 0.4 the gap CI excludes zero in
25/30 (200/200) and 22/30 (200/100) replicates — the design detects a real
gap ~75–83% of the time at n = 322.

## 3. The d′-confound scenario — Cowork's addition earned its place

**RAW latent estimation converts cross-domain type-1 ability correlation into
spurious metacognitive correlation:** with ρ_d′ = 0.4 and NOTHING else
correlated, raw latent ρ_sens medians were 0.084 (200/200) and **0.102
(200/100) — over the 0.10 bar → raw FAILS criterion (d)**. Per the
pre-specified rule, the d′-partialed variant (parcel AUROC2 residualized on
estimated d′ per domain) became primary: it kills the confound (−0.004 /
+0.029) while leaving GAP-scenario recovery intact (see table). **Standing
consequence: any real-data sensitivity analysis in this project must be
d′-partialed** — real cross-domain d′ correlation is exactly what Lund-type
data will contain.

## 4. The failing criterion, diagnosed

Latent ρ_sens is shrunk multiplicatively when parcel reliability is low, and
the shrinkage grows with the true correlation: bias ≈ +0.03 at ρ_sens = 0,
≈ ±0.02 at 0.2, ≈ −0.05 (200/200) to −0.09 (200/100) at 0.4. Level, with
parcel reliability ≈ 0.97, is unbiased (|bias| ≤ 0.006) — so the DIFFERENCE
inherits a small spurious positive component that peaks in the NULL scenario
(highest ρ_sens): gap bias +0.051 at 200/200 (passes), **+0.082 at 200/100
(fails the ±0.07 bar; second seed +0.096)**. This is the same artifact class
dispatch 002 exposed for raw correlations (there: ~+0.28), reduced ~4-fold
but not eliminated. It is quantified, replicated, and direction-known —
i.e., correctable in principle (simulation-calibrated bias band or
correction), but that would be a NEW estimator requiring a NEW pre-specified
gate round, not a post-hoc adjustment of this one.

## 5. The 002 realized-vs-population question — resolved, benign

2000 fresh trait draws per ρ (VERIFIED, simulation): the λ copula transform
(normal → uniform range map) shifts the realized Pearson correlation by only
−0.008 at ρ = 0.2 (mean realized 0.192, SD 0.053) and −0.018 at ρ = 0.6;
β is unbiased (mean 0.201 at ρ = 0.2). Dispatch 002's eye-catching realized
0.32 vs population 0.2 sits at the 99.2nd percentile of the n = 322 sampling
distribution — an unlucky draw, not a generator defect. Evaluating against
REALIZED correlations (as all criteria here do) makes this moot going
forward.

## 6. What this means

Validated and ready if Ben/Cowork choose to use them:
- The full estimator pipeline at **200/200** — all criteria pass; the
  memory×vision pair of the real data is exactly this configuration.
- **d′-partialing** as a mandatory ingredient of any sensitivity claim.
- Level measurement (again) — latent ρ_level bias ≤ 0.006 everywhere.

Not validated:
- Sensitivity/gap estimation at **200/100** (4 of the 6 real domain pairs)
  carries a replicated +0.08–0.10 spurious-gap bias under the null. 100/100
  (the Calories×GDP pair) was not in the dispatch's configs and is untested —
  presumably worse.

Options for the next planning round (not mine to decide):
1. **Floor reframe** (the dispatch's stated default on FAIL): level
   generalization + quantified measurement-limits + the two spurious-gap
   demonstrations (raw AND latent) as a methodological contribution.
2. **One more gate round** with a bias-corrected latent estimator
   (simulation-calibrated shrinkage correction or a planted-truth calibration
   band), pre-specified fresh, including 100/100.
3. **Scope-restricted design:** strong thesis claims only from the 200/200
   pair; 200/100 pairs reported with the simulation-measured bias band
   (±0.10) attached; no stand-alone claims from 100/100.

**STEP 0 GATE: FAILED (per pre-specification). No real-data thesis analysis
proceeds until Ben/Cowork select a path and, for options 2–3, a revised gate
passes.**
