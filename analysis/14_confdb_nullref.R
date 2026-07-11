# Step 5b Part A — null-reference gate for the Confidence Database contrast
# (dispatch 010). SIMULATION (parameters matched to REALDATA-EXTERNAL
# (CONFDB) committed summaries; no real trial data is touched here).
#
# QUESTION THIS ANSWERS: under a TRUE-NULL world where confidence LEVEL and
# metacognitive SENSITIVITY are equally domain-general (true r_level =
# true r_sens = rho), how large a RAW observed gap (r_level - r_sens_raw)
# does differential attenuation alone produce at each selected study's
# n / trials / scale / reliability configuration?
#
# These intervals are a SIMULATION REFERENCE, not a correction and not a
# test (dispatch 010, binding). The frozen Lund 200/200 calibration does
# NOT transfer to these configs; nothing downstream is confirmatory.
#
# Preregistered design (dispatch 010, fixed before any contrast was run):
# - Per study: two tasks (the PRIMARY pair), matched n subjects (pair-
#   qualified in the committed step11 measures), matched trials/task
#   (median clean trials among those subjects), matched discrete confidence
#   scale, accuracy ~= observed, per-task level/sensitivity trait SDs tuned
#   so SIMULATED odd/even Spearman-Brown split-half reliabilities reproduce
#   the study's COMMITTED step11 reliabilities within +/-0.05.
# - Two null scenarios: rho in {0.30, 0.45} (true r_level = true r_sens).
# - 500 replicates per study x scenario, seeds 20260711 + rep (the same
#   seed sequence per cell, per dispatch).
# - Output: 2.5-97.5% interval of the raw gap under each null.
# - GATE (pre-declared): the simulator reproduces the 4 target
#   reliabilities (2 tasks x {level, auroc2}) within +/-0.05 in >= 3 of 4
#   studies; otherwise Part B runs WITHOUT null-reference columns.
#
# Generative model (per subject i, task t):
#   zL_i ~ BVN(0, 1; cor rho) across tasks; zS_i likewise, independent of zL
#   mu_it    = m_t + sigL_t * zL_it        (confidence set-point trait)
#   delta_it = d_t + sigS_t * zS_it        (confidence resolution trait)
#   per trial: acc ~ Bernoulli(p_t)
#              c_latent = mu_it + delta_it * (acc - 0.5) + N(0, 1)
#              confidence category = 1 + #{tau_k < c_latent},
#              tau = K-1 equally spaced cuts on [-1.5, 1.5]
#   LEVEL = (mean(category) - 1) / (K - 1); sensitivity = AUROC2.
#   m_t solved analytically so E[LEVEL] matches the observed task mean;
#   d_t = sqrt(2) * qnorm(observed mean AUROC2) (pre-discretization
#   approximation; achieved values reported, not assumed).
#
# Outputs:
#   results/step14_SIMULATION_confdb_nullref.csv  one row per study x scenario
#   results/step14_SIMULATION_confdb_nullref_meta.json

library(here)
source(here("R", "measures.R")) # auroc2()

n_rep <- 500L
rhos_null <- c(0.30, 0.45)
seed_base <- 20260711L
tol_rel <- 0.05
n_tune <- 3000L # tuning-cohort size (common random numbers per eval)

# ---- Preregistered primary pairs (dispatch 010) -----------------------------
pairs <- list(
  Arbuzova_2021_expt2 = c("1", "2"),
  Arbuzova_unpub_3    = c("memory", "visual"),
  Bang_2019_Exp2      = c("1", "2"),
  Haddara_2022_Expt1  = c("1", "2")
)

# ---- Matched parameters from COMMITTED step11 outputs -----------------------
measures <- read.csv(here("results", "step11_CONFDB_measures.csv"),
                     stringsAsFactors = FALSE,
                     colClasses = c(task = "character",
                                    subj_idx = "character"))
reliab <- read.csv(here("results", "step11_CONFDB_reliability.csv"),
                   stringsAsFactors = FALSE,
                   colClasses = c(task = "character"))
stopifnot(
  all(c("study", "task", "subj_idx", "n_trials_clean", "mean_accuracy",
        "level", "auroc2", "conf_scale_min", "conf_scale_max")
      %in% names(measures)),
  all(names(pairs) %in% measures$study),
  all(names(pairs) %in% reliab$study)
)

study_params <- lapply(names(pairs), function(st) {
  tks <- pairs[[st]]
  m <- measures[measures$study == st & measures$task %in% tks, ]
  # pair-qualified: the committed CSV only contains cells with >= 60 clean
  # trials, so a subject present under both tasks is S1-qualified for the pair
  wide_ids <- intersect(m$subj_idx[m$task == tks[1]],
                        m$subj_idx[m$task == tks[2]])
  stopifnot(length(wide_ids) >= 30)
  per_task <- lapply(tks, function(tk) {
    d <- m[m$task == tk & m$subj_idx %in% wide_ids, ]
    r <- reliab[reliab$study == st & reliab$task == tk, ]
    list(
      task = tk,
      n_trials = as.integer(round(median(d$n_trials_clean))),
      p_acc = mean(d$mean_accuracy),
      mean_level = mean(d$level),
      mean_auroc2 = mean(d$auroc2, na.rm = TRUE),
      rel_level_target = r$rel_sb[r$measure == "level"],
      rel_auroc2_target = r$rel_sb[r$measure == "auroc2"]
    )
  })
  k_scale <- unique(m$conf_scale_max - m$conf_scale_min + 1)
  stopifnot(length(k_scale) == 1, k_scale %in% c(4, 6))
  list(study = st, n_subj = length(wide_ids), k_scale = as.integer(k_scale),
       tasks = per_task)
})
names(study_params) <- names(pairs)

# ---- Simulator core ---------------------------------------------------------
taus_for <- function(k) seq(-1.5, 1.5, length.out = k - 1)

# Analytic E[LEVEL] given m (marginal over traits and accuracy):
# c_latent | acc ~ N(m + d*(acc-.5), 1 + sigL^2 + sigS^2/4)
expected_level <- function(m, d, sigL, sigS, p, k) {
  tau <- taus_for(k)
  s <- sqrt(1 + sigL^2 + sigS^2 / 4)
  exceed <- p * pnorm((tau - m - d / 2) / s, lower.tail = FALSE) +
    (1 - p) * pnorm((tau - m + d / 2) / s, lower.tail = FALSE)
  sum(exceed) / (k - 1)
}

solve_m <- function(target_level, d, sigL, sigS, p, k) {
  uniroot(function(m) expected_level(m, d, sigL, sigS, p, k) - target_level,
          interval = c(-8, 8), tol = 1e-6)$root
}

# Simulate one study-task cell for N subjects given trait z-scores.
# Returns per-subject LEVEL and AUROC2 for full trials and odd/even halves.
sim_cell <- function(zL, zS, n_trials, p, m, d, sigL, sigS, k) {
  n <- length(zL)
  mu <- m + sigL * zL
  delta <- d + sigS * zS
  acc <- matrix(rbinom(n * n_trials, 1, p), nrow = n)
  c_lat <- mu + delta * (acc - 0.5) +
    matrix(rnorm(n * n_trials), nrow = n)
  tau <- taus_for(k)
  cat_ <- matrix(1L, nrow = n, ncol = n_trials)
  for (tk in tau) cat_ <- cat_ + (c_lat > tk)
  odd <- seq(1, n_trials, by = 2)
  even <- seq(2, n_trials, by = 2)
  lev <- function(cols) (rowMeans(cat_[, cols, drop = FALSE]) - 1) / (k - 1)
  au <- function(cols) {
    vapply(seq_len(n), function(i) {
      auroc2(cat_[i, cols], acc[i, cols])
    }, numeric(1))
  }
  all_cols <- seq_len(n_trials)
  list(
    level = lev(all_cols), auroc2 = au(all_cols),
    level_odd = lev(odd), level_even = lev(even),
    auroc2_odd = au(odd), auroc2_even = au(even),
    mean_acc = mean(acc)
  )
}

sb2 <- function(r) 2 * r / (1 + r)

rel_sb <- function(x, y) {
  ok <- !is.na(x) & !is.na(y)
  if (sum(ok) < 3 || sd(x[ok]) == 0 || sd(y[ok]) == 0) return(NA_real_)
  sb2(cor(x[ok], y[ok]))
}

# ---- Reliability tuning (per task; common random numbers per eval) ----------
# Both reliabilities are monotone increasing in their trait SD, so two
# rounds of coordinate bisection suffice; m is re-solved at every eval so
# the level target stays matched while SDs move.
tune_eval <- function(sigL, sigS, tp, k, tune_seed) {
  m <- solve_m(tp$mean_level, tp$d_base, sigL, sigS, tp$p_acc, k)
  set.seed(tune_seed)
  zL <- rnorm(n_tune)
  zS <- rnorm(n_tune)
  cell <- sim_cell(zL, zS, tp$n_trials, tp$p_acc, m, tp$d_base, sigL, sigS, k)
  c(rel_level = rel_sb(cell$level_odd, cell$level_even),
    rel_auroc2 = rel_sb(cell$auroc2_odd, cell$auroc2_even))
}

bisect_sd <- function(which_sd, target, other_sd, tp, k, tune_seed,
                      lo = 0.02, hi = 5, n_iter = 14L) {
  rel_at <- function(v) {
    r <- if (which_sd == "sigL") tune_eval(v, other_sd, tp, k, tune_seed)
         else tune_eval(other_sd, v, tp, k, tune_seed)
    r[[if (which_sd == "sigL") "rel_level" else "rel_auroc2"]]
  }
  r_lo <- rel_at(lo)
  r_hi <- rel_at(hi)
  if (is.na(r_lo) || is.na(r_hi) || target <= r_lo) return(lo)
  if (target >= r_hi) return(hi)
  for (i in seq_len(n_iter)) {
    mid <- sqrt(lo * hi) # log-scale bisection
    if (rel_at(mid) < target) lo <- mid else hi <- mid
  }
  sqrt(lo * hi)
}

message("=== Part A: tuning per-task trait SDs to committed reliabilities ===")
tuned <- lapply(study_params, function(sp) {
  sp$tasks <- lapply(sp$tasks, function(tp) {
    tp$d_base <- sqrt(2) * qnorm(min(max(tp$mean_auroc2, 0.51), 0.99))
    tune_seed <- seed_base + sum(utf8ToInt(paste0(sp$study, tp$task))) %% 1000L
    sigL <- 0.5
    sigS <- 0.5
    for (round in 1:2) {
      sigL <- bisect_sd("sigL", tp$rel_level_target, sigS, tp, sp$k_scale,
                        tune_seed)
      sigS <- bisect_sd("sigS", tp$rel_auroc2_target, sigL, tp, sp$k_scale,
                        tune_seed)
    }
    tp$sigL <- sigL
    tp$sigS <- sigS
    tp$m <- solve_m(tp$mean_level, tp$d_base, sigL, sigS, tp$p_acc,
                    sp$k_scale)
    tuned_rel <- tune_eval(sigL, sigS, tp, sp$k_scale, tune_seed)
    message(sprintf(
      "  %s task %s: sigL=%.3f sigS=%.3f | tuning rel level %.3f (target %.3f) auroc2 %.3f (target %.3f)",
      sp$study, tp$task, sigL, sigS,
      tuned_rel["rel_level"], tp$rel_level_target,
      tuned_rel["rel_auroc2"], tp$rel_auroc2_target))
    tp
  })
  sp
})

# ---- Null-world replicates --------------------------------------------------
message("\n=== Part A: null-world replicates (", n_rep,
        " per study x scenario) ===")
rows <- list()
ri <- 0L
achieved_store <- list()

for (sp in tuned) {
  k <- sp$k_scale
  n <- sp$n_subj
  for (rho in rhos_null) {
    gaps <- r_levels <- r_senss <- numeric(n_rep)
    rel_mat <- matrix(NA_real_, nrow = n_rep, ncol = 4)
    trait_cors <- matrix(NA_real_, nrow = n_rep, ncol = 2)
    acc_lev <- matrix(NA_real_, nrow = n_rep, ncol = 4)
    ch <- chol(matrix(c(1, rho, rho, 1), 2))
    for (rep in seq_len(n_rep)) {
      set.seed(seed_base + rep)
      zL <- matrix(rnorm(n * 2), ncol = 2) %*% ch
      zS <- matrix(rnorm(n * 2), ncol = 2) %*% ch
      cells <- lapply(1:2, function(j) {
        tp <- sp$tasks[[j]]
        sim_cell(zL[, j], zS[, j], tp$n_trials, tp$p_acc, tp$m, tp$d_base,
                 tp$sigL, tp$sigS, k)
      })
      r_lev <- cor(cells[[1]]$level, cells[[2]]$level)
      ok <- !is.na(cells[[1]]$auroc2) & !is.na(cells[[2]]$auroc2)
      r_sen <- cor(cells[[1]]$auroc2[ok], cells[[2]]$auroc2[ok])
      r_levels[rep] <- r_lev
      r_senss[rep] <- r_sen
      gaps[rep] <- r_lev - r_sen
      rel_mat[rep, ] <- c(
        rel_sb(cells[[1]]$level_odd, cells[[1]]$level_even),
        rel_sb(cells[[1]]$auroc2_odd, cells[[1]]$auroc2_even),
        rel_sb(cells[[2]]$level_odd, cells[[2]]$level_even),
        rel_sb(cells[[2]]$auroc2_odd, cells[[2]]$auroc2_even)
      )
      trait_cors[rep, ] <- c(cor(zL[, 1], zL[, 2]), cor(zS[, 1], zS[, 2]))
      acc_lev[rep, ] <- c(cells[[1]]$mean_acc, mean(cells[[1]]$level),
                          cells[[2]]$mean_acc, mean(cells[[2]]$level))
    }
    ach <- colMeans(rel_mat, na.rm = TRUE)
    targets <- c(sp$tasks[[1]]$rel_level_target,
                 sp$tasks[[1]]$rel_auroc2_target,
                 sp$tasks[[2]]$rel_level_target,
                 sp$tasks[[2]]$rel_auroc2_target)
    if (abs(rho - rhos_null[1]) < 1e-9) {
      achieved_store[[sp$study]] <- list(achieved = ach, targets = targets)
    }
    qs <- quantile(gaps, c(0.025, 0.5, 0.975), names = FALSE)
    ri <- ri + 1L
    rows[[ri]] <- data.frame(
      data_type = "SIMULATION",
      study = sp$study,
      task_a = sp$tasks[[1]]$task, task_b = sp$tasks[[2]]$task,
      rho_null = rho, n_rep = n_rep, n_subjects = n,
      n_trials_a = sp$tasks[[1]]$n_trials,
      n_trials_b = sp$tasks[[2]]$n_trials,
      k_scale = k,
      gap_raw_null_lo = qs[1], gap_raw_null_med = qs[2],
      gap_raw_null_hi = qs[3],
      r_level_null_mean = mean(r_levels),
      r_sens_raw_null_mean = mean(r_senss),
      achieved_rel_level_a = ach[1], achieved_rel_auroc2_a = ach[2],
      achieved_rel_level_b = ach[3], achieved_rel_auroc2_b = ach[4],
      target_rel_level_a = targets[1], target_rel_auroc2_a = targets[2],
      target_rel_level_b = targets[3], target_rel_auroc2_b = targets[4],
      max_abs_rel_dev = max(abs(ach - targets)),
      realized_trait_cor_level = mean(trait_cors[, 1]),
      realized_trait_cor_sens = mean(trait_cors[, 2]),
      achieved_mean_acc_a = mean(acc_lev[, 1]),
      achieved_mean_level_a = mean(acc_lev[, 2]),
      achieved_mean_acc_b = mean(acc_lev[, 3]),
      achieved_mean_level_b = mean(acc_lev[, 4]),
      stringsAsFactors = FALSE
    )
    message(sprintf(
      "  %s rho=%.2f: raw-gap null interval [%.3f, %.3f] (med %.3f); max |rel dev| %.3f",
      sp$study, rho, qs[1], qs[3], qs[2], max(abs(ach - targets))))
  }
}

out <- do.call(rbind, rows)

# ---- Gate decision (pre-declared) -------------------------------------------
# A study passes if all 4 achieved reliabilities (from the actual replicate
# runs, rho = 0.30 scenario is representative; both scenarios' deviations
# are in the CSV) are within +/-0.05 of the committed targets.
study_pass <- vapply(names(achieved_store), function(st) {
  a <- achieved_store[[st]]
  all(abs(a$achieved - a$targets) <= tol_rel)
}, logical(1))
gate_pass <- sum(study_pass) >= 3

# Stricter honesty check: also require the deviations to hold in BOTH
# scenarios (report if they differ).
worst_dev_any <- vapply(names(pairs), function(st) {
  max(out$max_abs_rel_dev[out$study == st])
}, numeric(1))

write.csv(out, here("results", "step14_SIMULATION_confdb_nullref.csv"),
          row.names = FALSE)

meta <- list(
  data_type = "SIMULATION",
  dispatch = "010 Part A",
  purpose = paste(
    "Null-reference intervals for the RAW level-vs-sensitivity gap in the",
    "4 selected Confidence Database studies under a true-null world",
    "(true r_level = true r_sens = rho). SIMULATION REFERENCE ONLY -",
    "not a correction, not a test; nothing in this tier is confirmatory."),
  design = list(
    rho_null = rhos_null, n_rep = n_rep,
    seeds = "20260711 + rep (same sequence per study x scenario, per dispatch)",
    tuning = paste(
      "per-task coordinate bisection (2 rounds, log-scale, common random",
      "numbers, tuning cohort n =", n_tune, ") of trait SDs so simulated",
      "odd/even Spearman-Brown reliabilities match committed step11 values"),
    thresholds = "K-1 equally spaced latent cuts on [-1.5, 1.5]",
    gate = paste(
      "PASS iff achieved reliabilities within +/-", tol_rel,
      "of committed targets for all 4 cells in >= 3 of 4 studies")
  ),
  matched_parameters = lapply(tuned, function(sp) {
    list(n_subjects = sp$n_subj, k_scale = sp$k_scale,
         tasks = lapply(sp$tasks, function(tp) {
           tp[c("task", "n_trials", "p_acc", "mean_level", "mean_auroc2",
                "rel_level_target", "rel_auroc2_target",
                "d_base", "sigL", "sigS", "m")]
         }))
  }),
  study_pass = as.list(study_pass),
  worst_abs_rel_dev_across_scenarios = as.list(worst_dev_any),
  gate = if (gate_pass) "PASS" else "FAIL_SKIP_NULLREF",
  r_version = R.version.string,
  run_utc = format(Sys.time(), tz = "UTC", usetz = TRUE)
)
jsonlite::write_json(
  meta, here("results", "step14_SIMULATION_confdb_nullref_meta.json"),
  auto_unbox = TRUE, pretty = TRUE, digits = 8)

message("\n=== Part A gate ===")
for (st in names(study_pass)) {
  message(sprintf("  %s: %s (worst |rel dev| across scenarios %.3f)",
                  st, if (study_pass[st]) "PASS" else "FAIL",
                  worst_dev_any[st]))
}
message("GATE: ", meta$gate)
