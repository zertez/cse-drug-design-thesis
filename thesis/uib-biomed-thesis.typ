// ==========================================================================
// uib-biomed-thesis.typ
// University of Bergen — Master's Thesis in Biomedical Sciences
// Department of Biomedicine, V2025 Guidelines
// ==========================================================================
//
// Formatting spec:
//   - A4, 2.5 cm margins
//   - 12pt serif, justified, 1.5x line spacing
//   - ~70 pages (+/- 10), excluding TOC, references, appendices
//   - Page numbers bottom-center
//
// Usage:
//   #import "uib-biomed-thesis.typ": uib-thesis
//   #show: uib-thesis.with(title: "...", author: "...", ...)
// ==========================================================================
#import "_packages.typ": *



#let uib-thesis(
  title: "",
  subtitle: none,
  author: "",
  study-track: "",
  department: "Department of Biomedicine",
  additional-department: none,
  university: "University of Bergen",
  semester-year: "",
  logo: none, // path to UiB owl logo, e.g. "figures/uib-logo.png"
  acknowledgements: none, // content block
  glossary-entries: none, // glossarium entry list
  body,
) = {
  // -- Document metadata --
  set document(title: title, author: author)

  // -- Page layout --
  set page(
    paper: "a4",
    margin: 2.5cm,
    numbering: "1",
    number-align: center,
  )

  // -- Typography --
  set text(
    font: "Times New Roman",
    size: 12pt,
    lang: "en",
  )
  set par(
    leading: 0.75em,
    first-line-indent: 0pt,
    spacing: 1.0em,
    justify: true,
  )

  // -- Headings --
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(1em)
    text(size: 16pt, weight: "bold", it)
    v(0.8em)
  }
  show heading.where(level: 2): it => {
    v(0.8em)
    text(size: 14pt, weight: "bold", it)
    v(0.5em)
  }
  show heading.where(level: 3): it => {
    v(0.6em)
    text(size: 12pt, weight: "bold", it)
    v(0.3em)
  }

  // -- Figures: caption below --
  set figure(gap: 1em)
  show figure.caption: it => text(size: 10pt, it)

  // -- Tables: caption above --
  show figure.where(kind: table): set figure.caption(position: top)

  // ======================================================================
  // FRONT PAGE
  // ======================================================================

  let department-line = if additional-department != none {
    [#department / #additional-department]
  } else {
    [#department]
  }

  page(numbering: none, margin: 2.5cm)[
    #v(2fr)

    #align(center)[
      #text(size: 24pt, weight: "bold")[#title]

      #if subtitle != none {
        v(0.5em)
        text(size: 16pt, style: "italic")[#subtitle]
      }

      #v(2cm)
      #text(size: 14pt)[#author]
      #v(2cm)

      #if logo != none {
        align(center, image(logo, width: 8cm))
        v(1.5cm)
      }

      #text(size: 12pt)[
        This thesis is submitted in partial fulfilment of the requirements for the degree of
        Master in Biomedical Sciences -- #emph[#study-track]
      ]

      #v(1cm)
      #text(size: 12pt)[
        #department-line \
        #university
      ]
      #v(1cm)
      #text(size: 12pt)[#semester-year]
    ]

    #v(3fr)
  ]

  // ======================================================================
  // ACKNOWLEDGEMENTS (max 1 page)
  // ======================================================================

  if acknowledgements != none {
    page(numbering: none)[
      #heading(outlined: true, numbering: none)[Acknowledgements]
      #acknowledgements
    ]
  }

  // ======================================================================
  // TABLE OF CONTENTS
  // ======================================================================

  page(numbering: none)[
    #heading(outlined: false, numbering: none)[Table of Contents]
    #outline(
      title: none,
      indent: 1.5em,
      depth: 3,
    )
  ]

  // ======================================================================
  // LIST OF ABBREVIATIONS
  // ======================================================================

  if glossary-entries != none {
    page(numbering: none)[
      #heading(outlined: true, numbering: none)[List of Abbreviations]
      #print-glossary(glossary-entries)
    ]
  }

  // ======================================================================
  // BODY — numbered pages start here
  // ======================================================================

  counter(page).update(1)
  body
}
