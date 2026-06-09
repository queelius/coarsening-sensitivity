# Citation and Reference Verification

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08

## Resolution -- all in-text keys resolve

I cross-checked every `\cite*` key used in `sections/` and `main.tex` against `main.bbl`.

- 25 distinct keys are cited; all 25 appear in main.bbl. No undefined citations
  (`make paper` reports 0 undefined non-Font references; main.blg shows 26 entries used,
  `warning$ -- 0`).
- `vandervaart1998asymptotic` resolves correctly; it is cited only in the appendix via
  optional-argument forms (`\citet[Ch.~5]{...}`, `\citet[Thm~5.9]{...}`,
  `\citep[Ch.~8]{...}`), which is why a naive `\cite{...}` grep can miss it.

## Bibliography integrity -- clean

The 26 main.bbl entries are well-formed (imsart-nameyear). DOIs are present and
plausibly formatted for the journal articles (Heitjan-Rubin, Copas-Li, Manski,
Molenberghs, Tenenbein, Begg-Greenes, Newey-Powell, Miao, White, etc.). Sibling entries
correctly use Zenodo CONCEPT DOIs per the family convention (verified against the keys in
refs.bib and the program's documented DOIs).

## Findings

- **MINOR -- one uncited entry.** `teicher1961maximum` (refs.bib:182-187) is in the .bib
  but never cited (and correctly does NOT appear in main.bbl, since BibTeX only emits
  cited entries). Either cite it (it would be natural support for an identifiability /
  MLE-characterization remark, e.g. near the exp-family exactness or the
  Newey-Powell/completeness discussion) or delete it from refs.bib to keep the source
  tidy. No effect on the build.

- **LOW -- verify the Domke eprint.** `domke2020moment` is `arXiv:2001.09771`
  (refs.bib:160-164), cited as the coarsened-data / hidden-data moment-matching result
  underwriting the exp-family exactness (discussion.tex:34-36). The eprint id format is
  valid (2001 = Jan 2020, matches `year=2020`). I cannot verify the arXiv content offline.
  The author should confirm 2001.09771 is the intended Domke paper on moment-matching for
  exponential families with conditioning or hidden data, and that the claim attributed to
  it ("coarsened-data moment-matching read under a tilt") is faithful. This is the one
  citation whose CONTENT (not just resolution) I could not check.

- **OK -- attribution faithfulness (spot checks).** The classical attributions are used as
  analogies and are correctly hedged, consistent with the prior-art-honesty note:
  - Copas-Li (1997) / Manski (1989) as the sensitivity-parameter / selection lineage:
    standard and correct.
  - Molenberghs et al. (2008) "equal fit" for the untestability of `delta`: this is
    exactly that paper's thesis; correct.
  - Tenenbein (1970), Begg-Greenes (1983) for double sampling / verification bias: correct
    canonical references.
  - Newey-Powell (2003) for completeness, Miao et al. (2018) for proxy identification:
    correctly characterized as the completeness / proxy lineage; the "single-view
    specialization" framing is the paper's own and is appropriately marked as such.

## Suggestion

- If the paper is submitted to Biometrika or JASA, consider adding a primary
  partial-identification reference beyond Manski (e.g. an Imbens-Manski or a
  Tamer review) so the "identified set" language has a modern partial-identification
  anchor; the current set (Copas-Li, Manski, Molenberghs, Daniels-Hogan) is missing-data
  flavored, which fits, but a partial-id reader may want the econometrics anchor. Optional.
