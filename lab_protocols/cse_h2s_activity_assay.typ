// 
//  CSE Activity Assay (Document B)
//  H2S production by hCSE: AzMC fluorometric (primary), methylene blue (orthogonal)
//  Haavik Neurotargeting Research Group · Department of Biomedicine · UiB
// 

#import "parameters.typ": *

// ==========================================================================
//  ACTIVITY-ASSAY PARAMETERS  (move into parameters.typ to keep the
//  single-source pattern; kept here so this file compiles standalone)
// ==========================================================================
#let azmc_mw        = 201.18   // g/mol (C10H7N3O2)
#let azmc_stock_mM  = 10.0     // DMSO stock concentration
#let azmc_work_uM   = 10.0     // final working concentration in the reaction
#let rxn_vol_uL     = 100      // reaction volume per well
#let plp_assay_mM   = 1.0      // PLP supplement in every reaction
#let enz_per_well_ug = 1.0     // rhCSE per well
#let cys_K05_mM     = 2.8      // L-cysteine K0.5 (Hill, h ~2.6)
#let dmso_max_pct   = 0.5      // total DMSO ceiling (vehicle + probe carrier)

//  ---- derived (do not edit) ----
// mass to make V_mL of AzMC stock, mg
#let azmc_stock_mass_mg(V_mL) = calc.round(azmc_stock_mM * V_mL * azmc_mw / 1000, digits: 2)
// AzMC consumed per well, ug
#let azmc_per_well_ug = calc.round(azmc_work_uM * rxn_vol_uL * azmc_mw * 1e-6, digits: 3)
// AzMC per full 96-well plate, ug
#let azmc_per_plate_ug = calc.round(azmc_per_well_ug * 96, digits: 1)

// ==========================================================================

#set document(
  title: "Enzymatic Activity Assay for Human Cystathionine γ-Lyase (hCSE)",
  author: "Marcus - Haavik Group, UiB Biomedicine",
)

#set page(
  paper: "a4",
  margin: (top: 2.2cm, bottom: 2.2cm, left: 2.2cm, right: 2.2cm),
  numbering: "1 / 1",
  header: [
    #set text(size: 8pt, fill: gray)
    #align(right)[Document B · v0.1 Author: Marcus D. Figenschou
    ]
  ],
)

#set text(font: "STIX Two Text", size: 10pt, lang: "en")
#show math.equation: set text(font: "STIX Two Math")
#set par(justify: true, leading: 0.6em)

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
  width: 100%, inset: 8pt, stroke: 0.5pt + black, fill: rgb("#f7f7f7"),
  [#text(weight: "bold")[You need:] \ #body],
)
#let nb(title: "NB!", body) = block(
  width: 100%, inset: 6pt, stroke: (left: 2pt + rgb("#b00020")), fill: rgb("#fdecea"),
  [#text(weight: "bold", fill: rgb("#b00020"))[#title ] #body],
)
#let note(title: "Tip", body) = block(
  width: 100%, inset: 6pt, stroke: (left: 2pt + rgb("#1a73e8")), fill: rgb("#e8f0fe"),
  [#text(weight: "bold", fill: rgb("#1a73e8"))[#title] #body],
)
#let tbd(body) = block(
  width: 100%, inset: 6pt, stroke: (left: 2pt + rgb("#b88600")), fill: rgb("#fff8e1"),
  [#text(weight: "bold", fill: rgb("#b88600"))[Decision pending. ] #body],
)

//  Title block
#align(center)[
  #v(0.5em)
  #text(size: 16pt, weight: "bold")[
    Enzymatic Activity Assay for hCSE \ H#sub[2]S Production: AzMC (primary) · Methylene Blue (orthogonal)
  ]
  #v(0.4em)
  #text(size: 10pt)[
    Basic and Translational Neuroscience · Neurotargeting Research Group · Department of Biomedicine · UiB
  ]
]

#v(0.5em)

= Protocol Quick View

- *Readout (primary):* AzMC fluorescence, #azmc_work_uM μM, excitation 365 nm / emission 450 nm
- *Readout (orthogonal):* methylene blue, absorbance #sym.tilde 670 nm (hit confirmation only)
- *Uses:* baseline kinetics (K#sub[0.5], V#sub[max]) · PAM dose-response (EC#sub[50]) · hit confirmation
- *Substrate:* L-cysteine (or L-homocysteine for higher yield)
- *Reaction buffer:* 10 mM sodium phosphate, pH 8.2 (assay buffer, distinct from GF storage)
- *Format:* 96-well black/clear-bottom plate, #rxn_vol_uL μL/well, #enz_per_well_ug μg rhCSE, #plp_assay_mM mM PLP

#note(title: "Why two assays")[\ AzMC fluorescence gives the sub-μM sensitivity and low CV needed to resolve a #sym.tilde 2-fold activation, runs non-destructively, and the same probe carries into the cellular phase. Methylene blue is mechanistically independent (acid-trapped sulfide read at 670 nm), so it is blind to the 450 nm-fluorescent, near-UV-absorbing PAMs that produce AzMC artefacts. Confirming an AzMC hit in methylene blue is the artefact filter no single fluorescence assay can provide. This expands the AzMC readout referenced in Document A (§Analytical Objectives, Day 11).]

#line(length: 100%, stroke: 0.5pt)

= Reagents and stocks

#needbox[AzMC (Aldrich-802409) · L-cysteine · L-homocysteine (optional) · PLP · NaHS or Na#sub[2]S.9H#sub[2]O (sulfide calibrant) · DMSO · methylene blue reagents (zinc acetate, N,N-dimethyl-p-phenylenediamine, FeCl#sub[3]) · 96-well black/clear-bottom plates · plate reader (ex 365 / em 450; A#sub[670])]

1. *AzMC stock (#azmc_stock_mM mM in DMSO).* For 1 mL, dissolve #azmc_stock_mass_mg(1) mg AzMC in 1 mL DMSO. Aliquot, store -20 °C in the dark; reconstituted stock stable #sym.tilde 6 months. Hold the bulk solid at -20 °C, reconstitute small stocks sized to #sym.tilde 6 months of use.

+ *AzMC working spike (200 μM).* On the assay day, dilute the #azmc_stock_mM mM stock 1:50 into reaction buffer. Adding 5 μL of this spike to a 95 μL reaction gives #azmc_work_uM μM final and contributes 0.1% DMSO from the probe.

+ *Substrate stocks.* Prepare L-cysteine (and L-homocysteine if used) fresh each day in reaction buffer; both autoxidise. Keep on ice.

+ *PLP stock.* In reaction buffer, protected from light; #plp_assay_mM mM final in every reaction.

+ *Sulfide calibrant.* Prepare NaHS (or Na#sub[2]S.9H#sub[2]O) fresh in degassed reaction buffer immediately before use; standardise the working stock rather than trusting weighed mass.

#nb[\ AzMC efficiency drops with thiols, DTT, or TCEP above #sym.tilde 25 mM. Keep substrate #sym.tilde$<=$10 mM and confirm any carryover TCEP from the protein stock is far below this in the final reaction. The azide is photosensitive - work in dim light.]

= H#sub[2]S calibration curve

Anchors RFU (and A#sub[670]) to [H#sub[2]S] and confirms linearity before any kinetic or EC#sub[50] run.

1. Prepare an NaHS series in reaction buffer (e.g. 0, 0.2, 0.5, 1, 2, 5, 10, 25, 50, 100 μM) with #azmc_work_uM μM AzMC, no enzyme.

+ Read endpoint (settings below); fit the linear region; confirm linearity across #sym.tilde 0.2 to 100 μM.

#note[\ Curvature at the top end signals probe depletion or inner-filter effect. Keep every experimental signal inside this validated window by holding accumulated H#sub[2]S below the upper bound (initial-rate regime).]

= In vitro rhCSE activity and kinetics

1. *Per well* (#rxn_vol_uL μL): reaction buffer, #enz_per_well_ug μg rhCSE, substrate, #plp_assay_mM mM PLP, vehicle at fixed DMSO, #azmc_work_uM μM AzMC added last from the working spike.

+ *Controls per plate:* no-enzyme blank (buffer + substrate + PLP + AzMC, for background subtraction); no-substrate control; buffer-only.

+ *Read* endpoint at 3 h, or kinetic mode for the initial linear rate, at ex 365 / em 450. Subtract the no-enzyme blank.

+ *K#sub[0.5] / V#sub[max]:* titrate L-cysteine #sym.tilde 0.25 to 30 mM. CSE is cooperative for cysteine (K#sub[0.5] #sym.tilde #cys_K05_mM mM, Hill #sym.tilde 2.6) - fit the Hill equation, not Michaelis-Menten.

+ *Occupancy check:* run paired -PLP / +PLP; a rise on PLP addition means the prep was sub-saturated (see Document A QC and the reconstitution step).

#note(title: "Benchmark")[\ At full occupancy, order of magnitude is #sym.tilde 1 U/mg from cysteine and #sym.tilde 6-7 U/mg from homocysteine by H#sub[2]S detection (1 U = 1 μmol H#sub[2]S/min).]

= PAM dose-response (EC#sub[50])

1. Fix enzyme and substrate; titrate PAM across 8 to 10 doses; hold total DMSO constant across every well.

+ Express signal as % over vehicle; fit a sigmoidal dose-response (variable slope); report EC#sub[50] with 95% CI from n $>=$ 3.

+ Controls: vehicle-only (basal), no-enzyme, and a reference activator if available. Require Z' $>=$ 0.5 on a validation plate (basal vs. maximally activated) before screening.

+ *Artefact counter-screen:* for every apparent hit, read compound + AzMC without enzyme. Intrinsic fluorescence or near-UV absorbance flags a false positive for resolution by methylene blue.

#nb(title: "Substrate choice - deliberate divergence")[\ Run the dose-response at *sub-saturating* substrate near K#sub[0.5] (#sym.tilde 2 to 3 mM cysteine), not at saturating substrate. The ZHAW series acts partly through improved apparent substrate affinity (α = 0.5), and affinity-type activation is largest below saturation, so sub-saturating substrate maximises the activation window. Characterise the mechanism separately with a substrate × PAM matrix to extract α.]

#nb[\ Total DMSO = PAM vehicle + the 0.1% from the AzMC spike. Hold the combined value constant across the whole plate and $<=$ #dmso_max_pct% to avoid perturbing the enzyme.]

= Methylene blue orthogonal confirmation

Run on AzMC-validated hits only.

1. Set up reactions as above (enzyme, substrate, PLP, PAM or vehicle) *without* AzMC.

+ At the endpoint, trap sulfide with zinc acetate, then develop colour with N,N-dimethyl-p-phenylenediamine in acid followed by FeCl#sub[3]; incubate #sym.tilde 20 min and read A#sub[670]. Optimise reagent concentrations and development time against an NaHS standard curve in this format.

+ Confirm hit direction and approximate magnitude reproduce independently. A compound active in AzMC but inactive in methylene blue (and flagged by the counter-screen) is a fluorescence artefact, not a modulator.

= Cellular adaptation (later phase)

1. Plate SH-SY5Y or HT-22 at #sym.tilde 2 × 10#super[5] cells/well (96-well black/clear-bottom); allow to adhere.

+ Pre-incubate with PAM or vehicle (fixed DMSO) #sym.tilde 1 h.

+ Add AzMC to #azmc_work_uM μM final; read kinetic mode #sym.tilde 2 h at 37 °C, ex 365 / em 450. Subtract no-cell background. Same probe and wavelengths as the in vitro assay, so the phases are directly comparable.

= QC and acceptance

- *Linearity:* signal within the NaHS-validated range (#sym.tilde 0.2 to 100 μM).
- *Rate regime:* initial-rate / low fractional probe turnover (no plateau).
- *Background:* no-enzyme blank subtracted every plate.
- *DMSO:* constant across plate, $<=$ #dmso_max_pct%.
- *Cofactor:* PLP saturating; -PLP/+PLP checked per prep.
- *Window:* Z' $>=$ 0.5 before screening.
- *Hit confidence:* reproduced in methylene blue and clears the artefact counter-screen.

#tbd[Plate-reader capability: AzMC needs near-UV excitation (365 nm). A monochromator reader does this natively; a filter reader needs an AMC/DAPI-type set. Methylene blue needs only A#sub[670]. Confirm before committing to AzMC as primary - same question as the DSF instrument.]

#tbd[Default substrate: L-cysteine (cleaner handling) vs. L-homocysteine (higher signal, faster autoxidation). Decide and fix one for cross-batch comparability.]

= Consumables

At #azmc_work_uM μM in #rxn_vol_uL μL, each well uses #azmc_per_well_ug μg AzMC; a full 96-well plate #sym.tilde #azmc_per_plate_ug μg. Whole-thesis use, including waste and the cellular phase, stays in the low single-digit mg range - a 10 mg single-lot order is sufficient with margin, and a single lot keeps the standard curve fixed across the campaign.

// ==========================================================================
//  References: add these keys to protocols.bib (Mendeley), then switch the
//  inline mentions to @cite to match Document A. Suggested keys:
//    @nasi2025_pam   Nasi et al. (2025) Pharmacol Res 219:107869
//    @sun2009_cse    Sun et al. (2009) JBC 284(5):3076-3085
//    @singh2009_h2s  Singh et al. (2009) JBC 284(33):22457-22466
// ==========================================================================
