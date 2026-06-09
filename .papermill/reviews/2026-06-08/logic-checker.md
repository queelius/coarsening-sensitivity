# Logic and Proof Verification

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08
**Scope**: Both appendix proofs (app:sensitivity proves thm:sensitivity; app:restoration
proves thm:restoration), plus the C1/M1/M2/M3 fix re-verification.

## Summary

Both theorems are correct. All four previously flagged issues (C1, M1, M2, M3) are
genuinely fixed in the appendix. The residual problems are not in the appendix proofs
themselves but in the main-text proof *sketches* and a corollary that have not been kept
in sync with the corrected appendix. One of those (the "ellipsoid" mischaracterization)
is a substantive math statement, not just wording.

## Fix re-verification (TOP PRIORITY)

### C1 (leading bias non-vanishing) -- HOLDS

`def:tilt` (framework.tex:35-48) now requires only `sup_{y in c(r)} |h(r,y)| <= 1` and
imposes NO within-set mean-zero constraint. I re-derived the delta-derivative of
`Psi(theta, delta) = E_{p_delta}[s(R;theta)]` from scratch:

- The rewrite `p_delta(r) = gbar(r) w_delta(r) / W_delta` with
  `w_delta(r) = E_{P0}[e^{delta h}|R=r]` is correct (verified the factorization against
  eq:app-tilted).
- `d/ddelta log p_delta(r)|_0 = hbar(r) - E_{P0}[hbar(R)]` with `hbar(r)=E_{P0}[h|R=r]`
  (verified: `w_0=1`, `W_0=1`, derivative of the normalizer gives `E[hbar]`). Matches
  appendix lines 50-52.
- `d/ddelta Psi(theta*,0) = Cov_{P0}(s, hbar)` (verified using `E[s]=0`). Matches
  eq:app-deltapartial.

The bias `Info^{-1} Cov(s, hbar)` is genuinely non-vanishing because the face-value score
`s(r;theta*)` and `hbar(r)` are both functions of `R` alone, and their covariance under
the report marginal has no reason to be zero. The OLD bug (imposing within-set mean zero,
forcing `hbar(r)=0` and collapsing the term to `O(delta^2)`) is gone. The current
statement is internally consistent with `def:tilt`: a purely within-set-mean-zero tilt
correctly gives zero first-order bias; that is a feature, not a bug, and the appendix's
"tilt enters only through hbar" reading (lines 59-61) is exactly right.

**Residual wording note** (MINOR): the theorem statement eq:bias writes
`Cov_{theta*}(s, h(R,Y))` with the full `h`, whereas the appendix proves `Cov(s, hbar)`
and only afterward abbreviates. These are EQUAL by the tower property
(`Cov(s, h) = Cov(s, E[h|R]) = Cov(s, hbar)` since `s` is `R`-measurable), so the theorem
is correct, but a one-line note ("by the tower property `Cov(s,h)=Cov(s,hbar)`, the tilt
enters only through its candidate-set-conditional mean") near eq:bias would make the
crucial point visible without reading the appendix. `hbar` is never mentioned in the main
text.

### M1 (worst-case tilt = L-inf sign extreme; Cauchy-Schwarz is a loose envelope) -- HOLDS in appendix, BROKEN in sketch

Appendix (lines 68-78) is correct:
- `|hbar(r)| <= ||h||_inf <= 1` by Jensen; `Var(hbar) <= 1`; Cauchy-Schwarz gives
  `|Cov(s_j, hbar)| <= sqrt(Var s_j)`.
- The sup `B = ||Info^{-1}|| sup_{||h||_inf<=1} ||Cov(s,h)||` is attained at the L-inf
  extreme point `hbar = sign` of the candidate-set-conditional score component (value
  `E[|score component|]`, an L1 functional), and Cauchy-Schwarz gives only the looser
  closed-form envelope, "generically not tight." I verified the achievable set of `hbar`
  is `{|hbar(r)| <= 1}` via genuine (within-set-varying) tilts when `|c(r)| >= 2`, so the
  sign extreme point is feasible and is the maximizer. Correct.

**RESIDUAL M1 ISSUE (MAJOR)**: the proof SKETCH in sensitivity.tex (lines 55-56) still
says "the bound eq:Bdelta is Cauchy-Schwarz over `||h||_inf <= 1`, attained at
`h propto` the conditional projection of `s` onto within-candidate-set variation." This
directly contradicts the corrected appendix: (a) eq:Bdelta is the SUP, which the appendix
explicitly distinguishes from the looser Cauchy-Schwarz envelope; (b) "the conditional
projection of `s`" is the L2 projection, but the sup is attained at the L-INF SIGN extreme
point. The sketch must be rewritten to match the appendix (sup attained at the sign of the
score component; Cauchy-Schwarz only a loose envelope).

### M2 (exp-family exactness requires h linear in T; natural-parameter shift delta*a) -- HOLDS

Appendix (lines 80-89) correctly conditions exactness on `h = a^T T`. I verified: for a
regular exponential family `p(r|theta) prop exp{eta(theta)^T T - A(eta)}`, the tilt
`e^{delta a^T T}` shifts the natural parameter to `eta(theta) + delta a` exactly, and the
pseudo-true `theta_delta` satisfies the exact mean-matching
`m(theta_delta) = E_{p_delta}[T]` along `range(d eta / d theta)`. The "no `O(delta^2)`"
statement is about the natural parameter, where the shift is `delta a` exactly. The
restriction `h = a^T T` is NECESSARY (a general bounded `h` does not preserve the
exponential family). This matches the simulation domain (i), where `h(y) = y - p0` is
affine in the Bernoulli natural statistic and the eta-scale slope is exactly 1.

**Residual note** (MINOR): the MAIN-TEXT exactness claims (introduction.tex:55,
sensitivity.tex:82-85) say "exact along curved directions in a regular exponential family"
WITHOUT the "tilt linear in `T`" qualifier. Add the qualifier or a pointer so the main
text does not state the claim more broadly than the appendix proves.

### M3 (singleton influence-function variance = sigma^2/gamma^2) -- HOLDS

Appendix (lines 98-103) is correct: per-singleton Fisher information `gamma^2/sigma^2`,
influence-function variance `sigma^2/gamma^2` (the reciprocal). I verified against the
concrete linear-Gaussian realization in the simulation (`x = theta_j gamma + N(0,sigma^2)`,
score `gamma(x - theta_j gamma)/sigma^2`, info `gamma^2/sigma^2`, MLE variance
`sigma^2/(gamma^2 n_j)`). The `i_v >= gamma^2/sigma^2` inequality (margin = smallest
signal) makes `sigma^2/gamma^2` the worst-case per-singleton variance, the correct
direction for an upper bound on sample complexity.

## Restoration proof (app:restoration) -- correct, one garble

- Upper bound: balanced allocation `m_k = n_s/r` gives per-direction variance
  `r sigma^2/(gamma^2 n_s)`; per-direction target `eps^2` gives `n_s = Theta(r/gamma^2)`
  (linear in r); total target gives `Theta(r^2/gamma^2)` (quadratic). Verified.
- Balanced-allocation optimality (minimize max, and minimize sum by AM-HM): verified.
- Lower bound (Le Cam two-point along `v^star`): KL per singleton
  `= (2 eps gamma)^2/(2 sigma^2) = Theta((gamma^2/sigma^2) eps^2)`, giving
  `m_{v^star} = Omega(sigma^2/(gamma^2 eps^2))` and `n_s = Omega(r/gamma^2)`. Verified;
  matches the upper bound, so `Theta(r/gamma^2)`.

**Residual issues**:
- (MINOR) Garbled sentence, appendix.tex:119-122: "the per-direction target of
  eq:samplecomplexity is the reading the singleton-budget interpretation, and the
  weak-supervision instance, intend." Ungrammatical (missing "that"; mis-spliced
  appositive). Rewrite. This sits inside a proof.
- (LOW) The simultaneous r-fold lower bound is argued as r independent two-point
  arguments with "the budgets add." The rate is correct (orthogonal directions,
  block-diagonal information), but a Statistical Science / Biometrika referee may want
  Assouad's lemma cited for the rigorous joint statement.

## Other logic findings

- **MAJOR -- "ellipsoid" is the wrong set.** cor:partial (sensitivity.tex:65) and
  validation.tex:20 call the identified set "the ellipsoid", but it is defined as
  `{theta_hat - delta Info^{-1} Cov(s,h) : ||h||_inf <= 1} + o(delta)`, the image of an
  L-inf ball under a linear map. That is a ZONOTOPE (centrally symmetric polytope), not an
  ellipsoid; an ellipsoid would require an L2 constraint `||h||_2 <= 1`. This is the same
  L2-vs-L-inf slip as the M1 sketch and partly undoes the M1 fix conceptually. The outer
  bounding ball of radius `delta B` (abstract/intro/conclusion say "delta-ball", which is
  fine) is a correct *outer* set, but the *exact* first-order identified set is a
  zonotope. Fix: call it the zonotope (or "centrally symmetric set"), and keep the outer
  `delta B` ball as the bounding radius.

- **MINOR -- Theta with retained parameters.** eq:samplecomplexity (restoration.tex:32)
  writes `n_s = Theta(r sigma^2/(eps^2 gamma^2))` and "equivalently" `Theta(r/gamma^2)`.
  Inside `Theta`, the two are equal only if `sigma^2, eps^2` are constants; presenting
  both as `Theta(.)` while one carries `sigma^2/eps^2` is loose. Either drop `sigma^2,
  eps^2` from the `Theta` (state "at fixed accuracy and noise level,
  `n_s = Theta(r/gamma^2)`; explicitly `n_s = r sigma^2/(eps^2 gamma^2)`") or keep the
  full expression without the `Theta` wrapper on the form that retains the constants.
