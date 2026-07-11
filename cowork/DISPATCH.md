# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 010
**Date:** 2026-07-11
**From:** Cowork — 009 AUDITED AND CONFIRMED (selection flags re-applied mechanically for all 180 studies with zero mismatches; Bang measures re-derived to 0.000000 across 402 cells; reliabilities to 4 decimals; firewall verified in code; push verified = 037c79a). One logged report error to correct here (see Part D). This dispatch is **Step 5b: the Confidence-Database level-vs-sensitivity contrast** in the 4 selected studies. **Tier: CONFDB ROBUSTNESS, NON-CONFIRMATORY** — no calibration correction exists for these configs (the frozen Lund 200/200 calibration does NOT transfer), so nothing here is a confirmatory test; the yardstick is a per-study simulated null reference plus disattenuation RANGES (never a corrected point value, per BRIEF).

## Objective
(A) Small simulation gate: per-study null-reference intervals for the RAW gap under a true-null world with the observed unequal reliabilities — quantifying how much raw-gap inflation differential attenuation alone produces at each study's n/trials/scale. (B) The contrast: per study, cross-task correlation of LEVEL and of d′-partialed AUROC2, the gap, bootstrap CIs, disattenuation ranges, preregistered secondaries. (C) One summary figure + data CSV. (D) Housekeeping incl. the 009 report correction.

## Preregistered decisions (fixed now — argue in the report if one looks wrong; do not change it)

### Study/pair definitions (PRIMARY pair per study; everything else labeled EXPLORATORY)
1. Arbuzova_2021_expt2: Task 1 × Task 2 (only pair).
2. Arbuzova_unpub_3: PRIMARY = memory × visual (best-pair n=40; motor/visuomotor are two conditions of one skittles paradigm per the readme, so mem×vis is the cleanest cross-domain pair). All 6 pairs additionally reported in one exploratory table.
3. Bang_2019_Exp2: Task 1 × Task 2 (coarse × fine Gabor).
4. Haddara_2022_Expt1: Task 1 × Task 2 (letter × color grids).
- **Taxonomy (binding for all write-ups):** only Arbuzova_unpub_3 mem×vis is a cross-DOMAIN pair; Arbuzova_2021 is visuomotor-condition×condition; Bang and Haddara are cross-TASK within vision. The report and MD must present this tier as testing TASK-generalization, with exactly one external cross-domain pair — never oversell it as four cross-domain replications.

### Subjects & cleaning
- Subjects: S1-qualified only for the pair (≥60 clean trials in BOTH tasks), listwise; n reported per study.
- Inputs: the committed `results/step11_CONFDB_measures.csv` AS-IS — EXCEPT Bang, whose primary measures are recomputed from raw with the identical 009 cleaning rules PLUS dropping `Catch_trial==1` (~3%; not genuine discrimination trials; 009 flagged that its rules did not drop them). Bang secondary B-s1 = committed catch-included measures (quantifies the difference). Document the recompute; md5-guard the raw file.
- Bang author-excluded subjects (readme: subjects 179–201 excluded by the AUTHORS for poor performance but present in the file): PRIMARY = keep them (our mechanical criteria only — no post-hoc performance exclusions, which could bias metacognition estimates); secondary B-s2 = without them. Both reported.
- Haddara feedback manipulation (Task 1 only, between-subject): PRIMARY = pooled; secondary H-s1 = split by feedback group (two correlations, reported as a heterogeneity check, no test).

### Estimator (per study, primary pair)
- r_level = Pearson correlation across tasks of LEVEL (the scale-normalized mean confidence already in the measures CSV).
- r_sens = Pearson correlation across tasks of AUROC2 residualized on the SAME-TASK d′-hat (OLS residualization within study-task, same logic as the Lund `partial_out_dprime`; d′-hats are in the measures CSV). Raw un-partialed r_sens_raw = secondary (the d′-confound exhibit, consistent with the locked Lund design where sensitivity is ALWAYS d′-partialed for primary readouts).
- gap = r_level − r_sens. CIs: subject bootstrap within study, B = 2000, percentile, seed 20260711.
- **Disattenuation: RANGE ONLY, never a point** (BRIEF §1 collapsed-claim 3). For r_sens report r_sens / sqrt(rel_a·rel_b) computed at (i) the committed step11 reliability point estimates and (ii) both reliability CI bounds → a [min, max] corrected range per study. Same for r_level (it will barely move — that asymmetry IS the message). Any statement about the gap must hold across the entire range to be stated at all.
- Scale-robustness secondary (BRIEF Step 5 requirement): Spearman versions of r_level and r_sens per study, one table row each.

### Part A — null-reference gate (`analysis/14_confdb_nullref.R`; runs FIRST)
For each study: simulate the null world — true r_level = true r_sens = SAME value ρ ∈ {0.3, 0.45} (two null-gap scenarios), two tasks, matched n subjects, matched trials/task, matched confidence scale (discretized), accuracy ≈ observed, with per-task sensitivity/level noise tuned so the SIMULATED split-half reliabilities reproduce the study's committed step11 reliabilities (tolerance ±0.05; report achieved values). 500 replicates per study×scenario, seeds 20260711+rep. Output: the 2.5–97.5% interval of the RAW gap under each null → `results/step14_SIMULATION_confdb_nullref.csv` + meta JSON. PASS criterion (gate, pre-declared): the simulator reproduces the target reliabilities within ±0.05 in ≥ 3 of 4 studies; if it fails, report and SKIP the null-reference columns (Part B still runs, with the disattenuation ranges as the only yardstick — say so plainly). These intervals are a SIMULATION REFERENCE, not a correction and not a test.

### Part B — the contrast (`analysis/15_confdb_contrast.R`; gate-independent, but reads Part A output if present)
Outputs `results/step15_CONFDB_contrast.csv` (one row per study×quantity: r_level, r_sens, r_sens_raw, gap, CIs, disattenuation ranges, null-reference interval, n, secondaries flagged) and `results/step15_CONFDB_contrast.md` with: the per-study table; the taxonomy paragraph; and an honest-reading paragraph that must state (i) NON-CONFIRMATORY/ROBUSTNESS tier, (ii) raw gaps are inflated by differential attenuation — compare each observed raw gap to its null-reference interval before any interpretation, (iii) "holds/fails" per study stated qualitatively: the Lund pattern "holds" in a study only if r_level exceeds the TOP of r_sens's disattenuated range AND the raw gap exceeds the null-reference interval; partial or failed replications are reported with exactly those words.
- WORDING RULES carried over verbatim: a null is "not excluded," never "absent"; no meta-analytic pooling across the 4 studies (heterogeneous tasks/scales; forest display only); no claim of cross-domain generality from within-vision pairs.

### Part C — figure (`analysis/16_confdb_figure.R`)
`figures/fig_confdb_contrast.pdf/.png` (300 dpi): per study (4 rows, primary pairs only), r_level and r_sens points with bootstrap CI whiskers, the r_sens disattenuated range drawn as a bracket, the null-reference raw-gap interval shown per row (distinct style), Lund's memory×vision confirmatory row included at top for visual comparison (values copied from step6 CSV with an assertion, marked CONFIRMATORY (corrected); all CD rows marked NON-CONFIRMATORY (robustness)). Caption in `figures/fig_captions.md` (append) carries the taxonomy sentence + attenuation warning. Underlying data → `results/fig_confdb_contrast_data.csv`.

### Part D — housekeeping
1. **Correct the 009 report error:** REPORT.md (last dispatch) claimed "all 361 files are version 1" — false; the manifest records 8 files at OSF v2–v4. Add a dated correction line to PROGRESS.md and note it in this dispatch's REPORT.md; manuscript provenance text must be drawn from the manifest/JSON, never that sentence.
2. PROGRESS.md update; overwrite `cowork/REPORT.md`; session-log line; final `docs:` commit; push; HEAD hash in the report.

## Constraints
- Every number computed this run (or read from committed CSVs with assertions), labeled REALDATA-EXTERNAL (CONFDB) / SIMULATION + status per BRIEF §3, saved under results/.
- Preregistered decisions fixed; deviations argued in REPORT.md, never silent. Primary/secondary labels immutable after this file is committed.
- No calibration correction anywhere; no pooled estimate; no disattenuated point values; no confirmatory phrasing.

## Acceptance criteria
- step14 null-reference CSV + meta with achieved-reliability check and PASS/SKIP status; step15 contrast CSV/MD with all four studies (primary + flagged secondaries incl. Bang B-s1/B-s2, Haddara H-s1, Spearman rows, exploratory Arbuzova 6-pair table); figure + data CSV with asserted Lund row; captions updated.
- Taxonomy + attenuation wording present in the MD; disattenuation appears only as ranges.
- 009 correction line in PROGRESS.md; `git status` clean; push confirmed with HEAD hash.
