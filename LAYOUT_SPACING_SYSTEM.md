# BankYar Spatial, Layout, & Spacing System Architecture (v1.0.0)
## Enterprise-Grade Spatial Blueprint for Offline-First Secure Financial Applications

---

## Executive Summary
This document establishes the official **Spatial, Layout, and Spacing System Architecture** for BankYar. Acting as the absolute spatial authority for the product ecosystem, this specification translates the product personality (Stoic, Precise, Empowering) and usability laws established in `DESIGN_PHILOSOPHY.md` into deterministic geometric rules.

To guarantee complete visual integrity, perfect scaling under accessibility magnification, and seamless support for Persian Right-to-Left (RTL) reading flows, **all layout structures are defined using abstract relative token relationships and logical coordinates.** No physical coordinates, hardcoded pixel values, or platform-specific layouts are permitted. This architecture provides the foundational scaffolding that guarantees absolute consistency and visual comfort across all screen sizes, foldables, tablets, and future platform environments.

---

## TABLE OF CONTENTS
1. [Layout Philosophy](#1-layout-philosophy)
2. [Spatial Design Principles](#2-spatial-design-principles)
3. [Grid Architecture](#3-grid-architecture)
4. [Baseline Grid Strategy](#4-baseline-grid-strategy)
5. [Responsive Grid System](#5-responsive-grid-system)
6. [Layout Zones](#6-layout-zones)
7. [Safe Area Strategy](#7-safe-area-strategy)
8. [Screen Margins](#8-screen-margins)
9. [Internal Padding Strategy](#9-internal-padding-strategy)
10. [External Spacing Strategy](#10-external-spacing-strategy)
11. [Vertical Rhythm](#11-vertical-rhythm)
12. [Horizontal Rhythm](#12-horizontal-rhythm)
13. [Content Width Rules](#13-content-width-rules)
14. [Container Rules](#14-container-rules)
15. [Card Layout Rules](#15-card-layout-rules)
16. [List Layout Rules](#16-list-layout-rules)
17. [Detail Screen Layout](#17-detail-screen-layout)
18. [Form Layout Rules](#18-form-layout-rules)
19. [Dialog Layout Rules](#19-dialog-layout-rules)
20. [Bottom Sheet Layout](#20-bottom-sheet-layout)
21. [Navigation Layout](#21-navigation-layout)
22. [App Bar Layout](#22-app-bar-layout)
23. [FAB Placement Rules](#23-fab-placement-rules)
24. [Search Layout](#24-search-layout)
25. [Statistics Layout](#25-statistics-layout)
26. [Chart Layout](#26-chart-layout)
27. [Empty State Layout](#27-empty-state-layout)
28. [Loading Layout](#28-loading-layout)
29. [Error Layout](#29-error-layout)
30. [Keyboard-safe Layout](#30-keyboard-safe-layout)
31. [Foldable Device Strategy](#31-foldable-device-strategy)
32. [Tablet Strategy](#32-tablet-strategy)
33. [Landscape Strategy](#33-landscape-strategy)
34. [Split-screen Strategy](#34-split-screen-strategy)
35. [RTL Layout Strategy](#35-rtl-layout-strategy)
36. [Layout Token Mapping](#36-layout-token-mapping)
37. [Governance Rules](#37-governance-rules)
38. [Validation Rules](#38-validation-rules)
39. [Anti-pattern Catalog](#39-anti-pattern-catalog)
40. [Future Evolution Strategy](#40-future-evolution-strategy)
* [Design Principles Matrix](#design-principles-matrix)
* [Design Laws](#design-laws)
* [UX Decision Matrix](#ux-decision-matrix)
* [Review Checklist](#review-checklist)
* [Architecture Alignment](#architecture-alignment)

---

## 1. Layout Philosophy
The layout system of BankYar is built to treat spatial distribution as a silent, powerful communicator of information hierarchy. In alignment with our *Content-as-Interface* philosophy:
* **Visual Quietness:** Whitespace is not empty space; it is a vital functional element used to isolate, group, and emphasize core financial data. Visual clutter is systematically eliminated.
* **Predictability & Physical Comfort:** The interface utilizes stable, repeating geometric patterns. When users switch screens, their eyes must scan layouts using identical movements, minimizing cognitive friction.
* **One-Handed Utility:** Interactive structures reside strictly within comfortable thumb-reach zones, while purely reading metrics are positioned in upper regions.

---

## 2. Spatial Design Principles
Every spatial arrangement in BankYar must satisfy four core principles:
* **Logical Proximity (Gestalt):** Elements related in function or sequence must reside within unified bounding shapes, separated from neighboring elements by pronounced spatial gaps.
* **Absolute Mirroring:** No layout rule is written physically (e.g., left or right). Every rule uses logical coordinates (start, end, inline, block) to ensure flawless spatial adaptability between Persian RTL and English LTR.
* **Proportionate Scaling:** When screen sizes or typographical scales increase, internal spacing, screen margins, and padding must adapt proportionally to maintain visual balance.
* **Rhythmic Stability:** Spacing must adhere strictly to a common base factor to establish a consistent visual tempo, ensuring the interface feels organized and professional.

---

## 3. Grid Architecture
The system employs a dynamic, adaptive column-grid structure. The grid coordinates horizontal alignments, ensuring that titles, balances, list dividers, and buttons remain mathematically aligned.

```
+-------------------------------------------------------------------------+
|                                SCREEN WIDTH                              |
+-------------------------------------------------------------------------+
|<- Margin ->| [Column 1] | Gutter | [Column 2] | Gutter |<- Margin ->|
|            |            |        |            |        |            |
|            |  Parsed    |        |  Ledger    |        |            |
|            |  SMS       |        |  Details   |        |            |
|            |  Entry     |        |  View      |        |            |
+-------------------------------------------------------------------------+
```

### Grid Metrics Strategy
* **Column Fills:** Columns represent active layout areas where structural elements span. Column widths are dynamic and calculated based on screen estate.
* **Gutter Channels:** Spaces between adjacent columns that prevent informational overlap. Gutters are mapped strictly to the `bankyar.responsive.gutter` token.
* **Boundary Margins:** Outer padding envelopes separating the outermost columns from the physical device edges. Margins are resolved via `bankyar.responsive.margin` tokens.

---

## 4. Baseline Grid Strategy
To prevent vertical layout drift and ensure overlapping text lines never occur, all vertical dimensions are coordinated by a strict **Baseline Grid**.

```
  Text Baseline 1  ========================================= (Inter-line space)
                   ......................................... (Spacing multi-factor)
  Text Baseline 2  =========================================
```

* **Core Multiplier:** The vertical rhythm is governed by a base spatial factor defined by the global token `bankyar.global.space.base`. All component heights, line leading, vertical gaps, and block paddings must be exact integer multiples of this base factor.
* **Persian Line Height Buffer:** Persian characters possess higher vertical structures (ascenders and descenders) compared to Latin text. The baseline strategy enforces standard vertical leading buffers of at least one-and-a-half times the base factor for body text, avoiding typographic collisions.

---

## 5. Responsive Grid System
The responsive grid adapts dynamically to three primary breakpoint device categories defined in `DESIGN_TOKEN_ARCHITECTURE.md`:

```
+-----------------------------------------------------------------------+
|  1. Compact Screen Grid (Standard Smartphones)                        |
|  [Columns: 4] [Margin Token: space.lg] [Gutter Token: space.md]        |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|  2. Medium Screen Grid (Foldables / Small Tablets)                   |
|  [Columns: 8] [Margin Token: space.xl] [Gutter Token: space.lg]        |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|  3. Expanded Screen Grid (Large Tablets / Landscape Desktop)          |
|  [Columns: 12] [Margin Token: space.xxl] [Gutter Token: space.xl]     |
+-----------------------------------------------------------------------+
```

* **Dynamic Structural Scaling:** Components span more or fewer columns depending on the active layout grid, ensuring content never looks excessively stretched.

---

## 6. Layout Zones
To maintain structural predictability, every screen in BankYar is divided into three fixed vertical **Layout Zones**:

```
+-----------------------------------------------------------------------+
|  ZONE A: Header & Diagnostic Overview Zone                            |
|  (Static / Sticky, houses balance, app status, and active filters)    |
+-----------------------------------------------------------------------+
|  ZONE B: Content Ledger & Feed Zone                                   |
|  (Scrollable, houses transaction feeds, details cards, lists)         |
+-----------------------------------------------------------------------+
|  ZONE C: Sticky Control & Quick Navigation Zone                       |
|  (Anchored to bottom, houses bottom navigation, main actions, FAB)    |
+-----------------------------------------------------------------------+
```

---

## 7. Safe Area Strategy
The Safe Area Strategy prevents system status indicators, notches, camera cutouts, and bottom navigation home indicators from overlapping interactive screen elements.

* **Start and End Edge Insets:** Layout boundaries must dynamically query device notch regions, applying logical-start or logical-end padding buffers so that content remains readable.
* **Gesture Navigation Buffers:** The bottom interaction zone must append a structural spacing offset to prevent native system gestures (like swipe-to-home) from conflicting with bottom navigation bar items or floating buttons.

---

## 8. Screen Margins
Screen margins define the outer protective envelope of the interface, separating the physical device bezel from readable content columns.

* **Token Association:** Screen margins are resolved using the responsive token `bankyar.responsive.margin`.
* **Proportionate Scaling:** On compact screens, the margin resolves to `bankyar.space.lg` to maximize reading surface area. On medium and expanded viewports, the margin scales up to `bankyar.space.xl` and `bankyar.space.xxl` respectively, preventing content from colliding with device edges.

---

## 9. Internal Padding Strategy
Internal padding defines the inner space between a container surface's boundary and its nested elements (such as text, icons, and buttons).

```
  +---------------------------------------------------------+
  | Card Bounding Outline                                   |
  |  |<-- Internal padding: bankyar.space.md -->|           |
  |  +---------------------------------------------------+  |
  |  | Nested Text Content Block                         |  |
  |  +---------------------------------------------------+  |
  +---------------------------------------------------------+
```

* **Unified Component Envelope:** Standard container elements (transaction cards, details cards, dialog enclosures) must utilize `bankyar.space.md` as their default inner padding.
* **Dense Informational Surfaces:** High-density components (lists, mini metadata badges) utilize `bankyar.space.sm` or `bankyar.space.xs` to maximize horizontal scan-readability.

---

## 10. External Spacing Strategy
External spacing regulates the gaps between distinct layout components or content blocks, signaling visual relationships without relying on borders.

* **High Structural Association:** Mutually related elements (such as a form input textfield and its top title label) must use a tight external gap mapped to `bankyar.space.sm`.
* **Block Separation:** Independent structural containers (such as separate transaction cards or list sections) must be separated by a pronounced visual gap mapped to `bankyar.space.lg`.

---

## 11. Vertical Rhythm
Vertical Rhythm ensures that as users scroll through transaction feeds, their eyes scan content along a steady, predictable vertical line.

* **Baseline Alignment:** Every text box, separation line, status badge, and container height must align to the baseline grid.
* **Consistent Vertical Intervals:** Visual gaps between major sections must use standard increments (e.g., `bankyar.space.lg` or `bankyar.space.xl`), creating a unified, rhythmic visual flow.

---

## 12. Horizontal Rhythm
Horizontal Rhythm aligns inline visual components, keeping labels, values, currency indicators, and icons mathematically balanced.

* **Anchor Baselines:** In RTL Persian layout feeds, icons are aligned with the logical start edge of the text block, while numerical transaction values are anchored to the logical end edge.
* **Symmetrical Alignments:** Horizontal button pairs or tab triggers must use equal internal padding, ensuring action sizes remain balanced and easy to tap.

---

## 13. Content Width Rules
To prevent text lines from expanding to unreadable widths on large screens, the system enforces a strict maximum content width.

* **Reading Comfort Boundary:** Paragraph elements (transaction notes, SMS details, information pages) must never exceed a comfortable reading boundary defined by `bankyar.responsive.container.width.max`.
* **Excessive Space Allocation:** If the viewport width exceeds this maximum, outer screen margins must expand dynamically to center the content column, preventing visual strain.

---

## 14. Container Rules
Containers act as flat visual envelopes that group related elements. To maintain a quiet visual style, containers follow strict geometric rules:

* **Flat Surfaces:** Containers must avoid 3D styling, heavy colored gradients, or dark drop shadows. They use subtle neutral tones (`bankyar.semantic.color.surface.default`) and thin boundaries (`bankyar.semantic.color.border.default`) to define structure.
* **Curvature Scale:** The corners of standard containers must use the unified curvature token `bankyar.radius.lg` to create a consistent, clean appearance.

---

## 15. Card Layout Rules
Cards represent the primary visual vessel for financial records in BankYar.

```
  +-------------------------------------------------------------------------+
  | Card Container - Curvature: radius.lg                                   |
  |                                                                         |
  |  [Icon: Success Status]  { Merchant Title / Sender }  Amount: +120,000  |
  |                          (Alignment: start)           (Alignment: end)  |
  |                                                                         |
  |  .....................................................................  |
  |  (Inner Separator: border.default)                                      |
  |                                                                         |
  |  Timestamp: 1402/10/12 | Account: Origin Card   [Category Badge: Chip]  |
  +-------------------------------------------------------------------------+
```

* **Z-Axis Elevation:** Cards must reside flat on the background surface. Elevation is communicated using fine border lines (`bankyar.semantic.color.border.default`) rather than visual shadows.
* **Actionable Layout States:** Interactive cards must utilize a visual pressed state mapped to `bankyar.semantic.color.interactive.pressed` to provide instant tactile feedback.

---

## 16. List Layout Rules
List layouts handle scrollable feeds, such as the ledger transaction feed.

* **Continuous Scrolling Flow:** List items must be arranged vertically, with separations defined by subtle hairline dividers (`bankyar.semantic.color.divider.default`) to keep the list organized.
* **Visual Density Modes:** Lists must support comfortable and compact visual modes. Comfortable mode uses `bankyar.space.md` padding, while compact mode adjusts to `bankyar.space.sm` to show more records on a single screen.

---

## 17. Detail Screen Layout
The Detail Screen presents a deep, structured analysis of a single financial record or transaction.

* **Proportionate Columns:** On standard mobile screens, detail sections are stacked vertically. On tablets and wider viewports, the layout transitions to a balanced multi-pane configuration (details on the logical start pane; related categorization rules on the logical end pane).
* **Metadata Grouping:** Related metadata (such as unparsed raw SMS text, matched rules, and debug details) are nested inside flat cards, keeping the layout uncluttered.

---

## 18. Form Layout Rules
Form layouts manage interactive inputs, such as PIN locks, custom transaction notes, or manual template creation.

```
  +-------------------------------------------------------------------------+
  | Form Field Layout                                                       |
  |                                                                         |
  |   { Form Title Label } (Weight: Medium, Size: xs)                       |
  |   [ Input Textbox Outline (Curvature: radius.md, Border: border.default) ]|
  |   [ focused state outline changes border to primary brand accent color ] |
  |   ( Helper / Validation Message below textbox )                          |
  +-------------------------------------------------------------------------+
```

* **Vertical Alignment:** Input titles, textfields, and validation helper text must align strictly to the logical start edge of the form container.
* **Interaction Targets:** To prevent accidental taps, input fields must maintain comfortable vertical touch targets in alignment with accessibility standards.

---

## 19. Dialog Layout Rules
Dialogs are high-priority modal overlays used for critical system confirmations, such as purging local databases or confirming PIN changes.

* **Maximum Screen Coverage:** Dialog widths are constrained to standard responsive proportions, ensuring they never expand to touch screen edges.
* **Logical Reading Priority:** Titles are aligned strictly to the logical start edge. Action buttons are grouped at the bottom, with the primary confirm button positioned at the logical start edge of the button row for immediate action.

---

## 20. Bottom Sheet Layout
Bottom sheets are modal drawers that expand from the bottom of the screen, bringing settings and transaction categorization options directly within comfortable thumb-reach.

```
  +-------------------------------------------------------------------------+
  | Bottom Sheet (Curvature top corners: radius.xl)                          |
  |                                                                         |
  |                          === [ Drag Handle ] ===                        |
  |                                                                         |
  |  { Sheet Header Title }                              [ Close Action ]   |
  |                                                                         |
  |  =====================================================================  |
  |  Scrollable Interactive Content Area (Category selection chips, etc)    |
  |  =====================================================================  |
  |                                                                         |
  |  [ Primary Bottom Action Trigger Button ]                               |
  +-------------------------------------------------------------------------+
```

* **Drag Control Handle:** Sheets must include a centered drag handle at the top edge, indicating that the sheet can be dismissed via downward gestures.
* **Curvature Mask:** Top corners of bottom sheets use the extra-large curve token `bankyar.radius.xl`, while the bottom corners remain flat against the screen boundaries.

---

## 21. Navigation Layout
The navigation layout structures how users move between the main sections of the application (Ledger, Analytics, Rules, Settings).

* **Persistent Bottom Placement:** On mobile devices, navigation resides in a persistent bottom bar. Icons and active markers are horizontally centered within their targets.
* **Lateral Navigation Rails:** On medium (tablet) and expanded screen sizes, the bottom navigation bar transitions to a lateral navigation rail anchored to the logical start edge of the viewport.

---

## 22. App Bar Layout
The App Bar provides a sticky status header at the top of the screen, housing page titles and secondary actions.

* **Dynamic Scroll Transitions:** The App Bar remains flat and blends with the background canvas. When users scroll content underneath, the bar transitions to show a subtle division line (`bankyar.semantic.color.border.default`) to define structure.
* **Symmetrical Controls:** The page title is centered horizontally, with back controls positioned at the logical start edge and auxiliary tools (like help or filter buttons) placed at the logical end edge.

---

## 23. FAB Placement Rules
Floating Action Buttons (FABs) provide rapid access to the screen's primary interactive action (such as manual SMS parsing or rule creation).

```
  RTL Layout:   [ Screen Canvas ]
                |                                                      |
                | [ FAB Icon ]                                         |
                +------------------------------------------------------+
                (FAB positioned at the logical bottom-start edge)
```

* **Logical Positioning:** The FAB is positioned at the logical bottom-start edge of the screen, matching the reading end-point of RTL layouts to ensure high visibility.
* **Visual Protection:** FABs must maintain comfortable spacing buffers from screen edges and the bottom navigation bar to prevent touch overlaps.

---

## 24. Search Layout
The Search Layout houses interactive query inputs, filters, and active tags used to search through transaction histories.

* **Integrated Filtering:** Filter chips are aligned horizontally below the search input field, allowing users to scroll chips horizontally to adjust filters.
* **Instant Text Clearing:** The input field must include an instant clear action positioned at the logical end edge, letting users clear search terms in a single tap.

---

## 25. Statistics Layout
The Statistics Layout structures high-level financial overviews, period selectors, and cash flow summaries at the top of the analytics dashboard.

* **Balance Overviews:** Total balances are displayed in large display typography at the top, centered horizontally to draw immediate focus.
* **Income and Expense Comparison:** Income and expense totals are arranged in balanced, equal-width columns directly below the main balance, grouped inside a flat card.

---

## 26. Chart Layout
Chart layouts handle flat data visualizations, such as spending distribution donuts or monthly cash flow bar graphs.

* **Proportionate Boundaries:** Charts are constrained to stable aspect ratios to prevent graphs from looking stretched on wider screens.
* **Symmetrical Legends:** Chart legends must be grouped cleanly below the main graph, using clear text labels and category tags to represent different metrics.

---

## 27. Empty State Layout
Empty states provide gentle, reassuring guidance when no transactions, rules, or search results are available, avoiding blank screens.

```
  +-------------------------------------------------------------------------+
  | [ Large Illustration Icon ] (bankyar.icon.size.xl)                      |
  |                                                                         |
  | { Brief Reassuring Title } (Weight: Bold, Size: lg)                     |
  | ( Clear Onboarding Instruction or Explanation Text )                    |
  |                                                                         |
  |              [ Primary Get Started Action Button ]                      |
  +-------------------------------------------------------------------------+
```

* **Vertical Centering:** Empty state elements are grouped and centered vertically within the parent layout.
* **Primary Call to Action:** The empty state must include a clear primary button (such as "Import SMS Statement" or "Add Parsing Rule") to guide users on their next steps.

---

## 28. Loading Layout
Loading layouts use flat skeleton elements to represent loading content, maintaining layout stability while background tasks execute.

* **Matched Geometries:** Skeleton elements must match the exact height, curvature, and alignment of the actual cards and lists they represent.
* **No Layout Jumps:** Content boundaries must remain stable as data loads, avoiding awkward shifts or layout jumps.

---

## 29. Error Layout
Error layouts handle parsing failures, PIN mismatches, or diagnostic issues, presenting errors in plain language.

* **Contained Warnings:** Errors are nested inside flat cards, using high-contrast warning indicators to draw immediate attention.
* **Primary Recovery Actions:** Error screens must include a clear, accessible action button (such as "Retry Database Load" or "View Diagnostic Logs") to help users recover.

---

## 30. Keyboard-safe Layout
Keyboard-safe layouts prevent the system soft keyboard from overlapping or obscuring interactive input forms when editing text fields.

* **Dynamic Viewport Shrinking:** Viewports must adjust and shrink dynamically when the keyboard slides up, preventing content from being compressed.
* **Automatic Field Centering:** Focused textfields must scroll automatically to the vertical center of the visible area, keeping inputs clearly visible.

---

## 31. Foldable Device Strategy
Foldable viewports adapt dynamically depending on the active physical state of the device (folded vs unfolded).

```
  Folded State (Single Screen View) -> Unfolded State (Dual Screen Master-Detail)
  +-------------------+               +-------------------+-------------------+
  | Ledger List Feed  |               | Ledger List Feed  | Transaction Detail|
  |                   |     ====>     |                   |                   |
  |                   |               |                   |                   |
  +-------------------+               +-------------------+-------------------+
```

* **Hinge Awareness:** Viewports must detect the active physical hinge region, ensuring text lines and interactive targets never overlap the hinge.
* **Dual-Pane Layouts:** When fully unfolded, the layout transitions to a balanced double-column master-detail view, with navigation rails anchored to the logical start edge.

---

## 32. Tablet Strategy
Tablet layouts utilize larger screens to show complex financial analysis in a single, organized view.

* **Multi-Pane Coordination:** The screen is divided into distinct, balanced columns (navigation rail on the start edge; transaction feed in the center; detailed analysis on the end edge).
* **Maximum Stretch Constraints:** Cards and forms are constrained to standard maximum widths, preventing elements from looking excessively stretched.

---

## 33. Landscape Strategy
Landscape layouts rearrange horizontal screen dimensions to maximize horizontal space, avoiding wide, unreadable text lines.

* **Multi-Column Grid Adjustments:** Single-column lists transition to side-by-side grids, displaying spending charts and recent transactions on a single screen.
* **Compact Header Scales:** Vertical headers are compacted horizontally to maximize scrollable content space in landscape mode.

---

## 34. Split-screen Strategy
Split-screen strategies handle viewports that are compressed horizontally or vertically by multi-tasking operations.

* **Dynamic Column Scaling:** The active grid column count scales down (from 12 columns to 4), adjusting layout dimensions to match compressed viewports.
* **Wrap-First Layouts:** Horizontal columns wrap into vertical stacks, and high-level charts scale down to keep core data legible.

---

## 35. RTL Layout Strategy
RTL Layout strategies ensure that Persian layouts flow and mirror naturally, matching regional reading and interaction habits.

```
  RTL Flow:  [ Margin Start (Right) ]  ==================>  [ Margin End (Left) ]
```

* **Logical Direction Mapping:** Left/right properties are completely excluded from definitions. The layout uses logical start/end coordinates, ensuring alignments mirror automatically when switching locales.
* **Directional Icon Mirroring:** Navigation back chevrons, swipe gestures, progress trackers, and forward indicators mirror dynamically based on active language direction.

---

## 36. Layout Token Mapping
This matrix defines how the spatial layout tokens link component alignments back to global structural multipliers:

| Layout Token Name | Target Property Mapping | Structural Spacing Association |
| :--- | :--- | :--- |
| `bankyar.layout.screen.margin` | Outer screen margins | `bankyar.responsive.margin` |
| `bankyar.layout.card.padding` | Transaction card internal space | `bankyar.space.md` |
| `bankyar.layout.card.gap` | Distance between cards | `bankyar.space.lg` |
| `bankyar.layout.form.field.gap` | Distance between form textfields | `bankyar.space.lg` |
| `bankyar.layout.form.label.gap`| Distance between input and label | `bankyar.space.sm` |
| `bankyar.layout.touch.target.min`| Minimum touch target height | `bankyar.space.xl` |

---

## 37. Governance Rules
To prevent inconsistent layout adjustments and protect visual consistency, all design contributions must comply with the following spatial governance rules:

1. **No Arbitrary Sizes:** Hardcoded margins, offsets, and paddings are strictly prohibited. Every dimension must reference an active layout or spacing token.
2. **Predictable Layout Zones:** Every new screen must follow our standard three-zone structural model (Header, Feed, Control).
3. **Gestalt Alignment:** Related visual elements must use consistent spacing tokens, signaling functional relationships through structured spacing.
4. **Accessibility First:** Spacing, cards, and viewports must support up to 200% system-level text magnification without overlapping or clipping text.

---

## 38. Validation Rules
The design compiler validates all layout and spacing schemas against a strict rule set before deployment:

* **No Physical Units:** Schema definitions are validated to ensure they contain no physical unit references (such as px, dp, sp, pt) or hardcoded dimensions.
* **RTL Compliance:** Layout structures are programmatically checked to verify they use logical start/end properties instead of physical left/right boundaries.
* **Consistent Multipliers:** All vertical spacing, padding, and height dimensions are verified to ensure they are exact integer multiples of the base spatial factor.

---

## 39. Anti-pattern Catalog
The following spatial and visual anti-patterns are strictly prohibited:

* **Physical Layout Hardcoding:** Direct use of physical left/right margins or hardcoded pixel coordinates in layouts is prohibited.
* **Fixed Heights:** Placing body text or list cards inside fixed-height wrappers that clip text when system text scale is increased is prohibited.
* **Overloaded Floating Actions:** Placing multiple floating action buttons on a single screen is prohibited.
* **Arbitrary Spacing Steps:** Using non-standard spacing steps (such as custom gaps or margins) that do not align with our core design tokens is prohibited.

---

## 40. Future Evolution Strategy
As BankYar expands, the Layout and Spacing System is built to scale:

* **Scalable Device Registries:** Support for new physical device profiles (such as smartwatches or large-scale TV interfaces) is added by registering new responsive breakpoint tokens, keeping existing code unchanged.
* **Spatial Token Lifecycles:** Deprecated layout tokens must follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing development teams with clear migration pathways between updates.

---

## Design Principles Matrix

The following matrix defines the priority weight and design rules for the primary spatial dimensions of the BankYar design system:

| Spatial Dimension | Core Usability Goal | Trade-off Rule | Priority Weight | Status |
| :--- | :--- | :--- | :---: | :---: |
| **RTL Layout Symmetry** | Flawless mirrored visual flows for Persian. | Logical start/end coordinates always supersede physical boundaries. | **Highest** | Mandatory |
| **Accessibility Scaling** | Prevents text clipping under 200% magnification. | Responsive vertical wrapping always supersedes fixed horizontal rows. | **Highest** | Mandatory |
| **Grid Alignment** | Stable vertical scanning lines across screens. | Grid alignment always supersedes custom horizontal layouts. | **High** | Mandatory |
| **One-Handed Reach** | Keeps core interactive triggers within thumb-reach. | Bottom-zone control placement always supersedes top-edge actions. | **High** | Mandatory |

---

## Design Laws

Every future screen, feature, and interaction layout in BankYar must strictly comply with these spatial design laws:

1. **The Grid Law:** Every text label, button, and card edge must align mathematically to the active column grid.
2. **The Thumb-Reach Law:** Core interactive buttons and selection list chips must reside within the lower half of the viewport.
3. **The Multiplier Law:** Vertical margins, card paddings, and header heights must align with integer multiples of the base spatial multiplier.
4. **The No-Overlap Law:** Content structures must use responsive heights that expand vertically, ensuring text never overlaps.
5. **The Mirror Law:** All physical coordinates are banned; all layouts must be declared using logical start/end alignments.

---

## UX Decision Matrix

Use this matrix to resolve layout conflicts during feature planning:

| Conflict Scenario | Option A (Decorative/Fixed) | Option B (Simple/Responsive) | Resolution Decision Rule |
| :--- | :--- | :--- | :--- |
| **Visualizing Ledger Cards** | Cards with fixed heights and decorative drop shadows. | Flat cards that expand vertically based on text wrapping. | **Option B.** Expanding flat cards prevent text clipping, ensuring accessibility and readability under large font scales. |
| **Placing Primary Actions** | Placing primary buttons inside top App Bars. | Grouping primary buttons inside bottom sheets or bottom-anchored control rows. | **Option B.** Bottom-anchored controls are easily reachable one-handed, improving physical comfort and utility. |
| **Structuring Forms** | Custom multi-column grid form inputs. | Unified single-column vertical form stacks. | **Option B.** Single-column layouts reduce cognitive load and scale predictably on compact and split-screen viewports. |

---

## Review Checklist

Before implementing or submitting a layout, verify compliance against this checklist:

- [ ] Does the layout align strictly with the active column grid?
- [ ] Are all padding, margin, and gap properties defined using design tokens?
- [ ] Are left/right alignments entirely excluded, using logical start/end properties instead?
- [ ] Does the layout support up to 200% text magnification without overlapping text lines?
- [ ] Are core interactive elements located within comfortable thumb-reach?
- [ ] Does the screen follow the standard three-zone structural model?

---

## Architecture Alignment

This Spatial, Layout, and Spacing System Architecture is fully aligned with the **BankYar Architecture Specification**:
* **Performance-First Rendering:** Smooth scrolling is maintained by keeping intensive calculation off the main thread, allowing layouts to render instantly.
* **Complete Offline Security:** No layout assets, fonts, or tracking elements require external network access, ensuring perfect offline operation.
* **Instant State Transitions:** Viewports render state transitions (such as opening drawer sheets) within 100 milliseconds, keeping the interface feeling instantaneous.

---
**End of Document**
