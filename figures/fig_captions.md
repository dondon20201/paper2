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
