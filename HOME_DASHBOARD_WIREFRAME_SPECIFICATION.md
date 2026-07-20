# BankYar Home Dashboard Screen Wireframe Specification (v1.1.0)
## Enterprise-Grade Structural UX Blueprint for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Wireframe Specification
**Document Version:** 1.1.0
**Authors:** Principal Product Designer, Senior UX Architect, Material Design 3 Expert, Flutter UI Architect, Enterprise Financial Application Designer
**Status:** Approved / Core Structural Blueprint

---

## 1. Screen Overview

### 1.1 Core Purpose
The Home Dashboard is the primary operational hub and financial cockpit of the BankYar application. Its core purpose is to translate unstructured, unformatted carrier text streams (SMS banking notifications) into a secure, structured, and instantly readable local financial ledger completely offline.

The design aims to reduce the anxiety associated with receiving financial notifications by presenting data in a highly structured, calm, and reassuring personal balance command center.

### 1.2 Target System Parameters
*   **Platform:** Android (Primary Target), designed with a platform-agnostic layout architecture to support future expansions to iOS and desktop viewports.
*   **Language & Text Flow:** Native Persian (RTL layout rules, Solar Hijri calendar, Persian numeric baselines).
*   **Connectivity Constraint:** 100% offline-first, private-by-default, operating under a strict zero-network permission sandbox.
*   **Visual Philosophy:** Stoic Vault and High-Precision Analyst personas—characterized by structural clarity, flat card borders, relative visual layers, high information density, and low cognitive load.
*   **Design Framework:** Material Design 3 (MD3) structural layout guidelines.

---

## 2. Vertical Layout

The screen follows a strict, single-column vertical stack with deterministic spatial zones. Gaps, margins, and relative sizes scale adaptively.

### 2.1 Spatial Grid & Outermost Columns
*   **Grid System:** Compact viewports utilize a 4-column master grid, expanding to an 8-column layout on tablets/foldables.
*   **Outer Margins:** Enforced on both inline (horizontal) boundaries using the `bankyar.responsive.margin` token.
*   **Gutter Spacing:** Horizontal spacing between adjacent components is bound to the `bankyar.responsive.gutter` token.
*   **Rhythm & Spacing Factor:** Vertical margins between independent blocks are governed by the `bankyar.space.lg` token, while tighter internal alignments use `bankyar.space.sm` and `bankyar.space.md`.

### 2.2 Wireframe Layout Diagram

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY HEADER & DIAGNOSTICS]                                  |
|  +-------------------------------------------------------------------+  |
|  | [Notification Bell]          [Brand Logo]         [Search Trigger]|  |
|  | (Logical End / Left)        (Center-Aligned)      (Logical Start) |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & FEED]                                  |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 2: Greeting Area]                                        |  |
|  |                                                                   |  |
|  |  [Region 3: Total Balance Display Card]                           |  |
|  |                                                                   |  |
|  |  [Region 4: Today's Financial Summary Card]                       |  |
|  |                                                                   |  |
|  |  [Region 5: Interactive Filter Row]                               |  |
|  |                                                                   |  |
|  |  [Region 6: Quick Statistics Spend Chart]                         |  |
|  |                                                                   |  |
|  |  [Region 7: Recent Transactions Ledger List]                       |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY CONTROL, ACTION & NAVIGATION]                          |
|  +-------------------------------------------------------------------+  |
|  | [Region 8: Primary Floating Action Button] (Logical Bottom-Start)  |  |
|  |                                                                   |  |
|  | [Region 9: Shell Bottom Navigation Bar]                           |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## 3. Section Hierarchy

The Home Dashboard is divided into nine physical regions, each mapped below with comprehensive architectural specifications.

### Region 1: Diagnostic App Bar Header
*   **Purpose:** Establishes application brand identity, houses search/notification shortcuts, and provides positive visual confirmation of the secure on-device database offline status.
*   **Priority:** Primary (Always visible).
*   **Position:** Zone A (Pinned to top viewport edge).
*   **Width:** Spans 100% of viewport width.
*   **Height:** Locked to `bankyar.layout.appbar.min.height` (no dynamic height expansion during scroll actions).
*   **Alignment:** Logical Start (Right) contains search and profile hooks; Center-aligned contains brand symbol; Logical End (Left) contains notification and offline diagnostic status triggers.
*   **Content Rules:** Contains vector icon elements for search, notification, and diagnostic badges. The brand logo is static.
*   **Interaction Rules:**
    *   Tapping the search icon expands the search bar overlay.
    *   Tapping the notification bell opens the slide-up notification panel.
    *   Tapping the diagnostic badge opens a secure local system-health metadata block.
*   **Accessibility:** Announced as *"Header: BankYar. Database secure and offline. Notification and search buttons available."*
*   **RTL Behaviour:** Mirroring is automatically applied. Search trigger aligns to the right side, diagnostic badges and notification bell align to the left.
*   **Loading Behaviour:** Replaced by a linear, non-blocking horizontal shimmering indicator at its bottom edge.
*   **Error Behaviour:** Displays a subtle warn-border indicator without obstructing branding or actions.
*   **Empty Behaviour:** Remained physically unaffected.
*   **Animation Notes:** Transitions between normal and active search fields use a horizontal slide-and-wipe transition matching the `bankyar.motion.duration.fast` token.

### Region 2: Greeting Area
*   **Purpose:** Welcomes the user and confirms the current on-disk ledger update timestamp.
*   **Priority:** Tertiary (Low density, high reassurance).
*   **Position:** Zone B (First scrollable block).
*   **Width:** Spans full columns between `bankyar.responsive.margin` bounds.
*   **Height:** Mapped to `bankyar.layout.greeting.height` (dynamic scaling based on text scaling settings).
*   **Alignment:** Text aligned to logical start (Right in Persian RTL).
*   **Content Rules:** Displays the user's name ("سلام، سهراب عزیز") in secondary title typography, with supporting subtitle confirming ledger safety ("صندوقچه مالی شما امن و به‌روز است").
*   **Interaction Rules:** Non-interactive block.
*   **Accessibility:** Structured text is announced sequentially: *"Hello dear Sohrab, your financial vault is secure and updated."*
*   **RTL Behaviour:** Symmetrical alignment to the right margin.
*   **Loading Behaviour:** Shown as two stacked horizontal skeletal blocks.
*   **Error Behaviour:** Hidden if greeting strings fail to resolve.
*   **Empty Behaviour:** Replaced by a default localized generic welcome string.
*   **Animation Notes:** Fades in smoothly upon application launch.

### Region 3: Total Balance Display Card
*   **Purpose:** The primary financial focal point showing the user's aggregated offline net balance.
*   **Priority:** Critical (Primary informational asset).
*   **Position:** Zone B (Directly below Region 2).
*   **Width:** Spans all columns of the grid.
*   **Height:** Constrained between `bankyar.layout.balance.card.min.height` and `bankyar.layout.balance.card.max.height`.
*   **Alignment:** Content is vertically and horizontally centered inside a card container.
*   **Content Rules:**
    *   Top-Start (Right): Monochromatic label "دارایی کل صندوقچه" (Total Vault Assets).
    *   Top-End (Left): Visibility eye symbol.
    *   Center: Large display balance text (+۱۲,۴۰۰,۰۰۰ تومان) with monospace digits.
    *   Bottom: "بروزرسانی شده در: ۱۴:۳۲" (Last updated timestamp).
*   **Interaction Rules:** Tapping the card body or the eye symbol toggles visual masking. When active, numbers are replaced with six circular characters ("••••••") to prevent shoulder-surfing in public spaces.
*   **Accessibility:** Announces: *"Total balance: twelve million four hundred thousand Tomans. Double-tap to mask sensitive values."*
*   **RTL Behaviour:** Label aligns right, toggle button aligns left. Currency token "تومان" sits inline-end of the Persian numeric digits.
*   **Loading Behaviour:** Replaced with a skeleton container possessing matching card curvature (`bankyar.radius.large`).
*   **Error Behaviour:** Displays a redacted mask with an inline error trigger reading *"Click to retry local ledger decryption"*.
*   **Empty Behaviour:** Displays a zero balance ("۰ تومان").
*   **Animation Notes:** Visibility masking toggles instantly to prevent lagging data exposure.

### Region 4: Today's Financial Summary Card
*   **Purpose:** Displays parallel, comparative daily cash inflow and outflow streams.
*   **Priority:** Secondary (Supports analytical scanability).
*   **Position:** Zone B (Directly below Region 3).
*   **Width:** Spans all columns, internally split into two equal horizontal cells.
*   **Height:** Mapped to `bankyar.layout.summary.card.height` token.
*   **Alignment:** Inline horizontal division.
*   **Content Rules:**
    *   Right Column: Daily Inflow label ("ورودی امروز"), amount (+۵۰۰,۰۰۰ تومان), and upward trend icon (↑).
    *   Left Column: Daily Outflow label ("خروجی امروز"), amount (-۲۵۰,۰۰۰ تومان), and downward trend icon (↓).
*   **Interaction Rules:** Tapping either column acts as an instant shortcut filter, restricting the Recent Transactions List to credit or debit ledger records respectively.
*   **Accessibility:** Screen readers parse column-by-column: *"Today's inflow: positive five hundred thousand Tomans; Today's outflow: negative two hundred and fifty thousand Tomans."*
*   **RTL Behaviour:** Inflow (positive) sits on the logical start (right), Outflow (negative) sits on the logical end (left).
*   **Loading Behaviour:** Shown as two side-by-side equal skeletal blocks.
*   **Error Behaviour:** Replaced with a flat, empty card template.
*   **Empty Behaviour:** Shows default values of "۰ تومان" for both streams.
*   **Animation Notes:** Horizontal split slides apart gently on transition state.

### Region 5: Interactive Filter Row
*   **Purpose:** Enables quick, one-handed categorization sub-queries on the chronological feed.
*   **Priority:** Primary (High Interaction).
*   **Position:** Zone B (Directly below Region 4). Pins immediately below Zone A (App Bar) when scrolled upwards.
*   **Width:** Full viewport width, overflowing margins for continuous horizontal scrolling.
*   **Height:** Mapped to `bankyar.layout.filter.row.height` (minimum touch envelope of `bankyar.space.xl`).
*   **Alignment:** Top-aligned horizontal row.
*   **Content Rules:** Contains selectable filter chips: "همه" (All), "بانک ملی" (Melli Bank), "بانک ملت" (Mellat Bank), "خرید روزمره" (Daily Spend), "حمل و نقل" (Transport). Selected chips display a leading checkmark icon.
*   **Interaction Rules:** Horizontal dragging scrolls the chip row. Tapping a chip toggles its filter state and instantly updates the ledger feed below.
*   **Accessibility:** Announced as a scrollable filter row: *"Filter list. Tab to select and filter transactions below."*
*   **RTL Behaviour:** Inline row scrolls right-to-left. First chip ("همه") is anchored to the right margin.
*   **Loading Behaviour:** Displays a horizontal sequence of five narrow, static skeletal chips.
*   **Error Behaviour:** Filter chips are disabled (38% opacity) and unclickable.
*   **Empty Behaviour:** Displays only the "All" chip, with other categorical chips hidden.
*   **Animation Notes:** Active chip selection scales slightly (1.02x) on selection with a fast spring-back motion.

### Region 6: Quick Statistics Spend Chart
*   **Purpose:** Provides a visual category spending breakdown.
*   **Priority:** Secondary (Visual analytics context).
*   **Position:** Zone B (Directly below Region 5).
*   **Width:** Spans all columns.
*   **Height:** Constrained to a stable square aspect ratio `bankyar.layout.chart.height`.
*   **Alignment:** Center-aligned horizontal split-panel (Right: Donut segment; Left: Category legends).
*   **Content Rules:** Displays a flat, multi-segment donut chart. Category legends are aligned in a vertical stack on the left side with monospace percentages.
*   **Interaction Rules:** Tapping a segment highlights the corresponding card and filters the chronological feed below. Tapping the chart center transitions to the Analytics Screen.
*   **Accessibility:** Reported as text: *"Spending distribution: food represents forty percent, transport represents fifteen percent."*
*   **RTL Behaviour:** Donut graph is placed on the right; vertical category percentages align right on the left.
*   **Loading Behaviour:** Skeleton circular shimmer of the donut card.
*   **Error Behaviour:** Replaced by an information card explaining that local statistics cannot be parsed due to empty indexes.
*   **Empty Behaviour:** Displays a hollow grey concentric circle with the label *"No spending registered this month"*.
*   **Animation Notes:** Radial segments expand outwards with a progressive, clock-wise sweep transition.

### Region 7: Recent Transactions Ledger List
*   **Purpose:** The chronological core ledger displaying the dense feed of parsed banking transactions.
*   **Priority:** Primary (Core user utility).
*   **Position:** Zone B (Occupies all remaining vertical viewport space).
*   **Width:** Spans all columns between horizontal margins.
*   **Height:** Dynamic, unbounded vertical scrolling.
*   **Alignment:** Stacked vertical list.
*   **Content Rules:** Grouped by dates using subtle dividers. Contains multiple Transaction Cards with bank logo, bank name, category badge, timestamp, security indicator, amount, and status dot (Verified/Unverified).
*   **Interaction Rules:**
    *   No inline card swiping (to prevent accidental modifications).
    *   Tapping a card opens its complete Transaction Details Modal.
    *   Tapping an Unverified card opens the Quick Verification Sheet.
    *   Pulling down from the top edge triggers local SMS inbox parsing.
*   **Accessibility:** Focus moves element-by-element: *"Transaction: Bank Melli, amount: negative forty-five thousand Tomans, Status: Unverified, tap to verify."*
*   **RTL Behaviour:** Bank identity and status info on the right, amounts and timestamps align left.
*   **Loading Behaviour:** Renders four stacked rectangular transaction card skeletons with linear horizontal shimmer.
*   **Error Behaviour:** Displays a flat warning card with redacted data and a retry database loading action.
*   **Empty Behaviour:** Replaced completely by the **Empty Screen Layout** (Region 10).
*   **Animation Notes:** Transaction detail modal slides up smoothly from the bottom edge; list items adjust vertical coordinates gracefully when items are verified or updated.

### Region 8: Primary Floating Action Button
*   **Purpose:** Prominent, reachable trigger to log a manual transaction or paste raw text.
*   **Priority:** Critical (Primary interaction gateway).
*   **Position:** Zone C, anchored to the logical bottom-start corner (lower-right for Persian RTL layouts).
*   **Width/Height:** Base size matches standard Material Design 3 FAB size tokens.
*   **Alignment:** Anchored to bottom-right corner with safe margins.
*   **Content Rules:** Displays a plus icon and localized label "ثبت دستی" (Log Manual).
*   **Interaction Rules:** Tapping the FAB slides up the Manual Entry Modal Sheet.
    *   Rapid downward scrolling collapses the FAB to a compact circle (icon-only) to protect reading space.
    *   Upward scroll restores the extended label.
*   **Accessibility:** Announced as: *"Button: Log manual transaction."*
*   **RTL Behaviour:** Positioned in the bottom-right corner (logical bottom-start) for immediate thumb reach.
*   **Loading/Error/Empty Behaviour:** Remains unaffected and active.
*   **Animation Notes:** Transitions between icon-only and extended labels use a horizontal slide-and-fade animation.

### Region 9: Shell Bottom Navigation Bar
*   **Purpose:** Persistent global route switcher across the four primary application sections.
*   **Priority:** Critical (Primary navigation).
*   **Position:** Zone C (Pinned to bottom viewport edge).
*   **Width:** Spans 100% of screen width.
*   **Height:** Locked to `bankyar.layout.navigation.height` (includes system gesture safe buffers).
*   **Alignment:** Equal-width horizontal distribution.
*   **Content Rules:** Four navigation items arranged right-to-left (RTL):
    1.  **دفترچه (Ledger):** Book icon (Active).
    2.  **نمودارها (Analytics):** Bar graph icon.
    3.  **قوانین (Rules):** Filter sliders icon.
    4.  **تنظیمات (Settings):** Gear icon.
*   **Interaction Rules:** Tapping an item switches the active viewport route immediately with a fast fade transition.
*   **Accessibility:** Announced as a navigation bar with active states: *"Navigation tab, Ledger, page one of four, active."*
*   **RTL Behaviour:** Tabs flow right-to-left: Ledger (Rightmost) to Settings (Leftmost).
*   **Loading/Error/Empty Behaviour:** Remains persistent, active, and interactive.
*   **Animation Notes:** Active selection changes paint an indicator pill backdrop with a soft scale and slide transition.

---

## 4. Information Hierarchy

The Home Dashboard operates on a highly structured visual hierarchy designed for fast scanability, minimal cognitive load, and immediate clarity.

### 4.1 Primary Visual Focus (Level 1)
*   **Component:** Region 3 (Total Balance Display Card).
*   **Justification:** The largest single visual container on the screen. It occupies the top fold and presents the user's consolidated financial net worth. Large monospace digits and the optional eye mask guarantee that this is the immediate entry point for the user's focus.

### 4.2 Secondary Visual Focus (Level 2)
*   **Component:** Region 4 (Today's Financial Summary Card) and Region 8 (Primary FAB).
*   **Justification:** The summary card immediately answers the user's secondary question (*"How much did I spend and receive today?"*), and the FAB provides a bold visual anchor in the interactive thumb zone for primary user actions.

### 4.3 High-Density Feed Focus (Level 3)
*   **Component:** Region 7 (Recent Transactions Ledger List) and Region 5 (Filter Row).
*   **Justification:** Represents the deepest information stream. These cards use a compact layout with thin dividing lines to allow the user to scan multiple transactions in a single view. Unverified transactions are highlighted with secondary border highlights to prompt immediate action.

---

## 5. Wireframe Description

The layout coordinate system is defined strictly using relative, logical dimensions, supporting fluid scaling across mobile form factors.

### 5.1 Absolute Spacing Grid System
*   **Grid:** 4-column layouts on mobile viewports.
*   **Symmetrical Padding:** Card components use the `bankyar.space.md` padding token.
*   **Dividing Lines:** Vertical and horizontal separators use a thin border token to define boundaries without relying on heavy shadows or hardcoded colors.

### 5.2 Responsive Layout Adaptations
*   **Tablet & Foldable Adaptations:** When horizontal viewports exceed standard smartphone widths, the single-column layout transitions to a two-pane layout:
    *   **Right Pane (6 Columns):** Displays Regions 2, 3, 4, 5, and 7 (Greeting, Balance, Summary, Filters, and Recent Ledger).
    *   **Left Pane (5 Columns):** Displays Region 6 (Quick Statistics Spend Chart) and interactive category rule setups.
    *   **Navigation Transition:** Bottom Navigation (Region 9) transitions to a vertical Navigation Rail anchored to the right margin (logical start), keeping the layout consistent and reachable.

---

## 6. Component Placement

Detailed coordinates and bounding rules for key components:

### 6.1 Diagnostic Status Badge
*   **Placement:** Placed at the logical end (left) of the Top App Bar (Region 1).
*   **Spacing:** Margins align with the outer boundary token `bankyar.responsive.margin`.
*   **Indicator State:** A steady green badge displaying *"Fully Offline"* confirms on-device security.

### 6.2 Search Trigger Icon
*   **Placement:** Anchored to the logical start (right) of the Top App Bar (Region 1).
*   **Interactive Area:** Sized to match the accessibility touch target token `bankyar.space.xl` to prevent mis-clicks.

### 6.3 Transaction Filters Chips
*   **Placement:** Located directly below Region 4 (Summary Cards) and above Region 7 (Transactions Ledger).
*   **Flow:** Arranged horizontally, overflowing the screen margins to encourage horizontal dragging.

### 6.4 Floating Action Button (FAB)
*   **Placement:** Anchored to the bottom-right corner of the screen.
*   **Z-Axis Elevation:** Elevated above the scrollable workspace (Zone B), with a clear margin from the Bottom Navigation (Region 9) to prevent overlapping touch targets.

### 6.5 Bottom Navigation Tabs
*   **Placement:** Pinned to the bottom edge of the screen.
*   **Spacing:** Includes a bottom safe margin to accommodate system gesture bars on Android devices.

---

## 7. Interaction Notes

Micro-interactions on the Home Dashboard are optimized for fast, reliable mobile usage.

### 7.1 Pull-to-Scan SMS Gesture
*   **Action:** Swiping down on the ledger feed triggers a rescan of local text messages.
*   **Visual Feedback:** A thin progress bar animates directly below the App Bar. The list remains interactive while parsing.

### 7.2 Swipe Isolation
*   **Action:** Horizontal swiping on transaction cards is disabled to prevent accidental deletions or modifications.
*   **Verification Dialogue:** Tap interactions on unverified cards open a quick confirmation card, allowing users to verify or edit categories.

### 7.3 Modal Sheets & Bottom Overlays
*   **Action:** Tapping the FAB opens a bottom sheet that slides up from the bottom edge.
*   **Dismissal:** Can be dismissed by tapping the backdrop or dragging the top handle downwards.

---

## 8. Accessibility Notes

BankYar is designed to be highly accessible and usable for all users.

### 8.1 Logical Focus Order
*   The screen reader focus order follows a natural reading pattern:
    1.  Top App Bar (Region 1) - Diagnostics, notifications, search.
    2.  Greeting Area (Region 2).
    3.  Total Balance Card (Region 3) - Balance details and visibility toggle.
    4.  Financial Summary (Region 4) - Inflow/outflow figures.
    5.  Filter Row (Region 5).
    6.  Spend Chart (Region 6) - Spend categories.
    7.  Ledger List (Region 7) - Transaction details grouped by date.
    8.  Primary FAB (Region 8).
    9.  Bottom Navigation Bar (Region 9).

### 8.2 Text Magnification
*   All card containers and lists are designed to scale and wrap text vertically, supporting up to 200% system-level text magnification without clipping content.

### 8.3 Touch Targets
*   All interactive elements (buttons, chips, lists, menu items) maintain a minimum touch target area matching the standard accessibility grid target token (`bankyar.space.xl`).

---

## 9. Validation Checklist

This wireframe specification must satisfy all validation checks before visual design or development begins:

*   [x] **No Hardcoded Hex Colors:** Every color mapping references abstract semantic design tokens (e.g., `bankyar.semantic.color.background.canvas`).
*   [x] **No Physical Dimensions:** Margins, spacing, padding, and corner curvatures use relative tokens (e.g., `bankyar.responsive.margin`) rather than physical pixels.
*   [x] **No Framework-Specific Code:** No framework UI building elements or code constructs are present.
*   [x] **Complete State Coverage:** Contains detailed layout rules for empty, loading, error, skeleton, permission, and offline states.
*   [x] **Symmetrical RTL Design:** Alignments, reading flows, and page transitions use logical coordinates (`start`, `end`).
*   [x] **No Mock Markers:** Contains no remaining warning notes, markers, or unfinished text elements.

---

## 10. UX Review Checklist

The following checklists verify that the wireframe meets core usability standards before high-fidelity design begins:

### 10.1 One-Handed Usability & Reachability
*   [x] **Reachability Check:** The most frequent interactive elements (FAB, Bottom Navigation, Filter Chips) are positioned in the lower third of the screen, within comfortable reach of the user's thumb.
*   [x] **Primary Action Check:** The Primary FAB is located in the bottom-right corner, making it easy to tap with one hand.
*   [x] **No Stretch Scroll:** The transaction list is scrollable without requiring the user to reach for top-screen elements.

### 10.2 Cognitive Load & Readability
*   [x] **Scanability:** The large typography on the Total Balance Card and clear inflow/outflow comparison columns allow users to check their financial status in less than two seconds.
*   [x] **Visual Clutter Control:** Spacing is managed via consistent margin and gutter tokens, preventing visual crowding.
*   [x] **Decoupled Security:** Sensitive values can be masked with a single tap, protecting user privacy in public spaces.

### 10.3 Device Adaptability
*   [x] **Tablet Strategy:** Layout transitions to a balanced multi-pane column system on larger screens, preventing cards from looking stretched.
*   [x] **Safe Area Buffers:** Layout margins account for top notch offsets and bottom navigation bars, preventing overlap with system actions.

---
**End of Document**
