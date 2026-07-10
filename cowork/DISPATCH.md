# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 007
**Date:** 2026-07-10
**From:** Cowork — 006 AUDITED AND CONFIRMED. Independent re-derivation (method-of-moments latent correlations, exact manifest block, calibration-line refit from committed replicates) reproduced every primary and secondary number: ρ_level 0.42, corrected ρ_sens 0.31, corrected gap 0.11 [−0.14, 0.36] → null not excluded, exactly as the preregistered wording states. The confirmatory result is FINAL and in the can. This dispatch is the DESCRIPTIVE TIER — the five remaining domain pairs, all labeled NON-CONFIRMATORY.

## Objective
Complete the cross-domain correlation table for the paper: the four 200/100 pairs (memory×Calories, memory×GDP, vision×Calories, vision×GDP) and Calories×GDP (100/100), with the preregistered bias bands in place of the calibration correction (those configs FAILED the blind calibration gate in 0b″ — they get bands, not corrections, and never confirmatory status).

## Preregistered decisions (fixed now — from the locked 0b″ §3 design)
1. Inputs: committed parcel columns of `results/step1_REALDATA_subject_measures.csv` AS-IS (no recomputation). Primary trial set. Per pair: both-qualifying subjects, listwise complete-case (report both n's per pair).
2. Estimator: identical machinery to 006 — `fit_latent` (K=4 for memory/vision, K=2 for Calories/GDP), sensitivity parcels d′-partialed via `partial_out_dprime` (same-domain d′-hat), level parcels raw.
3. NO calibration correction anywhere in this dispatch. Report uncorrected latent ρ_level, ρ_sens, gap per pair with delta-method CIs, PLUS the frozen bias bands on the gap: ±0.09 for the four 200/100 pairs; ±0.10 for Calories×GDP (the conservative end of the 004 ±0.09–0.10 range — fixed here). Present each gap as "estimate [CI] ± band (systematic)".
4. Labels: every row NON-CONFIRMATORY / DESCRIPTIVE. The paper's summary table may juxtapose the 006 memory×vision row (copied verbatim from `step6_REALDATA_confirmatory.csv`, marked CONFIRMATORY) — do NOT recompute it.
5. If any pair's CFA is non-converged/inadmissible after the bounded fallback: report that pair as NOT ESTIMABLE with diagnostics; do not improvise (2-parcel factors are identified only through the exchangeability constraints — fragility is a reportable finding, not a bug to fix silently).
6. No new quantities beyond the above (no Step 4/5 material — those are later dispatches).

## Tasks
1. `analysis/07_descriptive_pairs.R` — the five pairs per §2–3. Provenance guards as in 006 (raw md5 + git-clean check on the step1 input).
2. Outputs: `results/step7_REALDATA_descriptive.csv` (per pair: ρ_level, ρ_sens_uncorrected, gap, SEs, delta CIs, bias band, n_both, n_complete, converged/admissible) and `results/step7_REALDATA_descriptive.md` — the full 6-pair summary table (5 descriptive + the 006 confirmatory row clearly marked), with a one-paragraph honest reading: bands vs CIs, what is and is not claimable from this tier.
3. Update PROGRESS.md (006 final result + descriptive tier).
4. **GitHub push — still pending.** 006's remote wiring was denied because the URL came from a file. Ben must paste it directly in the Claude Code chat: `add remote https://github.com/dondon20201/paper2.git and push`. If he does so this session: wire, `git push -u origin master`, and confirm the pushed HEAD hash in the report.
5. Report per protocol: overwrite `cowork/REPORT.md`, session-log line, final `docs:` commit.

## Constraints
- FIREWALL variant for this tier: computing these five pairs is now permitted (006 has fired), but NOTHING here is confirmatory and the report must never phrase a descriptive gap as a test result.
- Every number: computed this run, labeled REALDATA + NON-CONFIRMATORY, saved to results/, status per BRIEF §3.
- Preregistered decisions fixed; argue in the report if one looks wrong, don't change it.

## Acceptance criteria
- step7 CSV/MD exist with all five pairs (or explicit NOT-ESTIMABLE rows); bias bands present on every gap; 006 row copied not recomputed; convergence flags reported; PROGRESS.md updated; `git status` clean; push confirmed or explicitly still-blocked with the reason.
