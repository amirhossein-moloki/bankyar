# BankYar Home Dashboard Screen Specification (v1.2.0)
## High-Fidelity UI Design Specification for Production-Ready Implementation

**Project Name:** BankYar
**Framework Target:** Flutter (Code-Agnostic Design Blueprint)
**Platform Target:** Android (RTL-Native Layout)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Classification:** Product & Engineering UI Specification

---

## 1. Design Philosophy & Vision

The BankYar Home Dashboard is designed as a secure personal cash flow ledger that runs completely offline with zero network permissions. Facing incoming banking SMS alerts can often feel stressful or overwhelming. To address this, the Home Dashboard translates carrier SMS text streams into a structured, highly calm, and reassuring personal balance command center.

In strict compliance with BankYar's visual design standards:
- **Zero Framework Code:** All layouts, hierarchies, and components are defined without direct code structures, classes, or layout construct names (such as elements from layout frameworks).
- **Zero Raw Styling Metrics:** Physical measurements (such as physical offsets, density-independent values, or scale-independent typography units) are strictly omitted. All spacing, rounded corners, borders, and typography scales map directly to abstract design tokens.
- **Zero Hardcoded Colors:** All color definitions reference semantic color tokens (with no raw hex color codes used) that adapt dynamically between Light, Dark, and High-Contrast themes.
- **RTL-First Structure:** Layouts, reading flows, and component alignments progress naturally from the logical start edge (right) to the logical end edge (left) following Persian RTL reading patterns.

---

## Deliverable 1: Complete Screen Description

The BankYar Home Dashboard serves as the central landing workspace for offline personal financial management. Upon initial launch or standard resumption, the screen presents a clean, non-reflective canvas that evokes the security of a physical safe vault. The layout establishes a peaceful visual hierarchy, grouping data in flat card enclosures defined by thin, medium-contrast borders rather than deep, distracting 3D shadows.

All Persian scripts are rendered with zero letter-spacing tracking, preserving the natural connecting ligatures of cursive handwriting. Monospace alignment is enforced strictly on Latin-character numeric strings, ensuring credit and debit figures align perfectly in vertical registers. The screen layout transitions seamlessly across diverse form factors, automatically transforming from a single scrollable viewport on standard smartphones into a balanced multi-pane master-detail presentation on tablets and foldable devices.

---

## Deliverable 2: Grid & Spatial Layout Specification

The dashboard layout utilizes a strict relative grid system to establish spatial stability and alignment across varying device screen sizes.

### Grid System Layout
- **Column Scaffolding:** Adaptively scales from compact phone screens to multi-column tablet layouts.
  - **Phone Viewport:** 4 columns
  - **Large Phone Viewport:** 4 columns
  - **Tablet Viewport:** 8 columns (double-column master-detail split)
  - **Foldable Viewport:** 8 columns (adaptive layout folding split)
- **Outer Margin Inset:** Aligns strictly to `bankyar.responsive.margin` token.
- **Gutter Spacing:** Horizontal gaps between elements are bound to `bankyar.responsive.gutter` token.
- **Rhythm Multipliers:** Spacing and containment pads are multiples of the base spacing unit (`bankyar.global.space.base`):
  - `bankyar.space.xxs` (0.25x base unit)
  - `bankyar.space.xs` (0.5x base unit)
  - `bankyar.space.sm` (1x base unit, 8-unit proportional step)
  - `bankyar.space.md` (2x base unit)
  - `bankyar.space.lg` (3x base unit)
  - `bankyar.space.xl` (4x base unit)
  - `bankyar.space.xxl` (6x base unit)

### Safe Area Strategy
- **Top System Status Buffer:** Region 1 includes a dynamic structural offset to match the device notch or status bar, preventing branding from overlapping system icons.
- **Bottom Navigation Buffer:** Region 7 appends a structural gesture buffer matching the device's navigation bar height, preventing touch conflicts with system home actions.

---

## Deliverable 3: Component Arrangement & Visual Composition Map

The visual workspace is organized into three distinct coordinate layers that segment information logically on the screen:

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY HEADER & DIAGNOSTICS] - Pinned at Viewport Top         |
|  +-------------------------------------------------------------------+  |
|  | [Diag Indicator]            [App Title Logo]      [Notification]  |  |
|  | (Logical End / Left)        (Center-Aligned)      (Logical Start) |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & FEED] - Primary Scrollable Container   |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 2: Greeting Section]                                     |  |
|  |                                                                   |  |
|  |  [Region 3: Total Balance Display Card]                           |  |
|  |  - Displays total net worth in display typography                 |  |
|  |                                                                   |  |
|  |  [Region 4: Inflow & Outflow Comparison Cards]                    |  |
|  |  - Parallel horizontal blocks showing monthly summary data       |  |
|  |                                                                   |  |
|  |  [Region 5: Search Bar & Interactive Filter Row]                  |  |
|  |  - Horizontal scrolling row of chip containers starting from right |  |
|  |                                                                   |  |
|  |  [Region 6: Analytical Summary Workspace]                          |  |
|  |  - Aspect-ratio locked donut visualization & monospace legends    |  |
|  |                                                                   |  |
|  |  [Region 7: Chronological Ledger Workspace]                       |  |
|  |  - Vertical stacked feed of transaction cards grouped by date    |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY CONTROL, ACTION & NAVIGATION] - Pinned at Bottom       |
|  +-------------------------------------------------------------------+  |
|  | [Region 9: Primary Floating Action Button] (Logical Bottom-Start)  |  |
|  |                                                                   |  |
|  | [Region 8: Bottom Action & Control Bar]                           |  |
|  | - Equal-width navigation triggers with systemic gesture buffers   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

### Z-Order Surface Hierarchy
The surface depth determines touch focus priority and is mapped as follows:
- **Layer 0 (Base Canvas):** Background fill (`bankyar.semantic.color.background.canvas`). Handles background list scrolling.
- **Layer 1 (Standard Cards):** Container cards (`bankyar.semantic.color.surface.default`) used for balance summaries, categories, and transaction rows.
- **Layer 2 (Surface Raised):** Top App Bar, persistent Bottom Navigation, and Floating Action Button (`bankyar.semantic.color.surface.raised`).
- **Layer 3 (Surface Overlay):** Modal dialogs, expanded bottom sheets, and PIN locking overlays (`bankyar.semantic.color.surface.overlay`).

---

## Deliverable 4: Visual Hierarchy & Cognitive Scanning Flow

The Home Dashboard interface is engineered to optimize the user's natural cognitive processing speed. When a user opens BankYar, their visual focus path is guided through a series of structured entry points to reduce scanning effort:

1. **First Focal Point (Primary Visual Anchor):** The massive numerical balance "+۱۲,۴۰۰,۰۰۰ تومان" instantly captures the eye. The use of prominent display typography and high contrast ensures the user immediately knows their net worth.
2. **Second Focal Point (Contextual Feedback):** The eye moves downward to the Inflow vs Outflow card, comparing current credit and debit flows. Green and red indicator accents draw rapid analytical focus.
3. **Third Focal Point (Recent Ledger Activity):** The gaze settles on the chronological transaction feed below, scrolling vertically through clean, flat transaction cards to verify recent bank SMS alerts.
4. **Interactive Action Anchor:** The prominent Floating Action Button in the lower logical start corner remains pinned, acting as a stable, persistent interaction target for custom logging.

---

## Deliverable 5: Typography Usage Matrix

Typographical elements are mapped strictly to designated token styles to preserve visual correctness under extreme scaling conditions:

| Typographical Style | Size Token | Weight Token | Leading Token | Core Interface Application |
| :--- | :--- | :--- | :--- | :--- |
| **Display Large** | `font.size.xxlarge` | `font.weight.bold` | `font.leading.tight` | Main account balance totals (`bankyar.semantic.typography.display.lg`) |
| **Heading Medium** | `font.size.xlarge` | `font.weight.bold` | `font.leading.standard` | Screen section titles, dialog headers |
| **Title Medium** | `font.size.large` | `font.weight.medium` | `font.leading.standard` | Card and component headers |
| **Body Standard** | `font.size.medium` | `font.weight.regular` | `font.leading.loose` | Transaction notes, parsed raw SMS blocks (`bankyar.semantic.typography.body.md`) |
| **Caption Small** | `font.size.small` | `font.weight.regular` | `font.leading.standard` | Localized dates, timestamps, transaction IDs |
| **Label Tiny** | `font.size.xsmall` | `font.weight.bold` | `font.leading.tight` | Form labels, category tags, badges |
| **Action Button** | `font.size.medium` | `font.weight.medium` | `font.leading.tight` | Buttons, navigation triggers, filter labels |

---

## Deliverable 6: Spacing & Rhythm Rules

All margins, paddings, and external layout spacing conform to standard spacing multiples to establish vertical rhythm:

- **Outer Margins:** Symmetrical borders mapped to `bankyar.responsive.margin`.
- **Card Spacing:** External vertical gaps between individual ledger rows are bound to `bankyar.space.md`, while major content blocks are separated by `bankyar.space.lg`.
- **Internal Card Padding:** Default containment padding matches `bankyar.space.md`. High-density arrays (such as category lists or mini badges) adjust to `bankyar.space.sm` to prevent visual crowding.
- **Form Label Gaps:** Gaps separating form labels from input textfields use `bankyar.space.sm` to maintain proximity cues.

---

## Deliverable 7: Elevation & Shadow Language

BankYar rejects decorative 3D drop shadows and heavy gradients to maintain a professional, minimal visual style:

- **Flat Style Alignment:** Structural components (transaction rows, statistics panels) sit flat on Layer 0 and Layer 1. Outline borders (`bankyar.semantic.color.border.default`) define clean card boundaries.
- **Ambient Occurrences:** For situations where separation is required on the Z-axis (Floating Action Buttons or Bottom Sheets), shadows are derived strictly from the neutral grayscale palette with no direct light offsets.
- **Diffuse Blur:** Ambient shadows use broad blur parameters and low-opacity settings (under 8% opacity) to create subtle, professional boundaries.

---

## Deliverable 8: Icon Placement & Semantic Mapping

All icon assets are outline-only linear vectors with open, simplified shapes:

- **Mirroring Rules:** Directional icons (such as back chevrons, forward arrows, parsing progress indicators, and textfield prefixes) mirror dynamically based on active language direction.
- **Symmetric Sizing:** Visual icons adhere strictly to size tokens to ensure balanced alignments:
  - Small Indicator Icons: `bankyar.icon.size.sm` (used for inline labels, status dots, arrow deltas).
  - Standard Action Icons: `bankyar.icon.size.md` (used for App Bar triggers, navigation buttons, category tags).
  - Large Graphic Icons: `bankyar.icon.size.xl` (used for empty state illustrations, security warnings).
- **Color Consistency:** Icons must share the identical semantic color of their adjacent text label, ensuring a unified visual hierarchy.

---

## Deliverable 9: Component-Level Specifications

This section defines the precise layout parameters, interactive states, and behavioral attributes for all 13 core dashboard components.

---

### Component 1: Top App Bar (Component 14: Top App Bar)

- **Visual Hierarchy:** Pinned at the top of the viewport (Zone A), establishing branding and diagnostic status.
- **Dimensions:** Spans full viewport width. Height matches `bankyar.layout.appbar.min.height`.
- **Spacing:** Spans edge-to-edge. Separated from scrollable content below by `bankyar.space.md`.
- **Padding:** Internal horizontal padding maps to `bankyar.responsive.margin`. Vertical padding is symmetrical, mapped to `bankyar.space.sm`.
- **Margins:** Zero external margins.
- **Typography:** Brand titles styled with `bankyar.semantic.typography.title.sm`.
- **Icons:** Linear outline vector icons sized to `bankyar.icon.size.md`.
- **Elevation:** Flat. Separated from the workspace by a hairline division border (`bankyar.border.width.thin`) of color `bankyar.semantic.color.border.subtle`.
- **Corner Radius:** Square corners (`bankyar.radius.none`).
- **States:**
  - **Loading:** Displays a thin, pulsing linear progress bar at the bottom boundary.
  - **Disabled:** Transparent overlay of 38% opacity is applied.
  - **Pressed:** Interactive triggers scale to 0.98x with background contrast shifting by +2 steps.
  - **Focused:** Active elements display focus rings (`bankyar.semantic.color.focus`).
  - **Empty:** Not applicable.
  - **Error:** Bottom border is repainted with error crimson.
- **Accessibility:** Semantic description: "System Status: Securely Offline. Search and notification triggers available."
- **RTL Behaviour:** Start edge (right) houses the search trigger, center houses the app logo, and end edge (left) houses notification indicators.
- **Animation Notes:** Displays a subtle horizontal division line when content scrolls underneath.

---

### Component 2: Greeting Section (Component 13: Section Header)

- **Visual Hierarchy:** Positioned at the top of the scrollable content area, establishing a warm welcome.
- **Dimensions:** Fits text lines dynamically. Spans all 4 columns on compact screens.
- **Spacing:** Separated from the App Bar above by `bankyar.space.md`, and from the balance card below by `bankyar.space.lg`.
- **Padding:** Symmetrical inner padding set to `bankyar.space.none`.
- **Margins:** Symmetrical horizontal margins match `bankyar.responsive.margin`.
- **Typography:** Primary string "سلام، سهراب عزیز" styled with `bankyar.semantic.typography.title.sm`. Supporting subtitle styled with `bankyar.semantic.typography.body.sm`.
- **Icons:** None.
- **Elevation:** Sits flat on the background canvas.
- **Corner Radius:** None.
- **States:**
  - **Loading:** Replaced by a rectangular layout-preserving shimmering skeleton of matching size.
  - **Disabled:** Text opacity drops to 38%.
  - **Pressed:** Non-interactive.
  - **Focused:** Outlined focus ring if keyboard navigation is active.
  - **Empty:** Fallback to standard greeting "سلام، کاربر عزیز" if user name is uninitialized.
  - **Error:** Text is color-tinted with warning secondary color.
- **Accessibility:** Screen readers announce: "Hello, dear Sohrab. Your personal cash flow ledger is secure and updated."
- **RTL Behaviour:** Text aligns right (logical start margin).
- **Animation Notes:** Fades in with standard deceleration curve on launch.

---

### Component 3: Current Balance Summary (Component 8: Cards / Component 47: Security Card)

- **Visual Hierarchy:** Primary visual anchor of the dashboard, positioned centrally in the upper workspace.
- **Dimensions:** Spans full grid width. Height is constrained between `bankyar.layout.balance.card.min.height` and `bankyar.layout.balance.card.max.height`.
- **Spacing:** Separated from greeting by `bankyar.space.lg`, and from comparison cards below by `bankyar.space.md`.
- **Padding:** Internal padding maps strictly to `bankyar.layout.card.padding` (equivalent to `bankyar.space.md`).
- **Margins:** Symmetrical horizontal margins match `bankyar.responsive.margin`.
- **Typography:** Net total "+۱۲,۴۰۰,۰۰۰ تومان" styled with `bankyar.semantic.typography.display.lg` (using monospace formatting for alignment). Supporting labels styled with `bankyar.semantic.typography.label.xs` and update timestamp styled with `bankyar.semantic.typography.caption.sm`.
- **Icons:** Eye visibility toggle icon sized to `bankyar.icon.size.md`.
- **Elevation:** Flat card sitting on Layer 1. Defined by a border of width `bankyar.border.width.medium` and color `bankyar.semantic.color.border.default`.
- **Corner Radius:** Curved corners mapped to `bankyar.radius.lg`.
- **States:**
  - **Loading:** Replaced by a rectangular shimmering skeleton card of matching dimensions.
  - **Disabled:** Card opacity drops to 38%.
  - **Pressed:** Responds to tap with subtle tactile scale compression of 0.98x.
  - **Focused:** Double-width focus outline ring appears around the card.
  - **Empty:** Shows "تراکنشی یافت نشد" (No transactions found) with a zero balance.
  - **Error:** Card border is painted with error crimson.
- **Accessibility:** Screen readers announce: "Total Net Balance: 12,400,000 Tomans. Tap to obscure figures." When masked, announces: "Total Net Balance: Obscured."
- **RTL Behaviour:** Mirror flow right-to-left. Numeric figures read natively. Visibility toggle icon is anchored to the logical end (left) edge.
- **Animation Notes:** Obscuring balance values animates using a fast cross-fade transition.

---

### Component 4: Today's Financial Overview (Component 8: Cards / Component 10: Statistic Card)

- **Visual Hierarchy:** Positions immediately below the current balance card, acting as the secondary analytical support.
- **Dimensions:** Spans full grid width. Constrained to `bankyar.layout.summary.card.min.height` and `bankyar.layout.summary.card.max.height`.
- **Spacing:** Separated from balance card by `bankyar.space.md`, and from statistics below by `bankyar.space.lg`.
- **Padding:** Symmetrical inner padding set to `bankyar.space.md`.
- **Margins:** Symmetrical horizontal margins match `bankyar.responsive.margin`.
- **Typography:** Primary values styled with `bankyar.semantic.typography.title.sm` using monospace digits. Labels styled with `bankyar.semantic.typography.label.xs`.
- **Icons:** Indicator arrows (`↑` / `↓`) sized to `bankyar.icon.size.sm`.
- **Elevation:** Flat card sitting on `bankyar.semantic.color.surface.default`. Defined by thin border outline.
- **Corner Radius:** Rounded corners mapped to `bankyar.radius.medium`.
- **States:**
  - **Loading:** Replaced by two side-by-side equal-width shimmering skeleton blocks.
  - **Disabled:** Card opacity drops to 38%.
  - **Pressed:** Responds to tap with standard scale compression.
  - **Focused:** Double-width focus outline ring appears.
  - **Empty:** Inflow and Outflow amounts reset to "+۰" and "-۰" Tomans.
  - **Error:** Outline borders turn to warning orange.
- **Accessibility:** Announced as: "Monthly Inflow: 500,000 Tomans, Monthly Outflow: 250,000 Tomans."
- **RTL Behaviour:** Inflow column is positioned on the right (logical start), and Outflow is positioned on the left (logical end).
- **Animation Notes:** Transitions and state shifts use standard fast duration curves.

---

### Component 5: Quick Statistics Cards (Component 30: Charts)

- **Visual Hierarchy:** Positioned below the comparison card, providing category allocation insight.
- **Dimensions:** Spans full grid width. Height is constrained to `bankyar.layout.chart.min.height` and `bankyar.layout.chart.max.height`.
- **Spacing:** Separated from comparison cards above by `bankyar.space.lg`, and from search/filters below by `bankyar.space.md`.
- **Padding:** Symmetrical inner padding set to `bankyar.space.md`.
- **Margins:** Symmetrical horizontal margins match `bankyar.responsive.margin`.
- **Typography:** Category legends styled with `bankyar.semantic.typography.body.sm` using monospace digits for percentages. Header styled with `bankyar.semantic.typography.title.sm`.
- **Icons:** None.
- **Elevation:** Flat bordered surface.
- **Corner Radius:** Rounded corners mapped to `bankyar.radius.medium`.
- **States:**
  - **Loading:** Chart segments are covered with a circular shimmering mask.
  - **Disabled:** Card opacity drops to 38%.
  - **Pressed:** Interactive segments compress slightly upon tap.
  - **Focused:** Selected segment receives focus stroke of double width.
  - **Empty:** Displays an empty neutral gray circle with the copy "بدون داده" (No data available).
  - **Error:** Card borders turn to error crimson.
- **Accessibility:** Screen readers announce: "Spending allocation chart. Food represents 40%, transport represents 30%, rent represents 30%."
- **RTL Behaviour:** The circular donut segment is positioned on the right (logical start). The text legends list is on the left (logical end).
- **Animation Notes:** Donut segments draw smoothly with slow deceleration curves on screen load.

---

### Component 6: Recent Transactions (Component 9: Transaction Card / Component 12: List Tile)

- **Visual Hierarchy:** Occupies the primary lower workspace. High density chronological feed.
- **Dimensions:** Spans full screen width, extending downwards indefinitely as a scrollable feed.
- **Spacing:** Chronological section headers separated from adjacent cards by `bankyar.space.sm`.
- **Padding:** Individual list tiles utilize vertical padding of `bankyar.space.sm` and horizontal padding of `bankyar.space.md`.
- **Margins:** Extends edge-to-edge of the scroll viewport, aligned horizontally to `bankyar.responsive.margin`.
- **Typography:** Title/Merchant styled with `bankyar.semantic.typography.title.sm`. Date and timestamps styled with `bankyar.semantic.typography.caption.sm` with monospace numbers. Amount styled with `bankyar.semantic.typography.body.md` (positive/negative formatting).
- **Icons:** Bank logo vector in circular frame (size `bankyar.icon.size.md`), security padlock icon (size `bankyar.icon.size.sm`), user notes indicator icon (size `bankyar.icon.size.sm`).
- **Elevation:** Individual items reside on flat surfaces. Divider lines between cards map to `bankyar.semantic.color.border.subtle` with a width of `bankyar.border.width.thin`.
- **Corner Radius:** Individual transaction card corners are mapped to `bankyar.radius.medium`.
- **States:**
  - **Loading:** Rows are represented by layout-preserving skeletons flowing with shimmering masks.
  - **Disabled:** 38% transparency.
  - **Pressed:** Surface contrast shifts by +2 steps with 0.98x compression.
  - **Focused:** Focus outline ring surrounds the selected list item.
  - **Empty:** Displays the empty state layout (Region 6 fallback).
  - **Error:** Card border is painted with high-contrast warning crimson.
- **Accessibility:** Screen readers announce: "Transaction: July 20, Bank Melli, amount plus 120,000 Tomans, Category Shopping, status verified."
- **RTL Behaviour:** Flow mirrors from right to left. Bank logo and merchant name sit at the right (logical start). Amount, time, and category tags sit at the left (logical end).
- **Animation Notes:** Items slide in horizontally from the right (logical start) when loaded into the feed.

---

### Component 7: Search Bar (Component 5: Search Bar)

- **Visual Hierarchy:** Positioned at the top of the transaction feed or expanded from the App Bar.
- **Dimensions:** Spans full grid width. Height is constrained to standard touch target height of `bankyar.space.xl`.
- **Spacing:** Separated from the current balance card by `bankyar.space.md`.
- **Padding:** Inner horizontal padding set to `bankyar.space.md`.
- **Margins:** Symmetrical horizontal margins match `bankyar.responsive.margin`.
- **Typography:** Input queries styled with `bankyar.semantic.typography.body.sm`. Input prompt styled in muted secondary text.
- **Icons:** Leading magnifying glass search icon and trailing cross reset clear icon sized to `bankyar.icon.size.sm`.
- **Elevation:** Flat outlined input box sitting on Layer 1.
- **Corner Radius:** Fully rounded corners mapped to `bankyar.radius.full`.
- **States:**
  - **Loading:** Replaced by a rounded shimmering skeleton bar.
  - **Disabled:** 38% opacity.
  - **Pressed:** Element scale scales slightly when tapped.
  - **Focused:** Outline focus ring of color `bankyar.semantic.color.focus` and double-width border appears.
  - **Empty:** Display prompt hint text "جستجو در صندوقچه..." (Search in vault...).
  - **Error:** Border turns to crimson.
- **Accessibility:** Screen readers announce: "Search text field. Double tap to enter search terms."
- **RTL Behaviour:** Search icon is on the right (logical start). Clear query trigger is on the left (logical end). Text is right-aligned.
- **Animation Notes:** Expands smoothly from the App Bar trigger.

---

### Component 8: Filter Chips (Component 21: Filter Chip)

- **Visual Hierarchy:** Horizontal scrolling row positioned below the Search Bar.
- **Dimensions:** Height is constrained to standard touch target height `bankyar.space.xl`.
- **Spacing:** Horizontal spacing between adjacent chips is mapped to `bankyar.space.sm`. Separated vertically by `bankyar.space.sm`.
- **Padding:** Internal horizontal chip padding maps to `bankyar.space.md`, vertical padding is `bankyar.space.xs`.
- **Margins:** Horizontal row overflows outer margins smoothly, beginning from the logical start edge (right) of the screen.
- **Typography:** Chips text styled with `bankyar.semantic.typography.label.xs`.
- **Icons:** Checked selection indicator icon sized to `bankyar.icon.size.sm`.
- **Elevation:** Sits flat. Selected chip maps to active primary fill, unselected chip is bordered.
- **Corner Radius:** Corners are mapped to `bankyar.radius.full`.
- **States:**
  - **Loading:** Horizontal row of rectangular shimmering bars.
  - **Disabled:** Opacity drops to 38%.
  - **Pressed:** Chip shifts contrast by +2 steps.
  - **Focused:** Focus outline around the selected chip.
  - **Empty:** Not applicable.
  - **Error:** Chip border turns to red warning.
- **Accessibility:** Announced as scrollable selection lists. Active states are explicitly announced: "Filter: Melli Bank, selected."
- **RTL Behaviour:** Scroll flow starts from right-to-left. Leading selection checkmark sits on the right (logical start) of the text.
- **Animation Notes:** Horizontal scrolling uses standard momentum easing. Active chip changes color with fast duration curves.

---

### Component 9: Floating Action Button (Component 3: FAB)

- **Visual Hierarchy:** Positioned at the bottom-start corner of Zone C (lower right). Highly prominent primary action.
- **Dimensions:** Sizing matches `bankyar.layout.fab.min.size` or `bankyar.layout.fab.max.size` (height of `bankyar.space.xxl`).
- **Spacing:** Placed in Zone C, maintaining a safety margin of `bankyar.responsive.margin` from screen edges and navigation elements.
- **Padding:** Symmetrical inner padding set to `bankyar.space.md`.
- **Margins:** Anchored bottom-right.
- **Typography:** Button label styled with `bankyar.semantic.typography.action`.
- **Icons:** Leading plus vector icon sized to `bankyar.icon.size.md`.
- **Elevation:** Elevated on Layer 2 (`bankyar.semantic.color.surface.raised`) with a subtle diffuse monochromatic shadow.
- **Corner Radius:** Fully rounded corners mapped to `bankyar.radius.full`.
- **States:**
  - **Loading:** Locked trigger state, showing an opacity loop overlay.
  - **Disabled:** 38% transparency, interactive triggers ignored.
  - **Pressed:** Surface contrast shifts by +2 steps, scales down to 0.95x with fast animation.
  - **Focused:** Double-width outline focus ring appears.
  - **Empty:** Not applicable.
  - **Error:** Shakes horizontally on launch if database is locked.
- **Accessibility:** Semantic label announces: "Add manual transaction."
- **RTL Behaviour:** Anchored to the lower right corner (logical bottom-start).
- **Animation Notes:** Scales down and slides out of view during rapid downward scroll, restoring smoothly on scroll stop.

---

### Component 10: Bottom Navigation (Component 15: Bottom Navigation)

- **Visual Hierarchy:** Persistent footer pinned to the viewport bottom (Zone C).
- **Dimensions:** Height is constrained to `bankyar.layout.navigation.min.height` and `bankyar.layout.navigation.max.height`. Spans full viewport width.
- **Spacing:** Separated from scrollable lists above. Appends safe area gesture buffer below.
- **Padding:** Symmetrical internal padding set to `bankyar.space.sm`.
- **Margins:** Edge-to-edge width.
- **Typography:** Tab labels styled with `bankyar.semantic.typography.action`.
- **Icons:** Tab icons size `bankyar.icon.size.md`. Active tab shows filled icon.
- **Elevation:** Sits on Layer 2 (`bankyar.semantic.color.surface.raised`). Separated from workspace by hairline border.
- **Corner Radius:** Square corners (`bankyar.radius.none`).
- **States:**
  - **Loading:** Trigger is locked.
  - **Disabled:** Tab opacity drops to 38%.
  - **Pressed:** Active icon receives subtle scale feedback.
  - **Focused:** Focus outline ring surrounds the tab.
  - **Empty:** Not applicable.
  - **Error:** Not applicable.
- **Accessibility:** Tabs are arranged symmetrically right-to-left. Reports active selection and index (e.g., "Ledger Tab, 1 of 4, selected").
- **RTL Behaviour:** Tabs are distributed right-to-left: 1. Ledger (دفترچه) 2. Analytics (نمودارها) 3. Rules (قوانین) 4. Settings (تنظیمات).
- **Animation Notes:** Active selection transitions apply a soft indicator pill backdrop.

---

### Component 11: Notification Indicator (Component 33: Badge)

- **Visual Hierarchy:** Compact visual marker positioned over the notification bell trigger.
- **Dimensions:** Symmetrical size bound to `bankyar.space.xs`.
- **Spacing:** Overlaps top-start edge of parent notification icon.
- **Padding:** Zero internal padding.
- **Margins:** Zero external margins.
- **Typography:** Number count styled with `bankyar.semantic.typography.label.xs` using monospace digits.
- **Icons:** None.
- **Elevation:** Integrated flat surface on Layer 2.
- **Corner Radius:** Fully rounded corners mapped to `bankyar.radius.full`.
- **States:**
  - **Loading:** Not applicable.
  - **Disabled:** Opacity drops to 38%.
  - **Pressed:** Not applicable.
  - **Focused:** Not applicable.
  - **Empty:** Invisible and hidden if unread notification count is zero.
  - **Error:** Turns to alert crimson color.
- **Accessibility:** Screen reader announces: "Notification trigger, 3 unread updates."
- **RTL Behaviour:** Anchored top-right (logical start) of notification icon.
- **Animation Notes:** Fades in and scales up when count increases.

---

### Component 12: Offline Status Banner (Component 43: Notification Banner)

- **Visual Hierarchy:** Integrated within top app bar diagnostic region. Confirms offline security.
- **Dimensions:** Compact badge sized to fit localized text "کاملاً آفلاین".
- **Spacing:** Sits inline-end of notification trigger.
- **Padding:** Symmetrical horizontal padding set to `bankyar.space.sm`, vertical set to `bankyar.space.xxs`.
- **Margins:** Zero external margins.
- **Typography:** Label styled with `bankyar.semantic.typography.label.xs`.
- **Icons:** Green indicator dot sized to `bankyar.icon.size.sm`.
- **Elevation:** Flat.
- **Corner Radius:** Rounded corners mapped to `bankyar.radius.small`.
- **States:**
  - **Loading:** Dot pulses slowly during inbox scan.
  - **Disabled:** Opacity drops to 38%.
  - **Pressed:** Not applicable.
  - **Focused:** Outlined focus ring if diagnostic details are navigated.
  - **Empty:** Not applicable.
  - **Error:** Green dot turns to warning orange if parsing exceptions occur.
- **Accessibility:** Announced as: "System status: fully offline and secure."
- **RTL Behaviour:** Dot is positioned inline-start (right) of the label.
- **Animation Notes:** Dot pulses with gentle opacity loops on initial boot.

---

### Component 13: Permission Banner (Component 42: Permission Card)

- **Visual Hierarchy:** Positions at top of feed if system SMS access is missing.
- **Dimensions:** Spans full grid width. Height is dynamic, wrapping text content without clipping.
- **Spacing:** Separated from summary card above by `bankyar.space.lg`, and from recent transactions by `bankyar.space.lg`.
- **Padding:** Symmetrical inner padding set to `bankyar.space.md`.
- **Margins:** Symmetrical horizontal margins match `bankyar.responsive.margin`.
- **Typography:** Title styled with `bankyar.semantic.typography.title.sm`. Supportive text styled with `bankyar.semantic.typography.body.sm`. Action labels styled with `bankyar.semantic.typography.action`.
- **Icons:** Warning exclamation icon sized to `bankyar.icon.size.sm`.
- **Elevation:** Flat card sitting on Layer 1. Defined by warning orange border of width `bankyar.border.width.medium`.
- **Corner Radius:** Rounded corners mapped to `bankyar.radius.medium`.
- **States:**
  - **Loading:** Covered with layout-preserving shimmering skeleton block.
  - **Disabled:** Opacity drops to 38%.
  - **Pressed:** CTA buttons compress slightly upon tap.
  - **Focused:** Active button choice receives focus ring.
  - **Empty:** Card is hidden once permission is granted or manual setup choice is committed.
  - **Error:** Card border turns to error crimson if permission is permanently denied.
- **Accessibility:** Screen reader announces: "SMS Access permission needed to parse bank messages. Select Grant Permission or Set Up Manually."
- **RTL Behaviour:** Primary action (Grant Access) is positioned inline-start (right), and secondary action (Set up manually) is inline-end (left).
- **Animation Notes:** Slides in vertically on first launch, dismisses with standard deceleration curves when resolved.

---

## Deliverable 10: Accessibility Review

The BankYar Home Dashboard is fully compliant with WCAG 2.1 AA accessibility guidelines to support inclusive operation:

- **Logical Reading Sequence:** Screen readers traverse screen content chronologically:
  1. System Status and Diagnostics (App Bar).
  2. Welcome greeting.
  3. Balance details and masking triggers.
  4. Daily summaries.
  5. Category allocations.
  6. Recent transactions feed.
  7. Floating manual triggers and bottom tabs.
- **Strict Color Contrast:** Symmetrical text-to-background contrast exceeds 4.5:1. Display amounts exceed 3:1 contrast against surface wrappers.
- **Physical Tap Sizes:** Interactive targets maintain a physical height of at least `bankyar.space.xl`, ensuring comfortable touch envelopes and preventing accidental overlap triggers.
- **Text Scaling Resilience:** Text containers utilize relative spatial wrapping rules. Under 200% magnification, cards expand vertically, avoiding overlapping text lines or clipped strings.

---

## Deliverable 11: RTL Review

The interface natively adopts Persian (RTL) reading and structural flows:

- **Mirrored Traverses:** Text and linear lists align right and flow toward the left. Layout coordinates use logical start/end properties, enabling automatic mirroring when switching system locales.
- **Directional Icon Control:** Back chevrons, swipe-to-reveal controls, and loading progress indicators mirror dynamically, matching RTL gaze patterns.
- **Persian Typography Line-Height Buffers:** Line leading values are expanded vertically to accommodate tall Persian characters (Alef, Lam) and deep descenders (Ye, Re), preventing character collisions in dense lists.

---

## Deliverable 12: UI Validation Checklist

Before implementation is compiled into production Flutter code, verify compliance against this checklist:

- [ ] Does the visual layout use 100% active design tokens, with zero hardcoded values?
- [ ] Are physical units completely omitted?
- [ ] Are raw hex colors completely absent, replaced by semantic tokens?
- [ ] Is the layout free of framework-specific layout construct names?
- [ ] Are sensitive balances masked securely on tap and during background multitasking states?
- [ ] Do all interactive elements meet WCAG AA contrast standards?
- [ ] Do all Persian text layouts, chevrons, and forms align RTL-first?
- [ ] Are there zero unfinished markers or template sections remaining?

---
**End of Specification Document**
