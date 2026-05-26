// 
//  CSE Enzyme Stress Test (Document A)
//  Small-scale expression, single-step purification, and characterisation
//  Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
// 

#import "@preview/cades:0.3.1": qr-code

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
    #align(right)[Document A · v0.1 (draft)
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
  #set text(size: 10pt, weight: "bold")
  #it
]

#let needbox(body) = block(
  width: 100%,
  inset: 8pt,
  stroke: 0.5pt + black,
  fill: rgb("#f7f7f7"),
  [#text(weight: "bold")[You need:] \ #body],
)

#let nb(title: "NB!", body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#b00020")),
  fill: rgb("#fdecea"),
  [#text(weight: "bold", fill: rgb("#b00020"))[#title ] #body],
)

#let note(title: "Note", body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#1a73e8")),
  fill: rgb("#e8f0fe"),
  [#text(weight: "bold", fill: rgb("#1a73e8"))[#title] #body],
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

//  Extended checklist helpers
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

#let checkgroup(title: none, ..items) = [
  #if title != none [
    #v(0.5em)
    #text(weight: "bold", size: 9.5pt)[#title]
  ]
  #for item in items.pos() {
    checkitem(item)
  }
]

#let checklist(title: none, ..content) = block(
  width: 100%,
  inset: 10pt,
  stroke: 0.5pt + black,
  fill: rgb("#fafafa"),
  [
    #if title != none [
      #text(weight: "bold", size: 10pt)[#title]
      #v(0.4em)
    ]
    #for c in content.pos() { c }
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

#note(title: "Laboratory Implementation:")[This is the first SOP for hCSE production in the group, adapted from the SGC pipeline. Expect revisions as we run it more times. The goal is to move hCSE production from one-off troubleshooting to a routine, reproducible workflow.]

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

Both arrive as stab cultures - bacteria stabbed into a column of LB agar in a small screw-cap vial. Cells grow along the puncture track and out across the surface. It is vital that the bacterial stabs are stored immediately at 4 °C upon arrival. The bacterial stabs can survive up to two weeks in this condition, if you need it for longer then it has to be transferred to glycerol stocks for long-term storage at -80 °C.

= Procedure

== Day 1: Plate and reagent preparation


#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    LB agar plates with antibiotic are required for Day 1 (streaking) and Day 3 QC (revive test). Plates are poured fresh ~1 week before Day 1 to ensure full antibiotic activity. Adapted from the Addgene plate-pouring protocol; scan the QR code for Addgene's video walkthrough.
  ],
  [
    #qr-code("https://www.youtube.com/watch?v=ey19jM6y7-c", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      Plate Pouring Protocol
    ]]
  ],
)


#checklist(
  checkgroup(
    title: "Equipment",
    [Autoclave],
    [60 °C water bath],
    [Shaking incubator at 37 °C],
    [-80 °C freezer space],
  ),
  checkgroup(
    title: "Reagents",
    [LB-agar powder, pre-mixed],
    [Sterile dH#sub[2]O],
    [Kanamycin stock: 50 mg/mL in dH#sub[2]O],
    [Chloramphenicol stock: 34 mg/mL in EtOH, kept dark],
  ),
  checkgroup(
    title: "Consumables",
    [Sterile cryovials (≥ 6)],
    [Sterile inoculation loops (platinum?), pipette tips],
    [Petri dishes, 60 mm × 15 mm, sterile],
  ),
)

#pagebreak()

=== Prepare and autoclave molten agar

1. For each antibiotic, weigh 8.14 g pre-mixed LB-agar powder into a separate 500 mL bottle.

  #note[Calculation: 37 g/L formulation × 0.220 L = 8.14 g. Making 220 mL rather than 200 mL provides margin for spillage and measurement error.]

+ Add 220 mL sterile dH#sub[2]O to each bottle. Swirl to form a uniform suspension.

+ Loosely cap each bottle (do #underline[*NOT*] seal airtight) and cover the cap with aluminium foil. Apply autoclave tape and label with date, contents, and initials.

+ Autoclave at 121 °C, 20 psi, for ≥ 30 min.

+ After the cycle, crack the autoclave door for $tilde$10 min to release steam and begin cooling. Use thermally insulated gloves to remove the bottles.

== Cool, add antibiotic, pour
While the bottles are still hot, set up the pouring station:

6. Spray a section of lab bench with 70% ethanol and wipe with a paper towel.

+ Position the flame at the bench. Stack $tilde$22 labelled petri dishes per antibiotic next to the flame.

+ Label each plate base (not the lid - lids get swapped) with: antibiotic, pour date, initials. Batch labelling with coloured markers per antibiotic (e.g. blue for Kan, red for Cam) speeds this up.

+ Have the antibiotic stocks ready on ice (Kan) or in a dark tube rack (Cam).

+ Partially submerge each bottle in the 60 °C water bath for ≥ 5 min. Do *not* let water bath water touch the cap or neck of the bottle. Cooled agar should be warm to the touch but still fully liquid - if you cannot hold the bottle in a gloved hand, it is too hot to add antibiotic.

+ Working next to the flame, add antibiotic to each bottle at 1:1000:
  - Kan bottle: 220 μL of 50 mg/mL kanamycin stock at 50 μg/mL final
  - Cam bottle: 220 μL of 34 mg/mL chloramphenicol stock at 34 μg/mL final

+ Swirl each bottle gently to distribute the antibiotic evenly. Avoid creating bubbles.

+ Pour $tilde$10 mL per plate (60 mm dish). For the first plate, measure with a pipette to calibrate by eye; pour subsequent plates directly from the bottle.

+ After pouring each plate, swirl gently to ensure even coverage and remove surface bubbles. Cap and stack.

+ Leave plates at room temperature to solidify ($tilde$30 min) and then dry overnight, agar-side up, with lids cracked slightly. This drying step is important - undried plates accumulate condensation on the lid.

== Storage and validation

16. Once dry, transfer plates to a sealed plastic bag with a folded paper towel as desiccant. Invert plates (agar-side up) inside the bag to prevent condensation pooling on the agar.

+ Label the bag with the antibiotic, pour date, and your initials.

+ Store at 4 °C. Chloramphenicol plates must be kept dark (opaque container or drawer); kanamycin plates are not light-sensitive.

+ Plates are valid for 1 month from the pour date. Discard any plates that show contamination, drying (cracks or shrinkage from plate edge), or condensation pooling on the agar.

#nb[Before relying on a new batch for the Day 1 streak, validate it: streak a known antibiotic-resistant strain on one plate and a known sensitive strain on a second plate. Incubate overnight at 37 °C. Resistant strain should grow; sensitive strain should not. If both grow, the antibiotic is degraded or was not added. If neither grows, the antibiotic concentration may be too high or your control strain is non-viable.]



== Day 2: Addgene Material Arriavl and Plate Streaking

#nb(title: "NB!")[Remember to store the plasmids at 4 °C immediately once they arrive!]

+ On receipt, store both stabs at 4 °C. Streak the same day if possible.
+ Using a sterile loop, pick a small amount of growth from each stab and streak onto a fresh plate with the appropriate antibiotic: 42365 to LB + Kan; 26242 to LB + Cam.
+ Incubate plates overnight at 37 °C until single colonies appear (typically 14 to 18 h).
+ Return the original stabs to 4 °C as a backup. Do not discard until long-term stocks have been validated (Day 3 QC).

== Day 2: Inoculate liquid cultures

== Day 3: Branch into archival storage and plasmid backup

=== Path A: Archival glycerol stocks (both strains)

=== Path B: Plasmid DNA backup (42365 only)


#bibliography(
  "protocols.bib",
  title: auto,
  style: "apa",
)