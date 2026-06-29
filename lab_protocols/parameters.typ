//  Batch sizing parameters - edit these to rescale the protocol

// ==========================================================================
//  PHYSICAL CONSTANTS (molar masses, g/mol) - single source of truth.
//  Consolidated here so every derived mass pulls from one place. Anhydrous
//  forms are the ones this lab stocks; hydrate alternatives kept where the
//  document shows both.
// ==========================================================================

// NaCl
#let mw_nacl = 58.44
// KCl
#let mw_kcl = 74.56
// MgCl2 (anhydrous - the form this lab stocks)
#let mw_mgcl2 = 95.211
// MnCl2.4H2O
#let mw_mncl2_4h2o = 197.91
// CaCl2 (anhydrous - the form this lab stocks)
#let mw_cacl2 = 110.98
// CaCl2.2H2O (dihydrate - alternative)
#let mw_cacl2_2h2o = 147.02
// HEPES free acid (Na-salt = 260.29)
#let mw_hepes = 238.30
// imidazole
#let mw_imidazole = 68.08
// Tris base (weighed, titrated to pH with HCl)
#let mw_tris = 121.14
// disodium EDTA dihydrate (the form this lab stocks)
#let mw_edta_na2_2h2o = 372.24
// Na2HPO4.2H2O - sodium phosphate dibasic dihydrate
#let mw_na2hpo4_2h2o = 177.99



// per-antibiotic plate count
#let plates_per_antibiotic = 3

// agar bottles / selection conditions poured: Kan, Cam, and Kan+Cam (double).
// The double bottle is banked for transformant selection at the later
// transformation step; it is not used in the Day 2-5 revival workflow.
#let n_agar_bottles = 4

// 60 mm dish holds 5-10 mL; 15 mL used here (per supervisor, current run)
#let volume_per_plate_mL = 15

// TARGET molten agar volume to make up PER ANTIBIOTIC BOTTLE (mL).
// Set this directly to the volume you want to make. The pour margin is
// derived from it below, so there is no percentage to tune by hand.
// (At 10 plates x 15 mL this needs 150 mL minimum; 200 mL gives ~33% margin.)
#let agar_volume_per_antibiotic_mL_target = 200

// pre-mixed LB-agar formulation
#let lb_agar_g_per_L = 40

// 1:1000 stock-to-final
#let antibiotic_dilution = 1000

//  Liquid broth media (autoclaved Day 1, stored ANTIBIOTIC-FREE at 4 C)

// LB broth (Lennox) - starter / overnight cultures. Two bottles, one
// earmarked per strain workflow; antibiotic added per culture at point of use.
#let lb_broth_volume_per_bottle_mL = 200
#let n_lb_broth_bottles = 2
// Sigma L7658 EZMix: 20.6 g/L
#let lb_broth_g_per_L = 20.6

// TB modified - high-density expression medium (used in a later document).
// Glycerol is the carbon source and is added before autoclaving.
#let tb_broth_volume_mL = 500
// Sigma T0918: 47.6 g/L + 8 mL/L glycerol
#let tb_broth_g_per_L = 47.6
#let tb_glycerol_mL_per_L = 8


//  Day 3 cultures / Day 4 glycerol-stock sizing (asymmetric: Mach1 screened, BL21 not)
// One overnight culture per picked colony. Stocks are aliquots of that one
// culture, so stocks-per-clone do NOT add cultures.

// #42365 colonies picked -> parallel cultures (Sanger screen)
#let n_clones_mach1 = 3
// provisional cryotubes per Mach1 clone
#let n_stocks_per_clone_mach1 = 3
// #26242: single colony, empty host, no screen needed
#let n_clones_bl21 = 1
// archival redundancy for the one BL21 clone
#let n_stocks_per_clone_bl21 = 4
// LB working volume per overnight tube
#let culture_volume_mL = 50
#let cryotubes_spare = 2

//  Derived values - do not edit directly

// agar strictly needed to fill the plates, no margin (3 x 15 = 45 mL)
#let agar_volume_required_mL = plates_per_antibiotic * volume_per_plate_mL

// the volume actually made per bottle = the target set above
#let agar_volume_per_antibiotic_mL = agar_volume_per_antibiotic_mL_target

// grand total made across all agar bottles (200 x 4 = 800 mL)
#let agar_volume_total_mL = agar_volume_per_antibiotic_mL * n_agar_bottles

#let lb_agar_mass_g = calc.round(
  lb_agar_g_per_L * agar_volume_per_antibiotic_mL / 1000,
  digits: 2,
)
#let antibiotic_volume_uL = calc.round(
  agar_volume_per_antibiotic_mL * 1000 / antibiotic_dilution,
  digits: 0,
)

//  Broth masses / glycerol - derived
#let lb_broth_mass_g = calc.round(
  lb_broth_g_per_L * lb_broth_volume_per_bottle_mL / 1000,
  digits: 2,
)
#let tb_broth_mass_g = calc.round(
  tb_broth_g_per_L * tb_broth_volume_mL / 1000,
  digits: 2,
)
#let tb_glycerol_mL = calc.round(
  tb_glycerol_mL_per_L * tb_broth_volume_mL / 1000,
  digits: 2,
)

//  Day 3 / Day 4 culture + stock sizing - derived
// 4
#let n_cultures_total = n_clones_mach1 + n_clones_bl21
// 9
#let n_stocks_mach1 = n_clones_mach1 * n_stocks_per_clone_mach1
// 4
#let n_stocks_bl21 = n_clones_bl21 * n_stocks_per_clone_bl21
// 13
#let n_stocks_total = n_stocks_mach1 + n_stocks_bl21
// 15
#let n_cryotubes_order = n_stocks_total + cryotubes_spare
// 50 uL at 1:1000
#let antibiotic_per_culture_uL = calc.round(
  culture_volume_mL * 1000 / antibiotic_dilution,
  digits: 0,
)


// ==========================================================================
//  Day 5B: chemically competent BL21(DE3)-R3-pRARE2  (Inoue method)
//  --------------------------------------------------------------------------
//  ONE FREE KNOB: the main CULTURE VOLUME. Type a round number; the Inoue
//  ratios fix everything else, and the derived wash / resuspension / DMSO are
//  rounded to bench-friendly values (whole mL, half mL, 10 uL). Aliquot count
//  is reported as an approximate output, not an input.
//  Rough guide:  15 mL ~ 25 aliquots | 30 mL ~ 50 | 60 mL ~ 100.
// ==========================================================================

//  ---- PRIMARY KNOB ----
// main culture volume (use a round number)
#let cc_culture_mL = 30

//  ---- method / format constants (rarely changed) ----
// volume dispensed per cryotube
#let cc_aliquot_volume_uL = 50
// DMSO final (v/v) - Inoue method = 7%
#let cc_dmso_fraction = 0.07
// culture : final-resuspension (canonical Inoue; rounding the resuspension
// lands this near ~12:1)
#let cc_culture_ratio = 12.5
// first-wash : culture vol (canonical 80 mL / 250 mL)
#let cc_wash_ratio = 0.32
// starter culture working volume
#let cc_starter_mL = 3
// SOB reserved as OD blank
#let cc_blank_mL = 5

//  ---- make-volume sizing margins ----
// SOB overage over (blank + starter + culture)
#let cc_sob_margin = 1.2
// Inoue TB overage over per-prep usage
#let cc_inoue_margin = 1.2
// min FRESH Inoue TB batch, for weighable salt masses
#let cc_inoue_floor_mL = 20

//  ---- Inoue TB / SOB recipe constants (MWs live in PHYSICAL CONSTANTS) ----
// 55 mM
#let cc_inoue_mncl2_M = 0.055
// 15 mM
#let cc_inoue_cacl2_M = 0.015
// 250 mM
#let cc_inoue_kcl_M = 0.250
// 10 mM final, from 0.5 M stock
#let cc_inoue_pipes_M = 0.010
#let cc_pipes_stock_M = 0.5
#let cc_sob_tryptone_g_per_L = 20
#let cc_sob_yeast_g_per_L = 5
// canonical SOB (NOT the 5 g/L of the Untergasser sheet)
#let cc_sob_nacl_g_per_L = 0.5
// 2.5 mM KCl weighed as solid (2.5e-3 mol/L x 74.55 g/mol)
#let cc_sob_kcl_g_per_L = 0.1864

//  ---- SOB salt STOCKS (pipetted, to avoid weighing sub-100 mg masses) ----
// 1 M NaCl working stock
#let cc_nacl_stock_M = 1.0
// 1 M KCl working stock
#let cc_kcl_stock_M = 1.0
// batch size when making the stocks fresh
#let cc_salt_stock_make_mL = 100
// ~8.556 mM
#let cc_sob_nacl_mM = calc.round(cc_sob_nacl_g_per_L / mw_nacl * 1000, digits: 3)
// SOB KCl target
#let cc_sob_kcl_mM = 2.5

// total Mg2+, ALL as MgCl2 (canonical SOB = 10 mM MgCl2 + 10 mM MgSO4 =
// 20 mM Mg2+; substituted to a single salt here)
#let cc_sob_mgcl2_M = 0.020
// 2 M MgCl2 stock
#let cc_mgcl2_stock_M = 2.0

//  ---- 2 M MgCl2 standing stock (shared lab reagent; autoclaved separately) ----
// batch size made up for the lab
#let cc_mgcl2_stock_make_mL = 50
#let cc_mgcl2_stock_mass_g = calc.round(cc_mgcl2_stock_M * cc_mgcl2_stock_make_mL / 1000 * mw_mgcl2, digits: 2)

//  ---- DERIVED: volume chain, ROUNDED for the bench (do not edit) ----
// nearest 1 mL
#let cc_wash_mL = calc.round(cc_culture_mL * cc_wash_ratio, digits: 0)
// nearest 0.5 mL
#let cc_resuspension_mL = calc.round(cc_culture_mL / cc_culture_ratio * 2, digits: 0) / 2
// nearest 10 uL
#let cc_dmso_mL = calc.round(cc_resuspension_mL * cc_dmso_fraction / (1 - cc_dmso_fraction), digits: 2)
#let cc_final_volume_mL = cc_resuspension_mL + cc_dmso_mL
// 1% starter into main
#let cc_starter_inoc_mL = calc.round(cc_culture_mL / 100, digits: 2)
#let cc_aliquots_theoretical = calc.floor(cc_final_volume_mL * 1000 / cc_aliquot_volume_uL)
// round usable target
#let cc_aliquots_round = calc.floor(cc_aliquots_theoretical / 5) * 5
#let cc_tubes_to_chill = cc_aliquots_theoretical + 2

//  ---- DERIVED: SOB make-volume + masses ----
// starter is LB (Day 1), not SOB
#let cc_sob_required_mL = cc_blank_mL + cc_culture_mL
#let cc_sob_make_mL = calc.ceil(cc_sob_required_mL * cc_sob_margin / 25) * 25
#let cc_sob_tryptone_g = calc.round(cc_sob_tryptone_g_per_L * cc_sob_make_mL / 1000, digits: 2)
#let cc_sob_yeast_g = calc.round(cc_sob_yeast_g_per_L * cc_sob_make_mL / 1000, digits: 2)
#let cc_sob_nacl_g = calc.round(cc_sob_nacl_g_per_L * cc_sob_make_mL / 1000, digits: 3)
#let cc_sob_kcl_g = calc.round(cc_sob_kcl_g_per_L * cc_sob_make_mL / 1000, digits: 4)
// stock volumes pipetted into each SOB batch (mM x mL / (stock M x 1000))
#let cc_sob_nacl_stock_mL = calc.round(cc_sob_nacl_mM * cc_sob_make_mL / (cc_nacl_stock_M * 1000), digits: 2)
#let cc_sob_kcl_stock_mL = calc.round(cc_sob_kcl_mM * cc_sob_make_mL / (cc_kcl_stock_M * 1000), digits: 2)
// masses to MAKE the 1 M stocks (if not on hand)
#let cc_nacl_stock_mass_g = calc.round(cc_nacl_stock_M * cc_salt_stock_make_mL / 1000 * mw_nacl, digits: 2)
#let cc_kcl_stock_mass_g = calc.round(cc_kcl_stock_M * cc_salt_stock_make_mL / 1000 * mw_kcl, digits: 2)
#let cc_sob_mgcl2_mL = calc.round(cc_sob_mgcl2_M * cc_sob_make_mL / cc_mgcl2_stock_M, digits: 2)
#let cc_mgcl2_preps_supplied = calc.floor(cc_mgcl2_stock_make_mL / cc_sob_mgcl2_mL)
#let cc_sob_base_mL = calc.round(cc_sob_make_mL - cc_sob_mgcl2_mL, digits: 1)

//  ---- DERIVED: Inoue TB (FRESH) make-volume + masses ----
#let cc_inoue_usage_mL = cc_wash_mL + cc_resuspension_mL
#let cc_inoue_make_mL = calc.max(
  calc.ceil(cc_inoue_usage_mL * cc_inoue_margin / 5) * 5,
  cc_inoue_floor_mL,
)
#let cc_inoue_mncl2_g = calc.round(cc_inoue_mncl2_M * cc_inoue_make_mL / 1000 * mw_mncl2_4h2o, digits: 3)
#let cc_inoue_cacl2_g = calc.round(cc_inoue_cacl2_M * cc_inoue_make_mL / 1000 * mw_cacl2, digits: 3)
#let cc_inoue_cacl2_dihydrate_g = calc.round(cc_inoue_cacl2_M * cc_inoue_make_mL / 1000 * mw_cacl2_2h2o, digits: 3)
#let cc_inoue_kcl_g = calc.round(cc_inoue_kcl_M * cc_inoue_make_mL / 1000 * mw_kcl, digits: 3)
#let cc_inoue_pipes_mL = calc.round(cc_inoue_pipes_M * cc_inoue_make_mL / cc_pipes_stock_M, digits: 2)

//  ---- display helper: sub-gram masses shown in mg, >=1 g shown in g ----
#let massfmt(g) = if g < 1 {
  [#calc.round(g * 1000, digits: 1) mg]
} else {
  [#calc.round(g, digits: 2) g]
}


// ==========================================================================
//  Day 5B: Transformation - verified pNIC28-Bsa4-CTHA (#42365) into the
//  freshly competent BL21(DE3)-R3-pRARE2. Heat-shock, LB recovery, dual
//  selection on Kan + Cam. A short DNA titration brackets a working amount.
// ==========================================================================

// competent cells per reaction (one aliquot)
#let tf_cells_uL = 50
#let tf_heatshock_C = 42
#let tf_heatshock_s = 45
// DNA + cells on ice before the shock
#let tf_ice_pre_min = 30
#let tf_ice_post_min = 2
// outgrowth; matters for Kan (unlike Amp)
#let tf_recovery_min = 60
// volume after adding LB
#let tf_recovery_total_mL = 1.0
// kanamycin (plasmid marker)
#let tf_kan_ug_mL = 50
// chloramphenicol (pRARE2 marker)
#let tf_cam_ug_mL = 34
// fixed volume spread per plate (comparable across titration)
#let tf_plate_uL = 100
// plasmid titration: fixed volumes of miniprep (no math needed)
#let tf_dna_lo_uL = 1
#let tf_dna_mid_uL = 2
#let tf_dna_hi_uL = 5
// measured miniprep concentration (Nanodrop); update if re-measured
#let tf_miniprep_ng_uL = 36
// mass delivered = vol x conc
#let tf_dna_lo_ng = calc.round(tf_dna_lo_uL * tf_miniprep_ng_uL, digits: 0)
#let tf_dna_mid_ng = calc.round(tf_dna_mid_uL * tf_miniprep_ng_uL, digits: 0)
#let tf_dna_hi_ng = calc.round(tf_dna_hi_uL * tf_miniprep_ng_uL, digits: 0)
// 950
#let tf_recovery_LB_uL = calc.round(tf_recovery_total_mL * 1000 - tf_cells_uL, digits: 0)
// 3 DNA amounts + 1 no-DNA control
#let tf_n_reactions = 4


// ==========================================================================
//  Day 6: Streaking xpression strain and make glycerol stocks. Pick Kan+Cam
//  transformants, grow overnights (DUAL selection), make glycerol stocks.
//  Mirrors Day 3/4 for the Mach1 clones, with dual selection and the new strain.
// ==========================================================================

// freezer / everyday name
#let strain_express_short = "BL21-hCSE"
// genotype-style record
#let strain_express_full = "BL21(DE3)-R3-pRARE2 / pNIC28-Bsa4-CTHA"
// colonies picked off Kan+Cam (c1, c2, c3)
#let n_clones_express = 3
// glycerol stocks per clone (c1.1, c1.2, c1.3, ...)
#let n_stocks_per_clone_express = 3
// LB overnight per clone (banking only)
#let express_overnight_mL = 15
// culture per stock
#let glycerol_culture_uL = 500
// 50% glycerol per stock (-> 25% final)
#let glycerol_stock_uL = 500
#let cryotubes_express_spare = 2

// 9
#let n_stocks_express = n_clones_express * n_stocks_per_clone_express
// 11
#let cryotubes_express_order = n_stocks_express + cryotubes_express_spare
// 5
#let express_kan_uL = calc.round(express_overnight_mL * 1000 / antibiotic_dilution, digits: 0)
// same 1:1000 dosing for Cam
#let express_cam_uL = express_kan_uL


// ==========================================================================
//  Day 8: Expression culture growth + IPTG induction. Two TB flasks
//  (pNIC28-Bsa4-CTHA in BL21(DE3)-R3-pRARE2). SGC platform induction:
//  0.1 mM IPTG, 18 C overnight - the same pipeline that produced the
//  deposited hCSE structures (PDB 2NMP / 3COG / 3ELP) from this construct.
// ==========================================================================

// TB working volume per flask
#let ind_flask_volume_mL = 500
// flasks induced in parallel
#let ind_n_flasks = 2
#let ind_shake_rpm = 200
// growth phase
#let ind_growth_temp_C = 37
// post-induction expression
#let ind_induction_temp_C = 18
// OD600 at induction (SGC: 2.0 +/- 1, TB)
#let ind_target_OD = 2.0
// hold at 18 C before IPTG (medium cooling)
#let ind_cooldown_min = 60
// IPTG working stock on hand
#let ind_iptg_stock_M = 1.0
// final IPTG (SGC platform default)
#let ind_iptg_final_mM = 0.1
// harvest spin (x g)
#let ind_harvest_g = 4000
#let ind_harvest_min = 15
#let ind_harvest_temp_C = 4

//  ---- DERIVED: IPTG dosing (do not edit) ----
// final(M) = ind_iptg_final_mM / 1000 ; volume = final * flask_vol / stock
#let ind_iptg_per_flask_uL = calc.round(
  ind_iptg_final_mM / 1000 * ind_flask_volume_mL / ind_iptg_stock_M * 1000,
  digits: 0,
)
#let ind_iptg_dilution_fold = calc.round(
  ind_iptg_stock_M / (ind_iptg_final_mM / 1000),
  digits: 0,
)


// ==========================================================================
//  Day 9: Cell extraction - resuspension, sonication, PEI clear, clarification.
//  SGC HEPES IMAC buffer series (supplement 1.1-1.8) for His-tag
//  pNIC28-Bsa4-CTHA. AFFINITY buffer is the 500 mL parent / standard;
//  LYSIS buffer = a 50 mL affinity aliquot + 1x protease inhibitor.
//  All bulk buffers stored SALTS-ONLY at 4 C; TCEP spiked in fresh per run.
//  Mechanical lysis (sonication) - no Bugbuster on hand.
//  Buffers are mixed from concentrated stocks (HEPES / NaCl / imidazole), not
//  weighed per prep; the weigh-once stock masses are defined below.
// ==========================================================================

//  ---- shared composition (HEPES base; Na-phosphate may substitute) ----
// affinity / wash / elution HEPES
#let buf_hepes_mM = 50
// gel-filtration HEPES (lower; Day 10)
#let buf_hepes_gf_mM = 10
#let buf_pH = 7.5
// 500 mM NaCl throughout
#let buf_nacl_M = 0.5
// 1 mM TCEP final (SPIKED FRESH, not stored)
#let buf_tcep_mM = 1.0
// affinity / load / lysis
#let buf_imid_affinity_mM = 10
#let buf_imid_wash_mM = 30
#let buf_imid_elution_mM = 300
// GF only (1.7); Day 10
#let buf_gf_glycerol_pct = 5

//  ---- make volumes (defaults; rescale to your Day 10 column) ----
// parent / standard (supervisor: make 500)
#let aff_make_mL = 500
// extensive wash
#let wash_make_mL = 250
// elution
#let elu_make_mL = 100
// poured off from affinity -> lysis (+ PI)
#let lysis_aliquot_mL = 50

//  ---- physical constants ----
// pre-neutralised 0.5 M TCEP working stock
#let tcep_stock_M = 0.5
// (HEPES / imidazole / NaCl MWs live in the PHYSICAL CONSTANTS block at top)

//  ---- buffer STOCKS (pipetted, to avoid weighing every prep) ----
//  HEPES and imidazole stocks are pre-titrated to buf_pH, so each working
//  buffer needs only a pH check, not a full titration. The phosphate stock is
//  left unbuffered (pH is set when the assay buffer is diluted; Day 10).
// 1 M HEPES, pre-titrated to buf_pH
#let hepes_stock_M = 1.0
// 5 M NaCl
#let nacl_stock_M = 5.0
// 2 M imidazole, pre-titrated to buf_pH
#let imid_stock_M = 2.0
// 50% (v/v) glycerol
#let glycerol_stock_pct = 50
// 0.5 M Na2HPO4 dibasic, unbuffered
#let phos_stock_M = 0.5

//  ---- stock batch sizes + weigh-once masses (made when a stock runs out) ----
#let hepes_stock_make_mL = 500
#let nacl_stock_make_mL = 500
#let imid_stock_make_mL = 250
#let glycerol_stock_make_mL = 500
#let phos_stock_make_mL = 250
#let hepes_stock_mass_g = calc.round(hepes_stock_M * hepes_stock_make_mL / 1000 * mw_hepes, digits: 1)
#let nacl_stock_mass_g = calc.round(nacl_stock_M * nacl_stock_make_mL / 1000 * mw_nacl, digits: 1)
#let imid_stock_mass_g = calc.round(imid_stock_M * imid_stock_make_mL / 1000 * mw_imidazole, digits: 1)
#let phos_stock_mass_g = calc.round(phos_stock_M * phos_stock_make_mL / 1000 * mw_na2hpo4_2h2o, digits: 2)
// neat glycerol to dilute into the 50% stock
#let glycerol_stock_neat_mL = calc.round(glycerol_stock_make_mL * glycerol_stock_pct / 100, digits: 0)

//  ---- DERIVED: per-buffer stock volumes to pipette (replaces salt masses) ----
//  mL of stock = final_mM x make_mL / (stock_M x 1000). NaCl is molar, so it
//  uses buf_nacl_M / nacl_stock_M directly.
#let _stock_mL(mM, V, stock_M) = calc.round(mM * V / (stock_M * 1000), digits: 2)
#let _nacl_stock_mL(V) = calc.round(buf_nacl_M * V / nacl_stock_M, digits: 2)

#let aff_hepes_mL = _stock_mL(buf_hepes_mM, aff_make_mL, hepes_stock_M)
#let aff_nacl_mL = _nacl_stock_mL(aff_make_mL)
#let aff_imid_mL = _stock_mL(buf_imid_affinity_mM, aff_make_mL, imid_stock_M)

#let wash_hepes_mL = _stock_mL(buf_hepes_mM, wash_make_mL, hepes_stock_M)
#let wash_nacl_mL = _nacl_stock_mL(wash_make_mL)
#let wash_imid_mL = _stock_mL(buf_imid_wash_mM, wash_make_mL, imid_stock_M)

#let elu_hepes_mL = _stock_mL(buf_hepes_mM, elu_make_mL, hepes_stock_M)
#let elu_nacl_mL = _nacl_stock_mL(elu_make_mL)
#let elu_imid_mL = _stock_mL(buf_imid_elution_mM, elu_make_mL, imid_stock_M)

//  ---- DERIVED: TCEP fresh-spike dosing (1 mM final from 0.5 M stock) ----
// 2 uL/mL
#let tcep_per_mL_uL = calc.round(buf_tcep_mM / 1000 / tcep_stock_M * 1000, digits: 1)

//  ---- protease inhibitor: "1x" is PRODUCT-DEFINED (must be EDTA-free) ----
// <-- VERIFY on your product datasheet (100x liquid)
#let pi_stock_x = 100
// 10 uL/mL
#let pi_per_mL_1x_uL = calc.round(1000 / pi_stock_x, digits: 1)
// 500 uL for 50 mL
#let pi_lysis_uL = calc.round(pi_per_mL_1x_uL * lysis_aliquot_mL, digits: 0)

//  ---- resuspension / lysis ----
// lysis buffer per g wet pellet (wired into Day 9 resuspend step)
#let lys_resusp_mL_per_g = 5

//  ---- PEI nucleic-acid precipitant (SGC 1.8) ----
//  5% (w/v) working PEI = 10x dilution of the 50% Sigma stock, pH 7.5 (HCl).
//  Dosed into the lysate to 0.15% final (SGC 4.2) to drop nucleic acids
//  before the clarifying spin.
// Sigma 50% stock
#let pei_stock_pct = 50
// working solution
#let pei_working_pct = 5
// standing batch (free knob; keeps months at 4 C)
#let pei_make_mL = 50
// final % in lysate (SGC 4.2)
#let pei_final_pct = 0.15
// 10x
#let pei_dilution_fold = calc.round(pei_stock_pct / pei_working_pct, digits: 0)
// 5.0 mL of 50% stock
#let pei_stock_mL = calc.round(pei_make_mL / pei_dilution_fold, digits: 1)
// 45.0 mL (add ~80% first, pH, then to vol)
#let pei_water_mL = calc.round(pei_make_mL - pei_stock_mL, digits: 1)
// 30 uL of 5% PEI per mL lysate
#let pei_dose_per_mL_uL = calc.round(pei_final_pct / pei_working_pct * 1000, digits: 1)

//  ---- clarification spin (SGC 4.2). rpm is ROTOR-DEPENDENT - set by g-force. ----
#let clarify_rpm = 17000
#let clarify_min = 30
#let clarify_temp_C = 4


// ==========================================================================
//  Day 10: Ni-IMAC affinity capture, TEV tag cleavage, reverse IMAC, and
//  size-exclusion polish (SEC) on Superdex 200. IMAC buffers carry over from
//  Day 9; the only new buffers are the gel-filtration (SEC) buffer and the
//  glycerol-free assay buffer.
// ==========================================================================

//  ---- Gel-filtration / SEC buffer (SGC 1.7), 1 L standing batch ----
//  10 mM HEPES, 0.5 M NaCl, 5% glycerol (v/v); pH 7.5 (NaOH). Stored
//  salts+glycerol only at 4 C - TCEP spiked FRESH per run, like the IMAC
//  buffers. Mixed from the same HEPES / NaCl / glycerol stocks (Day 9).
#let gf_make_mL = 1000
#let gf_hepes_mL = _stock_mL(buf_hepes_gf_mM, gf_make_mL, hepes_stock_M)
#let gf_nacl_mL = _nacl_stock_mL(gf_make_mL)
// mL of 50% glycerol stock for buf_gf_glycerol_pct% final
#let gf_glycerol_stock_mL = calc.round(buf_gf_glycerol_pct * gf_make_mL / glycerol_stock_pct, digits: 2)
// 2000 uL fresh for the full litre
#let gf_tcep_uL = calc.round(tcep_per_mL_uL * gf_make_mL, digits: 0)

//  ---- Glycerol-free assay / instrument buffer (Nasi 2025), standing batch ----
//  10 mM sodium phosphate, pH 8.2. Glycerol-free, low-salt. A WORKING ALIQUOT
//  is exchanged into this off the SEC pool for nDSF, the A280/A428 PLP check,
//  and AzMC / methylene-blue activity. Phosphate (not Tris) keeps spiked PLP
//  intact and matches the reference PAM assay. Diluted from the 0.5 M phosphate
//  stock (Day 9); pH set on dilution with phosphoric acid. Never frozen - the
//  -80 storage stock stays in glycerol. Reductant left OUT by default (thiol
//  reductants raise the AzMC azide background); spike TCEP fresh via
//  tcep_per_mL_uL only on non-AzMC aliquots that need it.
#let buf_phos_asy_mM = 10
#let buf_asy_pH = 8.2
#let asy_make_mL = 250
// mL of 0.5 M phosphate stock for buf_phos_asy_mM mM final
#let asy_phos_mL = _stock_mL(buf_phos_asy_mM, asy_make_mL, phos_stock_M)

//  ---- columns / hardware ----
#let imac_column = "HisTrap HP 5 mL"
#let sec_column = "Superdex 200 Increase 10/300 GL"
// 5 mL/min on the 5 mL HisTrap (prevents Ni leaching at scale)
#let imac_flow_mL_min = 5
// analytical Superdex 200 Increase 10/300
#let sec_flow_mL_min = 0.5
// max sample loop / injection onto the 10/300
#let sec_inject_mL = 0.5

//  ---- TEV cleavage (SGC 4.3.4) ----
// protein : TEV = 20 : 1 (mol/mol)
#let tev_ratio_mol = 20
#let tev_temp_C = 4
// reverse-IMAC load needs <= 30-40 mM imidazole
#let tev_imidazole_max_mM = 30


// Reusable dose table
#let dose_table(rate, unit_label, dose_label, lo: 5, hi: 50, step: 5, digits: 0) = table(
  columns: (auto, auto),
  align: (right, right),
  inset: 7pt,
  stroke: 0.5pt + luma(200),
  table.header([*#unit_label*], [*#dose_label*]),
  ..range(lo, hi + 1, step: step).map(v => (
    [#v], [#calc.round(v * rate, digits: digits)],
  )).flatten()
)
