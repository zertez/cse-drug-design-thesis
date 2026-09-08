// ==========================================================================
// Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
// ==========================================================================
#set document(
  title: "AzMC Sulfide Standard Curve",
  author: "Marcus D. Figenschou - Haavik Group, UiB Biomedicine",
)
#set page(
  paper: "a4",
  margin: (top: 2.0cm, bottom: 2.0cm, left: 2.0cm, right: 2.0cm),
  numbering: "1",
)
#set text(font: "STIX Two Text", size: 10pt, lang: "en")
#show math.equation: set text(font: "STIX Two Math")
#set par(justify: true, leading: 0.55em)
#show heading.where(level: 1): it => [
  #v(0.5em)
  #set text(size: 12.5pt, weight: "bold")
  #it
  #v(0.15em)
]
#show heading.where(level: 2): it => [
  #v(0.35em)
  #set text(size: 11pt, weight: "bold")
  #it
  #v(0.1em)
]
#show table: it => align(center, it)
#let nb(title: "Note", body) = block(
  width: 100%, inset: 6pt, stroke: (left: 2pt + rgb("#b00020")), fill: rgb("#fdecea"),
  [#text(weight: "bold", fill: rgb("#b00020"))[#title] #body],
)
#let ph-buffer = 8.10
#align(center)[
  #text(size: 14pt, weight: "bold")[
    AzMC Sulfide Standard Curve
  ]
]
#v(0.3em)
= Purpose
Set up a standard curve for Na#sub[2]S with the AzMC probe.
= Materials
- Fresh black 96-well plate, flat bottom
- Bucket with ice
- Na#sub[2]S·9H#sub[2]O
- Erlenmeyer flask
- AzMC 10 mM in 100% DMSO
- 200 mM sodium phosphate, pH #ph-buffer
- Degassed MilliQ

= Phosphate
Use the 200 mM sodium phosphate buffer at pH 8.1.
= Stocks
== Degassed MilliQ
Vacuum-filter MilliQ, cap it and store on ice.
== AzMC working, 100 µM
10 µL of 10 mM AzMC + 990 µL MilliQ. Ice, dark.
== Na#sub[2]S mother, 50 mM in degassed MilliQ
Solid is sodium sulfide nonahydrate, Na#sub[2]S·9H#sub[2]O.
Molar mass = 240.18 g/mol = 240.18 mg/mmol.
Target is 50 mM = 50 µmol/mL.
Mass per mL:
#pad(y: 0.2em, align(center, $ 50 thin "µmol/mL" times 240.18 thin "mg/mmol" = 12.01 thin "mg/mL" $))
Volume from a weighed mass:
#pad(y: 0.2em, align(center, $ V thin ("mL") = m thin ("mg") / 12.01 $))
Example: 24.02 mg in the hood. $ V = 24.02 / 12.01 = 2.00 thin "mL" $

Use an erlenmeyer flask for this step. Add 2.00 mL ice-cold degassed MilliQ. Cap. Ice.
Do not dissolve in phosphate. Do not return wetted solid to the bottle. Do not keep the aqueous mother overnight. Do not spend time weighing exactly take what you get and recalculate if needed.

#pagebreak()

== Na#sub[2]S working, 100 µM in degassed MilliQ
The two conditions use 193 µL. Make 5.00 mL: 10 µL of 50 mM + 4990 µL ice-cold degassed MilliQ. Cap and store on ice.

= Master mixes
Ice, dark. MM-3 is Block 1. MM-4 is Block 2. Do not put AzMC into MM-4.
Finished wells: 100 µL, 10 mM NaPi, 10 µM AzMC.
#table(
  columns: (auto, auto, auto, auto, auto),
  align: (left, right, right, right, right),
  stroke: 0.5pt,
  inset: 4pt,
  [*Mix*], [*200 mM NaPi*], [*MilliQ*], [*100 µM AzMC*], [*Total*],
  [MM-3 (Na#sub[2]S last)], [50 µL], [350 µL], [100 µL], [500 µL],
  [MM-4 (AzMC last)], [50 µL], [350 µL], [–], [400 µL],
)

= Plate setup
== Block 1. Na#sub[2]S last (A1–A7)
#table(
  columns: (auto, auto, auto, auto, auto),
  align: (left, right, right, right, right),
  stroke: 0.5pt,
  inset: 4pt,
  [*Well*], [*µM*], [*MM-3*], [*MilliQ*], [*100 µM Na#sub[2]S*],
  [A1], [0], [50 µL], [50 µL], [–],
  [A2], [0.5], [50 µL], [49.5 µL], [0.5 µL],
  [A3], [1], [50 µL], [49 µL], [1 µL],
  [A4], [5], [50 µL], [45 µL], [5 µL],
  [A5], [15], [50 µL], [35 µL], [15 µL],
  [A6], [25], [50 µL], [25 µL], [25 µL],
  [A7], [50], [50 µL], [–], [50 µL],
)
== Block 2. AzMC last (B1–B7)
#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (left, right, right, right, right, right),
  stroke: 0.5pt,
  inset: 4pt,
  [*Well*], [*µM*], [*MM-4*], [*MilliQ*], [*100 µM Na#sub[2]S*], [*100 µM AzMC*],
  [B1], [0], [40 µL], [50 µL], [–], [10 µL],
  [B2], [0.5], [40 µL], [49.5 µL], [0.5 µL], [10 µL],
  [B3], [1], [40 µL], [49 µL], [1 µL], [10 µL],
  [B4], [5], [40 µL], [45 µL], [5 µL], [10 µL],
  [B5], [15], [40 µL], [35 µL], [15 µL], [10 µL],
  [B6], [25], [40 µL], [25 µL], [25 µL], [10 µL],
  [B7], [50], [40 µL], [–], [50 µL], [10 µL],
)
== C1. Matrix blank
#table(
  columns: (auto, auto, auto, auto, auto),
  align: (left, left, right, right, right),
  stroke: 0.5pt,
  inset: 4pt,
  [*Well*], [*Condition*], [*MM-4*], [*MilliQ*], [*AzMC / Na#sub[2]S*],
  [C1], [Buffer + water], [40 µL], [60 µL], [–],
)
= Spark
Black plate, sealed, top read, 37 °C.
- Fluorescence intensity, top
- Kinetic, one label, 1 min × 120 min
- Ex 365 nm / Em 450 nm, bandwidth 20 nm
- Gain: Manual. Calculate from A7 or B7 (50 µM) after the last adds, then
  type that integer. Do not calculate from the 25 µM wells. Do not use
  Optimal on the kinetic. If A7 or B7 saturates, lower the gain until
  that well is under the ceiling, note the integer, and lock it.
- Flashes: 25-30
- Settle: 50-100 ms
- Shake: 30 s orbital before the first read, 5 s orbital between points
= Analysis
+ Treat A1–A7 and B1–B7 as two separate curves. Do not pool them.
+ A1 and B1 are the 0 µM reagent blanks. C1 is the matrix blank (buffer
  + degassed water only). Do not subtract C1 from the curves. Do not
  subtract empty wells.
+ Fit each curve at 10, 20 and 30 min. Singlets. Keep a point if it sits
  on the line. Drop a point only for overflow or an obvious pipette miss.
+ Record the locked gain integer.
+ Keep one last-add order. Criteria: RFU rises through 50 µM, 10/20/30 min
  points lie on the line.
+ Write the kept order and the gain on the enzyme protocol before that
  plate is poured.
+ Do not report nmol H#sub[2]S from this plate.
#pagebreak()
= Appendix
One example per condition. All finished wells are 100 µL.
#let calc(title, body) = block(
  breakable: false,
  width: 100%,
  above: 0.7em,
  below: 0.35em,
  [
    #heading(level: 2, title)
    #body
  ],
)
#let eq(body) = pad(y: 0.2em, align(center, body))
#calc([Final phosphate, every well])[
  #eq[$ 5 "µL" times 200 "mM" = 1.00 "µmol" $]
  #eq[$ 1.00 "µmol" / 100 "µL" = 10 "mM" $]
]
#calc([AzMC working, 100 µM])[
  #eq[$ (10 "µL" times 10 "mM") / 1000 "µL" = 100 "µM" $]
]
#calc([Na#sub[2]S mother, 50 mM])[
  Na#sub[2]S·9H#sub[2]O = 240.18 g/mol. \
  #eq[$ 50 "µmol/mL" times 240.18 "mg/mmol" = 12.01 "mg/mL" $]
  #eq[$ V ("mL") = m ("mg") / 12.01 $]
  Example: 24.02 mg gives 2.00 mL of 50 mM in degassed MilliQ.
]
#calc([Na#sub[2]S working, 100 µM])[
  #eq[$ (10 "µL" times 50 "mM") / 5000 "µL" = 100 "µM" $]
]
#calc([MM-3 (Na#sub[2]S last)])[
  500 µL mix: 50 µL of 200 mM + 350 µL MilliQ + 100 µL of 100 µM AzMC.
  #eq[$ (50 "µL" times 200 "mM") / 500 "µL" = 20 "mM NaPi" $]
  #eq[$ (100 "µL" times 100 "µM") / 500 "µL" = 20 "µM AzMC" $]
  50 µL MM-3 in the well:
  #eq[$ (50 "µL" times 20 "mM") / 100 "µL" = 10 "mM NaPi" $]
  #eq[$ (50 "µL" times 20 "µM") / 100 "µL" = 10 "µM AzMC" $]
]
#calc([MM-4 (AzMC last)])[
  400 µL mix: 50 µL of 200 mM + 350 µL MilliQ. No AzMC.
  #eq[$ (50 "µL" times 200 "mM") / 400 "µL" = 25 "mM NaPi" $]
  40 µL MM-4 in the well:
  #eq[$ (40 "µL" times 25 "mM") / 100 "µL" = 10 "mM NaPi" $]
]
#calc([Block 1 example. A5, 15 µM, Na#sub[2]S last])[
  50 µL MM-3 + 35 µL MilliQ + 15 µL of 100 µM Na#sub[2]S.
  #eq[$ (15 "µL" times 100 "µM") / 100 "µL" = 15 "µM sulfide" $]
  Phosphate and AzMC come from MM-3 (10 mM and 10 µM).
]
#calc([Block 2 example. B5, 15 µM, AzMC last])[
  40 µL MM-4 + 35 µL MilliQ + 15 µL of 100 µM Na#sub[2]S + 10 µL of 100 µM AzMC.
  #eq[$ (15 "µL" times 100 "µM") / 100 "µL" = 15 "µM sulfide" $]
  #eq[$ (10 "µL" times 100 "µM") / 100 "µL" = 10 "µM AzMC" $]
  Phosphate comes from MM-4 (10 mM).
]
#calc([50 µM wells])[
  A7: 50 µL MM-3 + 50 µL of 100 µM Na#sub[2]S. \
  B7: 40 µL MM-4 + 50 µL of 100 µM Na#sub[2]S + 10 µL of 100 µM AzMC. \
  Both are 100 µL and 50 µM sulfide. Both are 10 mM NaPi.
]
#calc([C1. Matrix blank])[
  40 µL MM-4 + 60 µL degassed MilliQ. No AzMC. No Na#sub[2]S.
  #eq[$ (40 "µL" times 25 "mM") / 100 "µL" = 10 "mM NaPi" $]
]
// End of document
