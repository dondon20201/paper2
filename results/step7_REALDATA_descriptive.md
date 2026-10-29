# DESCRIPTIVE TIER — five remaining domain pairs (dispatch 007)

**Date:** 2026-07-10 · **Code:** `analysis/07_descriptive_pairs.R` · **Data:** REALDATA, primary trial set, committed step-1 parcel columns AS-IS

**Every row below except the marked confirmatory one is NON-CONFIRMATORY / DESCRIPTIVE.**
These four 200/100 configurations and the 100/100 configuration FAILED the blind
calibration gate in step 0b'' — so their sensitivity correlations and gaps are
reported UNCORRECTED, with the frozen systematic bias band attached to each gap
(±0.09 for 200/100 pairs, ±0.10 for Calories × GDP) instead of a calibration
correction. The memory × vision row is the dispatch-006 confirmatory result,
copied verbatim from `results/step6_REALDATA_confirmatory.csv` — NOT recomputed.

| Pair | K | n both / complete | ρ_level [95% CI] | ρ_sens [95% CI] | Gap [95% CI] ± band | Status |
|---|---|---|---|---|---|---|
| **memory × vision** | 4/4 | 320 / 317 | 0.422 [0.328, 0.515] | 0.308 [0.075, 0.542] (corrected) | 0.113 [-0.138, 0.364] (corrected, no band) | **CONFIRMATORY (dispatch 006)** |
| memory × Calories | 4/2 | 320 / 317 | 0.375 [0.276, 0.474] | 0.395 [0.195, 0.595] | -0.020 [-0.243, 0.203] ± 0.09 (systematic) | NON-CONFIRMATORY, DESCRIPTIVE |
| memory × GDP | 4/2 | 315 / 312 | 0.323 [0.218, 0.427] | 0.456 [0.239, 0.673] | -0.133 [-0.374, 0.108] ± 0.09 (systematic) | NON-CONFIRMATORY, DESCRIPTIVE |
| vision × Calories | 4/2 | 322 / 322 | 0.450 [0.359, 0.541] | 0.256 [0.047, 0.465] | 0.194 [-0.034, 0.421] ± 0.09 (systematic) | NON-CONFIRMATORY, DESCRIPTIVE |
| vision × GDP | 4/2 | 317 / 317 | 0.464 [0.374, 0.554] | 0.168 [-0.058, 0.394] | 0.296 [0.055, 0.537] ± 0.09 (systematic) | NON-CONFIRMATORY, DESCRIPTIVE |
| Calories × GDP | 2/2 | 317 / 317 | 0.473 [0.382, 0.564] | 0.237 [-0.024, 0.498] | 0.237 [-0.039, 0.512] ± 0.10 (systematic) | NON-CONFIRMATORY, DESCRIPTIVE |

## Honest reading (what is and is not claimable from this tier)

Across the 5 estimable descriptive pairs, uncorrected latent ρ_level ranged 0.323–0.473, uncorrected ρ_sens ranged 0.168–0.456, and the uncorrected gap ranged -0.133–0.296. The confidence intervals above capture SAMPLING uncertainty only; the ±band on each descriptive gap is a separate, additive SYSTEMATIC allowance — the frozen worst-case estimator bias observed in the 0b'' simulations at these trial counts, where the calibration correction could not be validated. A descriptive gap whose CI excludes zero is therefore still NOT a positive finding if it sits within its band of zero (and even one that clears both is descriptive, not a test — nothing in this tier was pre-specified as confirmatory). What this table legitimately supports: (1) the cross-domain correlation LANDSCAPE for the paper's summary table, with honest uncertainty in both channels; (2) a consistency check — do the descriptive pairs point the same direction as the confirmatory memory × vision result (gap = 0.113 [−0.138, 0.364], null not excluded)? What it does NOT support: any claim that a specific descriptive gap is nonzero, any cross-pair meta-analytic combination (the pairs share subjects and the bands are correlated across pairs), or any confirmatory-style wording. The sensitivity correlations here are UNCORRECTED and known from simulation to be attenuated at these trial counts — they are lower bounds in expectation, not estimates of the latent truth.

