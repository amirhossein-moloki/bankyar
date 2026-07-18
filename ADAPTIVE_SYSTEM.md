# BankYar Adaptive & Multi-Device Experience System (v1.0.0)
## Enterprise-Grade Adaptive UX Architecture Specification for Offline-First Secure Financial Applications

---

## Executive Summary
This document establishes the official **Adaptive & Multi-Device Experience System** for BankYar. Acting as the ultimate authority for visual asset reflow, viewport transition behaviors, and spatial scaling under diverse device form factors, this specification implements the core product personality (Stoic, Precise, Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`.

To ensure strict visual integrity, security containment, and seamless Right-to-Left (RTL) Persian rendering, **all adaptive behaviors are governed by abstract design tokens and logical spatial models.** Raw physical units, hardcoded pixel values, or platform-specific layout files are strictly prohibited. This system establishes a future-proof architecture that scales seamlessly from compact smartphones to foldables, tablets, desktops, and external display environments without sacrificing privacy or performance.

---

## TABLE OF CONTENTS
1. [Adaptive Design Philosophy](#1-adaptive-design-philosophy)
2. [Device Classification Strategy](#2-device-classification-strategy)
3. [Breakpoint Philosophy](#3-breakpoint-philosophy)
4. [Responsive Principles](#4-responsive-principles)
5. [Adaptive Layout Rules](#5-adaptive-layout-rules)
6. [Phone Experience](#6-phone-experience)
7. [Large Phone Experience](#7-large-phone-experience)
8. [Tablet Experience](#8-tablet-experience)
9. [Foldable Experience](#9-foldable-experience)
10. [Desktop Readiness](#10-desktop-readiness)
11. [External Display Strategy](#11-external-display-strategy)
12. [Landscape Behavior](#12-landscape-behavior)
13. [Portrait Behavior](#13-portrait-behavior)
14. [Split Screen Strategy](#14-split-screen-strategy)
15. [Multi-window Support](#15-multi-window-support)
16. [Resizable Window Rules](#16-resizable-window-rules)
17. [Adaptive Navigation](#17-adaptive-navigation)
18. [Adaptive Forms](#18-adaptive-forms)
19. [Adaptive Charts](#19-adaptive-charts)
20. [Adaptive Tables](#20-adaptive-tables)
21. [Adaptive Statistics](#21-adaptive-statistics)
22. [Adaptive Search](#22-adaptive-search)
23. [Adaptive Dialogs](#23-adaptive-dialogs)
24. [Adaptive Bottom Sheets](#24-adaptive-bottom-sheets)
25. [Adaptive Cards](#25-adaptive-cards)
26. [Adaptive Lists](#26-adaptive-lists)
27. [Adaptive Empty States](#27-adaptive-empty-states)
28. [Adaptive Error States](#28-adaptive-error-states)
29. [Adaptive Loading States](#29-adaptive-loading-states)
30. [RTL Adaptive Rules](#30-rtl-adaptive-rules)
31. [Accessibility Across Devices](#31-accessibility-across-devices)
32. [Performance Considerations](#32-performance-considerations)
33. [Memory Considerations](#33-memory-considerations)
34. [Offline-first Considerations](#34-offline-first-considerations)
35. [Design Token Adaptation](#35-design-token-adaptation)
36. [Component Adaptation Rules](#36-component-adaptation-rules)
37. [Governance Rules](#37-governance-rules)
38. [Validation Checklist](#38-validation-checklist)
39. [Anti-pattern Catalog](#39-anti-pattern-catalog)
40. [Migration & Future Evolution Strategy](#40-migration--future-evolution-strategy)

---

## 1. Adaptive Design Philosophy
The adaptive architecture of BankYar is built on the tenet that **responsive design is not merely fluid scaling, but contextual reflowing of information structures.**
* **Content Continuity:** A user transitioning between an ultra-compact phone, an unfolded foldable, and a multi-window desktop must experience a seamless visual continuum. The informational hierarchy must remain identical, preventing cognitive disorientation.
* **Ergonomic Adaptation:** Interaction models must adapt to the physical holding patterns of each device class. We optimize interactive comfort targets based on whether a device is held with one hand, dual hands, or operated via physical keyboards and pointing cursors.
* **Deterministic Behavior:** All adaptive transitions are driven by semantic layout tokens. We reject device-specific heuristics and browser-agent hacks, relying instead on predictable parent-container bounding contexts.

---

## 2. Device Classification Strategy
To coordinate layout engines across varied form factors, BankYar classifies all physical viewports into distinct architectural tiers. The classification determines active column structures, interactive target scales, and layout densities.

### Device Matrix

| Device Class | Viewport Range Token | Default Grid Columns | Spacing Density | Primary Interaction Model | Primary Navigation Pattern |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **Compact Phones** | `bankyar.breakpoint.compact` (Min) | 4 Columns | Compact | One-handed Thumb Reach | Bottom Navigation Bar |
| **Standard Phones**| `bankyar.breakpoint.compact` (Mid) | 4 Columns | Comfortable | One-handed Thumb Reach | Bottom Navigation Bar |
| **Large Phones**   | `bankyar.breakpoint.compact` (Max) | 4 Columns | Comfortable | One-handed / Symmetrical | Bottom Navigation Bar |
| **Foldables (Folded)** | `bankyar.breakpoint.compact` (Max) | 4 Columns | Compact | One-handed Thumb Reach | Bottom Navigation Bar |
| **Foldables (Unfolded)**| `bankyar.breakpoint.medium` | 8 Columns | Comfortable | Dual-handed Thumbs | Start-edge Navigation Rail |
| **Small Tablets**  | `bankyar.breakpoint.medium` | 8 Columns | Comfortable | Dual-handed Thumbs / Surface | Start-edge Navigation Rail |
| **Large Tablets**  | `bankyar.breakpoint.expanded` | 12 Columns | Comfortable | Surface Tap / Stylus / Desk | Start-edge Navigation Drawer |
| **Desktop Windows**| `bankyar.breakpoint.expanded` (Max) | 12 Columns | Comfortable | Pointer / Keyboard | Persistent Left-side Drawer |
| **External Displays**| `bankyar.breakpoint.expanded` (Extra) | 12 Columns | High Density | Remote Control / Pointer | Large Overlay Header Menu |

---

## 3. Breakpoint Philosophy
BankYar rejects absolute physical device targeting in favor of **logical parent-bounding constraints.**
* **Abstract Boundaries:** Breakpoints represent the physical limits where a single layout structure cannot preserve typographical readability or interactive comfort.
* **Dynamic Interception:** Rather than relying on static device queries, components intercept available parent widths dynamically. A compact modal drawer scales into a centered dialog box when its container boundary exceeds `bankyar.breakpoint.medium`.
* **Proportionate Scaling:** Spacing, internal padding, and grid column boundaries scale proportionately in lockstep with active breakpoint transitions, preserving structural balance.

---

## 4. Responsive Principles
All layouts in BankYar must satisfy four core responsive principles to ensure fluid adaptability:
* **Principle of Information Equality:** No features or financial data points may be completely hidden or omitted on smaller devices. Elements must wrap, compress, or move to progressive sub-menus rather than disappearing.
* **Principle of Linear Flow:** Elements stack vertically when horizontal boundaries are reached. Horizontal row spans must dynamically convert into vertical stacks when viewports shrink.
* **Principle of Logical Alignment:** No physical left or right alignments are allowed. Layout boundaries must be modeled using logical-start and logical-end properties to support flawless RTL mirroring.
* **Principle of Visual Stability:** Prevent layout shifting during screen rotation, keyboard activation, or viewport resizing by locking the sizes of core navigation anchors.

---

## 5. Adaptive Layout Rules
To guide the rendering of complex multi-device features, BankYar enforces structural layout rules:
* **The Multi-Pane Rule:** Viewports exceeding `bankyar.breakpoint.medium` must transition from single-screen feeds to a coordinated master-detail multi-pane arrangement.
* **Container Width Bounds:** Standard text paragraphs, settings panels, and forms must be constrained by `bankyar.responsive.container.width.max` to prevent wide, unreadable content lines on expanded screens.
* **Spatial Rhythm Preservation:** Gutter widths and screen margins must scale strictly using integer multiples of the base spacing token `bankyar.global.space.base` when transitioning breakpoints.

---

## 6. Phone Experience
The phone experience is the primary foundational target for BankYar, optimized for ultra-fast, single-handed execution.

```
+---------------------------------------------+
| Standard Phone Portrait View                |
|                                             |
|  [Sticky Top Header] -> Balance Overview     |
|  .........................................  |
|                                             |
|  [Scrollable Core Ledger Feed]              |
|   +-------------------------------------+   |
|   | Card: Amount, Merchant, Category    |   |
|   +-------------------------------------+   |
|                                             |
|  .........................................  |
|  [Sticky Navigation Controls] -> Bottom Bar  |
+---------------------------------------------+
```

* **Thumb-Reach Zoning:** All primary interactive components—such as transaction categorization chips, text inputs, search buttons, and manual action triggers—must reside strictly in the lower region of the screen.
* **Single-Stream Feed:** Financial ledgers, analytic statistics, and custom rules stack in a single vertical list to maximize reading space on narrow viewports.

---

## 7. Large Phone Experience
Large phone experiences adjust layout metrics to optimize readability and prevent excessive white space.
* **Horizontal Padding Adjustment:** The outer screen margins scale up to the semantic token `bankyar.responsive.margin` (large variant), keeping lists and forms mathematically aligned without stretching content fields.
* **Multi-column Grid Alignment:** Form fields (such as rule names and regular expressions) transition from a single vertical column to twin-column horizontal rows, making efficient use of the wider screen space.

---

## 8. Tablet Experience
Tablet experiences take advantage of the expanded screen estate to present high-level financial insights in a single, unified view.

```
+-------------------------------------------------------------------------+
| Tablet Landscape Multi-Pane View                                        |
|                                                                         |
|  [Nav Rail]  |  [Master Panel: Ledger Feed]  |  [Detail Panel: Inspector]|
|  (Vertical)  |  - Card 1                      |  - Raw SMS Text          |
|              |  - Card 2                      |  - Matched Regex         |
|              |  - Card 3                      |  - Note Editor Form      |
|              |  - Card 4                      |  - Save Changes Trigger  |
+-------------------------------------------------------------------------+
```

* **Multi-Pane Coordination:** The interface splits into twin panes (Master-Detail). The logical-start pane contains the scrollable list of transactions or rules, while the logical-end pane displays the complete details and configuration inputs.
* **Adaptive Navigation Rails:** The persistent bottom navigation bar transitions into a vertical navigation rail anchored to the logical-start edge of the screen, freeing up vertical space for scrolling lists.

---

## 9. Foldable Experience
Foldables represent a dynamic hybrid state that transitions instantly between phone and tablet behaviors based on physical screen state.
* **Hinge Awareness:** Layouts must detect the physical fold line. Readability lines, text paragraphs, and touch targets must never overlap or intersect the physical hinge region.
* **Dual-screen Master-Detail:** When unfolded, the application transitions from standard single-column scrolling feeds to a coordinated dual-screen master-detail configuration, splitting the layout across the hinge.

---

## 10. Desktop Readiness
Desktop readiness guarantees that the application layout behaves predictably and looks clean when running on desktop environments or web viewports.
* **Persistent Side Drawer:** Navigation transitions from a start-edge rail to a persistent side navigation drawer, allowing users to move between modules in a single click.
* **Cursor and Pointer Optimization:** Focus and hover states transition from standard touch targets to precise hover overlays, giving users clear visual cues as they navigate with a pointer.

---

## 11. External Display Strategy
External display strategies govern how layouts render when the application is cast or projected onto large external monitors.
* **Presentation Mode:** When casting, the device acts as a secure input controller, while the external display renders a clean, high-contrast dashboard with spending charts and financial analysis.
* **Strict Privacy Redaction:** Private metadata—such as bank account numbers, IBANs, and individual SMS text strings—is completely redacted on the external display to protect user privacy in shared spaces.

---

## 12. Landscape Behavior
Landscape orientation rearranges horizontal screen space to maximize list density while keeping reading lines comfortable.
* **Horizontal Column Division:** Scrollable feeds and charts are positioned side-by-side rather than stacked vertically, avoiding wide, unreadable text lines.
* **App Bar Minimization:** Sticky top app bars shrink in height to maximize the vertical space available for scrollable content.

---

## 13. Portrait Behavior
Portrait orientation optimizes the layout for vertical scrolling, ensuring users can scan financial data with minimal eye movement.
* **Vertical Stack Structure:** Content blocks, comparison charts, and forms are stacked vertically, with logical separations defined by standard spacing tokens.
* **One-handed Usability:** The primary floating action button is positioned at the logical bottom-start edge of the screen, keeping key actions within comfortable thumb-reach.

---

## 14. Split Screen Strategy
Split-screen layouts handle viewports that are compressed horizontally or vertically by system-level multi-tasking.
* **Dynamic Column Scaling:** The active grid column count scales down dynamically from 12 columns to 4 columns as the window size is adjusted.
* **Inline Element Wrapping:** Multi-column forms and horizontal button pairs wrap into vertical stacks to keep inputs readable and touch targets comfortable.

---

## 15. Multi-window Support
Multi-window support ensures the application remains stable and visually consistent when running alongside other apps on tablets or desktop screens.
* **Aspect Ratio Preservation:** spending charts and cash-flow graphs are locked to stable aspect ratios, preventing them from stretching or distorting as the window size is adjusted.
* **Input Focus Preservation:** Forms and text inputs must preserve active cursor focus and scroll positions during window transitions, ensuring a seamless user experience.

---

## 16. Resizable Window Rules
Resizable window rules govern how layouts adapt as users resize the application window in real time on desktop or foldable environments.
* **Continuous Layout Reflowing:** Layouts must reflow smoothly and continuously as the window size is adjusted, avoiding abrupt visual jumps or layout shifts.
* **Dynamic Breakpoint Interception:** Spacing, padding, and column counts must adjust dynamically as the viewport size crosses defined breakpoint thresholds, maintaining a clean and balanced interface.

---

## 17. Adaptive Navigation
Navigation layouts adapt to optimize usability, screen space, and ergonomic comfort across different device sizes.

```
+-------------------+      +-------------------+-------------------+
| Compact (Phone)   |      | Medium (Tablet)   | Expanded (Desktop)|
|                   |      |                   |                   |
|                   |      | [Rail] [Content]  | [Drawer] [Content]|
|                   |      |        [Content]  |          [Content]|
| [Nav Bottom Bar]  |      |                   |                   |
+-------------------+      +-------------------+-------------------+
```

* **Interactive Target Adjustments:** Bottom bar items scale horizontally to ensure clean separation on phones, while vertical rail items stack neatly on tablet screens.
* **Consistent Flow Preservation:** Page paths, sub-menus, and back actions must remain functionally identical, ensuring a predictable user experience across all form factors.

---

## 18. Adaptive Forms
Form layouts ensure text inputs and configuration options remain clean, readable, and easy to interact with on any screen size.
* **Single-column Vertical Alignment:** Input titles, textfields, and validation helper text are aligned vertically in a single column on compact screens to minimize cognitive load.
* **Multi-column Row Transitions:** On expanded viewports, related form fields transition into multi-column rows, making efficient use of horizontal screen space without exceeding reading width bounds.

---

## 19. Adaptive Charts
Financial analytics and spending charts adapt to preserve data clarity and visual structure on any screen.
* **Constrained Aspect Ratios:** Spending donuts and cash-flow bar graphs are locked to stable aspect ratios, ensuring data visualizations are never distorted on wider screens.
* **Symmetrical Legend Reflowing:** Chart legends stack vertically below the graph on narrow screens, and transition to a side-by-side row on wider displays.

---

## 20. Adaptive Tables
Tables handle multi-row financial spreadsheets, adjusting their density and structure to remain highly readable on any viewport.
* **Horizontal Scroll Containment:** When columns exceed viewport bounds, tables enable horizontal scrolling inside a locked container, keeping the main screen stable.
* **Fixed Column Anchoring:** Primary identifier columns (such as transaction dates or bank accounts) lock in place at the logical start edge, remaining visible as users scroll other columns horizontally.

---

## 21. Adaptive Statistics
The statistics layout adapts to present high-level financial overviews clearly, drawing focus to key transactional metrics.
* **Vertical Hierarchy Stack:** Key balance figures stack vertically above comparison metrics on compact screens to optimize reading space.
* **Horizontal Row Distribution:** Overview cards align horizontally in equal-width columns on wider displays, giving users a complete financial snapshot at a single glance.

---

## 22. Adaptive Search
Search layouts and transaction filtering tools adapt to keep query inputs and active tags easy to access.
* **Sticky Header Search Bar:** On compact screens, the search bar is pinned to the top header zone, keeping filters easily reachable.
* **Interactive Slide Drawer:** On expanded viewports, filtering options transition from expandable rows to a persistent side drawer, allowing users to refine queries with ease.

---

## 23. Adaptive Dialogs
Dialogs are high-priority modal overlays used for critical system confirmations, adapting their scale to remain centered and non-intrusive.
* **Constrained Width Bounds:** Dialog widths are locked to standard responsive proportions, ensuring overlays never expand to touch the physical screen edges on larger viewports.
* **Logical Button Grouping:** Confirm and cancel actions are grouped at the bottom, with the primary confirm button positioned at the logical start edge for immediate action.

---

## 24. Adaptive Bottom Sheets
Bottom sheets are modal drawers that expand from the bottom of the screen, keeping settings and categorization tools within comfortable thumb-reach.
* **Maximum Height Constraints:** Sheets are constrained to a maximum vertical screen height, and enable vertical scrolling inside the drawer if content exceeds limits.
* **Dynamic Dialog Scaling:** Bottom sheets transition into centered, non-intrusive dialog overlays when parent viewport widths exceed `bankyar.breakpoint.medium`.

---

## 25. Adaptive Cards
Cards represent the primary visual vessel for financial records, adapting their padding and structure to maintain visual balance.
* **Proportionate Padding Scaling:** Card internal padding scales dynamically from the semantic token `bankyar.space.md` on compact screens to `bankyar.space.lg` on expanded viewports.
* **Vertical Content Wrapping:** Symmetrical row elements wrap into vertical stacks on narrow screens to prevent text clipping.

---

## 26. Adaptive Lists
List layouts handle scrollable feeds, adjusting their density and separation markers to match the active device class.
* **Dense Informational Spacing:** Lists on compact screens use tight spacing and hairline dividers to show more records at once.
* **Grouped Structural Cards:** On expanded viewports, lists transition into spaced-out structural card groups, optimizing readability and visual comfort.

---

## 27. Adaptive Empty States
Empty states provide clear, reassuring guidance when no transactions, rules, or search results are available, adjusting their layout to fit the screen.
* **Vertical Centering Grid:** Empty state elements are grouped and centered vertically within the parent layout, remaining readable on any screen size.
* **Actionable Onboarding Steps:** The empty state displays a prominent action button, guiding users on how to import statements or create manual transactions.

---

## 28. Adaptive Error States
Error states handle parsing failures or system issues, presenting warnings in plain language while adjusting to the viewport.
* **Contained Alert Envelopes:** Error warnings are nested inside flat cards, using high-contrast indicators to draw attention on any screen size.
* **Primary Recovery Controls:** Every error state includes an accessible recovery action button, helping users retry the failed operation with a single tap.

---

## 29. Adaptive Loading States
Loading states use stable skeleton layouts to represent content while background tasks run, avoiding layout jumps.
* **Matched Geometry Skeletons:** Skeleton containers must match the exact height, curvature, and alignment of the actual cards and lists they represent.
* **Stable Layout Boundaries:** Content boundaries are locked to stable aspect ratios, ensuring the screen remains steady as data loads.

---

## 30. RTL Adaptive Rules
RTL adaptive rules ensure that Persian layouts flow and mirror naturally, matching regional reading and interaction habits.

```
RTL Layout Flow: [Margin Start (Right Edge)] ========> [Margin End (Left Edge)]
```

* **Logical Direction Mapping:** Left/right properties are completely excluded from definitions. The layout uses logical start/end coordinates, ensuring alignments mirror automatically when switching locales.
* **Directional Icon Mirroring:** Navigation back chevrons, swipe gestures, progress trackers, and forward indicators mirror dynamically based on active language direction.

---

## 31. Accessibility Across Devices
Accessibility across devices ensures the interface remains highly readable and easy to navigate for all users, implementing the core tenets of `DESIGN_PHILOSOPHY.md`.

### Accessibility Matrix

| Device Class | Large Text Strategy | Screen Reader Priority | Keyboard / Cursor Highlight | Focus Ring Style |
| :--- | :--- | :--- | :--- | :--- |
| **Compact Phones** | Wrap rows to vertical stacks | Single-focus linear sweep | System-level hover tint | High-contrast inner ring |
| **Standard Phones**| Wrap rows to vertical stacks | Single-focus linear sweep | System-level hover tint | High-contrast inner ring |
| **Large Phones**   | Wrap rows to vertical stacks | Single-focus linear sweep | System-level hover tint | High-contrast inner ring |
| **Foldables**      | Multi-pane focus splitting | Pane-by-pane priority sweep | Double-line outline border| High-contrast outer ring |
| **Tablets**        | Multi-pane focus splitting | Master-detail dual sweeps | Double-line outline border| High-contrast outer ring |
| **Desktops**       | Container width reflowing  | Grid-coordinate navigation  | Symmetrical focus overlay | Primary accent border ring|

---

## 32. Performance Considerations
Performance-first design guarantees that layouts render smoothly and remain highly responsive, even on low-end mobile devices.
* **Thread Separation Optimization:** Heavy analytical calculations, SMS parsing, and database transactions are processed in background threads, keeping the UI thread responsive at 60fps+.
* **Elimination of Layout Shifts:** Container sizes and image bounding containers are locked to stable dimensions, preventing layout jumps and rendering overhead.

---

## 33. Memory Considerations
Memory considerations ensure the application remains light and stable, protecting device resources during long sessions.
* **Lazy List Rendering:** Transaction feeds and long lists render items lazily as they scroll into view, releasing memory for off-screen cards.
* **Asset Optimization Strategy:** No heavy media assets, remote fonts, or dynamic image loaders are used, keeping memory footprints low and secure.

---

## 34. Offline-first Considerations
Offline-first design ensures the application remains fully functional and reliable without requiring network connectivity.
* **Perfect Status Continuity:** The application does not show "offline warnings" or "no internet connection" alerts. It simply functions at 100% capacity at all times.
* **Instant State Mutations:** User actions (such as saving notes, updating categories, or modifying rules) are committed instantly to the local database, with changes rendered immediately on screen.

---

## 35. Design Token Adaptation
Design token adaptation governs how tokens adapt dynamically to represent different visual states and viewport metrics.
* **Contextual Token Resolution:** Themes and layouts do not introduce new tokens. Instead, they remap semantic tokens to different sets of Global values, preserving structural logic.
* **Enforced Value Independence:** Layout and spacing tokens are strictly separated from visual theme colors, ensuring the interface remains stable as visual styles change.

---

## 36. Component Adaptation Rules
Component adaptation rules define how complex widgets reflow their structures across different device breakpoints.

### Component Adaptation Matrix

| Component | Compact View (Phone) | Medium View (Tablet) | Expanded View (Desktop) |
| :--- | :--- | :--- | :--- |
| **Transaction List** | Single-column scroll | Dual-pane master list | Multi-column tabular list |
| **Transaction Details**| Bottom sheet overlay | Centered detail pane | Persistent side detail pane |
| **Statistics Dashboard**| Vertical cards stack | Horizontal cards row | Coordinated analytics grid |
| **Charts** | Inline donut display | Side-by-side comparison | Interactive multi-axis grid |
| **Search** | Header search bar | Sticky master search | persistent side panel |
| **Filters** | Horizontal chips bar | Slide-out side drawer | Persistent side drawer |
| **Forms** | Single-column vertical stack| Multi-column rows | Split-column inputs row |
| **Dialogs** | Screen-edge dialog | Centered dialog overlay | Centered dialog overlay |
| **Bottom Sheets** | Screen-edge modal drawer | Centered dialog overlay | Centered dialog overlay |
| **Navigation** | Bottom navigation bar | Left vertical nav rail | Persistent left side drawer |

---

## 37. Governance Rules
To prevent inconsistent layout adjustments and protect visual consistency, all design contributions must comply with the following governance rules:

1. **No Arbitrary Sizes:** Hardcoded margins, offsets, and paddings are strictly prohibited. Every dimension must reference an active layout or spacing token.
2. **Predictable Layout Zones:** Every new screen must follow our standard three-zone structural model (Header, Feed, Control).
3. **Gestalt Alignment:** Related visual elements must use consistent spacing tokens, signaling functional relationships through structured spacing.
4. **Accessibility First:** Spacing, cards, and viewports must support up to 200% system-level text magnification without overlapping or clipping text.
5. **No Visual Hiding:** No financial metrics or primary interactive controls may be omitted on smaller screens; content must wrap or reflow instead.
6. **RTL Native Mirroring:** All layouts must use logical start/end parameters to ensure flawless automatic mirroring between Persian and English locales.
7. **No Hardcoded Colors:** All visual surface and text colors must be resolved using semantic design tokens, ensuring perfect visual mode compatibility.

---

## 38. Validation Checklist
Before implementing or submitting an adaptive layout, verify compliance against this validation checklist:

- [ ] Does the layout align strictly with the active column grid across all breakpoints?
- [ ] Are all padding, margin, and gap properties defined using design tokens?
- [ ] Are left/right alignments entirely excluded, using logical start/end properties instead?
- [ ] Does the layout support up to 200% text magnification without overlapping text lines?
- [ ] Are core interactive elements located within comfortable thumb-reach on compact viewports?
- [ ] Does the screen follow the standard three-zone structural model?
- [ ] Have you verified that no financial metrics or controls are hidden on compact screens?
- [ ] Does the master-detail view transition cleanly when viewport widths cross breakpoint thresholds?

---

## 39. Anti-pattern Catalog
The following adaptive and visual anti-patterns are strictly prohibited:

* **Physical Layout Hardcoding:** Direct use of physical left/right margins or hardcoded pixel coordinates in layouts is prohibited.
* **Fixed Height Wrappers:** Placing body text or list cards inside fixed-height wrappers that clip text when system text scale is increased is prohibited.
* **Dynamic Content Hiding:** Concealing financial records, transactional balances, or active controls on compact screens to save space is prohibited.
* **Device-Specific Hack Queries:** Using platform-specific browser queries or operating system detection to adjust layouts, rather than parent container queries.
* **Overloaded Floating Actions:** Placing multiple floating action buttons on a single screen is prohibited.

---

## 40. Migration & Future Evolution Strategy
As BankYar expands, the Adaptive Experience System is built to scale:

* **Universal Viewport Registry:** Support for future device classes (such as wearables, smart TVs, or specialized hardware screens) is added by registering new breakpoint tokens, keeping existing code unchanged.
* **Platform-Agnostic Adaptation:** The adaptive layout rules avoid framework-specific dependencies, ensuring the design system can be compiled cleanly for future platforms (such as iOS and desktop environments).
* **Component-First Expansion:** New features must compose existing layout patterns (such as standard bottom sheets and flat cards) rather than introducing custom layouts, preserving visual consistency.

---
**End of Document**
