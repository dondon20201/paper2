# COWORK BRIEF — Build the Metacognition Paper FROM ZERO
## "Confidence Level vs Confidence Informativeness: Which Component of Metacognition Is Domain-General?"

READ THIS FIRST. You (Claude, in Cowork) are rebuilding this project FROM SCRATCH. A
previous effort produced code and numbers that are NOT trustworthy: the same agent
wrote the analysis, ran it, and graded its own output, and at least one shipped script
had a real bug found only later. Therefore:

  YOU TRUST NOTHING COMPUTATIONAL FROM BEFORE.
  - Re-fetch the raw data yourself and verify it (md5 + structure).
  - Write ALL of your own analysis code from scratch.
  - Do NOT reuse, import, or even consult any prior script, intermediate file, or
    saved result. They may be wrong. Reproduce every claim independently or reject it.
  - Every prior number in this brief is an UNVERIFIED LEAD, not a fact. If your own
    code does not reproduce it, label it FAILED and drop it.

What you SHOULD keep from before is NOT the answers but the WARNINGS: a precise map of
how this specific analysis went wrong last time, so you don't repeat it. Discard the
results; keep the list of traps (Section 1).


================================================================================
## HONESTY & REAL-DATA MANDATE (READ FIRST — THIS OVERRIDES EVERYTHING BELOW)
================================================================================
This project has ONE non-negotiable standard: everything must be honest, real, and
verifiable. A previous project failed by drifting from this. You will not.

1. ALL DATA MUST BE REAL AND VERIFIED.
   - Use only genuine, publicly documented, citable open datasets from their official
     source. No invented data, no synthetic data presented as real, no "illustrative"
     numbers, no placeholder values that later get treated as findings.
   - Download the data yourself from the official source and VERIFY it (md5 checksum
     where given, row/subject/column counts, and reproduce one basic known summary).
     If the checksum or structure does not match what is expected, STOP and report it;
     do not proceed on a file you have not confirmed is the real one.
   - Simulated data is allowed ONLY for parameter-recovery validation, and it must be
     labeled unmistakably as simulation. It may never be reported as an empirical result.

2. NEVER FABRICATE OR GUESS A NUMBER.
   - Every quantitative statement must come from code you just ran on the real data and
     can show. No numbers from memory, from this brief, from prior runs, or from
     "what the literature roughly says." If you cannot compute it, you do not report it.
   - If you are tempted to fill a gap with a plausible-sounding number, STOP. Report the
     gap instead.

3. NO OVERCLAIMING — CALIBRATE EVERY CLAIM TO THE EVIDENCE.
   - State only what the data support, with the appropriate hedges. Prefer "in this
     dataset, under these assumptions" over sweeping generalizations.
   - Every estimate carries an uncertainty interval. No naked point estimates.
   - Do not upgrade a suggestive result into a definitive one. Do not turn "consistent
     with" into "proves." Do not turn one dataset into "the field."
   - If a result is fragile, unstable, or borderline, say so plainly in the same breath
     as the result — not buried in limitations.
   - A smaller, bulletproof claim always beats a larger, shaky one.

4. LABEL THE STATUS OF EVERY CLAIM.
   - VERIFIED (re-derived from real data this run, code shown), REPRODUCED (matched a
     named external source), UNVERIFIED, or FAILED (tested and did not hold).
   - "Did not replicate," "did not converge," "too unstable to report," and "the effect
     is not there" are COMPLETE, CORRECT, ACCEPTABLE results. An honest null is a
     success, not a failure. Never dress up a null as a positive.

5. BE YOUR OWN ADVERSARY.
   - The core failure mode is that the same agent generates, runs, and grades its own
     work, so flattering errors survive. Actively try to break every result: re-run with
     different splits/seeds, check recovery of known values, and ask "what would a
     reviewer trying to prove me wrong attack first?" Report what you find, including
     when it undermines the story.
   - Do NOT optimize for an impressive paper. Optimize for claims that survive adversarial
     re-analysis. Impressiveness that isn't earned is exactly what sank the last project.

If at any point honesty and impressiveness conflict, choose honesty and tell the user.

================================================================================
## 0. THE THESIS (what the paper argues, if the data support it)
================================================================================
Confidence reports contain at least two separable things:
  (1) CONFIDENCE LEVEL / SET-POINT — how high/low someone's confidence runs overall
      (a response-style / scale-use tendency), and
  (2) CONFIDENCE INFORMATIVENESS / METACOGNITIVE SENSITIVITY — how well confidence
      discriminates a person's own correct from incorrect responses (meta-d', AUROC2,
      gamma).
THESIS: the domain-general part of confidence is the LEVEL, not the INFORMATIVENESS.
Confidence level generalizes strongly across domains; metacognitive sensitivity
generalizes weakly and is poorly measured. You must TEST this, not assume it. If the
data do not support it, report that — a null or partial result is acceptable.

================================================================================
## 1. FAILURE MAP FROM THE PRIOR ATTEMPT (warnings only — NOT results to reuse)
================================================================================
These are the ways this analysis has already gone wrong. Treat each as a landmine, not
a finding. None of the numbers here are to be trusted; they tell you what to watch for.

- ROOT FAILURE: generator = grader. The same agent produced, ran, and judged the
  analysis, so flattering errors survived and confidence accumulated across sessions
  while robustness did not. Counteract by re-deriving everything and actively trying to
  break your own results.
- A recovery-simulation script shipped with a real bug (simulated data's type-1 d'
  tracked meta-d' instead of d', corrupting M-ratio scaling). LESSON: validate every
  simulator by checking it reproduces the quantities it's supposed to, before trusting
  any recovery result.
- Five specific claims previously COLLAPSED under scrutiny — do NOT resurrect any:
  (1) "methods converge on domain-general ~0.37–0.40" (compared different quantities);
  (2) "metacognition invisible below 150 trials" (no stable threshold; recovery of a
      known 0.4 ranged 0.08–0.65);
  (3) "disattenuated correlation ≈ 0.39" (re-derived to 0.74; not reproducible;
      dominated by 3 tiny studies n=15–20) — NEVER report a single disattenuated point
      value; present disattenuation only as a sensitivity range;
  (4) "joint HMeta-d inflates weak pairwise correlations" (converged joint ≈ pairwise
      ≈ 0.18; not supported);
  (5) "domain-general metacognitive bias is a trait" (it was carried entirely by a
      person-level confidence set-point / scale-use).
- THE IPSATIVE ARTIFACT (critical): removing each person's mean confidence mechanically
  induces negative correlations. A prior "within-subject centered bias" number (~-0.39)
  was partly this artifact. Do NOT test the thesis by naive mean-subtraction. Use a
  multilevel model that estimates set-point, domain bias, and sensitivity jointly
  (Section 4, Step 5). If you cannot separate them cleanly, say so.
- Heavy Bayesian HMeta-d models did not converge in constrained compute and, when they
  did, did not reconcile with the original authors' published values. Prefer model-
  light sensitivity measures (AUROC2, gamma) for the main analysis; use hierarchical
  meta-d' only with full Rhat/ESS diagnostics and treat it cautiously.

================================================================================
## 2. DATA — FETCH AND VERIFY IT YOURSELF
================================================================================
Do not use any local copy handed to you. Download fresh and verify.

PRIMARY — Lund et al. (2025) multi-domain metacognition:
  Repo: https://github.com/embodied-computation-group/dg-metacognition
  Trial file: data_summary/metacognition_trialData_master.csv
    EXPECTED md5: 500b2e6e1eb0e47e717feba5b912ad9f (verify; if it differs, confirm the
    file matches the structure below before proceeding).
    ~11.8 MB, 322 subjects, ~200 trials/task, confidence 1–7, four domains:
    memory, Calories, GDP, vision. Columns: subject, modality, signal, response,
    confidence, repeat_exclude.
  The repo also ships precomputed MLE fits — you may use these ONLY as an external
  cross-check against your own per-subject estimates, never as your primary numbers.

SECONDARY — Confidence Database (Rahnev et al. 2020):
  OSF: https://osf.io/s46pr  (180 study CSVs, ~244 MB). Use for cross-study
  generalization and reliability across many tasks; subset to studies with multiple
  tasks per participant. Verify each study file's structure before using it.

================================================================================
## 3. INTEGRITY RULES (binding)
================================================================================
- NEVER report a number you did not just compute from raw data in code you can show.
- LABEL every quantitative claim: VERIFIED / REPRODUCED / UNVERIFIED / FAILED.
- Every estimate needs an interval (bootstrap or analytic CI). No naked point estimates.
- Any hierarchical/Bayesian result needs Rhat AND ESS; Rhat ≥ 1.01 = not trustworthy.
- Prove any estimator recovers a KNOWN planted value before trusting it on real data.
- "Did not replicate / did not converge / too unstable / effect absent" are valid,
  acceptable results. Prefer an honest null to a fragile positive.
- Do NOT optimize for impressiveness. Optimize for claims that survive adversarial
  re-analysis by someone trying to prove you wrong.

================================================================================
## 4. ANALYSIS PLAN (your own code, gated — each step must pass before the next)
================================================================================
STEP 0 — PROVENANCE + RECOVERY REPORT (deliver this FIRST, before any paper writing).
  This is the gate that was missing last time. Produce a short report proving:
  (a) the data is what it claims: md5 match, 322 subjects × 4 domains, confidence 1–7,
      and reproduce one basic published/derivable summary (e.g. per-domain mean d' or
      M-ratio roughly matching the shipped MLE fits — as an EXTERNAL check, using your
      own computation).
  (b) your pipeline recovers known truth: simulate subjects with KNOWN confidence LEVEL
      and KNOWN metacognitive SENSITIVITY, run your estimators, and confirm each
      recovers its planted value AND that the two components are SEPARABLE (estimating
      one does not leak into the other). If they are not separable in simulation, the
      thesis cannot be cleanly tested — stop and report that.
  The user should be able to read STEP 0 and judge whether the foundation is real
  before you build anything on it. Do not proceed to Step 1 until Step 0 passes.

STEP 1 — Define the two components per subject per domain (your own code):
  LEVEL: mean normalized confidence per subject-domain (set-point); also
    over/underconfidence (mean confidence − accuracy) as an alternate index.
  INFORMATIVENESS: AUROC2 and gamma (model-light, primary), plus meta-d'/M-ratio
    (validate your meta-d' code against an established implementation before use).
    Report all three; check they agree at the individual level.

STEP 2 — Reliability of each component (with bootstrap CIs):
  Split-half (and odd/even or repeat-session where available) reliability per measure
  per domain, Spearman-Brown corrected. Derive the trials-needed curve for sensitivity.
  Report honestly; if reliability is low or unstable, that is a finding.

STEP 3 — CORE CONTRAST (the thesis test), within the SAME people and domains:
  - LEVEL generalization: correlate confidence set-point across domain pairs; meta-
    analyze across pairs; CIs.
  - INFORMATIVENESS generalization: correlate sensitivity across the same pairs; CIs.
  - Compare the two, accounting for each component's reliability (present disattenuation
    ONLY as a sensitivity range, never a single point). The key question: is level-
    generalization reliably LARGER than informativeness-generalization, in the same
    subjects and domains?

STEP 4 — NON-IPSATIVE DECOMPOSITION (handle the artifact):
  Build a multilevel model estimating, simultaneously, a person-level confidence set-
  point, a domain-specific bias residual, and a sensitivity term; ask which component
  carries the cross-domain covariance. Do NOT use naive mean subtraction. If the level
  component carries it and the residual/sensitivity does not, the thesis holds without
  the artifact.

STEP 5 — GENERALIZATION / ROBUSTNESS:
  Replicate the level-vs-informativeness contrast in Confidence Database multi-task
  studies. Report where it holds and where it fails, and test sensitivity to confidence-
  scale differences across studies.

STEP 6 — WRITE-UP:
  Manuscript with: the Step 0 provenance/recovery report, the two-component definitions,
  reliability results with CIs, the within-person generalization contrast, the
  multilevel decomposition, a limitations section, and a claim-status table
  (VERIFIED/REPRODUCED/FAILED) for every number, plus each figure's underlying data.

================================================================================
## 5. SUCCESS / FAILURE / SAFE CLAIM
================================================================================
STRONG: within the same people and domains, confidence LEVEL generalizes across
  domains substantially more than metacognitive INFORMATIVENESS, the gap survives
  reliability correction and the non-ipsative multilevel decomposition, and recovery
  confirms the two components are separable. Clean, original, postgrad-level.
STILL USEFUL IF THE EXCITING PART FAILS: a validated two-component measurement
  framework + honest reliability-corrected cross-domain estimates + the explanation
  that "domain-general bias" was really domain-general confidence LEVEL. A real floor.
AVOID: resurrecting any of the five collapsed claims; a single disattenuated point
  value; naive mean-subtraction; claiming separability without the recovery check;
  over-reading a small gap.
SAFE claim: "In these data, the confidence set-point generalizes across domains more
  strongly and reliably than metacognitive sensitivity; apparent domain-general
  metacognition is substantially domain-general confidence LEVEL."
OVERCLAIM to avoid: "metacognitive sensitivity is not domain-general at all" (it's weak
  and poorly measured, not proven absent).

================================================================================
## 6. DELIVERABLES
================================================================================
- The STEP 0 provenance + recovery report (first, standalone).
- A reproducible repo of YOUR OWN code + README to rerun end to end.
- A results directory with every number saved (CSV/JSON), including reliability CIs,
  recovery outputs, and multilevel model outputs.
- The manuscript draft with the claim-status table.
- An honest running log of what failed / what is unresolved.

================================================================================
## 7. POSTURE
================================================================================
Trust nothing you inherit; re-derive everything with your own code; be your own harshest
reviewer. Deliver the Step 0 gate first so the foundation can be judged before the paper
is built. Prefer few bulletproof claims to many fragile ones. Success is how much would
survive someone trying hard to prove you wrong.
