# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — **Step 4 GATE PASSED → real-data decomposition run**; figures done; all pushed
**Dispatch #:** 008
**Date:** 2026-07-10

## What was done

All four parts, in order. Part A (gate) PASSED cleanly, so Part B ran; Parts
C and D unconditional as dispatched.

**Part A — gate (SIMULATION):** all 50 replicates (5 cells × 10, seeds
20260711–20260720 per cell) converged at rung **M1** — the ladder never
fired. Recovery bias ≤ ~0.05 per component per cell (criterion ≤ 0.10);
leakage across matched cell pairs ≤ 0.001 (criterion ≤ 0.10); sign of
Δ_ICC correct 10/10 in all three binding cells. **GATE: PASS on all four
criteria.** Ipsative exhibit, (0.5, 0.5) cell: naive mean-subtraction
manufactures mean centered r = **−0.310** (theory ≈ −1/3) while the same
data's LMM recovers 0.492/0.516 — the paper's methods exhibit, now with
simulated ground truth behind it.

**One implementation decision to audit:** the dispatch fixed the mean
resolution slope (0.8) and said "slope SDs partitioned by ICC_sens" but
never specified the TOTAL slope SD. I chose **0.4** (= mean/2; ~2% of
person-domain slopes negative), documented it in the meta JSON, and did not
treat it as preregistered. If you want a different magnitude the gate is
cheap to rerun (5 min total).

**Part B — real data (gate-conditional):** primary trial set, step-1
qualifying subject-domains (322 subjects, 1,281 subject-domains, 182,892
trials; 341 trials in non-qualifying subject-domains dropped). Note on one
ambiguity: the dispatch said subject-domains "exactly those present in
step1 primary rows" — I read "present" as the step-1 QUALIFYING set (the
non-qualifying rows have NA measures and were excluded from every prior
analysis; including them would be the new exclusion decision). Point fit
landed on **M1, converged, non-singular** — no ladder rung was ever used on
real data either. Bootstrap ran at full **B = 500** (5 s/fit, projected
0.7 h — no downgrade), **0 failed, 0 escalated**.

**Part C — figures:** both figures + underlying-data CSVs + captions
written; every plotted value read from committed CSVs and asserted against
the audited values (all assertions passed; no recomputation). Base-R
graphics — no new package dependencies beyond the dispatched lme4/ordinal.

**Part D:** session-02 note committed and folded into PROGRESS.md;
renv.lock updated with lme4 + ordinal (**Ben: run `renv::snapshot()` to
double-check next time you're in R** — I ran it non-interactively and
committed the result); pushed.

## Files changed / created

- `R/multilevel.R` — shared ladder/ICC/ipsative machinery
- `analysis/08_step4_recovery_gate.R` + `results/step8_SIMULATION_step4gate_{recovery,summary}.csv`, `step8_SIMULATION_step4gate_meta.json`, `step8_SIMULATION_ipsative_exhibit.csv`
- `analysis/09_step4_multilevel.R` + `results/step9_REALDATA_step4_multilevel.{csv,md}`, `step9_REALDATA_step4_diagnostics.csv`, `step9_REALDATA_ipsative_exhibit.csv`, `step9_REALDATA_step4_meta.json`
- `analysis/10_landscape_figures.R` + `figures/fig_landscape.{pdf,png}`, `figures/figS_gap_vs_reliability.{pdf,png}`, `figures/fig_captions.md`, `results/fig_landscape_data.csv`, `results/figS_gap_vs_reliability_data.csv`
- `renv.lock`; `cowork/sessions/2026-07-10-session-02.md`; `PROGRESS.md`; `cowork/DISPATCH.md`

## Commits

- `b8f1d93` — docs: dispatch 008 from Cowork + session-02 note + PROGRESS fold-in
- `be8d904` — chore: renv lockfile (lme4, ordinal)
- `d91967a` — feat: Part A gate — **GATE PASSED**
- `01c2b8e` — feat: Part C figures
- `a60304c` — feat: Part B multilevel decomposition
- final `docs:` commit — this report + session-log line (pushed; = origin/master HEAD when you audit)

## Results

All labeled per BRIEF §3. Tier: **STEP4_MULTILEVEL (preregistered,
NON-CONFIRMATORY)** — variance-share estimand, NOT the Step-3 latent gap;
nothing re-tests 006.

**PRIMARY decomposition (REALDATA, rung M1, cluster bootstrap B=500):**

| Quantity | Estimate | 95% CI |
|---|---|---|
| ICC_level (person-general share of set-point variance) | 0.44 | [0.37, 0.52] |
| ICC_sens (person-general share of resolution variance) | 0.34 | [0.26, 0.42] |
| **Δ_ICC** | **0.11** | **[0.0015, 0.21]** |

The preregistered wording branch fired on "CI excludes zero," and the MD
states it with hedges as required. **BUT — adversarial flag, read before
using this:** the exclusion margin is 0.0015, SMALLER than the Monte-Carlo
error of a B=500 percentile bound (analytically ~±0.006 under a normal
approximation to the bootstrap draws, SE ≈ 0.053). A different bootstrap
seed could put the bound on either side of zero. The honest presentation is
"Δ_ICC ≈ 0.11, boundary-significant — zero is at the very edge of the
interval," not "excludes zero." I recommend the paper treat this as
directionally consistent with 006's +0.11 point estimate (a nice
parallelism: two different estimands, same magnitude, same
can't-quite-exclude-zero verdict) rather than as a standalone positive. If
you want to lean on the exclusion, dispatch a higher-B verification run
(B=2000 ≈ 2.7 h) — do NOT quietly reuse this one.

**Variance components (full precision in CSV):** set-point: person 0.276
[0.207, 0.352] vs person×domain 0.347 [0.304, 0.389]; resolution slope:
person 0.088 [0.062, 0.119] vs person×domain 0.173 [0.143, 0.205];
residual 2.89.

**Robustness:** R1 (z within domain): 0.44 / 0.36 — consistent. R2
(ordinal clmm, COMPLETED within cap): 0.43 / 0.32 — consistent. The
decomposition is not a raw-scale or Gaussian artifact.

**Exploratory diagnostics (the standing d′ caution, quantified):** subject
slope-BLUPs correlate with mean d′-hat at r = 0.43 [0.33, 0.51];
subject-domain slope-BLUPs with matched d′-hat at r = 0.39 [0.34, 0.43].
The resolution slope substantially tracks type-1 performance — one more
reason it must never be presented as AUROC2-style sensitivity.

**Ipsative exhibits (sim + real, methods only):** simulation (planted
0.5/0.5): naive centered correlations mean −0.310 vs theory −1/3, LMM
recovers the truth. Real data: centered correlations range −0.667
(memory×vision!) to +0.083, mean −0.298. The prior project's "domain-general
bias ≈ −0.39 within-subject" number now has a complete, quantified
explanation sitting in two CSVs.

**Figures:** `fig_landscape` (six pairs, CI whiskers, systematic-band
rectangles on the five descriptive pairs, mem×vis marked CONFIRMATORY) and
`figS_gap_vs_reliability` (labeled scatter, no line/correlation/test,
EXPLORATORY in the title and caption). Captions in `figures/fig_captions.md`
carry the band-is-not-a-CI warning and the vision×GDP defensive sentence.

## Issues & blockers

None blocking. For the record:
1. The Δ_ICC zero-exclusion knife-edge (above) — decision needed on
   presentation before the manuscript.
2. The slope-SD implementation choice in the gate (above) — auditable,
   rerunnable.
3. The dispatch's "CI method (both parts)" clause: I applied bootstrap CIs
   to Part B only; Part A's gate criteria are means/counts over replicates
   (its outputs spec lists no CIs, and 25,000 bootstrap fits inside the gate
   would violate its own time rule). Flagging the interpretation rather
   than silently deciding it.
4. `setTimeLimit` was the R2 cap mechanism; clmm finished well inside it,
   so the cap was never exercised.

## Questions / decisions needed for planning

- Presentation of Δ_ICC (knife-edge exclusion vs boundary wording vs
  higher-B verification dispatch) — my recommendation above.
- Step 4 is done; remaining BRIEF steps: Step 5 (Confidence DB
  generalization — large download, stays out of git) and Step 6
  (manuscript + claim-status table). The claim-status table now has a rich
  set of VERIFIED rows to draw from; the parallel 0.11s (latent gap,
  Δ_ICC) and the twin ipsative exhibits (sim + real) are, to my eye, the
  paper's methodological core.
- GitHub push routine held: pushed after this dispatch's commits.
