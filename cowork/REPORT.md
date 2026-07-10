# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — **STEP 0 GATE FAILED (honest result, fully diagnosed)**
**Dispatch #:** 002
**Date:** 2026-07-10

## What was done

All tasks executed. renv initialized and snapshotted (R 4.6.1; here, jsonlite,
rprojroot, renv). Step 0b built from scratch: reusable estimators
(`R/measures.R`: AUROC2 via rank-sum with midranks, Goodman-Kruskal gamma,
bootstrap-CI helper), generative simulator (`R/simulate.R`: SDT trial model
with three independent planted traits — d′, sensitivity λ, set-point β —
analytically standardized so level and sensitivity are mechanistically
separate up to the 1–7 binning), and the main script
(`analysis/01_recovery_separability.R`) implementing the dispatch design plus
three diagnostics I added when the preregistered criteria started failing:
estimator unit checks against brute-force pair counting (every run), an
asymptotic-consistency cohort at 5000 trials, and a planted-d′ confound
quantification. `results/STEP0_REPORT.md` written (standalone) and committed.
All simulation outputs are named `step0b_SIMULATION_*` and carry a
`data_type = "SIMULATION"` column.

Preregistered criteria were NOT adjusted; where I believe one was
miscalibrated I said so in the report and left the verdict standing.

## Files changed / created

- `renv.lock`, `.Rprofile`, `renv/` (activate.R, settings.json) — renv init
- `R/measures.R` — auroc2(), gk_gamma(), boot_cor() (+ integer-overflow fix for huge-N cells)
- `R/simulate.R` — folded-normal-standardized SDT generator; trait draws; cohort runner with odd/even split-half estimates
- `analysis/01_recovery_separability.R` — self-check, unit checks, recovery, leakage, d′ confound, asymptotic run, detectability (gap + null × 3 trial configs), second-seed spot-check, preregistered-criteria evaluation
- `results/step0b_SIMULATION_{selfcheck,recovery_leakage,detectability,detectability_gaps,seedcheck_recovery,seedcheck_gaps}.csv`, `results/step0b_SIMULATION_meta.json`
- `results/STEP0_REPORT.md` — the standalone gate report
- `PROGRESS.md` — next-steps rewritten around the gate failure

## Commits

- `2e73b9e` — docs: dispatch 002 from Cowork (uncommitted Cowork file, committed per protocol)
- `655bcb2` — chore: initialize renv (R 4.6.1; here, jsonlite)
- `252dd48` — feat: step 0b — recovery/separability simulation (SIMULATION only)
- `3d80ec7` — docs: STEP 0 gate report — 0a PASSED, 0b FAILED, gate FAILED
- final `docs:` commit — this report + session-log line

Task 5 (remote push): **SKIPPED** — no GitHub URL provided. Repo still has no backup; five dispatch-002 commits are local-only.

## Results

All values computed this session by `analysis/01_recovery_separability.R`;
everything below is **SIMULATION**. Seeds 20260710 (main) and 42424242
(spot-check); 322 subjects; 2000-resample bootstrap CIs.

**Self-check: PASS.** Level knob → mean confidence strictly monotone, accuracy
flat (range 0.0036), AUROC2 coupling small and quantified (range 0.029).
Sensitivity knob → AUROC2 strictly monotone, accuracy flat, mean-confidence
coupling 0.16 via binning skew (did not produce measurable leakage). Generated
accuracy within 0.003 of analytic target. Estimator unit checks vs brute
force: exact (< 1e-12).

**Preregistered criteria scorecard:**

| Criterion | Result | Verdict |
|---|---|---|
| Level recovery ≥ 0.9 @200 | 0.99 [0.99, 0.99] | PASS |
| Level recovery ≥ 0.9 @100 | 0.98 [0.98, 0.99] | PASS |
| AUROC2 recovery ≥ 0.7 @200 | 0.59 [0.52, 0.65] | **FAIL** |
| (gamma recovery, same bar) | 0.55 [0.48, 0.62] | **FAIL** |
| Leakage level←λ, \|r\|<0.10 CI∋0 @200 | −0.020 [−0.13, 0.091] | PASS |
| Leakage AUROC2←β, same @200 | −0.035 [−0.15, 0.077] | PASS |
| (gamma←β leakage, unprereg'd but decisive) | **−0.18** [−0.32, −0.025], replicates seed 2 | **FAIL** — drop gamma as primary |
| Detectability: gap recovered, truth in CIs | level ✓ everywhere; sensitivity truth OUTSIDE CI (est 0.084 vs truth 0.32 @200/200) | **FAIL** |
| Null: no spurious gap | raw gap 0.27–0.31, CIs exclude 0 in all configs | **FAIL** |

**Diagnosis (all VERIFIED in simulation):** not a code bug — estimators exact
vs brute force and consistent (AUROC2 recovery 0.82 [0.78, 0.85] at 5000
trials). The causes are structural: split-half reliability of AUROC2 is only
~0.42–0.52 at 200 trials (~0.25–0.31 at 100), capping recovery at
√rel ≈ 0.65–0.72 — the preregistered 0.7 was likely unreachable by
construction (flagged in report, verdict unchanged); plus a type-1 confound
(AUROC2↔d′ r ≈ 0.33 at 200 trials, 0.41 asymptotically). The null-scenario
spurious raw gap is pure differential attenuation; split-half
Spearman-Brown disattenuation shrinks it (0.08–0.20) but is seed-unstable
(−0.11 to +0.25) at n = 322 — cannot certify a zero.

**Bottom line: the naive raw Step-3 contrast would manufacture the thesis
from measurement noise. Level measurement is bulletproof; sensitivity
measurement at these trial counts is not.**

## Issues & blockers

1. **THE BLOCKER: Step 0 gate FAILED** → per BRIEF.md, Steps 1+ do not start.
   Needs a Cowork-designed Step 0b′. Recommendation in STEP0_REPORT.md:
   (a) bring the Step-4 latent/multilevel machinery into the gate — extend
   this simulation to test whether a joint latent-correlation model recovers
   ρ_sens and the gap unbiasedly at 100–200 trials; and/or (b) reframe the
   primary claim around the validated level measure + a measurement-limits
   finding for sensitivity (BRIEF's stated fallback floor; the spurious-gap
   demo is itself a publishable methodological point).
2. Gamma should be demoted from co-primary sensitivity measure (leaks
   set-point via tie exclusion; replicated both seeds). Affects the Step 1
   definition list — Cowork should re-scope.
3. Minor: fixed an integer-overflow bug my own first draft hit in
   auroc2()/gk_gamma() at 200k-trial self-check cells (counts now double
   precision; unit checks cover it). Noting per be-your-own-adversary rule.
4. Still no remote backup (no URL yet).

## Questions / decisions needed for planning

- Which Step 0b′ path: (a) latent-model gate extension, (b) reframe to the
  level-centric floor, or (c) = (a)+(b)? ((c) is my recommendation: (b) is
  safe regardless; (a) decides whether the strong thesis is testable.)
- If (a): hierarchical model choice needs care under the integrity rules
  (Rhat/ESS discipline; long runs on Dondon allowed but not the paper's spine
  per CLAUDE.md). A model-light alternative worth simulating first:
  correlation of split-half-averaged AUROC2 with SIMEX-style or
  errors-in-variables correction, validated exactly like this dispatch.
- Does Ben want the ~0.05-tolerance criterion on 0a's memory domain (0.057)
  formally revisited, or is the r ≥ 0.998 per-subject agreement sufficient
  closure? (My view: sufficient, documented as footnote.)
- GitHub remote URL still needed for backup.
