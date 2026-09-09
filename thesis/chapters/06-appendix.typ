// Working settings summary, recorded 8 September 2026; review before submission.
// The complete original record is retained in reproducibility/ph74_2026-09-08/.
= Computational settings <app-computational-settings>

#set heading(outlined: false)
#set text(size: 11pt)
#set par(leading: 0.45em, spacing: 0.6em)

This working record summarises the pH 7.4 preparation, docking and planned MD protocol for the selected neutral ZHAWOC23115 complex and its matched PAM-free control.

#let settings-table(..rows) = block[
  #set text(size: 10pt)
  #set par(leading: 0.45em, spacing: 0.5em, justify: false)
  #table(columns: (1fr, 2fr), inset: 5pt, stroke: 0.4pt + luma(75%),
    table.header([*Parameter*], [*Setting*]), ..rows)
]

== Structure preparation

#settings-table(
  [Software], [Schrödinger Suite 2026-3, Build 122],
  [Receptor], [Refined CSE tetramer; protein protonation reassessed with PROPKA/ProtAssign at pH 7.4; heavy-atom flips disabled],
  [Cofactors], [Four covalent LLP212 residues (chains A–D); retained Z2 model, charge −1 each; excluded from protonation reassignment and Prime refinement],
  [Ligand], [LigPrep/Epik Classic at pH 7.4 with OPLS4; neutral and +1 states considered; neutral ZHAWOC23115 in selected fresh IFD1 used for MD],
)

Protonation states were fixed during MD. The historical Epik pH tolerance was not recorded.

== Induced-fit docking <app-docking-settings>

#settings-table(
  [Search centers / Å], [Previously defined SiteMap centers: AB (−24.3033, 16.6930, −25.1127); BA (−25.7199, 24.6811, −25.7437)],
  [Initial sampling], [New pH 7.4 grids; 12 Å inner and 32 Å outer edges per axis; Glide SP, flexible sampling, Epik penalties],
  [Initial vdW settings], [Receptor scale/cutoff 0.5/0.25; ligand scale/cutoff 0.5/0.15],
  [Sampling / pose retention], [Enhanced sampling 4; expanded sampling; MAXREF 2000; CV_CUTOFF 100; 20 poses per ligand; POSTDOCK_NPOSE 100; POSE_RMSD 1.0 Å],
  [Prime refinement], [Six seeds; residues within 5 Å of ligand; one pass; OPLS4/S-OPLS; energy window 30 kcal/mol],
  [Final Glide stage], [SP, flexible sampling, Epik penalties; up to five poses per ligand/refined receptor; receptor scale/cutoff 1.0/0.25; ligand scale/cutoff 0.8/0.15],
  [Selected IFD1 grid], [Center (−24.379020, 18.302858, −25.469990) Å; 10 Å inner and 23.874463 Å outer edges per axis],
  [MM-GBSA rescoring], [Prime; OPLS4/S-OPLS; VSGB 2.1; ligand minimisation with a fixed receptor],
)

The final Glide stage forms part of the new pH 7.4 IFD calculation. Its automatic outer edge followed the installed ligand-dependent rule $L_("outer") = 14 "Å" + 0.8 d_("max")$, where $d_("max")$ is the largest atom-pair distance in the grid-generating reference ligand, including hydrogens. This software-defined enclosing region accounts for the non-round edge; it is not a pocket diameter or an independently optimised box size. Exact reproduction requires the same software build, reference structures and input order.

#pagebreak()
== Molecular dynamics <app-openmm-settings>

#settings-table(
  [Software / force fields], [OpenMM 8.6; amber14-all.xml; TIP3P water; custom llp_Z2.xml; ligand GAFF 2.11/AM1-BCC as recorded in the preparation manifest],
  [Solvation], [Dodecahedral periodic box; 1.0 nm padding; 0.15 M ionic strength and charge neutralisation],
  [Electrostatics / dispersion], [PME; 1.0 nm cutoff; Ewald tolerance 0.0005; dispersion correction enabled; switching disabled],
  [Integration], [GaMD Langevin integrator; 310.15 K; collision rate 1 ps⁻¹; 2 fs timestep; natural hydrogen masses],
  [Constraints / minimisation], [Bonds to hydrogen constrained; rigid water; maximum 1,000 minimisation iterations],
  [Pressure coupling], [Monte Carlo barostat: 1 bar, every 25 steps during NPT; disabled during boosted NVT phases],
  [Output intervals], [Coordinates 10 ps; checkpoints 100 ps; energy and boost records 2 ps, with additional phase/output-boundary records],
)

The PAM-free control was made by removing the ligand while retaining the protein, cofactors, microstates and initial solvent/ions. Each system underwent its own minimisation and equilibration.

== GaMD settings and schedule <app-gamd-settings>

GaMD used the MiaoLab GaMD-OpenMM implementation @Copeland2022GaMDOpenMM with dual total/dihedral boosts, lower-bound thresholds and target boost standard deviations of 6 kcal/mol for each channel. Energy statistics used a 100 ps window. Boost parameters were fixed after GaMD equilibration for NVT production.

#settings-table(
  [Initial equilibration], [0.5 ns NVT, then 2.0 ns NPT],
  [Conventional MD], [0.4 ns preparation + 1.6 ns energy-statistics collection],
  [GaMD equilibration], [1.0 ns preparation + 9.0 ns boost-statistics adaptation],
  [Planned production], [200 ns per submitted system; 214.5 ns including preparation],
)

=== Run records <app-run-records>

The recorded submission seeds were 1555146408 (ligand-bound) and 663367594 (PAM-free). These seeds controlled the integrator and initial velocities; the barostat used seed + 1. Final reporting must replace planned production with completed, analysed trajectory lengths and confirm the actual software environment, platform and precision from those runs.

== Structure visualisation and supporting records

The selected complex was visualised in Blender 5.2.1 with Molecular Nodes. Ligand carbons were cyan and LLP carbons gray, with conventional element colours for heteroatoms and a white background. The displayed docking boxes used the selected IFD1 grid center and dimensions above, with a shared coordinate transformation for atoms and boxes.

The complete settings record, exact coordinates, input files, software identifiers and verification details are retained with the thesis source in #text(size: 9pt)[`reproducibility/ph74_2026-09-08/`]. Some original docking intermediates are missing; the archive documents the surviving setup rather than guaranteeing regeneration of identical historical poses.
