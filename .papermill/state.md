---
paper_id: coarsening-sensitivity
title: "Identifiability under imperfect coarsening: sensitivity bounds and the singleton sample complexity that restores them"
short_title: "Imperfect coarsening"
authors:
  - name: "Alexander Towell"
    email: "lex@metafunctor.com"
    orcid: "0000-0001-6443-9897"
    affiliation: "Department of Computer Science, Southern Illinois University Edwardsville"
paper_type: theory-methods
stage: scaffold-v0.1
created: 2026-06-08
last_updated: 2026-06-08

structure:
  format: LaTeX-imsart-sts
  main_file: main.tex
  bib_file: refs.bib
  sections_dir: sections/
  sections:
    - introduction.tex
    - framework.tex
    - sensitivity.tex
    - restoration.tex
    - instances.tex
    - validation.tex
    - discussion.tex
    - conclusion.tex
  page_target: 18

build:
  paper_cmd: make paper
  sim_cmd: make sim
  base_dependencies: [pdflatex, bibtex, Rscript]
  note: "Pillar 2 of the coarsening program. Has a cross-domain delta-sweep harness (scripts/) reusing the sibling DGPs."

# ============================================================================
# THESIS (papermill:thesis)
# ============================================================================
thesis: >
  Coarsening at random is the exception; informative coarsening is the rule. When
  the symmetry condition C2 fails by a tilt of magnitude delta, the face-value MLE
  is biased linearly in delta along a direction the marginal-fit check cannot see,
  so the latent parameter is partially identified over a delta-ball; a singleton
  (classical internal validation) restores point identification, and the number
  needed to recover the r confounded directions is of order r/gamma^2 in the domain
  margin gamma. This is the C2-violation companion to coarsening-synthesis.

novelty: >
  The structured-coarsening reading of a classical idea. The tilt is a
  Copas-Li/Manski sensitivity parameter; untestability of delta is the Molenberghs
  equal-fit phenomenon; the singleton is measurement-error double sampling /
  verification-bias internal validation; the exponential-family exactness is
  Domke's hidden-data moment-matching under a tilt; the rank deficit is
  finite-support completeness (Newey-Powell) and the single-view specialization of
  proxy identification (Miao et al.). Claimed: the candidate-set structure that
  makes the bias direction computable and the constant explicit, and the unified
  r/gamma^2 singleton rate across six domains.

contributions:
  - "Theorem A (thm:sensitivity): delta-linear bias bound B(delta) + partial identification (cor:partial)."
  - "Theorem B (thm:restoration): singleton sample complexity Theta(r/gamma^2)."
  - "def:tilt: a tilt parametrization of C2 violation (recovers mdrelax as the reliability instance)."
  - "Six domain instances (tab:instances) and a cross-domain delta-sweep validation."

venue:
  primary: "Statistical Science"
  shortlist: ["Statistical Science", "JASA Theory and Methods", "Biometrika", "JRSS-B"]

# ============================================================================
# REVIEW HISTORY (papermill:review)
# ============================================================================
review_history:
  - date: 2026-06-08
    reviewer: papermill multi-agent (area chair direct; Task sub-agents unavailable)
    recommendation: minor-revision
    dir: .papermill/reviews/2026-06-08/
    verdict: >
      Both theorems correct; build clean; simulation reproduces every reported number.
      The four prior proof flags (C1, M1, M2, M3) all HOLD as fixed in the appendix.
      Residual work is main-text sync with the corrected appendix, not new mathematics.
    fix_status: {C1: holds, M1: holds-in-appendix, M2: holds, M3: holds}
    counts: {critical: 0, major: 3, minor: 9, suggestions: 5}
    major_findings:
      - "cor:partial + validation call the identified set an 'ellipsoid'; it is a zonotope (image of an L-infinity ball). sensitivity.tex:65, validation.tex:20."
      - "thm:sensitivity proof sketch (sensitivity.tex:55-56) still states the L2/Cauchy-Schwarz characterization that the M1 appendix fix replaced with the L-infinity sign extreme point."
      - 'Notation collision: \Info=\mathcal{I} (Fisher information) vs \mathcal{I}_delta (identified set) in the same corollary.'
    top_minor:
      - "Add tower-property note so Cov(s,h)=Cov(s,hbar) is visible in the main text (hbar appears only in the appendix)."
      - "Add the 'h linear in T' qualifier to the main-text exp-family exactness claims (intro:55, sensitivity:82)."
      - "eq:samplecomplexity Theta(.) retains sigma^2/eps^2; drop them from Theta or unwrap the constant-carrying form."
      - "Fix the garbled sentence inside app:restoration (appendix.tex:119-122)."

# ============================================================================
# LOG
# ============================================================================
# 2026-06-08: Scaffolded from the research-directions memo. Eight sections drafted;
#   Theorems A and B stated with proof sketches; refs seeded with the sibling
#   concept DOIs and the MNAR/measurement-error/completeness lineage. Build clean
#   (6 pages at scaffold). Cross-domain delta-sweep harness in progress.
# 2026-06-08: Multi-agent pre-submission review (reviews/2026-06-08/). Verdict
#   minor-revision. Re-verified the C1/M1/M2/M3 appendix fixes (all hold).
#   Build clean (0 undefined non-Font); make sim reproduces all reported
#   numbers; figures render. 3 major (ellipsoid->zonotope; sketch vs appendix
#   on M1; I/I_delta notation clash) + 9 minor. Now 9 pages.
