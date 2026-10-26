# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE. All four table/structure defects are fixed in the rendered PDF. Cowork's `ms.qmd` edits fixed Table 1 and the stale comment but did **not** fully fix Tables 3 and 5, so I added two layout-only lines (`tbl-colwidths`, see Deviations). Both docs render clean, the grep-checks pass, and the commits are pushed.
**Dispatch #:** 013
**Date:** 2026-10-26

## What was done

Re-render, verify, commit, as scoped. **No analysis was rerun, no value was recomputed, and `results/` was read-only throughout.**

1. **Render.** `quarto render manuscript/ms.qmd` and `manuscript/supplement.qmd` both completed clean under the renv library (R 4.6.1, Quarto→Typst). Every `stopifnot` guard passed, including the new `studylab` and `tiermap` guards. Knitr printed eight warnings, all of the same cosmetic kind: "Duplicated chunk option 'label'", because chunks such as `{r tbl-cdb}` also carry `#| label: tbl-cdb`. The committed 012 file already had these. They have no effect on output, and I did not change them.
2. **Verified the four fixes in the rendered PDF** using `pdftotext -layout`. The first render used Cowork's file exactly as delivered:
   - **Table 1: FIXED by Cowork's edit.** Exactly three columns (Domain / Level / Sensitivity); the phantom `memory` column is gone.
   - **Table 3: NOT fixed by Cowork's edit.** It still rendered `2010.57` and `4430.87`. The cause was not the study-key length but pandoc's column sizing. Pandoc sizes each pipe-table column in proportion to its longest cell, so `n` (2–3 characters) got a sliver and `201`/`443` spilled into `r_level`. **Fix:** `#| tbl-colwidths: [13, 31, 6, 18, 20, 12]`. After re-rendering, `n` is clearly separated: `201 0.57 [0.45, 0.68]` and `443 0.87 [0.84, 0.90]`. `grep '2010\.57\|4430\.87'` returns 0.
   - **Table 4:** no collision in either render. The short labels from Cowork's edit are enough here, so I left it unchanged.
   - **Table 5: NOT fixed by Cowork's edit.** The long Verdict column still squeezed Tier and Estimate into slivers ("Es-timate", "Con-fir-ma-tory" interleaved across columns). Row 9 broke across the page, and the page number "12" was again absorbed into a cell. **Fix:** `#| tbl-colwidths: [4, 14, 14, 20, 48]`. After re-rendering, all nine rows are on one page (p. 12) in order, with no interleaving and no stray page number. `naive gap` shows `0.200 [0.051, 0.353]`. I kept the `#` column and did not need landscape.
   - **Stale STUB comment:** replaced. `grep -c STUB` on the PDF returns 0.
3. **012 grep-checks re-run on the rendered PDF: all pass.**
   - "not excluded" ×7.
   - "absent" ×3, all sanctioned: the Methods rule "reported as not excluded, never as absent"; the Results "a 'not excluded,' not an 'absent'"; and the Abstract/Intro "largely absent as a distinguishable effect", which refers to the dissociation and never to sensitivity.
     - These counts match the committed 012 PDF exactly. The 012 report's "×6" and "absent twice" were miscounts in that report, not a change in the text.
   - Disattenuation appears as ranges only.
   - The taxonomy sentences are present ("not four cross-domain replications"; "task generalization, not cross-domain generality").
   - The Δ_ICC boundary wording is present ("very edge of this interval", "boundary result").
   - The ArbU3 margins 0.046 and 0.020 are present.
   - The Discussion has no confirmatory-strength language on any null or partial result. Every hit is a tier name ("confirmatory pair/test/designs") or "demonstration of task generalization".
4. **"Zero hand-typed statistics": still holds.**
   - **Prose audit:** I stripped code chunks, inline `` `r …` `` spans and HTML comments from `ms.qmd`, then grepped the remaining prose for digits. The 93 digit-bearing prose lines are **byte-identical** to HEAD (`diff` is empty).
   - **Code audit:** I grepped every added line with a digit in `git diff`. The only new literals are:
     - study display labels: "Arbuzova 2021 E2", "Bang 2019 E2", and similar;
     - tier codes;
     - the `digits = 3` in `num3()`;
     - the `tbl-colwidths` percentages;
     - script/file names in the Table 5 caption.
   - **None is an estimated statistic.** `num3()` only *formats* values read from `step17_claim_status.csv`; it never retypes them.

## Deviations from the dispatch (argued, never silent)

1. **Two `tbl-colwidths` lines added to `ms.qmd` (Tables 3 and 5).** The dispatch said "verify, do not redo". It explicitly allowed further reduction for Table 5 only (drop `#`, or landscape). Table 3's fix, though, failed verification as delivered: `2010.57` was still in the PDF. Rolling back with `git checkout` would have brought back *all four* defects. So I applied the narrowest possible change: a column-width chunk option, which is layout only. It touches no value, label, wording or guard. For Table 5, this choice was within the dispatch's latitude and was less disruptive than either option it named. The `#` column was kept and no landscape section was needed.

## Observations for Cowork (no action taken)

- **"preregistered" wording (Part D #3):** Cowork's edit to the Table 5 caption already changed "verdict wording is **preregistered**" to "verdict wording is **fixed in advance**". That is one instance of the softening Part D says needs Ben's instruction. I kept it, because Cowork authored it and it is accurate. But Ben's Part D #3 decision is already partly pre-empted by this caption, so the wording should be made consistent either way.
- **Table 5 still hyphenates the tier codes** inside their column ("Confirma-tory"). It is readable and the rows are intact. If you want it cleaner, shift a few percent of width from Verdict (48) to Tier (14), or abbreviate "Confirmatory" → "Confirm.".

## Files changed / created

- `manuscript/ms.qmd`: Cowork's four fixes (committed as delivered), plus my two `tbl-colwidths` lines.
- `manuscript/ms.pdf`: re-rendered and committed.
- `manuscript/supplement.pdf`: re-rendered (gitignored; not committed).
- `cowork/DISPATCH.md`: Cowork's 013 (committed by Code). `cowork/REPORT.md`: this file. `PROGRESS.md`: status line and session-log row 16.

## Commits

- **`750c71e`**: fix: dispatch 013, manuscript table rendering defects (`manuscript/ms.qmd`, `manuscript/ms.pdf`).
- The final **`docs:`** commit holds this report, `PROGRESS.md` and `cowork/DISPATCH.md`. Its hash is the latest commit touching REPORT.md; HEAD after the push is equal to origin/master.

## Results / state

- The manuscript is a full first draft. It has passed the independent 124/124 audit (Cowork), and its rendered tables are now visually correct.
- The values are unchanged from 012. Every statistic is a guarded `V$` object or a cell built from a CSV.

## Issues & questions for planning

**Part D editorial decisions: still OPEN, not acted on, for Ben:**
1. **Author block.** It still reads `author: "Ben [Author]"`. It needs a name, affiliation, ORCID and email. Keywords, a funding statement and a COI statement are also missing.
2. **Title.** Choose among the three YAML candidates; the default is in place.
3. **"Preregistered".** The mechanism is a git timestamp in a private repo. Ben should either register retrospectively, or soften the wording throughout (see the observation above: one caption is already softened).
4. **Reference list is thin** (14 entries). Several Introduction claims have no citation. This needs a verified literature pass as its own dispatch, with no fabricated references.
5. **Figure 1 legend jargon.** It says "CONFIRMATORY (corrected, dispatch 006)". Fixing it requires `analysis/10_landscape_figures.R` plus a figure regeneration.
6. **Notation consistency.** The prose uses ρ_level/ρ_sens, while captions and table headers use `rho_level`/`r_sens_raw`.
