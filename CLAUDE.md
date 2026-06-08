# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Project Overview

Academic paper repository: **Identifiability under imperfect coarsening:
sensitivity bounds and the singleton sample complexity that restores them.**

This is "Pillar 2" of the coarsening-at-random program: the C2-violation companion
to `coarsening-synthesis` (Pillar 1, the C2-holds unification). Where the synthesis
says what is recoverable when coarsening is ignorable, this paper says how recovery
degrades when C2 fails and how much external information (singletons) restores it.
It is a methods paper with new results (not a synthesis), targeting Statistical
Science / JASA / Biometrika. Drafted 2026-06-08 from the strategy memo in
`../../.ecosystem/research-directions-2026-06-08.md`.

## Build Commands

```bash
make paper      # builds main.pdf
make sim        # runs scripts/sensitivity_sweep.R (the cross-domain delta-sweep)
make figures    # regenerates validation figures
make clean
```

Verify a build with `LC_ALL=C grep -ai undefined main.log | grep -aiv Font | wc -l`
(expect 0); plain `grep -c` can silently fail on the imsart log's non-UTF-8 bytes.

## Architecture

- `main.tex`: imsart (sts) preamble copied from `coarsening-synthesis` so notation
  matches across the two pillars; macros `\E \Prob \R \T \bias \Cov \Info`.
- `sections/`: introduction, framework, sensitivity, restoration, instances,
  validation, discussion, conclusion (no `\end{document}` in section files).
- `refs.bib`: sibling concept DOIs + the lineage.
- `scripts/`: base-R cross-domain delta-sweep harness.

## The two theorems (where they live)

- **Theorem A, graceful degradation** (`thm:sensitivity`, `sensitivity.tex`): the
  face-value MLE bias is `delta * Info^{-1} Cov(score, tilt) + O(delta^2)`; bound
  `B(delta)`; partial identification (`cor:partial`). Exact along curved directions
  in a regular exponential family.
- **Theorem B, singleton sample complexity** (`thm:restoration`,
  `restoration.tex`): `n_s = Theta(r / gamma^2)` singletons restore the `r`
  confounded directions; unifies weaksup's gold-set rate and scrna's spike-in bias.
- The `delta`-tilt of C2 is `def:tilt` in `framework.tex`; the six-domain instance
  table is `tab:instances` in `instances.tex`.

## Conventions (Alex's preferences)

- **No em-dashes** (soul plugin hook enforces; U+2014 blocks any file write). No
  LaTeX `---`; `--` only for numeric ranges.
- **No vanity counts** as achievement filler.
- LaTeX, not Quarto/RMarkdown.
- Cite siblings by Zenodo concept DOI (see `refs.bib`).
- Author: Alexander Towell, lex@metafunctor.com, SIUE Department of Computer
  Science, ORCID 0000-0001-6443-9897.

## Prior-art honesty (important)

This paper's novelty is the STRUCTURED-coarsening reading, not the sensitivity idea
itself, which is classical. The tilt is a Copas-Li / Manski sensitivity parameter;
the untestability of `delta` is the Molenberghs equal-fit phenomenon; the singleton
is measurement-error double sampling / verification-bias internal validation
(Tenenbein, Begg-Greenes); the exponential-family exactness is Domke's hidden-data
moment-matching under a tilt; the rank deficit is finite-support completeness
(Newey-Powell) and the single-view specialization of proxy identification (Miao et
al.). Cite and distinguish these; claim the candidate-set/coarsening-sufficient
structure that turns an abstract sensitivity parameter into a computable bias
direction and an explicit constant, and the unified `r/gamma^2` singleton rate
across six domains.

## Companion repositories

- `coarsening-synthesis` (Pillar 1; cited as `towell2026synthesis`).
- `mdrelax` (reliability instance + `ri_first_order` software; `towell2026mdrelax`).
- The five application papers supply the per-domain DGPs the harness reuses.
