// compile: typst compile docs/dependency-graph.typ docs/dependency-graph.png

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#set page(
  width: auto,
  height: auto,
  margin: 1em,
)
#set text(font: "Inter", size: 9pt)

#let domain-color = (
  core: rgb("#3b82f6"), // blue
  deai: rgb("#f59e0b"), // amber
  shared: rgb("#6b7280"), // gray
  orchestrator: rgb("#10b981"), // emerald
)

#let core-fill = domain-color.core.lighten(85%)
#let anti-fill = domain-color.deai.lighten(85%)
#let shared-fill = domain-color.shared.lighten(85%)
#let orch-fill = domain-color.orchestrator.lighten(85%)

#diagram(
  spacing: (6em, 4em),
  node-stroke: 0.8pt,
  edge-stroke: 1pt + luma(80),
  node-corner-radius: 0pt,

  // ── Row 0: Input ──────────────────────────────────
  node((2, 0), [*Input Text*], fill: white, stroke: 1pt + luma(180), width: 6em),

  // ── Row 1: Shared infrastructure ──────────────────
  node((0, 1), [`common.py`\ Singletons], fill: shared-fill, stroke: domain-color.shared, width: 7em),
  node((2, 1), [`Stanza (id)`\ POS + Tokenize], fill: shared-fill, stroke: domain-color.shared, width: 7em),
  node((4, 1), [`PySastrawi`\ ECS Stemmer], fill: shared-fill, stroke: domain-color.shared, width: 7em),

  // ── Row 2: Word-level (Group A) ───────────────────
  node((0, 2), [*L1* Baku\ `validate_baku.py`], fill: core-fill, stroke: domain-color.core, width: 8em),
  node((1.5, 2), [*L2* Stem\ `validate_baku.py`], fill: core-fill, stroke: domain-color.core, width: 8em),
  node((3, 2), [*L3* KBBI Root\ `validate_baku.py`], fill: core-fill, stroke: domain-color.core, width: 8em),
  node((4.5, 2), [*L9* Foreign\ `tag_foreign.py`], fill: core-fill, stroke: domain-color.core, width: 8em),

  // ── Row 3: Sentence-level (Group B) ───────────────
  node((0, 3), [*L4* EYD di-/ke-\ `check_eyd.py`], fill: core-fill, stroke: domain-color.core, width: 8em),
  node((1.5, 3), [*L6* AI Patterns\ `scan_ai.py`], fill: anti-fill, stroke: domain-color.deai, width: 8em),
  node((3, 3), [*L7* Rhythm\ `analyze_rhythm.py`], fill: anti-fill, stroke: domain-color.deai, width: 8em),
  node((4.5, 3), [*L8* Passive\ `classify_passive.py`], fill: anti-fill, stroke: domain-color.deai, width: 8em),

  // ── Row 4: Orchestrator ───────────────────────────
  node((2, 4), [*run_all.py*\ Score 0–100], fill: orch-fill, stroke: domain-color.orchestrator, width: 8em),

  // ── Edges: Input → shared ─────────────────────────
  edge((2, 0), (0, 1), "-|>"),
  edge((2, 0), (2, 1), "-|>"),
  edge((2, 0), (4, 1), "-|>"),

  // ── Edges: Shared → word-level ────────────────────
  edge((4, 1), (1.5, 2), "-|>", [stem], label-side: right, bend: 0deg),
  edge((0, 1), (0, 2), "-|>"),

  // ── Edges: L2 → L3, L9 (dependency) ───────────────
  edge((1.5, 2), (3, 2), "-|>", [root]),
  edge((1.5, 2), (4.5, 2), "-|>", [root], bend: -15deg),

  // ── Edges: Shared → sentence-level ────────────────
  edge((2, 0.9), (0, 3), "-|>", bend: -5deg),
  edge((2, 1), (1.5, 3), "-|>", bend: 25deg),
  edge((2, 1), (3, 3), "-|>", bend: -50deg),
  edge((2, 1), (4.5, 3), "-|>", bend: 25deg),

  // ── Edge: L2 → L8 (verb root for Pasif Persona) ──
  edge(
    (1.5, 2),
    (4.5, 3),
    "-|>",
    text(
      fill: domain-color.deai,
    )[verb root],
    bend: -55deg,
    stroke: 1pt + domain-color.deai,
  ),

  // ── Edges: All layers → orchestrator ──────────────
  edge((0, 2), (2, 4), "-|>", bend: -15deg),
  edge((1.5, 2), (2, 4), "-|>", bend: 30deg),
  edge((3, 2), (2, 4), "-|>", bend: -50deg),
  edge((4.5, 2), (2, 4), "-|>", bend: 25deg),
  edge((0, 3), (2, 4), "-|>", bend: -16deg),
  edge((1.5, 3), (2, 4), "-|>", bend: -70deg),
  edge((3, 3), (2, 4), "-|>", bend: -30deg),
  edge((4.5, 3), (2, 4), "-|>", bend: -7deg),
)

// ── Legend ───────────────────────────────────────────

#v(1em)
#grid(
  columns: 2,
  gutter: 1em,
  grid(
    columns: 4,
    gutter: 1em,
    rect(
      fill: core-fill,
      stroke: domain-color.core,
      width: 1em,
      height: 0.7em,
      radius: 0pt,
    ),
    text(
      size: 7pt,
    )[bahasa-core],

    rect(
      fill: anti-fill,
      stroke: domain-color.deai,
      width: 1em,
      height: 0.7em,
      radius: 0pt,
    ),
    text(
      size: 7pt,
    )[deai-style],
  ),
  grid(
    columns: 4,
    gutter: 1em,
    rect(
      fill: shared-fill,
      stroke: domain-color.shared,
      width: 1em,
      height: 0.7em,
      radius: 0pt,
    ),
    text(
      size: 7pt,
    )[shared infra],

    rect(
      fill: orch-fill,
      stroke: domain-color.orchestrator,
      width: 1em,
      height: 0.7em,
      radius: 0pt,
    ),
    text(
      size: 7pt,
    )[orchestrator],
  ),
)
