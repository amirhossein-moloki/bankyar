# BankYar Home Dashboard Screen Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, Senior UX Architect, Flutter UI Architect, Material Design 3 Expert, Financial Dashboard Specialist, Enterprise Design System Consultant
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Home Dashboard Screen is the absolute focal point of the application—serving as the primary user landing gateway, secure personal financial balance ledger, and tactical analytical command center. Under our uncompromising **offline-first, privacy-first, zero-network security bounds**, this screen is engineered to deliver immediate, local financial clarity to the user.

Facing incoming SMS alerts can evoke stress and anxiety; therefore, the Home Dashboard translates chaotic, unformatted carrier text streams into a structured, calming, and high-precision visual environment. Operating natively in **Persian (RTL)** and strictly complying with **Material Design 3 (MD3)** design system guidelines, this specification establishes an immutable blueprint. It defines the layout structures, component composition, state transitions, accessibility requirements, and interactive behaviors necessary before visual design or technical implementation begins.

---

## Screen Blueprint & Spatial Mapping

The Home Dashboard uses the standard three-zone vertical structural model. As an RTL-first application, the layout flow, reading lines, and horizontal transitions progress naturally from right (start) to left (end).

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY HEADER & DIAGNOSTICS]                                  |
|  +-------------------------------------------------------------------+  |
|  | [Diag Indicator]            [App Title Logo]      [Notification]  |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & FEED]                                  |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [1. Total Balance Card (Display Typography)]                     |  |
|  |     +1,240,000 Tomans                                             |  |
|  |                                                                   |  |
|  |  [2. Income & Expense Quick Summary Cards]                        |  |
|  |     Income: +2,500,000 Tomans   |   Expenses: -1,260,000 Tomans   |  |
|  |                                                                   |  |
|  |  [3. Active Filter Scroll Row]                                    |  |
|  |     [ All ]  [ Mellat Bank ]  [ Transport ]  [ Food ]             |  |
|  |                                                                   |  |
|  |  [4. Spend Analytics Chart Preview (Donut Segment)]               |  |
|  |                                                                   |  |
|  |  [5. Recent Transactions Feed / Chronological Ledger]             |  |
|  |     - Item 1: Snapp Taxi Ride            -15,000 Tomans           |  |
|  |     - Item 2: Salary Mellat Bank         +2,500,000 Tomans        |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY CONTROL, ACTION & NAVIGATION]                          |
|  +-------------------------------------------------------------------+  |
|  | [Floating Action Button: FAB] (Logical Bottom-Start / Lower Right) |  |
|  |                                                                   |  |
|  | [Persistent Bottom Navigation Bar]                                |  |
|  |   [Ledger]        [Analytics]          [Rules]        [Settings]  |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## Core Specification Deliverables

### 1. Screen Purpose
The primary purpose of the Home Dashboard Screen is to consolidate parsed offline financial data and present users with a clear, immediate view of their net worth, recent transactions, and spending distribution. By automating the extraction of incoming carrier SMS text structures and converting them into mathematical records, it serves as a secure vault that updates instantly without requiring manual bank integrations or external cloud connections.

### 2. Business Objectives
* **Promote User Retention:** Serve as a clean, highly functional financial hub, driving daily active engagement.
* **Guarantee Data Sovereignty:** Reinforce the brand's offline-only, privacy-first commitment, building deep trust.
* **Reduce Integration Overhead:** Rely on automated SMS parsing rather than complex, third-party banking APIs, minimizing operational maintenance.
* **Minimize Customer Support Loads:** Build intuitive interfaces with self-healing, clear error and permission states.

### 3. User Goals
* **Instant Financial Review:** View net balances and recent cash flows immediately upon opening the application.
* **Verify Incoming SMS Records:** Quickly review, correct, or tag automatically parsed transactions.
* **Track Spending Distributions:** Understand category expenses at a glance without navigating deep into sub-menus.
* **Ensure Operational Privacy:** Safely open the application in public environments without exposing private financial balances.

### 4. Entry Points
* **Application Initialization (Splash/Boot Gate):** Automatically loads the dashboard after checking local configurations and validating security contexts.
* **Security Unlock Page (PIN/Biometric Gate):** Navigates to the dashboard upon successful user verification.
* **Incoming SMS Notification Tap:** Launches the application directly to the dashboard, auto-scrolling to the newly parsed transaction ledger item.

### 5. Exit Points
* **Deep Feature Navigation:** Transitions to specialized full-screen detail and workspace modules (Analytics Dashboard, Rules Builder, Application Settings).
* **Security Lock-Out/Backgrounding:** Suspends execution and replaces active memory with visual mask sheets when the application transitions to the background.
* **System Termination:** Gracefully exits the application using secure memory scrub sequences.

### 6. Navigation Behaviour
* **Persistent Bottom Navigation Bar:** Provides flat, one-tap linear transitions across four primary sections: Ledger, Analytics, Rules, and Settings.
* **RTL-First Page Transitions:** Slides deep feature views (such as Transaction Inspector) from the logical start edge (right) to the logical end edge (left), maintaining natural reading patterns.
* **Bottom Sheet Overlays:** Standard menus (such as Category Selectors and Advanced Filters) expand upwards from the bottom of the viewport, maintaining reach within the ergonomic interaction zone.

### 7. Information Hierarchy
* **Primary Visual Tier (Net Balance):** Large, bold display typography positioned in Zone B, serving as the immediate visual focal point.
* **Secondary Visual Tier (Income/Expense Summaries, Active Filters):** Distinct, medium-weight container blocks immediately below the net balance.
* **Tertiary Visual Tier (Recent Ledger Feed, Donut Chart Segment):** Dense informational streams that users can scroll vertically.
* **Contextual Meta Tier (Timestamps, Transaction IDs):** Small, low-contrast typography using monospace layouts for numeric values.

### 8. Screen Layout Structure
* **Zone A (Header):** Pinned at the top of the viewport, housing the app logo, offline diagnostic badge, and notification triggers.
* **Zone B (Workspace):** A fully scrollable area containing the primary balance components, summary cards, spend charts, and transaction feeds.
* **Zone C (Controls):** Pinned to the bottom, containing the persistent navigation bar and the floating action button.
* **Symmetrical Outer Margins:** Bound strictly to the `bankyar.responsive.margin` token, preventing content from bleeding into physical screen borders.

### 9. Component Composition
The Home Dashboard is built by composing eight standardized design system elements:
* **Diagnostic App Bar Header**
* **Total Balance Display Card**
* **Inflow & Outflow Comparison Cards**
* **Active Filter Scrolling Chips Row**
* **Donut Analytics Chart Preview**
* **Chronological Transaction Ledger List**
* **Bottom-Start Floating Action Button**
* **Shell Bottom Navigation Bar**

### 10. Primary Actions
* **Manual Parsing / Custom Entry Trigger (FAB):** Positioned in Zone C within comfortable thumb reach. Initiates the manual SMS input flow or custom record generator.
* **Recent Transaction Validation:** Tapping any unverified card in the transaction list immediately launches the edit and confirm sheet.

### 11. Secondary Actions
* **Analytics Deep Dive:** Tapping the spend donut chart segues directly into the comprehensive Statistics Dashboard page.
* **Notification History Access:** Tapping the notification bell in the App Bar opens the in-app alert history log.

### 12. Contextual Actions
* **Active Filter Toggles:** Tapping active chips (such as bank accounts or transaction categories) dynamically filters the ledger list below.
* **Transaction Quick-View:** Tapping a verified ledger item displays a quick detail sheet with options to edit notes or change tags.

### 13. Transaction List Behaviour
* **Chronological Density:** Displays transaction records in descending chronological order, grouped by date sections.
* **Verification States:** Unverified transactions (heuristic-parsed SMS messages) are highlighted with a soft, distinct background border.
* **No Accidental Swipes:** Swiping actions inside the list are disabled to prevent accidental deletions or mutations while scrolling. All edits require deliberate taps.

### 14. Statistics Preview
* **Donut Spending Representation:** Displays spending distributions using a clean, flat donut chart. Segments are defined by high-contrast, low-saturation theme colors.
* **Monospace Legends:** Lists spending categories alongside percentage totals formatted with localized numbers.
* **Dynamic Sizing:** Constrains the chart to stable aspect ratios to prevent visual distortion on smaller screen viewports.

### 15. Search Behaviour
* **App Bar Search Trigger:** Tapping the search icon in Zone A smoothly expands the search input field.
* **Debounced Local Querying:** Debounces inputs by three hundred units before running queries against the local encrypted database.
* **Instant Input Clear:** Displays a clear icon on the logical end edge of the input field to quickly reset search terms.

### 16. Filter Behaviour
* **Horizontal Scrolling Filter Row:** Positioned immediately above the transaction feed, allowing users to scroll chips horizontally.
* **Visual State Feedback:** Selected chips are highlighted with active primary borders and background colors; unselected chips use subtle neutral borders.
* **Multi-Select Logic:** Supports toggling multiple filters concurrently (such as category and bank account), dynamically updating the list below.

### 17. Notification Entry
* **App Bar Bell Icon:** Positioned on the App Bar, displaying a small status dot if unread system messages exist (such as recommended backup intervals).
* **Semantic Badge Color:** Highlights alerts using the guarding amber scale to indicate warnings or the success green scale to indicate completed processes.

### 18. FAB Behaviour
* **RTL-First Bottom-Start Placement:** Positioned at the logical bottom-start edge of the viewport (the lower right on RTL screens), matching the natural ending reading point.
* **Scroll-Bound Visibility:** Scrolling down hides the FAB to maximize reading space; scrolling up reveals it instantly.
* **Touch-Target Compliance:** Ensures the interactive area meets minimum spatial touch target guidelines.

### 19. Empty State
* **Reassuring Narrative:** Displayed when no transaction records exist. It features an abstract, flat geometric graphic, supportive microcopy, and a prominent primary action button.
* **Explicit Privacy Reassurance:** The microcopy explicitly states: *"Your SMS logs never leave this device. We are waiting to detect your first incoming banking alert."*

### 20. Loading State
* **Layout-Preserving Skeletons:** Uses flat, shimmering skeleton outlines that match the exact shape and curvature of actual balance cards and transaction rows.
* **Non-Blocking Operation:** Avoids fullscreen blocking spinners, allowing users to browse cached data while background parsing tasks run.

### 21. Error State
* **Localized Context Warnings:** Displays errors using supportive, non-technical Persian text inside container cards highlighted with the alert crimson scale.
* **PII Redaction:** Strips raw SMS strings, encryption keys, and developer trace parameters from visible screens.

### 22. Offline State
* **Positive Status Display:** Since BankYar has zero network permissions, the "Offline" state represents normal system operations.
* **App Bar Diagnostic Indicator:** Displays a steady green icon with a local sync label, reinforcing to the user that their data is stored securely on the device.

### 23. Permission State
* **SMS Request Flow:** If SMS permissions are missing on boot, the dashboard is replaced with a clear explanation page.
* **Non-Coercive Choices:** Provides a primary button to grant system access and a secondary button to set up accounts manually, maintaining user choice.

### 24. Refresh Behaviour
* **Manual Refresh Gesture (Swipe-to-Refresh):** Triggers a rescan of the local SMS inbox when users swipe down on the ledger list.
* **Subtle Visual Feedback:** Uses a thin, linear progress bar under the App Bar instead of an intrusive, blocking loading wheel.

### 25. Animation Guidelines
* **Immediate Response Time:** Visual feedback triggers immediately upon user touches, with transitions completing under standard performance budgets.
* **Decelerated Ease Curves:** Ensures transitions start immediately and settle smoothly into their final positions.
* **Spatial Continuity:** Components expand and move from their physical touch origins to maintain spatial orientation.

### 26. Accessibility Behaviour
* **WCAG AA Compliance:** All body text and icons maintain a minimum contrast ratio of 4.5:1 against active backgrounds.
* **Dynamic Scale Adaptability:** Layout cards and text fields expand vertically to prevent text clipping under high system font-sizes.
* **Logical Screen Reader Sequencing:** screen reader focus progresses predictably from top-to-bottom and right-to-left.

### 27. RTL Behaviour
* **Logical Layout Mirroring:** Alignments, margins, and layouts use logical start/end parameters instead of physical left/right coordinates.
* **Icon Mirroring:** Directional assets (such as back chevrons and forward arrows) mirror automatically when switching locales.
* **Persian Font Baselines:** Optimizes vertical line-heights to support Persian character curves and prevent line overlaps.

### 28. Theme Behaviour
* **Consistent Visual Token Mapping:** Swapping between Light, Dark, or High-Contrast themes automatically re-maps design tokens without changing screen structures.
* **No Hardcoded Visual Parameters:** Eliminates inline hex colors or coordinates, relying strictly on resolved theme-specific tokens.

### 29. Security Behaviour
* **Active Window Obscurity:** Automatically displays a flat, branded mask sheet over the dashboard when the application transitions to the background multitasking task-switcher.
* **Plaintext Caching Prevention:** Financial balances and decrypted SMS buffers are scrubbed from active memory as soon as parsing completes.

### 30. Performance Expectations
* **Stable Frame Rates:** Renders interactions smoothly, maintaining consistent frame rates on standard Android devices.
* **Fast Query Execution:** Ensures local database queries and SMS parsing complete quickly to prevent UI thread lag.

### 31. Future Expansion Hooks
* **Budget Tracking Module:** Built-in spatial hooks immediately below the balance cards to support future budget progress indicators.
* **AI Financial Advisory Panel:** Reserved content slots inside the scrollable workspace to support future on-device advisory tips.

### 32. Validation Checklist
* **Strict Token Validation:** Confirms that every color, spacing margin, border, and corner curve maps directly to an active design token.
* **Accessibility and RTL Auditing:** Verifies layout readability and right-to-left alignments across all target device sizes.

### 33. Governance Rules
* **No Arbitrary Sizes:** Hardcoded offsets and paddings are prohibited; all dimensions must reference active design system tokens.
* **Semantic Color Integrity:** Visual properties must match active semantic tokens, preserving layout clarity and consistency.

---

## Screen Regions Definition

The Home Dashboard Screen is divided into distinct, structured functional regions. Each region serves a specific purpose, manages distinct user interactions, and adapts dynamically to system states:

```
+------------------------------------------------------------+
|  Region 1: Header and Diagnostics (Zone A - Pinned)       |
+------------------------------------------------------------+
|  Region 2: Primary Balance Workspace (Zone B - Scrollable) |
+------------------------------------------------------------+
|  Region 3: Interactive Filter Row (Zone B - Sticky)        |
+------------------------------------------------------------+
|  Region 4: Analytical Summary Workspace (Zone B - Scrollable)|
+------------------------------------------------------------+
|  Region 5: Chronological Ledger Workspace (Zone B - Scrollable)|
+------------------------------------------------------------+
|  Region 6: Bottom Action & Control (Zone C - Pinned)       |
+------------------------------------------------------------+
```

### 1. Header and Diagnostics Region (Zone A)
* **Visual Presentation:** A clean, flat bar pinned to the top of the viewport. It features a transparent base that reveals a subtle border line when content scrolls underneath.
* **Information Density:** Pinned elements are positioned at comfortable distances to prevent overlap, prioritizing high visibility for system-status indicators.
* **Horizontal Flow (RTL):** The brand logo sits at the center. The offline diagnostic badge sits on the logical end edge (left), while the search trigger and notification bell sit on the logical start edge (right).

### 2. Primary Balance Workspace Region (Zone B)
* **Visual Presentation:** Positioned at the top of the scrollable content area. It groups the primary balance displays inside flat, low-contrast container cards.
* **Information Density:** Employs the comfortable density profile, using generous spacing tokens to draw immediate focus to net cash totals.
* **Horizontal Flow (RTL):** Cash flows and account metrics are grouped logically inside cards, aligned with the right margin.

### 3. Interactive Filter Row Region (Zone B - Sticky)
* **Visual Presentation:** A sticky horizontal bar positioned immediately below the balance workspace. It displays a scrollable row of rounded filter chips.
* **Information Density:** Employs the compact density profile, maximizing horizontal scanning efficiency while maintaining comfortable touch targets.
* **Horizontal Flow (RTL):** Chips scroll horizontally from right to left, with the "All" filter chip selected by default.

### 4. Analytical Summary Workspace Region (Zone B)
* **Visual Presentation:** Displays spending distributions and cash flow trends using clean, flat charts grouped inside standard surface cards.
* **Information Density:** Groups charts and monospace legends symmetrically to ensure data is clear and readable.
* **Horizontal Flow (RTL):** Legends are positioned to the logical start edge of the chart segments, providing a natural reading flow.

### 5. Chronological Ledger Workspace Region (Zone B)
* **Visual Presentation:** A dense, vertically scrollable feed of transactions grouped by date sections.
* **Information Density:** Employs the compact density profile, using thin hairline dividers to separate rows and maximize visible list items.
* **Horizontal Flow (RTL):** Transaction details are organized cleanly: merchant names and timestamps align to the right (start), while localized amounts and category chips align to the left (end).

### 6. Bottom Action & Control Region (Zone C)
* **Visual Presentation:** A pinned bar at the bottom of the viewport, housing the persistent bottom navigation tabs and the primary floating action button.
* **Information Density:** Employs comfortable spacing tokens and gesture buffers to prevent touch conflicts with native system navigation.
* **Horizontal Flow (RTL):** Navigation items are distributed evenly, while the FAB is positioned at the logical bottom-start edge (lower right), matching the natural ending point of RTL reading.

---

## Detailed Component Specifications

### 1. Diagnostic App Bar Header
* **Purpose:** Defines screen context, displays system statuses, and provides access to notifications.
* **Position:** Zone A (Pinned).
* **Priority:** Primary (High Visibility).
* **Interactions:**
  * Tapping the search icon smoothly expands the search overlay.
  * Tapping the notification bell opens the Alert History Sheet.
  * Tapping the diagnostic badge displays a local database status popup.
* **Dependencies:** Relies on the security and database state managers.
* **Accessibility:** Uses clear semantic labels for screen readers (e.g., *"System Status: Securely Offline"*).
* **Animation:** Fades status indicators smoothly as system states change.
* **Loading:** Displays a thin, linear progress bar under the App Bar during background database rescans.
* **Errors:** Replaces the diagnostic badge with a flashing warning icon when database decryption fails.
* **Offline Behaviour:** Displays the green secure badge, reinforcing the offline-first design.
* **Future Extension:** Reserved slots to support future multi-language locale switchers.

### 2. Total Balance Display Card
* **Purpose:** Displays the user's total net balance in large, clear display typography.
* **Position:** Zone B (Scrollable).
* **Priority:** Critical (Primary Focus).
* **Interactions:**
  * Tapping the balance card toggles visual masking, allowing users to obscure sensitive figures in public environments.
* **Dependencies:** Relies on the local transaction database.
* **Accessibility:** Announces totals clearly (e.g., *"Total Net Balance: +1,240,000 Tomans"*).
* **Animation:** Animates number transitions smoothly using clean ease curves when balances update.
* **Loading:** Displays a shimmering, rounded skeleton card matching the exact shape of the balance card.
* **Errors:** Displays a generic warning message inside the card if local decryption fails.
* **Offline Behaviour:** Updates instantly using local data, with zero network dependencies.
* **Future Extension:** Reserved spaces to support multi-account balance switchers.

### 3. Inflow & Outflow Comparison Cards
* **Purpose:** Displays quick summaries of monthly income and expenses next to each other.
* **Position:** Zone B (Scrollable).
* **Priority:** Secondary (Supporting Info).
* **Interactions:**
  * Tapping cards filters the main ledger feed by income or expense transactions.
* **Dependencies:** Relies on the local ledger database.
* **Accessibility:** Uses distinct math symbols next to localized figures (e.g., *"+2,500,000" / "-1,260,000"*).
* **Animation:** Updates figures with quick, clean transitions during state refreshes.
* **Loading:** Displays shimmering, proportional skeleton blocks.
* **Errors:** Displays soft, red warning boundaries if calculations fail.
* **Offline Behaviour:** Resolves calculations instantly on-device.
* **Future Extension:** Reserved slots to support comparisons with prior monthly averages.

### 4. Spend Analytics Chart Preview
* **Purpose:** Displays spending distributions using a clean, flat donut chart.
* **Position:** Zone B (Scrollable).
* **Priority:** Secondary (Supporting Info).
* **Interactions:**
  * Tapping individual chart segments dynamically filters the ledger list below by category.
  * Tapping the center of the chart navigates to the detailed Statistics Dashboard page.
* **Dependencies:** Relies on the spend analytics category database.
* **Accessibility:** Announces segment distributions clearly for screen readers (e.g., *"Food Category: 40% of monthly spending"*).
* **Animation:** Animates chart segment expansions using smooth, decelerated ease curves.
* **Loading:** Displays a circular, shimmering donut skeleton.
* **Errors:** Displays a flat, neutral warning circle if category calculations are missing.
* **Offline Behaviour:** Updates instantly using on-device analytical structures.
* **Future Extension:** Reserved slots to support future monthly cash flow trend comparisons.

### 5. Quick Actions Panel
* **Purpose:** Provides rapid access to core manual utilities (such as manual SMS parsing and custom rules).
* **Position:** Zone B (Scrollable).
* **Priority:** Secondary (Supporting Info).
* **Interactions:**
  * Tapping the parse utility opens the SMS Parsing Wizard Sheet.
  * Tapping the rules utility navigates directly to the Custom Rules Builder page.
* **Dependencies:** None.
* **Accessibility:** Ensures interactive buttons have sufficient touch target areas.
* **Animation:** Highlights buttons with quick, tactile visual responses upon user taps.
* **Loading:** Rendered instantly; does not require loading indicators.
* **Errors:** Handled at the modal sheet level; the panel remains active.
* **Offline Behaviour:** Operates completely offline, using local configuration files.
* **Future Extension:** Supports adding custom, user-defined quick action shortcuts.

### 6. Recent Transactions Feed
* **Purpose:** Displays a chronological ledger of parsed transaction records.
* **Position:** Zone B (Scrollable).
* **Priority:** Primary (High Interest).
* **Interactions:**
  * Tapping unverified records opens the Quick Verification Sheet.
  * Tapping verified records displays transaction details and notes.
* **Dependencies:** Relies on the SMS parsing engine and ledger database.
* **Accessibility:** Announces transaction lines clearly (e.g., *"Transaction: Snapp Ride, -15,000 Tomans, Transport Category"*).
* **Animation:** Animates new list entries using clean, vertical slide transitions.
* **Loading:** Displays rows of shimmering rectangular skeletons.
* **Errors:** Displays inline warnings if records are corrupted or incomplete.
* **Offline Behaviour:** Operates completely offline, retrieving records from the secure local database.
* **Future Extension:** Reserved slots to support adding multi-select actions for bulk categorization.

### 7. Interactive Filter Area
* **Purpose:** Allows users to filter the chronological transaction feed quickly.
* **Position:** Zone B (Sticky Row).
* **Priority:** Primary (High Interaction).
* **Interactions:**
  * Tapping chips toggles active filter states, updating the transaction feed instantly.
  * Swipe gestures scroll chips horizontally.
* **Dependencies:** Relies on category indexes and account lists.
* **Accessibility:** Uses clear accessibility traits to indicate if a chip is selected.
* **Animation:** Slides chip highlights smoothly when active states toggle.
* **Loading:** Displays shimmering chip skeleton rows.
* **Errors:** Reverts to the "All" filter chip if category lookups fail.
* **Offline Behaviour:** Resolves filter states instantly on-device.
* **Future Extension:** Reserved slots to support saving custom, user-defined filter presets.

### 8. Primary Floating Action Button (FAB)
* **Purpose:** Provides a prominent, one-tap trigger to manually add custom transaction entries.
* **Position:** Zone C (Floating / Bottom-Start).
* **Priority:** Critical (Primary Action).
* **Interactions:**
  * Tapping the FAB opens the Manual Transaction Entry modal sheet.
* **Dependencies:** None.
* **Accessibility:** Uses clear semantic labels for screen readers (e.g., *"Create Custom Transaction Record"*).
* **Animation:** Automatically scales down and hides during rapid down-scrolls, sliding back smoothly when scrolling stops.
* **Loading:** Rendered instantly; does not require loading indicators.
* **Errors:** Handled at the modal sheet level.
* **Offline Behaviour:** Operates completely offline, with zero network dependencies.
* **Future Extension:** Supports expanding into a small speed-dial menu for quick category entries.

### 9. Shell Bottom Navigation Bar
* **Purpose:** Houses persistent navigation tabs for high-level application routes.
* **Position:** Zone C (Pinned).
* **Priority:** Critical (Primary Navigation).
* **Interactions:**
  * Tapping tabs switches high-level screens instantly.
* **Dependencies:** None.
* **Accessibility:** Announces active navigation states clearly (e.g., *"Navigation: Ledger Tab Selected, Row 1 of 4"*).
* **Animation:** Fades active state indicators smoothly when transitioning between tabs.
* **Loading:** Persistent and always visible; does not require loading states.
* **Errors:** Disabled options are highlighted with low-contrast, muted tones.
* **Offline Behaviour:** Operates completely offline, using local application configurations.
* **Future Extension:** Supports adding custom badge counters for notifications or rule alerts.

---

## Technical Integration & State Matrices

### Interaction Matrix

| UI Component | User Action | Target Component | State Mutation | Expected Transition |
| :--- | :--- | :--- | :--- | :--- |
| **Balance Display Card** | Single Tap | Net Balance Figure | Toggles visual masking (`Active` <-> `Obscured`) | Instantly blurs or reveals numbers. |
| **Notification Bell** | Single Tap | Notification Panel | Launches Notification overlay sheet | Slides sheet vertically up from Zone C. |
| **Filter Chip** | Single Tap | Transaction Feed | Updates active filter list | Refreshes feed items instantly. |
| **Ledger Item Card** | Single Tap | Details Panel | Opens Transaction Details modal sheet | Slides detail sheet vertically up from Zone C. |
| **Unverified Card** | Single Tap | Verification Sheet | Launches Verification wizard modal | Slides verification sheet vertically up from Zone C. |
| **FAB Button** | Single Tap | Custom Entry Form | Opens Custom Transaction modal sheet | Slides entry form vertically up from Zone C. |
| **Chart Segment** | Single Tap | Transaction Feed | Filters list by selected segment category | Updates feed list smoothly. |
| **Bottom Tab Item** | Single Tap | Navigation Shell | Switches active application screen | Fades active tab highlights smoothly. |

### State Matrix

| System State | App Bar Header | Balance Card | Ledger List | FAB Button | Bottom Sheet |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Uninitialized** | Displays Splash | Obscured | Hidden | Hidden | Disabled |
| **Loading** | Shimmer | Shimmer Card | Shimmer Rows | Hidden | Disabled |
| **Empty** | Active Logo | Zero Balance | Empty Screen Narrative | Active | Enabled |
| **Active/Normal** | Green Badge | Active Figure | Chronological Feed | Active | Enabled |
| **Filtered** | Active Logo | Active Figure | Filtered List Feed | Active | Enabled |
| **Backgrounded** | Mask Overlay | Mask Overlay | Mask Overlay | Hidden | Dismissed |
| **Decryption Error** | Crimson Badge | Locked Warning | Locked Warning | Disabled | Dismissed |
| **Biometric Lock** | Mask Overlay | Mask Overlay | Mask Overlay | Hidden | Dismissed |

### Accessibility Matrix

| UI Component | Accessibility Trait | Screen Reader Announcement | Touch Target Offset | Keyboard Navigation Focus Sequence |
| :--- | :--- | :--- | :--- | :--- |
| **Diagnostic App Bar**| Header Status | *"System Status: Securely Offline"* | Standard Insets | Step 1 (Start-to-End) |
| **Balance Card** | Toggle Action | *"Total Net Balance: +1,240,000 Tomans. Tap to toggle visibility."*| Large Area | Step 2 (Top-to-Bottom) |
| **Filter Chips** | Scroll Bar | *"Filter by: [Category Name], [Active State]"* | Standard Chips | Step 3 (Right-to-Left) |
| **Spend Donut Chart**| Chart Graphic | *"Spending Distribution Donut Chart. Tap to view Statistics."* | Large Area | Step 4 (Top-to-Bottom) |
| **Ledger Item Card** | List Item | *"Transaction: Snapp Ride, -15,000 Tomans, Transport Category."*| Row Height | Step 5 (Top-to-Bottom) |
| **FAB Button** | Action Trigger | *"Create Custom Transaction Record"*| Comfort Circle | Step 6 (Bottom-Start Focus) |
| **Bottom Navigation** | Navigation Bar | *"Bottom Navigation Tab: [Tab Name], Selected."*| High Comfort | Step 7 (Right-to-Left) |

---

## Design Token Matrix

To guarantee strict visual compliance across both light and dark themes without hardcoding values, the Home Dashboard uses the following design system tokens:

```
+--------------------------------------------------------------------------+
|                       CORE DESIGN TOKENS MATRIX                          |
+---------------------+----------------------------------------------------+
| Visual Element      | Design Token Key                                   |
+---------------------+----------------------------------------------------+
| Screen Background   | `bankyar.semantic.color.background.default`        |
| Card Surface        | `bankyar.semantic.color.surface.default`           |
| High Contrast Text  | `bankyar.semantic.color.text.primary`              |
| Supporting Text     | `bankyar.semantic.color.text.secondary`            |
| Divider Lines       | `bankyar.semantic.color.border.subtle`             |
| Balance Header Font | `bankyar.semantic.typography.display.lg`           |
| Ledger Title Font   | `bankyar.semantic.typography.title.sm`             |
| Outer Edge Margin   | `bankyar.responsive.margin`                        |
| Card Border Radius  | `bankyar.radius.medium`                            |
| Interaction Target  | `bankyar.space.xl` (Minimum Touch Target)          |
+---------------------+----------------------------------------------------+
```

---

## Validation Checklist

Before initiating visual design or technical implementation of the Home Dashboard, this specification must pass all validation checks:

- [ ] **No Hardcoded Hex Colors:** Confirms that every color property maps directly to an active semantic design token.
- [ ] **No Physical Dimensions:** Confirms that spacing, margins, and border widths use relative tokens rather than physical pixel values.
- [ ] **No Flutter Framework Code:** Confirms that the document remains platform-independent and free of direct Flutter code structures.
- [ ] **RTL-First Compliance:** Confirms that alignments, flows, and page transitions are mapped to logical start/end parameters.
- [ ] **Complete State Coverage:** Confirms that loading, empty, and error states are clearly defined and accounted for.
- [ ] **Security and Privacy Audited:** Confirms that sensitive financial totals and transaction records are masked when the app is backgrounded.
- [ ] **Accessibility and WCAG Audited:** Confirms that text elements, touch targets, and focus sequences comply with WCAG AA guidelines.

---

## Governance Rules

To prevent "visual debt" and maintain long-term design consistency, all modifications to this specification must comply with these governance rules:

1. **Tokens as the Single Source of Truth:** Every visual property must map to an active design token; manual style adjustments inside screens are prohibited.
2. **Deterministic Layout Structure:** New additions must follow the standard three-zone vertical model (Header, Workspace, Controls) to maintain spatial stability.
3. **Immutability of Released Elements:** Established dashboard components represent a shared contract and cannot be modified without formal design system guild approval.
4. **Zero Network Dependencies:** All assets, fonts, and icons must be packaged locally; external CDN links or cloud services are strictly prohibited.

---

## Future Expansion hooks

The Home Dashboard is designed to scale gracefully as new features are introduced in future releases:

* **Budget Tracking Module Integration:** Pre-allocated spacing immediately below the balance cards to support future budget progress indicators.
* **On-Device AI Recommendation Panel:** Reserved content slots inside the scrollable workspace to support future on-device financial advisory tips.
* **Multi-Account Balance Swiping:** Architectural hooks supporting horizontal swipe gestures on the balance card to view individual bank balances.
* **Multi-Language Adaptability:** Decoupled design tokens and logical spacing alignments, ensuring seamless future support for English (LTR) layouts.

---
**End of Document**
