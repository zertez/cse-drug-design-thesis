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

#set heading()
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

//  Checklist helpers
#let checkbox = box(
  width: 14pt,
  height: 14pt,
  stroke: 0.8pt + black,
  baseline: 3pt,
)

#let checkitem(body) = block(
  below: 0.5em,
  grid(
    columns: (auto, 1fr),
    column-gutter: 8pt,
    align: (horizon, horizon),
    checkbox,
    body,
  ),
)

#let checklist(title: none, ..items) = block(
  width: 100%,
  inset: 10pt,
  stroke: 0.5pt + black,
  fill: rgb("#fafafa"),
  [
    #if title != none [
      #text(weight: "bold", size: 10pt)[#title]
      #v(0.4em)
    ]
    #for item in items.pos() {
      checkitem(item)
    }
  ],
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
- *Potential Essential Additives:* TCEP (reducing agent), 10% Glycerol (cryoprotectant), Pyridoxal-5'-phosphate (PLP cofactor)
- *Methodological Basis:* Adapted from the SGC protocol @sgc_protocol and addgenes protocols.

#note(title: "Laboratory Implementation")[This is the first SOP for hCSE production in the group, adapted from the SGC pipeline. Expect revisions as we run it more times. The goal is to move hCSE production from one-off troubleshooting to a routine, reproducible workflow.]

#line(length: 100%, stroke: 0.5pt)

= Protocol Overview & Rationale

== Target Characteristics & Structural Constraints
This protocol covers heterologous expression, purification, and quality control of human cystathionine $gamma$-lyase (hCSE). Native hCSE is a fold type I PLP-dependent homotetramer ($tilde$ 44.5 kDa subunits, $tilde$ 178 kDa tetramer). Each active site carries a PLP cofactor covalently linked to Lys212 via a Schiff base (internal aldimine).

His-tag removal by TEV protease is included as a standard step. The N-terminal His6 tag introduced by pNIC28-Bsa4 is unlikely to interact with small-molecule ligands at the catalytic site or at the inter-subunit allosteric pocket described in on mechanistic grounds, but cleaving it eliminates the tag as a potential confound in downstream binding and activity readouts a priori. Using cleaved protein as the standard form across all biochemical and biophysical assays removes the need to control for tag effects post hoc and brings the screened protein sequence closer to the species modelled computationally.

== Analytical Objectives
Protein produced under this protocol feeds three downstream readouts:

1. Baseline catalytic characterization by the AzMC fluorometric H$#sub[2]$S assay.
2. Batch-to-batch thermal stability monitoring by Differential Scanning Fluorimetry (DSF).
3. Holoenzyme cofactor occupancy verification by A#sub[415]/A#sub[280] absorbance ratio.

Two thermal characterizations are part of batch release:

#text(weight: "bold")[Catalytic activity baseline at 37 °C.] Standard assay temperature for kinetic characterization. Enables direct comparison with published hCSE kinetic parameters and approximates physiological conditions.

#text(weight: "bold")[Baseline melting temperature (T#sub[m]) by DSF.] Used as a quality gate to verify folding and tetramer assembly. A reproducible T#sub[m] within a defined tolerance window (Section [forward ref]) is required before a batch is released to ligand screening. Buffer optimisation by pH/salt DSF screens is run separately when needed and is not part of routine batch QC.

#pagebreak()

= Strain and Plasmid Stock Management

Two items have been received from Addgene:

- *pNIC28-Bsa4-CTHA* (42365): the hCSE expression construct, shipped as a bacterial stab in a cloning host. Kanamycin selection.
- *BL21(DE3)-R3-pRARE2* (26242): the expression strain, shipped as a bacterial stab. Chloramphenicol selection (for pRARE2).

Both arrive as stab cultures - bacteria stabbed into a column of LB agar in a small screw-cap vial. Cells grow along the puncture track and out across the surface. It is vital that the bacterial stabs are stored immediately at 4 °C upon arrival. The bacterial stabs can survive up to two weeks in this condition, if you need it for longer then it has to be transferred to glycerol stocks for long-term storage.

= Procedure

#checklist(
  title: "Reagent and consumables checklist",
  [LB agar plates + kanamycin (50 μg/mL), poured and labelled - for #42365],
  [LB agar plates + chloramphenicol (34 μg/mL), poured and labelled - for #26242],
  [LB broth, autoclaved, ≥ 20 mL available],
  [Sterile 50% (v/v) glycerol in water, autoclaved, ≥ 5 mL available],
  [Sterile cryovials, labelled (≥ 3 per strain, minimum 6 total)],
  [Sterile inoculation loops or pipette tips],
  [Kanamycin stock: 50 mg/mL in water, aliquoted at −20 °C],
  [Chloramphenicol stock: 34 mg/mL in ethanol, aliquoted at −20 °C],
  [Miniprep kit on hand],
  [Sequencing primers ordered and received: pLIC-for, pLIC-rev],
  [Liquid nitrogen or dry ice available for snap-freeze],
  [−80 °C freezer space identified and labelled],
)

#checklist(
  title: "Day 1 - Procedure checklist",
  [Stabs received and stored at 4 °C],
  [42365 streaked onto LB + Kan plate],
  [26482 streaked onto LB + Cam plate],
  [Plates labelled: strain ID, date, antibiotic, initials],
  [Plates incubated at 37 °C overnight],
  [Original stabs returned to 4 °C as backup],
)


#bibliography(
  "protocols.bib",
  title: auto,

  style: "apa",
)