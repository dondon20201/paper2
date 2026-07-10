# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — descriptive tier done (all five pairs estimable) + **GitHub remote WIRED and PUSHED**
**Dispatch #:** 007
**Date:** 2026-07-10

## What was done

The five-pair descriptive tier ran exactly per the preregistered decisions.
Provenance guards passed (raw md5; step1 + step6 CSVs verified committed-clean
via git before running). Machinery identical to 006: committed step-1 parcel
columns AS-IS, primary trial set, both-qualifying subjects, `fit_latent`
(K = 4/2 as fixed), sensitivity parcels d′-partialed via the same
`partial_out_dprime`, level parcels raw. NO calibration correction anywhere;
each gap carries its frozen systematic band (±0.09 for the four 200/100
pairs, ±0.10 for Calories × GDP). The 006 confirmatory row was copied into
the summary table by reading `results/step6_REALDATA_confirmatory.csv` —
not recomputed. All five CFAs converged and were admissible (no
NOT-ESTIMABLE rows; prereg #5 fallback never triggered).

**Task 4 (GitHub remote): DONE.** Ben provided the URL directly in chat this
session, so the permission block cleared. `git remote add origin
https://github.com/dondon20201/paper2.git` + `git push -u origin master`
succeeded; verified `origin/master` = `8305ec9` (= local HEAD at report
time, the dispatch-007 feat commit — full history from cf66ac0 onward is on
GitHub). The final `docs:` commit (this report + PROGRESS.md) is pushed
immediately after it is created; it will be the pushed HEAD when Cowork
reads this.

## Files changed / created

- `analysis/07_descriptive_pairs.R`
- `results/step7_REALDATA_descriptive.csv` — per pair: ρ_level, ρ_sens (uncorrected), gap, SEs, delta CIs, bias band, n_both, n_complete, converged/admissible/estimable
- `results/step7_REALDATA_descriptive.md` — full 6-pair summary table (5 descriptive + 006 confirmatory row marked) + honest-reading paragraph
- `PROGRESS.md` — status, next-steps checkboxes, session-log line
- `cowork/DISPATCH.md` — committed as received from Cowork

## Commits

- `2bf7137` — docs: dispatch 007 from Cowork
- `8305ec9` — feat: dispatch 007 — descriptive tier, five cross-domain pairs
- final `docs:` commit — this report + session-log line (latest commit touching REPORT.md in git log; pushed)

## Results

All REALDATA, primary trial set, computed this session, every row
NON-CONFIRMATORY / DESCRIPTIVE. CIs are delta-method (sampling only); the
± band is the separate frozen systematic allowance.

| Pair | K | n both / complete | ρ_level [95% CI] | ρ_sens uncorr. [95% CI] | Gap [95% CI] ± band |
|---|---|---|---|---|---|
| memory × Calories | 4/2 | 320 / 317 | 0.375 [0.276, 0.474] | 0.395 [0.195, 0.595] | −0.020 [−0.243, 0.203] ± 0.09 |
| memory × GDP | 4/2 | 315 / 312 | 0.323 [0.218, 0.427] | 0.456 [0.239, 0.673] | −0.133 [−0.374, 0.108] ± 0.09 |
| vision × Calories | 4/2 | 322 / 322 | 0.450 [0.359, 0.541] | 0.256 [0.047, 0.465] | 0.194 [−0.034, 0.421] ± 0.09 |
| vision × GDP | 4/2 | 317 / 317 | 0.464 [0.374, 0.554] | 0.168 [−0.058, 0.394] | 0.296 [0.055, 0.537] ± 0.09 |
| Calories × GDP | 2/2 | 317 / 317 | 0.473 [0.382, 0.564] | 0.237 [−0.024, 0.498] | 0.237 [−0.039, 0.512] ± 0.10 |

(006 confirmatory memory × vision, copied verbatim: ρ_level 0.422 [0.328,
0.515]; corrected ρ_sens 0.308 [0.075, 0.542]; corrected gap 0.113 [−0.138,
0.364].)

**Descriptive reading (not test results):**
1. ρ_level is consistently moderate across ALL six pairs (0.32–0.47) — the
   level component's domain-generality is uniform across the landscape.
2. The gap is heterogeneous: vision pairs point the thesis's way
   (0.19–0.30), memory×knowledge pairs point the other way (−0.02, −0.13),
   Calories×GDP in between (0.24). Note vision×GDP's gap CI excludes zero,
   but its lower bound (0.055) sits inside the ±0.09 band — the systematic
   allowance covers zero, so even descriptively it is not a nonzero-gap
   claim. Overall this heterogeneity is CONSISTENT with the confirmatory
   verdict (null gap not excluded) and cuts against any strong uniform
   level > sensitivity story.
3. Uncorrected ρ_sens for the memory×knowledge pairs (0.40, 0.46) exceeds
   the corresponding ρ_level point estimates — and uncorrected sensitivity
   is attenuated in expectation, so if anything these understate ρ_sens.
   Domain-general sensitivity looks real across the landscape, echoing the
   006 corrected ρ_sens = 0.31 excluding zero.

## Issues & blockers

None blocking. Two interpretive cautions for planning:
1. d′-partialing in the 100-trial domains (and vision) leans on d′-hat
   estimates whose split-half reliability was ~0 or negative (the dispatch-
   005 staircase finding). The gate simulations that produced the bands used
   well-behaved d′, so the bands may not fully price this in. Fine for a
   descriptive tier; worth one limitations sentence in the paper.
2. `fit_latent` doesn't record whether the bounded fallback was used
   (converged/admissible only). Never mattered so far (0 fallbacks observed
   in 006's 2000 bootstrap fits); flagging for completeness.

## Questions / decisions needed for planning

- The heterogeneous gap landscape (point 2 above) is now the paper's most
  interesting descriptive fact: the level-advantage appears vision-anchored,
  not universal. Does Cowork want a (clearly non-confirmatory) domain-level
  presentation in the paper, or keep strictly to the pair table?
- Step 4 (non-ipsative multilevel decomposition) and Step 5 (Confidence DB)
  remain; sequence at your discretion.
- Backup routine per CLAUDE.md is now active: push after each dispatch's
  commits (done this dispatch; will repeat).
