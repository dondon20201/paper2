# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — Part A (claim-status table, 9 rows) + Part B (ms.qmd Methods+Results complete, stubs elsewhere) + Part C (supplement S1–S6) + Part D (housekeeping) all in; both docs render clean; grep-checks pass; pushed
**Dispatch #:** 011
**Date:** 2026-07-11

## What was done

Step 6a manuscript skeleton, exactly as scoped. **No analysis was rerun and
no estimate was recomputed — `results/` was read-only input throughout.** The
only new numbers file is `results/step17_claim_status.csv/.md`, which READS
and re-asserts committed values (it computes nothing new).

**Enforcement of "zero hand-typed statistics" (how):** every inline number in
`ms.qmd` and `supplement.qmd` is a member of a named list `V` built in a
single setup chunk that reads the committed CSVs; each `V$…` is wrapped in a
`stopifnot`/`gd()` guard asserting `round(value, k)` equals the cited figure,
so a drifted input fails the render. Every table is rendered with `knitr::kable`
directly from a committed CSV (values come from the file, never typed). There
are no numeric literals in the prose. `analysis/17_claim_status.R` uses the
same guard pattern for all 9 rows.

**Part A — claim-status table (`analysis/17_claim_status.R`):** 9 rows, one
per claim, columns claim_id / tier / quantity / estimate / ci_lo / ci_hi / n /
source_csv / verdict_wording (frozen) / figure_ref. All values extracted +
assert-guarded from the named CSVs. Frozen verdict strings reproduced verbatim.
Rows: gap_confirmatory (0.113 [-0.138, 0.364], "null gap not excluded");
rho_level_confirmatory (0.422 [0.328, 0.515]); rho_sens_confirmatory
(0.308 [0.075, 0.542]); naive_gap_exhibit (0.200 [0.051, 0.353], METHODS
EXHIBIT); descriptive_landscape (5 pairs, ±0.09/±0.10 bands); step4_decomposition
(Δ_ICC 0.105 [0.001, 0.210], boundary wording per decision 1); ipsative_exhibit
(real -0.667, sim planted-null mean -0.31); confdb_tier (r_level
0.550/0.560/0.574/0.872; holds 1/4 narrowly, partial 3/4; ArbU3 margins
0.046/0.020 per decision 3); reliability_floor (level .95–1.00 vs AUROC2
.39–.90 across Lund + 4 CD studies). Output: `results/step17_claim_status.csv`
and `.md`.

**Part B — manuscript (`manuscript/ms.qmd`, `references.bib`, `ms.pdf`):**
- All headings present: Abstract (STUB), Introduction (STUB w/ outline comment),
  Methods (FULL, 8 subsections), Results (FULL, 6 subsections in the prescribed
  order), Discussion (STUB w/ outline incl. the landscape measurement-lens
  section), Limitations (STUB seeded with the standing checklist), Data & Code
  Availability (FULL), References.
- Title is a marked PLACEHOLDER (`<!-- TITLE: measurement-lens, finalized in 012 -->`);
  Methods/Results prose is written compatible with the measurement-lens frame
  (decision 2). Δ_ICC uses the boundary wording (decision 1: "sits at the very
  edge of this interval … never claim the zero-exclusion"). ArbU3 uses the
  frozen decision-3 wording with the 0.046/0.020 margins in-text. Wording rules
  honoured: null = "not excluded" (6×), never "absent" as a null descriptor;
  disattenuation presented as RANGES only ("not corrected point values"); no
  pooling; binding taxonomy sentence present (within-vision task pairs and the
  condition×condition pair are NOT cross-domain replications); CD provenance
  drawn from the manifest/JSON (8 files at OSF v2–v4; all 4 selected studies'
  data CSVs v1), never the 009 report sentence.
- Figures: the three committed PNGs are included; captions are kept numeric-free
  and point to `figures/fig_captions.md` for the full committed caption (the
  numeric claims live in guarded body prose, so no statistic is hand-typed in a
  caption). Figure underlying-data CSVs are cited in Availability.
- `references.bib`: 14 entries (Lund 2025 10.1037/xlm0001462; Confidence DB
  10.1038/s41562-019-0813-1; Bang 2019; Haddara 2022; Arbuzova 2021;
  Fleming & Lau 2014; Galvin 2003 (AUROC2); Maniscalco & Lau 2012 (meta-d′);
  Nelson 1984 (gamma); Spearman 1910 + Brown 1910 (Spearman–Brown); Bates 2015
  (lme4); Rosseel 2012 (lavaan); R Core Team). All 14 are cited in-text and
  resolve in the rendered reference list.

**Part C — supplement (`manuscript/supplement.qmd`):** S1 full descriptive-tier
table (step7); S2 Arbuzova 6-pair exploratory (step15); S3 CD secondaries —
B-s1/B-s2/H-s1 + Spearman + un-partialed r_sens (step15); S4 null-reference
achieved-vs-target reliabilities + true-null gap intervals (step14); S5
reliability tables (step2 + step11); S6 ipsative exhibits (step8/9). Same
assert-guard + render-from-CSV rule.

**Part D — housekeeping:** PROGRESS.md status + session-log row 14; this report;
DISPATCH.md (Cowork 011) committed; renv.lock updated; pushed.

## Toolchain note (for the audit)

The repo had no PDF toolchain: knitr/rmarkdown were absent from the renv
library and no LaTeX is installed. I (a) installed knitr + rmarkdown (+deps)
into the renv library and recorded them with `renv::snapshot(type = "all")`
(lockfile now 73 packages; analysis spine — lavaan/lme4/ordinal/Matrix/boot —
verified still present); and (b) rendered PDF via Quarto's **bundled Typst**
engine (`format: typst`), which needs no LaTeX. A minimal repo-root
`_quarto.yml` was added so Typst's project root is the repo (otherwise it
refuses to load `../figures/*.png`). `quarto render` of both `ms.qmd` and
`supplement.qmd` succeeds. **`renv::snapshot()` reminder for Ben:** the lock was
updated this dispatch; if you prefer a leaner lock (type="all" also recorded
base-recommended packages), re-run an implicit snapshot on your machine.

## Files changed / created

- `analysis/17_claim_status.R` (new); `results/step17_claim_status.csv` + `.md` (new)
- `manuscript/ms.qmd`, `manuscript/references.bib`, `manuscript/supplement.qmd` (new)
- `manuscript/ms.pdf` (new; committed per dispatch — Ben's read copy)
- `_quarto.yml` (new); `renv.lock` (knitr/rmarkdown + deps); `.gitignore`
  (ignore `manuscript/*.typ`, `manuscript/supplement.pdf`, `.quarto/`);
  removed empty-dir placeholder `manuscript/.gitkeep`
- `PROGRESS.md` (status + log), `cowork/REPORT.md` (this file), `cowork/DISPATCH.md` (Cowork 011, committed by Code)

## Commits

- Part A — claim-status table
- Part B — ms.qmd (Methods+Results) + references.bib + ms.pdf + _quarto.yml + renv.lock + .gitignore
- Part C — supplement.qmd
- final `docs:` commit — this report + PROGRESS.md + DISPATCH.md (hash = latest commit touching REPORT.md; HEAD reported after push)

(Exact hashes in `git log`; the report is written before its own commit exists.)

## Results

- `results/step17_claim_status.md` renders the 9-row table; `.csv` is the
  machine copy. All 9 rows carry assert-guarded values and frozen wording.
- `manuscript/ms.pdf` and `manuscript/supplement.pdf` both render clean under
  the renv library (supplement.pdf is gitignored — regenerated on render;
  only ms.pdf is committed).
- Acceptance grep-checks (run this dispatch, on ms.qmd): "not excluded" present
  (6); "absent" appears only as the rule statement ("never as absent") and an
  explicit denial ("not an 'absent'"), never describing a null AS absent;
  disattenuation = ranges only ("not corrected point values"); taxonomy
  sentence present; Δ_ICC boundary wording ("very edge of this interval")
  present; ArbU3 margins 0.046 and 0.020 present (guarded).

## Issues & blockers

1. **Precision convention.** Prose reports correlations at 2 dp (2 sig figs per
   BRIEF integrity rule; e.g. ArbU3 r_level renders 0.56), while the
   claim-status table and the confirmatory gap keep 3 dp as the dispatch froze
   them (0.113, 0.560). Both are sourced/guarded; flagging the mixed precision
   in case you want it uniform in 012.
2. **Uncited-in-prose bib risk (resolved).** Typst's reference list shows only
   CITED entries, so I wove in-text citations for Spearman/Brown (Spearman–Brown),
   Maniscalco (meta-d′), Nelson (gamma), Rosseel (lavaan), and R Core Team so
   all 14 core refs appear. If 012's Intro/Discussion drop any of these
   attributions, the entry will silently leave the reference list.
3. **Figure captions.** Kept numeric-free in the .qmd (pointing to
   `figures/fig_captions.md`) to preserve "zero hand-typed statistics"; the full
   committed captions are not duplicated verbatim into ms.qmd. If you want the
   full captions inline, they must become guarded inline-`V$` compositions in 012.
4. **renv.lock breadth.** `type="all"` recorded base-recommended packages
   (survival, mgcv, …) alongside knitr/rmarkdown. Harmless for `renv::restore()`
   but heavier than strictly needed (see toolchain note).

## Questions / decisions needed for planning

1. Ready for dispatch 012 (Abstract + Introduction + Discussion + Limitations
   prose) once you've read `manuscript/ms.pdf`. The stubs already carry the
   outline comments and the standing limitations checklist.
2. Title is a placeholder — 012 should finalise the measurement-lens title/abstract.
3. Precision convention (issue 1): keep 2 dp in prose / 3 dp in the claim table,
   or unify?
4. Full figure captions inline vs. pointer-to-`fig_captions.md` (issue 3) —
   your call for 012.
