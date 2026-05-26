// 
//  CSE Enzyme Stress Test (Document A)
//  Small-scale expression, single-step purification, and characterisation
//  Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
// 

#set document(
  title: "CSE Enzyme Stress Test",
  author: "Marcus - Haavik Group, UiB Biomedicine",
)

#set page(
  paper: "a4",
  margin: (top: 2.2cm, bottom: 2.2cm, left: 2.2cm, right: 2.2cm),
  numbering: "1 / 1",
  header: [
    #set text(size: 8pt, fill: gray)
    #align(right)[
      CSE Enzyme Stress Test · Document A · v0.1 (draft)
    ]
  ],
)

#set text(font: "STIX Two Text", size: 10pt, lang: "en")
#set par(justify: true, leading: 0.6em)

#set heading(numbering: "1.")
#show heading.where(level: 1): it => [
  #v(0.6em)
  #set text(size: 13pt, weight: "bold")
  #it
  #v(0.2em)
]
#show heading.where(level: 2): it => [
  #v(0.4em)
  #set text(size: 11pt, weight: "bold")
  #it
  #v(0.1em)
]
#show heading.where(level: 3): it => [
  #v(0.3em)
  #set text(size: 10pt, weight: "bold", style: "italic")
  #it
]

#let needbox(body) = block(
  width: 100%,
  inset: 8pt,
  stroke: 0.5pt + black,
  fill: rgb("#f7f7f7"),
  [#text(weight: "bold")[You need:] \ #body],
)

#let qc(body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#b00020")),
  fill: rgb("#fdecea"),
  [#text(weight: "bold", fill: rgb("#b00020"))[QC checkpoint. ] #body],
)

#let note(title: "Note", body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#1a73e8")),
  fill: rgb("#e8f0fe"),
  [#text(weight: "bold", fill: rgb("#1a73e8"))[#title. ] #body],
)

#let tbd(body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#b88600")),
  fill: rgb("#fff8e1"),
  [#text(weight: "bold", fill: rgb("#b88600"))[Decision pending. ] #body],
)


//  Title block
#align(center)[
  #v(0.5em)
  #text(size: 16pt, weight: "bold")[
    Expression, Purification, and Analytical Quality Control of Human Cystathionine γ-Lyase (hCSE)
  ]
  #v(0.4em)
  #text(size: 10pt)[
    Basic and Translational Neuroscience · Neurotargeting Research Group · Department of Biomedicine · UiB
  ]
]

#v(0.5em)

// 

= Protocol Quick View 

- *Target protein:* Human cystathionine $gamma$-lyase (hCSE; gene: CTH; EC 4.4.1.1)
- *Expression vector:* pNIC28-Bsa4 (Addgene #42365) | Kan#super[R]
- *Expression Host:* *E. coli* BL21(DE3)-R3-pRARE2 (Addegg #26242) | Cam#super[R]
- *Primary Scope:* Low-volume, high-purity production for baseline catalytic characterization, thermal stability profiling, and storage-stability validation
- *Essential Additives:* TCEP (reducing agent), 10% Glycerol (cryoprotectant), Pyridoxal-5'-phosphate (PLP cofactor)
- *Methodological Basis:* Adapted from the SGC protocol @sgc_protocol

#note(title: "Laboratory Implementation")[This is the first SOP for hCSE production in the group, adapted from the SGC pipeline. Expect revisions as we run it more times. The goal is to move hCSE production from one-off troubleshooting to a routine, reproducible workflow.]

#line(length: 100%, stroke: 0.5pt)

= Protocol Overview & Rationale

== Target Characteristics & Structural Constraints
This protocol outlines the heterologous expression, purification, and multi-tier quality control validation of human cystathionine $gamma$-lyase (hCSE). Native hCSE is a fold type I pyridoxal-5'-phosphate (PLP)-dependent homotetramer ($tilde$ 44 kDa subunits, $approx$ 176 kDa total assembly). Each active site requires a covalently bound PLP cofactor, anchored to Lys212 via a Schiff base linkage.

To ensure high-fidelity downstream results, a standardized His-tag removal step via TEV protease is integrated into this pipeline. This strategy is implemented to eliminate potential interference from the polyhistidine moiety during subsequent ligand-binding assays and to ensure that the protein population used for screening is identical to the native-like state. 

== Thermal Stability & Analytical Objectives
A critical component of this QC pipeline is characterization of the enzyme's thermal landscape and stability constraints. Because PLP-dependent enzymes are sensitive to temperature-induced cofactor dissociation and subunit denaturation, this protocol targets two distinct thermal profiles:

1. Physiological Activity Baseline: Characterizing the baseline catalytic activity strictly at human physiological temperature (37°C). This ensures that the enzymatic velocity, active-site kinetics, and allosteric pocket conformations directly reflect the physiological environment of human brain tissue, providing a biologically relevant baseline for downstream ligand screening.
2. Thermal Shifts & Conformational Stability: Utilizing Differential Scanning Fluorimetry (DSF) to determine the baseline melting temperature (T#sub[m]) of the holoenzyme assembly. This profile serves as a quality gate to verify correct folding across different batches and maps how variations in pH and salt concentrations modulate the structural stability of the tetramer.

== Protocol Genesis & Implementation



Note on Laboratory Implementation:
This document serves as the foundational Standard Operating Procedure (SOP) for hCSE production. This workflow represents the first implementation of the SGC-derived pipeline for this specific target in the neurotargeting research group, this protocol is subject to iterative refinement. The primary objective of this document is to transition hCSE production from a developmental phase to a standardized, reproducible, and high-throughput capable workflow.



#bibliography(
  "protocols.bib",
  title: auto,

  style: "apa",
)