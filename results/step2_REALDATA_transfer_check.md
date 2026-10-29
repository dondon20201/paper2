# Step 2 — Calibration Transfer Check (REALDATA vs gate simulations)

**Date:** 2026-07-10 · **Code:** `analysis/05_realdata_reliability.R` (all numbers computed this run)

## VERDICT: **006 CLEARED**

Pre-specified rule (dispatch 005): real memory & vision parcel AUROC2
reliability must be >= 70% of the simulation's matching value.

| Quantity | Simulation | Real | Ratio real/sim |
|---|---|---|---|
| Parcel AUROC2 reliability, memory (50-trial parcels) | 0.177 | 0.546 [0.479, 0.606] | **3.08** |
| Parcel AUROC2 reliability, vision (50-trial parcels) | 0.177 | 0.273 [0.206, 0.339] | **1.54** |
| Parcel AUROC2 reliability, Calories (~46-trial parcels; context) | 0.191 | 0.306 [0.204, 0.400] | 1.60 |
| Parcel AUROC2 reliability, GDP (~40-trial parcels; context) | 0.191 | 0.242 [0.123, 0.357] | 1.27 |

Simulation parcel values derived from `step0b_SIMULATION_detectability.csv`
split-half SB reliabilities by inverse Spearman-Brown step-down
r_parcel = R / (K - (K-1)R); stated per the dispatch. Calories/GDP primary
parcels are slightly shorter than the simulated 50 trials (medians 92/81
trials -> ~46/40 per parcel) — noted, affects the context rows only.

## Distributional comparisons (simulator assumptions vs real data)

| Quantity | Simulation | Real (per domain, primary) |
|---|---|---|
| d' mean | 1.2 (truncnorm) | memory 1.56 · vision 1.20 · Calories 1.09 · GDP 1.03 |
| d' SD | 0.3 | memory 0.56 · vision 0.14 · Calories 0.18 · GDP 0.24 |
| Between-subject SD of mean confidence | 1.31 (implied by beta SD 0.8 through the 1-7 thresholds; mapping stated in code) | memory 0.78 · vision 0.87 · Calories 0.72 · GDP 0.91 |

## Material notes for dispatch 006

**d'-hat split-half reliability (SB): memory 0.86, vision -0.96, Calories -1.49, GDP -0.36.** The NEGATIVE values outside memory are a staircase/difficulty-control artifact (vision accuracy SD is only 0.017 — the contrast staircase clamps performance, and its negative feedback anticorrelates odd/even d'), so d'-hat carries essentially no stable trait variance outside memory. Consequences: (i) the real d'-confound risk the calibration guarded against is SMALLER than simulated — conservative; (ii) d'-partialing stays in the 006 design as pre-specified but will be near-inert for vision; (iii) real memory d' (mean 1.56, SD 0.56) is more variable than the simulated truncnorm(1.2, 0.3) — partialing matters most exactly where d' is a real trait.

**Real between-subject level SD (0.72-0.91) is below the simulated implied 1.31**, while level reliability is >= 0.95 everywhere — validity unaffected; cross-domain level correlations will simply have somewhat wider CIs than the simulations suggested. No action needed.

## Structural surprises check

Exclusions (>= 60 primary trials + both accuracy classes): memory 1/321, vision 0/322, Calories 0/322, GDP 5/322 — all far below the 15% flag threshold.

FIREWALL note: no cross-domain quantity was computed in this dispatch.

