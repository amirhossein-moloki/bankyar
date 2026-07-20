# BankYar Home Dashboard Screen Specification (v1.1.0)
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
- **Zero Framework Code:** All layouts, hierarchies, and components are defined without direct code structures or classes.
- **Zero Raw Styling Metrics:** Physical measurements (such as physical pixel offsets, density-independent pixels, or scale-independent typography units) are strictly omitted. All spacing, rounded corners, borders, and typography scales map directly to abstract design tokens.
- **Zero Hardcoded Colors:** All color definitions reference semantic color tokens that adapt dynamically between themes.
- **RTL-First Structure:** Layouts, reading flows, and component alignments progress naturally from the logical start edge (right) to the logical end edge (left).

---

## 2. Grid Architecture & Spatial Principles

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

---

## 3. Visual Specifications by Region

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [REGION 1: APP BAR HEADER]                                             |
|  +-------------------------------------------------------------------+  |
|  | [Notification Bell]          [Brand Logo]         [Search Trigger]|  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 2: WORKSPACE SCROLL AREA]                                      |
|  +-------------------------------------------------------------------+  |
|  |  [Greeting Section]                                               |  |
|  |                                                                   |  |
|  |  [Current Balance Card (Display Typo)]                            |  |
|  |                                                                   |  |
|  |  [Today's Summary Card (Inflow vs Outflow)]                       |  |
|  |                                                                   |  |
|  |  [Quick Statistics (Donut Graph Preview)]                         |  |
|  |                                                                   |  |
|  |  [Transaction Filters Scrolling Row]                              |  |
|  |                                                                   |  |
|  |  [Recent Transactions List (Chronological Feed)]                  |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 3: CONTROL & NAVIGATION]                                       |
|  +-------------------------------------------------------------------+  |
|  | [Floating Action Button: FAB] (Logical Bottom-Start / Lower Right) |  |
|  |                                                                   |  |
|  | [Persistent Bottom Navigation Bar]                                |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

### 3.1 Region 1: Top App Bar
The Top App Bar remains pinned at the top of the viewport, acting as the primary navigation and status banner.
- **Composition & RTL Flow:**
  - **Logical Start Edge (Right):** Quick search trigger icon and circular user profile avatar.
  - **Center:** Abstract brand logo symbol representing the secure, on-device vault.
  - **Logical End Edge (Left):** Notification bell icon with unread status badge and the offline diagnostics badge.
- **Visual Styles:**
  - **Container Base:** Transparent base that blends with the canvas background. When content scrolls underneath, a subtle dividing hairline (`bankyar.semantic.color.border.subtle`) appears.
  - **Height:** Scaled to `bankyar.space.xxl`.
- **Offline Status Badge:** Displays a steady green status dot with the localized label "کاملاً آفلاین" (Fully Offline), confirming to the user that zero bytes of data are transmitted.

### 3.2 Region 2: Greeting Section
Positioned at the top of the scrollable content area to welcome the user.
- **Visual Flow:**
  - **Primary Text:** "سلام، سهراب عزیز" (Hello, dear Sohrab) styled with `bankyar.semantic.typography.title.sm` typography token. Aligns strictly to the logical start margin (right).
  - **Secondary Supporting Text:** "صندوقچه مالی شما امن و به‌روز است" (Your financial vault is secure and updated) in secondary text color, styled with `bankyar.semantic.typography.body.sm` typography token.
- **Spacing:** Separated from the App Bar above by `bankyar.space.md`, and from the balance card below by `bankyar.space.lg`.

### 3.3 Region 3: Current Balance Card
The primary visual anchor of the Home Dashboard, summarizing the user's aggregated offline net worth.
- **Containment:** Rounded container card using `bankyar.radius.large` corner curvature token and filled with `bankyar.semantic.color.surface.default` background token.
- **Sizing:** Spans the full width of the horizontal workspace grid.
- **RTL Internal Flow:**
  - **Top-Start (Right):** Monochromatic label card "دارایی کل صندوقچه" (Total Vault Assets) in secondary text.
  - **Top-End (Left):** Decrypted balance visibility toggle icon (open eye symbol for visible, slashed eye symbol for masked).
  - **Center Display Metric:** Net total "+۱۲,۴۰۰,۰۰۰ تومان" (Toman) rendered in Display Large typography (`bankyar.semantic.typography.display.lg`) with monospace formatting for digits to ensure alignment.
  - **Bottom Status Row:** Displays "بروزرسانی شده در: ۱۴:۳۲" (Updated at: 14:32) on-disk file update indicator.
- **Visibility Masking (Privacy Mode):** Tapping the card or toggle icon triggers immediate visual masking. The balance metric is replaced with six secure circular dots ("••••••"), protecting sensitive financial figures when open in public environments.

### 3.4 Region 4: Today's Summary Card
Provides a side-by-side comparison of daily cash flows, positioned immediately below the balance card.
- **Containment:** Flat card using `bankyar.radius.medium` corner curvature token and a thin border outline (`bankyar.semantic.color.border.default`).
- **Internal Split Layout:** Divided into two equal horizontal layout columns using a vertical dividing line.
  - **Right Column (Inflow / Incomes):**
    - Label: "ورودی امروز" (Today's Inflow).
    - Amount: "+۵۰۰,۰۰۰ تومان" styled with green success text token.
    - Icon: Small upward-pointing arrow (`↑`) next to the amount.
  - **Left Column (Outflow / Expenses):**
    - Label: "خروجی امروز" (Today's Outflow).
    - Amount: "-۲۵۰,۰۰۰ تومان" styled with red error text token.
    - Icon: Small downward-pointing arrow (`↓`) next to the amount.
- **Spacing:** Internal margin padding matches `bankyar.space.md` token.

### 3.5 Region 5: Quick Statistics
Provides an instant analytical overview of category allocations for the current billing cycle.
- **Containment:** Bordered card styled with `bankyar.radius.medium` and subtle surface elevation tokens.
- **Interactive Donut Graph Preview:**
  - A flat circular donut segment positioned on the logical start side (right).
  - Segments are filled with high-contrast, low-saturation theme colors representing spending categories.
  - No physical gradients or drop shadows are applied.
- **RTL Monospace Legends:**
  - Positioned on the logical end side (left), aligned to the right.
  - Displays category labels with percentage indicators (e.g. "۴۰٪ خرید سوپرمارکت", "۳۰٪ اجاره خانه", "۳۰٪ حمل و نقل") using monospace digits for numerical alignment.
- **Interaction:** Tapping any segment dynamically filters the transaction list below. Tapping the graph center navigates to the detailed Statistics Dashboard page.

### 3.6 Region 6: Search Bar & Transaction Filters
Provides instant local filtering of the chronological transaction feed.
- **Search Input:**
  - Expands smoothly from the top App Bar trigger.
  - Uses an outlined input container styled with `bankyar.radius.full` and subtle focus outline tokens.
  - A clear trigger icon sits on the logical end edge (left) to reset query entries.
- **Scrolling Filter Chips Row:**
  - A horizontally scrollable row of choice chips immediately below the balance display.
  - Scrolling direction flows naturally from right to left (RTL).
  - **Selected Chip State:** Marked with active primary background fill, white text, and a leading checkmark icon.
  - **Unselected Chip State:** Muted outline border and standard secondary text.
  - **Filter Categories:** "همه" (All), "بانک ملی" (Melli Bank), "بانک ملت" (Mellat Bank), "خرید روزمره" (Daily Spend), "حمل و نقل" (Transport).

### 3.7 Region 7: Recent Transactions List
Displays a chronological ledger of parsed transaction records, grouped by date sections.
- **Section Headers:** Label dates (e.g., "امروز، ۱۲ دی ۱۴۰۲") in bold title font, separated by `bankyar.space.sm` vertical spacers.
- **List Dividers:** Hairline separator borders (`bankyar.semantic.color.border.subtle`) divide adjacent cards to prevent vertical list clutter.
- **Scroll Speed:** Optimized to maintain consistent performance (60fps+) on standard device screens.

---

## 4. Transaction Card Specification

Every transaction list item is structured within a dedicated card container, ensuring complete information clarity at a single glance.

```
+-------------------------------------------------------------------------+
| [Bank Logo]  [Bank Name]                       [Transaction Type]       |
|              [Category Badge]                  [Date & Time]            |
|                                                                         |
|                                                                         |
| [Status Ind] [Security Ind]  [User Note Icon]  [Amount & Currency]      |
+-------------------------------------------------------------------------+
```

### 4.1 Field Alignment & RTL Grid Mapping
- **Container Boundary:** Spans full width of the scroll area. Curvature is mapped to `bankyar.radius.medium` token.
- **Bank Logo Asset:** A localized vector logo (e.g., Bank Melli, Bank Mellat) displayed inside a circular avatar frame at the logical start corner (top-right). Size matches `bankyar.icon.size.md`.
- **Bank Name Text:** "بانک ملی ایران" or "بانک ملت" styled with `bankyar.semantic.typography.title.sm` typography token, positioned inline-end of the logo asset.
- **Category Badge:** A compact choice chip display (e.g. "حمل و نقل", "تغذیه") below the bank name text. Uses a subtle background tint and small font size.
- **Transaction Type Indicator:** Descriptive text label (e.g. "کارت به کارت (ورودی)", "خرید پایانه فروشگاهی") at the logical end corner (top-left).
- **Date & Time Timestamp:** Localized Solar Hijri date and 24-hour clock (e.g. "۱۴۰۲/۱۰/۱۲ - ۱۴:۳۲") in monospace digits below the transaction type indicator.
- **Amount & Currency Display:** Positional focus at the bottom-left corner.
  - **Inflow (Credit):** Placed with positive plus sign (e.g. "+۲۵۰,۰۰۰ تومان") using success text color.
  - **Outflow (Debit):** Placed with negative minus sign (e.g. "-۴۵,۰۰۰ تومان") using primary text color.
- **Security Indicator:** A padlock symbol confirming on-device cryptographic encryption, positioned on the bottom-right corner.
- **User Note Indicator:** A notebook icon next to the security indicator, visible only if a custom notes string is appended.
- **Status Indicator Dot:** A small status dot on the outer edge:
  - **Verified (Success Green):** Indicates standard parsed and checked entries.
  - **Unverified (Warning Amber):** Indicates heuristic parser results requiring user audit.

---

## 5. Persistent Control & Navigation

### 5.1 Floating Action Button (FAB)
- **Purpose:** Primary trigger to log custom transactions or trigger manual clipboard parsing.
- **Positioning:** Floating in Zone C, anchored to the logical bottom-start corner (lower right on RTL screen).
- **Interactive Styling:**
  - Extended oval shape on initialization, displaying "ثبت تراکنش" (Add Entry) and a leading plus icon.
  - Rapid downward scroll triggers smooth scaling transition to a compact circular shape, showing only the plus icon to protect reading space.
  - Drag-scrolling upwards restores the extended shape instantly.
- **Sizing & Radius:** Circle diameter matches `bankyar.space.xxl`. Curvature is mapped to `bankyar.radius.full`.

### 5.2 Shell Bottom Navigation Bar
- **Purpose:** Persistent linear tab navigation across primary application routing destinations.
- **Tabs RTL Distribution (Right to Left):**
  1. **دفترچه (Ledger):** Active tab by default, displayed with a filled ledger icon.
  2. **نمودارها (Analytics):** Mapped with an analytical bar graph icon.
  3. **قوانین (Rules):** Mapped with a list tuning icon.
  4. **تنظیمات (Settings):** Mapped with a secure settings cog icon.
- **Visual Styles:**
  - Container fill matches `bankyar.semantic.color.surface.raised` background token.
  - Standard navigation transition applies a soft indicator pill backdrop to the active selection.

---

## 6. Functional & Alternative Layout States

### 6.1 Pull to Refresh State
- **Gesture Action:** Swiping downwards on the chronological ledger feed triggers a rescan of the local SMS inbox.
- **Visual Feedback:** A thin linear progress indicator animates immediately below the Top App Bar, keeping the list active without blocking user interactions.

### 6.2 Empty State Layout
- **Visual Layout:** Centered full-screen panel displaying:
  - **Abstract Graphic:** Flat, monochromatic cash vault outline in the center, styled with `bankyar.icon.size.xl`.
  - **Supportive Headline:** "هنوز تراکنشی ثبت نشده است" (No transactions recorded yet) in bold typography.
  - **Empathetic Microcopy:** "بانک‌یار کاملاً آفلاین و امن است. به محض دریافت پیامک بانکی، تراکنش شما در این محل سازماندهی خواهد شد." (BankYar is fully offline and secure. As soon as a banking SMS is received, your transaction will be organized here.)
  - **Primary Action Button:** "ثبت دستی اولین تراکنش" (Manually log first transaction) styled as a prominent filled button in Zone C.

### 6.3 Loading State Layout
- **Visual Representation:** Employs layout-preserving skeleton templates to prevent awkward layout shifts once data query completes.
- **Skeleton Cards:** Linear shimmers flow from right to left across rectangular containers matching the exact curve and dimensions of balance cards and transaction rows.

### 6.4 Offline State Indicator
- **System Presentation:** Since BankYar has zero network permissions, the "Offline" state represents normal system operations.
- **Diagnostics Badge:** A steady green badge remains active in the App Bar header, reinforcing data sovereignty.

### 6.5 Permission State Card
- **Sizing & Containment:** A high-contrast card container positioned at the top of the transaction feed.
- **Visual Copy:** Explains the necessity of SMS access and provides two direct choices:
  - **Primary Action (Start):** "اعطای دسترسی پیامک" (Grant SMS Access) in filled container style.
  - **Secondary Action (End):** "تنظیم دستی حساب" (Set up manually) in bordered container style.

---

## 7. Interactive Controls & Overlays

### 7.1 Snackbars (Transient Notifications)
- **Visual Presentation:** A slide-up, low-contrast banner at the bottom of the screen.
- **RTL Content Flow:** Localized text message aligns right (e.g. "تراکنش با موفقیت حذف شد"), while the actionable undo trigger aligns left (e.g. "بازگردانی") in high-contrast accent color.
- **Dismissal:** Automatically self-dismisses after a short duration, or on swipe gestures.

### 7.2 Security Confirmation Dialogs
- **Purpose:** Used for critical, irreversible operations (such as clearing local databases).
- **Containment:** Centered popup container styled with `bankyar.radius.large` and heavy shadow tokens.
- **RTL Action Buttons:**
  - **Logical Start (Right):** "تایید حذف" (Confirm Deletion) styled with the alert crimson error token.
  - **Logical End (Left):** "انصراف" (Cancel Action) styled with neutral border outline.

### 7.3 System Bottom Sheets
- **Purpose:** Launches detailed metadata inspectors and category allocation editors.
- **Containment:** Slides upwards from the bottom of the viewport, settling in the lower half of the screen. Capped at 70% of viewport height.
- **Visual Elements:**
  - A central draggable bar handle at the top edge to support swipe dismissal gestures.
  - Scrollable categories chips grid inside the sheet container.

---

## 8. Interactive State Visual Mapping

To provide instant visual and tactile confirmation to the user, components modify their visual layers based on standard interaction states:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed |
| :--- | :--- | :--- |
| **Pressed State** | Element surface contrast shifts by +2 steps. Applies tactile touch-scale compression of 0.98x. | Immediate response trigger under `bankyar.motion.duration.instant` |
| **Selected State**| Applied primary background fill and active border indicators. Text changes to high contrast. | Smooth transition under `bankyar.motion.duration.fast` |
| **Loading State** | Content is overlaid with a semi-transparent shimmering pulse mask. Interactive triggers are locked. | Linear opacity loop under `bankyar.motion.duration.medium` |
| **Error State**   | Boundaries are repainted with high-contrast crimson tokens. Inline alert text displays context. | Shake animation on horizontal axis on launch |
| **Disabled State**| Applied 38% transparency opacity overlay. Active touch listeners are completely ignored. | Muted contrast change instantly |

---

## 9. Responsive Visual Layout Matrix

The layout structure adapts dynamically across varying form factors, maintaining architectural consistency.

### 9.1 Phone Viewport
- **Grid Layout:** 4 Columns. Symmetrical outer margins are optimized for close physical interaction.
- **Navigation:** Persistent Bottom Navigation Bar positioned within comfortable thumb reach.
- **Workspace:** Single scrollable ledger view. FAB is anchored to the bottom-start corner.

### 9.2 Large Phone Viewport
- **Grid Layout:** 4 Columns.
- **Visual Adaptation:** Spacing between categories and summary cards expands slightly to protect visual balance.

### 9.3 Tablet Viewport
- **Grid Layout:** 8 Columns.
- **Visual Adaptation (Split Pane View):**
  - **Logical Start Column Grid (Right):** The scrollable master ledger list of transactions.
  - **Logical End Column Grid (Left):** Persistent Transaction Detail panel showing full metadata, notes editor, and raw carrier SMS text.
- **Navigation:** Bottom Navigation Bar is replaced with a lateral Navigation Rail on the right edge, ensuring optimized screen real estate.

### 9.4 Foldable Viewport
- **Grid Layout:** 8 Columns.
- **Visual Adaptation:** Adapts based on hinge coordinates. Supports dual-screen layouts with the master transaction ledger on the right fold and the category statistics preview on the left fold.

---

## 10. Design Token Mapping Reference

Every visual property specified in this document maps directly to an active architectural design token, preserving long-term design consistency.

| Screen Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background.canvas` |
| Primary Container Card| Card Background Fill | `bankyar.semantic.color.surface.default` |
| Separators & Borders | Stroke Color | `bankyar.semantic.color.border.subtle` |
| Current Balance Text | Large Display Typography | `bankyar.semantic.typography.display.lg` |
| Segment Headers | Bold Subtitle Typography | `bankyar.semantic.typography.title.sm` |
| Transaction Amount | Monospace Numerical Display | `bankyar.semantic.typography.body.md` |
| Touch Target Envelopes| Sizing Spacing Factor | `bankyar.space.xl` |

---
**End of Specification Document**
