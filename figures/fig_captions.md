# Figure captions (dispatch 008, Part C)

## Figure 1 — `figures/fig_landscape.pdf/.png` (data: `results/fig_landscape_data.csv`)

**Cross-domain correlation landscape.** Top: latent correlation of confidence
level (set-point) for each of the six domain pairs, with 95% delta-method CIs.
Bottom: the gap (ρ_level − ρ_sens) per pair. memory × vision (filled point) is
the preregistered CONFIRMATORY pair (dispatch 006): its ρ_sens is
calibration-corrected and its gap carries no systematic band. The five open
points are NON-CONFIRMATORY / DESCRIPTIVE (dispatch 007): their sensitivity
correlations are uncorrected (these trial-count configurations failed the
blind calibration gate), and each gap therefore carries a shaded rectangle —
the frozen systematic-bias allowance (±0.09 for 200/100-trial pairs, ±0.10 for
Calories × GDP). **The shaded bands are systematic-bias allowances, NOT
confidence intervals**; whiskers are sampling CIs only. Note vision × GDP: its
CI excludes 0, but its lower bound (0.055) lies inside its ±0.09 band, so no
nonzero-gap claim is made for any descriptive pair. The confirmatory result
(gap = 0.113, 95% CI [−0.138, 0.364]) does not exclude a null gap.

## Figure S1 — `figures/figS_gap_vs_reliability.pdf/.png` (data: `results/figS_gap_vs_reliability_data.csv`)

**EXPLORATORY: gap vs sensitivity measurement quality.** Each pair's gap
(as in Figure 1) against the geometric mean of its two domains' raw,
PRE-PARTIALING AUROC2 parcel reliabilities (memory 0.546, vision 0.273,
Calories 0.306, GDP 0.242; `results/step2_REALDATA_reliability.csv`). No line
is fitted, no correlation computed, no test performed: with six non-independent
points this display is EXPLORATORY. The measurement-lens reading — the
level-advantage appears where sensitivity is least reliably measured and
reverses where it is best measured (memory pairs) — is offered as
interpretation of residual attenuation, not as a tested result.

## Figure 2 — `figures/fig_confdb_contrast.pdf/.png` (data: `results/fig_confdb_contrast_data.csv`)

**Confidence Database level-vs-sensitivity contrast (NON-CONFIRMATORY, robustness tier) with the Lund confirmatory pair for comparison.** Left: cross-task correlations of confidence LEVEL (filled) and metacognitive sensitivity (open; CD rows d'-partialed AUROC2, Lund row calibration-corrected) with 95% CIs; gray brackets are the r_sens disattenuation RANGES (r / sqrt(rel_a x rel_b) at the committed reliability point estimates and both CI bounds) — sensitivity ranges, never corrected point values. Right: the RAW gap (r_level - r_sens_raw) per CD study with 95% CI, against SIMULATION null-reference intervals — the 2.5-97.5% span of the raw gap in a true-null world (true r_level = true r_sens = 0.30 dotted / 0.45 dashed) matched to each study's n, trials, scale, and reliabilities. **Raw gaps are inflated by differential attenuation** (level split-half reliabilities 0.97-1.00 vs AUROC2 0.62-0.90), so a positive raw gap is expected even under a true null; only Arbuzova_unpub_3 memory x visual exceeds its null-reference intervals (raw gap 0.551 vs upper bounds 0.505 / 0.531). This tier tests TASK-generalization with exactly one external cross-domain pair: only Arbuzova_unpub_3 memory x visual is cross-DOMAIN; Arbuzova_2021_expt2 is a visuomotor condition x condition pair, and Bang_2019_Exp2 and Haddara_2022_Expt1 are within-vision task pairs — these four studies are not four cross-domain replications. The Lund row (top) is the preregistered CONFIRMATORY (corrected) result: its gap (0.113, 95% CI [-0.138, 0.364]) does not exclude a null. Null-reference intervals are a simulation reference, not a correction and not a test.
