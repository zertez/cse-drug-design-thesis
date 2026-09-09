// 3. Materials and Methods (max 10 pages)
// Tense: past tense.
#import "../_packages.typ": *
#import fletcher.shapes: brace, diamond, hexagon, parallelogram, pill
= Materials and Methods

== Materials

Unless otherwise stated, all chemicals were purchased from Sigma-Aldrich (Merck, Darmstadt, Germany).

=== Reagents and Kits

#align(center)[
  #table(
    columns: (auto, auto, auto),
    // Auto-sizes columns based on content
    inset: 10pt,
    align: horizon,
    fill: (x, y) => if y == 0 { gray.lighten(80%) },
    // Light gray header
    [*Reagent/Kit Name*], [*Manufacturer*], [*Catalog Details*],
    [Tris-HCl (1 M, pH 7.5)], [Sigma-Aldrich], [T6561],
    [SDS (10 %)], [Merck], [S2580],
    [Protein A/G Magnetic Beads], [Thermo Fisher], [N/A],
  )
]

=== Plasmids and Bacterial Strains



== Computational Methods

=== Molecular Modelling and System Preparation

The CSE tetramer and its four covalent pyridoxal phosphate–lysine cofactors (LLP212) were prepared in Maestro. Protein protonation was reassessed at pH 7.4 using PROPKA/ProtAssign, and ligand states were prepared with LigPrep/Epik. The reviewed LLP chemistry was retained. The selected neutral ZHAWOC23115 complex supplied the ligand-bound MD system. A matched PAM-free control retained its protein/cofactor microstate and initial solvent and ions after ligand removal. Preparation details are recorded in @app-computational-settings.

=== Virtual Screening and Docking

Glide and Prime were used for induced-fit docking in the proposed CSE interface pocket. Initial sampling used previously defined SiteMap-derived centers. Selected seeds underwent local receptor refinement and final Glide redocking, followed by geometric inspection and Prime MM-GBSA rescoring. Redocking denotes the final stage of the new pH 7.4 calculation. The selected neutral fresh IFD1 pose was retained with its refined receptor for MD preparation. Grid dimensions and numerical settings are provided in @app-docking-settings.

=== Molecular Dynamics and Enhanced Sampling

Explicit-solvent molecular dynamics simulations were set up in OpenMM @Eastman2024OpenMM8 with fixed protonation states assigned at pH 7.4. Enhanced sampling used Gaussian accelerated molecular dynamics (GaMD) through the MiaoLab GaMD-OpenMM implementation @Copeland2022GaMDOpenMM. Both systems used minimization, conventional equilibration, energy-statistics collection and GaMD equilibration before production with fixed boost parameters. Force fields, integration settings and stage durations are recorded in @app-openmm-settings and @app-gamd-settings. Requested production lengths are distinguished from completed sampling in @app-run-records.

// All computational scripts are available at: https://github.com/username/repository

== Experimental Methods

=== Protein Expression and Purification

#lorem(80)

=== Differential Scanning Fluorimetry (DSF)

#lorem(60)

=== LC-MS / HPLC Analysis

#lorem(60)

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi)/2 $