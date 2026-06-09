# Literature Context

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08
**Note**: The Task sub-agent tool was unavailable in this environment, so the literature
grounding was performed directly by the area chair from the manuscript's own bibliography,
the program CLAUDE.md, and domain knowledge, rather than by the broad/targeted scout
agents. Treat this as a focused positioning check, not an exhaustive field survey.

## Where this paper sits

The paper deliberately claims a place in three established lineages, and the positioning is
accurate:

1. **Coarsening at random** (Heitjan-Rubin 1991; Gill-van der Laan-Robins 1997;
   Little-Rubin 2002; Grunwald-Halpern 2003; Jaeger 2005). The C1/C2/C3 conditions and the
   untestability/informativeness of the symmetry condition C2 are the direct backdrop. The
   paper's contribution is to relax C2 (not to restate CAR), which is the natural and
   underexplored move in this lineage.

2. **MNAR sensitivity analysis / partial identification** (Copas-Li 1997; Manski 1989;
   Molenberghs et al. 2008; Daniels-Hogan 2008). The `delta`-tilt is a Copas-Li/Manski
   sensitivity parameter; the identified set is a Manski bound; the untestability is the
   Molenberghs equal-fit phenomenon. This is exactly the right home and the paper says so.
   A modern partial-identification anchor (Imbens-Manski; Tamer's review) would strengthen
   the econometrics side; currently the set is missing-data flavored (see
   citation-verifier suggestion).

3. **Measurement error / double sampling / verification bias** (Tenenbein 1970;
   Begg-Greenes 1983; Carroll et al. 2006). The singleton = internal-validation
   observation, and thm:restoration is its sample-complexity accounting. Correct and
   well-cited. The Rogan-Gladen connection (instances.tex phenotype) is the standard
   double-sampling correction and is correctly named.

## Adjacent machinery the paper leans on

- **Misspecified-MLE asymptotics** (Huber 1967; White 1982; van der Vaart 1998): the
  pseudo-true `theta_delta` and the implicit-function/Bartlett argument are textbook
  M-estimation; correctly attributed.
- **Exponential-family moment-matching under hidden data** (Domke 2020,
  arXiv:2001.09771): underwrites the exactness-along-curved-directions claim. This is the
  one citation whose content could not be verified offline (see citation-verifier, LOW).
- **Completeness / proxy identification** (Newey-Powell 2003; Miao et al. 2018): the rank
  deficit `r` is framed as a finite-support completeness gap and a single-view
  specialization of proxy identification. The "single-view" framing is the paper's own and
  is appropriately hedged.

## Competing/alternative approaches a referee may raise

- **Pattern-mixture vs selection-model** factorizations of MNAR: the tilt is a
  selection-model device. A referee may ask for a sentence relating the candidate-set tilt
  to a pattern-mixture reading. Optional but cheap.
- **ISNI / local sensitivity to nonignorability** (Troxel-Ma-Heitjan; Xie-Heitjan): the
  reliability instance already routes through an ISNI-style index
  (instances.tex:84-89 names "ISNI" and `ri_first_order`), so this literature is engaged
  via the sibling; a direct ISNI citation in the discussion would tie the
  `Info^{-1}Cov(s,h)` slope to its named antecedent. Optional.
- **Assouad's lemma** for the simultaneous r-fold lower bound: not a competing approach but
  the standard tool; the lower bound currently uses r independent two-point arguments (see
  logic-checker, LOW).

## Bottom line

The literature positioning is honest and accurate. The paper does not overclaim; it
explicitly subordinates its theorems to known machinery and claims only the
structured-coarsening reading and the unified rate. The few additions above
(partial-id anchor, ISNI cite, Assouad) are strengthening moves, not corrections.
