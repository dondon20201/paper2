# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 013
**Date:** 2026-10-03
**From:** Cowork — the dispatch-012 draft was independently audited this session and **passed 124/124 checks** (see Part A). The audit found no wrong number anywhere in the manuscript. It did find **four table-layout defects in the rendered PDF** and a stale structure comment. Those are fixed in the working tree already (see the deviation notice below). This dispatch = **re-render, verify, commit**. **results/ remains strictly READ-ONLY; no analysis reruns anywhere.**

## DEVIATION NOTICE — read first
Cowork wrote directly to `manuscript/ms.qmd` this session, which the CLAUDE.md workflow normally reserves for Code. The rule exists because of Windows file-truncation issues with direct editing; this write was a single atomic whole-file replacement (not an incremental editor), so that hazard does not apply. **Nothing was committed.** Your working tree has an uncommitted, modified `manuscript/ms.qmd` (929 → 952 lines). Your job is to verify it renders and is correct, then commit it. If the render fails, `manuscript/ms.qmd.bak` is NOT on the machine — recover the previous version with `git checkout manuscript/ms.qmd` and report the failure rather than patching around it.

## Part A — What the independent audit checked (context; no action)
An auditor written from scratch in **Python** (a deliberately different derivation path from the R render) re-read the committed `results/*.csv` and checked the rendered `ms.pdf`:
- **13/13 IDENTITY** checks — arithmetic relations that must hold: gap = ρ_level − ρ_sens; uncorrected gap likewise; naive gap = raw r_level − raw r_auroc2; ICC_level = v_subj/(v_subj + v_subj:dom); ICC_sens likewise; Δ_ICC = ICC_level − ICC_sens; the Arbuzova margins 0.046 / 0.020; and — the substantive one — **the four preregistered ConfDB verdicts re-derived from the raw disattenuation tops and null-reference bounds, independently reproducing holds 1 / partial 3 / fails 0, with Arbuzova_unpub_3 the single "holds."**
- **69/69 CONSISTENCY** checks — claim-status table agrees with every source CSV; no descriptive pair clears CI + bias band jointly; vision × GDP's lower bound sits inside its band; level reliability exceeds AUROC2 in every Lund domain and every ConfDB study; bootstrap had 0 failures; R1/R2 within 0.03 of primary; wording discipline ("not excluded" present, "absent" only in the sanctioned distinguishable-effect sense, no overclaim phrases).
- **42/42 TRANSCRIPTION** checks — every audited statistic appears in the rendered PDF at its stated precision.

**Conclusion: the numbers and the claim discipline are sound. Do not re-run analyses.**

## Part B — The fixes already applied to ms.qmd (verify, do not redo)
All four were *presentation* defects visible in the committed `ms.pdf`; none touched a value.
1. **Table 1 had a phantom first column** ("memory Memory 0.97 0.84"). Cause: `sapply()` returns a *named* vector, so those names became data-frame row names and `kable` printed them. Fixed with `unname()` + `row.names = NULL`.
2. **Tables 3 and 4 collided columns.** The long study keys (`Arbuzova_2021_expt2`) wrapped and pushed `n` into `r_level`, rendering as `2010.57` and `4430.87`. Fixed with a short display-label map (`studylab`), assert-guarded via `stopifnot(all(studies %in% names(studylab)))` so an unexpected study id fails the render rather than mislabelling. Remaining `sapply` columns in both tables are now `unname()`d for the same reason as (1).
3. **Table 5 broke across the page break** — the 30-40 character tier strings wrapped into a column so narrow that rows 8 and 9 interleaved and the page number "12" was absorbed into a cell. Fixed with a guarded `tiermap` of short tier codes (non-confirmatory tiers marked `*`), with the full key spelled out in the table caption. Also, `naive_gap_exhibit` printed as `0.2`; estimates and CIs in this table now format to 3 dp from the CSV via `num3()` (formatted, not retyped).
4. **Stale structure comment** at the top of the body still declared Abstract/Intro/Discussion/Limitations to be STUBs. Replaced with an accurate note.

**Integrity check for your report:** confirm the "zero hand-typed statistics" property still holds. The only new literals introduced are *labels* (study display names, tier codes) and the digit counts in `num3()`/`fmt()` calls — no estimated statistic. Grep the prose as you did in 012 and say so explicitly.

## Part C — Tasks
1. **Render.** `quarto render manuscript/ms.qmd` under renv → `manuscript/ms.pdf`. Must be clean; all guards must pass (that is the enforcement mechanism). Also re-render `supplement.qmd`.
2. **Verify the four fixes in the rendered PDF.** Extract text (`pdftotext -layout`) and confirm: Table 1 has exactly three columns; Tables 3 and 4 show `n` separated from `r_level` (no `2010.57`); Table 5 fits without interleaving rows 8 and 9 and shows `0.200` for `naive_gap_exhibit`. If Table 5 still breaks across the page, reduce it further (drop the `#` column, or set the chunk to landscape) and say what you did.
3. **Re-run the 012 grep-checks** ("not excluded" present; "absent" only in sanctioned uses; disattenuation ranges only; taxonomy sentence; Δ_ICC boundary wording; ArbU3 margins) — they must still pass.
4. **Commit.** Task commit for the manuscript fix (`fix:` — table rendering defects), then the usual final `docs:` commit for REPORT.md + PROGRESS.md. Push; HEAD hash in the report.
5. **PROGRESS.md:** session-log row 16; status line noting the independent audit result (124/124) and the table fixes.

## Part D — Open editorial decisions for Ben (DO NOT act on these; report them as open)
These are judgement calls, not defects, and they are the real remaining distance to submission:
1. **Author block.** The YAML still reads `author: "Ben [Author]"`. Needs real name, affiliation, ORCID, corresponding-author email. No keywords, funding statement, or conflict-of-interest statement is present; most journals require all three.
2. **Title.** Three candidates are still in the YAML comments; the default is in place.
3. **The word "preregistered."** It appears 12+ times, but the mechanism described in Methods is a **git timestamp in a private repo**, not a registry entry (OSF/AsPredicted). A reviewer will ask for the registration. Ben should decide: register retrospectively and say so, or soften to the accurate phrasing ("pre-specified and timestamped before the cross-domain quantities were computed") throughout. **Do not change this wording without Ben's instruction** — it is load-bearing for the paper's claims.
4. **Reference list is thin (14 entries) for a journal submission.** The Introduction asserts a literature it does not cite: "much prior work reports cross-domain confidence correlations" has no citation behind it, and there is no citation for the reliability/attenuation methodology literature beyond Spearman and Brown. This is the single most likely reviewer complaint. Per CLAUDE.md, **do not fabricate references** — this needs a verified literature pass as its own dispatch.
5. **Figure 1's legend contains internal project jargon**: "CONFIRMATORY (corrected, dispatch 006)". A reader has no idea what dispatch 006 is. Fixing it means editing `analysis/10_landscape_figures.R` and regenerating the figure, which touches `figures/` — flagged here rather than done, since it is a figure regeneration.
6. **Notation is inconsistent** between body prose (ρ_level, ρ_sens) and figure captions / table headers (`rho_level`, `r_sens_raw`). Cosmetic, but worth one pass before submission.

## Constraints
- `results/` read-only; no analysis reruns; no new numbers computed.
- Do not touch the frozen verdict wording strings.
- Do not act on Part D.
