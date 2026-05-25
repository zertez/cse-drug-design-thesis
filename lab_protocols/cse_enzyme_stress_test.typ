// =========================================================================
//  CSE Enzyme Stress Test (Document A)
//  Small-scale expression, single-step purification, and characterisation
//  Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
// =========================================================================

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

#set text(font: "New Computer Modern", size: 10pt, lang: "en")
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

#let note(body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#1a73e8")),
  fill: rgb("#e8f0fe"),
  [#text(weight: "bold", fill: rgb("#1a73e8"))[Note. ] #body],
)

#let tbd(body) = block(
  width: 100%,
  inset: 6pt,
  stroke: (left: 2pt + rgb("#b88600")),
  fill: rgb("#fff8e1"),
  [#text(weight: "bold", fill: rgb("#b88600"))[Decision pending. ] #body],
)

// =========================================================================
//  Title block
// =========================================================================
#align(center)[
  #v(0.5em)
  #text(size: 16pt, weight: "bold")[
    CSE Enzyme Stress Test
  ]
  #v(0.4em)
  #text(size: 10pt)[
    Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
  ]
]

#v(0.5em)

// =========================================================================
= Purpose and scope
// =========================================================================

This is the *characterisation* protocol for recombinant human cystathionine
γ-lyase (CSE, gene name _CTH_, UniProt P32929). No one in the group has
worked with this protein before. Before scaling up to the ~20 mg
preparative campaign needed for the PAM screen, we need baseline data on
how this specific construct, produced in this specific strain in this
specific lab, behaves: how it expresses, how it folds, how it tolerates
pH / temperature / salt / freeze-thaw, and whether the AzMC / methylene
blue activity assay gives reproducible signal.

*Output of this protocol:* 1–3 mg of single-step IMAC-purified, His-tagged
CSE; documented biophysical QC envelope (oligomeric state, monodispersity,
folding, thermal stability, identity, mass); documented activity envelope
(Km, kcat, pH and T optima, freeze-thaw stability).

*This protocol is not for producing screening material.* It deliberately
uses small culture volumes (200 mL), a single chromatographic step, and
no tag cleavage. The His tag is retained throughout - it does not
materially affect SEC-MALS, DLS, CD, DSF, intact mass, or activity, and
removing it adds a day of dialysis and an extra column for no gain at
this stage. The preparative protocol (Document B) handles tag cleavage
and SEC polishing once expression and activity have been validated here.

#note[
  The biophysical QC workflow in §5 follows the standard recombinant-protein
  characterisation tree used by structural-genomics groups (SGC, EMBL-PSF).
  It distributes 1 mg of purified protein across SEC-MALS, DLS, CD, DSF,
  SDS-PAGE / MALDI-TOF, and intact-mass ESI-TOF, with three storage
  conditions (fresh, ice, frozen) tested in parallel to capture storage
  stability in the same experimental block.
]

// =========================================================================
= Workflow overview
// =========================================================================

#table(
  columns: (auto, 1fr, auto),
  inset: 5pt,
  align: (left, left, left),
  stroke: 0.5pt + gray,
  table.header([*Day*], [*Step*], [*Hands-on*]),
  [Day 1 (Fri)], [Streak Addgene stab, miniprep, transform expression strain on LB-Kan-Cam], [2 h],

  [Day 2 (Mon)], [Pick colony, 5 mL starter culture, glycerol stocks, sequence-verify], [1 h],

  [Day 3 (Tue)], [Inoculate 200 mL TB, induce with IPTG at 16–18 °C overnight], [3 h],

  [Day 4 (Wed)], [Harvest, lyse, clarify, single-step IMAC purification], [Full day],

  [Day 5 (Thu)],
  [Concentrate, quantify, aliquot 1 mg / 1 mL stress-test charge; \
    set up fresh / ice / frozen storage arms],
  [Half day],

  [Day 6–10], [Biophysical QC (§5): SEC-MALS, DLS, CD, DSF, MALDI-TOF, ESI-TOF], [Distributed],

  [Day 6–10], [Activity baseline (§6): Km, kcat, pH and T optima, freeze-thaw stability], [Distributed],
)

// =========================================================================
= Small-scale expression and purification
// =========================================================================

== Materials and antibiotics

Same biological materials, antibiotics, and stock solutions as Document B.
Briefly: Addgene plasmid #42365 (pNIC28-Bsa4-CTHA, His#sub[6]-TEV-CTHA,
KanR) in expression strain Addgene #26242 (BL21(DE3)-R3-pRARE2, CamR).
Dual selection: kanamycin 50 µg/mL + chloramphenicol 34 µg/mL.

== Buffers (scaled down)

Same compositions as Document B. Prepare:

- *Lysis buffer*, 30 mL: 50 mM Tris-HCl pH 8.0, 500 mM NaCl, 10 mM
  imidazole, 5 % glycerol, 0.1 mM PLP, 1 mM TCEP, 0.5 mg/mL lysozyme,
  25 U/mL Benzonase, 1× cOmplete EDTA-free _(reducing agent, lysozyme,
  Benzonase, and inhibitors added fresh)_.
- *IMAC buffer A*, 100 mL: 50 mM Tris-HCl pH 8.0, 500 mM NaCl, 10 mM
  imidazole, 5 % glycerol, 0.05 mM PLP, 1 mM TCEP.
- *IMAC buffer B*, 50 mL: as A, with 500 mM imidazole.
- *Storage buffer*, 50 mL: 20 mM HEPES pH 7.5, 150 mM NaCl, 5 % glycerol,
  0.05 mM PLP, 0.5 mM TCEP.

== Day 1 - Plate streak and transformation

Identical to Document B §5. Streak the Addgene stab on LB-Kan, miniprep
from a single colony, transform competent BL21(DE3)-R3-pRARE2 by heat
shock, plate on LB-Kan-Cam. Pick the next morning.

== Day 2 - Starter culture and glycerol stocks

Identical to Document B §6. Pick a single colony into 5 mL LB-Kan-Cam,
grow to $"OD"_(600) approx 1$, freeze three glycerol stocks, sequence-verify
the insert from a miniprep.

#qc[
  Sequence-verify the _CTH_ insert from the miniprep _before_ the glycerol
  stocks are committed as the master cell bank. A wrong-strain or
  recombined construct caught here saves wasting all downstream
  expression work.
]

== Day 3 - Small-scale expression in 200 mL TB

#needbox[
  Overnight starter culture (5 mL, $"OD"_(600) approx$ 2–4) - or refresh \
  with 5 mL fresh LB-Kan-Cam in the morning to mid-log \
  1 L baffled Erlenmeyer flask with 200 mL Terrific Broth \
  Kanamycin (50 mg/mL), chloramphenicol (34 mg/mL), PLP (100 mM stock) \
  IPTG (1 M stock) \
  37 °C shaking incubator and 16–18 °C shaking incubator \
  Spectrophotometer with 1-cm cuvettes
]

=== Procedure

+ Add 200 µL kanamycin + 200 µL chloramphenicol + 200 µL PLP (100 µM
  final) to 200 mL TB in a 1 L baffled flask.
+ Inoculate with 2 mL overnight starter (~1 % v/v).
+ Grow at 37 °C, 180–220 rpm until $"OD"_(600) = 0.6 - 0.8$ (typically
  2.5–3.5 h in TB).
+ Take a 1 mL "C$minus$" pre-induction sample (pellet, freeze at
  #sym.minus 20 °C for SDS-PAGE).
+ Transfer flask to the pre-cooled 16–18 °C shaker. Equilibrate 30 min.
+ Induce with 60 µL 1 M IPTG (0.3 mM final). Optionally add another
  10 µL PLP (additional 50 µM).
+ Induce at 16–18 °C, 180 rpm, overnight (16–20 h).
+ Take a 1 mL "C$plus$" post-induction sample.
+ Harvest at 6 000 × g, 15 min, 4 °C. Expected wet pellet: 1.5–3 g.
+ Either resuspend immediately in lysis buffer or snap-freeze the pellet
  in liquid N#sub[2] and store at #sym.minus 80 °C.

#qc[
  Pellet should be visibly pale yellow if PLP incorporation has worked.
  Take a photograph of the pellet next to a control (BSA or any
  non-PLP-enzyme prep) for your lab notebook.
]

== Day 4 - Lysis and single-step IMAC

#needbox[
  Resuspended (or thawed) cell pellet from Day 3 \
  Freshly supplemented lysis buffer (lysozyme + Benzonase + inhibitors \
  + PLP + TCEP, all added on the day) \
  Sonicator with 3 mm or 6 mm tip, ice-water bath \
  High-speed centrifuge with JA-25.50 (or equivalent) rotor \
  0.45-µm syringe filters \
  HisTrap HP 1 mL column (Cytiva 17-5247-01) or 1 mL Ni-NTA spin \
  column (Qiagen / Thermo); ÄKTA start or peristaltic pump
]

=== Procedure

+ Add fresh lysozyme, Benzonase, protease inhibitors, PLP, and TCEP to
  ~15 mL lysis buffer.
+ Resuspend pellet thoroughly (~5 mL buffer per 1 g wet pellet).
+ Incubate on ice with gentle stirring for 20 min.
+ Sonicate on ice: 3 mm tip, 40 % amplitude, 3 s ON / 7 s OFF, total
  ON-time 2 min for ~15 mL lysate. Visible drop in viscosity.
+ Clarify at 30 000–40 000 × g, 30 min, 4 °C.
+ Filter the supernatant through 0.45 µm. Take a 30 µL "soluble lysate"
  sample.

=== IMAC, ÄKTA route (preferred when available)

+ Equilibrate HisTrap HP 1 mL with 5 CV buffer A at 1 mL/min, 4 °C.
+ Load filtered lysate at 0.5 mL/min. Collect flow-through.
+ Wash with 10 CV buffer A (10 mM imidazole) until $A_(280)$ baseline
  stable. Take a 100 µL FT sample.
+ Step wash 5 CV at 6 % B (~40 mM imidazole) to remove weakly bound
  contaminants.
+ Elute with linear gradient 6 → 100 % B over 15 CV. Collect 0.5 mL
  fractions across the elution peak. CSE typically elutes around
  150–250 mM imidazole.
+ Pool fractions across the central $A_(280)$ peak.

=== IMAC, spin-column route (when no FPLC available)

+ Equilibrate spin column with 3 × 1 CV buffer A by gravity drip.
+ Apply filtered lysate in 1 mL aliquots, allowing gravity drip; collect
  flow-through.
+ Wash with 10 × 1 CV buffer A; then 5 × 1 CV at 6 % B.
+ Elute with 5 × 0.5 mL of 100 % B (500 mM imidazole). Collect each
  elution fraction separately and assay $A_(280)$ to identify the protein
  peak.

#qc[
  Measure $A_(280)$ and $A_(415)$ on the pooled eluate. Target
  $A_(415)/A_(280)$ between 0.3 and 0.4 (good holoenzyme); ratio below
  0.15 is a yellow flag - supplement with 0.1 mM additional PLP, incubate
  30 min on ice in the dark, re-measure. Photograph the pooled eluate —
  yellow colour indicates holoenzyme.
]

+ Take a 30 µL pooled-eluate sample for SDS-PAGE. Expected band: ~45 kDa
  (His-tagged monomer; full-length His-CTH = ~47 kDa with the
  pNIC28-Bsa4 N-terminal His#sub[6]-TEV linker).

== Day 5 - Buffer exchange, concentration, and aliquoting

The IMAC eluate is in 500 mM NaCl / variable imidazole. For downstream
biophysics it is better to remove imidazole and standardise the buffer.
A single buffer-exchange step using a desalting column or PD-10 is
sufficient; full SEC polishing is deferred to Document B.

#needbox[
  Pooled IMAC eluate \
  PD-10 desalting column (Cytiva 17-0851-01) pre-equilibrated in storage \
  buffer - or HiTrap Desalting 5 mL on the ÄKTA \
  Amicon Ultra-4 concentrator, 30 kDa MWCO \
  UV-Vis spectrophotometer with 1-cm quartz cuvette \
  Cryotubes, 0.5 mL Eppendorf low-binding tubes, liquid N#sub[2]
]

=== Procedure

+ Buffer-exchange ~2.5 mL pooled eluate into storage buffer using a
  PD-10 column (gravity protocol), or HiTrap Desalting on the ÄKTA.
+ Concentrate to ~1 mg/mL using an Amicon Ultra-4 (30 kDa MWCO), 4 000 ×
  g, 4 °C, in 3-min spins with mixing between spins. Do not exceed
  ~5 mg/mL at this stage.
+ Centrifuge at 16 000 × g, 10 min, 4 °C to remove aggregates.
+ Measure final concentration by $A_(280)$: \
  $epsilon_(280)("His-CTH") approx 30 940 "M"^(-1) "cm"^(-1)$,
  $"MW" approx 46 800 "Da"$ for the His-tagged monomer. \
  $A_(280) = 0.661$ → 1.0 mg/mL.

#note[
  Recompute the exact extinction coefficient and MW from the actual
  pNIC28-Bsa4-CTHA construct sequence using ExPASy ProtParam before
  reporting. The values above are good for a sanity check but are not
  substitutes for a per-construct calculation.
]

+ Record $A_(415)/A_(280)$, sample colour, and any visible turbidity.
+ Aliquot the 1 mg / 1 mL "stress-test charge" as described in §5 below,
  and the remainder in 50 µL aliquots at #sym.minus 80 °C for the activity
  characterisation in §6.

// =========================================================================
= Biophysical QC and storage stability
// =========================================================================

This section follows the workflow shown in. The starting material
is 1 mg of purified CSE at 1 mg/mL (1 mL total). It is split into two
arms: a 900 µg arm for *storage stability* (which compares fresh, ice,
and frozen storage across three orthogonal biophysical readouts) and a
100 µg arm for *identity, thermal stability, and intact-mass
characterisation* of the freshly prepared protein.

#tbd[
  Confirm equipment access for SEC-MALS, DLS, CD, DSF, MALDI-TOF, and
  ESI-TOF with Sumit and the Biomedicine core facility. Some of these
  may need to be booked in advance or run via the PROBE / NORCRYST
  facility. Update this protocol with instrument-specific parameters
  (sample volume, cuvette pathlength, concentration range) once
  confirmed.
]

== Sample plan

#table(
  columns: (auto, auto, auto, auto, 1fr),
  inset: 5pt,
  align: (left, left, left, left, left),
  stroke: 0.5pt + gray,
  table.header([*Arm*], [*Storage*], [*Method*], [*Amount*], [*Readout*]),
  [Storage], [Fresh], [SEC-MALS], [250 µg], [Oligomeric state, monodispersity],
  [Storage], [Fresh], [DLS], [50 µg], [Hydrodynamic radius, aggregation],
  [Storage], [Fresh], [CD], [(re-use DLS sample)], [Secondary structure / folding],
  [Storage], [Ice (4 °C, 7 d)], [SEC-MALS], [250 µg], [as above],
  [Storage], [Ice (4 °C, 7 d)], [DLS + CD], [50 µg], [as above],
  [Storage], [Frozen (#sym.minus 80 °C, then thaw)], [SEC-MALS], [250 µg], [as above],
  [Storage], [Frozen (#sym.minus 80 °C, then thaw)], [DLS + CD], [50 µg], [as above],
  [Identity], [Fresh], [DSF], [90 µg], [Thermal stability, pH and salt preference],
  [Identity], [Fresh], [SDS-PAGE → MALDI-TOF], [5 µg], [Sequence identity, degradation],
  [Identity], [Fresh], [ESI-TOF intact mass], [5 µg], [Intact mass, redox modifications],
)

== Storage conditions (the three arms)

+ *Fresh.* Used directly after the Day 5 buffer-exchange and quantification.
  Run all "fresh" measurements on the same day.
+ *Ice.* 300 µg aliquot held at 4 °C in storage buffer for 7 days.
  Run measurements on Day 12 (i.e., Day 5 + 7).
+ *Frozen.* 300 µg aliquot flash-frozen in liquid N#sub[2] within 1 h
  of quantification, stored at #sym.minus 80 °C, thawed on ice on Day 12
  and assayed alongside the ice arm. Single freeze-thaw cycle only.

#note[
  The 7-day ice storage and the matched single-freeze-thaw timing
  re-create the conditions under which screening material will actually
  be used: prepared in batches, stored on ice during a day's assays, and
  pulled fresh from #sym.minus 80 °C aliquots between assay sessions. If you
  see degradation or aggregation specifically in the ice arm, all
  same-day assays will need to be planned to minimise time on ice.
]

== SEC-MALS

#needbox[
  250 µg sample per condition in storage buffer \
  Superdex 200 Increase 10/300 GL column (Cytiva 28-9909-44) \
  Storage buffer, 0.22-µm filtered and degassed \
  ÄKTA system coupled to MALS detector (Wyatt DAWN / miniDAWN) and \
  refractive index detector (Wyatt Optilab) \
  ASTRA software for MALS data analysis
]

=== Procedure

+ Equilibrate column with 1.5 CV (~36 mL) storage buffer at 0.5 mL/min,
  monitoring UV, MALS, and RI baselines until stable.
+ Calibrate the system with BSA (2 mg/mL, 50 µL injection) on each
  experimental day to confirm normalisation, alignment, and band
  broadening parameters.
+ Inject 50 µL of CSE sample at ~5 mg/mL (i.e. concentrate 250 µg to
  50 µL just before injection). Use a 100 µL loop.
+ Acquire UV, MALS, and RI signals at 0.5 mL/min.
+ Fit the main peak in ASTRA using the standard $"d"n / "d"c$ value for
  protein (0.185 mL/g).

=== Expected output

- *Tetramer.* Molar mass 175–190 kDa across the peak (theoretical
  His-CTH tetramer = 4 × 46.8 = 187 kDa).
- *Polydispersity.* $M_w/M_n lt 1.05$ across the peak indicates a
  monodisperse tetramer.
- *Void / aggregate fraction.* < 10 % of total peak area as a flag for
  acceptable monodispersity.

== DLS

#needbox[
  50 µg sample per condition (~1 mg/mL recommended; works down to \
  ~0.5 mg/mL) \
  Wyatt DynaPro NanoStar, Malvern Zetasizer, or equivalent \
  Disposable cuvettes (1 cm or low-volume quartz) \
  0.22-µm centrifugal filters to clean samples
]

=== Procedure

+ Centrifuge sample at 16 000 × g, 10 min, 4 °C immediately before
  loading to remove dust and aggregates. Alternatively filter through
  0.22-µm centrifugal filter.
+ Load ~20 µL into a low-volume quartz cuvette (or appropriate
  disposable).
+ Acquire 20 acquisitions of 5 s each at 25 °C.
+ Report:
  - *Z-average hydrodynamic radius* ($R_h$): expected ~5.5–6.5 nm for
    the CSE tetramer.
  - *Polydispersity index* (PDI): < 0.2 for monodisperse samples;
    < 0.1 indicates excellent monodispersity.
  - *Intensity vs. number distributions:* number distribution should
    show a single ~6 nm peak; intensity distribution may reveal small
    populations of large aggregates that contribute negligibly by
    number but disproportionately by intensity.

== CD spectroscopy

The DLS sample (after dilution to ~0.2 mg/mL) can be re-used for far-UV
CD. Keep the same aliquot - if it has aggregated by DLS, CD will give
a misleading spectrum.

#needbox[
  ~50 µg sample per condition, diluted to ~0.2 mg/mL in low-salt buffer \
  (or buffer-exchange into 10 mM phosphate pH 7.5 / 150 mM NaF) \
  Jasco J-810 / J-815 CD spectropolarimeter or equivalent \
  0.1 cm pathlength quartz cuvette
]

=== Procedure

+ Buffer-exchange a fresh ~50 µg aliquot into 10 mM sodium phosphate
  pH 7.5 / 150 mM NaF (chloride absorbs strongly below 200 nm) using a
  Zeba spin desalting column. This step is _per condition_.
+ Dilute to ~0.2 mg/mL final concentration.
+ Acquire far-UV spectrum (190–260 nm) at 25 °C, 50 nm/min scan rate,
  1 nm bandwidth, 4 accumulations averaged.
+ Subtract buffer blank.

=== Expected output

- A spectrum consistent with an α/β protein: negative bands near 208 nm
  and 222 nm (α-helix), with secondary contribution from β-sheet near
  217 nm. CSE is a fold-type I PLP enzyme with substantial α-helix
  content.
- Compare across the three storage conditions - overlay should be
  superimposable. Drift in the 222/208 nm ratio across conditions is a
  warning for partial unfolding.

== Differential scanning fluorimetry (DSF)

#needbox[
  90 µg sample (fresh, divided across pH × salt matrix) \
  SYPRO Orange (Sigma S5692, 5 000× stock) \
  qPCR machine with FRET / SYBR-compatible filter set, or Prometheus \
  nanoDSF (label-free, preferred if available - uses intrinsic Trp \
  fluorescence and avoids SYPRO interference with PLP cofactor) \
  Buffer matrix: 3 pH × 3 salt combinations
]

=== pH and salt matrix

#table(
  columns: (auto, auto, auto, auto),
  inset: 5pt,
  align: (left, left, left, left),
  stroke: 0.5pt + gray,
  table.header([*Buffer*], [*pH*], [*Buffer base*], [*NaCl*]),
  [B1], [6.5], [50 mM MES], [50 mM],
  [B2], [6.5], [50 mM MES], [150 mM],
  [B3], [6.5], [50 mM MES], [500 mM],
  [B4], [7.5], [50 mM HEPES], [50 mM],
  [B5], [7.5], [50 mM HEPES], [150 mM],
  [B6], [7.5], [50 mM HEPES], [500 mM],
  [B7], [8.5], [50 mM Tris], [50 mM],
  [B8], [8.5], [50 mM Tris], [150 mM],
  [B9], [8.5], [50 mM Tris], [500 mM],
)

All buffers contain 5 % glycerol, 0.05 mM PLP, 0.5 mM TCEP.

=== Procedure (SYPRO route)

+ Per well: 5 µL protein (1 mg/mL) + 14 µL buffer + 1 µL 100× SYPRO
  Orange (final 5×). Run in triplicate × 9 buffers = 27 wells.
+ Ramp 25 → 95 °C at 1 °C/min in a qPCR machine, monitoring SYPRO
  fluorescence (ex 470 nm / em 610 nm typical).
+ Fit each melt curve to a Boltzmann sigmoid to extract $T_m$.

=== Procedure (nanoDSF route, preferred if Prometheus is available)

+ Load 10 µL per capillary at 0.5 mg/mL.
+ Ramp 20 → 90 °C at 1 °C/min.
+ Read intrinsic fluorescence at 330 and 350 nm; $T_m$ from the inflection
  in the 350/330 ratio.

=== Expected output

- $T_m approx$ 55–62 °C is typical for hCSE in the literature.
- The pH × salt matrix identifies the most stabilising buffer condition,
  which becomes the recommended formulation for downstream biochemistry.
- $Delta T_m$ between conditions usually ranges 2–8 °C; > 5 °C
  difference is a strong signal for the preferred buffer.

#note[
  SYPRO Orange can interact with PLP and give noisy or non-sigmoidal
  curves for PLP enzymes. If the qPCR-based DSF gives uninterpretable
  curves, switch to nanoDSF (Prometheus) - it avoids the dye entirely.
]

== SDS-PAGE and MALDI-TOF peptide mass fingerprinting

#needbox[
  5 µg sample (fresh) \
  SDS-PAGE rig (BIO211 Bio-Rad standard), 4–20 % gradient gel \
  Coomassie staining (or SimplyBlue SafeStain) \
  Sterile scalpel, clean glass plate \
  Access to MALDI-TOF facility for in-gel digest and PMF
]

=== Procedure

+ Run 2 µg per lane in duplicate on a 4–20 % gradient SDS-PAGE
  (15 µL sample + 5 µL 4× sample buffer, 80 °C × 5 min, 150 V × 60 min).
+ Stain with Coomassie.
+ Excise the major band (~45 kDa, expected to be His-CSE).
+ Submit to the proteomics core facility for in-gel trypsin digest and
  MALDI-TOF peptide mass fingerprinting. Provide the expected sequence
  (His-CSE) for matching.

=== Expected output

- Coverage > 50 % of the CSE primary sequence by MALDI-TOF peptide
  matching. Identity confirmed against UniProt P32929 with the
  N-terminal His tag from pNIC28-Bsa4.
- Absence of unexpected bands; if a faint band ~5–10 kDa lower than
  the main band is visible, excise it too - this would indicate
  C-terminal degradation.

== Intact-mass ESI-TOF

#needbox[
  5 µg sample (fresh) in storage buffer \
  Access to LC-MS facility with ESI-TOF mass spectrometer (e.g. \
  Agilent 6230, Bruker maXis) \
  C3 or C4 reverse-phase trap column \
  Aqueous–acetonitrile gradient with 0.1 % formic acid
]

=== Procedure

+ Dilute the 5 µg sample to ~0.1 mg/mL in MS-compatible buffer (or rely
  on the on-column desalting of the LC method).
+ Inject ~1 µg onto C3/C4 trap, elute with water → acetonitrile gradient
  with 0.1 % formic acid.
+ Acquire ESI-TOF spectrum under denaturing conditions across charge
  states 20–60.
+ Deconvolute to the intact mass using MaxEnt or equivalent.

=== Expected output

- Intact mass within ±2 Da of the predicted mass for the His-tagged
  apo-CSE monomer. PLP-bound species may also be visible at +247 Da
  (PLP–Lys internal aldimine adduct; ~229 Da increment for the imine
  form, +247 for the alcohol form - the exact mass depends on the
  derivatisation state).
- *Redox modifications.* Adducts at +16 / +32 / +48 Da indicate methionine
  or cysteine oxidation (one, two, or three oxidations). > 30 % oxidised
  species in a fresh prep indicates buffer reducing-agent insufficient
  or oxidative damage during expression / purification.

#qc[
  Storage stability is judged by comparing the *fresh, ice, and frozen*
  arms for each biophysical readout. The pass criterion is:
  no change in oligomeric state (SEC-MALS), no increase in aggregation
  ($> 5 %$ shift in DLS PDI or appearance of a void peak in SEC-MALS),
  no change in CD spectrum overlay, and no increase in oxidation by
  ESI-TOF. Any condition that fails should be excluded from future
  workflows and noted in the lab notebook.
]

#pagebreak()

// =========================================================================
= Activity baseline and stress testing
// =========================================================================

The biophysical QC in §5 tells us whether the protein is folded,
monodisperse, and the right mass. It does *not* tell us whether the
protein is enzymatically active. The activity baseline establishes Km
and kcat in the chosen buffer system, identifies pH and temperature
optima, and quantifies how much activity is lost on freeze-thaw or on
extended storage on ice.

== Activity assay choice

#tbd[
  Confirm with Sumit whether the Biomedicine common-equipment plate
  reader supports fluorescence at $lambda_"ex" = 365$ nm /
  $lambda_"em" = 450$ nm (required for AzMC) or absorbance at 670 nm
  (required for methylene blue, plus access to a fume hood for the acid
  development step). Both assays are defensible primary readouts for
  thesis-grade work. The decision is driven by lab capability, not by
  any external reference.

  *AzMC* (fluorometric, fixed-time or kinetic): detection ~50 nM H#sub[2]S,
  one-pot reaction, 96-well throughput, cheap consumable. Vulnerable to
  autofluorescent screening compounds.

  *Methylene blue* (colorimetric, fixed-time): detection ~µM H#sub[2]S,
  zinc-trap then acid development, two-step but reagents extremely cheap.
  Robust against autofluorescent compounds.
]

Whichever is selected, *both* §6 (activity baseline) and the downstream
PAM screening (Document B and the PAM screening protocol) must use the
*same* assay, *same* buffer, *same* reader settings, and ideally *same*
protein batch as the baseline. Switching assay platforms mid-campaign
introduces a confound that cannot easily be back-corrected.

== Standard curve and limit of detection

Regardless of assay choice, run a Na#sub[2]S standard curve at the start
of every assay day:

+ Prepare a fresh 100 mM Na#sub[2]S stock in degassed water _on the day_.
  Confirm concentration by $A_(230)$ ($epsilon = 7700 "M"^(-1) "cm"^(-1)$
  for HS$""^minus$). Sulfide oxidises in air rapidly; never use a
  multi-day stock.
+ Serial dilute to 0, 0.1, 0.3, 1, 3, 10, 30, 100 µM in assay buffer.
+ Process each standard through the assay alongside the experimental
  samples.

== Buffer for all activity assays

100 mM HEPES pH 8.0, 150 mM NaCl, 0.1 mM PLP, 0.5 mM TCEP, 0.01 % (w/v)
BSA (as carrier to prevent CSE adsorption at low enzyme concentrations).

L-cysteine substrate stock prepared fresh in degassed assay buffer on
each assay day (cysteine oxidises rapidly in air).

== Baseline kinetics: Km and kcat

#needbox[
  CSE stock from Day 5 \
  L-cysteine: stock 100 mM fresh in assay buffer \
  Assay buffer \
  AzMC or methylene blue reagents (per chosen assay) \
  Na#sub[2]S standards \
  96-well plate (black, clear-bottom for AzMC; clear for methylene blue) \
  Plate reader (fluorescence or absorbance per chosen assay) \
  37 °C incubator
]

=== Procedure

+ Verify the chosen assay is in the *initial-rate linear range* at your
  enzyme concentration. Run a single concentration of L-cysteine (5 mM)
  at three enzyme concentrations (0.5, 1, 2 µM final), and fixed-time
  readouts at 5, 15, 30, 60 min. Product accumulation should be linear
  in time and in enzyme over your chosen window. Pick a single
  endpoint time within the linear window for all subsequent assays —
  typically 15 or 30 min.

+ Run a Michaelis-Menten saturation curve at 12 cysteine concentrations:
  0.05, 0.1, 0.25, 0.5, 1, 2, 5, 10, 20, 50 mM, in triplicate, with
  enzyme = 0.5 µM, 37 °C, fixed endpoint.

+ Convert fluorescence (or absorbance) to nmol H#sub[2]S using the Na#sub[2]S
  standard curve.

+ Convert nmol H#sub[2]S to initial velocity v#sub[0] (µM/s or
  µmol·min$""^(minus 1)$·mg$""^(minus 1)$).

+ Fit to the Michaelis-Menten equation in GraphPad Prism or scipy:

  $ v_0 = (V_"max" dot [S]) / (K_m + [S]) $

  Extract $V_"max"$ (and thus $k_"cat"$ given known $[E]$) and $K_m$.

=== Expected output

- $K_m$ for L-cysteine: literature value ~1–4 mM for hCSE.
- $k_"cat"$: literature ~0.1–2 s$""^(minus 1)$ for hCSE under similar conditions.
- $k_"cat" / K_m$: ~10$""^2$–10$""^3$ M$""^(minus 1)$ s$""^(minus 1)$.

Significant departures from these ranges are diagnostic: low $k_"cat"$
suggests poor PLP loading or partial inactivation; high $K_m$ suggests
buffer interference (Tris in particular).

== pH optimum

Repeat the assay at fixed substrate concentration (5 mM L-cysteine,
above $K_m$) across pH 6, 6.5, 7, 7.5, 8, 8.5, 9, using:

- pH 6.0–7.0: 100 mM MES
- pH 7.0–8.0: 100 mM HEPES
- pH 8.0–9.0: 100 mM Tris

Plot $v_0$ vs pH. Expected optimum: pH 7.4–8.4 for hCSE.

#note[
  Use *the same buffer* across two adjacent pH points (e.g., pH 7.0 in
  both MES and HEPES) to detect buffer-specific effects. If MES and
  HEPES disagree at pH 7.0 by more than 10 %, report buffer-specific
  activities rather than a single pH curve.
]

== Temperature optimum

At pH optimum (from above) and 5 mM L-cysteine, repeat the assay at
4, 25, 30, 37, 42, 45, 50, 55 °C. Pre-equilibrate the reaction mix at
target temperature for 5 min before adding enzyme.

Plot $v_0$ vs T. Expected:

- Activity rises from 4 °C to ~37–42 °C
- Falls sharply above ~45 °C as the enzyme begins to denature
- Optimum may be 37–42 °C; thermal denaturation $T_m$ from DSF should
  agree

== Freeze-thaw stability

Take 8 aliquots of CSE from #sym.minus 80 °C; subject them to 0, 1, 2, or 3
freeze-thaw cycles (snap-freeze in liquid N#sub[2], thaw on ice over
20 min). Assay each at pH and T optima.

Plot activity vs freeze-thaw cycles. Acceptance criterion: < 20 % loss
per cycle is normal for PLP enzymes; > 50 % loss per cycle indicates
the formulation needs more cryoprotectant (try increasing glycerol to
10 % or adding 5 % trehalose).

== Time-on-ice stability

Hold one aliquot on ice (4 °C) and assay activity at 0, 1, 3, 8, 24 h.
This sets the maximum time a thawed aliquot can be used during an assay
day before activity loss compromises results.

// =========================================================================
= Acceptance criteria
// =========================================================================

#table(
  columns: (auto, auto, auto),
  inset: 5pt,
  align: (left, left, left),
  stroke: 0.5pt + gray,
  table.header([*Parameter*], [*Pass*], [*Investigate*]),
  [SDS-PAGE purity], [> 90 %], [< 80 %],
  [SEC-MALS, $M_w/M_n$], [< 1.05], [> 1.10],
  [SEC-MALS molar mass], [175–195 kDa], [outside this range],
  [DLS, PDI], [< 0.2], [> 0.3],
  [DLS, $R_h$], [5.5–6.5 nm], [< 4.5 or > 7.5 nm],
  [DSF $T_m$], [55–62 °C], [< 50 °C],
  [ESI-TOF intact mass], [±2 Da of expected], [> 5 Da deviation],
  [Oxidised species], [< 30 %], [> 50 %],
  [$A_(415)/A_(280)$], [0.3–0.4], [< 0.15],
  [Freeze-thaw activity loss (1 cycle)], [< 20 %], [> 50 %],
  [$K_m$ for L-cysteine], [1–4 mM], [> 8 mM or < 0.5 mM],
  [$k_"cat"$], [0.1–2 s$""^(minus 1)$], [< 0.02 or > 5 s$""^(minus 1)$],
)

Any "Investigate" call should be discussed with Sumit before the prep
is committed to the screening campaign. A partial fail may be acceptable
provided the failure mode is understood and documented; a complete fail
is a signal to revisit expression conditions (try lower IPTG, lower
temperature, higher PLP) or storage formulation (higher glycerol, longer
PLP equilibration).

// =========================================================================
= Document control
// =========================================================================

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 5pt,
  align: (left, left, left, left),
  stroke: 0.5pt + gray,
  table.header([*Version*], [*Date*], [*Author*], [*Changes*]),
  [0.1 (draft)],
  [—],
  [Marcus],
  [Initial small-scale + QC + activity baseline draft; circulated to J. Haavik and S. Kumar for review. Activity-assay decision (AzMC vs methylene blue) and equipment access (SEC-MALS, MALDI, ESI-TOF) pending lab confirmation.],
)

// =========================================================================
= References
// =========================================================================

+ BIO211 Labheftet, Department of Biological Sciences, University of
  Bergen, 2025 (v1.0).
+ Burgess-Brown N. A. et al. (2008). Codon optimization can improve
  expression of human genes in _Escherichia coli_: A multi-gene study.
  _Protein Expression and Purification_ 59, 94–102.
+ Savitsky P. et al. (2010). High-throughput production of human
  proteins for crystallization: The SGC experience. _Journal of
  Structural Biology_ 172, 3–13.
+ Addgene #42365, pNIC28-Bsa4-CTHA.
+ Addgene #26242, BL21(DE3)-R3-pRARE2.
+ Sun Q. et al. (2009). Structural basis for the inhibition mechanism
  of human cystathionine γ-lyase. _JBC_ 284, 3076–3085.
+ Wintner E. A. et al. (2010). A monobromobimane-based assay to measure
  the pharmacokinetic profile of reactive sulphide (H#sub[2]S) in
  biological fluids. _Br. J. Pharmacol._ 160, 941–957.
+ Niesen F. H., Berglund H., Vedadi M. (2007). The use of differential
  scanning fluorimetry to detect ligand interactions that promote
  protein stability. _Nat. Protoc._ 2, 2212–2221.
