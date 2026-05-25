// Summary (1-2 pages)
// Outline: topic, objectives, main results.
#import "_packages.typ": *

#heading(numbering: none)[Materials]

== Protein Expression and Purification Materials
#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    align: horizon,
    fill: (x, y) => if y == 0 { gray.lighten(80%) },
    table.header([*Material*], [*Catalog \#*], [*Est. Price (USD)*], [*Why*]),

    // === CONSTRUCTS & STRAINS ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Constructs & Strains*],

    [CTHA plasmid (CSE in pNIC28-Bsa4) -- #link("https://www.addgene.org/42365/")[Addgene]],
    [\#42365],
    [\~\$89],
    [Construct for human CSE with N-His6-TEV tag. Used to solve PDB 2NMP/3COG @savitsky2010],

    [BL21(DE3)-R3-pRARE2 -- #link("https://www.addgene.org/26242/")[Addgene]],
    [\#26242],
    [\~\$89],
    [Depositor-recommended expression strain @burgess_brown2008],

    // === PLASMID AMPLIFICATION ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Plasmid Amplification (Mach1 → midiprep → transform BL21)*],

    [Plasmid Midiprep Kit (e.g. Macherey-Nagel NucleoBond Xtra Midi)],
    [MN 740410.50],
    [\~\$250 (50 preps)],
    [Isolate plasmid DNA from Mach1 overnight culture in LB + kanamycin; single midiprep yields \~100+ µg],

    // === EXPRESSION REAGENTS ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Expression*],

    [IPTG (dioxane-free, 5 g)],
    [e.g. Thermo R0392],
    [\~\$50],
    [Inducer for T7 promoter; 0.5 mM working conc. @burgess_brown2008],

    [Terrific Broth (powder, 1 kg)],
    [e.g. Sigma T0918],
    [\~\$80],
    [High-density expression medium for BL21; target OD#sub[600] 3--4 before induction. Need 2--4 L for \~20 mg CSE @savitsky2010],

    [Kanamycin sulfate],
    [],
    [],
    [Selection for pNIC28-Bsa4; 50 µg/mL. Used in both Mach1 (plasmid amplification) and BL21 (expression)],

    [Chloramphenicol],
    [],
    [],
    [Selection for pRARE2 in BL21; used in overnight starter only, dropped for expression culture @burgess_brown2008],

    [Pyridoxal 5'-phosphate (PLP)],
    [e.g. Sigma P9255],
    [\~\$30],
    [Essential cofactor for CSE; supplement expression medium (50--100 µM) and all purification buffers @nasi2025],

    // === LYSIS ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Lysis*],

    [Roche cOmplete EDTA-free Protease Inhibitor Tablets],
    [Roche 04693132001],
    [\~\$120 (20 tablets)],
    [EDTA-free required for IMAC compatibility; 1 tablet per 50 mL lysate @burgess_brown2008],

    [Benzonase Nuclease (HC, ≥250 U/µL)],
    [e.g. Sigma E1014],
    [\~\$120],
    [Degrades nucleic acids in lysate; reduces viscosity. Requires 1--2 mM MgCl#sub[2] for activity @savitsky2010],

    [MgCl#sub[2] (1 M stock)],
    [],
    [],
    [Co-factor for Benzonase; add to lysis buffer at 1--2 mM final concentration],

    [TCEP-HCl (5 g)],
    [e.g. Thermo 77720],
    [\~\$70],
    [Reducing agent; 0.5--1 mM in all buffers. Stable and IMAC-compatible unlike DTT @burgess_brown2008],

    // === PURIFICATION: Ni-AFFINITY ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Purification - Ni-Affinity (IMAC)*],

    [HisTrap HP 5 mL prepacked column (Cytiva)],
    [Cytiva 17524801],
    [\~\$150 each],
    [Prepacked Ni Sepharose HP; 40 mg/mL binding capacity. @savitsky2010],

    [Imidazole (100 g)],
    [e.g. Sigma I5513],
    [\~\$25],
    [Wash buffer (20--40 mM) and elution (250--500 mM)],

    // === PURIFICATION: TAG CLEAVAGE ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Purification - Tag Cleavage & Reverse IMAC*],

    [TEV protease (His-tagged)],
    [e.g. Sigma T4455],
    [\~\$90],
    [Cleaves His6 tag from CSE overnight at 4°C; His-tagged TEV removed during reverse IMAC @savitsky2010],

    // === PURIFICATION: SIZE EXCLUSION ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Purification - Size Exclusion Chromatography*],

    [Superdex 200 Increase 10/300 GL (Cytiva)],
    [Cytiva 28990944],
    [\~\$1,200],
    [SEC polishing; fractionation range 10--600 kDa, resolves CSE homotetramer (\~176 kDa) from aggregates and contaminants. @savitsky2010],

    // === CONCENTRATION & STORAGE ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*Concentration & Storage*],

    [Amicon Ultra-15 Centrifugal Filters, 30 kDa MWCO],
    [Millipore UFC903024],
    [\~\$120 (24 pack)],
    [Concentrate CSE between chromatography steps; 30 kDa cutoff appropriate for CSE monomer (\~44 kDa)],

    [Glycerol (molecular biology grade)],
    [],
    [],
    [10% in storage buffer for protein stability; also for glycerol stocks of expression strain],

    // === QC & ANALYSIS ===
    table.cell(colspan: 4, fill: blue.lighten(85%))[*QC & Analysis*],

    [Precast SDS-PAGE gels (e.g. Bio-Rad Any kD Mini-PROTEAN TGX)],
    [Bio-Rad 4569036],
    [\~\$120 (10 gels)],
    [Monitor every purification fraction - total, soluble, FT, wash, elution, SEC fractions],

    [Prestained protein ladder],
    [e.g. NEB P7719],
    [\~\$60],
    [Molecular weight reference; CSE monomer band expected at \~44 kDa],

    [Coomassie / InstantBlue stain],
    [e.g. Abcam ab119211],
    [\~\$50],
    [Gel staining; or use stain-free gels if Bio-Rad system available],
  )
]

#bibliography(
  "master_thesis_CSE.bib",
  title: auto,
  style: "apa",
)
