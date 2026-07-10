# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — **006 CLEARED by the preregistered transfer rule. Firewall held.**
**Dispatch #:** 005
**Date:** 2026-07-10

## What was done

First real-data dispatch, executed under the firewall (NO cross-domain
quantity computed anywhere — verified by grepping my own outputs before
committing; the only match is the firewall note itself). Step 1: per-subject
measurement layer for all 322 subjects × 4 domains, both trial sets (primary
= repeat_exclude==0; all-trials sensitivity check), with parcels and d′-hat
as the 006 CFA inputs. Step 2: split-half reliabilities with bootstrap CIs,
parcel-level reliabilities, trials-needed curves (memory/vision), and the
preregistered calibration-transfer check. Raw-file md5 re-verified at the top
of every script (provenance guard is now standing practice).

Two mid-run fixes, both documented: (1) the raw memory domain contains 3
trials with NaN signal/response but intact accuracy/confidence — d_prime_hat
now drops such trials (was silently NA-ing all of memory's d′); (2) my
trials-needed bootstrap had an aggregate-formula bug producing boundary CIs —
fixed and rerun (point estimates were unaffected).

## Files changed / created

- `analysis/04_realdata_measures.R` — Step 1 (REALDATA labels throughout)
- `analysis/05_realdata_reliability.R` — Step 2 + transfer check writer
- `R/parcels.R` — d_prime_hat NA-guard for signal/response
- `results/step1_REALDATA_{subject_measures,domain_summary}.csv`
- `results/step2_REALDATA_{reliability,trialsneeded,trialsneeded_curve}.csv`
- `results/step2_REALDATA_transfer_check.md` — the verdict document

## Commits

- `6ef90a2` — docs: dispatch 005 from Cowork
- `77254c1` — feat: steps 1–2 — real-data measures, reliability, trials-needed, transfer check
- final `docs:` commit — this report + session-log line

Task 5 (remote): **SKIPPED — no URL, fifth ask.** The repo now contains real
paper deliverables and still has zero backup beyond this machine.

## Results

All REALDATA, primary trial set, computed this session (VERIFIED; CIs are
2000-resample bootstrap unless noted).

**Exclusions (preregistered rule ≥60 trials + both accuracy classes):**
memory 1/321, vision 0/322, Calories 0/322, GDP 5/317-of-322 — max 1.6%,
nowhere near the 15% surprise threshold. Missing-confidence trials dropped:
0.79% of all trials.

**Reliability (split-half, Spearman-Brown, [95% CI]):**

| Domain | Level (mean conf) | AUROC2 | d′-hat |
|---|---|---|---|
| memory | 0.97 [0.96, 0.98] | **0.84** [0.79, 0.87] | 0.86 [0.83, 0.89] |
| vision | 0.99 [0.98, 0.99] | 0.59 [0.48, 0.68] | **−0.96** [−1.5, −0.53] |
| Calories | 0.95 [0.94, 0.96] | 0.47 [0.35, 0.57] | **−1.5** [−2.1, −0.98] |
| GDP | 0.95 [0.93, 0.96] | 0.39 [0.22, 0.51] | −0.36 [−1.3, 0.22] |

Two headline findings:
1. **The level-vs-sensitivity measurability contrast is dramatic and now
   quantified on real data** — trials needed for reliability 0.7: level 7–15
   trials; AUROC2 memory ~110 [96, 170], **vision ~360 [210, 490] — more
   trials than the experiment contains.** (SB-prophecy fits; curve + fits
   saved.) This is a paper figure/deliverable on its own, and it lands
   exactly on BRIEF §1's "sensitivity is poorly measured" warning.
2. **Negative d′ split-half reliability outside memory** (vision −0.96,
   Calories −1.5): vision is contrast-staircased (accuracy SD 0.017!) and
   the staircase's negative feedback anticorrelates odd/even d′; the trivia
   tasks appear difficulty-controlled too. So d′-hat has essentially no
   stable trait variance outside memory. Consequences for 006 are in the
   transfer check: the d′-confound risk is SMALLER than simulated
   (conservative); partialing stays (preregistered) but will be near-inert
   for vision; memory d′ (mean 1.56, SD 0.56) is a genuine trait and is
   where partialing matters.

**TRANSFER CHECK — VERDICT: 006 CLEARED** (preregistered rule, numbers in
`step2_REALDATA_transfer_check.md`): real parcel AUROC2 reliability vs
simulation — memory 0.55 vs 0.18 (ratio 3.1), vision 0.27 vs 0.18 (1.5);
both ≥ 0.7 by a wide margin, and in the direction the dispatch itself deemed
conservative (real measurement is BETTER than the calibration assumed; any
over-correction inflates estimated sensitivity correlations, which biases
AGAINST the thesis gap). Context rows: Calories 1.6×, GDP 1.3×. Also noted:
real between-subject level SD (0.72–0.91) below simulation-implied 1.31 —
wider real CIs, no validity issue.

**Sensitivity check (all-trials vs primary):** domain summaries nearly
identical (means shift ≤ 0.03); primary carries the claims as preregistered.

## Issues & blockers

1. None blocking 006. The transfer verdict is CLEARED under the
   preregistered rule.
2. For 006 planning: memory AUROC2 reliability (0.84) is far above what the
   0b″ power note assumed — real confirmatory power should exceed the
   simulated ~60%. Conversely vision (0.59) is at the simulated level. Net:
   likely somewhat better than 60%, not dramatically.
3. The staircase finding (negative d′ reliability) deserves a sentence in the
   paper's methods for why d′-partialing is near-inert in vision — flagging
   now so it isn't rediscovered as a reviewer objection.
4. Backup: fifth consecutive skip. Real deliverables now at risk on one disk.

## Questions / decisions needed for planning

- 006 (confirmatory memory×vision, single shot) is cleared to be dispatched.
  Suggest it also preregister: the all-trials sensitivity variant, a
  bootstrap-over-subjects CI to complement the delta-method CI, and the
  exact wording template for both outcomes (gap CI excludes 0 / does not).
- Should the descriptive-tier pairs (dispatch 007?) reuse this dispatch's
  parcel columns as-is (they're saved and committed), or recompute after any
  006 learnings? My suggestion: as-is, they're preregistration-clean.
- GitHub remote URL. (Fifth ask — the trials-needed curve alone is worth
  backing up.)
