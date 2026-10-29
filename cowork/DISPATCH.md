# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 017 (revised; replaces the earlier 017 draft, which was never run)
**Date:** 2026-10-29
**From:** Cowork. Dispatch 016 AUDITED AND CONFIRMED independently against a fresh GitHub clone: HEAD `e30d015`, exactly the 29 in-scope paths changed (+40 −1,052), and my own separately written R-lexer reproduced all 29 files byte for byte (907 + 40 R comments, 57 chunk comments, 20 `#|` kept, 4 YAML, 1 HTML block, 14 config lines, 35 quoted-`#` lines kept). Other 78 files unchanged. Two corrections to your report: leftover "dispatch" strings are in 10 scripts (05, 06, 07, 08, 09, 10, 11, 14, 15, 17), not 05–09; and "prereg" survived 015 in 8 strings (06, 07, 09) because the 015 search was for "preregist" (my miss too).

## Ben's direction (read first)

**Git-For-Metacognition-Paper is a standalone repo. It has no connection to paper2.**
- Work ONLY in `C:\Dev\Git-For-Metacognition-Paper`. Do not edit anything in paper2 (only this mailbox: `cowork/REPORT.md` and the `PROGRESS.md` row, as usual).
- The paper2 → public sync procedure from 016 is **retired**. From now on, changes are made directly in the public repo.
- Two goals, nothing else:
  1. Remove every internal-workflow word: "dispatch", "Cowork", "BRIEF.md", "Ben", "prereg", "paper2", and the dispatch "Part A/B/C/D" labels.
  2. Anyone who downloads the repo can run it: fix the known blockers in Part B. **Ben does not want a full test run of the pipeline; do not run the analysis scripts.**
- No analysis number, manuscript prose, label, caption or chunk setting changes. No comments get added back. History stays as it is (normal commits, no force-push).

## Part A: word cleanup (public repo)

**A.1 Script strings.** Apply exactly these replacements in `analysis/*.R`. Each OLD fragment must match exactly once in its file (stop if not). Only string-literal text changes.

**05_realdata_reliability.R**
1. `Pre-specified rule (dispatch 005):` → `Pre-specified rule:`
2. `; stated per the dispatch.` → `, as pre-specified.`
3. `## Material notes for dispatch 006` → `## Material notes for the confirmatory analysis`
4. `computed in this dispatch.` → `computed in this step.`

**06_confirmatory_memvis.R**
5. `stopping (prereg guard).` → `stopping (pre-specified input guard).`
6. `STOPPING per prereg #5; dispatch back to Cowork.` → `STOPPING per pre-specified rule 5.`
7. `memory × vision (dispatch 006)` → `memory × vision`

**07_descriptive_pairs.R**
8. `stopping (prereg guard).` → `stopping (pre-specified input guard).`
9. `reported as such per prereg #5.` → `reported as such per pre-specified rule 5.`
10. `bounded fallback (prereg #5)` → `bounded fallback (pre-specified rule 5)`
11. `domain pairs (dispatch 007)` → `domain pairs`
12. `is the dispatch-006 confirmatory result,` → `is the confirmatory result,`
13. `**CONFIRMATORY (dispatch 006)**` → `**CONFIRMATORY**`

**08_step4_recovery_gate.R**
14. Delete the list element line `dispatch = "008 Part A",` (the JSON key goes away).
15. `IMPLEMENTATION CHOICE — dispatch specified mean slope` → `IMPLEMENTATION CHOICE — the plan specified mean slope`
16. `0.4 (= mean/2) chosen and flagged in REPORT.md for Cowork audit` → `0.4 (= mean/2) chosen`

**09_step4_multilevel.R**
17. `Part B must not run (prereg).` → `the multilevel decomposition must not run (pre-specified).`
18. `stopping (prereg guard).` → `stopping (pre-specified input guard).`
19. `report and stop (prereg).` → `report and stop (pre-specified).`
20. `multilevel decomposition (dispatch 008)` → `multilevel decomposition`

**10_landscape_figures.R**
21. `# Figure captions (dispatch 008, Part C)` → `# Figure captions`
22. `CONFIRMATORY pair (dispatch 006):` → `CONFIRMATORY pair:`
23. `DESCRIPTIVE (dispatch 007):` → `DESCRIPTIVE:`

**11_confdb_fetch.R**
24. `STOPPING per dispatch (do not` → `STOPPING (do not`

**13_confdb_measures.R**
25. `=== Part D summary ===` → `=== Summary ===`

**14_confdb_nullref.R**
26. `=== Part A: tuning per-task` → `=== Tuning per-task`
27. `=== Part A: null-world replicates (` → `=== Null-world replicates (`
28. Delete the list element line `dispatch = "010 Part A",` (the JSON key goes away).
29. `per study x scenario, per dispatch)` → `per study x scenario)`
30. `=== Part A gate ===` → `=== Null-reference gate ===`

**15_confdb_contrast.R**
31. `message("Part A null-reference gate: "` → `message("Null-reference gate: "`
32. `raw gap; Part A gate FAILED` → `raw gap; null-reference gate FAILED`
33. `level-vs-sensitivity contrast (dispatch 010)` → `level-vs-sensitivity contrast`
34. `md5-verified at fetch (dispatch 009) and` → `md5-verified at fetch and`
35. `SKIPPED (Part A gate failed)` → `SKIPPED (null-reference gate failed)`
36. `selected mechanically (dispatch 009), but` → `selected mechanically, but`
37. `forest display only, dispatch 010).` → `forest display only).`
38. `"- Part A null-reference gate: %s."` → `"- Null-reference gate: %s."`

**17_claim_status.R**
39. `# Claim-status table (dispatch 011, Part A)` → `# Claim-status table`
40. `Status labels follow BRIEF.md:` → `Status labels:`
41. `Part A OK: 9 rows` → `OK: 9 rows`

**A.2 Outputs (text edit; no reruns).** Apply the same replacements where they appear:
- step2 md: 1–4; step6 md: 7; step7 md: 11–13; step9 md: 20; step15 md: 33, 34, 36, 37, and item 38's filled-in form `- Part A null-reference gate: PASS.` → `- Null-reference gate: PASS.`; step17 md: 39–40; `figures/fig_captions.md`: 21–23.
- `results/step8_SIMULATION_step4gate_meta.json`: remove the `"dispatch"` key; 15–16 in `sd_slope_total_note`.
- `results/step14_SIMULATION_confdb_nullref_meta.json`: remove the `"dispatch"` key; 29 in `seeds`.
- (Cowork dry-ran A.1 + A.2 on the GitHub files: every fragment matches once, 0 hits remain, and the only digits removed are the dispatch labels 005–011.)

**A.3 Other files.**
- `git rm` `results/STEP0_REPORT.md`, `results/STEP0B_PRIME_REPORT.md`, `results/STEP0B2_FINAL_REPORT.md` (hand-written planning memos; nothing in the manuscript or README uses them).
- `manuscript/supplement.qmd`: `title: "Supplementary tables [PLACEHOLDER — companion to ms.qmd]"` → `title: "Supplementary Tables"`, add `subtitle: "What Generalizes in Metacognition? Confidence Level, Informativeness, and a Measurement-Reliability Account of Apparent Dissociations"`, `author: "Ben [Author]"` → `author: "Brandon Chow"`. Date unchanged.
- `manuscript/references.bib`: delete the two leading `%` lines. ("Bolker, Ben" in the lme4 entry is a cited author and stays.)
- `.gitignore`: drop the line `.claude/settings.local.json`; put that pattern in this repo's local `.git/info/exclude` so it still works but is not published.

## Part B: make it run from a plain download

1. **No git needed at run time.** Scripts 06, 07, 09 check their inputs with `system("git diff --quiet HEAD -- ...")`. That fails for anyone who downloads the ZIP or has no git. Replace each with an MD5 check of the same files against their committed contents, hashing with line endings normalized to LF (so a Windows CRLF checkout still matches). Same files, same stop, same message as after Part A. Hard-code the MD5s the same way the raw-data check right above already does.
2. **Root without `.git`.** Add an empty `.here` file at the repo root, so `here()` finds the root in a ZIP download (Quarto runs R from `manuscript/`).
3. Commit both parts as one normal commit with a plain message containing none of the Part A words (e.g. `Tidy script messages, finalize supplement title, remove git dependency`). Push, no force.

## Part C: guards on the repo (all must pass)

1. **Words:** case-insensitive `dispatch|cowork|brief|prereg|paper2|claude|placeholder|\bPart [A-E]\b` over all text files except `renv.lock` and `renv/activate.R` (renv's third-party files) = **0 hits**. `\bBen\b` = only "Bolker, Ben" in `references.bib`. Paste the command and output.
2. **Only the intended edits:** applying the A.1/A.2 list to each old file reproduces the new file exactly, except the B.1 guard blocks in 06/07/09. Digit runs are unchanged except the removed labels 005–011 and the new MD5 strings.
3. **Code:** the parse trees of the edited scripts differ only in the edited strings, the two deleted `dispatch = ...` elements and the B.1 blocks. `grep -rnE '^\s*#' R analysis` = 0 (no comments added).
4. **JSON:** both meta files parse; all fields identical except the removed key and the two edited strings.
5. **Render in the repo:** `ms.pdf` text identical to the committed one (restore from HEAD if only metadata differs). The supplement renders, with only its title block changed; delete its PDF.
6. **Tree diff vs `e30d015`:** 11 scripts (05, 06, 07, 08, 09, 10, 11, 13, 14, 15, 17), 6 results `.md`, 2 meta `.json`, `figures/fig_captions.md`, `manuscript/references.bib`, `manuscript/supplement.qmd`, `.gitignore` (23 modified); `.here` added; the 3 memos deleted. Anything else = stop.
7. **B.1 sanity check without running the analyses:** source only the new guard block of 06, 07 and 09 (not the scripts) in the repo, and once in a copy of the repo with `.git` removed: it must pass on the committed files, and must stop if one input file has one byte changed.

## Part D: report

In `cowork/REPORT.md`: every replacement applied (per file, counts); the B.1 code before/after and the guard-7 result; guard outputs; public commit hash and `ls-remote`. PROGRESS.md session-log row 20. `docs:` commit in paper2 (mailbox only), push.

## Constraints
- Nothing in paper2 changes except the mailbox files.
- No number, prose, label, caption or chunk-setting changes. The public `ms.pdf` text must not change.
- Third-party text stays: renv files, and cited authors in `references.bib`.
- No force-push.
