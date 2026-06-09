# Methodology and Reproducibility Audit

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08

## Reproducibility -- excellent

`make paper` builds clean (exit 0; 0 undefined non-Font references via
`LC_ALL=C grep -ai undefined main.log | grep -aiv Font`). `make sim` runs base-R only,
fixed seed `20260608`, no external data, and regenerates both figures plus
`scripts/sweep_results.rds`. I ran the harness and every number quoted in validation.tex
reproduces:

| Claim in validation.tex | Reproduced |
|---|---|
| natural-scale slope 0.9999, R^2 1.000 | 0.99991, 0.999997 |
| mean-scale tracks curve within 1.2% | 1.15% (max rel dev), small-delta slope 0.237 vs 0.227 |
| DP slope 0.667, R^2 1.000, ratio 1.000 | 0.66662, 0.999998, 0.9999 |
| B1 error vs n_s exponent -1.01 | -1.012 |
| B2 error vs gamma exponent -2.01 | -2.014 |
| B3 per-direction r-exponent 1.02 | 1.016 |
| B3 total r-exponent 1.98 | 1.982 |

The figures render correctly and match the captions (panel (a) slope 1 natural scale,
(b) first-order line 0.227 with curved pseudo-true peeling off, (c) DP slope 0.667).

## Statistical design -- sound

- The analytic prediction lines are computed from each model's own score and tilt
  (`Info^{-1} Cov(s,h)`), not fitted to the realized bias, so a match is a genuine
  confirmation rather than a curve fit (validation.tex:11-13 states this and the code
  honors it: `expA_pred_slope`, `dp_pred_slope` derive the slope analytically).
- The "exact along the curved direction" check is done on the natural (eta) scale where
  the pseudo-true bias is exactly `delta` (slope 1); the mean-scale O(delta^2) curvature
  is shown separately. This cleanly separates the exactness claim (M2) from the generic
  first-order claim. Good methodology.
- The Theorem B harness honestly measures BOTH r-exponents (per-direction linear,
  total-error quadratic) and lets the prose state which target each corresponds to,
  rather than fudging a single number (scripts lines 269-288). This is the right way to
  handle the fork in the rate.
- Monte Carlo error is reported (+/-2 SE bars in figures; SE columns in the harness).

## Cross-check of the methodology against the proofs (cross-verification of logic findings)

I was asked to confirm whether the logic-checker's proof reasoning is reproducible.

- **M3 / restoration upper bound**: the simulated linear-Gaussian singleton model
  (`x = theta_j gamma + N(0,sigma^2)`) realizes exactly the per-singleton information
  `gamma^2/sigma^2` and estimator variance `sigma^2/(gamma^2 n_j)` the proof uses. The
  empirical exponents (-1 in n_s, -2 in gamma, +1/+2 in r) are exactly the proof's
  predictions. The proof reasoning reproduces. CONFIRMED.

- **M2 / exp-family exactness**: domain (i) uses `h(y) = y - p0`, affine in the Bernoulli
  natural statistic, and the eta-scale slope is exactly 1 with R^2 = 1.0, which is the
  natural-parameter-shift-by-`delta a` mechanism the appendix proves. The proof reasoning
  reproduces. CONFIRMED.

- **"ellipsoid" finding (from logic-checker)**: methodologically, the validation only ever
  checks SCALAR slopes and exponents; it never actually plots or measures the 2D+
  identified SET, so the "ellipsoid vs zonotope" mischaracterization is not exercised by
  the simulation. validation.tex:20 says "if the realized identified set matches the
  ellipsoid of cor:partial" but no figure shows a set. This is consistent with the
  logic-checker's MAJOR finding: the word "ellipsoid" is wrong AND unverified. Either add
  a set-geometry panel (a zonotope from the L-inf ball image) or drop the "realized
  identified set matches the ellipsoid" sentence to what is actually checked (the slope).

## Gaps / suggestions

- **Validation covers 2 of 6 domains directly** (Bernoulli exp-family + Gaussian DP). The
  other four domains (reliability, spatial, weaksup, phenotype) are claimed to reduce to
  the same two regimes and are validated in their own sibling papers, but this paper's
  abstract/intro says the sweep covers "reliability, single-cell and spatial genomics,
  differential privacy, weak supervision, and phenotyping" (introduction.tex:69-70). The
  harness instantiates "two representative regimes" (validation.tex:36-37). The claim is
  defensible (the two regimes are the exp-family and location-family archetypes, and the
  remark cites the siblings' own reproductions) but slightly overstates what THIS script
  runs. Soften to "two representative regimes spanning the exponential-family and
  location-family archetypes; the per-domain reductions are validated in the siblings."

- The DP tilt `h(m) = (m-mu)/c` (scripts:176-178) is unbounded in `m`, so the
  `||h||_inf <= 1` normalization of def:tilt holds only on the effective support. The code
  comment acknowledges "(scaled to |h|<=1 over the effective support)" but the paper does
  not. See prose-auditor / the DP minor.

- No seed-sensitivity or grid-sensitivity sweep is reported. Not required for a methods
  paper whose predictions are analytic, but a one-line "results are insensitive to seed
  and grid" would preempt a referee question. Optional.
