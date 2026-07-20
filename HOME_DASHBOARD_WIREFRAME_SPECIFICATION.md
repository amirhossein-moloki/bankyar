# BankYar Home Dashboard Screen Wireframe Specification (v1.0.0)
## Enterprise-Grade Structural Blueprint for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Wireframe Specification
**Document Version:** 1.0.0
**Authors:** Principal UX Architect, Information Architect, Senior Product Designer, Flutter UX Specialist, Material Design Expert, Enterprise Financial Product Consultant
**Status:** Approved / Core Structural Blueprint

---

## Executive Summary

This document establishes the official, absolute **Structural Wireframe Specification** for the Home Dashboard of BankYar. Operating within our strict offline-first, privacy-first, and zero-network security boundaries, this specification defines the interface's structure, hierarchy, relative spacing, region layout, and interaction flow before any visual design or framework-specific coding begins.

BankYar is designed to translate unformatted carrier text streams (SMS) into a secure, structured local financial ledger. Operating natively in **Persian (RTL)** on the Android platform, this wireframe specification defines how the Home Dashboard maintains physical comfort, predictability, and safety under one-handed mobile usage.

This is **not** a UI mockup, **not** a visual design document, and contains **zero** framework-specific code constructs. All spacing, alignments, boundaries, and behaviors are specified using abstract relative design tokens, ensuring perfect scaling under accessibility magnification, fluid responsiveness across devices, and strict consistency.

---

## Layout Hierarchy

The structural layout uses a deterministic three-zone vertical model that progress logically from right (start) to left (end) following Persian RTL reading patterns. The master grid and spatial containment rules are mapped below:

### Structural Blueprint Mapping

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
|  |  [Region 2: Total Balance Display Card]                           |  |
|  |  - Displays total net worth in display typography                 |  |
|  |                                                                   |  |
|  |  [Region 3: Inflow & Outflow Comparison Cards]                    |  |
|  |  - Parallel horizontal blocks showing monthly summary data       |  |
|  |                                                                   |  |
|  |  [Region 4: Interactive Filter Row] (Sticky-capable horizontal row) |  |
|  |  - Horizontal scrolling row of chip containers starting from right |  |
|  |                                                                   |  |
|  |  [Region 5: Analytical Summary Workspace]                          |  |
|  |  - Aspect-ratio locked donut visualization & monospace legends    |  |
|  |                                                                   |  |
|  |  [Region 6: Chronological Ledger Workspace]                       |  |
|  |  - Vertical stacked feed of transaction cards grouped by date    |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY CONTROL, ACTION & NAVIGATION] - Pinned at Bottom       |
|  +-------------------------------------------------------------------+  |
|  | [Region 8: Primary Floating Action Button] (Logical Bottom-Start)  |  |
|  |                                                                   |  |
|  | [Region 7: Bottom Action & Control Bar]                           |  |
|  | - Equal-width navigation triggers with systemic gesture buffers   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## Region Specification

The Home Dashboard is divided into eight distinct structural regions. Each region's geometric rules, priority, behaviors, and accessibility boundaries are defined below.

### 1. Diagnostic App Bar Header (Region 1)
* **Purpose:** Establishes the primary application brand context, displays positive offline sync status, and houses secondary contextual search and notification actions.
* **Position:** Zone A (Pinned to top of screen).
* **Priority:** Primary (Critical for branding and diagnostic state).
* **Minimum Height:** Mapped to `bankyar.layout.appbar.min.height` (resolved through global spatial base factor multiplier).
* **Maximum Height:** Mapped to `bankyar.layout.appbar.max.height` (equal to the minimum height to maintain a stable, predictable top margin).
* **Expansion Rules:** This region remains physically static. No height expansion is allowed during standard scroll interactions.
* **Collapse Rules:** This region does not collapse. It remains pinned to the viewport top to ensure diagnostics and high-level notifications are always reachable.
* **Interaction Rules:**
  * Tapping the notification symbol (logical start) slides up the modal notification sheet from the bottom edge.
  * Tapping the search icon smoothly triggers the expanding local search field.
  * Tapping the diagnostic badge (logical end) opens a secure, on-device diagnostic card displaying local parse metrics.
* **Dependencies:** Relies on local database synchronization and security states.
* **Accessibility:** Native screen readers announce: *"System Status: Securely Offline. Search and notification triggers available."*
* **Future Scalability:** Designed with symmetrical start/end slots to support future localization selectors without altering the center logo alignment.

### 2. Total Balance Display Card (Region 2)
* **Purpose:** Presents the consolidated net worth of the user, parsed entirely offline from local transactions.
* **Position:** Zone B (Top-most scrollable item).
* **Priority:** Critical (Primary informational focal point).
* **Minimum Height:** Mapped to `bankyar.layout.balance.card.min.height` (must fit display typography and currency label without text clipping).
* **Maximum Height:** Mapped to `bankyar.layout.balance.card.max.height` (prevents vertical layout stretching).
* **Expansion Rules:** Grows vertically if system typography scaling exceeds the default size, ensuring that high-level currency strings wrap cleanly instead of clipping.
* **Collapse Rules:** None. Constrained strictly between min/max height tokens under standard scales.
* **Interaction Rules:** Tapping the balance area toggles visual masking. This replaces the active figures with a localized obscured character string, preventing shoulder surfing in public spaces.
* **Dependencies:** Relies on the decrypted local ledger query engines.
* **Accessibility:** Focuses immediately after the App Bar, announcing: *"Total Net Balance: [Local Currency Figure]. Tap to obscure figures."*
* **Future Scalability:** Internal horizontal flex space is reserved to show a small trend delta indicator in future versions.

### 3. Inflow & Outflow Comparison Cards (Region 3)
* **Purpose:** Displays a side-by-side comparative summary of monthly income (inflow) and monthly expenses (outflow).
* **Position:** Zone B (Directly below Region 2).
* **Priority:** Secondary (Supports high-level financial clarity).
* **Minimum Height:** Mapped to `bankyar.layout.summary.card.min.height`.
* **Maximum Height:** Mapped to `bankyar.layout.summary.card.max.height`.
* **Expansion Rules:** Expands vertically to wrap text when accessibility scale is magnified up to double the standard size.
* **Collapse Rules:** None.
* **Interaction Rules:** Tapping either card acts as a high-level filter shortcut, updating the Chronological Ledger Workspace to display only incoming or outgoing records respectively.
* **Dependencies:** Relies on category indexes and transaction aggregation modules.
* **Accessibility:** Formatted as two distinct columns. Screen readers announce: *"Monthly Income: [Figure]"* followed by *"Monthly Expenses: [Figure]"*.
* **Future Scalability:** Sized symmetrically to accommodate budget threshold indicators in future phases.

### 4. Interactive Filter Row (Region 4)
* **Purpose:** Houses horizontal filter chips that allow rapid sub-query filtering of the transaction feed.
* **Position:** Zone B (Directly below Region 3, capable of pinning to the top of Zone B when Region 2 and 3 scroll off-screen).
* **Priority:** Primary (High Interaction).
* **Minimum Height:** Mapped to `bankyar.layout.filter.row.min.height` (guarantees a touch target height of at least `bankyar.space.xl`).
* **Maximum Height:** Mapped to `bankyar.layout.filter.row.max.height`.
* **Expansion Rules:** None. Constrained to a single row to maximize vertical scrolling space for the transaction feed.
* **Collapse Rules:** None.
* **Interaction Rules:** Horizontal dragging scrolls the row right-to-left. Tapping any filter chip toggles its selection state, instantly updating the Ledger feed below.
* **Dependencies:** Relies on custom categories and registered bank ledger accounts.
* **Accessibility:** Announced as a scrollable selector list. Screen readers report active selection states (e.g., *"Filter Chip: Food, selected"*).
* **Future Scalability:** Reserved slots to append a trailing "Add Custom Filter" chip to launch a rule builder sheet.

### 5. Analytical Summary Workspace (Region 5)
* **Purpose:** Provides a visual breakdown of categorized spending using an aspect-ratio locked donut visualization and tabular legends.
* **Position:** Zone B (Below Region 4).
* **Priority:** Secondary (Visual context).
* **Minimum Height:** Mapped to `bankyar.layout.chart.min.height`.
* **Maximum Height:** Mapped to `bankyar.layout.chart.max.height`.
* **Expansion Rules:** Under tablet viewports, the chart transitions to a side-by-side presentation next to the tabular legend instead of a vertical stack.
* **Collapse Rules:** Can be toggled closed via a vertical chevron header button, collapsing to minimum header height.
* **Interaction Rules:** Tapping individual donut segments highlights that segment and updates the chronological ledger feed below to show transactions matching that category. Tapping the chart center transitions navigation to the full Analytics Screen.
* **Dependencies:** Relies on transaction categorization categories and local calculation models.
* **Accessibility:** Includes detailed text labels representing each slice. Screen readers announce: *"Spending Chart: Food represents 40 percent of total expenses, Transport represents 15 percent."*
* **Future Scalability:** The structural legend accommodates up to eight categories without requiring a scroll wrapper.

### 6. Chronological Ledger Workspace (Region 6)
* **Purpose:** Displays the chronological, high-density stream of parsed financial transactions.
* **Position:** Zone B (Occupies all remaining vertical space in the scrollable viewport).
* **Priority:** Primary (Core informational asset).
* **Minimum Height:** Spans dynamically to fill the viewport remaining area, with a baseline minimum of two complete transaction item heights.
* **Maximum Height:** Unlimited (unbounded scroll area).
* **Expansion Rules:** Fills all available scrolling area, extending downwards as more records are loaded from the local database.
* **Collapse Rules:** None.
* **Interaction Rules:**
  * Swiping gestures inside this list are strictly disabled to prevent accidental mutations while scrolling.
  * Tapping a verified ledger item displays its comprehensive detail sheet.
  * Tapping an unverified item (highlighted with active primary boundaries) launches the Quick Verification Sheet.
  * Pulling down from the top edge of the list triggers a scan of the system's local SMS inbox.
* **Dependencies:** Secure parsing engine, local SMS database, custom categorizations.
* **Accessibility:** Each ledger item is grouped as a single focused element, ensuring natural reading: *"Transaction: [Date], [Merchant Name], [Amount], [Status: Verified/Unverified]"*.
* **Future Scalability:** Structured to allow multi-selection checkboxes on the right (start) margin for future bulk tagging.

### 7. Bottom Action & Control Bar (Region 7)
* **Purpose:** Houses persistent high-level navigation tabs and manages page routes.
* **Position:** Zone C (Pinned to the bottom edge of the viewport).
* **Priority:** Critical (Primary navigation).
* **Minimum Height:** Mapped to `bankyar.layout.navigation.min.height` (includes additional gesture safety buffers).
* **Maximum Height:** Mapped to `bankyar.layout.navigation.max.height`.
* **Expansion Rules:** Vertically scales only on wide screens to prevent visual compression.
* **Collapse Rules:** None. Remaining persistent to allow instant section switching.
* **Interaction Rules:** Tapping any navigation tab changes active routes instantly with visual fade transitions.
* **Dependencies:** Navigation state router.
* **Accessibility:** Tabs are arranged symmetrically from right to left. High-contrast indicators ensure active tab visibility.
* **Future Scalability:** Designed to support numeric count badges over specific navigation items without changing overall heights.

### 8. Primary Floating Action Button (Region 8)
* **Purpose:** Provides a prominent, immediate trigger to create a manual transaction record.
* **Position:** Zone C (Anchored to the logical bottom-start edge / lower right).
* **Priority:** Critical (Primary interaction gateway).
* **Minimum Height:** Mapped to `bankyar.layout.fab.min.size` (complying with comfort touch targets).
* **Maximum Height:** Mapped to `bankyar.layout.fab.max.size`.
* **Expansion Rules:** Can transition horizontally into an extended FAB displaying a localized action label when scrolling stops.
* **Collapse Rules:** Automatically scales down and slides out of view during rapid downward scroll actions, restoring smoothly on scroll stop.
* **Interaction Rules:** Tapping the FAB opens the Manual Transaction Entry modal sheet from the bottom viewport edge.
* **Dependencies:** None.
* **Accessibility:** Semantic label announces: *"Add manual transaction."*
* **Future Scalability:** Prepared to expand into a small, floating speed-dial menu for future quick actions.

---

## Wireframe Layout & Spatial Rules

### 1. Screen Regions
The dashboard is structurally organized into three fixed coordinate layers:
* **Sticky Top Layer (Zone A):** Houses Region 1 (App Bar).
* **Scrollable Workspace Layer (Zone B):** Houses Regions 2, 3, 4, 5, and 6 in vertical sequence.
* **Sticky Bottom Layer (Zone C):** Houses Region 7 (Navigation Bar) and Region 8 (Floating Action Button).

### 2. Vertical Layout
The screen follows a strict single-column stacked vertical layout. All components are placed along a single vertical track to prevent cognitive splitting on compact screens:
1. Pinned Header (Region 1)
2. Card Workspace (Region 2)
3. Summary Row (Region 3)
4. Interactive Filters (Region 4)
5. Chart Workspace (Region 5)
6. Transaction Feed (Region 6)
7. Pinned Footer (Region 7)

### 3. Horizontal Layout
Alignments are defined using logical structural coordinates (`start` for right, `end` for left, `inline` for horizontal flow, `block` for vertical stack) rather than physical left/right rules:
* Symmetrical margins are enforced on the inline edges using `bankyar.responsive.margin`.
* The reading direction flows natively right-to-left. Text and supporting icons are anchored to the start (right) margin, while transaction numeric amounts and state badges are anchored to the end (left) margin.

### 4. Safe Area Rules
* **Top System Status Buffer:** Region 1 includes a dynamic structural offset to match the device notch or status bar, preventing branding from overlapping system icons.
* **Bottom Navigation Buffer:** Region 7 appends a structural gesture buffer matching the device's navigation bar height, preventing touch conflicts with system home actions.

### 5. Grid Structure
* **Compact Viewport (Smartphones):** Uses a standard 4-column layout. Gaps are controlled via `bankyar.responsive.gutter` and outermost columns are separated from margins via `bankyar.responsive.margin`.
* **Span Allocations:**
  * Region 2 (Total Balance Card) spans all 4 columns.
  * Region 3 (Comparison Cards) spans 2 columns each, placed side-by-side.
  * Region 5 and 6 span all 4 columns.

### 6. Content Hierarchy
* **Primary Visual Focus:** Region 2 (Net Balance Display Card) is the largest card with prominent display typography to focus the user's attention instantly.
* **Supporting Data:** Region 3 and Region 5 provide secondary visual breakdowns.
* **Dense Informational Streams:** Region 6 is high-density and vertically scrollable, optimized for fast legibility using thin lines to separate records.

### 7. Scroll Areas
* **Global Scroll Layer for Zone B:** Operates as the master scroll container.
* **Scroll Boundary Locks:** Vertical scroll parameters are bound to the inner edges of Region 1 and Region 7, ensuring that content never scrolls over system status bars or bottom navigation tabs.
* **No Nested Scroll Containers:** Nested vertical scrolling within list tiles or cards is strictly prohibited to avoid scroll trapping.

### 8. Sticky Areas
* **App Bar Header (Region 1):** Remains permanently pinned to the top.
* **Interactive Filter Row (Region 4):** Anchored horizontally. When scrolled upwards, it pins immediately under the bottom edge of Region 1, keeping filters accessible while scanning transactions.
* **Bottom Navigation Bar (Region 7):** Remains permanently pinned to the bottom.

### 9. Card Placement
* All cards (Region 2, Region 3, and individual rows in Region 6) are flat, using thin border outlines to define borders without relying on shadows.
* The outer edges of cards align with the horizontal columns of the master grid, using standard curvature tokens to maintain a consistent appearance.

### 10. Search Placement
* **Trigger Placement:** Positioned at the logical start (right) of Region 1 as a persistent icon.
* **Activation Overlay:** Tapping the search icon smoothly expands the search field horizontally, overlaying the App Bar.
* **Layout Structure:** The active search field occupies the entire horizontal width of Region 1, featuring an instant clear button at the end (left) edge.

### 11. Filter Placement
* **Horizontal Row Placement:** Positioned immediately above Region 6, separating analytical overviews from the transaction ledger.
* **Layout Structure:** Organized as an inline, horizontally scrollable row of chips that overflows the inline margin boundaries.

### 12. Statistics Placement
* **Dashboard Summary Placement:** Positioned inside Region 5. It contains a centered donut chart and parallel tabular legends.
* **Aspect Ratio Protection:** The chart is constrained to equal vertical and horizontal bounds, preventing visual distortion.

### 13. Transaction List Placement
* **Ledger Placement:** Placed at the bottom of Zone B, filling all remaining vertical space.
* **Structural Grouping:** Grouped by date sections, utilizing thin hairline division lines between individual cards.

### 14. Floating Button Placement
* **Location:** Positioned at the logical bottom-start edge of the screen (lower right in Persian RTL layouts).
* **Spacing Protection:** Elevated on the Z-axis, maintaining a clear separation margin from Region 7 to prevent touch overlap.

### 15. Navigation Placement
* **Location:** Pinned at the bottom of the screen as the persistent navigation shell.
* **Layout Structure:** Features four equal-width navigation triggers arranged horizontally from right (start) to left (end).

---

## State and Alternative Layouts

### 16. Empty Screen Layout
When no transactions or parsed records are present in the local database, Zone B is replaced by a centered, structured onboarding layout:
* **Visual Anchor:** An abstract, non-colored geometric illustration positioned in the upper-middle region.
* **Supportive Microcopy:** Reassuring, non-technical Persian text explaining that BankYar is offline-first, private, and waiting to parse incoming carrier SMS streams.
* **Primary Call to Action:** A prominent button labeled *"Enter manual transaction"* is centered horizontally, inviting immediate interaction.

### 17. Loading Layout
During initial local database loading or rule execution, the screen remains stable without layout jumps:
* **Non-blocking Loading Indicators:** A thin, linear progress indicator runs along the bottom edge of Region 1.
* **Active Interactions:** Interactive elements remain visible, and users can browse cached transaction records while background parsing processes complete.

### 18. Error Layout
If database decryption fails or system exceptions occur, the screen prevents data exposure and presents a clear recovery layout:
* **Contained Warnings:** Localized Persian errors are nested inside flat cards, using high-contrast warning borders.
* **PII Redaction:** Stated in clear, plain language; raw system traces or sensitive database parameters are completely redacted.
* **Primary Action:** A clear button labeled *"Retry Database Load"* is placed at the bottom edge of the error card.

### 19. Permission Layout
If SMS access is not granted on system boot, the entire dashboard is replaced with a clear explanation layout:
* **Context Explanation:** A structured, vertical stack explaining why local SMS permissions are required to automate ledger parsing.
* **Dual Interaction Actions:** Displays a primary button to grant system access and a secondary button to set up accounts manually, maintaining user choice.

### 20. Offline Layout
Since BankYar operates under a strict zero-network constraint, the offline state represents normal system operations:
* **Status Indicator:** Region 1 displays a steady, positive green diagnostic status badge reading *"Securely Offline"*, reassuring the user that their data is stored safely on the device.

### 21. Skeleton Layout
Before data is loaded, content blocks are represented by layout-preserving skeletons:
* **Geometric Symmetry:** Skeletons match the exact heights, widths, and corner curvatures of Region 2, Region 3, and individual rows in Region 6.
* **Visual Stability:** Prevents layout shifts as cached data loads into the interface.

---

## Responsive & Adaptive Behaviour

### 22. Tablet Adaptation (Medium & Expanded Viewports)
When the horizontal viewport exceeds standard compact boundaries, the single-column stack transitions to a structured multi-pane layout:

```
Tablet / Unfolded Viewport Grid (12-Columns)
+-------------------------------------------------------------------------+
| [Persistent Nav Rail] | [Ledger Feed Pane (Region 2, 3, 4, 6)]           | [Analytics & Rules Pane] |
|                       | (Spans 6 Columns)                              | (Spans 5 Columns)        |
| (Logical Start / Right|                                                 |                          |
|  - Spans 1 Column)    |                                                 |                          |
+-------------------------------------------------------------------------+
```

* **Navigation Transition:** The Bottom Navigation Bar (Region 7) transitions to a vertical Navigation Rail anchored to the logical start (right) edge of the screen.
* **Multi-Pane Columns:** The screen is divided into two distinct, balanced columns (ledger feed pane on the right; analytical breakdown and category rules on the left), preventing cards from looking excessively stretched.

### 23. Foldable Adaptation
* **Hinge Awareness:** The layout engine detects the device hinge or folding line. Content margins are automatically adjusted to ensure text lines and primary interactive buttons never overlap the folding area.
* **Dual-Pane Layouts:** When unfolded, the interface transitions to a dual-pane master-detail configuration, using the physical hinge as a natural boundary between the transaction feed and transaction details.

---

## Spacing Strategy

To guarantee visual comfort and balance, all dimensions, paddings, margins, and gaps are defined using abstract relative tokens:

* **Outer Margin:** Mapped to `bankyar.responsive.margin`. This margin scales from compact screens to wider viewports to maintain optimal readability.
* **Internal Padding:** Inside standard cards and content blocks, padding is controlled via `bankyar.space.md`, maintaining consistent density. High-density lists utilize `bankyar.space.sm` to show more records on a single screen.
* **External Spacing Gaps:**
  * Gaps between major independent containers are mapped to `bankyar.space.lg`.
  * Gaps between tightly associated elements (such as input labels and textfields) are mapped to `bankyar.space.sm`.
* **Touch Targets:** Interactive targets (filter chips, buttons, list rows, App Bar actions) maintain a minimum vertical height of `bankyar.space.xl`, ensuring comfortable interactions.

---

## Accessibility Layout & RTL Rules

### 24. Accessibility Layout
* **Logical Screen Reader Sequence:** Focus progresses predictably from top-to-bottom and right-to-left following natural reading patterns.
* **Double Typography Magnification:** All cards and form inputs are designed to scale and wrap vertically without clipping content, supporting up to 200% system-level text magnification.
* **High-contrast Ratios:** All text elements and status indicators maintain high contrast ratios against card backgrounds.

### 25. RTL Layout Rules
* **Logical Mirroring:** The layout is defined using logical coordinates (`start` for right, `end` for left), ensuring alignments, margins, and swipe gestures mirror automatically when switching locales.
* **Directional Icon Mirroring:** Navigational chevrons, page transitions, and progress bars are mirrored dynamically to match Persian RTL reading flows.
* **Persian Line Height Buffer:** Spacing offsets are expanded to accommodate Persian ascenders and descenders, preventing overlapping text lines.

### 26. Future Expansion Zones
* **Pre-allocated Budget Hook:** A spatial gap is reserved directly below Region 3 to accommodate budget tracking progress bars in future versions.
* **AI Financial Insights Hook:** A content container slot is reserved in Region 5 to support on-device financial advisory cards without altering the screen structure.

---

## Validation Checklist

This wireframe specification must satisfy all validation checks before visual design or development begins:

- [x] **No Hardcoded Hex Colors:** Every color mapping references abstract semantic design tokens (e.g., `bankyar.semantic.color.background.default`).
- [x] **No Physical Dimensions:** Margins, spacing, padding, and corner curvatures use relative tokens (e.g., `bankyar.responsive.margin`) rather than physical pixels.
- [x] **No Framework-Specific Code:** No framework UI building elements or code constructs are present.
- [x] **Complete State Coverage:** Contains detailed layout rules for empty, loading, error, skeleton, permission, and offline states.
- [x] **Symmetrical RTL Design:** Alignments, reading flows, and page transitions use logical coordinates (`start`, `end`).
- [x] **No Mock Markers:** Contains no remaining warning notes, markers, or unfinished text elements.

---
**End of Document**
