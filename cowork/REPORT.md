# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE. Ben's three decisions are applied to both repos, and every check passed. paper2 = **`de8497f`** (task commit, pushed). Public copy = **`6c9303c`** (pushed; `ls-remote` = local HEAD). There are three argued deviations, all in how checks were carried out; none changes content beyond the dispatch. **No analysis was rerun except `analysis/10_landscape_figures.R`.**
**Dispatch #:** 015
**Date:** 2026-10-29

## What was done

**Part A: paper2**
- **Re-measure (in-scope = 107 tracked files, i.e. all but `BRIEF.md`, `CLAUDE.md`, `PROGRESS.md`, `README.md`, `cowork/`).** Case-insensitive `pre-?regist` on the HEAD blobs gives **33 files, 108 occurrences**: `preregistered` 79, `Preregistered` 17, `preregistration` 8, `PREREGISTERED` 4, `Preregistration` 0. This **matches Cowork's count exactly**. There are no other forms and no hyphenated `pre-regist…`.
- **Identifier check before substituting.** Every hit in `R/` and `analysis/` is in a comment or a string literal. None is an R identifier, so the hyphen cannot break syntax.
- **A.1 substitution.** The map was applied in dispatch order to each HEAD blob (byte-exact read, raw write).
  - **Counts by form:** 4 / 17 / 79 / 0 / 8. That is 108 replacements in 33 files.
  - **Generating scripts and their committed outputs are both covered:**
    - `09` line 148 ↔ the `tier` column in `step9_…_multilevel.csv` (8)
    - `06` line 200 ↔ the `note` cell in `step6_…confirmatory.csv`
    - `08` / `09` ↔ the two `meta.json` files
    - `15` ↔ `step15_…md`
    - `16` line 210 ↔ the Figure 2 caption in `fig_captions.md`
  - **Word-level diff:** the only changed tokens are the 108 old forms becoming the 108 new ones. One of them is the compound `preregistered-by-default` → `pre-specified-by-default` (`results/STEP0B2_FINAL_REPORT.md:37`).
  - **Line endings:** all 33 committed blobs are LF (`git ls-files --eol` = `i/lf`; 0 CR bytes).
- **A.2 numbers guard: 33 / 33 files PASS.** The ordered `[0-9]+` runs are identical before and after.
- **A.3 Figure 1 legend.** Line 123 now reads `"CONFIRMATORY (corrected)"`. I then ran `analysis/10_landscape_figures.R` under renv; all of its value assertions passed.
  - **Data CSVs:** `results/fig_landscape_data.csv` and `results/figS_gap_vs_reliability_data.csv` are **byte-identical to HEAD** (LF-normalized md5 match; the working-tree bytes are also unchanged from before the run).
  - **`figures/fig_captions.md`:** the final diff vs HEAD is **exactly the 2 substitution lines**. See Deviation 1 for how.
  - **`figures/fig_landscape.png`:** I viewed it. The legend reads **"CONFIRMATORY (corrected)"**. A pixel diff against the HEAD PNG (2100×2400) shows **3,929 differing pixels, all inside one 281×40 px box at the first legend line** (x 900–1180, y 1206–1245), which is where ", dispatch 006" was removed. Every other pixel is identical.
  - **`figures/fig_landscape.pdf`:** regenerated and committed (legend change plus R's timestamp fields).
  - **figS:** the PNG is byte-identical. The PDF differed only in timestamps, so I restored it (Deviation 2).
- **A.4 render.** `quarto render manuscript/ms.qmd` exited 0 with **all 19 chunks run and every assert-guard passing**. The only warnings are the 8 known cosmetic "Duplicated chunk option 'label'" ones. MD5s before and after: the render changed only `manuscript/ms.pdf`.
- **A.5 PDF wording check: PASS, with one caveat on method** (Deviation 3).
  - **Pages:** old 16, new 16.
  - **Hits:** 11 in the old text, 0 in the new.
  - **Result:** after the substitution map plus whitespace and line-break-hyphen removal, the texts are **identical (37,953 characters)** once a genuine hyphen in a line break is accounted for.
- **A.6 completeness:** `pre-?regist` (case-insensitive) across in-scope tracked files = **0**. The excluded historical files still contain the old wording, as intended: `PROGRESS.md`, `cowork/DISPATCH.md`, the old `cowork/REPORT.md`, and 3 session notes.
- **A.7:** commit `de8497f` (36 files: the 33 substituted files, plus `fig_landscape.pdf/.png` and `ms.pdf`). Pushed; `origin/master` = `de8497f`.

**Part B: public copy** (`C:\Dev\Git-For-Metacognition-Paper`)
- **B.1:** all 36 paths from the Part A commit exist in the copy (none are paper2-only). They were exported from paper2 HEAD with `git cat-file blob`; **36 / 36 MD5-match**.
- **B.2:** both `ms.qmd` edits were re-applied. `diff` against paper2 HEAD shows **exactly 2 lines**: line 7 `author: "Brandon Chow"` and line 929, the public URL.
- **B.3:** in `data/raw/lund2025/README.md`, row 21's last cell changed `Yes` → ``No (downloaded by `analysis/00_fetch_verify.R`)``. `diff` against paper2 HEAD shows **exactly 1 line**. The file is LF (it is `-text` there). paper2's copy still says `Yes`.
- **B.4 render in the copy.**
  - Exit 0, all 19 chunks, all guards passed. Quarto's first LibPath is the copy's renv library. Only `ms.pdf` changed.
  - **16 pages.** The author reads **"Brandon Chow"**. The availability section shows `https://github.com/dondon20201/Git-For-Metacognition-Paper` (wrapped at its own hyphen, as in 014). 0 `pre-?regist` hits.
  - **`pdftotext -layout` diff** against paper2's new PDF: only the author line and the re-wrapped availability paragraph differ.
- **B.5 whole-repo check.** The copy's index was compared with paper2's HEAD tree.
  - **103 / 107 files are blob-identical.**
  - The 4 that differ are exactly the permitted ones: `README.md`, `manuscript/ms.qmd`, `manuscript/ms.pdf`, `data/raw/lund2025/README.md`.
  - No file exists only in the copy. `data/raw/` holds only `.gitkeep` and the README. `pre-?regist` in tracked files = **0**.
- **B.6:** a normal commit (no amend), **`6c9303c`** (`6c9303c0bfeade4413cf53c92036831612802af4`), by `dondon20201 <brandonchow2020@gmail.com>`: `Use "pre-specified" wording, clarify Figure 1 legend, correct data README`. Pushed with no force (`2a599ca..6c9303c`). `git ls-remote origin` shows `HEAD` = `refs/heads/main` = local HEAD = `6c9303c…`. The working tree is clean.

## Deviations from the dispatch (argued, never silent)

1. **`figures/fig_captions.md`: script 10 cannot regenerate the whole file by itself.**
   - **The problem.** Script 10 `writeLines()` the whole file with only the Figure 1 and Figure S1 captions (30 lines). The Figure 2 section (lines 31–34) is appended later by `analysis/16_confdb_figure.R` ("append once"). Running only script 10, as the dispatch requires, therefore deleted the Figure 2 caption. So the A.3 expectation ("its diff vs HEAD must consist only of the A.1 substitution") could not hold for the raw script output.
   - **What I did.**
     1. Verified that script 10's output is **byte-identical to lines 1–30 of the substituted HEAD file**.
     2. Restored lines 31–34 from the substituted HEAD file. These are the script-16 section, whose source string literal was itself substituted in A.1.
   - **Why this is correct.** The committed file is exactly what a 10 → 16 rerun produces, and its diff vs HEAD is the 2 substitution lines. I did not run script 16 (Constraints).
2. **`figures/figS_gap_vs_reliability.pdf` not committed.**
   - Script 10 regenerates it. The new file differed from HEAD in 20 bytes, **all inside the `/CreationDate` and `/ModDate` fields**; the size is the same (5,396 bytes).
   - The content is unchanged and its PNG is byte-identical, so I restored the PDF from HEAD to avoid a timestamp-only change in both repos.
3. **A.5 PDF wording check: the literal procedure produces one false mismatch, so I added one targeted normalization.**
   - **The cause.** In the new PDF, one line breaks at the genuine hyphen of "pre-|specified" (Discussion: "…across domains: in the pre-" / "specified confirmatory pair…"). The dispatch's "remove line-break hyphens" step turns that into `prespecified`. It is a check artifact; the source reads `pre-specified`.
     - poppler's default (non-layout) `pdftotext` already drops such hyphens itself, so I switched to `-layout` text, which keeps them.
   - **What I did.** In the new text only, I kept the hyphen when a line ends in `pre-` and the next line starts with `specifi`. This happened in exactly **1** place. I also removed line-break hyphens in the old text *before* substituting, in case a `prereg-` word had been hyphenated.
   - **Result:** identical. The line-end hyphen counts are old 27 and new 28, the +1 being this break.
   - **What remains:** the literal order (substitute → strip) differs at exactly that one position and nowhere else.

## Observations for Cowork (no action taken)

- **One mechanical result reads a little oddly:** "linear, as pre-specified-by-default — no quadratic term" (`results/STEP0B2_FINAL_REPORT.md:37`). It is a faithful substitution, so I did not reword it.
- **The 014 observation about dangling references still applies.** Public code comments now say e.g. "pre-specified in cowork/DISPATCH.md #004", which is still a pointer to a file the public cannot see. This dispatch did not ask for a change ("dispatch"/"Cowork" wording stays).
- **The Figure 1 caption text still says "(dispatch 006)" / "(dispatch 007)"** in `fig_captions.md` and in script 10's caption strings. Only the legend was in scope. The rendered manuscript PDF contains no "dispatch" at all; `ms.qmd` has it only in 4 source comments (lines 2, 29, 103, 349).
- **PROGRESS.md "Current status"** still lists "preregistered" wording and Fig 1 legend jargon as open Part D items. Updating that is Cowork's close-out; I only appended the session-log row.
- **Pipeline fragility:** rerunning script 10 alone always drops the Figure 2 caption (Deviation 1). A future dispatch could make script 10 preserve or rewrite only its own sections, or make script 16's append idempotent against a fresh file. That is low priority, because the full pipeline order (10 then 16) is correct.

## Files changed / created

- **paper2 (task commit `de8497f`, 36 files):**
  - `R/confdb.R`, `R/multilevel.R`
  - `analysis/01–10, 12–17` (17 scripts; `10` also has the legend change)
  - `figures/fig_captions.md`, `figures/fig_landscape.pdf`, `figures/fig_landscape.png`
  - `manuscript/ms.qmd`, `manuscript/ms.pdf`
  - `results/`: `STEP0_REPORT.md`, `STEP0B_PRIME_REPORT.md`, `STEP0B2_FINAL_REPORT.md`, `step2_REALDATA_transfer_check.md`, `step6_REALDATA_confirmatory.{csv,md}`, `step7_REALDATA_descriptive.md`, `step8_SIMULATION_step4gate_meta.json`, `step9_REALDATA_step4_{meta.json,multilevel.csv,multilevel.md}`, `step15_CONFDB_contrast.md`, `step17_claim_status.md`
- **paper2 (docs commit):** `cowork/REPORT.md` (this file), `PROGRESS.md` (session-log row 18), `cowork/DISPATCH.md` (Cowork's 015, committed by Code).
- **Public copy (`6c9303c`, 37 files):** the same 36 paths (with `ms.qmd` carrying its 2 copy edits and `ms.pdf` re-rendered in the copy) plus `data/raw/lund2025/README.md` (1 line).

## Commits

- **paper2:** **`de8497f`** `fix: dispatch 015 — "pre-specified" wording + Figure 1 legend`. Pushed; `origin/master` verified = `de8497f` at the time of push.
- **paper2:** the final `docs:` commit holds this report, `PROGRESS.md` and `cowork/DISPATCH.md`. It is the latest commit touching REPORT.md, and it is pushed to `origin/master`.
- **Public repo:** **`6c9303c`** (`6c9303c0bfeade4413cf53c92036831612802af4`) `Use "pre-specified" wording, clarify Figure 1 legend, correct data README`. Pushed with no force; `ls-remote` = local HEAD.

## Results / state

- **Both repos say "pre-specified" everywhere in scope:** 0 `pre-?regist` hits in paper2's in-scope files, the public copy's tracked files, and both rendered PDFs.
- **No number changed anywhere.** The digit-run guard passed on 33/33 files. Figure data CSVs are byte-identical. Both renders passed every assert-guard. The PDF text matches the old text under the substitution map.
- **Figure 1's legend reads "CONFIRMATORY (corrected)"** in both repos, matching Figure S1.
- **The public data README is now correct:** `mle_fit_data_wide.csv` → "No (downloaded by `analysis/00_fetch_verify.R`)".
- **The public copy = paper2 HEAD, except the 4 sanctioned files.**

## Issues & questions for planning

1. **Should script 10 stop truncating `fig_captions.md`** (Deviation 1)? This only matters if script 10 is ever rerun on its own again.
2. **Caption text "(dispatch 006/007)"** in `fig_captions.md` and script 10: leave it, or strip it like the legend? This is Ben's call; it is the same class as decision 2.
3. **Dangling `cowork/DISPATCH.md` / `BRIEF.md` references in public files** remain open from 014 (Issue 2 there).
4. **Still open from 014:** the paper2 ↔ public sync procedure (this dispatch's export-by-blob + re-apply-3-edits + blob-compare worked cleanly and could be the template); the author block (affiliation, ORCID, email); and the Dondon xfun cache defect.
