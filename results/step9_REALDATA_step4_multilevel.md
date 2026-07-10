# STEP 4 — Non-ipsative multilevel decomposition (dispatch 008)

**Tier: STEP4_MULTILEVEL (preregistered, NON-CONFIRMATORY).**

**Date:** 2026-07-10 · **Code:** `analysis/09_step4_multilevel.R` · **Data:** REALDATA, primary trial set, step-1 qualifying subject-domains (n = 322 subjects, 1281 subject-domains, 182892 trials)

**Estimand note (binding):** the ICCs below are VARIANCE-SHARE
generalizability indices from a trial-level mixed model — a different
estimand from Step 3's latent cross-domain correlations. The random
accuracy slope measures confidence RESOLUTION (Δconf correct−incorrect),
not AUROC2, and is NOT d′-partialed (the d′ confound is quantified in the
diagnostics, not removed). Nothing here confirms, disconfirms, or re-tests
the 006 confirmatory result; the 'null not excluded' wording of 006 stands.

## Decomposition

Ladder rung: **M1** (converged TRUE, singular FALSE). Bootstrap: B = 500, 500 ok / 0 failed / 0 escalated (FULL, STABLE).

| Quantity | Estimate | 95% CI (cluster bootstrap) | Status |
|---|---|---|---|
| ICC_level (person-general share of set-point variance) | 0.44 | [0.37, 0.52] | VERIFIED, NON-CONFIRMATORY |
| ICC_sens (person-general share of resolution variance) | 0.34 | [0.26, 0.42] | VERIFIED, NON-CONFIRMATORY |
| Δ_ICC | 0.11 | [0.00, 0.21] | VERIFIED, NON-CONFIRMATORY |

As a preregistered secondary finding, stated with hedges: in this dataset and under this model, the person-general variance share was 0.44 for the set-point and 0.34 for resolution (Delta_ICC = 0.11, 95% bootstrap CI [0.00, 0.21], CI excluding zero). This is a variance-share result, not a re-test of the confirmatory latent-correlation gap.

## Secondary / robustness

- R1 (confidence z-scored within domain, rung M1): ICC_level = 0.44, ICC_sens = 0.36 — consistent with the raw-scale decomposition.
- R2 (ordinal cumulative-link mixed model): COMPLETED — ICC_level = 0.43, ICC_sens = 0.32
- Exploratory diagnostics: see `step9_REALDATA_step4_diagnostics.csv` — the resolution-slope BLUPs' correlation with d′-hat quantifies the standing d′ confound (the LMM slope is not d′-partialed).

## Ipsative exhibit (METHODS EXHIBIT ONLY — never evidence)

The naive mean-subtraction analysis on the same trials yields centered domain-mean correlations from -0.667 to 0.083 (mean -0.298) across the six pairs — the mechanical negativity the non-ipsative model exists to avoid (cf. the simulation exhibit, where the same computation manufactures ≈ −1/3 under a planted null structure while the LMM recovers the planted shares).

## Honest reading

What this tier supports: a decomposition of confidence variance into
person-general vs person×domain shares for set-point and resolution,
with cluster-bootstrap uncertainty, free of the ipsative artifact.
What it does NOT support: any claim about the Step-3 latent gap, any
confirmatory-style wording, or treating the resolution slope as
metacognitive sensitivity in the AUROC2 sense. The resolution slope
carries a known, quantified d′ confound and its domain-specific share is
partly measurement noise at 100-trial domains.

