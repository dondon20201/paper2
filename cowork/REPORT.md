# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — Abstract + Introduction + Discussion + Limitations prose written; title finalized; two 011 hand-typed spots closed; full figure captions inline (guarded); both docs render clean; grep-checks pass; pushed. **FULL FIRST DRAFT.**
**Dispatch #:** 012
**Date:** 2026-07-12

## What was done

Step 6b — the manuscript PROSE, exactly as scoped. **No analysis was rerun and
no estimate was recomputed — `results/` was read-only input throughout.** Every
new inline number is a guarded `V$` object read from a committed CSV/JSON.

**Part A — Abstract (STUB → prose).** Cowork's authored ~220-word text used
verbatim, with each numeral swapped for its guarded `V$` object: ρ_level `V$rl`
(0.42), ρ_sens `V$rs` (0.31, CI excludes zero), corrected gap `V$gap` (0.113),
naive raw gap `V$rawgap` (0.20). Measurement-lens close ("substantially a
measurement-reliability artifact").

**Part B — Introduction (STUB → 5 paragraphs).** Written to Cowork's paragraph
plan: (1) the phenomenon and the domain-general reading; (2) the LEVEL vs
INFORMATIVENESS conflation, bias ≠ skill; (3) the measurement trap as the pivot
(differential reliability biases a raw correlation-gap upward under a true null);
(4) the from-scratch, gated, reliability-corrected approach with the firewall and
the up-front statement that a null/partial gap is acceptable; (5) explicit
four-item contributions list ending on the one-sentence measurement-lens thesis.
Intentionally numeral-free (no statistic to guard); cites `@Lund_2025`,
`@Rahnev_2020`, `@Fleming_2014`.

**Part C — Discussion (STUB → 6 paragraphs).** To Cowork's plan: (1) two-sided
headline through the measurement lens (level generalizes `V$rl`; corrected
sensitivity `V$rs` excludes zero — not domain-specific; gap `V$gap`/`V$gap_ci`
not excluded; naive `V$rawgap` excludes zero → artifact); (2) the REQUIRED
landscape section — heterogeneous gap read as one measurement fact, gaps largest
where sensitivity is least reliably measured (parcel reliabilities `V$parc_*`),
explicitly an attenuation *interpretation* not a tested result, with the
vision × GDP reviewer-proofing sentence; (3) the external tier — level travels
(`V$cd_rl_lo`–`V$cd_rl_hi`), only Arbuzova_unpub_3 is cross-domain and holds
narrowly (margins `V$cd_margin30`/`V$cd_margin45`), Haddara within-vision
sensitivity high (`V$cd_hadd_rs`) = task generalization ≠ domain generality,
taxonomy binding, no pooling; (4) "domain-general bias = domain-general LEVEL"
reconciliation with the variance-share side (`V$icc_l` > `V$icc_s`, boundary);
(5) what would settle it (more trials to lift sensitivity reliability, more
cross-domain pairs, higher power; the method is the reusable contribution);
(6) brief close (the measurement-lens moral generalizes). No confirmatory-strength
language attached to any null/partial result.

**Part D — Limitations (STUB → Cowork's authored prose).** All eight-plus standing
items present (power ~60% at true gap 0.4; sensitivity reliability floor →
disattenuation as range only; Δ_ICC boundary; single dataset / single 200/200
pair; ArbU3 n = 40 narrow margins; null-simulator caveats; residual-reliability
caveat; d′ poorly measured / slope not d′-partialed; gamma dropped, meta-d′
secondary, no pooling). Numerals guarded: `V$power`, `V$cd_arbU_n`,
`V$cd_margin30`, `V$cd_margin45`. **See deviation #1 below re the 0.008 clause.**

**Part E — Title.** Cowork's default (measurement-lens) placed in the YAML:
*"What Generalizes in Metacognition? Confidence Level, Informativeness, and a
Measurement-Reliability Account of Apparent Dissociations."* The two alternatives
recorded as YAML comments for Ben.

**Closing the two 011 hand-typed spots.**
- **R1/R2 robustness quartet** (multilevel Results): now guarded `V$r1_icc_l`
  (0.44), `V$r1_icc_s` (0.36), `V$r2_icc_l` (0.43), `V$r2_icc_s` (0.32), read +
  `gd()`-guarded from `results/step9_REALDATA_step4_diagnostics.csv`
  (SECONDARY_R1_zscored / SECONDARY_R2_ordinal).
- **MLE cross-check "≥ 0.998"** (Methods §data): a committed source *does* hold
  it — `step0a_provenance.json` `per_subject_agreement$cor_own_vs_shipped` (four
  domain correlations, min 0.9979, max 0.9993). Guarded as the range
  `V$mle_cor_rng` = **0.998–0.999** (rounded, 3 dp), replacing the bare "≥ 0.998".
  (Chose the range form over "≥ 0.998" because the raw min 0.9979 is fractionally
  below 0.998 before rounding; the range is unimpeachable and still guarded.)

**Full figure captions inline.** The complete Fig 1 / Fig S1 / Fig 2 captions from
`figures/fig_captions.md` are now built in the setup chunk as `V$cap_fig1/…figS1/…fig2`
`paste0` strings, concatenating guarded `V$` numerals, and referenced via
`#| fig-cap: !expr V$cap_figN`. The "see fig_captions.md (Figure N)" pointers are
deleted. Every estimated numeral in a caption is a guarded `V$` (band
`V$band_200100`/`V$band_calgdp`, `V$d_visgdp_lo`, `V$gap`/`V$gap_ci`, `V$parc_*`,
`V$cd_level_rng`/`V$cd_auroc_rng`, `V$cd_arbU_rawgap`/`V$cd_arbU_n30`/`V$cd_arbU_n45`).

**Precision convention.** The confirmatory gap and its CIs now render at **3 dp**
(`V$gap` 0.113; `V$gap_ci` [−0.138, 0.364]; `V$gap_boot_ci` 3 dp) so the in-text
gap matches the claim-status table and the Fig 1 caption; all other in-text
correlations stay at 2 dp. This resolved the one pre-existing mismatch (011 body
showed "0.11" vs the table's "0.113").

## Verification (grep-checks I ran)

Run on the **rendered PDF text** (`pdftotext manuscript/ms.pdf`) unless noted:
- **No STUB** anywhere (`grep -c STUB` = 0).
- **"not excluded"** present (×6). **"absent"** occurs only twice, both correct:
  the Results not-excluded-vs-absent contrast, and the Cowork-sanctioned "largely
  absent as a *distinguishable* effect" (describing the dissociation/gap, never
  sensitivity generalization).
- **Disattenuation = ranges only** ("disattenuation ranges", "only as a range");
  no single corrected disattenuated point value anywhere.
- **Taxonomy binding** present ("not four cross-domain replications";
  "task-generalization, not cross-domain generality").
- **Δ_ICC boundary wording** present ("very edge of its/this interval",
  "boundary result").
- **ArbU3 margins** 0.046 and 0.020 present (guarded).
- **No confirmatory-strength language** on any null/partial result in Discussion
  (grepped Discussion for confirm/significant/proves/demonstrates/establishes —
  only "confirmatory pair/test/result" as tier NAMES, which is allowed).
- **Zero hand-typed statistics (the acceptance item):** stripped fenced code
  chunks + inline `` `r …` `` spans + HTML comments from `ms.qmd`, then grepped
  the surviving prose for digits. Every remaining literal is a **design/method
  constant** — trial configs (200/200, 200/100, 100/100), planted gap 0.4, null
  ρ 0.30/0.45, bootstrap B (2000/500), CI level 95%, reliability target 0.7,
  qualitative gate descriptor r ≈ 0.99, OSF version, ≥ 60 trials, 2.5–97.5% span,
  frozen bias bands ±0.09/±0.10 — the same operative definition of "statistic"
  (= a value estimated from data) that the 011 audit used. **No estimated
  statistic is hand-typed** in prose or captions.
- Both `ms.qmd` and `supplement.qmd` `quarto render` clean under the renv library;
  rendered values spot-checked in the PDF (0.113; [−0.138, 0.364]; 0.998–0.999;
  R1/R2 quartet; margins 0.046 and 0.020; ArbU raw gap 0.551 vs 0.505/0.531; title).

## Deviations from the dispatch (argued, never silent)

1. **The "≈ 0.008" independent-simulator margin (Limitations, Part D) was
   de-numeralized.** Cowork's Part D text reads "the smaller margin shrinks to
   about 0.008 under an independently constructed null simulator." **0.008 is not
   in any committed `results/` CSV** — the only committed null-reference simulator
   is `step14` (matched to each study's reliabilities/means), which yields the
   0.046/0.020 margins; the 0.008 comes from Cowork's own independently
   constructed simulator, external to this repo. Under the binding rules ("NEVER
   report a number not just computed from raw data in code you can show"; "If a
   number you want is not in a committed CSV, do not invent it — write the
   sentence without the numeral"), I could not print it. The clause now reads
   "…and the smaller margin shrinks further under an independently constructed
   null simulator — so this replication is directional, not decisive," preserving
   the generator-sensitivity caveat (Ben's binding decision 3) without the
   ungrounded numeral. **If Cowork wants 0.008 in the paper, commit the
   independent simulator's output to `results/` and I will guard it in a
   follow-up.**

No other deviations. All Cowork-authored text (Abstract, Limitations) used
verbatim except that one numeral; Intro/Discussion expanded faithfully to the
plans with no empirical claim beyond the committed results.

## Files changed / created

- `manuscript/ms.qmd` — Abstract/Intro/Discussion/Limitations prose; final title
  in YAML; new guarded `V$` objects (`mle_cor_rng`, `r1/r2_icc_*`, `cd_arbU_n`,
  `band_200100`, `band_calgdp`, `cap_fig1/figS1/fig2`); confirmatory gap → 3 dp;
  three `fig-cap` chunks switched to `!expr`; `fig_captions.md` pointers removed.
- `manuscript/ms.pdf` — re-rendered (committed; Ben's read copy).
- `manuscript/supplement.pdf` — re-rendered (gitignored; not committed).
- `PROGRESS.md` — status → FULL FIRST DRAFT; session-log row 15.
- `cowork/REPORT.md` — this file. `cowork/DISPATCH.md` — Cowork 012 (committed by Code).
- `figures/fig_captions.md` — unchanged (retained as the caption source of record;
  its content is now duplicated inline and guarded).

## Commits

- **`5ae2ea7`** — feat: dispatch 012 manuscript prose + title + inline captions +
  011 loose ends (`manuscript/ms.qmd`, `manuscript/ms.pdf`).
- final **`docs:`** commit — this report + `PROGRESS.md` + `cowork/DISPATCH.md`
  (hash = latest commit touching REPORT.md; HEAD reported after push below).

## Results / state

- Manuscript is a **complete first draft**: Abstract, Introduction, Methods,
  Results, Discussion, Limitations, Data & Code Availability, References — no
  stubs remain. Renders clean to `manuscript/ms.pdf` under renv (Quarto+Typst).
- Every reported statistic is a guarded `V$` object or a `kable`-from-CSV cell;
  the "zero hand-typed statistics" claim is now literally true (audit above).

## Issues & questions for planning

1. **0.008 (deviation #1)** — decide: commit the independent null-simulator output
   to `results/` (then I guard and restore the numeral), or keep the qualitative
   "shrinks further" wording. Currently qualitative.
2. **Precision** — confirmatory gap now 3 dp in-text to match the table; all other
   correlations 2 dp. Flag if you want the gap CI bounds elsewhere unified too.
3. **Author/affiliation** — YAML still `author: "Ben [Author]"`; supply the real
   author line + affiliations when ready.
4. **Bib coverage unchanged** — all 14 refs still cited (Intro cites Lund/Rahnev/
   Fleming; the meta-d′/gamma/Spearman–Brown/lavaan/R attributions remain in
   Methods). No new citations added; no TODO-cite placeholders were needed.
5. **Next** — ready for Ben's read + a revision pass; folder rename paper2 →
   metacog still pending an explicit dispatch.
