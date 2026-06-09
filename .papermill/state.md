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
stage: submitted (EJS, 2026-06-09)
created: 2026-06-08
last_updated: 2026-06-09

submission:
  venue: "Electronic Journal of Statistics (EJS)"
  manuscript_id: "EJS2606-023"
  status: under-review
  submitted: 2026-06-09
  round: null      # not yet assigned (initial editorial processing)
  decision: null
  track_url: "https://www.e-publications.org/ims/submission/EJS/author/track/2"
  uploaded: "main.pdf (ejsv2,noshowframe build, md5 e48caf23) + LaTeX source zip; metadata, MSC2020, keywords, cover letter, suggested referees all entered"
  preprint: "PUBLISHED 2026-06-09: Zenodo version DOI 10.5281/zenodo.20604315; concept DOI 10.5281/zenodo.20604314 now resolves (record https://zenodo.org/records/20604315)."

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
  # Venue analysis 2026-06-09 (web-verified; supersedes the scaffold's Statistical Science
  # primary). Pillar 2 is a THEORY-METHODS paper with new theorems, NOT a synthesis.
  # Statistical Science rejects plain theory-and-methods unless review-framed, and it is the
  # companion synthesis's target, so the two pillars are deliberately split by genre:
  # synthesis -> Statistical Science; sensitivity -> a theory-and-methods journal (below).
  primary: "Electronic Journal of Statistics (EJS)"
  top_down_alternative: "JASA Theory & Methods"
  decision: >
    RESOLVED 2026-06-09 (author): EJS-first. Fast, zero-reformat (imsart ejs option), open
    access with no APC, near-certain fit; banks a published methods paper the synthesis can
    cite by concept DOI. JASA Theory & Methods kept as the top-down alternative if EJS declines
    or a higher imprint is wanted. main.tex switched to documentclass[ejs]; the official
    imsart-ejs.cnf (a benign optional production hook) can be vendored at submission.
  analyzed: 2026-06-09
  shortlist:
    - rank: 1
      name: "JASA Theory & Methods"
      fit: high
      reformat_from_imsart: "yes (one-time class swap)"
      note: >
        Scope-perfect: missing-data/identification methods with required real-problem
        motivation; the six instances + simulation harness satisfy JASA's motivation and
        (mandatory-on-revision) reproducibility expectations. Most prestigious fit. Risks:
        ~10% acceptance, slow review. Preprints permitted (disclose the Zenodo DOI).
    - rank: 2
      name: "Electronic Journal of Statistics (EJS)"
      fit: high
      reformat_from_imsart: "NO (imsart)"
      note: >
        Calibrated/fast: IMS, full open access, NO APC, zero reformat, historically <~3mo to
        first decision, no page friction for ~10pp. Lower prestige than JASA but near-certain
        fit and the fastest path, so the synthesis can cite a PUBLISHED methods paper.
    - rank: 3
      name: "Biometrika"
      fit: good
      reformat_from_imsart: "yes (OUP template)"
      note: >
        Partial-ID/sensitivity theory + verification-bias lineage fit the house style; compact
        dense theory (~10pp on-brand). Reviewers will demand the first-order finite-delta
        remainder be quantified, not just bounded.
    - rank: 4
      name: "Bernoulli"
      fit: good
      reformat_from_imsart: "NO (imsart bj template)"
      note: >
        IMS/Bernoulli-Society trade-up above EJS with zero reformat; more probability-leaning,
        so lead with the theorems (bias bound, identified set, minimax rate) over the six
        applied instances. Slower and more selective than EJS.
    - rank: 5
      name: "JRSS Series B"
      fit: weak
      reformat_from_imsart: "yes (OUP class)"
      note: >
        Elite methodology; wants broad-impact methodology rather than a focused theorem-pair,
        and may see the synthesis as already owning the broad frame. Reach unless reframed.
  reach: >
    Annals of Statistics (imsart, no reformat) ONLY if reframed around the minimax lower bound
    and the theory is deepened (full risk characterization over the zonotope); as-is a likely
    desk-reject for being too short/applied.
  excluded:
    - "Statistical Science as primary: rejects plain theory-and-methods; it is the synthesis's venue. Keep the pillars separate."
    - "Biometrics: biom.cls reformat, 25pp cap, biological-sciences identity; scope mismatch."
    - "Journal of Econometrics / Quantitative Economics: no economic application despite the partial-ID content."
  strategy: >
    The decision is speed/certainty vs imprint. Calibrated-first (EJS) banks a fast,
    near-certain, zero-overhead OA publication so the synthesis can cite a published methods
    paper; top-down (JASA T&M, fall back to Bernoulli or EJS) trades months for the JASA
    imprint. No venue penalizes prior rejection, so serial submission costs only time; the
    real friction is repeated non-imsart reformatting (JASA -> Biometrika -> JRSS-B each need a
    different class), which an IMS-family choice (EJS/Bernoulli) avoids. Content lever for the
    higher-bar venues: tighten and quantify the first-order finite-delta remainder, the single
    most likely technical objection. Keep the division of labor explicit in the cover letter
    (this = the C2-violation theorems; synthesis = the cross-domain review frame) so neither
    reads as salami-slicing.

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
