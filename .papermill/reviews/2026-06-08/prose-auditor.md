# Prose, Narrative, and Notation Audit

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08

## Overall

The writing is strong: confident, well-organized, and rhetorically effective ("Coarsening
at random is the exception; informative coarsening is the rule. This paper prices the
rule." is a clean thesis line). Section arc is logical: setup -> tilt -> bias bound ->
restoration -> instances -> validation -> discussion. The two question-titled sections
("How wrong is the face-value fit?", "How much restores identification?") are good
signposting. No em-dashes (U+2014) anywhere; no LaTeX `---`. Author identity correct.

The issues below are local. The two that matter (notation collision, garbled proof
sentence) are listed first.

## Notation

- **MAJOR -- symbol collision.** `\Info` is defined as `\mathcal{I}` (Fisher information,
  main.tex:58), used ~10 times. But cor:partial (sensitivity.tex:67) names the identified
  SET `\mathcal{I}_\delta`. So `\mathcal{I}` means both the information matrix and (with a
  subscript) the identified set, and the two appear in the SAME corollary:
  `\mathcal{I}_\delta = {\hat\theta - \delta \Info^{-1}...}`. Rename the identified set
  (e.g. `\Theta_\delta`, `\mathcal{S}_\delta`, or `\mathcal{B}_\delta`). The keyword
  `\Info` is also the macro, so the set name is the one to change.

- **MINOR -- `hbar` invisible in main text.** The bias's true argument is
  `hbar(r) = E[h|R=r]` (appendix), but the main text only ever writes `Cov(s, h)`. Since
  they are equal by the tower property, the theorem is correct, but introducing `hbar`
  (or a one-line tower-property remark) in the main text would make the "tilt enters only
  through its candidate-set-conditional mean" point legible without the appendix. See
  logic-checker C1.

- **MINOR -- "curved directions" never glossed.** Used 5 times (first at
  introduction.tex:56), but never defined in one line near first use. A reader does not
  know these are `range(d eta / d theta)`, the directions along which the exp-family tilt
  acts as a pure natural-parameter shift. Add a one-line gloss at or before first use
  (e.g. "the curved directions, the range of `d eta / d theta` along which the tilt is a
  natural-parameter shift").

## Grammar / wording

- **MINOR (in a proof) -- garbled sentence.** appendix.tex:119-122: "the per-direction
  target of eq:samplecomplexity is the reading the singleton-budget interpretation, and
  the weak-supervision instance, intend." Missing "that"; the mid-sentence appositive is
  mis-spliced. Rewrite, e.g.: "the per-direction target of eq:samplecomplexity is the
  reading that the singleton-budget interpretation (and the weak-supervision instance)
  intend." restoration.tex:51-53 has a cleaner version of the same sentence; mirror it.

- **MINOR -- sentence-initial `\cref` should be `\Cref`.** Genuine sentence-initial cases:
  instances.tex:90 ("...solved for delta. For \cref{thm:restoration} the rank deficit..."),
  instances.tex:169 ("...confounded direction. On the \cref{thm:sensitivity} side..."),
  instances.tex:185 ("...score-tilt covariance. For \cref{thm:restoration} the confounded
  direction..."). Use `\Cref` for capitalization. (Other `\cref` occurrences are
  mid-sentence and correct.)

- **MINOR -- dead macro.** `\bias` (main.tex:55) is defined but never used. Remove, or use
  it (e.g. write `\bias(\hat\theta)` in eq:bias).

## Clarity findings tied to the math (cross-listed with logic-checker)

- **MAJOR -- "ellipsoid".** cor:partial (sensitivity.tex:65) and validation.tex:20 call the
  identified set "the ellipsoid". The set is the image of an L-inf ball under a linear map,
  a zonotope, not an ellipsoid. This is a clarity AND correctness issue: the prose word
  contradicts the L-inf structure the M1 fix established. Replace "ellipsoid" with
  "zonotope" / "centrally symmetric set", keeping the `delta B` outer ball as the radius.
  (The abstract/intro/conclusion correctly say "delta-ball" for the OUTER set; only
  cor:partial and validation say "ellipsoid" for the EXACT set.)

- **MAJOR (sketch vs appendix) -- the Cauchy-Schwarz sentence.** sensitivity.tex:55-56
  describes eq:Bdelta as Cauchy-Schwarz attained at the L2 projection; the corrected
  appendix says the sup is attained at the L-inf sign extreme point with Cauchy-Schwarz as
  a looser envelope. The sketch reads as a fluent paragraph but now states the wrong
  characterization. Rewrite to match the appendix. (Primarily a logic issue; flagged here
  because the sketch is prose a reader trusts.)

## Positioning prose -- well done

The two-lineage discussion (MNAR sensitivity / measurement-error double sampling) is clear,
correctly hedged, and gives the paper an honest home. No overclaiming. The "Why C2
deserved this" paragraph (discussion.tex:22-28) is a strong rhetorical answer to the
obvious referee objection.

## Small suggestions (optional)

- introduction.tex:9-10: the five one-clause vignettes ("A failed component is reported as
  a set of suspects; ...") are excellent; consider echoing the SAME five in the same order
  in tab:instances row order for a mnemonic through-line (currently the table order is
  reliability, scRNA, spatial, DP, weaksup, phenotype; the vignette order is reliability,
  dropout, DP, weaksup, phenotype, i.e. spatial is omitted from the vignettes). Minor.
- "the discrete tilt is the relaxed candidate-set weight" (framework.tex:63) is terse;
  one more clause would help the reliability reader.
