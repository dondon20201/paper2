# Step 5b — Confidence Database level-vs-sensitivity contrast (dispatch 010)

**Data:** REALDATA-EXTERNAL (CONFDB), md5-verified at fetch (dispatch 009) and re-guarded at every raw read this run. **Status: VERIFIED** (every number below computed this run by `analysis/15_confdb_contrast.R`; saved in `results/step15_CONFDB_contrast.csv`).

**TIER: CONFDB ROBUSTNESS, NON-CONFIRMATORY.** No calibration correction exists for these study configurations — the frozen Lund 200/200 calibration does not transfer — so nothing here is a confirmatory test. The yardsticks are (a) per-study SIMULATION null-reference intervals for the raw gap (`analysis/14_confdb_nullref.R`) and (b) disattenuation RANGES (never a corrected point value).

## Taxonomy (binding for all write-ups)

This tier tests **TASK-generalization**, with exactly one external cross-domain pair. Only **Arbuzova_unpub_3 memory x visual** is a cross-DOMAIN pair. Arbuzova_2021_expt2 is a visuomotor **condition x condition** pair; Bang_2019_Exp2 (coarse x fine Gabor) and Haddara_2022_Expt1 (letter x color grids) are cross-TASK pairs **within vision**. These four studies must never be presented as four cross-domain replications.

## Primary results (pre-specified pairs; subject bootstrap, B = 2000, seed 20260711)

| Study | Pair | n | r_level [95% CI] | r_sens (d'-partialed) [95% CI] | gap [95% CI] |
|---|---|---|---|---|---|
| Arbuzova_2021_expt2 | task 1 x task 2 (visuomotor, condition x condition) | 41 | 0.550 [0.215, 0.799] | 0.243 [-0.085, 0.513] | 0.307 [-0.117, 0.729] |
| Arbuzova_unpub_3 | memory x visual (CROSS-DOMAIN) | 40 | 0.560 [0.253, 0.762] | -0.097 [-0.350, 0.143] | 0.657 [0.297, 0.968] |
| Bang_2019_Exp2 | task 1 x task 2 (coarse x fine Gabor, within vision) | 201 | 0.574 [0.452, 0.676] | 0.067 [-0.050, 0.194] | 0.508 [0.354, 0.653] |
| Haddara_2022_Expt1 | task 1 x task 2 (letter x color grids, within vision) | 443 | 0.872 [0.841, 0.900] | 0.561 [0.488, 0.626] | 0.311 [0.247, 0.383] |

## Yardsticks per study (disattenuation ranges + SIMULATION null reference)

| Study | r_level disatt. range | r_sens disatt. range | raw gap [95% CI] | null-ref interval (rho=0.30) | null-ref interval (rho=0.45) |
|---|---|---|---|---|---|
| Arbuzova_2021_expt2 | [0.551, 0.554] | [0.258, 0.308] | 0.139 [-0.224, 0.472] | [-0.357, 0.520] | [-0.308, 0.466] |
| Arbuzova_unpub_3 | [0.567, 0.590] | [-0.251, -0.118] | 0.551 [0.188, 0.873] | [-0.315, 0.505] | [-0.239, 0.531] |
| Bang_2019_Exp2 | [0.580, 0.585] | [0.079, 0.094] | 0.170 [0.025, 0.317] | [-0.117, 0.253] | [-0.063, 0.257] |
| Haddara_2022_Expt1 | [0.876, 0.878] | [0.640, 0.689] | 0.128 [0.086, 0.173] | [-0.083, 0.183] | [-0.042, 0.186] |

Disattenuation ranges are r / sqrt(rel_a x rel_b) evaluated at the committed step11 reliability point estimates and at both reliability CI bounds — a sensitivity RANGE, not a corrected estimate. The null-reference intervals are the 2.5–97.5% span of the RAW gap under a SIMULATED true-null world (true r_level = true r_sens = rho) matched to each study's n / trials / scale / reliabilities: they quantify how much raw-gap inflation differential attenuation alone produces. They are a simulation reference, not a correction and not a test.

## Reading each study (pre-specified criteria)

The Lund pattern **holds** in a study only if r_level exceeds the TOP of r_sens's disattenuated range AND the raw gap exceeds the null-reference interval under both null scenarios; one condition met = **partial**; neither = **fails**.

- **Arbuzova_2021_expt2: partial.** r_level = 0.550 EXCEEDS the top of r_sens's disattenuated range (0.308); raw gap does NOT exceed the null-reference interval (0.139 vs upper bounds 0.520 / 0.466).
- **Arbuzova_unpub_3: holds.** r_level = 0.560 EXCEEDS the top of r_sens's disattenuated range (-0.118); raw gap EXCEEDS the null-reference interval (0.551 vs upper bounds 0.505 / 0.531).
- **Bang_2019_Exp2: partial.** r_level = 0.574 EXCEEDS the top of r_sens's disattenuated range (0.094); raw gap does NOT exceed the null-reference interval (0.170 vs upper bounds 0.253 / 0.257).
- **Haddara_2022_Expt1: partial.** r_level = 0.872 EXCEEDS the top of r_sens's disattenuated range (0.689); raw gap does NOT exceed the null-reference interval (0.128 vs upper bounds 0.183 / 0.186).

## Secondaries

| Unit | Definition | n | r_level [95% CI] | r_sens [95% CI] | gap [95% CI] |
|---|---|---|---|---|---|
| B-s1 | Bang, committed catch-included measures | 201 | 0.573 [0.448, 0.676] | 0.104 [-0.018, 0.226] | 0.469 [0.320, 0.615] |
| B-s2 | Bang, recomputed, without author-excluded 179-201 | 178 | 0.560 [0.425, 0.674] | 0.100 [-0.021, 0.232] | 0.461 [0.295, 0.613] |
| H-s1 feedback | Haddara, Task-1 feedback group | 225 | 0.871 [0.827, 0.907] | 0.575 [0.479, 0.658] | 0.296 [0.213, 0.392] |
| H-s1 no-feedback | Haddara, Task-1 no-feedback group | 218 | 0.875 [0.828, 0.913] | 0.522 [0.406, 0.621] | 0.353 [0.250, 0.467] |

H-s1 is a heterogeneity check only — two correlations reported side by side, no test.

### Scale-robustness (Spearman) and the d' confound exhibit

| Study | Spearman r_level [95% CI] | Spearman r_sens [95% CI] | r_sens_raw (un-partialed) [95% CI] |
|---|---|---|---|
| Arbuzova_2021_expt2 | 0.565 [0.270, 0.779] | 0.132 [-0.169, 0.423] | 0.410 [0.183, 0.603] |
| Arbuzova_unpub_3 | 0.484 [0.170, 0.737] | -0.139 [-0.399, 0.164] | 0.008 [-0.283, 0.281] |
| Bang_2019_Exp2 | 0.557 [0.440, 0.661] | 0.127 [-0.001, 0.261] | 0.404 [0.281, 0.517] |
| Haddara_2022_Expt1 | 0.872 [0.839, 0.899] | 0.530 [0.450, 0.600] | 0.743 [0.700, 0.784] |

## Exploratory: Arbuzova_unpub_3, all six pairs

EXPLORATORY. motor and visuomotor are two conditions of one skittles paradigm (study readme), so only memory x visual is a clean cross-domain pair.

| Pair | n | r_level [95% CI] | r_sens [95% CI] | gap [95% CI] |
|---|---|---|---|---|
| memory x motor | 36 | 0.450 [0.157, 0.695] | -0.032 [-0.350, 0.248] | 0.482 [0.035, 0.943] |
| memory x visual | 40 | 0.560 [0.253, 0.762] | -0.097 [-0.350, 0.143] | 0.657 [0.297, 0.968] |
| memory x visuomotor | 36 | 0.600 [0.340, 0.785] | 0.092 [-0.210, 0.353] | 0.508 [0.109, 0.899] |
| motor x visual | 36 | 0.485 [0.231, 0.744] | 0.213 [-0.123, 0.579] | 0.272 [-0.140, 0.670] |
| motor x visuomotor | 36 | 0.879 [0.806, 0.938] | 0.531 [0.265, 0.755] | 0.348 [0.102, 0.623] |
| visual x visuomotor | 36 | 0.365 [0.059, 0.654] | 0.091 [-0.249, 0.434] | 0.274 [-0.159, 0.689] |

## Honest reading

(i) This entire tier is **NON-CONFIRMATORY / ROBUSTNESS**: the four studies were selected mechanically (dispatch 009), but no calibration correction exists for their configurations, so none of these estimates carries the confirmatory status of the Lund memory x vision result. (ii) **Raw gaps are inflated by differential attenuation**: LEVEL is measured near-perfectly (committed split-half reliabilities 0.97–1.00) while AUROC2 is not (0.62–0.90), so a positive raw gap is expected even in a true-null world — each observed raw gap must be compared to its SIMULATION null-reference interval before any interpretation. (iii) Per the pre-specified criteria, the Lund pattern **holds** in 1 of 4 studies, is **partial** in 3, and **fails** in 0 (study-by-study statements above). Where the pattern does not hold, a null is **not excluded** (it is never 'absent' — sensitivity here is weakly measured, not proven undifferentiated). No meta-analytic pooling is performed across the four studies (heterogeneous tasks, scales, and populations; forest display only, dispatch 010). Because Bang and Haddara are within-vision task pairs and Arbuzova_2021 is a condition pair, **no claim of cross-domain generality is made from them**; the only external cross-domain evidence in this tier is the single Arbuzova_unpub_3 memory x visual pair.

## Provenance / run info

- Inputs: committed `results/step11_CONFDB_measures.csv` (asserted 1,525 rows) and `results/step11_CONFDB_reliability.csv`; raw files re-read this run with md5 guards: `data_Bang_2019_Exp2.csv` (e697b4615d6f3da5fa7c10342d16dfe2), `data_Haddara_2022_Expt1.csv` (fbe82cb5185b41d67894e429c8be1699).
- Bang recompute: 40200 clean trials, 1206 catch trials dropped (3.0%); 402 subject-task rows; author-excluded subjects 179-201 KEPT in the primary (mechanical criteria only), removed in B-s2.
- Haddara feedback groups (from raw, between-subject, Task 1 only): feedback = 225, no_feedback = 218.
- Estimator: r_sens = Pearson correlation of AUROC2 residualized (OLS, within study-task, on the analysis sample) on the same-task d'-hat; residualization recomputed inside every bootstrap resample. Subjects: >= 60 clean trials in BOTH tasks, listwise complete.
- Part A null-reference gate: PASS.
- R version 4.6.1 (2026-06-24 ucrt); bootstrap B = 2000, percentile, seed 20260711 per analysis unit.
