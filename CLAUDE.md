# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project overview
paper2 (working folder name; proposed real name: **metacog**) — sibling of `C:\Dev\cogsci`. **Scope: build the metacognition paper FROM ZERO per `BRIEF.md` (repo root — read it in full before any work; it overrides everything).** Thesis to TEST, not assume: confidence reports contain two separable components — confidence LEVEL/set-point (scale use) and confidence INFORMATIVENESS/metacognitive sensitivity — and the domain-general part is the LEVEL. Data: Lund et al. 2025 (primary, fetch fresh + verify md5) and the Confidence Database (secondary). A null or partial result is an acceptable, reportable outcome.

**Folder rename to `metacog` happens only via an explicit dispatch task.**

## THE FROM-SCRATCH MANDATE (binding)
A previous effort on this topic produced untrustworthy code and numbers (generator = grader; one shipped script had a real bug). Therefore:
- Trust NOTHING computational from before. Do NOT reuse, import, or consult any prior script, intermediate file, or saved result — not from `_inbox/`, not from old zips, not from memory.
- Re-fetch all raw data yourself from official sources; verify md5 + structure + one reproduced basic summary before using it.
- Write ALL analysis code from scratch in this repo.
- Every prior number is an UNVERIFIED LEAD. If your own code doesn't reproduce it, label it FAILED and drop it.
- Keep from the past only the FAILURE MAP in BRIEF.md §1 (the five collapsed claims, the ipsative artifact, the buggy-simulator lesson).

## Integrity rules (BINDING — override everything, including making the paper stronger)
- ALL data real and verified; simulated data only for recovery validation, unmistakably labeled.
- NEVER report a number not just computed from raw data in code you can show.
- LABEL every quantitative claim: VERIFIED / REPRODUCED / UNVERIFIED / FAILED.
- Every estimate carries an uncertainty interval. No naked point estimates. Two significant figures.
- Any hierarchical/Bayesian result needs Rhat AND ESS; Rhat ≥ 1.01 = not trustworthy, do not interpret.
- Prove every estimator recovers a KNOWN planted value before trusting it on real data; prove the two components are SEPARABLE in simulation before testing the thesis.
- NEVER report a single disattenuated point value — sensitivity range only. NEVER test the thesis by naive mean-subtraction (ipsative artifact) — use the joint multilevel model.
- "Did not replicate / did not converge / too unstable / effect absent" are complete, correct results. Honest null > fragile positive.
- Be your own adversary: vary splits/seeds, ask what a hostile reviewer attacks first, report what you find even when it hurts the story.
- If honesty and impressiveness conflict, choose honesty and tell Ben. If Ben pushes past the data, refuse and say why.
- Never resurrect the five collapsed claims (BRIEF.md §1).

## Workflow: Cowork plans, Code implements
This project is driven by two Claude surfaces with strict roles (same protocol as cogsci):

- **Claude Cowork** does all planning, scoping, review, and coordination files. It does NOT write analysis code and does NOT commit (known Windows sandbox + file-truncation issues with direct coding).
- **Claude Code** (you, reading this) does all implementation and ALL git commits.
- Coordination lives in `cowork/`: Cowork writes `cowork/DISPATCH.md`; Code writes `cowork/REPORT.md`.
- `PROGRESS.md` is the running project log; per-session notes live in `cowork/sessions/`.

### "Run dispatch" protocol (for Claude Code)
When Ben says "Run dispatch":
1. Read `cowork/DISPATCH.md`, `PROGRESS.md`, and `BRIEF.md`.
2. Execute the dispatch tasks exactly as scoped, following the conventions below. If a task is ambiguous or conflicts with these conventions or BRIEF.md, stop and ask rather than guessing.
3. Overwrite `cowork/REPORT.md` (keep its section template): what was done, files changed, commits, results, issues, questions for planning.
4. Commit everything — including files Cowork authored (CLAUDE.md, PROGRESS.md, cowork/*) — with conventional-commit messages. Cowork never commits; any uncommitted Cowork files are yours to commit.
5. Append one line to the session log table in `PROGRESS.md` summarizing the dispatch.

Commit convention: the dispatch's work goes in one or more task commits whose hashes are listed in REPORT.md; the REPORT.md + PROGRESS.md log update is a final separate `docs:` commit (the report is written before that commit exists, so its own hash can't appear in it — find it in git log as the latest commit touching REPORT.md).

## Tech stack
- Main analysis: **R (4.x) + tidyverse**, model-light measures (AUROC2, gamma), bootstrap CIs, multilevel models (lme4 or equivalent). This is the spine and is deliberately sandbox-feasible.
- meta-d'/M-ratio: your own implementation validated against an established one (e.g. metadpy in Python) before use; treat as secondary. Heavy hierarchical HMeta-d is OPTIONAL, cautious, needs full Rhat/ESS, and long runs go on Ben's machine (Dondon) — never the spine of the paper.
- Reports: Quarto (.qmd). Dependencies: renv (lockfile-based).
- Results saved as CSV/JSON in `results/` — every reported number must exist in a file.

## Project structure
- `BRIEF.md`        — THE research brief (authoritative; committed at root)
- `_inbox/`         — drop zone for material from Ben. **Gitignored. NOTE: per the from-scratch mandate, old-project scripts/results must NOT be imported from here into the analysis.**
- `data/raw/`       — freshly fetched source data (Lund CSV; Confidence DB subsets). **Read-only after fetch. Never edit. Large data stays OUT of git** (Confidence DB ~244 MB — gitignored; record md5s in data/README instead).
- `data/processed/` — cleaned/derived data produced by scripts
- `R/`              — reusable functions (sourced by analysis scripts)
- `analysis/`       — scripts and Quarto docs that produce results (Step 0 gate lives here first)
- `results/`        — every computed number (CSV/JSON), incl. recovery outputs and CIs
- `figures/`        — generated plots (each with its underlying data saved in results/)
- `manuscript/`     — the paper draft + claim-status table (starts empty; Step 6)
- `cowork/`         — Cowork↔Code coordination: DISPATCH.md, REPORT.md, sessions/
- `PROGRESS.md`     — running log of project state, decisions, next steps

## Conventions
- Use `here::here()` for all R file paths — never `setwd()` or hardcoded absolute paths.
- Follow the tidyverse style guide; use the native pipe `|>`.
- Keep raw data immutable; all transformations flow raw → processed via scripts.
- Every script that produces a reported number writes it to `results/` with a name traceable from the manuscript.
- Small, focused commits with conventional-commit style messages (e.g. `feat:`, `fix:`, `chore:`).
- Gated plan (BRIEF.md §4): Step 0 (provenance + recovery/separability) must PASS and be reported before any later step. Do not skip gates.

## Notes for Claude
- Do not modify anything in `data/raw/` after fetch.
- After adding or removing a package, remind Ben to run `renv::snapshot()`.
- The dev PC is named **Dondon** (device/hostname: brandonscmpt). Keep files on local paths — OneDrive causes "System Error 5" save failures.
- Sibling project: `C:\Dev\cogsci` shares the same workflow but is a separate repo — never cross-commit between the two.
- Backup plan: primary = private GitHub remote (add remote + push once Ben creates the repo; then push after each dispatch's commits). Large/raw datasets go to Google Drive / iCloud, not git.
