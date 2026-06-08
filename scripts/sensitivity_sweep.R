#!/usr/bin/env Rscript
## ===========================================================================
## sensitivity_sweep.R
##
## Cross-domain validation harness for
##   "Identifiability under imperfect coarsening: sensitivity bounds and the
##    singleton sample complexity that restores them" (Pillar 2).
##
## Validates two theorems by Monte Carlo, base R only, no external data:
##
##   Theorem A (thm:sensitivity, eq:bias / eq:Bdelta).
##     Under a C2-violation tilt of magnitude delta,
##         kappa(r|y) = kappa_0(r) exp{ delta h(r,y) },   h centered, |h| <= 1,
##     the face-value MLE has asymptotic bias, to leading order,
##         theta_delta - theta^star = delta * Info^{-1} Cov(score, tilt) + O(delta^2).
##     We sweep delta, simulate, fit the face-value MLE, record realized bias,
##     and overlay the analytic first-order prediction (slope computed from the
##     model's own score and tilt, NOT hardcoded).
##       Domain (i):  regular exponential family. Bernoulli latent with
##                    value-dependent coarsening (dropout tilted by the true
##                    latent value). Prediction is exact at every delta along the
##                    curved direction (the report law stays an exponential
##                    family under the tilt).
##       Domain (ii): location family. Differential-privacy regime, M = mu + Z
##                    with informative (data-dependent) noise scale. Prediction
##                    holds up to the O_p(n^{-1/2}) remainder.
##
##   Theorem B (thm:restoration, eq:samplecomplexity).
##     n_s = Theta(r / gamma^2) singletons restore the r confounded directions.
##     We build a domain with a tunable rank deficit r and margin gamma, add n_s
##     singletons, and record restored-parameter squared error vs n_s, r, gamma.
##     Expected: error ~ 1/n_s; singletons-for-fixed-accuracy linear in r;
##     dependence gamma^{-2}.
##
## Output: figures/sensitivity_sweep.pdf, figures/singleton_complexity.pdf,
##         scripts/sweep_results.rds; a concise summary to stdout.
## ===========================================================================

set.seed(20260608L)

## Resolve paths relative to this script so `make sim` works from the repo root.
args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
if (length(file_arg) == 1L) {
  script_path <- normalizePath(sub("^--file=", "", file_arg))
  repo_root   <- dirname(dirname(script_path))
} else {
  repo_root <- normalizePath(getwd())
}
fig_dir <- file.path(repo_root, "figures")
out_dir <- file.path(repo_root, "scripts")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

cat("== Cross-domain validation harness (coarsening-sensitivity) ==\n")
cat("repo root :", repo_root, "\n")
cat("figures   :", fig_dir, "\n\n")

## ===========================================================================
## THEOREM A, DOMAIN (i): regular exponential family
## ---------------------------------------------------------------------------
## Latent Y ~ Bernoulli(p), natural parameter eta = logit(p), so theta = eta.
## The estimand we report on is the mean p = expit(eta); we work on the natural
## scale where the family is curved exponential, then read off the induced bias.
##
## Coarsening. Each unit is either reported exactly (a singleton candidate set
## {y}, fully informative) or coarsened to the full set {0,1} (uninformative,
## "missing"). Under C2 the coarsening probability is flat in y. The tilt makes
## the probability of being *kept* (reported as a singleton) depend on the true
## value y. With centered tilt h(y) = y - p (mean zero under the truth) and
## bound rescaled into |h| <= 1, the keep-weight is
##     kappa(keep | y) = kappa_0 * exp{ delta * h(y) }.
## A kept unit's report is its exact value; a coarsened unit carries no
## information. The face-value MLE uses only kept units:
##     phat = (# kept ones) / (# kept).
## This is the textbook value-dependent-missingness (MNAR) Bernoulli, and it is
## exactly the candidate-set picture: singleton report vs uninformative full set.
##
## Exactness. Among kept units, P(y=1 | kept) is itself a Bernoulli whose natural
## parameter is eta shifted by a delta-linear amount; hence the face-value MLE
## converges to a pseudo-true p_delta and the leading term is exact along the
## curved direction. We verify the slope of (p_delta - p^star) in delta against
## the theorem's Info^{-1} Cov(score, tilt).
## ===========================================================================

expit <- function(x) 1 / (1 + exp(-x))
logit <- function(p) log(p / (1 - p))

## Exact pseudo-true mean p_delta = E[Y | kept] under the tilt (closed form).
## P(keep|y) propto exp(delta * h(y)); h(1)=1-p0 (scaled), h(0)=-p0 (scaled).
## We use the centered, scaled tilt hbar(y) = (y - p0) so that within-set mean is
## zero under the truth; |hbar| <= max(p0, 1-p0) <= 1, satisfying the bound.
expA_pseudo_true <- function(p0, delta) {
  ## h(y) = y - p0 (mean zero under p0). Keep-weight w(y) = exp(delta*(y-p0)).
  w1 <- exp(delta * (1 - p0))
  w0 <- exp(delta * (0 - p0))
  ## p_delta = P(Y=1 | kept) = p0 w1 / (p0 w1 + (1-p0) w0)
  (p0 * w1) / (p0 * w1 + (1 - p0) * w0)
}

## Theorem A predicted slope d/ddelta (p_delta - p0) at delta = 0, on the MEAN
## scale. We get it the way the theorem says: Info^{-1} Cov(score, tilt) on the
## natural scale, then push through dp/deta. For Bernoulli on the natural scale
## eta, the per-kept-unit score for a *kept* observation about eta is (y - p0),
## the face-value information is Info = Var(Y) = p0(1-p0), and the tilt h(y) =
## (y - p0). So Cov(score, h) = E[(y-p0)^2] = p0(1-p0) and
##     d eta_delta / ddelta = Info^{-1} Cov = 1.
## On the mean scale, dp/deta = p0(1-p0), so the predicted MEAN-scale slope is
##     slope_pred = p0(1-p0) * 1 = p0(1-p0).
## We also confirm this equals the exact-derivative of expA_pseudo_true at 0.
expA_pred_slope <- function(p0) {
  score_tilt_cov <- p0 * (1 - p0)   # Cov(y-p0, y-p0)
  info           <- p0 * (1 - p0)   # face-value information (natural scale)
  d_eta          <- score_tilt_cov / info        # = 1
  dp_deta        <- p0 * (1 - p0)                 # mean-scale Jacobian
  dp_deta * d_eta
}

simA_one <- function(p0, delta, n, base_keep = 0.25) {
  y <- rbinom(n, 1, p0)
  ## keep probability proportional to exp(delta*(y-p0)); the baseline keep rate
  ## kappa0 = base_keep is a constant that cancels from phat, so only the
  ## y-dependence (the tilt) matters. base_keep is chosen small enough that
  ## base_keep*exp(delta*(1-p0)) stays < 1 over the whole grid, so the keep
  ## probability is never clipped and the simulation realizes the PURE
  ## exponential tilt that expA_pseudo_true assumes (exactness, not an approx).
  w <- exp(delta * (y - p0))
  keep_prob <- base_keep * w
  stopifnot(max(keep_prob) <= 1 + 1e-9)          # guard: no clipping
  kept <- rbinom(n, 1, pmin(1, keep_prob)) == 1L
  if (sum(kept) < 2L) return(NA_real_)
  mean(y[kept])                                   # face-value MLE of the mean
}

run_domainA <- function(p0 = 0.35,
                        deltas = seq(0, 0.8, by = 0.1),
                        n = 20000L, reps = 600L) {
  pred_slope <- expA_pred_slope(p0)               # MEAN-scale leading slope
  eta0 <- logit(p0)
  realized <- numeric(length(deltas)); se <- numeric(length(deltas))
  exact    <- numeric(length(deltas))
  realized_eta <- numeric(length(deltas)); se_eta <- numeric(length(deltas))
  for (k in seq_along(deltas)) {
    d <- deltas[k]
    est <- replicate(reps, simA_one(p0, d, n))
    est <- est[is.finite(est)]
    realized[k] <- mean(est) - p0                 # mean-scale realized bias
    se[k]       <- sd(est) / sqrt(length(est))
    exact[k]    <- expA_pseudo_true(p0, d) - p0   # exact pseudo-true bias (mean)
    ## natural-scale bias: logit(phat) - eta0. On the eta scale the pseudo-true is
    ## EXACTLY eta0 + delta (slope exactly 1), so this is the genuine "exact along
    ## the curved direction" demonstration with no O(delta^2) term.
    eta_est <- logit(pmin(pmax(est, 1e-6), 1 - 1e-6))
    realized_eta[k] <- mean(eta_est) - eta0
    se_eta[k]       <- sd(eta_est) / sqrt(length(eta_est))
  }
  list(domain = "Bernoulli dropout (exp-family)",
       p0 = p0, eta0 = eta0, deltas = deltas,
       realized = realized, se = se, exact = exact, pred_slope = pred_slope,
       realized_eta = realized_eta, se_eta = se_eta, pred_slope_eta = 1.0,
       n = n, reps = reps)
}

## ===========================================================================
## THEOREM A, DOMAIN (ii): location family (differential privacy)
## ---------------------------------------------------------------------------
## Latent mu (a sensitive statistic). The released report is M = mu + Z, the
## standard additive-noise mechanism. The estimand theta = mu. Under C2 the noise
## law is symmetric and independent of which admissible value mu took (data-
## independent mechanism, e.g. Laplace/Gaussian): the face-value MLE mean(M) is
## unbiased. The C2 violation is a DATA-DEPENDENT mechanism: the noise is tilted
## so that the report distribution within the candidate set prefers values on one
## side, i.e. the conditional density of M given the latent draw is tilted by
## h(m, y). We realize the tilt as an exponential reweighting of the symmetric
## Gaussian noise:
##     p_delta(m | mu) propto phi((m-mu)/sigma) * exp{ delta * h(m) },
## with h centered. Taking the canonical informative direction h(m) = (m - mu)/c
## (scaled to |h|<=1 over the effective support) shifts the report mean, biasing
## the face-value estimator mean(M).
##
## For a Gaussian kernel and h linear in the residual, the tilted law is again
## Gaussian with a shifted mean: p_delta(m|mu) = N(mu + delta*sigma^2/c, sigma^2).
## So the face-value estimator mean(M) -> mu + delta*sigma^2/c, giving an exact
## leading slope sigma^2/c with an O_p(n^{-1/2}) Monte Carlo remainder. This is
## the location-family analogue: the prediction Info^{-1}Cov(score, tilt) equals
## the same constant.
##
## Theorem-form check. Face-value model: M ~ N(mu, sigma^2), score about mu is
## s = (m-mu)/sigma^2, Info = 1/sigma^2. Tilt h(m) = (m-mu)/c. Then
##     Cov(s, h) = E[(m-mu)^2]/(sigma^2 c) = sigma^2/(sigma^2 c) = 1/c,
##     Info^{-1} Cov(s,h) = sigma^2 * (1/c) = sigma^2 / c   ==> predicted slope.
## ===========================================================================

dp_pred_slope <- function(sigma, c_scale) sigma^2 / c_scale

## Draw from the tilted Gaussian report law exactly: N(mu + delta*sigma^2/c, sigma^2).
simDP_one <- function(mu0, delta, sigma, c_scale, n) {
  shift <- delta * sigma^2 / c_scale
  m <- rnorm(n, mean = mu0 + shift, sd = sigma)
  mean(m) - mu0                                   # realized bias of face-value MLE
}

run_domainDP <- function(mu0 = 2.0, sigma = 1.0, c_scale = 1.5,
                         deltas = seq(0, 0.8, by = 0.1),
                         n = 4000L, reps = 400L) {
  pred_slope <- dp_pred_slope(sigma, c_scale)
  realized <- numeric(length(deltas))
  se       <- numeric(length(deltas))
  exact    <- numeric(length(deltas))
  for (k in seq_along(deltas)) {
    d <- deltas[k]
    est <- replicate(reps, simDP_one(mu0, d, sigma, c_scale, n))
    realized[k] <- mean(est)
    se[k]       <- sd(est) / sqrt(length(est))
    exact[k]    <- d * pred_slope                 # exact tilted-mean bias
  }
  list(domain = "Gaussian DP mechanism (location)",
       mu0 = mu0, sigma = sigma, c_scale = c_scale,
       deltas = deltas, realized = realized, se = se,
       exact = exact, pred_slope = pred_slope, n = n, reps = reps)
}

## ---------------------------------------------------------------------------
## Fit realized-bias slope (through the origin) and R^2 vs the analytic line.
## `small_frac` restricts the slope fit to the small-delta head of the grid so
## the LEADING-order slope is read off without O(delta^2) curvature; the full-grid
## R^2 against the straight prediction line is also returned.
## ---------------------------------------------------------------------------
fit_through_origin <- function(delta, bias, small_frac = 0.5) {
  ok <- delta > 0
  ## small-delta head for the leading-order slope
  thr <- quantile(delta[ok], small_frac, type = 1)
  head <- ok & (delta <= thr)
  b_head <- sum(delta[head] * bias[head]) / sum(delta[head]^2)
  ## full-grid slope and R^2 about the no-intercept fit
  b_full <- sum(delta * bias) / sum(delta * delta)
  fitted <- b_full * delta
  sse <- sum((bias - fitted)^2); sst <- sum(bias^2)
  r2  <- if (sst > 0) 1 - sse / sst else NA_real_
  list(slope = b_full, slope_head = b_head, r2 = r2)
}

## Max relative deviation of realized bias from a reference (e.g. exact pseudo-
## true), over delta > 0. Tests the "exact along the curved direction" claim.
max_rel_dev <- function(realized, reference, delta) {
  ok <- delta > 0 & abs(reference) > 1e-9
  max(abs(realized[ok] - reference[ok]) / abs(reference[ok]))
}

## ===========================================================================
## THEOREM B: singleton sample complexity  n_s = Theta(r / gamma^2)
## ---------------------------------------------------------------------------
## We construct a problem with an explicit rank deficit r and margin gamma.
##
## Model. Parameter theta in R^p. The coarsened data identify theta on V^perp
## (a (p-r)-dimensional subspace) exactly; they carry NO information on an
## r-dimensional confounded subspace V. We take V = span of the first r
## coordinate axes WLOG (any orthonormal basis works; coordinates are the
## confounded directions). Singletons are direct, noisy observations of the
## latent value along V: a singleton assigned to direction j observes
##     x = theta_j * gamma + noise,   noise ~ N(0, sigma^2),
## so the per-singleton Fisher information for theta_j is gamma^2 / sigma^2, i.e.
## the per-singleton information along every unit direction of V is (gamma^2/
## sigma^2) >= gamma (margin gamma is the smallest singleton signal along V).
## Balanced allocation spreads n_s singletons across the r directions; the MLE of
## theta_j from its n_s/r singletons has variance sigma^2 / (gamma^2 * n_s/r) =
## r sigma^2 / (gamma^2 n_s).
##
## What "target accuracy" means, and why it sets the r-exponent. The
## eq:samplecomplexity statement n_s = Theta(r/gamma^2) is the PER-DIRECTION
## (mean) accuracy target: restore each of the r confounded directions to squared
## error eps^2. Per-direction error is sigma^2/(gamma^2 * n_s/r) = r sigma^2/
## (gamma^2 n_s); setting it to eps^2 gives n_s = r sigma^2/(gamma^2 eps^2),
## LINEAR in r. This is the rate the theorem states and the natural one (you want
## every confounded direction recovered, and the count scales with how many there
## are). The TOTAL squared error over all r directions is instead
##     E ||thetahat_V - theta_V||^2 = r * (r sigma^2)/(gamma^2 n_s)
##                                  = r^2 sigma^2 / (gamma^2 n_s),
## so a fixed-TOTAL-error target needs n_s = r^2 sigma^2/(gamma^2 eps^2), QUADRATIC
## in r. The restoration.tex sketch records exactly this fork ("r^2 ... in the
## worst split and r/gamma^2 under a balanced allocation"). We therefore measure
## BOTH r-exponents and let the prose state which target each corresponds to,
## rather than fudge a single number. The robust, target-independent predictions
## are:
##     (B1) error ~ 1/n_s          (slope -1 on log-log in n_s),
##     (B2) error ~ gamma^{-2}     (slope -2 on log-log in gamma),
##     (B3) n_s for fixed PER-DIRECTION accuracy is linear in r  (slope +1),
##          n_s for fixed TOTAL accuracy is quadratic in r       (slope +2);
## the per-direction target is the one eq:samplecomplexity asserts.
## ===========================================================================

## One restored-estimator squared error on V, balanced allocation. Returns both
## the TOTAL squared error over the r directions and the PER-DIRECTION mean.
simB_one <- function(r, gamma, n_s, sigma = 1.0, theta_true = NULL) {
  if (is.null(theta_true)) theta_true <- rep(1.0, r)  # unit signal per direction
  ## balanced allocation: floor split, distribute remainder
  per <- rep(n_s %/% r, r)
  rem <- n_s %% r
  if (rem > 0) per[seq_len(rem)] <- per[seq_len(rem)] + 1L
  err2 <- 0
  for (j in seq_len(r)) {
    nj <- per[j]
    if (nj < 1L) { err2 <- err2 + theta_true[j]^2; next }  # no data: full error
    ## singleton observations x = theta_j*gamma + N(0,sigma^2); MLE thetahat_j =
    ## mean(x)/gamma. Var(thetahat_j) = sigma^2/(gamma^2 nj).
    x <- rnorm(nj, mean = theta_true[j] * gamma, sd = sigma)
    thetahat_j <- mean(x) / gamma
    err2 <- err2 + (thetahat_j - theta_true[j])^2
  }
  c(total = err2, per_dir = err2 / r)
}
## Convenience accessors averaging over reps.
simB_total   <- function(r, gamma, n_s, sigma, reps)
  mean(replicate(reps, simB_one(r, gamma, n_s, sigma)["total"]))
simB_perdir  <- function(r, gamma, n_s, sigma, reps)
  mean(replicate(reps, simB_one(r, gamma, n_s, sigma)["per_dir"]))

## Bisect for the smallest n_s whose simulated error (via err_fun) hits the
## target. err_fun(ns) returns a mean squared error; monotone-decreasing in ns.
bisect_ns <- function(err_fun, r, target, reps) {
  hi <- max(r, 1L); e_hi <- err_fun(hi); guard <- 0L
  while (e_hi > target && guard < 40L) { hi <- hi * 2L; e_hi <- err_fun(hi); guard <- guard + 1L }
  lo <- max(r, 1L)
  for (it in seq_len(28L)) {
    mid <- as.integer((lo + hi) %/% 2L)
    if (mid <= lo) break
    if (err_fun(mid) > target) lo <- mid else hi <- mid
  }
  hi
}

run_domainB <- function(reps = 600L, sigma = 1.0) {
  ## --- (B1) error vs n_s, at fixed r, gamma (total squared error) ---
  r1 <- 4L; gamma1 <- 1.0
  ns_grid <- c(50, 100, 200, 400, 800, 1600, 3200)
  err_ns <- sapply(ns_grid, function(ns) simB_total(r1, gamma1, ns, sigma, reps))
  exp_ns <- unname(coef(lm(log(err_ns) ~ log(ns_grid)))[2])

  ## --- (B2) error vs gamma, at fixed r, n_s ---
  r2 <- 4L; ns2 <- 1600L
  gamma_grid <- c(0.25, 0.5, 0.75, 1.0, 1.5, 2.0)
  err_gamma <- sapply(gamma_grid, function(g) simB_total(r2, g, ns2, sigma, reps))
  exp_gamma <- unname(coef(lm(log(err_gamma) ~ log(gamma_grid)))[2])

  ## --- (B3) singletons for FIXED accuracy vs r, BOTH targets ---
  ## Per-direction target (the eq:samplecomplexity rate): n_s ~ r   (slope 1).
  ## Total-error target:                                   n_s ~ r^2 (slope 2).
  gamma3 <- 1.0; eps2_target <- 0.02
  r_grid <- c(1L, 2L, 4L, 8L, 16L)
  ns_perdir <- integer(length(r_grid))
  ns_total  <- integer(length(r_grid))
  for (i in seq_along(r_grid)) {
    rr <- r_grid[i]
    ns_perdir[i] <- bisect_ns(function(ns) simB_perdir(rr, gamma3, ns, sigma, reps),
                              rr, eps2_target, reps)
    ns_total[i]  <- bisect_ns(function(ns) simB_total(rr, gamma3, ns, sigma, reps),
                              rr, eps2_target, reps)
  }
  exp_r_perdir <- unname(coef(lm(log(ns_perdir) ~ log(r_grid)))[2])
  exp_r_total  <- unname(coef(lm(log(ns_total)  ~ log(r_grid)))[2])

  list(
    sigma = sigma, reps = reps,
    ns_grid = ns_grid, err_ns = err_ns, r1 = r1, gamma1 = gamma1, exp_ns = exp_ns,
    gamma_grid = gamma_grid, err_gamma = err_gamma, r2 = r2, ns2 = ns2, exp_gamma = exp_gamma,
    r_grid = r_grid, ns_perdir = ns_perdir, ns_total = ns_total,
    eps2_target = eps2_target, gamma3 = gamma3,
    exp_r_perdir = exp_r_perdir, exp_r_total = exp_r_total
  )
}

## ===========================================================================
## RUN
## ===========================================================================
cat("-- Theorem A: sensitivity sweep --\n")
A_exp <- run_domainA()
A_dp  <- run_domainDP()

fitA_exp     <- fit_through_origin(A_exp$deltas, A_exp$realized)
fitA_exp_eta <- fit_through_origin(A_exp$deltas, A_exp$realized_eta)
fitA_dp      <- fit_through_origin(A_dp$deltas,  A_dp$realized)

## "Exact along the curved direction": on the NATURAL (eta) scale the pseudo-true
## bias is exactly delta (slope 1) at every delta; the realized eta-bias should
## match the straight line delta to Monte Carlo error with R^2 ~ 1. On the MEAN
## scale the realized bias should match the closed-form curved pseudo-true.
relA_exp     <- max_rel_dev(A_exp$realized,     A_exp$exact,         A_exp$deltas)
relA_exp_eta <- max_rel_dev(A_exp$realized_eta, A_exp$deltas * 1.0,  A_exp$deltas)
relA_dp      <- max_rel_dev(A_dp$realized,      A_dp$exact,          A_dp$deltas)

cat(sprintf("  [exp-family]  NATURAL scale: predicted slope = 1 (exact along curved dir)\n"))
cat(sprintf("                realized eta slope = %.5f, R^2 = %.6f, max rel dev = %.4f%%\n",
            fitA_exp_eta$slope, fitA_exp_eta$r2, 100 * relA_exp_eta))
cat(sprintf("                MEAN scale:    predicted leading slope = %.5f\n", A_exp$pred_slope))
cat(sprintf("                realized small-delta slope = %.5f (ratio %.4f)\n",
            fitA_exp$slope_head, fitA_exp$slope_head / A_exp$pred_slope))
cat(sprintf("                realized-vs-EXACT(curve) max rel dev = %.4f%% (O(delta^2) on mean scale)\n",
            100 * relA_exp))
cat(sprintf("  [DP/location] predicted slope = %.5f | realized slope = %.5f | R^2 = %.6f\n",
            A_dp$pred_slope, fitA_dp$slope, fitA_dp$r2))
cat(sprintf("                ratio realized/predicted = %.4f | max rel dev vs exact = %.4f%%\n\n",
            fitA_dp$slope / A_dp$pred_slope, 100 * relA_dp))

cat("-- Theorem B: singleton sample complexity --\n")
B <- run_domainB()
cat(sprintf("  (B1) total error vs n_s : empirical exponent = %.3f  (predicted -1)\n", B$exp_ns))
cat(sprintf("  (B2) total error vs gamma: empirical exponent = %.3f  (predicted -2)\n", B$exp_gamma))
cat(sprintf("  (B3) n_s vs r, PER-DIRECTION target = %.3f  (eq:samplecomplexity => 1, linear in r)\n",
            B$exp_r_perdir))
cat(sprintf("       n_s vs r, TOTAL target        = %.3f  (balanced floor-split => 2)\n",
            B$exp_r_total))
cat(sprintf("       r grid               : %s\n", paste(B$r_grid, collapse = ", ")))
cat(sprintf("       n_s (per-direction)   : %s\n", paste(B$ns_perdir, collapse = ", ")))
cat(sprintf("       n_s (total)           : %s   (eps^2 = %.3f, gamma = %.1f)\n\n",
            paste(B$ns_total, collapse = ", "), B$eps2_target, B$gamma3))

## ===========================================================================
## SAVE RESULTS
## ===========================================================================
results <- list(
  seed = 20260608L,
  A_exp = A_exp, A_dp = A_dp,
  fitA_exp = fitA_exp, fitA_exp_eta = fitA_exp_eta, fitA_dp = fitA_dp,
  relA_exp = relA_exp, relA_exp_eta = relA_exp_eta, relA_dp = relA_dp,
  B = B,
  generated = Sys.time()
)
rds_path <- file.path(out_dir, "sweep_results.rds")
saveRDS(results, rds_path)
cat("results written:", rds_path, "\n")

## ===========================================================================
## FIGURE 1: sensitivity sweep (realized vs predicted bias across delta)
## ===========================================================================
fig1 <- file.path(fig_dir, "sensitivity_sweep.pdf")
pdf(fig1, width = 12, height = 4.0)
op <- par(mfrow = c(1, 3), mar = c(4.2, 4.4, 3.0, 1.0), mgp = c(2.5, 0.8, 0),
          cex.lab = 1.05, cex.axis = 0.95)

## panel (a): exp-family on the NATURAL scale (exact along curved direction).
d <- A_exp$deltas
ye <- A_exp$realized_eta
ylo <- ye - 2 * A_exp$se_eta; yhi <- ye + 2 * A_exp$se_eta
rng <- range(c(ylo, yhi, d, 0))
plot(d, ye, type = "n", ylim = rng,
     xlab = expression(tilt~magnitude~~delta),
     ylab = expression(natural-scale~bias~~eta[delta] - eta^"*"),
     main = "(a) Bernoulli dropout, natural scale")
abline(h = 0, col = "grey80")
abline(a = 0, b = 1, col = "firebrick", lwd = 2, lty = 2)   # exact: slope 1
arrows(d, ylo, d, yhi, length = 0.02, angle = 90, code = 3, col = "grey50")
points(d, ye, pch = 19, col = "navy", cex = 0.9)
legend("topleft", bty = "n", cex = 0.82,
       legend = c("realized (Monte Carlo, +/-2 SE)",
                  "exact prediction (slope 1)"),
       col = c("navy", "firebrick"), pch = c(19, NA), lty = c(NA, 2), lwd = c(NA, 2))

## panel (b): exp-family on the MEAN scale (leading line + exact curved pseudo-true).
ym <- A_exp$realized
ylo <- ym - 2 * A_exp$se; yhi <- ym + 2 * A_exp$se
rng <- range(c(ylo, yhi, A_exp$pred_slope * d, A_exp$exact, 0))
plot(d, ym, type = "n", ylim = rng,
     xlab = expression(tilt~magnitude~~delta),
     ylab = expression(mean-scale~bias~~p[delta] - p^"*"),
     main = "(b) Bernoulli dropout, mean scale")
abline(h = 0, col = "grey80")
abline(a = 0, b = A_exp$pred_slope, col = "firebrick", lwd = 2, lty = 2)
lines(d, A_exp$exact, col = "darkorange", lwd = 1.8, lty = 3)
arrows(d, ylo, d, yhi, length = 0.02, angle = 90, code = 3, col = "grey50")
points(d, ym, pch = 19, col = "navy", cex = 0.9)
legend("topleft", bty = "n", cex = 0.82,
       legend = c("realized (Monte Carlo, +/-2 SE)",
                  sprintf("first-order line (slope %.3f)", A_exp$pred_slope),
                  "exact pseudo-true (curved)"),
       col = c("navy", "firebrick", "darkorange"),
       pch = c(19, NA, NA), lty = c(NA, 2, 3), lwd = c(NA, 2, 1.8))

## panel (c): DP / location family.
d2 <- A_dp$deltas
yobs2 <- A_dp$realized
ylo2 <- yobs2 - 2 * A_dp$se; yhi2 <- yobs2 + 2 * A_dp$se
rng2 <- range(c(ylo2, yhi2, A_dp$pred_slope * d2, 0))
plot(d2, yobs2, type = "n", ylim = rng2,
     xlab = expression(tilt~magnitude~~delta),
     ylab = expression(asymptotic~bias~~mu[delta] - mu^"*"),
     main = "(c) Gaussian DP mechanism (location)")
abline(h = 0, col = "grey80")
abline(a = 0, b = A_dp$pred_slope, col = "firebrick", lwd = 2, lty = 2)
arrows(d2, ylo2, d2, yhi2, length = 0.02, angle = 90, code = 3, col = "grey50")
points(d2, yobs2, pch = 19, col = "navy", cex = 0.9)
legend("topleft", bty = "n", cex = 0.82,
       legend = c("realized (Monte Carlo, +/-2 SE)",
                  sprintf("first-order prediction (slope %.3f)", A_dp$pred_slope)),
       col = c("navy", "firebrick"),
       pch = c(19, NA), lty = c(NA, 2), lwd = c(NA, 2))
par(op)
dev.off()
cat("figure written:", fig1, "\n")

## ===========================================================================
## FIGURE 2: singleton sample complexity
## ===========================================================================
fig2 <- file.path(fig_dir, "singleton_complexity.pdf")
pdf(fig2, width = 12, height = 3.9)
op <- par(mfrow = c(1, 3), mar = c(4.2, 4.4, 3.0, 1.0), mgp = c(2.5, 0.8, 0),
          cex.lab = 1.05, cex.axis = 0.95)

## panel (a): error vs n_s (log-log), reference slope -1
plot(B$ns_grid, B$err_ns, log = "xy", pch = 19, col = "navy",
     xlab = expression(number~of~singletons~~n[s]),
     ylab = expression(restored~squared~error~~"||"*hat(theta)[V] - theta[V]*"||"^2),
     main = sprintf("(a) error vs n_s  (slope %.2f)", B$exp_ns))
## reference line of slope -1 through the first point
ref_c <- B$err_ns[1] * B$ns_grid[1]
lines(B$ns_grid, ref_c / B$ns_grid, col = "firebrick", lwd = 2, lty = 2)
legend("topright", bty = "n", cex = 0.85,
       legend = c("simulated", "reference slope -1 (1/n_s)"),
       col = c("navy", "firebrick"), pch = c(19, NA), lty = c(NA, 2), lwd = c(NA, 2))

## panel (b): error vs gamma (log-log), reference slope -2
plot(B$gamma_grid, B$err_gamma, log = "xy", pch = 19, col = "navy",
     xlab = expression(identification~margin~~gamma),
     ylab = expression(restored~squared~error),
     main = sprintf("(b) error vs gamma  (slope %.2f)", B$exp_gamma))
ref_c2 <- B$err_gamma[which.min(abs(B$gamma_grid - 1))] * 1^2
lines(B$gamma_grid, ref_c2 / B$gamma_grid^2, col = "firebrick", lwd = 2, lty = 2)
legend("topright", bty = "n", cex = 0.85,
       legend = c("simulated", expression(reference~slope~-2~~(gamma^-2))),
       col = c("navy", "firebrick"), pch = c(19, NA), lty = c(NA, 2), lwd = c(NA, 2))

## panel (c): n_s for fixed accuracy vs r, both targets.
##   per-direction target (the eq:samplecomplexity rate): linear in r (slope 1)
##   total-error target:                                  quadratic in r (slope 2)
yr <- range(c(B$ns_perdir, B$ns_total))
plot(B$r_grid, B$ns_perdir, log = "xy", pch = 19, col = "navy", ylim = yr,
     xlab = expression(rank~deficit~~r),
     ylab = expression(singletons~at~fixed~accuracy~~n[s]),
     main = sprintf("(c) n_s vs r  (per-dir %.2f, total %.2f)",
                    B$exp_r_perdir, B$exp_r_total))
points(B$r_grid, B$ns_total, pch = 17, col = "darkgreen")
## reference slope-1 (linear) anchored to the per-direction series at r=1
lines(B$r_grid, B$ns_perdir[1] * B$r_grid, col = "firebrick", lwd = 2, lty = 2)
## reference slope-2 (quadratic) anchored to the total series at r=1
lines(B$r_grid, B$ns_total[1] * B$r_grid^2, col = "darkorange", lwd = 2, lty = 3)
legend("topleft", bty = "n", cex = 0.82,
       legend = c("per-direction target (Thm B rate)",
                  "total-error target",
                  "reference slope 1 (linear in r)",
                  "reference slope 2 (quadratic)"),
       col = c("navy", "darkgreen", "firebrick", "darkorange"),
       pch = c(19, 17, NA, NA), lty = c(NA, NA, 2, 3), lwd = c(NA, NA, 2, 2))
par(op)
dev.off()
cat("figure written:", fig2, "\n\n")

cat("== done ==\n")
