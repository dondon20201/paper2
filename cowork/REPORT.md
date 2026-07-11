# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — Part A gate PASS 4/4; contrast in (holds 1/4, partial 3/4 per prereg criteria); figure + captions in; 009 report error corrected; pushed
**Dispatch #:** 010
**Date:** 2026-07-11

## What was done

All four parts, exactly as preregistered in the dispatch. Every number below
is VERIFIED (computed this run by committed code, saved in results/), labeled
REALDATA-EXTERNAL (CONFDB) or SIMULATION as appropriate. **This dispatch
computed the first cross-task quantities of Step 5 — the 009 firewall ended
here, by preregistration.**

**Part A — null-reference gate (`analysis/14_confdb_nullref.R`), SIMULATION:**
Per study, a discretized latent-Gaussian generator (level trait on the
set-point, sensitivity trait on the correct-vs-error confidence separation,
both correlated across tasks at the SAME true rho ∈ {0.30, 0.45}) matched to
each study's pair-qualified n, median clean trials/task, confidence scale
(K = 6 or 4), and observed accuracy, with per-task trait SDs tuned by
log-scale coordinate bisection (common random numbers, tuning cohort 3,000)
so simulated odd/even Spearman-Brown reliabilities reproduce the COMMITTED
step11 values. **GATE PASS 4/4** — achieved reliabilities in the actual
500-replicate runs within ±0.05 of all 16 targets; worst |deviation| 0.022
(Bang), others ≤ 0.016. The tuning itself matched targets to 3 decimals.
Null-world raw-gap intervals (2.5–97.5%):

| Study | rho=0.30 | rho=0.45 |
|---|---|---|
| Arbuzova_2021_expt2 (n=41) | [−0.357, 0.520] | [−0.308, 0.466] |
| Arbuzova_unpub_3 (n=40) | [−0.315, 0.505] | [−0.239, 0.531] |
| Bang_2019_Exp2 (n=201) | [−0.117, 0.253] | [−0.063, 0.257] |
| Haddara_2022_Expt1 (n=443) | [−0.083, 0.183] | [−0.042, 0.186] |

The headline of Part A: **at these configurations, differential attenuation
plus sampling noise alone produces raw gaps up to ~0.5 (small-n studies) /
~0.25 (Bang) / ~0.19 (Haddara) under a TRUE NULL** — the raw gap is
uninterpretable without this reference, exactly as the dispatch framed it.

**Part B — the contrast (`analysis/15_confdb_contrast.R`):** primary pairs
as preregistered; subjects ≥60 clean trials in BOTH tasks, listwise; subject
bootstrap B=2000, percentile, seed 20260711, residualization recomputed
inside every resample. Bang recomputed from raw (md5-guarded) with identical
009 cleaning + Catch_trial==1 dropped (1,206 of 40,200 clean trials, 3.0%;
author-excluded subjects 179–201 KEPT in the primary). Haddara feedback
groups derived from raw (md5-guarded; 225 feedback / 218 no-feedback;
between-subject flag verified constant per subject, Task 2 verified
feedback-free). PRIMARY results:

| Study | n | r_level [95% CI] | r_sens (d′-partialed) [95% CI] | gap [95% CI] |
|---|---|---|---|---|
| Arbuzova_2021_expt2 | 41 | 0.550 [0.215, 0.799] | 0.243 [−0.085, 0.513] | 0.307 [−0.117, 0.729] |
| Arbuzova_unpub_3 (mem×vis) | 40 | 0.560 [0.253, 0.762] | −0.097 [−0.350, 0.143] | 0.657 [0.297, 0.968] |
| Bang_2019_Exp2 | 201 | 0.574 [0.452, 0.676] | 0.067 [−0.050, 0.194] | 0.508 [0.354, 0.653] |
| Haddara_2022_Expt1 | 443 | 0.872 [0.841, 0.900] | 0.561 [0.488, 0.626] | 0.311 [0.247, 0.383] |

**Preregistered verdicts** (holds = r_level > top of r_sens's disattenuated
range AND raw gap > null-reference interval under both scenarios):
- **Arbuzova_unpub_3 memory×visual: HOLDS** — the tier's ONLY cross-domain
  pair. r_level 0.560 vs r_sens disatt range [−0.251, −0.118]; raw gap 0.551
  vs null upper bounds 0.505 / 0.531. **Note the margins: 0.046 / 0.020** —
  real but not comfortable; flagged for your read.
- **Arbuzova_2021_expt2, Bang, Haddara: PARTIAL** — in all three, r_level
  exceeds the top of r_sens's disattenuated range (0.550 vs 0.308; 0.574 vs
  0.094; 0.872 vs 0.689), but the raw gap sits INSIDE the true-null
  reference interval (0.139 vs 0.520/0.466; 0.170 vs 0.253/0.257; 0.128 vs
  0.183/0.186). A null gap is **not excluded** in these three.
- No study **fails**.

Secondaries all in and consistent: B-s1 (catch-included) r_sens 0.104 vs
primary 0.067 — the catch-trial choice matters little; B-s2 (without
author-excluded subjects, n=178) essentially unchanged (gap 0.461 vs 0.508);
H-s1 heterogeneity check: feedback gap 0.296 vs no-feedback 0.353 (no test,
per dispatch); Spearman versions track Pearson everywhere (scale-use is not
driving r_level); r_sens_raw ≫ r_sens for Bang (0.404 vs 0.067) and Haddara
(0.743 vs 0.561) — the d′-confound exhibit, again. Exploratory Arbuzova 6-pair
table in the MD; motor×visuomotor (one paradigm, two conditions) shows the
pattern's ceiling (r_level 0.879) — labeled EXPLORATORY.

**Part C — figure (`analysis/16_confdb_figure.R`):** two-panel forest,
5 rows (Lund memory×vision CONFIRMATORY (corrected) on top, values asserted
against `step6_REALDATA_confirmatory.csv` at 3 dp; 4 CD rows labeled
NON-CONFIRMATORY). Left: r_level/r_sens with CIs + disattenuation brackets.
Right: raw gap vs both null-reference intervals (dotted/dashed). Caption
appended to `figures/fig_captions.md` with the binding taxonomy sentence and
the attenuation warning; underlying data in
`results/fig_confdb_contrast_data.csv`.

**Part D — housekeeping:** the 009 report error is CORRECTED in PROGRESS.md
(dated line + session-log annotation): the 009 report claimed "all 361 files
are version 1" — false; the manifest records 8 files at OSF v2–v4
(3 data CSVs: Haddara_2022_Expt2, Siedlecka_2016, Sinanaj_2015 at v2;
5 readmes incl. Haddara_2022_Expt1 at v4). All 4 SELECTED studies' data CSVs
are v1. Manuscript provenance text must come from the manifest/JSON.

## Files changed / created

- `analysis/14_confdb_nullref.R`, `results/step14_SIMULATION_confdb_nullref.csv` + `_meta.json` (new)
- `analysis/15_confdb_contrast.R`, `results/step15_CONFDB_contrast.csv` + `.md` (new)
- `analysis/16_confdb_figure.R`, `figures/fig_confdb_contrast.pdf/.png`, `results/fig_confdb_contrast_data.csv` (new); `figures/fig_captions.md` (appended)
- `PROGRESS.md` (status + correction + session log), `cowork/REPORT.md` (this file), `cowork/DISPATCH.md` + `cowork/sessions/2026-07-11-session-03.md` (Cowork-authored, committed by Code)

## Commits

- `eb5f7c1` — Part A (null-reference gate, SIMULATION, PASS 4/4)
- `b285dcf` — Part B (contrast CSV/MD)
- `183e2dd` — Part C (figure + captions + data)
- final `docs:` commit — this report + PROGRESS.md + Cowork session files (hash = latest commit touching REPORT.md, then pushed; HEAD after push reported in the session log workflow)

## Results

See Part A/B tables above; complete numbers in
`results/step14_SIMULATION_confdb_nullref.csv`,
`results/step15_CONFDB_contrast.csv`, `results/step15_CONFDB_contrast.md`,
`results/fig_confdb_contrast_data.csv`. Independent spot-check this run:
Haddara r_level/r_sens/r_sens_raw and Bang-recomputed r_level re-derived
with fresh code (no shared helpers) matched the pipeline to 4 decimals.

Honest summary for planning: **the external tier says the LEVEL side of the
thesis travels; the gap side mostly does not clear its attenuation-aware
yardsticks.** r_level is uniformly positive and precisely estimated
(0.55–0.87). r_sens is heterogeneous (−0.10 to 0.56). The preregistered
pattern check gives holds 1/4 (the single cross-domain pair, thin margins),
partial 3/4, fails 0/4 — consistent with the Lund confirmatory verdict
(gap null not excluded) rather than stronger than it.

## Issues & blockers

1. **The "holds" verdict is thin.** Arbuzova_unpub_3's raw gap clears its
   null bounds by 0.046 (rho=0.30) and 0.020 (rho=0.45), n=40. Under the
   integrity rules I'd resist any wording stronger than "the only
   cross-domain pair is consistent with the Lund direction and exceeds its
   simulated true-null reference, narrowly."
2. Haddara r_sens 0.561 [0.488, 0.626] is high in absolute terms — worth
   discussing: within-vision, near-identical task formats, 443 subjects.
   Its raw gap (0.128) is inside the null interval, but sensitivity itself
   is clearly domain-... task-general there. Wording watch: that's TASK
   generalization, within vision.
3. Disattenuation of r_sens uses the committed AUROC2 reliabilities as
   prescribed, though r_sens is the d′-partialed residual correlation —
   the reliability of the residualized quantity is not identical to the
   AUROC2 reliability. Preregistered choice followed; noted here for the
   audit.
4. Simulator caveats (documented in the meta JSON): fixed per-task accuracy
   (no d′ trait, no staircase dynamics), fixed equally spaced latent
   thresholds; reliabilities/means matched, higher moments not. Deviations
   worth probing in an audit if you want (e.g. subject-varying accuracy).
5. Bang committed reliabilities are catch-included while the Bang primary
   measures are catch-dropped (prereg said committed reliabilities AS-IS);
   B-s1 shows the catch choice shifts r_sens by ~0.04, so this is immaterial.

## Questions / decisions needed for planning

1. Does the "holds, narrowly" framing for Arbuzova_unpub_3 (margins
   0.020–0.046) match how you want Step 6 to phrase the single external
   cross-domain replication?
2. Step 4's Δ_ICC knife-edge presentation decision is still pending on your
   side — Step 6 needs it.
3. Ready to plan Step 6 (manuscript + claim-status table). The claim
   inventory now spans: Lund confirmatory (gap null not excluded, both
   components domain-general), descriptive 5-pair landscape, Step 4
   decomposition (knife-edge), CONFDB external tier (holds 1/4 partial 3/4).
