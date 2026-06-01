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

#nb[\ Before you go through this protocol check that you have everything needed such as materials and equipemnt. Especially check if you need to book equipment in advance!]

== Day 1: Media preparation (autoclave batch)

All media that need sterilising are prepared in one session on Day 1. The autoclave cycle is the slow, rate-limiting step of the whole workflow, so everything that has to pass through it - plate agar, starter/overnight broth, and the high-density expression broth - is batched into a single run rather than spread across the week.

#note(title: "Storage rule")[\ Autoclaved media *without antibiotic* keep at 4 °C for up to $tilde$1 month. Antibiotic is added only at the point of use, never to a stored bottle - kanamycin and chloramphenicol both lose activity over weeks in solution, and antibiotic media cannot be re-autoclaved. *LB agar is the single exception:* it sets solid, so antibiotic must be mixed into the molten agar just before pouring. The antibiotic plates are therefore poured on Day 1 and used within their $tilde$1-month plate shelf life; both broths are stored plain and dosed per culture (Day 3 onward).]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Autoclave],
      [60 °C water bath],
      [Balance + weigh boats],
      [Static incubator at 37 °C],
      [Bunsen burner / flame source],
      [Ice for antibiotics],
      [Dark or foil-wrapped tube rack (for Cam stock)],
      [Autoclave-safe 500 mL bottles ($times$#{n_agar_bottles + 1}: #n_agar_bottles agar + 1 TB)],
      [Autoclave-safe 1 L bottles ($times$#n_lb_broth_bottles, for LB broth)],
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
      [LB-agar powder, Luria/Miller (verify g/L on bottle label)],
      [LB broth (Lennox) powder, e.g. Sigma L7658],
      [TB modified powder, e.g. Sigma T0918],
      [Glycerol (TB carbon source; *not* the 50% cryo-glycerol of Day 4)],
      [Sterile dH#sub[2]O],
      [Kanamycin stock: 50 mg/mL in dH#sub[2]O, 0.22 μm filter-sterilised, $-$20 °C],
      [Chloramphenicol stock: 34 mg/mL in EtOH, 0.22 μm filter-sterilised, $-$20 °C, kept dark],
    )
  ],
)


=== Agar batch sizing

At #volume_per_plate_mL mL per plate, the #plates_per_antibiotic plates per condition require #agar_volume_required_mL mL of molten agar; make up #agar_volume_per_antibiotic_mL mL per bottle (#agar_volume_total_mL mL total across #n_agar_bottles bottles).


=== Procedure - Part A: Suspend and autoclave all media

Weigh out every medium first, then run them through the autoclave together (#{n_agar_bottles + n_lb_broth_bottles + 1} bottles: #n_agar_bottles agar, #n_lb_broth_bottles LB broth, 1 TB).

1. LB agar ($times$#n_agar_bottles bottles: Kan, Cam, Kan+Cam). Weigh #lb_agar_mass_g g LB-agar powder into each of #n_agar_bottles separate 500 mL bottles and add #agar_volume_per_antibiotic_mL mL sterile dH#sub[2]O to each. Swirl to a uniform suspension. Pre-label the bottles Kan, Cam, and Kan+Cam - they are identical until antibiotic is added at pouring.

  #note[\ Calculation: #lb_agar_g_per_L g/L $times$ #{agar_volume_per_antibiotic_mL / 1000} L = #lb_agar_mass_g g per bottle. The #agar_volume_per_antibiotic_mL mL volume targets #plates_per_antibiotic plates at #volume_per_plate_mL mL each with margin for bottle residue. The Kan+Cam (double-selection) bottle is selection medium for the eventual transformed expression clone; pouring it from a full identical bottle banks plates for the later transformation step. Do *not* add antibiotic here - it goes into the molten agar at the pouring step (Part B).]

+ LB broth ( bottles). Weigh #lb_broth_mass_g g LB broth (Lennox) powder into each of #n_lb_broth_bottles separate 1 L bottles and add #lb_broth_volume_per_bottle_mL mL sterile dH#sub[2]O. Swirl to dissolve.

  #note[\ Calculation: #lb_broth_g_per_L g/L $times$ #{lb_broth_volume_per_bottle_mL / 1000} L = #lb_broth_mass_g g per bottle. Use 1 L bottles, not 500 mL - #lb_broth_volume_per_bottle_mL mL needs autoclave headroom. One bottle is earmarked per strain workflow; both are stored *antibiotic-free*.]

+ TB broth ($times$2 bottle). Weigh #tb_broth_mass_g g TB modified powder into a 500 mL bottle, add #tb_broth_volume_mL mL sterile dH#sub[2]O and #tb_glycerol_mL mL glycerol, and swirl to dissolve.

  #note[\ Calculation: #tb_broth_g_per_L g/L $times$ #{tb_broth_volume_mL / 1000} L = #tb_broth_mass_g g, plus glycerol at #tb_glycerol_mL_per_L mL/L = #tb_glycerol_mL mL. Glycerol is the TB carbon source and is heat-stable, so it goes in before autoclaving. Stored antibiotic-free; used for the expression culture in a later document.]

+ Loosely cap every bottle (do #underline[*NOT*] seal airtight) and cover each cap with aluminium foil. Apply autoclave tape and label each with medium, volume, date, and initials.

+ Find a water bottle that matches the biggest bottle inside of the autoclave. Place the integrated thermometer into this as this is the reference temperature for the autoclaver.

+ Autoclave all bottles together at 121 °C, 20 psi, for ≥ 30 min.
#v(10em)
#align(center)[
  *While the autoclave is running, set up the plate-pouring station near a burner for part B.*
]
#pagebreak()
=== Procedure - Part B: Pour antibiotic agar plates

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    Antibiotic is mixed into the molten agar just before pouring; the plates set with antibiotic locked in. Pour next to the flame. Adapted from the Addgene plate-pouring protocol - scan for the video walkthrough.
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

  #nb(title: "NB!")[\ If agar begins solidifying in the bottle stop pouring. Antibiotic has already been added, re-heating (microwave or autoclave) will degrade both kanamycin and chloramphenicol and the batch must be discarded. To avoid this, work briskly once the antibiotic is in - typical pour window from antibiotic addition to last plate is 10-15 min.]

#pagebreak()

10.  After pouring each plate, swirl gently to ensure even coverage and remove surface bubbles. Cap and stack. Work briskly, it is not an exact science, an agar plate can suddenly solidify compared to other plates out of nowhere.


+ Leave plates at room temperature to solidify, takes roughly 30 min. Once solidified, invert the plates (agar-side up) and place them directly into a sealed plastic bag. Keep them inverted so any future condensation collects on the lid, not the agar surface. You can place a folded paper towel in the bag to help absorb excess moisture.

+ Label the bag with the antibiotics, pour date, and your initials. Then spray the outside of the bag with 70% EtOH.

+ Store at 4 °C. Again keep any Chloramphenicol-containing plates (LB+Cam and LB+Kan/Cam) away from direct sunlight.

+ Plates are valid for 1 month from the pour date, but check the plates continuously. Discard any plates that show contamination, drying (cracks or shrinkage from plate edge), or condensation pooling on the agar.

=== Procedure - Part C: Cool and store broths

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
    Streaking from the Addgene stabs serves two purposes simultaneously: (i) revival of the strains for downstream liquid culture, and (ii) bidirectional batch validation of the LB+Kan and LB+Cam plates via cross-streaking (see Day 1 Batch sizing). All plates are streaked together and incubated at 37 °C; because the two strains finish at different times, each plate is moved to 4 °C as its colonies are ready and held there until Day 3 - no staggered streaking or timing is required. Adapted from the Addgene plate-streaking protocol - scan the QR code for the video walkthrough.
  ],
  [
    #qr-code("https://www.youtube.com/watch?v=P6HlqmYEcZM", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      Plate Streaking Protocol
    ]]
  ],
)

#nb(title: "Growth Timelines & 4 °C Hold")[\
Mach1 (Stab #42365) is one of the fastest cloning hosts available: isolated colonies are clearly visible $tilde 8$ h after plating at 37 °C. BL21(DE3)-R3-pRARE2 (Stab #26242) carries the pRARE2 helper plasmid under chloramphenicol selection and grows more slowly, typically needing $tilde 14-16$ h for comparable colonies; some constructs are slower still due to basal-expression toxicity.

The two strains do *not* need to finish at the same time. Streak everything together at Hour 0 and incubate at 37 °C. As each plate develops good isolated colonies, move it to 4 °C - Mach1 first ($tilde 8$ h), BL21 the following morning. Both plates then sit ready in the fridge together until Day 3.

Cold storage simply pauses the colonies; it does not harm them or require any "revival" step. A colony picked from a 4 °C plate inoculates a liquid culture exactly as well as a fresh one. Streaked plates hold reliably for $tilde$2 weeks at 4 °C (longer if sealed with Parafilm), so there is no need to time the streak or pick colonies the moment they appear.]

#nb(title: "NB!")[\ Store both Addgene stabs at 4 °C immediately on arrival, or place on ice if streaking the same day. The stabs survive at 4 °C for up to 2 weeks, but glycerol stocks (Day 4) should be made within the first 5 days to maximise safety margin.]

#checklist(
  cols: 2,
  [
    #checkgroup(
  title: "Equipment & Consumables",
  [Static incubator at 37 °C],
  [Refrigerator at 4 °C (plate storage)],
  [Sterile single-use plastic inoculating needles],
  [Ice bucket],
  [Parafilm (optional, for sealing stored plates)],
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
#pagebreak()
=== Procedure

1. Take the Kan#super[R] and Cam#super[R] plates out and let them reach room temperature before streaking, as cold agar causes condensation and uneven streak distribution. Pre-warm at 37 °C for 10 min if heavy condensation is present.

+  Set up your sterile workspace. Use a fresh, sterile single-use plastic needle for every plate and every quadrant sector to avoid transferring antibiotic residues between selections; discard each needle after use and do not flame them. Because a needle has no loop, drag it lightly when spreading each quadrant so the agar is not gouged.

+ Streaking Mach1 (Stab #42365): Pick a small amount of growth from the #42365 stab using a sterile loop. Perform a standard four-quadrant streak to ensure isolated single colonies on the following:
  - 1 Kan#super[R] Plate (Mach1 workflow source): the plasmid-bearing host; this plate feeds the Day 3 miniprep culture.
  - 1 Cam#super[R] Plate (Cross-Control): Expect #underline[no growth] if Cam selection is functional.

+ Streaking BL21 (Stab #26242): Using a fresh sterile loop, pick a small amount of growth from the #26242 stab. Perform a standard four-quadrant streak on the following:
  - 2 LB+Cam Plates (BL21 - Plates A & B): Both are positive controls and your source for fresh colonies to make competent cells / transform on Day 3+.
  - 1 LB+Kan Plate (Cross-Control): Expect #underline[no growth] if Kan selection is functional.

+ Return both stabs to 4 °C immediately. #underline[Do not discard] - they remain your only verified source of viable starter material until the glycerol stocks are validated on Day 5.

+ Invert all plates (agar-side up) and incubate at 37 °C from Hour 0:
  - Mach1 Kan#super[R] plate -> colonies $tilde 8$ h.
  - Both BL21 Cam#super[R] positive plates -> colonies $tilde 14-16$ h.
  - Both Mach1 and BL21 negative cross-control plates.

+ As each plate develops good isolated colonies, move it to 4 °C (seal with Parafilm if storing more than a day or two). In practice the Mach1 plate is ready first and is fridged the same evening; the BL21 plates are fridged the following morning. Both then hold together at 4 °C until Day 3 - no revival step is needed before picking.

#pagebreak()

== Day 3: Inoculate liquid cultures

After overnight incubation, the positive streak plates (LB+Kan with #42365; LB+Cam with #26242) should show isolated single colonies. The negative cross-control plates should show no growth - this confirms both antibiotic batches are functional. Pick one well-isolated colony per strain to seed a liquid culture.

#nb(title: "CRITICAL LIQUID GROWTH RATE DELAY")[\
Mach1 reaches full saturation within roughly 4 to 6 hours from a standard colony inoculation. Leaving it for a full 16 h overnight pushes it well past that point, into over-aging that lowers plasmid yield from the Day 4B miniprep this culture feeds. Conversely, BL21(DE3)-R3-pRARE2 requires a full 14–16 hours overnight to reach saturation, due to the metabolic load of the pRARE2 helper plasmid.
To harvest both cultures at peak viability, use one of the following timing mechanisms:
1. Staggered Timeline: Inoculate the Mach1 tube in the morning of Day 3 (harvests 5 hours later in the afternoon); inoculate the BL21 tube in the late evening of Day 3 (harvests the following morning).
2. High Dilution Overnight: If inoculating both simultaneously in the evening, pick a normal single colony for BL21, but perform a 1:1000 micro-dilution of the picked colony for Mach1 to intentionally extend its lag phase through the night.
]

#checklist(
  cols: 2,
  [
    #checkgroup(
      title: "Equipment & Consumables",
      [Shaking incubator, 37 °C, 200 rpm],
      [Sterile inoculation loops or toothpicks (x4)],
      [Sterile 50 mL culture tubes (x2)],
      [P10 sterile tips],
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

1. Near the flame, prepare two culture tubes:
   - Cloning host tube (Mach1): 10 mL LB + 10 μL Kan stock.
   - Expression host tube (BL21): 10 mL LB + 10 μL Cam stock.

2. Using a sterile loop or pipette tip, pick a single well-isolated colony from the Kan#super[R] positive plate (#42365). If inoculating for a daytime sprint, drop the entire tip into the tube and gently swirl. If inoculating for an extended overnight run, lightly touch the colony and dilute into the medium minimally to avoid premature overgrowth.

  #note[\ Pick from a clearly isolated single colony, not a streak edge or confluent area. Clonal identity of every downstream glycerol stock depends on this step. If colonies are too dense to resolve a single one, re-streak from the backup plate before proceeding.]

3. Using a fresh sterile tip, pick a single well-isolated colony from the Cam#super[R] positive plate (#26242) and drop the tip directly into the BL21 culture tube.

4. Incubate both tubes at 37 °C on a shaking incubator set to 200 rpm, keeping the Mach1 incubation time restricted to 5–6 hours (or using the high-dilution overnight method) while letting the BL21 shake for a full 14–16 hours. Target OD#sub[600] = 2-4 (saturated culture) at the time of harvest. Ensure incubator slots are booked in advance if sharing shaker space.

  #note[\ Overnight saturated culture is the standard input for glycerol stocks. Late-log phase (OD#sub[600] $tilde$ 1.5-2) gives marginally higher post-thaw viability but requires rigorous daytime monitoring; saturated culture is the practical default and post-thaw viability remains $gt$ 95% for E. coli under standard glycerol freezing.]

#pagebreak()

== Day 4A: Archival glycerol stocks

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

#nb(title: "NB!")[\ Use *screw-cap* cryotubes, not snap-top. Snap-top tubes can open spontaneously at $-$80 °C and release the stock. Make sure they have been steralized!]

=== Procedure

1. Label 8 cryotubes (4 per strain) on *both the side wall and the cap* with a solvent-resistant cryo marker. Each label must include:

   #note[\
   Adhesive labels detach at $-$80 °C over months. Writing directly on the tube with a cryo-rated marker is the lab standard. Labelling both the wall *and* the cap ensures identification even if a label face is rubbed off during handling. Or use a labeling machine if available.]

+ Pre-chill the 8 labelled cryotubes on ice.

+ To each cryotube, add:
  - 500 μL sterile 50% glycerol
  - 500 μL overnight culture (#42365 culture for the 4 Kan-labelled tubes; #26242 culture for the 4 Cam-labelled tubes)

  Final glycerol concentration: 25% (v/v).

+ Cap tightly. Vortex briefly (2-3 s) to fully mix - confirm a single uniform solution with no glycerol layer at the bottom.

  #nb[\ Incomplete mixing leaves a glycerol gradient inside the tube, which results in uneven cryoprotection and lower post-thaw viability.]

#pagebreak()
5.  Snap-freeze in liquid nitrogen, then transfer to $-$80 °C. If LN#sub[2] is not available, transfer directly from ice to $-$80 °C - post-thaw viability is comparable for *E. coli* under either method.


== Day 4B - Plasmid isolation from the cloning host (GeneJET miniprep)

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  align: (top, center),
  [
    With a saturated overnight of the #42365 cloning host in hand (LB + Kan, from the Day 3 inoculation), the plasmid is isolated by SDS/alkaline lysis and silica-column capture using the Thermo Scientific GeneJET Plasmid Miniprep Kit (K0502/K0503; User Guide MAN0012655). The eluate feeds directly into the verification digest and Sanger submission, and is the material later transformed into the #26242 expression host. Scan for the full kit user guide.
  ],
  [
    #qr-code("https://documents.thermofisher.com/TFS-Assets/LSG/manuals/MAN0012655_GeneJET_Plasmid_Miniprep_UG.pdf", width: 2cm)
    #align(center)[#text(size: 7pt, fill: gray)[
      GeneJET User Guide
    ]]
  ],
)

#note(title: "Copy number")[\ The kit's own vector table classes *pBR322 and its derivatives as low-copy* (10-50 copies/cell). pNIC28-Bsa4 is built on pET28a, a pBR322 derivative, so it is *low-copy*: use the upper end of the kit's range ($tilde$5-10 mL of saturated overnight) and expect modest yields, not the pUC-level output of a high-copy cloning vector. The column binds up to $tilde$20 μg dsDNA; for genuinely high-copy plasmids Thermo warns against exceeding 5 mL, which is not a constraint at this copy number but is the reason not to scale the input endlessly.]

#nb(title: "First-use kit prep")[\ Two reagents must be completed before the first prep or the run fails silently:
- Add ethanol (96-100%) to the Wash Solution concentrate - 35 mL into the 20 mL K0502 bottle, or 170 mL into the 100 mL K0503 bottle - then tick the checkbox on the bottlecap.
- Add the supplied RNase A to the Resuspension Solution and mix; store that bottle at 4 °C (stable 6 months). Skipping this leaves RNA in the eluate.]

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
      [Wash Solution I (R1611) + isopropanol - only if EndA#super[+]; not needed here],
    )
  ],
)

#pagebreak()

=== Procedure

All steps are carried out at room temperature. Unless stated otherwise, every centrifugation is in a microcentrifuge at ≥ 12 000 $times$ g.

1. *Harvest.* Pellet $tilde$5-10 mL of the saturated #42365 overnight and remove *all* residual medium - leftover LB carries into the lysate and impairs the prep.
   - 1.5 mL-tube route: spin at $tilde$6800 $times$ g (8000 rpm) for 2 min, decant, and repeat onto the same pellet until the full volume is spun.
   - 15 mL-tube route: spin at 3000-5000 $times$ g for $tilde$10 min on a benchtop centrifuge; then resuspend in the 250 μL Resuspension Solution (next step) and transfer the suspension to a 1.5 mL tube.

  #note[\ Use a *12-16 h* overnight, not an over-aged one - an old culture is the single most common cause of low yield. If you ever switch from LB to a rich medium like TB, cap growth at $tilde$12 h and reduce the input volume.]

+ *Resuspend.* Add 250 μL Resuspension Solution to the pellet and vortex (or pipette up and down) until *completely homogeneous* - no visible clumps.

  #note[\ Incomplete resuspension is the most common low-yield cause. Fully disperse the pellet before adding the Lysis Solution; no clumps should remain.]

+ *Lyse.* Add 250 μL Lysis Solution and mix by gently inverting the tube 4-6 times until the suspension turns viscous and slightly clear. Do *not* vortex.

  #nb[\ Never vortex after the Lysis Solution - shear liberates genomic DNA that co-purifies. Keep this step under *5 min*: over-lysis denatures the plasmid, and denatured plasmid runs *ahead* of the supercoiled band on a gel and *will not cut* - directly sabotaging the verification digest this prep feeds into.]

+ *Neutralize.* Add 350 μL Neutralization Solution and *immediately* invert 4-6 times, gently but thoroughly (to avoid localised precipitation). The lysate turns cloudy as a fluffy white precipitate (SDS, protein, genomic DNA) forms.

+ *Clear the lysate.* Centrifuge for 5 min to pellet the cell debris and chromosomal DNA. A compact white pellet collects against the tube wall.

+ *Bind.* Decant or pipette the cleared supernatant onto a GeneJET spin column, *avoiding the white precipitate*. Centrifuge 1 min, discard the flow-through, and return the column to the same collection tube.

  #note[\ EndA#super[+] strains only: a preliminary wash with 500 μL Wash Solution I + isopropanol (spin 30-60 s, discard) precedes the ethanol washes to strip nuclease activity. Mach1 is endA#super[$-$], so skip it here - see the closing note.]

+ *Wash ($times$2).* Add 500 μL Wash Solution (ethanol-supplemented), centrifuge 30-60 s, and discard the flow-through. Repeat once, for two washes total.

+ *Dry the membrane.* Discard the flow-through, then centrifuge the empty column for 1 min to drive off residual Wash Solution.

  #nb[\ Do not skip the dry spin. Carried-over ethanol inhibits restriction digestion and Sanger sequencing - the two steps this plasmid is headed straight into.]

+ *Elute.* Transfer the column to a clean, labelled 1.5 mL tube. Dispense 50 μL Elution Buffer (or nuclease-free water) onto the *centre* of the membrane, without touching the membrane with the tip. Incubate 2 min, then centrifuge 2 min. The flow-through is the purified plasmid; discard the column.

  #note[\ To raise concentration from this low-copy prep, elute in 30-35 μL instead of 50, or re-apply the first eluate to the membrane for a second pass. An optional second elution with fresh buffer recovers another $tilde$10-20% but dilutes the sample. Prewarming Elution Buffer to 70 °C is only needed for constructs $gt$20 kb - not the case for the $tilde$6.6 kb #42365 plasmid.]

+ *Quantify.* Measure on the NanoDrop: expect A#sub[260]/A#sub[280] $tilde$1.8 and A#sub[260]/A#sub[230] $gt$ 2.0. Record concentration and volume.

+ *Store.* Keep the eluate at $-$20 °C until the verification digest and Sanger submission.

#note(title: "Alternative")[\ The user guide also documents a *vacuum-manifold* route through the bind/wash steps (cell lysis and lysate clearing are identical). If a standard vacuum manifold is available it can replace the bind/wash spins; the elution step is the same. The centrifugation route above is the default here.]

#nb(title: "Looking ahead - EndA")[\ This prep is from the *Mach1 cloning host*, which is endA#super[-], so the standard wash gives clean DNA. When you later re-isolate the plasmid from the *#26242 expression clone*, that strain (BL21(DE3)) is endA#super[+]: run the preliminary *Wash Solution I (R1611) + isopropanol* wash before the ethanol washes, or the plasmid comes out nicked and degraded.]



#pagebreak()

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


#bibliography(
  "protocols.bib",
  title: auto,
  style: "apa",
)