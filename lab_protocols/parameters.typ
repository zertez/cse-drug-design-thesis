//  Batch sizing parameters - edit these to rescale the protocol

// per-antibiotic plate count
#let plates_per_antibiotic = 10

// Kan and Cam, each in its own bottle
#let n_antibiotics = 2

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
#let lb_agar_g_per_L = 37

// 1:1000 stock-to-final
#let antibiotic_dilution = 1000

//  Derived values - do not edit directly

// agar strictly needed to fill the plates, no margin (10 x 15 = 150 mL)
#let agar_volume_required_mL = plates_per_antibiotic * volume_per_plate_mL

// the volume actually made per bottle = the target set above
#let agar_volume_per_antibiotic_mL = agar_volume_per_antibiotic_mL_target

// grand total made across all bottles (200 x 2 = 400 mL)
#let agar_volume_total_mL = agar_volume_per_antibiotic_mL * n_antibiotics

// pour margin implied by the target, for documentation
#let pour_margin_factor = agar_volume_per_antibiotic_mL / agar_volume_required_mL
#let pour_margin_percent = calc.round((pour_margin_factor - 1) * 100, digits: 0)

#let lb_agar_mass_g = calc.round(
  lb_agar_g_per_L * agar_volume_per_antibiotic_mL / 1000,
  digits: 2,
)
#let antibiotic_volume_uL = calc.round(
  agar_volume_per_antibiotic_mL * 1000 / antibiotic_dilution,
  digits: 0,
)
#let dishes_per_antibiotic = plates_per_antibiotic + plates_spare
#let total_plates = plates_per_antibiotic * n_antibiotics
#let total_dishes = dishes_per_antibiotic * n_antibiotics

//  Day 2 streaking consumption (subset of the Day 1 batch)
#let plates_used_day2_per_direction = 2    // 1 workflow + 1 backup per streak direction
#let plates_used_day2_per_antibiotic = plates_used_day2_per_direction * 2  // pos + neg cross-control
#let plates_used_day2_total = plates_used_day2_per_antibiotic * n_antibiotics
