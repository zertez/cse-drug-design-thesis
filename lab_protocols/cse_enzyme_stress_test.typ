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
    #align(right)[Document A · v3.0 Author: Marcus D. Figenschou
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

- *Target protein:* Human cystathionine $gamma$-lyase (hCSE, gene: CTH, EC 4.4.1.1)
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

#nb[\ Before you go through this protocol check that you have everything needed such as materials and equipemnt. Especially check if you need to book equipment in advance!]

== Day 1: Media preparation (autoclave batch)

All media that need sterilising are prepared in one session on Day 1. The autoclave cycle is the slow, rate-limiting step of the whole workflow, so everything that has to pass through it - plate agar, starter/overnight broth, and the high-density expression broth - is batched into a single run rather than spread across the week.

#note(title: "Storage rule")[\ Autoclaved media *without antibiotic* keep at 4 °C for up to $tilde$1 month. Antibiotic is added only at the point of use, never to a stored bottle - kanamycin and chloramphenicol both lose activity over weeks in solution, and antibiotic media cannot be re-autoclaved. *LB agar is the single exception:* it sets solid, so antibiotic must be mixed into the molten agar just before pouring. The antibiotic plates are therefore poured on Day 1 and used within their $tilde$1-month plate shelf life, both broths are stored plain and dosed per culture (Day 3 onward).]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Autoclave],
      [60 °C water bath to keep agar liquid],
      [Balance + weigh boats],
      [Static incubator at 37 °C],
      [Flame source],
      [Ice for antibiotics],
      [Autoclave-safe 500 mL bottles ($times$#{n_agar_bottles + 1}: #n_agar_bottles agar + 1 TB)],
      [Autoclave-safe 1 L bottles ($times$#n_lb_broth_bottles, for LB broth)],
      [Aluminium foil (for autoclave bottle caps)],
      [Autoclave tape + lab tape for labelling],
      [Sterile inoculation loops],
      [Sterile pipette tips],
      [Sterile petri dishes],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [LB-agar powder, Luria/Miller (#underline[_*_verify g/L on bottle label_*_])],
      [LB broth (Lennox) powder, e.g. Sigma L7658],
      [TB modified powder, e.g. Sigma T0918],
      [Glycerol (TB carbon source, *not* the 50% cryo-glycerol of Day 4)],
      [Sterile dH#sub[2]O],
      [Kanamycin stock: 50 mg/mL in dH#sub[2]O, 0.22 μm filter-sterilised, -20 °C],
      [Chloramphenicol stock: 34 mg/mL in EtOH, 0.22 μm filter-sterilised, -20 °C],
    )
  ],
)


=== Agar batch sizing

At #volume_per_plate_mL mL per plate, the #plates_per_antibiotic plates per condition require #agar_volume_required_mL mL of molten agar, make up #agar_volume_per_antibiotic_mL mL per bottle (#agar_volume_total_mL mL total across #n_agar_bottles bottles).


== Day 1A: Prepare and autoclave all media

Weigh out every medium first, then run them through the autoclave together (#{n_agar_bottles + n_lb_broth_bottles + 1} bottles: #n_agar_bottles agar, #n_lb_broth_bottles LB broth, 1 TB).

1. LB agar ($times$#n_agar_bottles bottles: Kan, Cam, Kan+Cam). Weigh out #lb_agar_mass_g g LB-agar powder into each of #n_agar_bottles separate 500 mL bottles and add #agar_volume_per_antibiotic_mL mL sterile dH#sub[2]O to each. Swirl to a uniform suspension. Pre-label the bottles Kan, Cam, and Kan+Cam - they are identical until antibiotic is added at pouring.

  #note[\ Calculation: #lb_agar_g_per_L g/L $times$ #{agar_volume_per_antibiotic_mL / 1000} L = #lb_agar_mass_g g per bottle. The #agar_volume_per_antibiotic_mL mL volume targets #plates_per_antibiotic plates at #volume_per_plate_mL mL each with margin for bottle residue. The Kan+Cam (double-selection) bottle is selection medium for the eventual transformed expression clone, pouring it from a full identical bottle banks plates for the later transformation step. Do *not* add antibiotic here - it goes into the molten agar at the pouring step (Part B).]

+ LB broth ( bottles). Weigh #lb_broth_mass_g g LB broth (Lennox) powder into each of #n_lb_broth_bottles separate 1 L bottles and add #lb_broth_volume_per_bottle_mL mL sterile dH#sub[2]O. Swirl to dissolve.

  #note[\ Calculation: #lb_broth_g_per_L g/L $times$ #{lb_broth_volume_per_bottle_mL / 1000} L = #lb_broth_mass_g g per bottle. Use 1 L bottles, not 500 mL - #lb_broth_volume_per_bottle_mL mL needs autoclave headroom. One bottle is earmarked per strain workflow, both are stored *antibiotic-free*.]

+ TB broth ($times$2 bottle). Weigh #tb_broth_mass_g g TB modified powder into a 500 mL bottle, add #tb_broth_volume_mL mL sterile dH#sub[2]O and #tb_glycerol_mL mL glycerol, and swirl to dissolve.

  #note[\ Calculation: #tb_broth_g_per_L g/L $times$ #{tb_broth_volume_mL / 1000} L = #tb_broth_mass_g g, plus glycerol at #tb_glycerol_mL_per_L mL/L = #tb_glycerol_mL mL. Glycerol is the TB carbon source and is heat-stable, so it goes in before autoclaving. Stored antibiotic-free, used for the expression culture in a later document.]

+ Loosely cap every bottle (do #underline[*NOT*] seal airtight) and cover each cap with aluminium foil. Apply autoclave tape and label each with medium, volume, date, and initials.

+ Find a water bottle that matches the biggest bottle inside of the autoclave. Place the integrated thermometer into this as this is the reference temperature for the autoclaver.

+ Autoclave all bottles together at 121 °C, 20 psi, there is usually a programme named "liquids" for this.
#v(10em)
#align(center)[
  *While the autoclave is running, set up the plate-pouring station near a burner for part B.*
]
#pagebreak()
== Day 1B: Pour antibiotic agar plates

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    Antibiotic is mixed into the molten agar just before pouring, the plates set with antibiotic locked in. Pour next to the flame. Adapted from the Addgene plate-pouring protocol - scan for the video walkthrough.
  ],
  [
    #qr-code("https://www.youtube.com/watch?v=ey19jM6y7-c", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      Plate Pouring Protocol
    ]]
  ],
)

1. Spray a section of lab bench with 70% ethanol and wipe with a paper towel.

+ Label each plate base (not the lid - lids get swapped) with conditions:
  - Kan#super[R] - two positives (+) and one negative (-)
  - Cam#super[R] - two positives (+) and one negative (-)
  - Kan#super[R]/Cam#super[R] - two positives (+) and one negative (-)
  - Pour date
  - Initials

+ Position the flame at the bench. Stack the labelled petri dishes per condition next to the flame.

+ Have both antibiotic stocks ready on ice. Keep the chloramphenicol tube away from direct sunlight, normal laboratory LED lighting is of no concern during working.

+ Retrieve the *#n_agar_bottles agar bottles* from the autoclave (leave the broths to cool - they are handled in Part C).

  #note[\ Once the autoclave is complete, open the door and leave it partially open for $tilde$10 min. This will release steam and will let the gel-mix cool a little bit. *#underline[Use thermally insulated gloves to remove the bottles.]*]

+ Let the agar bottles cool until you can touch it, but it has to be hot still at 55 °C.

+ Working next to the flame, add antibiotic to each bottle at 1:#antibiotic_dilution:
  - Kan bottle: #antibiotic_volume_uL μL of 50 mg/mL kanamycin stock
  - Cam bottle: #antibiotic_volume_uL μL of 34 mg/mL chloramphenicol stock
  - Kan+Cam bottle: #antibiotic_volume_uL μL kanamycin *and* #antibiotic_volume_uL μL chloramphenicol

  #note[\ The double-selection bottle takes both antibiotics, each at its own 1:#antibiotic_dilution - add them as two separate spikes and swirl between, rather than premixing. They do not interact, dosing independently keeps each at the correct final concentration.]

+ Swirl each bottle gently to distribute the antibiotic evenly. Avoid creating bubbles.

+ Use a pipetteboy with a 50 mL strip and apply $tilde$#volume_per_plate_mL mL per plate.

  #nb(title: "NB!")[\ If agar begins solidifying in the bottle stop pouring. Antibiotic has already been added, re-heating (microwave or autoclave) will degrade both kanamycin and chloramphenicol and the batch must be discarded. To avoid this, work briskly once the antibiotic is in - typical pour window from antibiotic addition to last plate is 10-15 min. Alternatively if you have a water bath at 60 °C this can be used to reheat the agar before it solidifies.]

#pagebreak()

10.  After pouring each plate, swirl gently to ensure even coverage and remove surface bubbles. Cap and stack. Work briskly, an agar plate can suddenly solidify a lot faster than expected.

+ Leave plates at room temperature to solidify, takes roughly 30 min. Once solidified, invert the plates (agar-side up) and place them directly into a sealed plastic bag. Keep them inverted so any future condensation collects on the lid, not the agar surface. You can place a folded paper towel in the bag to help absorb excess moisture.

+ Label the bag with the antibiotics, pour date, and your initials. Then spray the outside of the bag with 70% EtOH.

+ Store at 4 °C. Again keep any Chloramphenicol-containing plates (LB+Cam and LB+Kan/Cam) away from direct sunlight.

+ Plates are valid for 1 month from the pour date, but check the plates continuously. Discard any plates that show contamination, drying (cracks or shrinkage from plate edge), or condensation pooling on the agar.

== Day 1C: Cool and store broths

The LB and TB broths leave the autoclave with the agar but need no pouring - just cool and shelve them.

1. Let the LB broth ($times$#n_lb_broth_bottles) and TB broth bottles cool to room temperature on the bench, caps loosened and foil still on.

+ Confirm each bottle is clearly labelled (medium, volume, date, initials) and *antibiotic-free*. Tighten the caps once cool.

+ Store at 4 °C. The broths keep for up to $tilde$1 month antibiotic-free. Antibiotic is added per culture at the point of use (Day 3 onward), at 1:#antibiotic_dilution from the stocks above.

  #nb(title: "NB!")[\ Never dose a stored broth bottle. Add antibiotic only to the aliquot you are about to use - e.g. 5 mL culture + 5 μL of the relevant stock $arrow$ 1:#antibiotic_dilution. A whole bottle dosed with antibiotic loses activity within weeks and cannot be re-sterilised.]

#pagebreak()


== Day 2: Stab arrival and plate streaking

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    Streaking from the Addgene stabs serves two purposes simultaneously: (i) revival of the strains for downstream liquid culture, and (ii) bidirectional batch validation of the LB+Kan and LB+Cam plates via cross-streaking (see Day 1 Batch sizing). All plates are streaked together and incubated at 37 °C. Adapted from the Addgene plate-streaking protocol - scan the QR code for the video walkthrough.
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
  [Refrigerator at 4 °C (plate storage)],
  [Inculation loops],
  [Ice bucket],
)
  ],
  [
    #checkgroup(
      title: "Reagents & Materials",
      [Addgene stab #42365 (Mach1 cloning host with pNIC28-Bsa4-CTHA)],
      [Addgene stab #26242 (BL21(DE3)-R3-pRARE2 expression host)],
      [LB+Kan plates from day 1 batch],
      [LB+Cam plates from day 1 batch],
    )
  ],
)


=== Procedure

1. Take the Kan#super[R] and Cam#super[R] plates out and let them reach room temperature before streaking, as cold agar causes condensation and uneven streak distribution. Pre-warm at 37 °C for 10 min if heavy condensation is present.

+  Set up your sterile workspace. Use a fresh, sterile single-use plastic loop for every plate and every quadrant sector to avoid transferring antibiotic residues between selections, discard each loop after use and do not flame them. Because a loop has no loop, drag it lightly when spreading each quadrant so the agar is not gouged.

+ Streaking Mach1 (Stab #42365): Pick a small amount of growth from the #42365 stab using a sterile loop. Perform a standard four-quadrant streak to ensure isolated single colonies on the following:
  - 1 Kan#super[R] Plate (Mach1 workflow source): the plasmid-bearing host, this plate feeds the Day 3 miniprep culture.
  - 1 Cam#super[R] Plate (Cross-Control): Expect #underline[no growth] if Cam selection is functional.

+ Streaking BL21 (Stab #26242): Using a fresh sterile loop, pick a small amount of growth from the #26242 stab. Perform a standard four-quadrant streak on the following:
  - 2 LB+Cam Plates (BL21 - Plates A & B): Both are positive controls and your source for fresh colonies to make competent cells / transform on Day 3+.
  - 1 LB+Kan Plate (Cross-Control): Expect #underline[no growth] if Kan selection is functional.

+ Return both stabs to 4 °C immediately. #underline[Do not discard] - they remain your only verified source of viable starter material until the glycerol stocks are validated on Day 5.

+ Invert all plates (agar-side up) and incubate at 37 °C from Hour 0:
  - Mach1 Kan#super[R] plate -> colonies $tilde 8$ h.
  - Both BL21 Cam#super[R] positive plates -> colonies $tilde 14-16$ h.
  - Both Mach1 and BL21 negative cross-control plates.

+ As each plate develops good isolated colonies, move it to 4 °C (seal with Parafilm if storing more than a day or two). In practice the Mach1 plate is ready first and is fridged the same evening, the BL21 plates are fridged the following morning. Both then hold together at 4 °C until Day 3 - no revival step is needed before picking.

#pagebreak()

== Day 3: Inoculate liquid cultures

After overnight incubation, the positive streak plates (LB+Kan with #42365, LB+Cam with #26242) show isolated single colonies, the negative cross-control plates show no growth, confirming both antibiotic batches are functional. Pick #n_clones_mach1 well-isolated Mach1 colonies (clones C1-C#(n_clones_mach1)) and #n_clones_bl21 BL21 colony, each seeding its own overnight - #n_cultures_total cultures total.

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Shaking incubator, 37 °C, 200 rpm],
      [Sterile inoculation loops or toothpicks],
      [Sterile #culture_volume_mL mL culture tubes],
      [P10 / P200 sterile tips],
      [Bunsen burner / flame source],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [LB broth, sterile (from Day 1 batch, antibiotic-free)],
      [Kanamycin stock at 50 mg/mL],
      [Chloramphenicol stock at 34 mg/mL],
    )
  ],
)

=== Procedure

1. Near the flame, prepare #n_cultures_total culture tubes:
   - Cloning host (Mach1, #42365): #n_clones_mach1 tubes, C1-C#(n_clones_mach1), each #culture_volume_mL mL LB + #antibiotic_per_culture_uL μL Kan stock.
   - Expression host (BL21, #26242): #n_clones_bl21 tube (B1), #culture_volume_mL mL LB + #antibiotic_per_culture_uL μL Cam stock.

+ From the Kan#super[R] positive plate (#42365), pick #n_clones_mach1 separate well-isolated colonies into C1-C#(n_clones_mach1) - one colony per tube, fresh tip each.

  #note[\ Pick clearly isolated single colonies, not streak edges or confluent areas. Clonal identity of every downstream stock and miniprep depends on this. If colonies are too dense to resolve, re-streak from the backup plate first.]

+ From the Cam#super[R] positive plate (#26242), pick one well-isolated colony into B1.

+ Incubate at 37 °C, 180-200 rpm. Hold the Mach1 tubes to 5-6 h (or use the high-dilution overnight), let the BL21 tube run a full 14-16 h. Target OD#sub[600] = 2-4 (saturated) at harvest. Book shaker slots in advance if sharing.

  #note[\ Saturated overnight is the standard glycerol-stock input. Late-log (OD#sub[600] $tilde$1.5-2) gives marginally better post-thaw viability but needs daytime monitoring, saturated is the practical default and post-thaw viability stays $gt$95% for #emph[E. coli].]

#pagebreak()

== Day 4A: Archival glycerol stocks

Stocks are banked *per clone*. The #n_clones_mach1 Mach1 cultures (C1-C#(n_clones_mach1)) each yield #n_stocks_per_clone_mach1 cryotubes - #n_stocks_mach1 Mach1 tubes total - and the single BL21 culture (B1) yields #n_stocks_bl21. #n_stocks_total tubes in all. The tubes of any one clone are clonally identical: redundancy against tube failure, freezer accidents, and freeze-thaw degradation, not biological replicates.

The Mach1 (#42365) stocks are *provisional* until the Day 4B Sanger result identifies the verified clone - nothing on this strain enters the long-term archive unsequenced. The BL21 (#26242) stocks need no sequence gate: the colony's Cam#super[R] growth already confirms pRARE2 in a construct-free host.

#note(title: "What survives the gate")[\ After Sanger, keep the verified Mach1 clone's #n_stocks_per_clone_mach1 tubes and discard the other #{(n_clones_mach1 - 1) * n_stocks_per_clone_mach1} (the rejected clones). All #n_stocks_bl21 BL21 tubes are kept - no gate, single clone. Long-term archive retained: #n_stocks_per_clone_mach1 (Mach1, verified) + #n_stocks_bl21 (BL21) = #{n_stocks_per_clone_mach1 + n_stocks_bl21} tubes.]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Vortex],
      [Ice bucket],
      [-80 °C freezer (cryobox position pre-assigned)],
      [Liquid nitrogen dewar (optional, for snap-freeze)],
      [Screw-cap cryotubes, 2 mL, sterile ($times$#n_cryotubes_order)],
      [P1000 sterile tips],
      [Solvent-resistant cryo marker],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [Sterile 50% glycerol (autoclaved, room temperature)],
      [Day 3 overnight cultures (all #n_cultures_total)],
    )
  ],
)

#nb(title: "NB!")[\ Use screw-cap cryotubes, not snap-top. Snap-top tubes can open spontaneously at -80 °C and release the stock. Confirm they are sterilised.]

=== Procedure

1. Label #n_stocks_total cryotubes on both side wall and cap with a solvent-resistant cryo marker (or labeller): #n_stocks_per_clone_mach1 tubes per Mach1 clone (C1-C#(n_clones_mach1)) and #n_stocks_bl21 for the BL21 clone (B1), each label carrying clone ID, strain, date, and initials.

  #note[\ Adhesive labels detach at -80 °C over months, write directly on the tube and label wall + cap so identity survives if a face is rubbed during handling. A labelling machine is fine if available.]

+ Pre-chill all #n_stocks_total labelled cryotubes on ice.

+ To each cryotube add 500 μL sterile 50% glycerol + 500 μL of *that clone's* Day 3 overnight (Kan cultures C1-C#(n_clones_mach1) into their C-labelled tubes, the BL21 culture into the #n_stocks_bl21 B1 tubes). Final glycerol concentration 25% (v/v).

+ Cap tightly. Vortex briefly (2-3 s) to fully mix - confirm a single uniform solution with no glycerol layer at the bottom.

  #nb[\ Incomplete mixing leaves a glycerol gradient inside the tube - uneven cryoprotection and lower post-thaw viability.]

+ Snap-freeze in liquid nitrogen, then transfer to -80 °C. If LN#sub[2] is unavailable, transfer directly from ice to -80 °C - post-thaw viability is comparable for *E. coli* under either method.

  #nb(title: "Do not archive an unsequenced Mach1 clone")[\ The Mach1 tubes are provisional until Day 4B Sanger confirms one clone. They exist to avoid a re-grow, not to serve as the archive - the archive is the verified clone's set.]


== Day 4B - Plasmid isolation from the cloning host (GeneJET miniprep)

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    With a saturated overnight of the #42365 cloning host in hand (Kan#super[R], from the Day 3 inoculation), the plasmid is isolated by SDS/alkaline lysis and silica-column capture using the Thermo Scientific GeneJET Plasmid Miniprep Kit (K0502/K0503, User Guide MAN0012655). The eluate feeds directly into the verification digest and Sanger submission, and is the material later transformed into the #26242 expression host. Scan for the full kit user guide.
  ],
  [
    #qr-code("https://documents.thermofisher.com/TFS-Assets/LSG/manuals/MAN0012655_GeneJET_Plasmid_Miniprep_UG.pdf", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      GeneJET User Guide
    ]]
  ],
)

#note(title: "Copy number")[\ The kit's own vector table classes pBR322 and its derivatives as low-copy (10-50 copies/cell). pNIC28-Bsa4 is built on pET28a, a pBR322 derivative, so it is low-copy: use the upper end of the kit's range ($tilde$5-10 mL of saturated overnight) and expect modest yields, not the pUC-level output of a high-copy cloning vector. The column binds up to $tilde$20 μg dsDNA, for genuinely high-copy plasmids Thermo warns against exceeding 5 mL, which is not a constraint at this copy number but is the reason not to scale the input endlessly.]

#nb(title: "First-use kit prep")[\ Two reagents must be completed before the first prep or the run fails silently:
- Add ethanol (96-100%) to the Wash Solution concentrate - 35 mL into the 20 mL K0502 bottle, or 170 mL into the 100 mL K0503 bottle - then tick the checkbox on the bottlecap.
- Add the supplied RNase A to the Resuspension Solution and mix, store that bottle at 4 °C (stable 6 months). Skipping this leaves RNA in the eluate.]

#note(title: "Before each use")[\ Check the Lysis and Neutralization Solutions for salt precipitation. If any is present, warm the solution to 37 °C to redissolve, then cool back to 25 °C before use. Wear gloves throughout - the Lysis and Neutralization Solutions are irritants.]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Microcentrifuge (≥ 12 000 $times$ g)],
      [Benchtop centrifuge + 15 mL tube for harvest, _or_ a 1.5 mL tube for sequential harvest spins],
      [Vortex mixer],
      [GeneJET spin columns + collection tubes (in kit)],
      [Sterile 1.5 mL microcentrifuge tubes],
      [RNase-free micropipette tips (P200, P1000)],
      [Disposable gloves],
      [NanoDrop / UV spectrophotometer],
    )
  ],
  [
    #checkgroup(
      title: "Reagents (GeneJET Kit, K0502/K0503)",
      [#42365 cloning-host overnight (LB + Kan, Day 3)],
      [Resuspension Solution (+ RNase A added)],
      [Lysis Solution],
      [Neutralization Solution],
      [Wash Solution (+ ethanol added, first use)],
      [Elution Buffer (10 mM Tris-HCl, pH 8.5) or nuclease-free water],
      [Ethanol, 96-100% (for the first-use Wash Solution prep)],
      [Wash Solution I (R1611) + isopropanol - only if EndA#super[+], not needed here],
    )
  ],
)

#pagebreak()

=== Procedure

All steps are carried out at room temperature. Unless stated otherwise, every centrifugation is in a microcentrifuge at ≥ 12 000 $times$ g.

1. Harvest. Pellet $tilde$5-10 mL of the saturated #42365 overnight and remove all residual medium - leftover LB carries into the lysate and impairs the prep.
   - 1.5 mL-tube route: spin at $tilde$6800 $times$ g (8000 rpm) for 2 min, decant, and repeat onto the same pellet until the full volume is spun.
   - 15 mL-tube route: spin at 3000-5000 $times$ g for $tilde$10 min on a benchtop centrifuge, then resuspend in the 250 μL Resuspension Solution (next step) and transfer the suspension to a 1.5 mL tube.

  #note[\ Use a 12-16 h overnight, not an over-aged one - an old culture is the single most common cause of low yield. If you ever switch from LB to a rich medium like TB, cap growth at $tilde$12 h and reduce the input volume.]

+ Resuspend. Add 250 μL Resuspension Solution to the pellet and vortex (or pipette up and down) until completely homogeneous - no visible clumps.

  #note[\ Incomplete resuspension is the most common low-yield cause. Fully disperse the pellet before adding the Lysis Solution, no clumps should remain.]

+ Lyse. Add 250 μL Lysis Solution and mix by gently inverting the tube 4-6 times until the suspension turns viscous and slightly clear. Do not vortex.

  #nb[\ Never vortex after the Lysis Solution - shear liberates genomic DNA that co-purifies. Keep this step under 5 min: over-lysis denatures the plasmid, and denatured plasmid runs ahead of the supercoiled band on a gel and will not cut - directly sabotaging the verification digest this prep feeds into.]

+ Neutralize. Add 350 μL Neutralization Solution and immediately invert 4-6 times, gently but thoroughly (to avoid localised precipitation). The lysate turns cloudy as a fluffy white precipitate (SDS, protein, genomic DNA) forms.

+ Clear the lysate. Centrifuge for 5 min to pellet the cell debris and chromosomal DNA. A compact white pellet collects against the tube wall.

+ Bind. Decant or pipette the cleared supernatant onto a GeneJET spin column, avoiding the white precipitate. Centrifuge 1 min, discard the flow-through, and return the column to the same collection tube.

  #note[\ EndA#super[+] strains only: a preliminary wash with 500 μL Wash Solution I + isopropanol (spin 30-60 s, discard) precedes the ethanol washes to strip nuclease activity. Mach1 is endA#super[-], so skip it here - see the closing note.]

+ Wash ($times$2). Add 500 μL Wash Solution (ethanol-supplemented), centrifuge 30-60 s, and discard the flow-through. Repeat once, for two washes total.

+ Dry the membrane. Discard the flow-through, then centrifuge the empty column for 1 min to drive off residual Wash Solution.

  #nb[\ Do not skip the dry spin. Carried-over ethanol inhibits restriction digestion and Sanger sequencing - the two steps this plasmid is headed straight into.]

+ Elute. Transfer the column to a clean, labelled 1.5 mL tube. Since this is a low-copy plasmid *#underline[do not pipette the standard 50 μL]* Elution Buffer, instead pipette 30-40 μL to achieve a higher concentrated sample. Dispense it onto the centre of the membrane, without touching the membrane with the tip. Incubate 2 min, then centrifuge 2 min. The flow-through is the purified plasmid so *do not* throw away this eluent! Discard the filter column.

+ Quantify. Measure on the NanoDrop: expect A#sub[260]/A#sub[280] $tilde$1.8 and A#sub[260]/A#sub[230] $gt$ 2.0. Record concentration and volume.

+ Store. Keep the eluate at -20 °C until the verification digest and Sanger submission.

== Day 5A: Preparation of chemically competent BL21(DE3)-R3-pRARE2 (Inoue method)

The expression host is made chemically competent using the Inoue method (routinely yielding $10^7$–$10^8$ cfu/μg). Rather than running a standard, liter-scale prep that yields hundreds of unnecessary tubes, this protocol downsizes the absolute volumes to match your needs. Everything scales from a single variable in `parameters.typ` (`cc_culture_mL`, the main-culture volume).

Crucially, the culture-to-final-resuspension ratio is kept near the textbook Inoue value ($tilde.op$12:1). Because only the overall scale shrinks, per-aliquot competence remains entirely unaffected. The workflow uses the QC-confirmed BL21 glycerol stock from Day 5 as the starter source.

#note(title: "Timing")[\ A same-day prep. Grow a starter in LB (overnight, or $tilde$4-6 h to turbidity), make the Inoue TB fresh, then subculture into the main SOB flask and grow at 37 °C; first OD#sub[600] read at $tilde$2 h, then every $tilde$30 min until 0.4-0.5 ($tilde$2-3 h total). Reserve $tilde$2 h of uninterrupted cold work for the harvest - it cannot be paused partway.]

=== Buffers & reagents

Prepare the three solutions in the order below. SOB and the PIPES stock can both be made ahead and stored; the Inoue TB is made up *fresh on the day* and needs the PIPES stock, so PIPES comes first.

#nb(title: "Two opposite sterilisation rules")[\ *Inoue TB - filter-sterilise only, never autoclave.* Heat oxidises the Mn#super[2+] and kills the prep; freshly made buffer is colourless, so discard any batch with a tan/brown tint or precipitate. \ *Mg stock (2 M MgCl#sub[2]) - autoclave.* It is a heat-stable inorganic salt; it goes into the SOB *after* the base is autoclaved only because it precipitates with media components during the cycle, not because it is heat-labile.]

*A. SOB medium ($tilde$#cc_sob_make_mL mL) — main growth culture (+ OD blank); autoclave; may be made ahead.*

1. Dissolve #massfmt(cc_sob_tryptone_g) tryptone and #massfmt(cc_sob_yeast_g) yeast extract in $tilde$40 mL water.
+ Add #cc_sob_nacl_stock_mL mL 1 M NaCl and #cc_sob_kcl_stock_mL mL 1 M KCl from stock (these replace weighing the sub-100 mg NaCl/KCl by hand), then make up to $tilde$#cc_sob_base_mL mL.
+ Autoclave, then cool to room temperature.
+ Add #cc_sob_mgcl2_mL mL *autoclaved* 2 M MgCl#sub[2] (20 mM Mg#super[2+], final).

_NaCl is 0.5 g/L, not the 5 g/L misprint on the Untergasser sheet. The Mg (competence-supporting, omitted from that bare recipe) is supplied here as 20 mM MgCl#sub[2] in place of the canonical 10 mM MgCl#sub[2] + 10 mM MgSO#sub[4] - equivalent total Mg#super[2+]. The starter runs in LB, not SOB._

*1 M NaCl and 1 M KCl stocks — standing lab reagents; make ahead if not on hand.*

1. 1 M NaCl: dissolve #massfmt(cc_nacl_stock_mass_g) NaCl in water to #cc_salt_stock_make_mL mL; autoclave.
+ 1 M KCl: dissolve #massfmt(cc_kcl_stock_mass_g) KCl in water to #cc_salt_stock_make_mL mL; autoclave.

_Both keep at room temperature. Each SOB batch uses #cc_sob_nacl_stock_mL mL NaCl and #cc_sob_kcl_stock_mL mL KCl, so #cc_salt_stock_make_mL mL of each lasts a long time. These are the salts that were awkward to weigh as solids (#massfmt(cc_sob_nacl_g) NaCl, #massfmt(cc_sob_kcl_g) KCl per batch), which is why they are pipetted from stock instead._

*2 M MgCl#sub[2] stock ($tilde$#cc_mgcl2_stock_make_mL mL) — make ahead; autoclave separately; standing lab reagent.*

1. Dissolve #massfmt(cc_mgcl2_stock_mass_g) anhydrous MgCl#sub[2] in $tilde$35 mL water (strongly exothermic - add slowly and let it cool), then make up to #cc_mgcl2_stock_make_mL mL.
+ Autoclave (cap loosened) in its own bottle, *never combined with the SOB base*. Store at room temperature.

_Each SOB batch uses only #cc_sob_mgcl2_mL mL, so #cc_mgcl2_stock_make_mL mL covers $tilde$#cc_mgcl2_preps_supplied preps. If using the hexahydrate (MgCl#sub[2]·6H#sub[2]O, MW 203.30) instead, weigh 20.33 g for the same #cc_mgcl2_stock_make_mL mL._

*B. 0.5 M PIPES stock (100 mL) — make ahead; keeps frozen for months.*

1. Dissolve 15.1 g PIPES in $tilde$80 mL water (it will not clear until the pH is raised).
+ Titrate to pH 6.7 with KOH. If you overshoot, bring it back down with HCl.
+ Bring to 100 mL, aliquot, and store at -20 °C.

_This is the one stable, manganese-free component: a single frozen batch supplies many preps and feeds the Inoue TB below._

*C. Inoue Transformation Buffer (Inoue TB, $tilde$#cc_inoue_make_mL mL) — MAKE FRESH on the day; keep ice-cold.*

1. Dissolve #massfmt(cc_inoue_mncl2_g) MnCl#sub[2]·4H#sub[2]O (55 mM), #massfmt(cc_inoue_cacl2_g) anhydrous CaCl#sub[2] (15 mM) and #massfmt(cc_inoue_kcl_g) KCl (250 mM) in water.
+ Add #cc_inoue_pipes_mL mL of the 0.5 M PIPES stock last (10 mM final) and bring to volume.
+ Filter-sterilise (0.22 μm) - *never autoclave* - and keep on ice. Confirm the buffer is colourless before use.

_Only $tilde$#calc.round(cc_inoue_usage_mL, digits: 1) mL is used per prep; the batch is sized up so the salt masses stay weighable - discard the surplus, and once it is mixed do *not* store it. CaCl#sub[2] is the anhydrous form; for the dihydrate (CaCl#sub[2]·2H#sub[2]O, MW 147.02) weigh #massfmt(cc_inoue_cacl2_dihydrate_g) instead for the same batch._

*D. DMSO — have on hand.* Molecular-biology grade, added to $tilde$#calc.round(cc_dmso_fraction * 100, digits: 0)% (v/v) final at the resuspension step. Solid below $tilde$18 °C, so bring it to room temperature before use.

#pagebreak()

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Refrigerated centrifuge + rotor for 50 mL tubes ($tilde$2500 $times$ g, 4 °C)],
      [Shaking incubator, 37 °C],
      [Spectrophotometer (OD#sub[600]) + cuvettes],
      [Flask $gt.eq$ 4$times$ the culture volume (for the #cc_culture_mL mL culture)],
      [Sterile 50 mL centrifuge tubes ($times$1-2)],
      [0.22 μm syringe filters + syringes (for fresh Inoue TB)],
      [Ice-water bath; cold-room access],
      [Liquid nitrogen + dewar],
      [Pre-chilled #cc_aliquot_volume_uL μL aliquot tubes ($times$#cc_tubes_to_chill); repeat pipettor],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [BL21(DE3)-R3-pRARE2 glycerol stock (Day 4A, QC-confirmed Day 5)],
      [LB broth (Day 1) - for the starter culture],
      [SOB medium, sterile (+ autoclaved Mg added) - main culture + OD blank],
      [Inoue TB, *made fresh*, ice-cold, filter-sterilised],
      [0.5 M PIPES stock (frozen)],
      [DMSO, molecular-biology grade],
      [For QC: pUC19 control plasmid; LB-Amp plates; SOC],
    )
  ],
)

=== Procedure

Once the cells are chilled (the chill step onward), work on ice or in the cold room. The one rule that matters above all: don't let the cells warm up again.

1. Make the Inoue TB fresh. Prepare #cc_inoue_make_mL mL from the frozen PIPES stock (above), pass it through a 0.22 μm filter, and keep it on ice. It should be colourless - if it isn't, remake it.

+ Set the OD blank aside. Keep $tilde$#cc_blank_mL mL of sterile SOB at 4 °C to blank against in the morning.

+ Get the starter going. Inoculate #cc_starter_mL mL LB (from the Day 1 broth) with a scrape off the BL21 glycerol stock - no antibiotic. Shake at 37 °C, 200 rpm, until it turns turbid - overnight, or $tilde$4-6 h if you start it the same day.

+ Set up the main culture. Inoculate #cc_culture_mL mL SOB 1:100 with $tilde$#cc_starter_inoc_mL mL of the starter - no antibiotic. Use a flask at least 4× the volume and keep it under a quarter full so it aerates, then shake at 37 °C, 200 rpm.

+ Watch the OD. First reading at $tilde$2 h, then every $tilde$30 min, blanking on the SOB you set aside. Harvest at OD#sub[600] 0.4-0.5 - aim for $tilde$0.45, and don't let it run past 0.5, since competence drops off fast above that.

+ Chill the culture. At the target OD, sit the flask in an ice-water bath for 10 min. Everything from here stays cold.

+ Harvest. Spin at $tilde$2500 $times$ g for 10 min at 4 °C in a 50 mL tube and pour off all the medium. The pellet is small at this scale, so pour slowly and keep an eye on it.

+ First wash. Resuspend the pellet gently in $tilde$#cc_wash_mL mL ice-cold Inoue TB - swirl it, don't vortex.

+ Spin again. $tilde$2500 $times$ g, 10 min, 4 °C; pour off the supernatant.

+ Resuspend. Take the pellet up gently in #cc_resuspension_mL mL ice-cold Inoue TB.

+ Add the DMSO. Add #cc_dmso_mL mL room-temperature DMSO ($tilde$#calc.round(cc_dmso_fraction * 100, digits: 0)% final) dropwise while swirling - dumping it in all at once is locally toxic to the cells. Don't vortex. Leave on ice for 10 min.

+ Aliquot and snap-freeze. Working on ice, pipette #cc_aliquot_volume_uL μL into pre-chilled tubes ($tilde$#cc_aliquots_round usable, out of #cc_aliquots_theoretical possible from #calc.round(cc_final_volume_mL, digits: 2) mL) and drop each tube straight into liquid nitrogen. Don't just put them in the -80 to freeze slowly - that costs you efficiency. It goes fastest with two people, one filling and the other capping and dropping them in. Store at -80 °C.

#pagebreak()

== Day 6: Transformation of pNIC28-Bsa4-CTHA into competent BL21(DE3)-R3-pRARE2

The Sanger-verified construct (miniprep #42365, Kan#super[R]) is introduced into the freshly made competent BL21(DE3)-R3-pRARE2 by standard 42 °C heat shock, recovered in LB, and plated under dual selection on Kan + Cam. A short DNA titration (a few plasmid amounts plus a no-DNA control) is run to settle on an amount that reliably gives transformants.

#nb(title: "Selection logic and success criterion")[\ The introduced plasmid carries Kan#super[R]; the resident pRARE2 carries Cam#super[R]. Plating on *Kan + Cam* selects for both at once: Kan needs the new construct, Cam needs pRARE2. A colony on Kan + Cam therefore has both, which is exactly the expression strain you want. That plate is the readout, so no separate efficiency QC is needed: colonies on the dual plate, with a clean no-DNA control, is success.]

#note(title: "Timing")[\ About 2 h of bench work (thaw, set up, heat shock, recover), then an overnight plate incubation. The recovery (outgrowth) step is not optional here, because kanamycin resistance has to be expressed before the cells meet Kan; ampicillin is forgiving about this, Kan is not.]

=== Plasmid titration

You do not have to calculate anything to run this: just pipette a few fixed volumes of the verified miniprep straight into the cells, #tf_dna_lo_uL μL, #tf_dna_mid_uL μL and #tf_dna_hi_uL μL, plus a no-DNA control (#tf_n_reactions tubes in total).

The volume is tied to your Nanodrop reading only as a clue to how much DNA that is: mass delivered = volume × concentration. We measured C2 to #tf_miniprep_ng_uL ng/μL, the three volumes deliver about #tf_dna_lo_ng ng, #tf_dna_mid_ng ng and #tf_dna_hi_ng ng, all comfortably in the useful range (a verified plasmid into competent cells needs only tens of ng). Keep the largest at #tf_dna_hi_uL μL (about 10% of the #tf_cells_uL μL of cells), since going higher just dilutes the cells without helping.

_If you re-elute or re-measure the miniprep, update `tf_miniprep_ng_uL` in `parameters.typ` and the delivered masses recompute. Concentration affects only the ng-per-μL, not whether the transformation works, so the volumes above stand regardless._

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment",
      [Water bath, #tf_heatshock_C °C],
      [Shaking incubator, 37 °C (recovery)],
      [Static incubator, 37 °C (plates)],
      [Ice bucket],
      [Sterile microcentrifuge or 14 mL round-bottom tubes ($times$#tf_n_reactions)],
      [Sterile spreader or glass beads],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [Competent BL21(DE3)-R3-pRARE2 (Day 5A; #tf_n_reactions aliquots)],
      [Verified pNIC28-Bsa4-CTHA miniprep (#42365, Day 4B)],
      [LB medium, no antibiotic (recovery)],
      [LB-agar + Kan (#tf_kan_ug_mL μg/mL) + Cam (#tf_cam_ug_mL μg/mL) plates (Day 1 bank)],
    )
  ],
)

=== Procedure

1. Thaw the cells. Take #tf_n_reactions aliquots (one per reaction) from the -80 °C and thaw on ice, 20 to 30 min. Keep them cold.

+ Warm the plates. Take the Kan + Cam plates from 4 °C, bring to room temperature, and (optional) dry them at 37 °C so the surface takes up the liquid when you plate.

+ Set up the reactions. Into each tube of #tf_cells_uL μL cells, pipette the planned volume of miniprep: #tf_dna_lo_uL μL, #tf_dna_mid_uL μL, #tf_dna_hi_uL μL, and nothing in the control tube. Mix by flicking the bottom of the tube gently a few times. Do not pipette up and down, and do not vortex.

+ Ice. Hold the tubes on ice for #tf_ice_pre_min min.

+ Heat shock. Put the lower half to two-thirds of each tube into the #tf_heatshock_C °C water bath for #tf_heatshock_s s, then move straight back to ice.

+ Ice again. #tf_ice_post_min min on ice.

+ Recover. Add #tf_recovery_LB_uL μL LB (no antibiotic) to each tube, giving $tilde$#tf_recovery_total_mL mL, and shake at 37 °C, $tilde$225 rpm, for #tf_recovery_min min. For decent aeration, recover in a 14 mL round-bottom tube, or lay a microcentrifuge tube on its side.

+ Plate. Spread #tf_plate_uL μL of each reaction on its own Kan + Cam plate (a fixed volume keeps the titration comparable), and plate the control the same way. If you expect few transformants, pellet the cells gently, pour off most of the LB, resuspend in $tilde$100 μL, and plate all of it, so there is not too much liquid on the agar. Let the liquid soak in before inverting.

+ Incubate. 37 °C overnight.

#note(title: "Reading the result")[\ Transformants are colonies on the Kan + Cam plates; the no-DNA control should stay blank. Any growth on the control means contamination or non-selective plates, and the run is void. Pick well-separated colonies for the expression work. If you want to confirm the cells themselves were alive and still pRARE2-positive, streak a little of the no-DNA recovery on a Cam-only plate: growth there, with nothing on Kan + Cam, shows live pRARE2-bearing cells that simply did not take up the construct.]

#pagebreak()

== Day 7: Banking the expression strain (#strain_express_short)

The Kan + Cam colonies from Day 5B are the finished expression strain: BL21(DE3)-R3-pRARE2 now carrying pNIC28-Bsa4-CTHA. This day repeats the Day 3/4 workflow (pick colonies, grow overnights, make glycerol stocks), with three modifications:

- *Dual selection throughout.* Every culture here carries *both* Kan (#tf_kan_ug_mL μg/mL) and Cam (#tf_cam_ug_mL μg/mL): Kan holds the CTHA construct, Cam holds pRARE2.
- *Source is the Day 5B transformant plate*, not the original streak. Pick #n_clones_express well-separated colonies (c1, c2, c3) as independent clones.
- *Banking only.* The overnights are small (#express_overnight_mL mL), just enough for glycerol stocks. The litre-scale TB expression cultures belong to the expression protocol, not here.

#nb(title: "Strain name and tube labels")[\ Record the strain two ways: *#strain_express_full* for strain records and the methods section (host slash plasmid, genotype-style), and *#strain_express_short* for the freezer and everyday use. With #n_clones_express clones and #n_stocks_per_clone_express stocks each, label tubes clone.stock: #(strain_express_short + "-c1.1"), -c1.2, -c1.3, -c2.1 ... -c3.3 (#n_stocks_express stocks in total).]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment",
      [Shaking incubator, 37 °C],
      [Sterile culture tubes ($times$#n_clones_express)],
      [Cryovials ($times$#cryotubes_express_order)],
      [-80 °C freezer],
    )
  ],
  [
    #checkgroup(
      title: "Reagents",
      [Day 5B Kan + Cam transformant plate],
      [LB medium],
      [Kanamycin stock, 50 mg/mL; chloramphenicol stock, 34 mg/mL],
      [Sterile 50% glycerol],
    )
  ],
)

=== Procedure (as Day 3/4, dual-selection)

1. Pick colonies. From the Day 5B Kan + Cam plate, pick #n_clones_express well-separated colonies (c1, c2, c3) with a sterile tip or loop.

+ Overnights. Inoculate each colony into #express_overnight_mL mL LB + #express_kan_uL μL Kan + #express_cam_uL μL Cam. Shake at 37 °C, 200 rpm, overnight to saturation.

+ Check growth. Confirm each overnight is turbid. A clear tube means that clone did not grow; do not bank it.

+ Make glycerol stocks. For each clone, mix #glycerol_culture_uL μL of the overnight with #glycerol_stock_uL μL sterile 50% glycerol (25% final) in a labelled cryovial, #n_stocks_per_clone_express per clone. Mix by inversion.

+ Store the glycerol stocks at -80 °C.


#bibliography(
  "protocols.bib",
  title: auto,
  style: "apa",
)