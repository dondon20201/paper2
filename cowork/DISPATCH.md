# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 016
**Date:** 2026-10-29
**From:** Cowork. Dispatch 015 AUDITED AND CONFIRMED independently: 0 "preregist" left in either repo; 33/34 changed text files differ only by the word swap (the 34th, script 10, also has the legend fix); every number unchanged except the intended "006" leaving the legend; figure data CSVs unchanged; public PDF text = old text with only the swap; public vs paper2 differ in exactly the 4 sanctioned files; GitHub serves the new data README line. Your three deviations were correct calls.
**This dispatch:** Ben wants **all comments removed from the PUBLIC copy's code**. **paper2 keeps every comment** (it is the private working source). No analysis reruns; no wording changes to any prose.

## Part A: a reusable comment stripper (lives in paper2, never published)
1. Create `tools/strip_public_comments.R` in paper2 and add `tools/` to the public-copy exclusion list (alongside `cowork/`, `BRIEF.md`, `CLAUDE.md`, `PROGRESS.md`, `README.md`). Future paper2 → public syncs use it (Part D).
2. Method (use R's own parser, never regex, for R code):
   - **R scripts:** `getParseData(parse(file, keep.source = TRUE))`; delete every `COMMENT` token's text span. A line left empty or whitespace-only by the deletion is removed; trailing whitespace left on a code line is trimmed; then runs of 2+ blank lines collapse to 1. A `#` inside a string is not a COMMENT token and is never touched.
   - **.qmd files:**
     - Inside each ` ```{r} ` chunk, parse the chunk code and remove COMMENT tokens the same way, EXCEPT keep every token whose text starts with `#|` (Quarto chunk settings: labels, captions; removing them breaks the manuscript).
     - Remove comment lines inside the YAML front matter.
     - Remove HTML comments `<!-- ... -->`.
     - Prose outside chunks, inline `` `r ...` `` code and chunk headers must not change.
   - **Config files** (`.gitignore`, `.gitattributes`, `_quarto.yml`): delete lines whose first non-space character is `#`. Every pattern/setting line stays, in order.

## Part B: apply to the public copy (`C:\Dev\Git-For-Metacognition-Paper`)
- **In scope:** `R/*.R`, `analysis/*.R`, `manuscript/ms.qmd`, `manuscript/supplement.qmd`, `.gitignore`, `.gitattributes`, `_quarto.yml`.
- **Do NOT touch:** `renv/activate.R` (renv's own generated bootstrap), `renv.lock`, `renv/settings.json`, `.Rprofile`, `README.md`, `references.bib`, everything in `results/`, `figures/`, `data/`.
- Expected scale (Cowork's rough count; report the exact parser counts): about 907 full-line comment lines across 24 R scripts, plus trailing comments. In the two .qmd files: 57 chunk comment lines; 4 YAML comment lines; 1 HTML comment block; 20 `#|` lines that must SURVIVE. 14 comment lines across the three config files.

## Part C: guards (all must pass, or stop and restore from HEAD)
1. **Code unchanged, per R file and per chunk.** The token stream excluding COMMENT tokens (token type + text, from `getParseData`) is identical before and after. COMMENT tokens after = 0 (in .qmd chunks, only `#|` tokens remain). Report the number removed per file.
2. **Chunk settings intact.** The `#|` lines in ms.qmd and supplement.qmd are identical before and after: same count (20), same text, same order.
3. **Prose intact.** In each .qmd, the lines outside code chunks, YAML comments and HTML comments are byte-identical before and after.
4. **Config intact.** The non-comment lines of each config file are identical, in order.
5. **Render.** `quarto render manuscript/ms.qmd` in the copy exits 0, all assert-guards pass, and the `pdftotext` text of the new ms.pdf is IDENTICAL to the text of the currently committed public ms.pdf (comments never render). Same page count (16). Any text difference = stop.
6. **Provenance check.** For every in-scope file, running the stripper on the paper2 HEAD version must reproduce the public file exactly. For ms.qmd, also re-apply the 2 public edits (author, URL) and compare. This proves the copy differs from paper2 only by stripped comments plus the already-sanctioned edits.
7. `grep -rnE '^\s*#' R analysis` in the copy returns nothing.

## Part D: commit, push, record the sync procedure
1. Public copy: one normal commit, `Remove code comments`. Push `origin main`. **No force-push.** Verify `git ls-remote` = local HEAD; report the hash.
2. paper2: commit `tools/strip_public_comments.R` (`feat:`).
3. In `cowork/REPORT.md`, write the **standing sync procedure** for future changes: export changed paper2 HEAD blobs, run the stripper on them, re-apply the public edits (ms.qmd author + URL; data README `mle_fit` row), render, run guards C.1–C.7, then a normal commit and push.
4. PROGRESS.md session-log row 19. `docs:` commit, push paper2.

## Constraints
- paper2's own code keeps all its comments.
- No prose, number, label, caption or chunk-setting changes anywhere.
- Prose documents (`results/*.md`, `figures/fig_captions.md`, the data README) are NOT comments and are out of scope for this dispatch.
- No force-push; earlier public commits stay in history as they are.
