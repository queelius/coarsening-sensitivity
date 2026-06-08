# coarsening-sensitivity

Paper: **Identifiability under imperfect coarsening: sensitivity bounds and the
singleton sample complexity that restores them.**

Author: Alexander Towell (lex@metafunctor.com), Department of Computer Science,
Southern Illinois University Edwardsville.

## Status

**Scaffold v0.1 (drafted 2026-06-08).** This is "Pillar 2" of the
coarsening-at-random program: the C2-violation companion to
`coarsening-synthesis` (Pillar 1, which handles the C2-holds case). All eight
sections have substantive content; the two main theorems are stated with proof
sketches; the cross-domain validation harness is being built. Build verified clean
(`make paper`, zero undefined references).

## Thesis

Coarsening at random (C1, C2, C3) makes a latent parameter identifiable and the
face-value MLE consistent, but the symmetry condition C2 is the exception, not the
rule: real coarsening is informative. This paper prices the rule.

1. **Sensitivity bound** (`thm:sensitivity`): parametrize the C2 violation by a
   tilt of magnitude `delta`; the face-value MLE's asymptotic bias is, to leading
   order, linear in `delta` with an explicit constant (inverse face-value
   information times the score-tilt covariance). The latent parameter is partially
   identified over a `delta`-ball that contracts to a point as C2 is approached.
2. **Singleton sample complexity** (`thm:restoration`): a singleton (a report that
   pins the latent value, hence classical internal validation) restores point
   identification, and the number needed to recover the `r` confounded directions
   is of order `r / gamma^2`, where `gamma` is the domain's identification margin.

Together these unify the reliability sensitivity bands (`mdrelax`), the single-cell
spike-in bias, the weak-supervision gold-set sample complexity, and the
differential-privacy mechanism partition, and place the program in the lineage of
MNAR sensitivity analysis (Copas-Li, Manski, Molenberghs), measurement-error
double sampling, and verification-bias correction.

## Build

```bash
make paper      # builds main.pdf (pdflatex; bibtex; pdflatex; pdflatex)
make sim        # runs the cross-domain delta-sweep harness, writes results .rds
make figures    # regenerates validation figures from the sweep
make clean
```

Requires LaTeX with `natbib`, `cleveref`, `bm` (imsart class files vendored in the
repo), and R (base only) for the harness.

## Structure

- `main.tex`: imsart preamble (shared with `coarsening-synthesis`) + frontmatter +
  section inputs.
- `sections/`: introduction, framework (the `delta`-tilt of C2), sensitivity
  (Theorem A), restoration (Theorem B), instances (the six-domain table),
  validation, discussion, conclusion.
- `refs.bib`: sibling concept DOIs + the MNAR-sensitivity / measurement-error /
  completeness lineage.
- `scripts/`: the cross-domain `delta`-sweep harness (in progress).

## Companion papers

- `coarsening-synthesis` (Pillar 1; the C2-holds unification this paper completes).
- `mdrelax` (the reliability instance and the `ri_first_order` software).
- The five application papers supply the per-domain DGPs the harness reuses.

## Conventions

- No em-dash characters (soul plugin hook enforces).
- LaTeX, not Quarto/RMarkdown.
- Cite siblings by Zenodo concept DOI.

## Target venue

Statistical Science, JASA Theory and Methods, or Biometrika (a
sensitivity-and-identification methods paper).
