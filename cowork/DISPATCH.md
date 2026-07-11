# Cowork → Code Dispatch

<!-- Written by Claude Cowork after each planning session. Claude Code executes this when Ben says "Run dispatch". This file is overwritten per dispatch; history lives in git. -->

**Status:** READY
**Dispatch #:** 011
**Date:** 2026-07-11
**From:** Cowork — 010 AUDITED AND CONFIRMED (all four primary r_level/r_sens/gap re-derived from the committed measures CSV to 6 decimals with independent code incl. independent d′-partialing; Bang catch-dropped recompute from raw exact, 1,206/40,200; all 8 disattenuation ranges to 1e-9; null-reference gate re-verified AND intervals reproduced by an independently built simulator; holds 1 / partial 3 / fails 0 re-applied mechanically — matches; figure Lund row == step6; 009 correction verified against manifest; push verified = aa2aad6). **STEP 5 CLOSED. This dispatch = Step 6a: manuscript skeleton + full Methods + full Results + machine-generated claim-status table.** No new analyses anywhere in this dispatch — results/ is READ-ONLY input.

## Ben's manuscript decisions (2026-07-11 — BINDING for all manuscript text)
1. **Δ_ICC knife-edge → boundary wording.** Present Step 4 as "a Δ_ICC of zero sits at the very edge of the interval"; directionally consistent with the confirmatory +0.11 corrected gap (two estimands, same magnitude, same cannot-quite-exclude-zero verdict). NEVER claim the zero-exclusion. (A B=2000 verification rerun stays in the drawer as a revision-stage option; do not run it now.)
2. **Abstract + title framing → measurement-lens.** The paper leads with: apparent level-vs-sensitivity dissociations are largely a measurement/attenuation story; corrected analyses leave the null gap not excluded while confidence LEVEL clearly generalizes. (Abstract itself is written in 012, but Methods/Results prose written now must be compatible with this frame.)
3. **Arbuzova_unpub_3 → "holds, narrowly" with margins in text.** Frozen wording: the only external cross-domain pair is "consistent with the Lund direction and exceeds its simulated true-null reference, narrowly (margins 0.046 and 0.020 against the ρ=0.30 and ρ=0.45 null references)." Generator-sensitivity caveat (Cowork's independent simulator shrinks the ρ=0.45 margin to ~0.008) goes in limitations (012), but the margins appear in Results NOW.

## Objective
(A) Machine-generated claim-status table from committed CSVs. (B) `manuscript/ms.qmd`: full section skeleton; Methods COMPLETE; Results COMPLETE; Intro/Discussion/Abstract as labeled stubs (written in 012 after Ben reviews). (C) Supplementary tables from committed CSVs. (D) Housekeeping + push.

## Preregistered decisions (fixed now — argue in the report if one looks wrong; do not change it)

### Global rules for ALL manuscript text (binding)
- **Every statistic is READ from a committed results CSV inside an R chunk and assert-guarded (`stopifnot` on value at the cited precision) — NO hand-typed numbers anywhere in ms.qmd, captions, or tables.** If a needed number is not in a committed CSV, STOP and flag in the report — do not recompute it.
- Wording rules verbatim: a null is **"not excluded," never "absent"**; **no disattenuated point values** (ranges only, always labeled "range, not a corrected estimate"); **no meta-analytic pooling** across CD studies; **no cross-domain generality claims from within-vision pairs** (taxonomy sentence from step15 MD carried verbatim); Δ_ICC boundary wording per decision 1; ArbU3 wording per decision 3.
- CD provenance text is written from `results/step11_CONFDB_manifest.csv` + `results/step11_CONFDB_provenance.json` — NEVER from the 009 report sentence (corrected in 010; 8 files at OSF v2–v4, all 4 selected studies' data CSVs v1).
- Tier labels appear in every results subsection heading or first sentence: CONFIRMATORY / DESCRIPTIVE (NON-CONFIRMATORY) / STEP4 MULTILEVEL (NON-CONFIRMATORY) / CONFDB ROBUSTNESS (NON-CONFIRMATORY) / EXPLORATORY / METHODS EXHIBIT.

### Part A — claim-status table (`analysis/17_claim_status.R` → `results/step17_claim_status.csv` + `.md`)
One row per claim: claim_id, tier, quantity, estimate, ci_lo, ci_hi, n, source_csv, verdict_wording (frozen strings below), figure_ref. Rows (all values read+asserted from the named CSVs):
1. `gap_confirmatory` — CONFIRMATORY — corrected gap 0.113 [−0.138, 0.364], n=317 (step6) — "null gap not excluded".
2. `rho_level_confirmatory` — CONFIRMATORY — 0.422 [0.328, 0.515] (step6) — "confidence level is domain-general".
3. `rho_sens_confirmatory` — CONFIRMATORY — corrected 0.308 [0.075, 0.542] (step6) — "corrected sensitivity correlation excludes zero — sensitivity is not domain-specific either".
4. `naive_gap_exhibit` — METHODS EXHIBIT — raw gap 0.200 [0.051, 0.353] (step6) — "the uncorrected analysis would have affirmed the thesis; the correction machinery prevented that claim".
5. `descriptive_landscape` — DESCRIPTIVE NON-CONFIRMATORY — five pairs with frozen ±0.09/±0.10 bands (step7) — "heterogeneous, vision-anchored; no nonzero-gap claim for any descriptive pair".
6. `step4_decomposition` — NON-CONFIRMATORY — ICC_level 0.44 [0.37, 0.52]; ICC_sens 0.34 [0.26, 0.42]; Δ_ICC 0.11 [0.0015, 0.21] (step9) — boundary wording per decision 1.
7. `ipsative_exhibit` — METHODS EXHIBIT — planted-null −0.31 manufactured r; real-data mem×vis −0.667 mechanical distortion (step8/step9 exhibit CSVs) — "grand-mean centering manufactures negative within-subject correlations; asymmetric under unequal trial counts".
8. `confdb_tier` — CONFDB ROBUSTNESS NON-CONFIRMATORY — per-study r_level 0.550/0.560/0.574/0.872; verdicts partial/HOLDS-narrowly/partial/partial (step15) — taxonomy + decision-3 wording.
9. `reliability_floor` — FLOOR/METHODS — level split-half .95–1.00 vs AUROC2 .39–.90 across Lund + all four CD studies (step2 + step11 reliability CSVs) — "the measurement asymmetry that inflates raw gaps is universal in these data".

### Part B — manuscript skeleton (`manuscript/ms.qmd` + `manuscript/references.bib`)
- Quarto document, renders with the repo's renv (add quarto-required packages to renv.lock if missing; flag in report). Author Ben; title PLACEHOLDER marked `<!-- TITLE: measurement-lens, finalized in 012 -->`.
- **Section skeleton (all headings present):** Abstract (STUB), Introduction (STUB with a one-paragraph outline comment: puzzle → prior mixed findings → measurement-lens thesis → contributions list), Methods (FULL), Results (FULL), Discussion (STUB with outline comment incl. landscape measurement-lens section per session-2 decision), Limitations (STUB seeded with the standing checklist below — prose in 012), Data & Code Availability (FULL: GitHub repo, Zenodo/OSF sources, md5 pins), References (bib skeleton with the ~10 core citations: Lund 2025 doi 10.1037/xlm0001462; Confidence DB NHB s41562-019-0813-1; Bang 2019; Haddara 2022; Arbuzova 2021; Fleming/Lau AUROC2/meta-d′ methods refs; Spearman-Brown; brglm2 if cited).
- **Methods sections (complete prose):** (1) Lund dataset + provenance (from step0a provenance JSON; case-collision note NOT needed in ms — repo README matter); (2) measures: LEVEL = scale-normalized mean confidence, SENSITIVITY = AUROC2 always d′-partialed (rationale: d′ confound, from 002/003 gates), gamma dropped (set-point leakage); (3) simulation-gate program: what was gated, what failed honestly (002 raw-contrast exhibit, 003 d′-partialing mandate, 004 calibration a=0.040/b=0.749 frozen, 200/200 only config passing blind eval), power note (~60% at true gap 0.4); (4) confirmatory design: memory×vision ONLY, parcel CFA, correction + delta CI, prereg-by-git-timestamp; (5) descriptive tier + frozen bands; (6) Step 4 multilevel: model formula, domain-level accuracy centering, ICC estimands, sim gate, B=500 bootstrap, R1/R2 robustness; ipsative exhibit as methods warning; (7) CD study selection: mechanical four-criteria funnel 180→21→4, provenance from manifest/JSON, firewall design (no cross-task quantity before 010); (8) CD contrast: primary pairs + taxonomy, Bang catch/authors decisions, Haddara pooling, estimators, B=2000 bootstrap, disattenuation RANGES, null-reference simulation design and its gate.
- **Results sections (complete prose + tables/figures, in this order):** (1) measurement floor: reliability asymmetry table (step2 + step11), trials-needed (step2); (2) CONFIRMATORY mem×vision (step6) incl. the corrected-vs-naive exhibit as its closer; (3) descriptive landscape + fig_landscape + figS scatter (step7, captions already committed); (4) multilevel decomposition (step9) with boundary wording; (5) CONFDB external tier (step14/15) + fig_confdb_contrast: taxonomy paragraph verbatim, per-study verdicts with decision-3 ArbU3 wording, null-reference framing ("raw gaps up to ~0.5 under a true null at small n"); (6) claim-status table (step17) rendered as the Results summary table.
- Figures: reference the three committed PNGs/PDFs; captions imported from `figures/fig_captions.md` content (asserted equal, or included verbatim with a comment pointing at the source file).

### Part C — supplement (`manuscript/supplement.qmd`)
From committed CSVs only: S1 full descriptive-tier table (step7); S2 Arbuzova 6-pair exploratory table (step15); S3 CD secondaries (B-s1, B-s2, H-s1, Spearman rows; step15); S4 null-reference table (step14) with achieved-vs-target reliabilities; S5 reliability tables (step2, step11); S6 ipsative exhibit tables (step8/9). Same assert-guard rule.

### Part D — housekeeping
1. PROGRESS.md: status → "Step 6a manuscript skeleton in; Methods+Results complete; Intro/Discussion/Abstract pending 012"; session-log row.
2. Overwrite `cowork/REPORT.md`; commit any `cowork/sessions/*.md` present; final `docs:` commit; push; HEAD hash in the report.

## Constraints
- **results/ is read-only.** No estimate is recomputed; no new simulation; no new analysis of any kind. `analysis/17_claim_status.R` only READS committed CSVs and writes the table.
- `quarto render manuscript/ms.qmd` (and supplement) must succeed; do not commit rendered artifacts except one PDF of ms.qmd for Ben's read (manuscript/ms.pdf, committed).
- Preregistered wording strings in Part A are FROZEN — deviations argued in REPORT.md, never silent.
- Intro/Discussion/Abstract remain stubs — do NOT draft them (012 does, after Ben reads the skeleton).

## Acceptance criteria
- `results/step17_claim_status.csv` + `.md` committed; all 9 rows present with assert-guarded values and frozen wording strings.
- `manuscript/ms.qmd` + `supplement.qmd` + `references.bib` + rendered `ms.pdf` committed; render clean under renv.
- Zero hand-typed statistics (report must state how this is enforced — e.g., all inline values via chunk objects with stopifnot guards).
- Grep-checks pass and are stated in the report: "not excluded" present; "absent" absent (as a null descriptor); no disattenuated point value anywhere; taxonomy sentence present; boundary wording present; ArbU3 margins 0.046/0.020 present.
- `git status` clean; push confirmed with HEAD hash.
