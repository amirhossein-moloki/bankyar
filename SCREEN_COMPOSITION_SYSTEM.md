# BankYar Screen Composition & Page Templates System (v1.0.0)
## Enterprise-Grade Page Composition Architecture for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, UX Architect, Enterprise Design System Expert, Flutter UI Architect, Information Architecture Specialist
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary
This document establishes the official **Screen Composition & Page Templates System** for the BankYar ecosystem. Acting as the absolute architectural authority for visual asset arrangement, structural nesting, and interactive hierarchy, this specification translates the product personality (Stoic, Precise, Empowering) and layout laws defined in `DESIGN_PHILOSOPHY.md` and `LAYOUT_SPACING_SYSTEM.md` into deterministic composition rules.

To guarantee complete visual integrity, scaling under accessibility magnification up to 200%, and seamless support for Persian Right-to-Left (RTL) reading flows, **all screen templates are composed using abstract relative token relationships and logical coordinates.** No physical coordinates, hardcoded pixel sizes (px, dp, sp), or platform-specific layouts are permitted. This architecture provides the foundational scaffolding that guarantees absolute consistency and visual comfort across all screen sizes, foldables, tablets, and future platform environments.

---

## Table of Contents
1. [Screen Composition Philosophy](#1-screen-composition-philosophy)
2. [Page Hierarchy Principles](#2-page-hierarchy-principles)
3. [Screen Anatomy](#3-screen-anatomy)
4. [Information Density Strategy](#4-information-density-strategy)
5. [Visual Hierarchy Rules](#5-visual-hierarchy-rules)
6. [Page Zones](#6-page-zones)
7. [Safe Area Strategy](#7-safe-area-strategy)
8. [App Bar Composition](#8-app-bar-composition)
9. [Content Area Composition](#9-content-area-composition)
10. [Bottom Action Area](#10-bottom-action-area)
11. [Floating Actions Strategy](#11-floating-actions-strategy)
12. [Sticky Components](#12-sticky-components)
13. [Scroll Behavior](#13-scroll-behavior)
14. [Nested Scroll Rules](#14-nested-scroll-rules)
15. [List-based Pages](#15-list-based-pages)
16. [Dashboard Pages](#16-dashboard-pages)
17. [Detail Pages](#17-detail-pages)
18. [Search Pages](#18-search-pages)
19. [Statistics Pages](#19-statistics-pages)
20. [Settings Pages](#20-settings-pages)
21. [Security Pages](#21-security-pages)
22. [Backup & Restore Pages](#22-backup--restore-pages)
23. [Onboarding Pages](#23-onboarding-pages)
24. [Permission Request Pages](#24-permission-request-pages)
25. [Dialog Templates](#25-dialog-templates)
26. [Bottom Sheet Templates](#26-bottom-sheet-templates)
27. [Full-screen Flow Templates](#27-full-screen-flow-templates)
28. [Empty State Integration](#28-empty-state-integration)
29. [Loading State Integration](#29-loading-state-integration)
30. [Error State Integration](#30-error-state-integration)
31. [Responsive Composition Rules](#31-responsive-composition-rules)
32. [RTL Composition Rules](#32-rtl-composition-rules)
33. [Accessibility Composition Rules](#33-accessibility-composition-rules)
34. [Design Token Integration](#34-design-token-integration)
35. [Component Placement Rules](#35-component-placement-rules)
36. [Screen Validation Checklist](#36-screen-validation-checklist)
37. [Governance Rules](#37-governance-rules)
38. [Anti-pattern Catalog](#38-anti-pattern-catalog)
39. [Future Template Expansion Strategy](#39-future-template-expansion-strategy)
40. [Composition Decision Matrix](#40-composition-decision-matrix)

---

## 1. Screen Composition Philosophy
The screen composition philosophy of BankYar is built on the tenet that **Content is the Interface**. In alignment with our strict privacy-first, zero-network, and offline-first guidelines, screens are designed to eliminate visual noise, maximize information clarity, and maintain physical predictability.

Every page in BankYar is composed of three foundational truths:
* **Structural Determinism:** Screens are constructed from a standardized grid. When a user navigates between features, components do not shift arbitrarily. They align with stable horizontal and vertical baselines, which minimizes cognitive load.
* **One-Handed Operational Utility:** Interactive zones are placed within easy reach of the thumb (lower half of the viewport). Heavy reading sections or high-level charts remain in the upper regions of the screen.
* **Semantic Integrity:** Visual structures use semantic tokens that map to functional state relationships rather than aesthetic choices, ensuring flawless adaptivity under dark mode, high-contrast, and RTL locales.

---

## 2. Page Hierarchy Principles
Page hierarchy governs how users move deeper into the application's domain model without losing spatial orientation. We enforce a **three-tier depth structure** across the entire routing tree:

```
[ Tier 1: Shell Gateways ] (Splash, Lock Screen, Onboarding, Authenticated Shell Root)
          |
          v
[ Tier 2: Feature Feed / Workspace ] (Chronological Ledger, Spend Analytics, Preference List)
          |
          v
[ Tier 3: Focused Detail / Action ] (Transaction Inspector, Custom Rules Builder, Backup Passphrase Wizard)
```

* **Tier 1 (Shell Gateways):** High-priority structural entry points. These are full-screen templates that block user entry until specific states (security validation, initialization) are resolved.
* **Tier 2 (Feature Workspace):** Primary working surfaces. These utilize multi-column layouts on wider screens and persistent list/grid adapters on phone screens.
* **Tier 3 (Detail/Action):** Focused sub-surfaces that overlay or slide onto Tier 2 workspaces. They restrict user focus to a single, high-fidelity objective (such as viewing structured transaction data or configuring a custom regex).

---

## 3. Screen Anatomy
Every screen template in the BankYar ecosystem is constructed using a unified structural layout. The diagram below illustrates how screen components are organized horizontally and vertically under an RTL layout:

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY HEADER]                                                |
|  +-------------------------------------------------------------------+  |
|  | [Status Indicator]         [Page Title]             [Actions Row] |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & FEED]                                  |
|  +-------------------------------------------------------------------+  |
|  | [Persistent Element: Active Filters / Balance Banner]             |  |
|  |                                                                   |  |
|  | [Primary Content Block: Ledger Lists / Analytics Charts]          |  |
|  |                                                                   |  |
|  | [Secondary Content: Category Metadata / Annotations]              |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY CONTROL & NAVIGATION]                                  |
|  +-------------------------------------------------------------------+  |
|  | [Floating Component: FAB] (RTL Start Anchor)                      |  |
|  |                                                                   |  |
|  | [Persistent Element: Bottom Action / Navigation Bar]              |  |
|  |                                                                   |  |
|  | [Temporary Element: Toast Notice / Bottom Sheet Drawer]           |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

### Anatomy Elements Taxonomy

1. **Header:** The top App Bar that defines screen purpose and provides basic navigation utilities (back button).
2. **Navigation:** The architectural mechanism (bottom bar, lateral navigation rail, or modal exit buttons) used to move between contexts.
3. **Primary Content:** The main scrollable content area, displaying transactions, analytics charts, settings lists, or form fields.
4. **Secondary Content:** Contextual details that support primary content (unparsed raw SMS texts, category badges, inline alerts).
5. **Actions:** Interactive triggers (buttons, chips, icons) that allow users to modify, create, or delete data.
6. **Status Indicators:** Micro-elements that display system or transactional status (success badges, diagnostic heartbeats, security lock status).
7. **Floating Components:** Overlay triggers, such as Floating Action Buttons (FABs), that float above scrollable content in Zone C.
8. **Bottom Actions:** Fixed interaction controls placed in Zone C (primary action buttons, dual action buttons, or quick-save rows).
9. **Persistent Elements:** Layout structures that remain in place during scrolling (sticky summaries, active filter rows).
10. **Temporary Elements:** Transient overlays that appear on top of other screen content (toasts, dialog confirmations, bottom sheets).

---

## 4. Information Density Strategy
Information density governs the quantity of visual items displayed in a single viewport. BankYar supports two standard density profiles:

* **Comfortable Density Profile:**
  * Primarily used for onboarding, settings, details pages, forms, and setup wizards.
  * Emphasizes whitespace and spatial separation to reduce cognitive load during complex tasks.
  * Internal padding token mapping: `bankyar.space.lg` (vertical gaps) and `bankyar.space.md` (horizontal gutters).
* **Compact Density Profile:**
  * Used for chronological transaction feeds, analytical tabular logs, and filter lists.
  * Optimizes horizontal scanning space to help users review multiple data points without scrolling excessively.
  * Internal padding token mapping: `bankyar.space.md` (vertical gaps) and `bankyar.space.sm` (horizontal gutters).

---

## 5. Visual Hierarchy Rules
Visual hierarchy guides the user's eye across the screen in a logical path, ensuring that critical data is read first.

```
Visual Scan Path: [ Top-End (RTL Start Point) ] ============> [ Top-Start (RTL End Point) ]
                                                                       |
                                                                       v
                  [ Bottom-End (Action Targets) ] <=========== [ Center Workspace ]
```

* **Typographical Scaling:** Headings, financial amounts, and titles are styled with larger display fonts and higher weights to establish clear focal points.
* **Color Contrast Weights:** Core interactive triggers and primary status updates use high-contrast primary colors. Inactive states, metadata, and background cards use subtle neutral and border tones to reduce visual noise.
* **Spatial Containers (Gestalt Proximity):** Elements that are functionally related are grouped inside flat cards (`bankyar.semantic.color.surface.default`), separating them visually from surrounding elements.

---

## 6. Page Zones
Every screen in BankYar is divided into three fixed vertical layout zones:

| Zone | Name | Scroll Rule | Target Content |
| :--- | :--- | :--- | :--- |
| **Zone A** | Header & Diagnostics | Pinned / Collapsible | App Bar, Screen title, quick diagnostic statuses, active filters |
| **Zone B** | Content Workspace & Feed | Fully Scrollable | Transaction lists, financial forms, settings lists, statistics charts |
| **Zone C** | Control & Sticky Actions | Pinned / Sticky | Bottom navigation, floating action buttons, primary action footers |

---

## 7. Safe Area Strategy
The Safe Area Strategy prevents system status indicators, notches, camera cutouts, and bottom navigation home indicators from overlapping interactive elements.

* **Start and End Edge Insets:** Layout boundaries must dynamically query device notch regions, applying logical-start or logical-end padding buffers so that content remains readable.
* **Gesture Navigation Buffers:** The bottom interaction zone must append a structural spacing offset to prevent native system gestures (like swipe-to-home) from conflicting with bottom navigation bar items or floating buttons.

---

## 8. App Bar Composition
The App Bar provides a persistent header at the top of the screen, housing page titles and secondary actions.

```
RTL Layout App Bar:
+-------------------------------------------------------------------------+
| [Action: Back Chevron] (End)       [Page Title]             [Actions Row] (Start) |
+-------------------------------------------------------------------------+
```

* **Title Centering:** Page titles are centered horizontally on mobile devices.
* **Logical Start Actions:** Multi-item secondary action rows (such as search, filters, or refresh buttons) are aligned to the logical start edge of the App Bar.
* **Logical End Back Button:** Back chevrons are aligned strictly to the logical end edge of the App Bar, mirroring the natural reading direction.

---

## 9. Content Area Composition
The main container area (Zone B) is designed to organize content into clean, readable layouts.

* **Grid Columns:** Columns represent active layout areas where structural elements span. Column widths are dynamic and calculated based on screen estate.
* **Gutter Channels:** Spaces between adjacent columns that prevent informational overlap. Gutters are mapped strictly to the `bankyar.responsive.gutter` token.
* **Boundary Margins:** Outer padding envelopes separating the outermost columns from the physical device edges. Margins are resolved via `bankyar.responsive.margin` tokens.

---

## 10. Bottom Action Area
The bottom action area (Zone C) houses the screen's primary interactive triggers, keeping them within easy reach of the thumb.

```
Dual Action Layout:
+-------------------------------------------------------------------------+
| [ Primary Call-To-Action Button ]       [ Secondary Dismiss Button ]    |
| (Logical Start - High Contrast Accent)  (Logical End - Low Contrast Border) |
+-------------------------------------------------------------------------+
```

* **Primary Trigger Dominance:** The primary action is styled with high contrast and positioned at the logical start edge.
* **Secondary Action Demotion:** Secondary actions (cancel, reset, back) are styled with low-contrast borders and positioned at the logical end edge.

---

## 11. Floating Actions Strategy
Floating Action Buttons (FABs) provide rapid access to the screen's primary interactive action (such as manual SMS parsing or rule creation).

```
RTL Layout FAB:
+-------------------------------------------------------------------------+
| [ FAB Icon ]                                                            |
| (Logical Bottom-Start / Lower Right of screen)                          |
+-------------------------------------------------------------------------+
```

* **Positioning:** FABs are positioned at the logical bottom-start edge of the screen, matching the reading end-point of RTL layouts to ensure high visibility.
* **Visual Protection:** FABs must maintain comfortable spacing buffers from screen edges and the bottom navigation bar to prevent touch overlaps.

---

## 12. Sticky Components
Sticky components remain pinned in place during scrolling, keeping critical data and actions visible.

* **App Bar Stability:** The top App Bar remains pinned at the top of the viewport. When content scrolls underneath, a subtle divider line (`bankyar.semantic.color.border.subtle`) appears to define structure.
* **Scroll-Locked Summaries:** In list-based screens, summary bars (such as total monthly spend or active filters) remain pinned immediately below the App Bar.

---

## 13. Scroll Behavior
Scroll behavior is designed to feel fluid and natural, aligning with platform-specific physics while protecting layout stability.

* **Momentum Scrolling:** Scrollable areas use standard momentum physics to ensure smooth, natural interactions.
* **Overscroll Indicators:** Overscroll indicators use subtle, non-intrusive animations that match the active theme.
* **Scroll-Bound Actions:** Scrolling down hides secondary floating actions to maximize screen space; scrolling up reveals them instantly.

---

## 14. Nested Scroll Rules
Nested scrollable areas must be designed carefully to prevent touch conflicts and ensure a smooth user experience.

* **Directional Locking:** Scrollable areas are locked to a single direction (either horizontal or vertical).
* **Scroll Chaining Prevention:** Scroll events within a nested scrollable area, such as a horizontal category list, must not trigger scrolling in the parent container, such as a vertical transaction feed.

---

## 15. List-based Pages
List-based pages are designed to handle scrollable lists of transactions, rules, or settings rows efficiently.

```
List Layout Architecture:
+-------------------------------------------------------------------------+
| [Section Header: Date / Category Name]                                  |
| ----------------------------------------------------------------------- |
| [ List Card Item - Curvature: radius.lg ]                              |
| ----------------------------------------------------------------------- |
| [ List Card Item - Curvature: radius.lg ]                              |
+-------------------------------------------------------------------------+
```

* **Visual Separation:** List items are grouped inside flat cards or separated by subtle hairline dividers (`bankyar.semantic.color.border.subtle`).
* **Tap Targets:** List items maintain comfortable vertical touch heights to prevent accidental selections.

---

## 16. Dashboard Pages
Dashboard pages provide high-level financial overviews and quick access to core features.

```
Dashboard Layout:
+-------------------------------------------------------------------------+
| [ Balance Component - Display Typography ]                              |
|   Total Account Balance: +1,240,000 Rials                               |
| ----------------------------------------------------------------------- |
| [ Income / Expense Columns ]                                            |
|   Income: +2,500,000 Rials              | Expenses: -1,260,000 Rials   |
| ----------------------------------------------------------------------- |
| [ Recent Transaction Feed ]                                             |
|   - Item 1: Snapp Taxi                  | - Item 2: Mellat Transfer    |
+-------------------------------------------------------------------------+
```

* **Primary Visual Focus:** Balance metrics are displayed at the top in large display typography.
* **Quick-Access Actions:** Primary actions are kept within comfortable thumb-reach in Zone C.

---

## 17. Detail Pages
Detail pages present a deep, structured analysis of a single financial record or transaction.

```
Detail Page Layout:
+-------------------------------------------------------------------------+
| [ High Contrast Amount Indicator ]                                      |
| ----------------------------------------------------------------------- |
| [ Tab A: Structured Info ]           [ Tab B: Raw SMS Carrier Text ]    |
| ----------------------------------------------------------------------- |
| - Transaction ID: ID_102948                                             |
| - Assigned Category: [ Chip: Transport ]                                |
| - Notes Field: "Fuel payment during trip"                               |
+-------------------------------------------------------------------------+
```

* **Interactive Detail Tabs:** Users can switch between "Structured Info" and "Raw SMS Carrier Text" tabs without reloading the page.
* **Actionable Layout States:** Interactive details use a visual pressed state to provide tactile feedback.

---

## 18. Search Pages
Search pages provide fast, local search query capabilities with integrated filters.

```
Search Layout:
+-------------------------------------------------------------------------+
| [ Search Field ] [Clear Button]                                         |
| ----------------------------------------------------------------------- |
| [ Active Filters Row: Horizontally scrolling chips ]                    |
| ----------------------------------------------------------------------- |
| [ Scrollable Results Feed ]                                             |
+-------------------------------------------------------------------------+
```

* **Instant Field Clears:** A clear button is positioned at the logical end edge of the search field.
* **Input Debouncing:** Search queries are debounced by 300ms to protect database performance.

---

## 19. Statistics Pages
Statistics pages combine charts, selectors, and summary cards into a clear visual report.

```
Statistics Layout:
+-------------------------------------------------------------------------+
| [ Period Selector: Weekly | Monthly | Yearly ]                          |
| ----------------------------------------------------------------------- |
| [ Spend Distribution Donut Chart ]                                      |
| ----------------------------------------------------------------------- |
| [ Scrollable Category Spend Table ]                                     |
+-------------------------------------------------------------------------+
```

* **Stable Aspect Ratios:** Charts are constrained to stable ratios to prevent visual distortion.
* **Interactive Drill-Downs:** Tapping a chart segment automatically filters the ledger list.

---

## 20. Settings Pages
Settings pages are organized into linear preference lists, grouped logically by category.

```
Settings Layout:
+-------------------------------------------------------------------------+
| [ Category Divider: Security Settings ]                                 |
| ----------------------------------------------------------------------- |
| [ Security PIN Preference Row ] [Flow Chevron]                          |
| [ Biometric Authentication Toggle ]                                     |
+-------------------------------------------------------------------------+
```

* **Action Indicators:** Rows that navigate to sub-pages display a flow chevron on the logical end edge.
* **Persistent Groupings:** Related preferences are grouped inside flat cards to reduce clutter.

---

## 21. Security Pages
Security pages manage access gates, PIN authentication, and privacy-focused locks.

```
Security Lock Screen:
+-------------------------------------------------------------------------+
| [ Large Shield Lock Graphic ]                                           |
| ----------------------------------------------------------------------- |
| { Enter Secure PIN }                                                    |
| [ PIN Input Dots Indicator ]                                            |
| ----------------------------------------------------------------------- |
| [ Numerical Keypad Grid Layout (3x4) ]                                  |
+-------------------------------------------------------------------------+
```

* **Numerical Keypad Layout:** Displays a clear, accessible 3x4 grid for PIN entries.
* **Privacy Screen Overlays:** Active app window contents are automatically blanked or obscured in multitasking viewports to prevent sensitive financial data leakage.

---

## 22. Backup & Restore Pages
Backup and restore pages guide users through secure local data export and import wizards.

```
Backup Wizard:
+-------------------------------------------------------------------------+
| [ Large Shield Archive Icon ]                                           |
| ----------------------------------------------------------------------- |
| { Secure Export Wizard }                                                |
| Create a secure .bankyar backup. Enter a passphrase to encrypt your     |
| offline database with AES-256-GCM.                                      |
| ----------------------------------------------------------------------- |
| [ Passphrase Field ] [ Confirm Passphrase Field ]                       |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Export encrypted backup file ]                 |
+-------------------------------------------------------------------------+
```

* **Encrypted File Exports:** Generates standard encrypted `.bankyar` files containing the local database.
* **Validation Prompts:** Validates passphrases locally and displays strong warning notices before overwriting existing data.

---

## 23. Onboarding Pages
Onboarding pages welcome users and walk them through initial setup.

```
Onboarding Slide:
+-------------------------------------------------------------------------+
| [ Warm Onboarding Illustration Icon ]                                   |
| ----------------------------------------------------------------------- |
| { Welcome to BankYar }                                                  |
| Your secure, completely offline financial analytics assistant.          |
| ----------------------------------------------------------------------- |
| [ Slide Indicators Row (Dots) ]                                         |
| [ Primary Onboarding Button ]                                           |
+-------------------------------------------------------------------------+
```

* **Welcome Progress Indicators:** Horizontal dot indicators show progression through onboarding steps.
* **Clear Skip Options:** Allows users to easily skip secondary onboarding steps.

---

## 24. Permission Request Pages
Permission pages explain why BankYar requires system access (such as SMS access).

```
Permission Request Screen:
+-------------------------------------------------------------------------+
| [ Large Keyhole Graphic ]                                               |
| ----------------------------------------------------------------------- |
| { SMS Access Request }                                                  |
| BankYar requires SMS permission to automatically ingest banking        |
| transaction alerts. Your messages never leave this device.              |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Grant Access ]                                 |
| [ Secondary Action Button: Setup Manually ]                             |
+-------------------------------------------------------------------------+
```

* **Clear, Direct Language:** Explains exactly why the permission is needed and reinforces privacy rules.
* **Non-Coercive Choices:** Provides immediate alternatives (such as manual entry) if permission is denied.

---

## 25. Dialog Templates
Dialogs are high-priority overlays used for critical confirmations.

```
Confirmation Dialog:
+-------------------------------------------------------------------------+
| { Confirm Local Database Wipe? }                                        |
| This action is permanent. All offline transaction histories will be     |
| erased unless an encrypted backup is saved.                             |
| ----------------------------------------------------------------------- |
| [ Action 1: Confirm Wipe ]       [ Action 2: Cancel Action ]            |
| (Logical Start - Red Warning)    (Logical End - Secondary Border)       |
+-------------------------------------------------------------------------+
```

* **Width Constraints:** Dialog widths are constrained to ensure comfortable spacing on all viewports.
* **Explicit Confirmations:** Primary confirmations are positioned at the logical start edge.

---

## 26. Bottom Sheet Templates
Bottom sheets slide up from the bottom of the screen to present secondary menus.

```
Bottom Sheet Menu:
+-------------------------------------------------------------------------+
|                          === [ Drag Handle ] ===                        |
| ----------------------------------------------------------------------- |
| { Select Category }                                   [Close Trigger]   |
| ----------------------------------------------------------------------- |
| [ Scrollable Category Chip Grid ]                                       |
+-------------------------------------------------------------------------+
```

* **Swipe dismissal:** Supports downward swipes to close the sheet.
* **Height caps:** Sheets are capped at 70% of screen height to keep the underlying screen partially visible.

---

## 27. Full-screen Flow Templates
Full-screen templates manage complex, multi-step actions (such as manual rule builders).

```
Multi-Step Rule Builder:
+-------------------------------------------------------------------------+
| [ App Bar: Rule Builder ] [ Step 1 of 3 Progress Bar ]                  |
| ----------------------------------------------------------------------- |
| { Select Target SMS Sender }                                            |
| [ Sender Search Dropdown ]                                              |
| ----------------------------------------------------------------------- |
| [ Primary Next Step Button ]            [ Secondary Previous Button ]   |
+-------------------------------------------------------------------------+
```

* **Interactive Progress Indicators:** Displays clear progress steps, such as Step 1 of 3, at the top.
* **Exit Protections:** Confirms dismissals to prevent unsaved data loss.

---

## 28. Empty State Integration
Empty states provide friendly guidance when no data is available, avoiding blank screens.

```
Empty State Screen:
+-------------------------------------------------------------------------+
| [ Large Empty State Illustration Icon ]                                 |
| ----------------------------------------------------------------------- |
| { No Transaction History Found }                                        |
| We haven't detected any banking SMS alerts yet. If you have active SMS  |
| alerts, ensure SMS permissions are enabled.                             |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Manual Import ]                                |
+-------------------------------------------------------------------------+
```

* **Vertical Centering:** Empty state elements are grouped and centered vertically on the screen.
* **Empathetic Microcopy:** Reassures the user and provides a clear next step.

---

## 29. Loading State Integration
Loading states use flat skeleton templates to represent loading elements, maintaining layout stability.

```
Skeleton Card Loading:
+-------------------------------------------------------------------------+
| [ Shimmering Circle Skeleton ]  [ Shimmering Rounded Line Skeleton ]    |
|                                 [ Shimmering Short Line Skeleton ]      |
+-------------------------------------------------------------------------+
```

* **Geometrical Match:** Skeletons match the exact heights, widths, and curvature of actual elements.
* **Layout Shifts Elimination:** Content boundaries remain stable while background tasks execute.

---

## 30. Error State Integration
Error states display failures in plain language and provide a clear way to recover.

```
Error Recovery Screen:
+-------------------------------------------------------------------------+
| [ Large Warning Shield Graphic ]                                        |
| ----------------------------------------------------------------------- |
| { Database Decryption Failed }                                          |
| The security PIN entered is incorrect. If you have forgotten your PIN,  |
| you must restore from an encrypted backup.                              |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Retry Decryption ]                             |
+-------------------------------------------------------------------------+
```

* **PII Redaction:** Redacts internal technical details from visual screens.
* **Direct Recoveries:** Provides actionable buttons to resolve the error.

---

## 31. Responsive Composition Rules
Layouts adapt dynamically across different screen sizes:

```
Compact (Phone)            Medium (Tablet / Foldable)    Expanded (Tablet / Desktop)
+-------------------+      +-------------+-------------+  +-------+-------------+-------------+
| Single-pane list  | ===> | List Pane   | Detail Pane |  | Rail  | List Pane   | Detail Pane |
+-------------------+      +-------------+-------------+  +-------+-------------+-------------+
```

* **Column Scale:** Layout grids scale from 4 columns (compact) to 8 columns (medium) and 12 columns (expanded).
* **Multi-Pane Viewports:** Medium and expanded layouts transition to double-column master-detail views.

---

## 32. RTL Composition Rules
BankYar is designed RTL-first, ensuring that Persian layouts flow and mirror naturally.

```
RTL Flow:  [ Margin Start (Right Edge) ]  ======================>  [ Margin End (Left Edge) ]
```

* **Logical Margins:** Excludes physical properties, using logical start and end alignments instead.
* **Asset Mirroring:** Directional icons (back arrows, chevrons, progress meters) mirror automatically.

---

## 33. Accessibility Composition Rules
Accessibility rules ensure BankYar remains readable and usable for all users.

* **MAGNIFICATION_RULE:** Layout rows must wrap to vertical stacks if font scales exceed standard boundaries, preventing text clipping.
* **TOUCH_TARGET_RULE:** Every interactive button and target must maintain a minimum physical touch target of `bankyar.space.xl` to ensure ease of use.
* **FOCUS_CYCLE_RULE:** System focus cycles follow a predictable top-to-bottom, right-to-left sequence.

---

## 34. Design Token Integration
Every composition element in BankYar maps directly to semantic design tokens.

| Element | Visual Parameter | Design Token Key |
| :--- | :--- | :--- |
| Screen Background | Fill Color | `bankyar.semantic.color.background.default` |
| Primary Card | Background Color | `bankyar.semantic.color.surface.default` |
| Border | Stroke Boundary | `bankyar.semantic.color.border.default` |
| Large Header | Display Typography | `bankyar.semantic.typography.display.lg` |
| Small Header | Sub-heading Typography | `bankyar.semantic.typography.title.sm` |
| Body Text | Reading Text | `bankyar.semantic.typography.body.md` |

---

## 35. Component Placement Rules
Component placement is designed to keep interactive elements within easy reach while keeping information readable.

* **Interactive Elements:** Buttons, chips, and selection lists are kept in the lower half of the viewport (Zone C).
* **Information Overviews:** Charts, high-level summaries, and titles are positioned in the upper half of the screen (Zone A and Zone B).

---

## 36. Screen Validation Checklist
Before any screen design is implemented, it must pass this validation checklist:

- [ ] Does the screen use the standard three-zone structural model (Zone A, B, C)?
- [ ] Are all padding, margin, and gap properties defined using design tokens?
- [ ] Are physical properties completely excluded, using logical start/end properties instead?
- [ ] Does the screen support up to 200% text magnification without clipping text?
- [ ] Are primary interactive elements positioned within comfortable thumb-reach?
- [ ] Does the design include templates for empty, loading, and error states?

---

## 37. Governance Rules
To prevent inconsistent layout adjustments and protect visual consistency, all design contributions must comply with the following spatial governance rules:

1. **No Arbitrary Sizes:** Hardcoded margins, offsets, and paddings are strictly prohibited. Every dimension must reference an active layout or spacing token.
2. **Predictable Layout Zones:** Every new screen must follow our standard three-zone structural model (Header, Feed, Control).
3. **Gestalt Alignment:** Related visual elements must use consistent spacing tokens, signaling functional relationships through structured spacing.
4. **Accessibility First:** Spacing, cards, and viewports must support up to 200% system-level text magnification without overlapping or clipping text.

---

## 38. Anti-pattern Catalog
The following spatial and visual anti-patterns are strictly prohibited:

* **Physical Layout Hardcoding:** Direct use of physical left/right margins or hardcoded pixel coordinates in layouts is prohibited.
* **Fixed Heights:** Placing body text or list cards inside fixed-height wrappers that clip text when system text scale is increased is prohibited.
* **Overloaded Floating Actions:** Placing multiple floating action buttons on a single screen is prohibited.
* **Arbitrary Spacing Steps:** Using non-standard spacing steps (such as custom gaps or margins) that do not align with our core design tokens is prohibited.

---

## 39. Future Template Expansion Strategy
The Screen Composition System is designed to scale as BankYar expands.

* **Modular Template Registration:** New features, such as budgets, category managers, or notification centers, must register their route paths and match their structures to standard templates.
* **Deprecation Lifecycles:** Obsolete layout templates follow a standard deprecation cycle, providing developers with clear migration pathways.

---

## 40. Composition Decision Matrix
This matrix helps design teams choose the correct screen template based on user objectives and feature priority:

| User Objective | Primary Viewport | Key Interactive Needs | Best Matching Template |
| :--- | :--- | :--- | :--- |
| Quick entry | Phone Viewport | Numeric keypad, large inputs, immediate validation | PIN Unlock Screen |
| High-level overviews | Wide Tablet Viewport | Multi-pane summaries, charts, quick details | Home Dashboard Template |
| Chronological review | Phone Viewport | Quick searches, dense scrolling, horizontal filters | Transaction List Template |
| Detailed analysis | Tablet Viewport | Tabbed metadata, full raw text, primary edit actions | Transaction Details Template |

---
## PAGE TEMPLATES CATALOG

### 1. Splash Screen
The initial boot gate of the application, verifying system configurations and local keystores.

```
+-------------------------------------------------------------------------+
|                                                                         |
|                                                                         |
|                       [ Logo Asset: BankYar Icon ]                      |
|                                                                         |
|                                                                         |
|                      { Loading Security Context... }                    |
|                        [ Spinner Indicator Dot ]                        |
|                                                                         |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Simple, focused layout centered on the screen.
  * Displays a progress indicator to signal ongoing background initialization tasks.

### 2. Home Dashboard
The primary landing dashboard, displaying aggregated balances and high-level charts.

```
+-------------------------------------------------------------------------+
| [ ZONE A: App Bar Logo / Quick Diagnostics Statuses ]                   |
| ----------------------------------------------------------------------- |
| [ ZONE B: Balance Component - Display Typography ]                      |
|   Total Account Balance: +1,240,000 Rials                               |
|   (Display Typography Scale)                                            |
| ----------------------------------------------------------------------- |
| [ Income / Expense Cards ]                                              |
|   Income: +2,500,000 Rials              | Expenses: -1,260,000 Rials   |
| ----------------------------------------------------------------------- |
| [ Spend Analytics Donut Chart Segment ]                                 |
| ----------------------------------------------------------------------- |
| [ Recent Transactions Ledger Feed ]                                     |
|   - Item 1: Snapp Taxi                  | - Item 2: Mellat Transfer    |
| ----------------------------------------------------------------------- |
| [ ZONE C: Sticky Bottom Navigation Bar ]                                |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Displays critical balances and high-level summaries at the top.
  * Provides quick access to secondary dashboards and settings.

### 3. Transaction List
A chronological list of transactions with integrated search and quick filters.

```
+-------------------------------------------------------------------------+
| [ ZONE A: Search Text Field & Clear Button ]                            |
| ----------------------------------------------------------------------- |
| [ Horizontal Active Filters Row: Category / Date Chips ]                |
| ----------------------------------------------------------------------- |
| [ ZONE B: Chronological List of Transactions ]                          |
|   - Item 1: Mellat Transfer             | - Item 2: Groceries           |
|   - Item 3: Petrol Station              | - Item 4: Rent Payment        |
| ----------------------------------------------------------------------- |
| [ ZONE C: Sticky FAB (Add Manual Entry) ]                               |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Employs the Compact Density Profile to maximize visible rows.
  * Pin-locks active filters immediately below the App Bar.

### 4. Transaction Details
A full detail inspector presenting parsed transaction records and raw SMS data.

```
+-------------------------------------------------------------------------+
| [ ZONE A: App Bar Title: Transaction Inspector ]                        |
| ----------------------------------------------------------------------- |
| [ ZONE B: Balanced Amount Header: +120,000 Rials ]                      |
| ----------------------------------------------------------------------- |
| [ Detail View Tabs: Structured Info | Raw SMS Carrier Text ]            |
| ----------------------------------------------------------------------- |
|   - ID: ID_102948                       - Timestamp: 1402/10/12         |
|   - Category: [ Chip: Food ]            - Account: Mellat Bank          |
|   - Notes: "Lunch with team"                                            |
| ----------------------------------------------------------------------- |
| [ ZONE C: Secondary Annotations Editor Button ]                         |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Displays high-contrast details inside standard cards.
  * Groups related metadata into clear, structured sections.

### 5. Search
A dedicated local search template with input fields, history list, and quick chips.

```
+-------------------------------------------------------------------------+
| [ ZONE A: Search Bar Text Field & Clear Icon ]                          |
| ----------------------------------------------------------------------- |
| [ ZONE B: Search History Rows ]                                         |
|   - "Mellat Bank"                                                       |
|   - "Snapp Taxi"                                                        |
| ----------------------------------------------------------------------- |
| [ Quick-Select Suggestion Chips ]                                       |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Automatically focuses the input field when launched.
  * Displays active search suggestions and search history.

### 6. Advanced Filters
An expanding filter panel with date ranges, amount ranges, and account toggles.

```
+-------------------------------------------------------------------------+
| [ App Bar: Advanced Filters ]                                           |
| ----------------------------------------------------------------------- |
| { Select Date Range }                                                   |
| [ Start Date Picker Button ]           [ End Date Picker Button ]       |
| ----------------------------------------------------------------------- |
| { Amount Range Limits }                                                 |
| [ Min Amount Text Field ]              [ Max Amount Text Field ]        |
| ----------------------------------------------------------------------- |
| [ Primary Apply Filter Button ]        [ Secondary Clear Button ]       |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Reuses the Comfortable Density Profile for detailed picker menus.
  * Positions clear primary and secondary buttons in Zone C.

### 7. Statistics Dashboard
An analytics dashboard combining spend distributions, cash flows, and selectors.

```
+-------------------------------------------------------------------------+
| [ ZONE A: Period Selector Segment: Weekly | Monthly | Yearly ]          |
| ----------------------------------------------------------------------- |
| [ ZONE B: Spend Distribution Donut Chart Component ]                    |
| ----------------------------------------------------------------------- |
| [ Cash Flow Trend Bar Graph Component ]                                 |
| ----------------------------------------------------------------------- |
| [ High-Spend Categories List ]                                          |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Displays high-level summaries and charts in the upper regions.
  * Tapping chart segments drills down to filter the ledger list.

### 8. Charts
Standard chart elements, including spending donuts and monthly bar graphs.

```
+-------------------------------------------------------------------------+
| [ Donut Spend Chart Segment ]                                           |
| ----------------------------------------------------------------------- |
| [ Color-Coded Chart Legend ]                                            |
|   - Food: 40% (Red Accent)             - Rent: 30% (Blue Accent)       |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Charts must use stable, responsive aspects.
  * Legends are grouped symmetrically below charts.

### 9. Notes Editor
An annotation form for writing custom notes and tags for transaction records.

```
+-------------------------------------------------------------------------+
| [ App Bar: Notes Annotator ]                                            |
| ----------------------------------------------------------------------- |
| { Add Transaction Notes }                                               |
| [ Custom Notes Multi-line Text Area Input ]                             |
| ----------------------------------------------------------------------- |
| [ Add Custom Tag Chip Grid ]                                            |
| ----------------------------------------------------------------------- |
| [ Primary Save Notes Button ]          [ Secondary Cancel Button ]      |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Employs the Comfortable Density Profile.
  * Restricts inputs to a maximum character limit.

### 10. Settings
A settings index listing security preferences, backup tools, and diagnostics.

```
+-------------------------------------------------------------------------+
| [ App Bar: Settings ]                                                   |
| ----------------------------------------------------------------------- |
| { Security Preferences Group }                                          |
| - PIN Configuration Preference Row     [Chevron]                        |
| - Biometric Toggle Preference Row                                       |
| ----------------------------------------------------------------------- |
| { Data Management Group }                                               |
| - Backup & Restore Preference Row      [Chevron]                        |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Groups related options inside flat cards.
  * Displays tiny flow indicators on rows that navigate to sub-pages.

### 11. Security
Security preference panels for PIN setups, biometric configurations, and lock parameters.

```
+-------------------------------------------------------------------------+
| [ App Bar: Security Settings ]                                          |
| ----------------------------------------------------------------------- |
| [ Security Level Component: Balanced ]                                  |
| ----------------------------------------------------------------------- |
| - Update PIN Row                       [Chevron]                        |
| - Biometric Authentication Switch                                       |
| - Screen Lock Timeout Delay Row        [Chevron]                        |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Emphasizes whitespace and clear state indicators.
  * Automatically obscures active fields when backgrounded.

### 12. PIN Unlock
The secure gate screen prompting PIN entries or biometric triggers.

```
+-------------------------------------------------------------------------+
|                                                                         |
|                       [ Logo Asset: BankYar ]                           |
|                                                                         |
|                        { Enter Secure PIN }                             |
|                        [ *  *  *  * ] dots                              |
|                                                                         |
|                        [ Keypad Row: 1 2 3 ]                            |
|                        [ Keypad Row: 4 5 6 ]                            |
|                        [ Keypad Row: 7 8 9 ]                            |
|                        [ Keypad Row: C 0 [Del] ]                        |
|                                                                         |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Simple, centered numerical keyboard layout.
  * Instantly triggers biometric unlocks when the screen is mounted.

### 13. Backup
The database export wizard, prompting passphrase setups and file generations.

```
+-------------------------------------------------------------------------+
| [ App Bar: Database Backup Wizard ]                                     |
| ----------------------------------------------------------------------- |
| { Setup Encryption Passphrase }                                         |
| Enter a passphrase to encrypt your offline database file with AES-256.  |
| ----------------------------------------------------------------------- |
| [ Passphrase Text Field ]                                               |
| [ Confirm Passphrase Text Field ]                                       |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Export encrypted .bankyar backup file ]        |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Guides users step-by-step through backup procedures.
  * Explains clearly why the passphrase is required.

### 14. Restore
The database import page, verifying passphrases and writing local databases.

```
+-------------------------------------------------------------------------+
| [ App Bar: Database Restore Wizard ]                                    |
| ----------------------------------------------------------------------- |
| { Select Encrypted .bankyar Backup File }                               |
| [ Primary File Selector Button ]                                        |
| ----------------------------------------------------------------------- |
| { Enter Backup Passphrase }                                             |
| [ Passphrase Text Field ]                                               |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Restore and import database file ]             |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Displays file details and validation warnings before importing.
  * Overwrites local databases only upon successful verification.

### 15. About
An informational page detailing application license keys, versions, and security audits.

```
+-------------------------------------------------------------------------+
| [ App Bar: About BankYar ]                                              |
| ----------------------------------------------------------------------- |
| [ Logo Asset: BankYar Icon ]                                            |
| Version: 1.0.0 (Offline-First)                                          |
| ----------------------------------------------------------------------- |
| { Fully Secure & Audited }                                              |
| BankYar is a local-only financial analytics application with zero       |
| network access. All data remains encrypted on your device.              |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Structured as a clean reading layout.
  * Reinforces security principles and offline compliance.

### 16. Help
An interactive FAQ panel addressing search indices, categories, and regex builders.

```
+-------------------------------------------------------------------------+
| [ App Bar: Help Center ]                                                |
| ----------------------------------------------------------------------- |
| { Frequently Asked Questions }                                          |
| - How do I set up automatic parsing?   [Chevron]                        |
| - Where is my data stored?             [Chevron]                        |
| - How can I restore an encrypted backup? [Chevron]                      |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Linear lists of FAQ topics that expand when tapped.
  * Includes search capability to help users find answers quickly.

### 17. Permission Flow
Onboarding setup flows for granting permissions (such as SMS access).

```
+-------------------------------------------------------------------------+
| { Step 2 of 3: SMS Access Permission }                                  |
| ----------------------------------------------------------------------- |
| [ Large Keyhole Graphic ]                                               |
| ----------------------------------------------------------------------- |
| BankYar uses SMS access to read incoming banking alerts. Your private   |
| data remains secure on this device and never leaves your control.       |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Grant Access ]                                 |
| [ Secondary Action Button: Setup Manually ]                             |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Employs clean visuals to explain permissions clearly.
  * Provides manual alternatives if the permission is denied.

### 18. Future AI Insights
An analytical dashboard with spent recommendations and predictive diagnostics.

```
+-------------------------------------------------------------------------+
| [ ZONE A: App Bar: AI Insights ]                                        |
| ----------------------------------------------------------------------- |
| [ ZONE B: Spending Trend Advisory Card ]                                |
|   { Spending is projected to decrease by 5% this month }                |
| ----------------------------------------------------------------------- |
| [ Spent Recommendation Items List ]                                     |
|   - "Verify petrol costs"               | - "Verify grocery limits"     |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Displays high-contrast predictions at the top.
  * Organizes items cleanly inside flat cards.

### 19. Future Budget Module
Budget builders with limit setup fields and spent status bar widgets.

```
+-------------------------------------------------------------------------+
| [ App Bar: Budget Setup ]                                               |
| ----------------------------------------------------------------------- |
| { Food & Dining Limit Setup }                                           |
| [ Limit Amount Field ]                                                  |
| ----------------------------------------------------------------------- |
| [ Spend Status Progress Bar: 45% used ]                                 |
| ----------------------------------------------------------------------- |
| [ Primary Action Button: Save Budget ]                                  |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Reuses standard forms templates.
  * Uses clear visual progress bars to track spending.

### 20. Future Category Module
Categorization wizards with chip matrices and custom color picker cards.

```
+-------------------------------------------------------------------------+
| [ App Bar: Custom Categories ]                                          |
| ----------------------------------------------------------------------- |
| { Select Category Icon & Color }                                        |
| [ Horizontal Icon Chip Selector Track ]                                 |
| ----------------------------------------------------------------------- |
| [ Category Color Matrix Grid ]                                          |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Simple, flat grid designs.
  * Employs standard curvature and padding.

### 21. Future Notification Center
In-app alert histories tracking parsing heartbeats, security PIN expirations, and backups.

```
+-------------------------------------------------------------------------+
| [ App Bar: Notifications ]                                              |
| ----------------------------------------------------------------------- |
| - Item 1: Database backup recommended   - 2 hours ago [Icon: Info]     |
| - Item 2: Secure PIN updated successfully - 1 day ago [Icon: Success]   |
+-------------------------------------------------------------------------+
```

* **Composition Guidelines:**
  * Uses chronological list layouts.
  * Displays status icons to categorize notifications.

---
## CORE DESIGN RULES SUMMARY

### Screen Anatomy Matrix

| Screen Component | Interaction Category | Primary Page Zone | Safe Area Mapping |
| :--- | :--- | :--- | :--- |
| **Header (App Bar)** | Navigation/Secondary | Zone A | Top status bar inset |
| **Navigation Rail** | Primary Navigation | Zone C | Logical start margin |
| **Primary Content** | Primary Content | Zone B | Margins and gutters |
| **Secondary Content** | Contextual Info | Zone B | Margins and gutters |
| **Actions Row** | Secondary Actions | Zone A | Inset padding |
| **Status Indicators**| Feedback Micro-elements| Zone A / B | Symmetrical padding |
| **FAB** | Primary Action | Zone C | Bottom/Start offsets |
| **Bottom Action Bar**| Primary Actions | Zone C | Bottom gesture navigation inset |

### Information Hierarchy Rules

* **Primary Information (Balances, Core Amounts):** Displayed in large weights and display typography sizes in upper zones.
* **Supporting Information (Titles, Accounts):** Main reading typography sizes in central zones.
* **Metadata (Timestamps, Sub-IDs):** Medium weights and neutral color tokens, using monospace characters for numbers.
* **Financial Data (Amounts, Currency):** Anchored symmetrically, using Persian character symbols.
* **Actions (Triggers, Inputs):** Placed in bottom reach zones (Zone C).
* **Warnings (Alerts, Database Signature Mismatches):** High-contrast warning backgrounds inside cards.
* **Recommendations (AI Spent Advisories):** Flat surface cards using primary accent borders.
* **Contextual Information (Brief Microcopy):** Centered above or below target components using secondary text scales.

---
**End of Document**
