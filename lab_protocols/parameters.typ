//  Batch sizing parameters - edit these to rescale the protocol

// per-antibiotic plate count
#let plates_per_antibiotic = 3

// antibiotic STOCKS / single-antibiotic revival conditions (Kan, Cam).
// Drives the Day 2 cross-streak logic (each gets a + and a - control).
#let n_antibiotics = 2

// agar bottles / selection conditions poured: Kan, Cam, and Kan+Cam (double).
// The double bottle is banked for transformant selection at the later
// transformation step; it is not used in the Day 2-5 revival workflow.
#let n_agar_bottles = 4

// extra dishes labelled and stacked, not poured
#let plates_spare = 2

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
#let lb_broth_volume_per_bottle_mL = 500
#let n_lb_broth_bottles = 2
#let lb_broth_g_per_L = 20.6          // Sigma L7658 EZMix: 20.6 g/L

// TB modified - high-density expression medium (used in a later document).
// Glycerol is the carbon source and is added before autoclaving.
#let tb_broth_volume_mL = 200
// Sigma T0918: 47.6 g/L + 8 mL/L glycerol
#let tb_broth_g_per_L = 47.6
#let tb_glycerol_mL_per_L = 8


// One overnight culture per picked colony (clone). Stocks are aliquots of that single culture, so n_stocks_per_clone does NOT add cultures.

// Mach1 (#42365) + BL21 (#26242)
#let n_strains = 2
// colonies picked -> parallel overnight cultures
#let n_clones_per_strain = 3
// glycerol cryotubes banked per culture
#let n_stocks_per_clone = 3
// LB working volume per overnight tube (see aeration note)
#let culture_volume_mL = 50
#let cryotubes_spare = 2

//  Derived values - do not edit directly

// agar strictly needed to fill the plates, no margin (10 x 15 = 150 mL)
#let agar_volume_required_mL = plates_per_antibiotic * volume_per_plate_mL

// the volume actually made per bottle = the target set above
#let agar_volume_per_antibiotic_mL = agar_volume_per_antibiotic_mL_target

// grand total made across all agar bottles (200 x 3 = 600 mL)
#let agar_volume_total_mL = agar_volume_per_antibiotic_mL * n_agar_bottles

// pour margin implied by the target, for documentation
#let pour_margin_factor = agar_volume_per_antibiotic_mL / agar_volume_required_mL

#let lb_agar_mass_g = calc.round(
  lb_agar_g_per_L * agar_volume_per_antibiotic_mL / 1000,
  digits: 2,
)
#let antibiotic_volume_uL = calc.round(
  agar_volume_per_antibiotic_mL * 1000 / antibiotic_dilution,
  digits: 0,
)
#let dishes_per_antibiotic = plates_per_antibiotic
#let total_plates = plates_per_antibiotic * n_agar_bottles
#let total_dishes = dishes_per_antibiotic * n_agar_bottles

//  Day 2 streaking consumption (subset of the Day 1 batch)
#let plates_used_day2_per_direction = 2    // 1 workflow + 1 backup per streak direction
#let plates_used_day2_per_antibiotic = plates_used_day2_per_direction * 2  // pos + neg cross-control
#let plates_used_day2_total = plates_used_day2_per_antibiotic * n_antibiotics

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
#let n_cultures_total = n_clones_per_strain * n_strains
#let n_stocks_per_strain = n_clones_per_strain * n_stocks_per_clone
#let n_stocks_total = n_stocks_per_strain * n_strains
#let n_cryotubes_order = n_stocks_total + cryotubes_spare
#let antibiotic_per_culture_uL = calc.round(
  culture_volume_mL * 1000 / antibiotic_dilution,
  digits: 0,
)