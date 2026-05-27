//  Batch sizing parameters - edit these to rescale the protocol

// per-bottle count
#let plates_per_antibiotic = 10

// Kan and Cam, each in its own bottle
#let n_antibiotics = 2

// extra dishes labelled and stacked, not poured
#let plates_spare = 2

// 60 mm dish holds 5-10 mL; 10 mL is standard here
#let volume_per_plate_mL = 10

// 10% extra agar for bottle residue and pour loss
#let pour_margin_factor = 1.10

// pre-mixed LB-agar formulation
#let lb_agar_g_per_L = 37

// 1:1000 stock-to-final
#let antibiotic_dilution = 1000

//  Derived values - do not edit directly
#let agar_volume_per_antibiotic_mL = calc.round(
  plates_per_antibiotic * volume_per_plate_mL * pour_margin_factor,
  digits: 0,
)
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