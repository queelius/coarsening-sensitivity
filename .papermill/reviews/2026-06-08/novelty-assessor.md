# Novelty and Contribution Assessment

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08

## Contribution clarity -- strong

Four numbered contributions (introduction.tex:45-71), each crisp and each delivered:

1. **Tilt parametrization of C2 violation** (def:tilt). A bounded log-linear tilt of
   magnitude `delta` over each candidate set, recovering C2 at `delta=0`. Clean,
   well-motivated, and the right generalization (the within-set variation is what is
   informative; constant tilts are absorbed).
2. **Sensitivity bound** (thm:sensitivity): `delta`-linear bias with explicit constant
   `Info^{-1} Cov(s, hbar)`, partial identification, exp-family exactness along curved
   directions.
3. **Singleton sample complexity** (thm:restoration): `Theta(r/gamma^2)` singletons.
4. **Six domain instances + cross-domain simulation.**

The two-pillar framing (this is the C2-fails companion to the C2-holds synthesis) is a
genuine and clearly stated structural contribution.

## Honest positioning -- this is a model of prior-art honesty

The paper does NOT overclaim. It repeatedly and correctly situates itself as the
STRUCTURED-coarsening reading of classical ideas, not as inventing sensitivity analysis:

- The tilt is "a sensitivity parameter in the sense of Copas-Li and Manski"
  (framework.tex:56-58).
- Untestability of `delta` is "the equal-fit phenomenon of Molenberghs"
  (discussion.tex:8-11).
- The singleton is "classical internal validation" / measurement-error double sampling /
  verification-bias correction (Tenenbein, Begg-Greenes, Carroll) (introduction.tex:38-41,
  discussion.tex:15-20).
- Exp-family exactness is "Domke's coarsened-data moment-matching read under a tilt"
  (discussion.tex:34-36).
- The rank deficit is "the finite-support completeness gap of Newey-Powell and the
  single-view specialization of the proxy-identification logic of Miao et al."
  (discussion.tex:36-40).

The claimed novelty is precisely what CLAUDE.md's prior-art-honesty note authorizes: the
candidate-set / coarsening-sufficient-statistic structure that turns an abstract
sensitivity parameter into a COMPUTABLE bias direction `Info^{-1} Cov(s,h)` and an explicit
constant `B(theta)`, plus the unified `r/gamma^2` singleton rate across six domains. This
is defensible and well-bounded. No inflation.

## Significance

For a methods venue (Statistical Science / JASA T&M / Biometrika), the significance rests
on the unification + computability claim rather than on a single hard theorem (both
theorems are, by the paper's own admission, structured instances of known machinery). The
audience-fit is good for Statistical Science (which prizes synthesis and perspective) and
plausible for JASA T&M; Biometrika would want the proofs tightened (see logic-checker:
the M1 sketch, the "ellipsoid", and the Assouad point for the lower bound) because
Biometrika referees are exacting on exactly the L2-vs-L-inf and two-point-vs-Assouad
details that currently have residual slips.

## Differentiation from Pillar 1 (the synthesis)

Clear: Pillar 1 = what is recoverable when C2 holds (one consistency identity + rank
condition); Pillar 2 = how recovery degrades when C2 fails (bias bound + partial id) and
how much restores it (singleton complexity). The two are tightly coupled but
non-overlapping. The cross-references are consistent.

## Cross-verification note (is unclear writing hiding a weak contribution?)

I was asked whether any prose-flagged unclarity hides a weak contribution. The opposite:
the contributions are strong and clearly stated; the residual issues are local technical
sync problems (sketch vs appendix, one mislabeled set, one notation collision), not a weak
core. The contribution survives all of them once they are fixed. No novelty concern.

## Minor

- The abstract and conclusion both enumerate the SAME four exemplar domains (reliability
  bands, single-cell spike-in, weak-supervision gold-set, DP mechanism partition) as "one
  theory", while the table and instances cover six. This is fine (the four are the
  headline cases) but a reader counting may notice the asymmetry; consider "across the six
  domains of Table 1, of which four supply named, already-proved bias bounds" or similar.
