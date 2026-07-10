# Lund et al. (2025) — dg-metacognition raw data

Primary dataset for this project. Fetched fresh from the official repository by
`analysis/00_fetch_verify.R` (Step 0a); do not edit anything in this directory.

- **Source repo:** https://github.com/embodied-computation-group/dg-metacognition
- **Pinned commit:** `0c38aba4eb720a143d126b7c7d4c313a900bc536` (2024-06-28; verified as
  repo HEAD on 2026-07-10)
- **Fetch date:** 2026-07-10 (UTC)
- **Fetch method:** direct raw-URL download per file at the pinned commit. The repo is
  deliberately NOT cloned in full on this machine: it contains two files whose names
  differ only in case (`metacognition_TrialData_master.csv` vs
  `metacognition_trialData_master.csv`), which collide on case-insensitive NTFS. Raw
  URLs are case-sensitive, so per-file download is safe.

## Files

| File | md5 | Bytes | In git? |
|---|---|---|---|
| `metacognition_trialData_master.csv` | `500b2e6e1eb0e47e717feba5b912ad9f` | 11,837,935 | No (gitignored; re-fetch via script) |
| `mle_fit_data_wide.csv` | `8dafc9a5a87c4c9a9461083d48d9c640` | 118,445 | Yes |

URLs (pinned commit):

- https://raw.githubusercontent.com/embodied-computation-group/dg-metacognition/0c38aba4eb720a143d126b7c7d4c313a900bc536/data_summary/metacognition_trialData_master.csv
- https://raw.githubusercontent.com/embodied-computation-group/dg-metacognition/0c38aba4eb720a143d126b7c7d4c313a900bc536/data_summary/mle_fit_data_wide.csv

## Verification status (Step 0a, 2026-07-10)

- Trial-file md5 and byte size match the expected values exactly (**VERIFIED**).
- Structure **VERIFIED**: 193,200 rows; 322 subjects; modalities Calories, GDP,
  memory, vision; confidence integers 1–7; 11 columns (subject, modality, trial,
  signal, response, accuracy, confidence, rt, rt_conf, contrast, repeat_exclude);
  median trials/subject 200 (memory), 200 (vision), 101 (Calories), 99 (GDP).
- The lowercase `trialData` file is the CORRECT one. The similarly named
  `TrialData` file (md5 `653437023bcee998481bc33a77fd2729`) is a different, wrong
  file — never fetch it.
- `mle_fit_data_wide.csv` (320 subjects, 26 cols) is the authors' shipped MLE
  fits. Used ONLY as an external cross-check, never as primary numbers. Their
  `avg_conf_*` columns agree with per-subject mean confidence computed from raw
  trials to r ≥ 0.998 per domain, with a small systematic offset (~0.02–0.03,
  theirs higher) attributable to undocumented preprocessing in their pipeline;
  their `da_*` columns are a different SDT quantity than naive d′ and are not
  numerically comparable. See `results/step0a_provenance.json` and
  `results/step0a_basic_summary.csv`.
