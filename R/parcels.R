# Parcel-based latent-correlation machinery (step 0b'). Validated in
# simulation by analysis/02_latent_gate.R; reused on real data only if the
# step-0 gate passes.

# Interleaved parcel assignment (trial index mod k) keeps parcels
# exchangeable under any slow within-session drift.
parcel_measures <- function(trials, k) {
  p <- (seq_len(nrow(trials)) - 1L) %% k + 1L
  s <- vapply(seq_len(k), function(j) {
    auroc2(trials$confidence[p == j], trials$accuracy[p == j])
  }, numeric(1))
  l <- vapply(seq_len(k), function(j) {
    mean(trials$confidence[p == j])
  }, numeric(1))
  c(
    setNames(s, paste0("s", seq_len(k))),
    setNames(l, paste0("l", seq_len(k)))
  )
}

# Type-1 d' with log-linear correction (for d'-partialing variants).
d_prime_hat <- function(trials) {
  n_s <- sum(trials$signal == 1)
  n_n <- sum(trials$signal == 0)
  h <- (sum(trials$response == 1 & trials$signal == 1) + 0.5) / (n_s + 1)
  f <- (sum(trials$response == 1 & trials$signal == 0) + 0.5) / (n_n + 1)
  qnorm(h) - qnorm(f)
}

# Two-domain, two-component CFA: latent sensitivity and level per domain,
# each indicated by its parcels. std.lv = TRUE so the labeled factor
# covariances ARE correlations; gap is a lavaan defined parameter (delta-
# method SE, hence a CI on the gap from a single fit).
#
# Interleaved parcels are EXCHANGEABLE by construction, so within each factor
# the loadings and residual variances are constrained equal (true in the
# population). This is what identifies a 2-parcel factor and keeps weakly
# correlated parcels from collapsing into Heywood solutions.
latent_model <- function(k_a, k_b) {
  fac <- function(name, lab, ind) {
    c(
      paste0(name, " =~ ", paste(paste0("load_", lab, "*", ind),
                                 collapse = " + ")),
      paste0(ind, " ~~ resid_", lab, "*", ind)
    )
  }
  paste(c(
    fac("sensA", "sA", paste0("sA", seq_len(k_a))),
    fac("sensB", "sB", paste0("sB", seq_len(k_b))),
    fac("levA", "lA", paste0("lA", seq_len(k_a))),
    fac("levB", "lB", paste0("lB", seq_len(k_b))),
    "sensA ~~ rs*sensB",
    "levA ~~ rl*levB",
    "gap := rl - rs"
  ), collapse = "\n")
}

# Fit the model on a wide per-subject data frame. Each parcel FAMILY is
# rescaled by its pooled SD (a common constant per family, so exchangeability
# is preserved exactly; latent correlations are scale-free either way) to
# avoid feeding the optimizer variances four orders of magnitude apart.
# Returns estimates plus convergence/admissibility bookkeeping.
fit_latent <- function(dat, k_a, k_b) {
  families <- list(
    paste0("sA", seq_len(k_a)), paste0("sB", seq_len(k_b)),
    paste0("lA", seq_len(k_a)), paste0("lB", seq_len(k_b))
  )
  for (fam in families) {
    pooled_sd <- sqrt(mean(vapply(dat[fam], var, numeric(1), na.rm = TRUE)))
    dat[fam] <- lapply(dat[fam], function(x) {
      (x - mean(x, na.rm = TRUE)) / pooled_sd
    })
  }
  model <- latent_model(k_a, k_b)
  try_fit <- function(...) {
    tryCatch(suppressWarnings(lavaan::cfa(model, data = dat, std.lv = TRUE,
                                          ...)),
             error = function(e) NULL)
  }
  is_ok <- function(f) {
    !is.null(f) && lavaan::lavInspect(f, "converged") &&
      isTRUE(tryCatch(suppressWarnings(lavaan::lavInspect(f, "post.check")),
                      error = function(e) FALSE))
  }
  # unbounded ML is ~100x faster and almost always admissible thanks to the
  # exchangeability constraints; fall back to bounded estimation if not
  fit <- try_fit()
  if (!is_ok(fit)) {
    fit2 <- try_fit(bounds = "standard")
    if (is_ok(fit2)) fit <- fit2
  }
  bad <- data.frame(
    rho_sens = NA_real_, rho_sens_lo = NA_real_, rho_sens_hi = NA_real_,
    rho_level = NA_real_, rho_level_lo = NA_real_, rho_level_hi = NA_real_,
    gap = NA_real_, gap_lo = NA_real_, gap_hi = NA_real_,
    converged = FALSE, admissible = FALSE
  )
  if (is.null(fit)) {
    return(bad)
  }
  converged <- lavaan::lavInspect(fit, "converged")
  if (!converged) {
    bad$converged <- FALSE
    return(bad)
  }
  admissible <- tryCatch(
    suppressWarnings(lavaan::lavInspect(fit, "post.check")),
    error = function(e) FALSE
  )
  pe <- lavaan::parameterEstimates(fit)
  grab <- function(lab) pe[pe$label == lab, c("est", "ci.lower", "ci.upper")]
  rs <- grab("rs")
  rl <- grab("rl")
  gp <- grab("gap")
  data.frame(
    rho_sens = rs$est, rho_sens_lo = rs$ci.lower, rho_sens_hi = rs$ci.upper,
    rho_level = rl$est, rho_level_lo = rl$ci.lower, rho_level_hi = rl$ci.upper,
    gap = gp$est, gap_lo = gp$ci.lower, gap_hi = gp$ci.upper,
    converged = TRUE, admissible = isTRUE(admissible)
  )
}
