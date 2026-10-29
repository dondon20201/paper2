# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 014
**Date:** 2026-10-28
**From:** Cowork. Dispatch 013 confirmed done (commits 750c71e + 6acef84, pushed 2026-10-26). This dispatch = **build the public replication copy**: populate the new, currently EMPTY public repo `https://github.com/dondon20201/Git-For-Metacognition-Paper` from paper2. **paper2 itself stays unchanged** (only the usual REPORT.md + PROGRESS.md log entries are written in paper2). **No analysis reruns.**

## Ben's decisions applied (defaults; Ben may override before running)
1. Manuscript author in the PUBLIC COPY: replace the placeholder `author: "Ben [Author]"` with `author: "Brandon Chow"` (Ben's earlier instruction for this paper). paper2's own ms.qmd is NOT edited.
2. License: **none** (no LICENSE file) unless Ben says otherwise.
3. History: the copy starts with a fresh history (one initial commit). paper2's history is not carried over.

## Part A: build the copy
1. Create `C:\Dev\Git-For-Metacognition-Paper` (sibling of paper2). Fail and report if it already exists and is non-empty.
2. Source of truth = the files paper2 tracks in git at HEAD (`git -C C:\Dev\paper2 ls-files`). This automatically excludes everything gitignored (raw data, renv/library, rendered supplement PDF, .quarto).
3. From that list, EXCLUDE these internal project-management paths: `cowork/`, `CLAUDE.md`, `BRIEF.md`, `PROGRESS.md`, `_inbox/`, `.claude/`, and the old one-line `README.md` (replaced in Part B).
4. Copy every remaining tracked file byte-for-byte, preserving paths. This must include at least: `R/`, `analysis/` (00 to 17), `results/`, `figures/`, `manuscript/ms.qmd`, `manuscript/supplement.qmd`, `manuscript/references.bib`, `manuscript/ms.pdf`, `renv.lock`, `.Rprofile`, `renv/activate.R`, `renv/settings.json`, `renv/.gitignore`, `_quarto.yml`, `.gitignore`, `.gitattributes`, and any tracked `data/` READMEs. If any of these is not in `ls-files`, report it rather than copying an untracked version.
5. Verify the copy: for every copied file, MD5 must equal the paper2 HEAD version. Report the count (copied / matched). Then confirm no file under `data/raw/` other than README/.gitkeep exists in the copy, and report the total size of the copy.

## Part B: the two edits allowed in the copy (and only in the copy)
1. **New top-level README.md**, text exactly as below (Cowork-authored).
2. **manuscript/ms.qmd in the copy only:** (a) the author line per decision 1; (b) in the "Data and code availability" section, change the code URL `https://github.com/dondon20201/paper2` to `https://github.com/dondon20201/Git-For-Metacognition-Paper` (that section currently points readers to the source repo, which the public may not be able to open). Change nothing else in ms.qmd.

README.md text:

```
# What Generalizes in Metacognition? Confidence Level, Informativeness, and a Measurement-Reliability Account of Apparent Dissociations

Brandon Chow

Replication materials for the paper. Every number reported in the manuscript is computed by the scripts in `analysis/` and written to a file in `results/`. The manuscript reads those files directly, and rendering fails if any reported value does not match its source file.

## Contents

- `analysis/`: numbered analysis scripts, run in order (00 to 17)
- `R/`: shared functions used by the scripts
- `results/`: every computed number (CSV and JSON); simulation outputs carry SIMULATION in their file names
- `figures/`: figures; the data behind each figure is saved in `results/`
- `manuscript/`: manuscript source (`ms.qmd`), supplement, references, and the rendered `ms.pdf`
- `renv.lock`: exact R package versions

## Data

Raw data are not redistributed here. The scripts download them from their original sources and verify every file before use.

- Lund et al. (2025): trial-level data from `github.com/embodied-computation-group/dg-metacognition` at a pinned commit, verified by MD5 (`analysis/00_fetch_verify.R`; provenance in `results/step0a_provenance.json`).
- Confidence Database (Rahnev et al., 2020): OSF node `s46pr`, each file checked against its OSF MD5 (`analysis/11_confdb_fetch.R`; manifest in `results/step11_CONFDB_manifest.csv`).

## Reproducing

1. Install R 4.6.1 and Quarto.
2. In R, from the repository root: `renv::restore()`
3. Run the scripts in `analysis/` in numerical order.
4. Render the manuscript: `quarto render manuscript/ms.qmd`
```

## Part C: render check in the copy
1. In the copy: `renv::restore()` (renv's global cache on Dondon should make this fast), then `quarto render manuscript/ms.qmd`. The render MUST succeed: its assert-guards re-check every reported number against the copied `results/`, which proves the copy is intact. If it fails, stop and report; do not patch.
2. `pdftotext manuscript/ms.pdf`: confirm the author reads "Brandon Chow", the availability section shows the new URL, and the page count (paper2's is 16). Keep the re-rendered ms.pdf in the copy.
3. Do not render supplement.qmd (its PDF is gitignored in paper2 too).

## Part D: commit and push the copy
1. `git init -b main` in the copy; add remote `origin = https://github.com/dondon20201/Git-For-Metacognition-Paper.git`.
2. One commit: `Initial release: replication materials for "What Generalizes in Metacognition?"`
3. Push to `origin main`. Verify with `git ls-remote origin` that `main` equals local HEAD. Report the hash.
4. If the push is rejected because the remote is not empty, STOP and report; do not force-push.

## Part E: housekeeping in paper2 (logging only)
1. Overwrite `cowork/REPORT.md` (keep its template): what was copied, MD5 match counts, size, render result, pushed hash, anything excluded or missing.
2. PROGRESS.md: session-log row 17, one line.
3. Commit those two files in paper2 (`docs:` commit) and push paper2 as usual. Nothing else in paper2 changes.

## Constraints
- Never modify paper2's ms.qmd, results/, analysis/, figures/, or any data.
- Never copy raw data into the public copy.
- No force-push anywhere.
- Do not edit code comments or any file content beyond the two Part B edits.
