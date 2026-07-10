# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 006
**Date:** 2026-07-10
**From:** Cowork — 005 fully audited AND independently re-derived: every reported number was reproduced from the raw trial file with Cowork's own code (domain summaries, all split-half SB reliabilities incl. the negative d′ values, parcel reliabilities, sim denominators 0.177/0.191 via the stated step-down, implied level SD 1.31, transfer ratios ~3.1/1.5). **005's "006 CLEARED" verdict stands under the preregistered rule.** THIS DISPATCH IS THE CONFIRMATORY SHOT. It fires exactly once.

## Objective
The preregistered confirmatory test of the thesis on the memory×vision pair: is confidence LEVEL more domain-general than confidence INFORMATIVENESS? Produce corrected latent ρ_level, corrected ρ_sens, and the corrected gap with a delta-method 95% CI, using the locked estimator. One run; the primary numbers are final once written.

## Locked design being executed (0b″ §3 — do not deviate, do not relitigate)
- LEVEL: mean-confidence parcels, raw, NO correction. SENSITIVITY: AUROC2 parcels, ALWAYS d′-partialed — reuse the EXACT partialing code path validated in the step-0b′/0b″ gate scripts (no new method choices; state in the report precisely what that path does).
- Estimator: exchangeable-parcel latent CFA, K=4 × K=4 (`fit_latent` in `R/parcels.R`), on the committed parcel columns of `results/step1_REALDATA_subject_measures.csv` used AS-IS (they are preregistration-clean; do not recompute).
- Correction: FROZEN 200/200 calibration (a=0.040, b=0.749) applied to ρ_sens exactly as implemented/validated in `analysis/03_calibrated_gate.R`; corrected gap = ρ_level − corrected ρ_sens; delta-method CI propagated with `cov_rs_rl` from the fit. Corrected CIs must be ≥ as wide as uncorrected (0b″ property — assert it).

## Preregistered decisions (fixed now, before any cross-domain number exists)
1. **Sample:** primary trial set (`repeat_exclude==0`); subjects qualifying in BOTH memory and vision (expected n=320). Missing parcels (3 memory subjects have one single-accuracy-class parcel): listwise deletion — the validated gate machinery ran on complete data — expected analysis n=317. Report both counts.
2. **PRIMARY OUTCOME:** corrected gap with delta-method 95% CI. Preregistered wording (fill numbers, change nothing else):
   - CI excludes 0, gap > 0 → "On the confirmatory memory×vision pair, confidence level was more domain-general than confidence informativeness (corrected gap = X, 95% CI [L, U])."
   - CI includes 0 → "The confirmatory test does not exclude a null gap (corrected gap = X, 95% CI [L, U]). Given ~60% simulated power at a true gap of 0.4 (plausibly somewhat higher given memory's measured reliability), a null gap is **not excluded**; this is not evidence of absence."
   - CI excludes 0, gap < 0 → "The confirmatory test showed the REVERSE pattern (corrected gap = X, 95% CI [L, U])" — reported with exactly the same prominence.
3. **SECONDARY (labeled SECONDARY, computed in the same single run, written after the primary block):**
   a. bootstrap-over-subjects CI (2000 resamples) on the corrected gap, as a delta-method complement;
   b. all-trials variant (same pipeline);
   c. uncorrected latent ρ_level / ρ_sens / gap (doubles as the methods "uncorrected-latent spurious gap" exhibit);
   d. raw manifest correlations (cross-domain r of mean_conf; of AUROC2; naive gap) — METHODS EXHIBIT ONLY, labeled as the demonstration that raw contrasts invent the thesis under a null, never as evidence.
4. **One-shot discipline:** a script error BEFORE outputs are written may be fixed and rerun (errors ≠ peeking). Once `results/step6_REALDATA_confirmatory.csv` exists, the primary numbers are final: any later-discovered bug → report BOTH original and corrected numbers, never silently replace. No estimator tweaks, no alternative specs beyond §3.
5. If the primary CFA is non-converged/inadmissible after `fit_latent`'s bounded fallback: STOP, write the diagnostics to the report, and dispatch back to Cowork — do not improvise a new estimator.

## Tasks
1. `analysis/06_confirmatory_memvis.R` implementing exactly the above. Provenance guard (raw md5) even though inputs come from step1 CSV — assert the step1 file is the committed version (git-diff clean before running).
2. Outputs: `results/step6_REALDATA_confirmatory.csv` (primary + all secondary estimates, SEs, CIs, convergence/admissibility flags, n's) and `results/step6_REALDATA_confirmatory.md` (verdict document using the preregistered wording verbatim, CONFIRMATORY label on the primary block).
3. Update PROGRESS.md — and fold in the session-1 close-out row from `cowork/sessions/2026-07-10-session-01.md` (standing item).
4. GitHub remote — **URL PROVIDED, six dispatches in: `https://github.com/dondon20201/paper2.git`.** Wire it (`git remote add origin`), push master with `-u`, and confirm the push (with the pushed HEAD hash) in the report. If auth fails, say so explicitly in the report and tell Ben what he needs to run (e.g. `gh auth login`) — do not silently skip. This is no longer optional; the repo will contain the paper's confirmatory result.
5. Report per protocol: overwrite `cowork/REPORT.md`, session-log line, final `docs:` commit.

## Constraints
- Every number: computed this run, labeled REALDATA, status-labeled per BRIEF §3; the primary additionally labeled CONFIRMATORY.
- Report must state the d′-partialing implementation in one sentence and confirm it is byte-identical in logic to the gate scripts'.
- Argue in the report if a preregistered decision looks wrong — do not change it.

## Acceptance criteria
- step6 CSV + MD exist; primary corrected gap with delta-method CI present; wording template matched verbatim; corrected CI ≥ uncorrected CI width; secondary blocks labeled; convergence flags TRUE; PROGRESS.md updated incl. fold-in; `git status` clean.
