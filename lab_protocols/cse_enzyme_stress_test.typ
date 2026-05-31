// 
//  CSE Enzyme Stress Test (Document A)
//  Small-scale expression, single-step purification, and characterisation
//  Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
// 

#import "@preview/cades:0.3.1": qr-code
#import "parameters.typ": *

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
    #align(right)[Document A · v1.0 Author: Marcus D. Figenschou
    ]
  ],
)

#set text(font: "STIX Two Text", size: 10pt, lang: "en")
#show math.equation: set text(font: "STIX Two Math")
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

#let note(title: "Tip", body) = block(
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

#let checkgroup(title: none, ..items) = [
  #if title != none [
    #v(0.5em)
    #text(weight: "bold", size: 9.5pt)[#title]
  ]
  #for item in items.pos() {
    checkitem(item)
  }
]

#let checklist(title: none, cols: 1, ..content) = block(
  width: 100%,
  inset: 10pt,
  stroke: 0.5pt + black,
  fill: rgb("#fafafa"),
  [
    #if title != none [
      #text(weight: "bold", size: 10pt)[#title]
      #v(0.4em)
    ]
    #if cols > 1 {
      grid(
        columns: (1fr,) * cols,
        column-gutter: 16pt,
        ..content.pos(),
      )
    } else {
      for c in content.pos() { c }
    }
  ],
)



//  Title block
#align(center)[
  #v(0.5em)
  #text(size: 16pt, weight: "bold")[
    Expression, Purification, and Analytical Quality Control of \ Human Cystathionine γ-Lyase (hCSE)
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
- *Expression Host:* *E. coli* BL21(DE3)-R3-pRARE2 (Addgene #26242) | Cam#super[R]
- *Primary Scope:* Low-volume, high-purity production for baseline catalytic characterization, thermal stability profiling, and storage-stability validation
- *Potential Essential Additives:* TCEP (reducing agent), 10% Glycerol (cryoprotectant), \ Pyridoxal-5'-phosphate (PLP cofactor)
- *Methodological Basis:* Adapted from the SGC protocol @sgc_protocol and addgenes protocols.

#note(title: "Laboratory Implementation")[\ This is the first SOP for hCSE production in the group, adapted from the SGC pipeline. Expect revisions as we run it more times. The goal is to move hCSE production from one-off troubleshooting to a routine, reproducible workflow.]

#line(length: 100%, stroke: 0.5pt)

= Protocol Overview & Rationale

== Target Characteristics & Structural Constraints
This protocol covers heterologous expression, purification, and quality control of human cystathionine $gamma$-lyase (hCSE). Native hCSE is a fold type I PLP-dependent homotetramer ($tilde$ 44.5 kDa subunits, $tilde$ 178 kDa tetramer). Each active site carries a PLP cofactor covalently linked to Lys212 via a Schiff base (internal aldimine).

His-tag removal by TEV protease is included as a standard step. The N-terminal His6 tag introduced by pNIC28-Bsa4 is unlikely to interact with small-molecule ligands at the catalytic site or at the inter-subunit allosteric pocket described in on mechanistic grounds, but cleaving it eliminates the tag as a potential confound in downstream binding and activity readouts a priori. Using cleaved protein as the standard form across all biochemical and biophysical assays removes the need to control for tag effects post hoc and brings the screened protein sequence closer to the species modelled computationally.

== Analytical Objectives
Protein produced under this protocol feeds three downstream readouts:

1. Baseline catalytic characterization by the AzMC fluorometric H$#sub[2]$S assay.
+ Batch-to-batch thermal stability monitoring by Differential Scanning Fluorimetry (DSF).
+ Holoenzyme cofactor occupancy verification by A#sub[415]/A#sub[280] absorbance ratio.
+ Flash freeze and thawing
+ Oligomeric state and monodispersity by SEC-MALS (250 µg per condition), on fresh, on-ice, and flash-frozen aliquots.
+ Aggregation behaviour and hydrodynamic radius by dynamic light scattering (DLS, 50 µg per condition) on the same three storage conditions.
+ Regular secondary-structure content and fold integrity by circular dichroism (CD), carried forward from the DLS samples.
+ Intact mass and redox susceptibility by ESI-TOF mass spectrometry (5 µg).
+ Buffer-screen thermal stability by DSF across 3 pH values × 3 salt concentrations (90 µg total, full combinatorial matrix).
+ Sequence identity and proteolytic degradation by SDS-PAGE (5 µg), with band excision submitted for MALDI-TOF peptide mass fingerprinting.

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
    LB agar plates with antibiotic are required for Day 1 (streaking) and Day 3 QC (revive test). Plates are poured fresh ~1 week before Day 1 to ensure full antibiotic activity. Adapted from the Addgene plate-pouring protocol - scan the QR code for Addgene's video walkthrough.
  ],
  [
    #qr-code("https://www.youtube.com/watch?v=ey19jM6y7-c", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      Plate Pouring Protocol
    ]]
  ],
)

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Autoclave],
      [60 °C water bath],
      [Static incubator at 37 °C],
      [Bunsen burner / flame source],
      [Ice for antibiotics],
      [Dark or foil-wrapped tube rack (for Cam stock)],
      [Autoclave-safe 500 mL bottles ($times$#n_antibiotics)],
      [Aluminium foil (for autoclave bottle caps)],
      [Autoclave tape + lab tape for labelling],
      [Sterile inoculation loops (4-6)],
      [Sterile pipette tips (P200, P1000)],
      [Petri dishes, 60 mm × 15 mm, sterile - #total_dishes total (see Batch sizing)],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [LB-agar powder, pre-mixed (verify g/L on bottle label)],
      [Sterile dH#sub[2]O],
      [Kanamycin stock: 50 mg/mL in dH#sub[2]O, 0.22 μm filter-sterilised, $-$20 °C],
      [Chloramphenicol stock: 34 mg/mL in EtOH, 0.22 μm filter-sterilised, $-$20 °C, kept dark],
    )
  ],
)

#pagebreak()

=== Batch sizing

This SOP pours *#total_plates plates total (#plates_per_antibiotic per antibiotic)*:

#table(
  columns: (1fr, 1fr, 0.6fr),
  stroke: 0.5pt,
  inset: 5pt,
  align: (left, left, center),
  [*Plate type*], [*Streaked with*], [*n*],
  [LB+Kan], [#42365 (+) / #26242 ($-$)], [#{plates_per_antibiotic / 2} + #{plates_per_antibiotic / 2}],
  [LB+Cam], [#26242 (+) / #42365 ($-$)], [#{plates_per_antibiotic / 2} + #{plates_per_antibiotic / 2}],
  table.cell(colspan: 2, align: left)[*Total*], [*#total_plates*],
)

At #volume_per_plate_mL mL per plate, the #plates_per_antibiotic plates per antibiotic require #agar_volume_required_mL mL of molten agar; make up #agar_volume_per_antibiotic_mL mL per bottle (#agar_volume_total_mL mL total across #n_antibiotics bottles) to allow ~#pour_margin_percent% margin for bottle residue and pouring loss.


1. For each antibiotic, weigh #lb_agar_mass_g g pre-mixed LB-agar powder into a 500mL bottle, one for each antibiotic.

  #note[\ Calculation: #lb_agar_g_per_L g/L formulation $times$ #{agar_volume_per_antibiotic_mL / 1000} L = #lb_agar_mass_g g. The #agar_volume_per_antibiotic_mL mL volume targets #plates_per_antibiotic plates at #volume_per_plate_mL mL each with margin for bottle residue.]

+ Add #agar_volume_per_antibiotic_mL mL sterile dH#sub[2]O to each bottle. Swirl to form a uniform suspension.

+ Loosely cap each bottle (do #underline[*NOT*] seal airtight) and cover the cap with aluminium foil. Apply autoclave tape and label with date, contents, and initials.

+ Autoclave at 121 °C, 20 psi, for ≥ 30 min.

*While the autoclave is running set up the plate pouring station near a burner*

5. Spray a section of lab bench with 70% ethanol and wipe with a paper towel.

+ Label each plate base (not the lid - lids get swapped) with: antibiotic, pour date, initials. Batch labelling with coloured markers per antibiotic (e.g. blue for Kan, red for Cam) speeds this up.

+ Position the flame at the bench. Stack the *#dishes_per_antibiotic labelled petri dishes per antibiotic* next to the flame (#plates_per_antibiotic for the workflow + #plates_spare spare for pouring variation).

+ Have both antibiotic stocks ready on ice. Foil-wrap the Cam tube or keep it in an opaque container to protect from light.

+ Retrieve the molten agar from the autoclave.

  #note[\ Once the autoclave is complete, open the door and leave it partially open for $tilde$10 min. This will release steam and will let the gel-mix cool a little bit. *#underline[Use thermally insulated gloves to remove the bottles.]*]

+ Partially submerge each bottle in the 60 °C water bath for ≥ 5 min. Do *not* let water bath water touch the cap or neck of the bottle. Cooled agar should be warm to the touch but still fully liquid - if you cannot hold the bottle in a gloved hand, it is too hot to add antibiotic.

+ Working next to the flame, add antibiotic to each bottle at 1:#antibiotic_dilution:
  - Kan bottle: #antibiotic_volume_uL μL of 50 mg/mL kanamycin stock $arrow$ 50 μg/mL final
  - Cam bottle: #antibiotic_volume_uL μL of 34 mg/mL chloramphenicol stock $arrow$ 34 μg/mL final

+ Swirl each bottle gently to distribute the antibiotic evenly. Avoid creating bubbles.

+ Pour $tilde$#volume_per_plate_mL mL per plate (60 mm dish). For the first plate, measure with a pipette to calibrate by eye; pour subsequent plates directly from the bottle.

  #nb(title: "NB!")[\ If agar begins solidifying in the bottle stop pouring. Antibiotic has already been added, re-heating (microwave or autoclave) will degrade both kanamycin and chloramphenicol and the batch must be discarded. To avoid this, work briskly once the antibiotic is in - typical pour window from antibiotic addition to last plate is 10-15 min.]

#pagebreak()
14. After pouring each plate, swirl gently to ensure even coverage and remove surface bubbles. Cap and stack.

+ Leave plates at room temperature to solidify ($tilde$30 min) and then dry overnight, agar-side up, with lids cracked slightly. This drying step is important - undried plates accumulate condensation on the lid.
+ Once dry, transfer plates to a sealed plastic bag with a folded paper towel as desiccant. Invert plates (agar-side up) inside the bag to prevent condensation pooling on the agar.

+ Label the bag with the antibiotic, pour date, and your initials.

+ Store at 4 °C. Chloramphenicol plates must be kept dark (opaque container or drawer); kanamycin plates are not light-sensitive.

+ Plates are valid for 1 month from the pour date, but check the plates continuously. Discard any plates that show contamination, drying (cracks or shrinkage from plate edge), or condensation pooling on the agar.

== Day 2: Stab arrival and plate streaking

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    Streaking from the Addgene stabs serves two purposes simultaneously: (i) revival of the strains for downstream liquid culture, and (ii) bidirectional batch validation of the LB+Kan and LB+Cam plates via cross-streaking (see Day 1 Batch sizing). Adapted from the Addgene plate-streaking protocol - scan the QR code for the video walkthrough.
  ],
  [
    #qr-code("https://www.youtube.com/watch?v=P6HlqmYEcZM", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      Plate Streaking Protocol
    ]]
  ],
)

#nb(title: "NB!")[\ Store both Addgene stabs at 4 °C immediately on arrival, or place on ice if streaking the same day. The stabs survive at 4 °C for up to 2 weeks, but glycerol stocks (Day 4) should be made within the first 5 days to maximise safety margin.]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Static incubator at 37 °C],
      [Bunsen burner / flame source],
      [Sterile inoculation loops ($times$4, one per streak)],
      [Ice bucket],
    )
  ],
  [
    #checkgroup(
      title: "Reagents & Materials",
      [Addgene stab #42365 (cloning host with pNIC28-Bsa4-CTHA)],
      [Addgene stab #26242 (BL21(DE3)-R3-pRARE2)],
      [LB+Kan plates from Day 1 batch ($times$#plates_used_day2_per_antibiotic)],
      [LB+Cam plates from Day 1 batch ($times$#plates_used_day2_per_antibiotic)],
    )
  ],
)

=== Procedure

1. Bring 4 LB+Kan plates and 4 LB+Cam plates to room temperature before streaking (cold agar gives uneven streak distribution). Pre-warm at 37 °C for 10 min if condensation is present.

+ Working near the flame, flame-sterilise an inoculation loop. Allow $tilde$5 s to cool.

+ Pick a small amount of growth from the *#42365 stab* using the cooled loop. Streak onto:
  - *2 LB+Kan plates* (positive control + workflow source for colony picking on Day 3)
  - *2 LB+Cam plates* (negative cross-control - expect *no growth* if Cam is functional)

  Use standard four-quadrant streaking on each plate to generate isolated single colonies. Flame the loop between plates.

+ Flame the loop again and allow to cool. Pick from the *#26242 stab*. Streak onto:
  - *2 LB+Cam plates* (positive control + workflow source for colony picking on Day 3)
  - *2 LB+Kan plates* (negative cross-control - expect *no growth* if Kan is functional)

+ Return both stabs to 4 °C immediately. *Do not discard* - they remain the only verified source of viable material until glycerol stocks are validated on Day 5.

+ Invert all 8 plates (agar-side up) and incubate at 37 °C for 14-18 h.

#pagebreak()

== Day 3: Inoculate liquid cultures

After overnight incubation, the positive streak plates (LB+Kan with #42365; LB+Cam with #26242) should show isolated single colonies. The negative cross-control plates should show no growth - this confirms both antibiotic batches are functional. Pick one well-isolated colony per strain to seed a liquid culture.

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Shaking incubator, 37 °C, 200 rpm],
      [Sterile inoculation loops or toothpicks ($times$4)],
      [Sterile 50 mL culture tubes ($times$2)],
      [P10 sterile tips],
      [Bunsen burner / flame source],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [LB broth, sterile (autoclaved)],
      [Kanamycin stock: 50 mg/mL],
      [Chloramphenicol stock: 34 mg/mL],
    )
  ],
)

== Procedure

1. Near the flame, prepare two culture tubes:
   - *Tube 1 (cloning host):* 5 mL LB + 5 μL Kan stock $arrow$ 50 μg/mL final. Label "#42365 / Kan / [date] / [initials]".
   - *Tube 2 (expression host):* 5 mL LB + 5 μL Cam stock $arrow$ 34 μg/mL final. Label "#26242 / Cam / [date] / [initials]".

+ Using a sterile loop, pick a *single well-isolated colony* from the LB+Kan positive plate (#42365). Inoculate into Tube 1. Swirl the loop briefly in the medium.

  #note[\ Pick from a clearly isolated single colony, not a streak edge or confluent area. Clonal identity of every downstream glycerol stock depends on this step. If colonies are too dense to resolve a single one, re-streak from the backup plate before proceeding.]

+ Flame the loop. Using a fresh sterile loop, pick a single isolated colony from the LB+Cam positive plate (#26242). Inoculate into Tube 2.

+ Incubate both tubes overnight at 37 °C, 200 rpm. Target OD#sub[600] = 2-4 (saturated culture) the next morning.

  #note[\ Overnight saturated culture is the standard input for glycerol stocks. Late-log phase (OD#sub[600] $tilde$1.5-2) gives marginally higher post-thaw viability but requires daytime monitoring; saturated overnight culture is the practical default and post-thaw viability remains $gt$95% for *E. coli* under standard glycerol freezing.]

#pagebreak()

== Day 4: Archival glycerol stocks

Both Addgene strains are archived in parallel. Four cryotubes per strain provides redundancy against tube failure, freezer accidents, and freeze-thaw degradation - *not* biological replicates. All four stocks for a given strain are clonally identical, derived from the same single colony via the same overnight culture.

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Vortex],
      [Ice bucket],
      [$-$80 °C freezer (cryobox position pre-assigned)],
      [Liquid nitrogen dewar (optional, for snap-freeze)],
      [Screw-cap cryotubes, 2 mL, sterile ($times$8 + 2 spares)],
      [P1000 sterile tips],
      [Solvent-resistant cryo marker],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [Sterile 50% glycerol (autoclaved, room temperature)],
      [Day 3 overnight cultures (both strains)],
    )
  ],
)

#nb(title: "NB!")[\ Use *screw-cap* cryotubes, not snap-top. Snap-top tubes can open spontaneously at $-$80 °C and release the stock.]

=== Procedure

1. Label 8 cryotubes (4 per strain) on *both the side wall and the cap* with a solvent-resistant cryo marker. Each label must include:
   - Strain ID (#42365 or #26242)
   - Antibiotic (Kan or Cam)
   - Stock number (e.g. "1/4", "2/4", ...)
   - Date of freezing
   - Initials

   #note[\
   Adhesive labels detach at $-$80 °C over months. Writing directly on the tube with a cryo-rated marker is the lab standard. Labelling both the wall *and* the cap ensures identification even if a label face is rubbed off during handling.]

+ Pre-chill the 8 labelled cryotubes on ice.

+ To each cryotube, add:
  - 500 μL sterile 50% glycerol
  - 500 μL overnight culture (#42365 culture for the 4 Kan-labelled tubes; #26242 culture for the 4 Cam-labelled tubes)

  Final glycerol concentration: 25% (v/v).

+ Cap tightly. Vortex briefly (2-3 s) to fully mix - confirm a single uniform solution with no glycerol layer at the bottom.

  #nb[\ Incomplete mixing leaves a glycerol gradient inside the tube, which results in uneven cryoprotection and lower post-thaw viability. The Addgene protocol specifies shaking 5-6 times until uniform; vortexing achieves the same with less risk of inverting cap-down.]

#pagebreak()
5.  Snap-freeze in liquid nitrogen, then transfer to $-$80 °C. If LN#sub[2] is not available, transfer directly from ice to $-$80 °C - post-thaw viability is comparable for *E. coli* under either method.

+ Record cryobox location, position, and contents in the lab freezer log immediately.


== Day 5: Glycerol stock viability QC

Confirm that the freezing step did not compromise viability. One stock per strain is sampled; the remaining three serve as the long-term archive.

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Static incubator, 37 °C],
      [Sterile inoculation loops or toothpicks ($times$2)],
      [Ice bucket or dry ice (to keep cryotubes cold during sampling)],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [1 LB+Kan plate (workflow plate from Day 1 batch)],
      [1 LB+Cam plate (workflow plate from Day 1 batch)],
    )
  ],
)

=== Procedure

30. Pre-warm one LB+Kan and one LB+Cam plate to room temperature.

+ Remove one cryotube per strain (e.g. "1/4" of each) from $-$80 °C. *Keep the tube on dry ice or ice during sampling - do not allow the stock to thaw.*

+ Using a sterile loop or toothpick, scrape a small amount of frozen stock from the surface. Immediately return the cryotube to $-$80 °C.

  #note[Scraping the frozen surface preserves the bulk of the stock without freeze-thaw damage. Each archival stock can be sampled this way multiple times if needed, though the standard practice is to scrape once for QC and treat the remainder as untouched archive.]

+ Streak the scraped material onto the corresponding antibiotic plate using standard four-quadrant streaking for single colonies. Flame the loop between strains.

+ Incubate plates overnight at 37 °C.

+ *Read-out (next morning):* single colonies on both plates confirm viable archival stocks. The Addgene stabs may now be discarded (or retained at 4 °C for an additional 1-week safety margin if storage space allows).

  #nb(title: "If no growth:")[Re-test a second cryotube from the same strain. If the second stock also fails, the freezing step is the likely failure mode (incomplete mixing, glycerol concentration error, freezer malfunction). Do *not* discard the original Addgene stab - re-streak from the stab and repeat Days 3-5 with corrected procedure.]

=== Path B: Plasmid DNA backup (42365 only) 


#bibliography(
  "protocols.bib",
  title: auto,
  style: "apa",
)