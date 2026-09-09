// ==========================================================================
// main.typ — Compile this file: typst compile main.typ
// ==========================================================================
#import "_packages.typ": *
#import "uib-biomed-thesis.typ": uib-thesis
#import "glossary.typ": glossary-entries

#show: make-glossary
#register-glossary(glossary-entries)

#show: uib-thesis.with(
  title: "De Novo Design of Positive Allosteric Modulators of Human Cystathionine γ-Lyase: Targeting a Potential Therapeutic Pathway in Neurodegeneration",
  author: "Marcus Dalaker Figenschou",
  study-track: "Molecular Medicine",
  department: "Department of Biomedicine",
  // additional-department: "Department of Chemistry",
  semester-year: "Spring 2027",
  logo: "figures/uib-seal.png",
  acknowledgements: [
    I would like to express my sincere gratitude to my supervisors ...
    #lorem(80)
  ],
)

// -- Abbreviations --
#heading(numbering: none)[Abbreviations]
#[
  #show emph: it => it.body
  #print-glossary(glossary-entries, show-all: true)
]

// -- Chapters --
#include "chapters/00-summary.typ"
#include "chapters/01-introduction.typ"
#include "chapters/02-aims.typ"
#include "chapters/03-methods.typ"
#include "chapters/04-results.typ"
#include "chapters/05-discussion.typ"


// -- References --
// Uncomment once you have a .bib file:
#bibliography(
  "thesis.bib",
  title: auto,

  style: "apa",
)

#[
  #counter(heading).update(0)
  #set heading(numbering: "A.1")
  #include "chapters/06-appendix.typ"
]
