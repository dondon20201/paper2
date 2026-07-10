# Code → Cowork Report

<!-- Written by Claude Code after completing each dispatch. Cowork reads this to plan next steps. Overwrite the placeholder sections below; keep the section headings. -->

**Status:** COMPLETE — **CONFIRMATORY RESULT FINAL: corrected gap = 0.11, 95% CI [−0.14, 0.36] → null gap NOT excluded**
**Dispatch #:** 006
**Date:** 2026-07-10

## What was done

The one-shot confirmatory test ran exactly per the locked design and
preregistration. Provenance guards passed (raw md5; step1 + calibration files
verified committed-clean via git before running). The frozen calibration
(a = 0.0401, b = 0.7492) was re-derived deterministically from the COMMITTED
calibration replicates (same lm on same data — necessary because the coefs
CSV stores SEs but not the coefficient covariance the delta CI needs) and
asserted equal to the published coefficients. d′-partialing implementation
(dispatch-required one-sentence statement): each AUROC2 parcel is residualized
across subjects on the same-domain d′-hat by OLS with na.exclude — this is
`partial_out_dprime()` in `R/gate_harness.R`, the literal same function the
0b′/0b″ gate scripts sourced, not a re-implementation.

Sample matched preregistration exactly: 320 both-qualifying, 317 complete-case.
CFA converged, admissible, no bounded fallback needed; corrected CI widths ≥
uncorrected (asserted in code). Outputs written once; **primary numbers are
final**. PROGRESS.md session-1 fold-in done (Cowork's close-out row appended;
Current status rewritten from the stale scaffold text).

## Files changed / created

- `analysis/06_confirmatory_memvis.R`
- `results/step6_REALDATA_confirmatory.csv` — primary + all secondary blocks
- `results/step6_REALDATA_confirmatory.md` — verdict document, preregistered wording verbatim
- `PROGRESS.md` — status/next-steps + session-1 fold-in

## Commits

- `bcd9df1` — docs: dispatch 006 from Cowork (hash from git log)
- `1cf0dec` — feat: dispatch 006 — CONFIRMATORY memory×vision test
- final `docs:` commit — this report + session-log line

**Task 4 (GitHub remote): BLOCKED, not skipped.** I attempted
`git remote add origin https://github.com/dondon20201/paper2.git` and the
Claude Code permission classifier denied it: a remote URL sourced from a
coordination FILE (your dispatch) rather than typed by Ben in chat counts as
agent-guessed, and repointing pushes clears only when the user names the
remote directly. I did not work around the denial (that would defeat its
purpose — a wrong remote would exfiltrate the whole repo). **Ben: to wire
backup, either paste the URL in a chat message to Claude Code ("add remote
https://github.com/dondon20201/paper2.git and push"), or run locally:
`git remote add origin https://github.com/dondon20201/paper2.git && git push -u origin master`.**
Everything is committed and ready to push.

## Results

All REALDATA, primary trial set, computed this session, one shot.

**PRIMARY (CONFIRMATORY — preregistered wording, verbatim in the MD):**
"The confirmatory test does not exclude a null gap (corrected gap = 0.11,
95% CI [−0.14, 0.36]). Given ~60% simulated power at a true gap of 0.4
(plausibly somewhat higher given memory's measured reliability), a null gap
is **not excluded**; this is not evidence of absence."

| Quantity | Estimate | 95% CI (delta) |
|---|---|---|
| Latent ρ_level (raw) | 0.42 | [0.33, 0.52] |
| Latent ρ_sens (d′-partialed, corrected) | 0.31 | [0.08, 0.54] |
| **Corrected gap (primary)** | **0.11** | **[−0.14, 0.36]** |

**SECONDARY:**
- (a) Subject bootstrap (2000; calibration coefficients fixed, so this CI is
  subject-sampling only): gap CI [−0.12, 0.38] — agrees with delta; corrected
  ρ_sens CI [0.05, 0.52]; **0/2000 bad fits**.
- (b) All-trials variant: identical to primary (memory/vision contain
  essentially no repeat-flagged trials — consistent with step 0a, where those
  domains' summaries were invariant to the filter).
- (c) Uncorrected latent: ρ_sens 0.27 [0.10, 0.45]; gap 0.15 [−0.05, 0.35].
- (d) METHODS EXHIBIT ONLY: raw r(mean conf) = 0.40 [0.30, 0.49]; raw
  r(AUROC2) = 0.20 [0.09, 0.31]; **naive raw gap = 0.20 [0.05, 0.35] — the
  raw analysis would have "confirmed" the thesis.** The gate machinery
  existed precisely to prevent that publication.

**Substantive reading (for planning, not for the paper without Ben):**
1. Confidence LEVEL is solidly domain-general (0.42 latent across
   memory×vision).
2. After honest correction, metacognitive SENSITIVITY is ALSO domain-general
   (0.31, CI excluding zero) — the "sensitivity is not domain-general" strong
   form was never claimable, and now the moderate form has real-data support.
3. The gap points the thesis's way (+0.11) but a null is not excluded at
   this n/reliability. The paper's honest center of gravity is the FLOOR:
   validated two-component framework, level's measurability advantage
   (7–15 vs 110–360 trials), the corrected-vs-naive contrast (0.11-null-
   not-excluded vs 0.20-CI-excludes-zero), and the preregistered narrow gate.

## Issues & blockers

1. Remote wiring blocked as above — needs Ben's direct action (one message).
2. None analytical. One-shot discipline held: no reruns after outputs
   existed; assertions all passed on the first complete run.

## Questions / decisions needed for planning

- Descriptive-tier dispatch (5 remaining pairs with the frozen ±0.09/±0.10
  bias bands): ready when you are; parcel inputs are committed.
- Paper framing: the preregistered wording is in the record; Ben should
  decide whether the abstract leads with the level result + measurement
  story (my read of BRIEF §5's "safe claim") or with the two-component
  framework. The corrected ρ_sens = 0.31 excluding zero deserves prominent,
  carefully-hedged treatment — it cuts against overclaiming in BOTH
  directions.
- Step 4 (non-ipsative multilevel decomposition) and Step 5 (Confidence DB)
  remain per BRIEF; sequence at your discretion.
