# Multi-Agent Review Report

**Date**: 2026-06-08
**Paper**: Identifiability under imperfect coarsening: sensitivity bounds and the singleton
sample complexity that restores them (Pillar 2 of the coarsening-at-random program)
**Recommendation**: minor-revision

> Note: the Task sub-agent tool was unavailable in this environment, so the area chair
> executed all lenses directly (logic/proof, methodology, prose, citations, format/build,
> novelty, literature). Per-lens notes are in this directory.

## Summary

**Overall Assessment**: A strong, honest methods paper whose two central theorems are
correct and whose simulation faithfully reproduces every reported number. All four
previously flagged proof issues (C1, M1, M2, M3) are genuinely fixed in the appendix. The
remaining work is not in the appendix proofs but in keeping the main-text statements in
sync with the corrected appendix: one corollary mislabels the identified set as an
"ellipsoid" (it is a zonotope, the image of an L-infinity ball), and one proof sketch still
describes the old L2/Cauchy-Schwarz characterization that M1 corrected. These are
addressable without new mathematics. No critical issues; the contribution is sound and the
positioning is a model of prior-art honesty.

**Strengths**:
1. Both appendix proofs are correct end to end; the C1/M1/M2/M3 fixes hold (logic-checker).
2. Fully reproducible: `make paper` is clean (0 undefined non-Font refs), `make sim` is
   base-R/fixed-seed/no-external-data, and every validation number reproduces to Monte
   Carlo error; analytic prediction lines are derived from the model, not fitted
   (methodology-auditor).
3. Exemplary honest positioning: the paper subordinates its results to the MNAR-sensitivity,
   measurement-error-double-sampling, and completeness lineages and claims only the
   structured-coarsening reading plus the unified `r/gamma^2` rate (novelty-assessor,
   literature-context).
4. Strong writing and narrative arc; no em-dashes; clean STS/imsart frontmatter and label
   hygiene (prose-auditor, format-validator).

**Weaknesses**:
1. The exact first-order identified set is called an "ellipsoid" but is a zonotope; this
   contradicts the L-infinity structure the M1 fix established (logic-checker,
   prose-auditor).
2. The thm:sensitivity proof sketch still gives the L2/Cauchy-Schwarz characterization the
   appendix replaced with the L-infinity sign extreme point (logic-checker, prose-auditor).
3. A `\mathcal{I}` symbol collision: Fisher information `\Info=\mathcal{I}` vs the
   identified set `\mathcal{I}_\delta`, in the same corollary (prose-auditor).
4. Smaller: `Theta(.)` carrying `sigma^2/eps^2`; main-text exactness missing the "h linear
   in T" qualifier; a garbled sentence inside the restoration proof; the DP unbounded-tilt
   normalization; the Bernoulli example's mapping to def:tilt left implicit; "curved
   directions" never glossed.

**Finding Counts**: Critical: 0 | Major: 3 | Minor: 9 | Suggestions: 5

## Fix verification (the four prior flags)

| Flag | Verdict | Residual |
|---|---|---|
| **C1** leading bias non-vanishing, consistent with def:tilt | **HOLDS** | def:tilt has no mean-zero requirement; `d_delta Psi = Cov(s, hbar)` re-derived from scratch and confirmed genuinely non-zero. Add a tower-property one-liner so `Cov(s,h)=Cov(s,hbar)` is visible in the main text. |
| **M1** worst-case = L-inf sign extreme; C-S a loose envelope; B is the sup | **HOLDS in appendix; BROKEN in the main-text sketch** | sensitivity.tex:55-56 must be rewritten to match appendix.tex:74-78. |
| **M2** exp-family exactness needs h = a^T T, shift delta*a | **HOLDS** | Add the "h linear in T" qualifier to the main-text exactness claims (intro:55, sensitivity:82). |
| **M3** singleton influence-function variance sigma^2/gamma^2 | **HOLDS** | None (also confirmed numerically). |

## Critical Issues

None.

## Major Issues

### M-1. The "identified set" is a zonotope, not an ellipsoid (source: logic-checker; corroborated: prose-auditor, methodology-auditor)
- **Location**: cor:partial, sections/sensitivity.tex:65; echoed in sections/validation.tex:20.
- **Quoted text**: "the identified set for $\theta^\star$ ... is, to first order, the
  ellipsoid" with the set
  `$\mathcal{I}_\delta = \{ \hat\theta - \delta\, \Info^{-1}\Cov(s, h) : \|h\|_\infty \le 1 \} + o(\delta)$`;
  and validation.tex: "if the realized identified set matches the ellipsoid of cor:partial".
- **Problem**: the image of an L-infinity ball (`||h||_inf <= 1`) under a linear map is a
  zonotope (centrally symmetric polytope), not an ellipsoid. An ellipsoid arises from an
  L2 constraint. Worse, the M1 fix exists precisely to establish that the operative
  constraint is L-infinity (worst case at the sign extreme point); calling the resulting
  set an "ellipsoid" reintroduces the L2 thinking M1 corrected. The outer bounding ball of
  radius `delta B` (the abstract/intro/conclusion correctly say "delta-ball") is a valid
  OUTER set, but the EXACT first-order set is a zonotope.
- **Suggestion**: replace "ellipsoid" with "zonotope" (or "centrally symmetric set"), keep
  "with radius `delta B(theta*)`" as the bounding ball. In validation.tex either add a
  set-geometry panel showing the L-infinity-ball image or reduce the claim to what the
  simulation actually checks (the scalar slope).
- **Cross-verified**: yes, by prose-auditor (clarity dimension: word contradicts the
  L-infinity structure) and methodology-auditor (the set geometry is never actually
  simulated, so the term is both wrong and unverified). All three agree.

### M-2. The thm:sensitivity proof sketch contradicts the corrected appendix (M1) (source: logic-checker; corroborated: prose-auditor)
- **Location**: proof sketch, sections/sensitivity.tex:55-56.
- **Quoted text**: "the bound \eqref{eq:Bdelta} is Cauchy--Schwarz over $\|h\|_\infty \le
  1$, attained at $h \propto$ the conditional projection of $s$ onto
  within-candidate-set variation."
- **Problem**: the corrected appendix (appendix.tex:74-78) states the opposite and correct
  thing: "The supremum defining $B$ is attained at the $L^\infty$ extreme point $\bar h =
  \operatorname{sign}$ of the candidate-set-conditional score component; the
  Cauchy--Schwarz step gives the looser closed-form envelope ... which is generically not
  tight." The sketch (a) calls eq:Bdelta itself "Cauchy-Schwarz" (it is the sup, which the
  appendix distinguishes FROM Cauchy-Schwarz), and (b) says the maximizer is the L2
  projection (it is the L-infinity sign extreme point).
- **Suggestion**: rewrite the sketch sentence to: "the bound eq:Bdelta is the supremum of
  `||Cov(s,h)||` over `||h||_inf <= 1`, attained at the sign of the candidate-set-conditional
  score component; Cauchy-Schwarz gives a looser closed-form envelope (deferred to
  app:sensitivity)."
- **Cross-verified**: yes, by prose-auditor (same finding from the readability side: the
  sketch is fluent prose a reader trusts but now states the wrong characterization).

### M-3. Symbol collision: `\mathcal{I}` is both Fisher information and the identified set (source: prose-auditor)
- **Location**: macro main.tex:58 (`\newcommand{\Info}{\mathcal{I}}`) vs cor:partial
  sections/sensitivity.tex:67 (`\mathcal{I}_\delta`).
- **Quoted text**: definition `\newcommand{\Info}{\mathcal{I}}`; corollary
  `\mathcal{I}_\delta \;=\; \Big\{\, \hat\theta - \delta\, \Info^{-1}\Cov(s, h) ...`.
- **Problem**: `\mathcal{I}` denotes the Fisher information matrix (`\Info`, ~10 uses) and,
  with a subscript, the identified set, and both appear in the SAME corollary
  (`\mathcal{I}_\delta = {... \Info^{-1} ...}`). A reader sees `\mathcal{I}` mean two
  things one line apart.
- **Suggestion**: rename the identified set (e.g. `\Theta_\delta`, `\mathcal{S}_\delta`, or
  `\mathcal{B}_\delta`); keep `\Info=\mathcal{I}` for the information.
- **Cross-verified**: not separately routed; it is an unambiguous notation defect, no
  second opinion needed.

## Minor Issues

1. **Tower-property remark missing (C1 readability).** eq:bias writes `Cov(s, h(R,Y))`; the
   appendix proves `Cov(s, hbar)` with `hbar=E[h|R]`. They are equal by the tower property
   (s is R-measurable). Add a one-line note near eq:bias so "the tilt enters only through
   its candidate-set-conditional mean" is visible without the appendix. (logic-checker,
   prose-auditor) `hbar` is currently never mentioned in the main text.
2. **"h linear in T" qualifier missing in main text (M2).** introduction.tex:55 and
   sensitivity.tex:82-85 say "exact along curved directions in a regular exponential
   family" without the `h = a^T T` condition the appendix requires. Add the qualifier or a
   pointer. (logic-checker)
3. **`Theta(.)` retains `sigma^2/eps^2`.** restoration.tex:32 writes
   `n_s = Theta(r sigma^2/(eps^2 gamma^2))` "equivalently" `Theta(r/gamma^2)`; inside
   `Theta` these are equal only if `sigma^2, eps^2` are constants. Either drop them from
   the `Theta` or present the constant-carrying form without the `Theta` wrapper.
   (logic-checker)
4. **Garbled sentence inside a proof.** appendix.tex:119-122: "the per-direction target of
   eq:samplecomplexity is the reading the singleton-budget interpretation, and the
   weak-supervision instance, intend." Missing "that"; mis-spliced appositive. Mirror the
   cleaner restoration.tex:51-53 phrasing. (logic-checker, prose-auditor)
5. **DP tilt is unbounded; `||h||_inf <= 1` is effective-support.** The DP instance uses
   `h(m)=(m-mu)/c` (scripts:176-178; instances.tex:138-154), unbounded in `m`, so the
   def:tilt normalization holds only on the effective support. The code comment admits
   this; the paper does not. Add a clause in the DP subsection (and/or validation.tex)
   noting the normalization is on effective support there. (methodology-auditor,
   prose-auditor)
6. **Bernoulli validation -> def:tilt mapping implicit.** validation.tex:40-41 uses
   `kappa(keep|y)=kappa_0 exp{delta(y-p*)}`, which tilts the keep/coarsen choice; the
   relevant candidate set is `{0,1}` and `h(r,y)=y-p*` is the within-set log-weight whose
   variation (slope delta) is the C2 violation. The example IS a correct def:tilt instance,
   but the mapping is not spelled out. Add one or two sentences. (logic-checker /
   methodology-auditor). Does not threaten the numerical validation.
7. **"curved directions" never glossed.** Used 5 times (first introduction.tex:56), never
   defined as `range(d eta / d theta)`. Add a one-line gloss at first use. (prose-auditor)
8. **Sentence-initial `\cref` should be `\Cref`.** instances.tex:90, 169, 185.
   (prose-auditor, format-validator)
9. **Tidy-up:** `teicher1961maximum` is in refs.bib but uncited (cite it near the
   exp-family/identifiability remark or delete); the `\bias` macro (main.tex:55) is defined
   but unused (use or remove). (citation-verifier, prose-auditor, format-validator)

## Suggestions

1. **Cite Assouad** for the simultaneous r-fold lower bound. The current proof uses r
   independent two-point (Le Cam) arguments with "the budgets add"; the rate is correct
   (orthogonal directions, block-diagonal information), but Biometrika/JASA referees may
   want Assouad's lemma for the rigorous joint statement. (logic-checker, literature)
2. **Soften the "six-domain sweep" phrasing.** introduction.tex:69-70 lists all six
   domains; the harness runs two representative regimes (the exp-family and location-family
   archetypes) and cites the siblings for the rest. State that explicitly.
   (methodology-auditor)
3. **Add a modern partial-identification anchor** (Imbens-Manski or a Tamer review) so the
   "identified set" language has an econometrics reference beyond Manski 1989; the current
   set is missing-data flavored. (citation-verifier, literature)
4. **Confirm the Domke eprint** (arXiv:2001.09771) is the intended moment-matching paper
   and that the attributed claim is faithful; this is the one citation whose content could
   not be verified offline. (citation-verifier, literature)
5. **Optional ISNI citation** in the discussion to tie the `Info^{-1}Cov(s,h)` slope to its
   named antecedent (local sensitivity to nonignorability), since the reliability instance
   already routes through ISNI. (literature)

## Detailed Notes by Domain

### Logic and Proofs
Both theorems correct. C1/M1/M2/M3 fixes all hold in the appendix; each re-derived from
scratch (C1 delta-derivative -> `Cov(s, hbar)`; M1 sup at L-infinity sign extreme with C-S
as loose envelope; M2 natural-parameter shift `delta a` for `h=a^T T`; M3 variance
`sigma^2/gamma^2`). Restoration upper and lower bounds verified (`Theta(r/gamma^2)`
per-direction, `Theta(r^2/gamma^2)` total; Le Cam KL order confirmed). Residuals are sync
problems with the main text (M-1 ellipsoid, M-2 sketch) plus minors 1-4 and the LOW Assouad
point. See logic-checker.md.

### Novelty and Contribution
Four crisp, delivered contributions. Positioning is a model of prior-art honesty (tilt =
Copas-Li/Manski; untestability = Molenberghs; singleton = double sampling; exactness =
Domke; rank deficit = Newey-Powell/Miao), claiming only the structured-coarsening
computability and the unified rate. Good fit for Statistical Science; Biometrika would want
the residual L2-vs-L-infinity and lower-bound rigor tightened. See novelty-assessor.md.

### Methodology
Excellent reproducibility; every validation number reproduces (natural-scale slope 0.99991,
DP 0.66662, B-exponents -1.012/-2.014/1.016/1.982). Predictions are analytic, not fitted.
Honest dual reporting of the per-direction vs total r-exponents. Two domains validated
directly (exp-family, location); the six-domain claim slightly overstates what THIS script
runs. The identified-set geometry is never actually simulated, corroborating M-1. See
methodology-auditor.md.

### Writing and Presentation
Strong arc and prose; no em-dashes; correct author identity. Defects: the `\mathcal{I}`
collision (M-3), the "ellipsoid" word (M-1), the contradicting sketch (M-2), the garbled
proof sentence, sentence-initial `\cref`, the dead `\bias` macro, and the missing
"curved directions" gloss. See prose-auditor.md.

### Citations and References
All 25 cited keys resolve in main.bbl; build clean; bibliography well-formed; siblings use
concept DOIs correctly. `teicher1961maximum` uncited; Domke eprint content unverifiable
offline. See citation-verifier.md.

### Formatting and Production
`make paper` exits 0 with 0 undefined non-Font references; 32 labels all resolve; STS/imsart
frontmatter complete and correct; figures present and matching captions. 9 pages vs an
aspirational 18-page target. Only cosmetic items (sentence-initial `\cref`, dead macro).
See format-validator.md.

## Literature Context Summary
The paper correctly claims three lineages: coarsening at random (Heitjan-Rubin,
Gill-vdL-Robins), MNAR sensitivity/partial identification (Copas-Li, Manski, Molenberghs,
Daniels-Hogan), and measurement-error double sampling/verification bias (Tenenbein,
Begg-Greenes, Carroll). Supporting machinery (misspecified MLE: Huber/White/van der Vaart;
exp-family moment-matching: Domke; completeness/proxy: Newey-Powell/Miao) is appropriately
hedged. Strengthening additions (a modern partial-id anchor, an ISNI cite, Assouad for the
joint lower bound) are optional, not corrections. See literature-context.md.

## Review Metadata
- Lenses executed (directly by the area chair; Task sub-agents unavailable): logic-checker,
  novelty-assessor, methodology-auditor, prose-auditor, citation-verifier, format-validator,
  literature-context.
- Cross-verifications performed: 3 (M-1 ellipsoid routed logic -> prose + methodology, all
  agree; M-2 sketch routed logic -> prose, agree; M2/M3 proof reasoning routed logic ->
  methodology via the simulation, reproduces).
- Disagreements noted: 0.
- Build verified: `make paper` clean (0 undefined non-Font); `make sim` reproduces all
  reported numbers; figures render and match captions.
