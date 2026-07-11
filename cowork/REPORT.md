# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — CD fetched + 361/361 VERIFIED; 4 studies SELECTED mechanically; measures + reliabilities in; **firewall held (zero cross-task quantities)**; pushed
**Dispatch #:** 009
**Date:** 2026-07-10

## What was done

All five parts. Every reported number below is REALDATA-EXTERNAL (CONFDB),
VERIFIED (computed this run from md5-verified files by committed code) and
lives in a results/ CSV.

**Part A — fetch + provenance (`analysis/11_confdb_fetch.R`):** OSF project
s46pr enumerated via the OSF v2 API ("Confidence Database" folder + root
`Database_Information.xlsx`). **No registered/versioned snapshot of the node
exists** (registrations endpoint returns empty — recorded in the provenance
JSON), so the pin is: access timestamp (2026-07-10 UTC), each file's
OSF-reported md5/sha256, and each file's OSF version — **all 361 files are
version 1**, i.e. never modified since upload. Download = each file's
canonical `https://osf.io/download/<guid>/` link, binary mode, 2 retries
then MISSING. Result: **361/361 VERIFIED against OSF md5s (180 data CSVs +
180 readmes + 1 metadata sheet, 255,175,101 bytes), 0 MD5_MISMATCH, 0
MISSING** — no MISSING rows were needed but the mechanism is in the script.
Raw files land in `data/raw/confidence_db/` (gitignored this dispatch).

**Part B — inventory (`analysis/12_confdb_inventory.R`):** all **180 study
CSVs parsed, 0 parse failures, 0 encoding fixes needed**. Inventory records
structure only: columns vs the CD standard, n rows/subjects, task-like
column (exact `Task` preferred, else name containing "task"), per
subject(-task) trial counts, observed confidence scale (n distinct, range,
integer flag, % missing), accuracy mechanism (0/1 `Accuracy` column, else
`Stimulus`==`Response` equality, else none), training column + its observed
values. 13 studies have zero mechanically-usable clean trials — all are
genuine oddball formats, RECORDED not repaired (see Issues #3).

**Part C — mechanical selection (same script, separate output):** funnel
**180 files → 180 parsed → 21 multi-task within-subject → 4 pass S1 → 4
pass S1–S4 → 4 SELECTED**: `Arbuzova_2021_expt2`, `Arbuzova_unpub_3`,
`Bang_2019_Exp2`, `Haddara_2022_Expt1`. S2/S3 eliminated nobody that
passed S1; **S4: the metadata sheet has NO dedicated flag/exclusion column**
— per the dispatch it would auto-pass, but since a free-text `Notes` column
exists I keyword-scanned it (fixed regex, in-script:
exclud|problem|warning|caution|do not use|corrupt|erroneous|unreliable) and
it raised **zero flags**; both facts recorded. Independent hand-check: S1
for Bang_2019_Exp2 recomputed with fresh code (no shared helpers) = 201
qualified subjects, matching the pipeline exactly.

**Part D — measures + reliabilities (`analysis/13_confdb_measures.R`):**
**1,525 subject×task rows across 10 study-task cells** (every cell with
≥60 clean trials; all subjects included, not just S1-qualified, so you can
subset either way for 010). Per row: n clean trials, mean accuracy, LEVEL
(mean confidence normalized by the study's own observed clean-trial range —
constants recorded on every row: Arbuzova_2021_expt2 1–6, others 1–4), raw
AUROC2 (no d′-partialing, per dispatch), same-task d′-hat (log-linear; all
10 cells have exactly 2 stimulus values so it is defined everywhere).
Split-half = odd/even by within-cell row order, Spearman-Brown,
subject-bootstrap B=500.

**FIREWALL: HELD.** No correlation, covariance, regression, or difference
between tasks' measures exists anywhere in this dispatch. Auditable by
reading: `R/confdb.R` (per-file/per-cell helpers only), script 13 (every
loop is over one study-task cell; the only cross-task-ish field anywhere is
`best_pair_n_subjects` in the selection CSV, which is a structural count of
subject overlap — no measure is involved). The measures CSV is one row per
subject×task with no cross-task columns.

**Part E:** `.gitignore` entry added; `git status --porcelain | grep -c
confidence_db` = **0** (proof: no raw CD file staged); readxl added to
renv.lock (**Ben: run `renv::snapshot()` to double-check next time you're
in R** — I ran it non-interactively and committed the result).

## Files changed / created

- `analysis/11_confdb_fetch.R` + `results/step11_CONFDB_manifest.csv`, `results/step11_CONFDB_provenance.json`
- `R/confdb.R` (shared defensive parse + preregistered cleaning rules)
- `analysis/12_confdb_inventory.R` + `results/step11_CONFDB_inventory.csv`, `results/step11_CONFDB_selection.csv`
- `analysis/13_confdb_measures.R` + `results/step11_CONFDB_measures.csv`, `results/step11_CONFDB_reliability.csv`
- `.gitignore` (data/raw/confidence_db/), `renv.lock` (readxl)
- `cowork/REPORT.md`, `PROGRESS.md`, `cowork/DISPATCH.md` (docs commit)

## Commits

- `87bf01d` — chore: readxl in renv lockfile
- `1b2b4e4` — feat: Part A fetch + provenance
- `99ba813` — feat: Parts B+C inventory + selection
- `1dededa` — feat: Part D measures + reliabilities
- final `docs:` commit — this report + PROGRESS log line + the 009 dispatch text (pushed; = origin/master HEAD when you audit)

## Results

**Selected studies (all pass S1–S4; numbers from the selection CSV):**

| Study | Tasks (qualifying) | N subj total | S1 qualified | Best pair N | Conf scale (observed) |
|---|---|---|---|---|---|
| Arbuzova_2021_expt2 | skittles-trajectories × skittles-angles (Task 1×2) | 43 | 41 | 41 | 1–6, 6 values |
| Arbuzova_unpub_3 | memory, motor, visual, visuomotor | 41 | 40 | 40 (memory×visual) | 1–4, 4 values |
| Bang_2019_Exp2 | coarse × fine Gabor discrimination (Task 1×2) | 201 | 201 | 201 | 1–4, 4 values |
| Haddara_2022_Expt1 | letter (X/O) × color (red/blue) grids (Task 1×2) | 443 | 443 | 443 | 1–4, 4 values |

All four use `Stimulus`==`Response` accuracy (no usable Accuracy column;
readmes confirm identical 1/2 coding of Stimulus and Response in each).
Mean accuracy per cell 0.70–0.77 (staircased or difficulty-matched
designs), d′-hat 1.1–1.6 — all sensible.

**Reliability headlines (split-half SB, 95% subject-bootstrap CI; full
table in `results/step11_CONFDB_reliability.csv`):**

- **LEVEL: 0.97–1.00 in all 10 cells.** Floor of the 20 CI bounds: 0.94.
- **AUROC2: 0.62–0.90.** Weakest: Arbuzova_unpub_3 memory 0.62 [0.25,
  0.80] (~186 trials); strongest: Haddara task 1 0.90 [0.88, 0.92] (330
  trials). Bang (100 trials/task): 0.79 both tasks.

The Lund pattern — level reliability at ceiling, sensitivity reliability
substantially lower and trial-count-bound — **reproduces across all four
external studies before any contrast is computed.** The 60-trial floor
priced in by the dispatch shows up exactly as expected (Bang/Arbuzova cells
sit lower than Haddara's 330-trial cell).

**Near-misses for the record (top of the S1-fail list, from the selection
CSV):** Matthews_2019 (24 qualified subj), Xu_2019_Exp2 (21), Samaha_2017
exp1/exp3 (20 each), Song_2011 (18), Ye_2018 (18). All fail only the
40-subject floor. Reported for completeness — criteria stay frozen; any
loosening is yours to re-preregister in writing.

## Issues & blockers

None blocking. For the audit trail:

1. **Two mechanical-rule fixes made during Part B, both data-driven and
   committed** (the first inventory run exposed them): (a) Training-column
   rule — the CD standard says 0/1 but Desender_2014/2016 use
   `main`/`training1`/`training2`; the initial `!=0` rule wrongly dropped
   ALL their trials. Final rule: training iff lowercased value matches
   `^1$|^training` (the snapshot's complete observed value sets are {0},
   {0,1}, {main,training1,training2} — recorded in the inventory). (b) Two
   files (Rahnev_2021, Zheng_2023_NOC) name the subject column
   `subject_id`, not `Subj_idx` — added as the only accepted variant.
   Neither file is multi-task; neither fix changed the funnel or selection.
2. **Readme↔data naming mismatch (maintainer-side):** `data_Arbuzova_2021_
   expt1/expt2.csv` have no same-named readmes; the matching descriptions
   are `readme_Arbuzova_unpub_1/2.txt` (study published mid-database;
   files renamed inconsistently). Structure checks were run on the DATA
   files; the readme mapping is inferred (unpub_1 ↔ expt2 matches: 2 tasks,
   43 subjects incl. 2 task-1-only, 6-point scale).
3. **13 zero-clean-trial studies, all recorded as oddballs, none repaired**
   (exact list in the inventory; verified reasons): 6 wide-format files
   with no standard `Confidence` column (AguilarLleyda ×2, Konishi_2019,
   Matthews_2018_exp1/exp2, Matthews_unpub — several of these ARE
   multi-task and could be reshaped if you ever want them, but that would
   be a new preregistered decision); Akdogan_2017 ×3, Dildine_unpub,
   Duyan_unpub_Exp1 (continuous stimulus/response spaces, no derivable
   binary correctness); Desender_2021_PsyRes (correctness in a nonstandard
   `Correct` column); Desender_2016 (its `Confidence` column contains the
   strings `easy`/`diff` — a binary difficulty judgment, not numeric
   confidence).
4. **Facts you'll want for the 010 preregistration:** (a) Bang_2019_Exp2
   contains 3% catch trials (`Catch_trial` column) — the preregistered
   cleaning does not drop them (not in the dispatch's rule set; flagged
   rather than silently filtered) — and its readme says subjects 179–201
   were excluded by the AUTHORS for poor performance but are present in
   the file. (b) Haddara_2022_Expt1 has a between-subject Feedback
   manipulation (Task 1 only; Task 2 feedback-free for everyone). (c)
   Arbuzova_2021_expt2 has 3 conditions (visuomotor/motor/visual) NESTED
   within each task; Arbuzova_unpub_3's motor/visuomotor "tasks" are the
   two conditions of one skittles paradigm (readme wording) — whether they
   count as distinct domains is an interpretation call for 010. (d)
   Arbuzova error-marked trials arrive as NaN confidence and are dropped
   by the missing-confidence rule automatically.
5. S3 is partially entailed by S1 as implemented (accuracy-derivability is
   part of the clean-trial definition, so a study with no accuracy
   mechanism can't reach 60 clean trials); S3 still independently asserts
   both accuracy classes occur per qualifying task. No study was decided
   by this subtlety.

## Questions / decisions needed for planning

- **010 contrast prereg inputs are ready:** 4 studies, 10 study-task cells,
  best-pair Ns 41/40/201/443, reliabilities as above. Decisions you'll
  need to freeze: task-pair choice where >2 tasks (Arbuzova_unpub_3),
  whether motor/visuomotor count as separate domains, Bang catch-trial and
  author-excluded-subject handling, Haddara feedback-group handling
  (pool/split/covariate), estimator (raw vs d′-partialed AUROC2 — d′-hats
  are already in the measures CSV), and disattenuation presentation
  (sensitivity range only, per BRIEF).
- Zero-selected did NOT happen; no loosening decision needed. If you want
  more studies, the near-miss list + the reshapeable wide-format
  multi-task files are the two documented expansion paths (both would be
  new preregistrations).
- Push done; origin/master = the final docs commit below.
