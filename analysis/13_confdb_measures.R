# Step 5a Part D — per subject-task measures + split-half reliabilities for
# the SELECTED Confidence Database studies (dispatch 009).
# REALDATA-EXTERNAL (CONFDB). NON-CONFIRMATORY: these are measurement
# summaries only; the level-vs-sensitivity contrast is preregistered
# separately (dispatch 010) and is NOT computed here.
#
# *** FIREWALL (binding, dispatch 009): NO cross-task quantity of any kind.
# *** No correlation, covariance, regression, or difference between tasks'
# *** measures, per study or pooled. The measures CSV is one row per
# *** subject x task with no cross-task columns; the reliability CSV is one
# *** row per study x task x measure. Auditable: every loop below is over
# *** one study-task cell at a time; no object ever joins two tasks.
#
# Preregistered cleaning (dispatch 009, implemented in R/confdb.R):
# drop training trials where flagged (Training != 0); drop missing-confidence
# trials; accuracy from a 0/1 Accuracy column when shipped, else
# Stimulus == Response equality (mechanism recorded per study in the
# selection CSV).
#
# Inclusion here: every subject x task cell with >= 60 clean trials in a
# SELECTED study (the same per-cell threshold as S1; all such subjects are
# included, not only S1-qualified ones, so Cowork can subset either way for
# the 010 preregistration).
#
# Measures per subject-task (dispatch 009):
#   n_trials_clean, mean_accuracy,
#   LEVEL = mean confidence normalized to [0,1] by the STUDY's own observed
#     clean-trial scale range (constants recorded per row),
#   raw AUROC2 (no d'-partialing here — estimator choices are preregistered
#     in 010), and a same-task d'-hat for later use (log-linear correction;
#     defined only for tasks with exactly 2 distinct stimulus values).
#
# Reliability per study-task: odd/even split by within-cell trial order
# (file row order), Spearman-Brown corrected, subject-bootstrap CIs (B=500).
#
# Outputs:
#   results/step11_CONFDB_measures.csv     one row per subject x task
#   results/step11_CONFDB_reliability.csv  one row per study x task x measure

library(here)
source(here("R", "confdb.R"))
source(here("R", "measures.R")) # auroc2()

set.seed(20260710)
n_boot <- 500L
min_trials <- 60L

raw_dir <- here("data", "raw", "confidence_db")
selection <- read.csv(here("results", "step11_CONFDB_selection.csv"),
                      stringsAsFactors = FALSE)
selected <- selection$study[selection$selected]
message("Selected studies: ", length(selected))
stopifnot(length(selected) > 0)

# d'-hat for Confidence Database coding: valid only when the task has exactly
# 2 distinct stimulus values; "signal" = the higher-sorted value; responses
# equal to the signal value count as signal responses. Log-linear correction
# as in R/parcels.R d_prime_hat.
dprime_confdb <- function(stim, resp, signal_value) {
  is_sig <- stim == signal_value
  n_s <- sum(is_sig)
  n_n <- sum(!is_sig)
  if (n_s == 0 || n_n == 0) return(NA_real_)
  h <- (sum(resp == signal_value & is_sig) + 0.5) / (n_s + 1)
  f <- (sum(resp == signal_value & !is_sig) + 0.5) / (n_n + 1)
  qnorm(h) - qnorm(f)
}

sb2 <- function(r) 2 * r / (1 + r)

measures_rows <- list()
rel_rows <- list()
mi <- 0L
ri <- 0L

for (study in selected) {
  fn <- paste0("data_", study, ".csv")
  message("Measuring ", study, " ...")
  p <- read_confdb_csv(file.path(raw_dir, fn))
  stopifnot(p$status %in% c("OK", "OK_WITH_FIX"))
  ct <- clean_trials(p$data)
  cd <- ct$data

  # study-level observed confidence range on clean trials (the preregistered
  # normalization; recorded on every row)
  conf_min <- min(cd$.conf)
  conf_max <- max(cd$.conf)
  stopifnot(conf_max > conf_min)

  s_col <- find_col(cd, "Stimulus")
  r_col <- find_col(cd, "Response")

  for (task in sort(unique(cd$.task))) {
    td <- cd[cd$.task == task, , drop = FALSE]

    # task-level stimulus coding for d'-hat
    stim_chr <- if (!is.na(s_col)) trimws(as.character(td[[s_col]])) else NULL
    stim_vals <- if (!is.null(stim_chr)) {
      sort(unique(stim_chr[!is.na(stim_chr) & stim_chr != ""]))
    } else character(0)
    dprime_ok <- length(stim_vals) == 2
    dprime_note <- if (dprime_ok) "" else
      sprintf("d'-hat undefined: %d distinct stimulus values",
              length(stim_vals))

    cnt <- table(td$.subj)
    subjects <- names(cnt)[cnt >= min_trials]
    if (length(subjects) == 0) next

    half_lv_o <- half_lv_e <- half_au_o <- half_au_e <-
      rep(NA_real_, length(subjects))

    for (k in seq_along(subjects)) {
      sd_ <- td[td$.subj == subjects[k], , drop = FALSE] # file row order
      lev_raw <- mean(sd_$.conf)
      dh <- NA_real_
      if (dprime_ok) {
        rs <- trimws(as.character(sd_[[r_col]]))
        dh <- dprime_confdb(trimws(as.character(sd_[[s_col]])), rs,
                            stim_vals[2])
      }
      mi <- mi + 1L
      measures_rows[[mi]] <- data.frame(
        data_type = "REALDATA-EXTERNAL (CONFDB)",
        study = study, task = task, subj_idx = subjects[k],
        n_trials_clean = nrow(sd_),
        mean_accuracy = mean(sd_$.acc),
        mean_conf_raw = lev_raw,
        conf_scale_min = conf_min, conf_scale_max = conf_max,
        level = (lev_raw - conf_min) / (conf_max - conf_min),
        auroc2 = auroc2(sd_$.conf, sd_$.acc),
        dprime_hat = dh,
        dprime_note = dprime_note,
        stringsAsFactors = FALSE
      )
      odd <- sd_[c(TRUE, FALSE), , drop = FALSE]
      even <- sd_[c(FALSE, TRUE), , drop = FALSE]
      half_lv_o[k] <- (mean(odd$.conf) - conf_min) / (conf_max - conf_min)
      half_lv_e[k] <- (mean(even$.conf) - conf_min) / (conf_max - conf_min)
      half_au_o[k] <- auroc2(odd$.conf, odd$.acc)
      half_au_e[k] <- auroc2(even$.conf, even$.acc)
    }

    # split-half reliability with subject bootstrap (B = n_boot), one
    # study-task cell at a time (no cross-task object anywhere)
    for (m in c("level", "auroc2")) {
      x <- if (m == "level") half_lv_o else half_au_o
      y <- if (m == "level") half_lv_e else half_au_e
      ok <- !is.na(x) & !is.na(y)
      xs <- x[ok]; ys <- y[ok]
      n <- length(xs)
      if (n < 3 || sd(xs) == 0 || sd(ys) == 0) {
        rel <- ci <- c(NA_real_, NA_real_, NA_real_)
      } else {
        rel <- sb2(cor(xs, ys))
        boots <- replicate(n_boot, {
          idx <- sample.int(n, replace = TRUE)
          if (sd(xs[idx]) == 0 || sd(ys[idx]) == 0) NA_real_
          else sb2(cor(xs[idx], ys[idx]))
        })
        ci <- quantile(boots, c(0.025, 0.975), names = FALSE, na.rm = TRUE)
        rel <- c(rel, ci)
      }
      ri <- ri + 1L
      rel_rows[[ri]] <- data.frame(
        data_type = "REALDATA-EXTERNAL (CONFDB)",
        study = study, task = task, measure = m,
        n_subjects = n, split = "odd_even_row_order",
        rel_sb = rel[1], ci_lo = rel[2], ci_hi = rel[3],
        n_boot = n_boot,
        stringsAsFactors = FALSE
      )
    }
  }
}

measures <- do.call(rbind, measures_rows)
reliability <- do.call(rbind, rel_rows)

# firewall self-check: measures has exactly one row per study-task-subject,
# and no column refers to more than one task
stopifnot(!anyDuplicated(measures[, c("study", "task", "subj_idx")]))

write.csv(measures, here("results", "step11_CONFDB_measures.csv"),
          row.names = FALSE)
write.csv(reliability, here("results", "step11_CONFDB_reliability.csv"),
          row.names = FALSE)

message("\n=== Part D summary ===")
message("subject-task rows: ", nrow(measures),
        " across ", length(unique(measures$study)), " studies / ",
        nrow(unique(measures[, c("study", "task")])), " study-task cells")
message("\nSplit-half reliabilities (Spearman-Brown, 95% subject-bootstrap CI):")
print(reliability[, c("study", "task", "measure", "n_subjects",
                      "rel_sb", "ci_lo", "ci_hi")], digits = 2, row.names = FALSE)
