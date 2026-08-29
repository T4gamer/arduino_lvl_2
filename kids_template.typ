// ============================================
// Kid-Friendly Pandoc + Typst Template
// Handles missing metadata gracefully
// ============================================

// --- Pandoc compatibility stubs ---
#let horizontalrule = line.with(start: (0%, 0%), end: (100%, 0%), stroke: 2pt + rgb("#FF6B6B"))
#let lineblock = it => it
#let tightlist = it => it

// ============================================
// THEME COLORS
// ============================================
#let c-bg = rgb("#FFF8E7")
#let c-text = rgb("#2C3E50")
#let c-h1-bg = rgb("#FF6B6B")
#let c-h2-bg = rgb("#4ECDC4")
#let c-h3-fg = rgb("#FF6B6B")
#let c-code-bg = rgb("#1E1E1E")
#let c-code-fg = rgb("#A6E22E")
#let c-table-header = rgb("#FF6B6B")
#let c-table-stripe = rgb("#FFF0F0")

// ============================================
// MAIN DOCUMENT FUNCTION
// ============================================
#let kidspaper(
  title: none,
  author: none,
  date: none,
  body
) = {
  // Set document title if provided
  $if(title)$
  set document(title: "$title$")
  $endif$
  
  // Page setup
  set page(
    paper: "a4",
    margin: (x: 2.2cm, y: 2.2cm),
    fill: c-bg,
    footer: context {
      align(center)[
        #text(size: 9pt, fill: rgb("#BBB"))[
          #counter(page).display("1 / 1", both: true)
        ]
      ]
    }
  )
  
  // Typography
  set text(
    font: ("Segoe UI", "Arial", "DejaVu Sans"),
    size: 12pt,
    fill: c-text,
    lang: "ar",
    dir: rtl
  )
  
  set par(justify: true, leading: 1.5em, spacing: 1.2em)
  
  // ==========================================
  // HEADINGS
  // ==========================================
  set heading(numbering: none)
  
  show heading.where(level: 1): it => block(
    fill: c-h1-bg,
    inset: (x: 16pt, y: 12pt),
    radius: 10pt,
    width: 100%,
    spacing: 1.5em,
    text(fill: white, size: 22pt, weight: "black")[⭐ #it.body]
  )
  
  show heading.where(level: 2): it => block(
    fill: c-h2-bg,
    inset: (x: 14pt, y: 10pt),
    radius: 8pt,
    width: 100%,
    spacing: 1.2em,
    text(fill: white, size: 15pt, weight: "bold")[⚡ #it.body]
  )
  
  show heading.where(level: 3): it => block(
    inset: (x: 10pt, y: 6pt),
    spacing: 1em,
    text(fill: c-h3-fg, size: 13pt, weight: "bold")[▸ #it.body]
  )
  
  // ==========================================
  // CODE BLOCKS
  // ==========================================
  show raw.where(block: true): it => block(
    fill: c-code-bg,
    inset: 14pt,
    radius: 10pt,
    width: 100%,
    spacing: 1em,
    stroke: 1pt + rgb("#333"),
    text(
      fill: c-code-fg,
      font: ("Consolas", "Courier New", "monospace"),
      size: 9.5pt,
      it
    )
  )
  
  show raw.where(block: false): it => box(
    fill: rgb("#FFF3CD"),
    inset: (x: 6pt, y: 2pt),
    radius: 4pt,
    text(
      fill: rgb("#856404"),
      font: ("Consolas", "Courier New"),
      size: 10pt,
      it
    )
  )
  
  // ==========================================
  // BLOCKQUOTES
  // ==========================================
  show quote: it => block(
    fill: rgb("#E8F6F3"),
    inset: 14pt,
    radius: 8pt,
    width: 100%,
    spacing: 1em,
    stroke: (left: 4pt + rgb("#4ECDC4")),
    text(size: 11pt, style: "italic", fill: rgb("#1A5276"))[💡 #it.body]
  )
  
  // ==========================================
  // TABLES
  // ==========================================
  set table(
    fill: (x, y) => if y == 0 { c-table-header } else if calc.even(y) { c-table-stripe } else { white },
    stroke: (x, y) => (
      bottom: if y == 0 { 2pt + c-h2-bg } else { 0.5pt + rgb("#DDD") }
    ),
    inset: 10pt,
  )
  
  show table.cell.where(y: 0): it => text(fill: white, weight: "bold", size: 10.5pt, it)
  show table.cell: it => text(size: 10.5pt, it)
  
  // ==========================================
  // LISTS
  // ==========================================
  set list(
    marker: (text(fill: c-h1-bg, size: 14pt, "▸"), text(fill: c-h2-bg, size: 12pt, "▹")),
    spacing: 0.8em,
    indent: 1.2em
  )
  
  set enum(
    numbering: (..nums) => text(fill: c-h1-bg, weight: "bold", size: 12pt, nums.pos().map(str).join(".") + "."),
    spacing: 0.8em,
    indent: 1.2em
  )
  
  // ==========================================
  // LINKS
  // ==========================================
  show link: it => text(fill: rgb("#2980B9"), weight: "bold", underline(it))
  
  // ==========================================
  // TITLE PAGE (only if title exists)
  // ==========================================
  $if(title)$
  page(margin: 3cm)[
    #align(center + horizon)[
      #box(
        fill: c-h1-bg,
        inset: 20pt,
        radius: 16pt,
        text(size: 34pt, fill: white, weight: "black")[🚀 $title$]
      )
      #v(1.5em)
      $if(author)$
      #text(size: 14pt, fill: rgb("#666"))[✍️ $for(author)$$author$$sep$, $endfor$]
      #v(0.8em)
      $endif$
      $if(date)$
      #text(size: 11pt, fill: rgb("#999"))[📅 $date$]
      $endif$
    ]
  ]
  $endif$
  
  // ==========================================
  // BODY
  // ==========================================
  body
}

// ============================================
// INVOKE WITH PANDOC METADATA (conditional)
// ============================================
#show: kidspaper.with(
$if(title)$
  title: "$title$",
$endif$
$if(author)$
  author: ($for(author)$"$author$"$sep$, $endfor$),
$endif$
$if(date)$
  date: "$date$",
$endif$
)

$body$