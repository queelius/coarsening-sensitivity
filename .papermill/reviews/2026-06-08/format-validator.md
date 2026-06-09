# Format and Build Validation

**Paper**: Identifiability under imperfect coarsening (Pillar 2)
**Date**: 2026-06-08
**Class**: imsart with `[sts]` option (Statistical Science).

## Build -- clean

- `make paper` (pdflatex; bibtex; pdflatex; pdflatex) exits 0.
- `LC_ALL=C grep -ai undefined main.log | LC_ALL=C grep -aiv Font | wc -l` = **0**.
  (Per the brief and project memory, "Font shape ... undefined" warnings are harmless and
  excluded; none of substance remain.)
- main.blg: 26 entries, `warning$ -- 0`, no bibtex errors.
- Output: 9 pages (state.md page_target is 18; the draft is well under target, which is
  fine for a methods paper but see "page count" below).

## Label hygiene -- clean

Every `\label` has a matching `\cref`/`\ref`/`\eqref` and vice versa (checked all 32
labels). No multiply-defined labels, no orphan labels, no undefined references. cleveref
and the imsart theorem environments (theorem/proposition/lemma/corollary/definition/
condition/remark) are configured correctly; `\crefname`/`\Crefname` set for `condition`.

## STS / imsart compliance -- compliant

- `\documentclass[sts]{imsart}` correct; class files vendored in the repo (self-contained
  build, matching the program convention).
- Frontmatter complete: `\title`, `\runtitle`, `\author` with `\fnms`/`\snm`/`\ead`/
  `\orcid`, `\runauthor`, `\address`, `\begin{abstract}`, `\begin{keyword}` with `\kwd`.
  ORCID 0000-0001-6443-9897 present and correct.
- `\startlocaldefs ... \endlocaldefs` used for theorem environments and macros, as imsart
  requires.
- Bibliography style `imsart-nameyear`, `\bibliographystyle` + `\bibliography` correct.

## Findings

- **MINOR -- sentence-initial `\cref` should be `\Cref`** (format/style): instances.tex:90,
  169, 185 begin sentences with a lowercase `\cref`. STS/cleveref style wants `\Cref` for
  capitalization at sentence start. Cosmetic but a copyeditor will flag it. (Cross-listed
  with prose-auditor.)

- **MINOR -- dead macro `\bias`** (main.tex:55): defined, never used. Harmless; remove for
  tidiness. (Cross-listed.)

- **LOW -- page count vs target.** state.md sets `page_target: 18`; the current build is 9
  pages. The fixes recommended elsewhere (gloss for curved directions, tower-property
  remark, set-geometry clarification, possible Assouad citation, possible set-geometry
  figure panel) will add length but not reach 18. Not a problem for Statistical Science
  (no hard length floor); just note state.md's target is aspirational, not met.

- **OK -- figures.** `figures/sensitivity_sweep.pdf` and `figures/singleton_complexity.pdf`
  are present, included via `\includegraphics[width=\linewidth]{...}`, render correctly,
  and match their captions. `\graphicspath{{figures/}}` set.

## No action needed on

- Hyperref/colorlinks setup (standard), microtype, booktabs table in tab:instances
  (clean `\toprule/\midrule/\bottomrule`), enumitem `[(i)]` contribution list. All fine.
