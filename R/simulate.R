# Generative simulator for step 0b. SIMULATION ONLY — never empirical data.
#
# Each simulated subject-domain carries three independently planted traits:
#   d_prime — type-1 sensitivity (drives accuracy),
#   lambda  — metacognitive SENSITIVITY in [0, 1): how strongly the trial's
#             confidence evidence tracks the decision evidence |x|,
#   beta    — confidence LEVEL / set-point: shifts where confidence lands on
#             the 1-7 scale without touching accuracy or evidence quality.
#
# Trial model (SDT-style): signal S in {0,1} equiprobable; evidence
# x ~ N(+-d'/2, 1); response = (x > 0); accuracy = (response == S).
# Confidence evidence:
#   z = lambda * standardize(|x|) + sqrt(1 - lambda^2) * noise + beta,
# where standardize() uses the analytic folded-normal mean/sd of |x| given the
# subject's d', so E[z] = beta and Var[z] = 1 for every (d', lambda). That is
# what keeps the two knobs mechanistically separate in the generator; any
# residual coupling can only enter through the 1-7 binning, and the simulator
# self-check quantifies it. z is cut into confidence 1-7 by fixed
# population-wide thresholds.

folded_mean <- function(mu) {
  sqrt(2 / pi) * exp(-mu^2 / 2) + mu * (1 - 2 * pnorm(-mu))
}

folded_sd <- function(mu) {
  sqrt(mu^2 + 1 - folded_mean(mu)^2)
}

# Fixed 1-7 cutpoints: equal mass under N(0,1), i.e. a neutral subject
# (beta = 0) uses all seven categories about equally.
conf_thresholds <- qnorm(seq_len(6) / 7)

# One subject-domain block of trials.
simulate_trials <- function(n_trials, d_prime, lambda, beta) {
  mu <- d_prime / 2
  signal <- rbinom(n_trials, 1, 0.5)
  x <- rnorm(n_trials, mean = mu * (2 * signal - 1), sd = 1)
  response <- as.integer(x > 0)
  accuracy <- as.integer(response == signal)
  z <- lambda * (abs(x) - folded_mean(mu)) / folded_sd(mu) +
    sqrt(1 - lambda^2) * rnorm(n_trials) + beta
  confidence <- 1L + findInterval(z, conf_thresholds)
  data.frame(signal, response, accuracy, confidence)
}

# Independent trait draws for a cohort. d' centred so generated accuracy sits
# in the empirical Lund-2025 per-domain range (calibration only; see step 0b).
draw_traits <- function(n_subjects, d_prime_mean = 1.2) {
  data.frame(
    d_prime = pmax(rnorm(n_subjects, d_prime_mean, 0.3), 0.2),
    lambda = runif(n_subjects, 0.15, 0.85),
    beta = rnorm(n_subjects, 0, 0.8)
  )
}

# Simulate a cohort at a given trial count and estimate per-subject measures
# on all trials plus odd/even half-trial splits (for split-half reliability).
run_cohort <- function(traits, n_trials) {
  est <- lapply(seq_len(nrow(traits)), function(i) {
    tr <- simulate_trials(
      n_trials, traits$d_prime[i], traits$lambda[i], traits$beta[i]
    )
    halves <- list(all = tr, odd = tr[c(TRUE, FALSE), ], even = tr[c(FALSE, TRUE), ])
    out <- lapply(halves, function(h) {
      c(
        mean_conf = mean(h$confidence),
        accuracy = mean(h$accuracy),
        auroc2 = auroc2(h$confidence, h$accuracy),
        gamma = gk_gamma(h$confidence, h$accuracy)
      )
    })
    unlist(out)
  })
  cbind(traits, as.data.frame(do.call(rbind, est)))
}
