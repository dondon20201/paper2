# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — **STEP 0b′ FAILED per preregistration (by one criterion, one config, by 0.012)**
**Dispatch #:** 003
**Date:** 2026-07-10

## What was done

Step 0b′ built and run in full: parcel machinery (`R/parcels.R` — interleaved
parcels, per-parcel AUROC2/mean-conf, corrected d′, and the two-domain
four-factor CFA with the gap as a lavaan defined parameter), the gate script
(`analysis/02_latent_gate.R` — 4 scenarios × 2 configs × 30 replicates main
seed + 15 second-seed, raw AND d′-partialed variants everywhere), lavaan
added to renv and lockfile updated. `results/STEP0B_PRIME_REPORT.md` written
(standalone) and STEP0_REPORT.md's verdict block updated to point at it.
Runtime: 1.8 min of fits (well within budget; R = 30 kept).

**One estimator refinement made during smoke testing (before any scenario
run, documented per the K "justify or revise" clause):** an unconstrained
2-parcel factor on 50-trial AUROC2 parcels is empirically underidentified —
first smoke fit gave loadings 24.2/0.006, residual variance −463, singular
information matrix. Since interleaved parcels are exchangeable BY
CONSTRUCTION, equal-loading + equal-residual constraints within each factor
are true in the population; imposing them identifies K = 2 and stabilized
everything (480/480 admissible fits, 0% — criterion e headroom huge).
Unbounded ML with a bounded fallback (bounds cost 180× runtime for identical
estimates). Preregistered CRITERIA were not touched.

## Files changed / created

- `R/parcels.R` — parcel measures, corrected d′, exchangeability-constrained CFA builder + fitter
- `analysis/02_latent_gate.R` — the gate suite incl. trait-transform check
- `renv.lock` — + lavaan 0.6-21 (quadprog, mnormt, pbivnorm, numDeriv)
- `results/step0bprime_SIMULATION_{replicates,summary,traitcheck}.csv`, `_meta.json`
- `results/STEP0B_PRIME_REPORT.md` (new), `results/STEP0_REPORT.md` (verdict block updated)
- `PROGRESS.md` — status/next-steps per verdict

## Commits

- `7705efc` — docs: dispatch 003 from Cowork
- `819a149` — feat: step 0b′ — parcel-based latent-estimator gate (SIMULATION only)
- `4086ce9` — docs: step 0b′ gate report + STEP0_REPORT verdict update
- final `docs:` commit — this report + session-log line

Task 4 (remote): **SKIPPED again — no URL.** Eleven commits now live only on
Dondon. Please create the private GitHub repo.

## Results

All SIMULATION, computed this session; full tables in the CSVs and
STEP0B_PRIME_REPORT.md. Primary variant = **d′-partialed** (promoted by the
preregistration itself: raw failed DCONF at 200/100 with median spurious
ρ_sens 0.102 ≥ 0.10; partialed passes it at −0.004/+0.029).

Scoreboard (partialed): **200/200 passes all eight criteria** — GAP ρ_sens
bias +0.029, coverage 28/30, gap>0 29/30; NULL gap bias +0.051, CI∋0 29/30;
ZERO-SENS 0.041; DCONF −0.004; 0% bad fits. **200/100 fails exactly one:**
NULL-scenario median gap bias **+0.082 vs the ±0.07 bar** (everything else
passes; second seed +0.096 — replicated, systematic). Mechanism: latent
ρ_sens shrinks multiplicatively at low parcel reliability (−0.09 bias at
true 0.4 in 200/100) while level is unbiased (≤0.006), leaving a residual
spurious-gap component ~4× smaller than dispatch 002's raw artifact but
still over the preregistered bar. → **STEP 0b′: FAILED as written; STEP 0
GATE: still FAILED.**

Also delivered:
- **DCONF finding (important, replicated):** raw latent estimation converts
  cross-domain d′ correlation into spurious sensitivity correlation;
  d′-partialing eliminates it. Mandatory ingredient for ANY future real-data
  sensitivity analysis in this project.
- **Power note:** at true gap 0.4, gap CI excludes 0 in 25/30 (200/200) and
  22/30 (200/100) — the validated config has ~80% power.
- **002 realized-vs-population deviation explained (benign):** λ copula
  transform bias is −0.008 at ρ = 0.2 (2000-draw check; SD 0.053); 002's
  realized 0.32 was a 99.2nd-percentile draw. Criteria here use realized
  values, mooting the issue.

## Issues & blockers

1. **THE BLOCKER (decision, not defect):** gate failed by 0.012 on one
   criterion in one config, replicated. Three paths in STEP0B_PRIME_REPORT §6:
   (1) floor reframe; (2) one more preregistered round with a
   simulation-calibrated shrinkage correction, including the untested 100/100
   config (Calories×GDP — presumably worse than 200/100); (3) scope-restrict
   strong claims to the 200/200 pair (memory×vision) with bias bands on the
   200/100 pairs. My read: (2) is worth one round — the bias is
   multiplicative, direction-known, and stable across seeds, which is what
   makes calibration credible; (3) is the fallback if (2) fails; (1) remains
   the floor regardless. But the preregistration bar is Ben's/yours to set.
2. If option (2): the correction must be developed on NEW seeds and validated
   against the existing criteria untouched — I will not tune on the
   evaluation seeds.
3. Repo backup still missing (no remote URL).

## Questions / decisions needed for planning

- Which path (1/2/3 above)? If (2): confirm the ±0.07 bar stays, and whether
  100/100 must also pass or is explicitly out of scope (it determines whether
  the Calories×GDP pair can carry any sensitivity claim at all).
- If (3): confirm which claims may rest on 200/100 pairs with a ±0.10
  simulation bias band attached — that phrasing decision shapes Step 3's
  design.
- GitHub remote URL, again.
