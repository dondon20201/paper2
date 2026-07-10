# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 005
**Date:** 2026-07-10
**From:** Cowork — 0b″ audited (scoreboard, calibration coefs, CI-honesty all reconcile with raw files). STEP 0 CLOSED: GATE PASSED, NARROW. This is the FIRST REAL-DATA dispatch: Steps 1–2 + the calibration-transfer check. The confirmatory thesis test is dispatch 006, gated on this one.

## Objective
Compute the per-subject measurement layer on the real Lund data (BRIEF Steps 1–2), characterize reliability, and check that the real data's measurement properties match the simulation assumptions the frozen calibration rests on. **Produce NO cross-domain correlation of anything** — that firewall keeps the confirmatory memory×vision test (dispatch 006) unpeeked.

## Context
Locked design from 0b″ §3: LEVEL = mean confidence (raw); SENSITIVITY = AUROC2 only, always d′-partialed; estimator (for 006) = exchangeable-parcel CFA with frozen 200/200 calibration (a=0.040, b=0.749). Real-data outputs are labeled REALDATA the way simulations were labeled SIMULATION.

## Preregistered analysis decisions (fixed now)
- PRIMARY trial set: `repeat_exclude == 0` trials only (the authors flagged those trials; respect it). SENSITIVITY CHECK: all trials. Report both; primary carries the claims.
- Subjects: all 322 present in the raw file; a subject-domain enters a given analysis only if it has ≥ 60 primary trials and both correct and incorrect responses. Report exclusion counts per domain.
- No other filtering. No outlier removal at this stage (robustness variants come later if planned).

## Tasks

1. `analysis/04_realdata_measures.R` — per subject × domain, primary trial set (REALDATA labels):
   a. LEVEL: mean confidence; also over/underconfidence (mean confidence/7 rescaled minus accuracy — state the rescaling explicitly) as the alternate index.
   b. SENSITIVITY: AUROC2 on all qualifying trials; K=4 interleaved parcels for memory/vision, K=2 for Calories/GDP — parcel AUROC2 and parcel mean-conf per parcel (the CFA inputs for 006).
   c. d′-hat per subject-domain (log-linear), for partialing in 006 and for the transfer check.
   d. Save `results/step1_REALDATA_subject_measures.csv` (one row per subject-domain, plus parcel columns) and a compact `results/step1_REALDATA_domain_summary.csv` (per-domain n, means, SDs of each measure). NO cross-domain joins.

2. `analysis/05_realdata_reliability.R` — Step 2 (REALDATA):
   a. Split-half (odd/even interleaved) reliability per measure per domain, Spearman-Brown corrected, bootstrap CIs (2000).
   b. Parcel-level reliability per domain (the quantity the calibration transfer depends on).
   c. Trials-needed curve for AUROC2 in memory and vision: subsample n ∈ {25, 50, 75, 100, 150, 200} trials per subject (3 random subsamples averaged per n, fixed seed), split-half reliability at each n, Spearman-Brown prophecy fit with bootstrap CI on the curve parameter; report trials-to-reliability .5/.7/.8 with CIs. (This is a paper deliverable in its own right.)
   d. Same reliability table for LEVEL (expected near-ceiling — that contrast is also a paper figure).
   e. Save `results/step2_REALDATA_reliability.csv` + curve data.

3. TRANSFER CHECK (`results/step2_REALDATA_transfer_check.md`) — decides whether 006 may run:
   a. Compare, per domain: real parcel AUROC2 reliability vs the simulation's parcel reliability at matching trial counts (pull the simulated values from your 0b/0b″ outputs and state them); real d′ distribution (mean, SD) vs simulated truncnorm(1.2, 0.3); real level SD vs simulated beta SD 0.8 (on comparable scales — state the mapping).
   b. PREREGISTERED RULE: if real memory & vision parcel reliabilities are ≥ 70% of the simulation's matching values (i.e., not more than 30% relatively below), the calibration transfers → declare "006 CLEARED". If below, declare "TRANSFER AT RISK" → 006 waits for one recalibration round at the real data's measured reliability (that would be a small, targeted rerun of 0b″'s calibration, not a new gate philosophy). If real reliabilities are HIGHER than simulated, transfer is conservative → cleared, note it.
   c. Also flag any gross structural surprise (e.g., a domain where >15% of subject-domains fail the inclusion rule) — surprises get reported, not smoothed.

4. Update PROGRESS.md; note explicitly that no cross-domain quantity has been computed yet.

5. OPTIONAL — GitHub remote if Ben provides a URL at run time. (Repo STILL has no backup and now contains real deliverables — press this in your summary.)

6. Report per protocol: overwrite `cowork/REPORT.md`, session-log line, final `docs:` commit.

## Constraints
- **FIREWALL: no cross-domain correlations, no gaps, no latent fits on real data in this dispatch.** Within-domain measurement properties only. The confirmatory shot is 006 and it fires exactly once.
- Every reported number: computed this run, labeled REALDATA, saved to results/, status-labeled per BRIEF §3.
- Preregistered decisions above are fixed; argue in the report if one looks wrong, don't change it.

## Acceptance criteria
- step1/step2 REALDATA files exist with per-domain exclusion counts; reliability tables with CIs; trials-needed curve with CIs.
- Transfer check states "006 CLEARED" or "TRANSFER AT RISK" explicitly, with the numeric comparison shown.
- No cross-domain quantity anywhere in outputs (grep your own results before committing).
- `git status` clean; REPORT.md per template.
