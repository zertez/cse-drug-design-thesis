// 4. Results (max 20 pages including text, tables, figures)
// Tense: past tense for experiments; present tense for general conclusions.
// One main figure per research question (panels A, B, C, ...).
#import "../_packages.typ": *

= Results

== Structural Analysis of CBS and CSE

#lorem(120)

// Example: multi-panel figure using subpar
#subpar.grid(
  figure(image("../figures/ATP_test.png"), caption: [CBS homodimer overview.]),
  figure(image("../figures/ATP_test.png"), caption: [Active site detail.]),

  figure(image("../figures/ATP_test.png"), caption: [CSE structural comparison.]),
  figure(image("../figures/ATP_test.png"), caption: [AlphaFold3 overlay.]),

  columns: (1fr, 1fr),
  caption: [Structural analysis of CBS and CSE. ...],
  label: <fig:structural-analysis>,
)

== Computational Drug Screening

#lorem(120)

== Experimental Validation

#lorem(120)

// Example: table with caption above
// #figure(
//   table(
//     columns: 4,
//     stroke: 0.5pt,
//     inset: 0.5em,
//     [*Compound*], [*IC50 (uM)*], [*Kd (uM)*], [*Delta Tm (C)*],
//     [Compound 1], [12.3 +- 1.2], [8.7 +- 0.9], [+3.2],
//     [Compound 2], [45.6 +- 3.4], [> 100], [+0.8],
//   ),
//   caption: [Summary of hit compound activities against CBS.],
//   kind: table,
// ) <tab:compound-activity>
