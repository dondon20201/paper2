# CONFIRMATORY RESULT — memory × vision (dispatch 006)

**Date:** 2026-07-10 · **Code:** `analysis/06_confirmatory_memvis.R` · **Data:** REALDATA, primary trial set · n = 320 both-qualifying, 317 complete-case (listwise, preregistered)

## PRIMARY (CONFIRMATORY — preregistered wording verbatim)

The confirmatory test does not exclude a null gap (corrected gap = 0.11, 95% CI [-0.14, 0.36]). Given ~60% simulated power at a true gap of 0.4 (plausibly somewhat higher given memory's measured reliability), a null gap is **not excluded**; this is not evidence of absence.

| Quantity | Estimate | 95% CI (delta) | Status |
|---|---|---|---|
| Latent ρ_level (raw) | 0.422 | [0.328, 0.515] | VERIFIED, CONFIRMATORY |
| Latent ρ_sens (d′-partialed, corrected) | 0.308 | [0.075, 0.542] | VERIFIED, CONFIRMATORY |
| **Corrected gap (primary outcome)** | **0.113** | **[-0.138, 0.364]** | VERIFIED, CONFIRMATORY |

CFA converged and admissible: TRUE/TRUE. Corrected CI widths ≥ uncorrected (asserted in code). Frozen calibration a = 0.0401, b = 0.7492.

## SECONDARY

- (a) Subject bootstrap (2000, calibration fixed): corrected gap CI [-0.123, 0.379]; corrected ρ_sens CI [0.054, 0.524]; bad fits 0/2000.
- (b) All-trials variant: gap = 0.113 [-0.138, 0.364] (n = 317).
- (c) Uncorrected latent: ρ_sens = 0.271 [0.098, 0.445]; gap = 0.150 [-0.046, 0.347].
- (d) METHODS EXHIBIT ONLY (never evidence): raw manifest r(mean conf) = 0.402 [0.298, 0.492]; raw r(AUROC2) = 0.202 [0.089, 0.314]; naive raw gap = 0.200 [0.051, 0.353].

