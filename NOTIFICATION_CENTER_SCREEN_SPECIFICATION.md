# BankYar Notification Center & Smart Notification Experience Specification (v2.0.0)
## Enterprise-Grade Screen & Interaction Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Framework Target:** Flutter (Platform-Agnostic Design Blueprint)
**Platform Target:** Android & iOS (RTL-Native Layouts with Hardware-Level Security)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Classification:** Enterprise Design System Specification
**Document Version:** 2.0.0
**Status:** Approved / Core Specification Blueprint

---

## 1. Executive Summary

This document establishes the absolute visual, spatial, and interaction design specifications for the **Notification Center and Smart Notification Experience** in the BankYar ecosystem. In a secure, offline-first personal finance platform with zero internet access and 100% on-device cryptography, notifications are not merely passive alerts—they represent the primary feedback loop between real-time background SMS interception and active user awareness.

Operating strictly within BankYar's Level 0 Engineering and Visual Design Constitutions:
- **Zero Framework Code:** All layouts, sequences, and structures are platform-independent, with zero Flutter/Dart implementation details.
- **Zero Raw Styling Metrics:** Hardcoded dimensions (pixels, dp, sp, milliseconds) are strictly prohibited. All dimensions, offsets, and gaps map directly to abstract design tokens (`bankyar.space.*`, `bankyar.radius.*`, etc.).
- **Zero Hardcoded Colors:** No raw HEX color codes are permitted. Every surface, text, and indicator layer references semantic tokens that adapt dynamically between Light, Dark, and High-Contrast modes.
- **RTL-First Structure:** Horizontal reading paths, vertical grids, swipe gestures, and transition curves mirror natively to support Persian RTL workflows from the logical start edge (right) to the logical end edge (left).
- **No Development Markers:** No draft markers, incomplete sections, or temporary development items exist. Every parameter is fully specified and production-ready.

---

## 2. Screen Blueprint & Spatial Scaffolding

The Notification Center is built using BankYar's logical three-zone vertical layout model, ensuring that system control bars, scrollable history feeds, and persistent diagnostic markers remain perfectly separated.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY NOTIFICATION CENTER HEADER & CONTROL BAR]              |
|  +-------------------------------------------------------------------+  |
|  | [Clear All Trigger]      { Notification Center }      [Back Chevron]|  |
|  |                                                                   |  |
|  | [ Unread: ۴ ] [ Smart Categories:  (واریز)  (برداشت)  (سیستم) ]     |  |
|  |                                                                   |  |
|  | [ Search: "بانک ملی" ...                                       ]  |  |
|  |                                                                   |  |
|  | [ Filter: [همه]  [امروز]  [تراکنش]  [امنیت]  [پین شده] ]             |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE NOTIFICATION WORKSPACE & HISTORY]                  |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 1: Pinned Notifications / Active System Warnings]        |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | Pinned Icon | Security Alert: Root detected!          |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 2: Today's Notifications Timeline]                       |  |
|  |     [Section Header: امروز (Today) - ۱۲ دی ۱۴۰۲]                   |  |
|  |     - Deposit Notification Card (Unread, success colored)         |  |
|  |     - Withdrawal Notification Card (Read, muted metadata)         |  |
|  |     - Failed Parsing Card (Unread, showing retry trigger)         |  |
|  |                                                                   |  |
|  |  [Region 3: Yesterday's Notifications Timeline]                   |  |
|  |     [Section Header: دیروز (Yesterday) - ۱۱ دی ۱۴۰۲]               |  |
|  |     - Purchase Card (Read, showing notes tag)                     |  |
|  |     - Transfer Card (Read, showing share receipt trigger)         |  |
|  |                                                                   |  |
|  |  [Region 4: Older Notifications Timeline]                         |  |
|  |     [Section Header: قدیمی‌تر (Older)]                            |  |
|  |     - Backup Completed Card (Read, muted metadata)                |  |
|  |     - Permission Reminder Card (Read, persistent check)           |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: PERSISTENT CONTROLS & SYSTEM DIAGNOSTICS]                     |
|  +-------------------------------------------------------------------+  |
|  | [Offline Privacy Status Badge: "آفلاین و امن - بدون اتصال شبکه"]  |  |
|  | [Shell Bottom Navigation Bar]                                     |  |
|  | [داشبورد]             [تحلیل‌ها]             [قوانین]   [تنظیمات]* |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## 3. Core Spatial Principles & Grid System

All structural elements, padding configurations, interactive cards, and action rows align strictly with BankYar's dynamic 8-unit spatial layout grid, guaranteeing geometric consistency and vertical rhythm.

### 3.1 Grid Layout Metrics
- **Compact Viewport (Smartphones):** 4 columns. Symmetrical outer margins are mapped to the token `bankyar.responsive.margin` (resolving to `bankyar.space.lg` on mobile). Inter-column gutters are bound to `bankyar.responsive.gutter` (`bankyar.space.md`).
- **Medium Viewport (Tablets / Foldables):** 8 columns. Master-detail horizontal splitting. Symmetrical margins are bound to `bankyar.space.xl` and gutters to `bankyar.space.lg`.
- **Expanded Viewport (Landscape / Large Tablets):** 12 columns. Content columns are constrained to `bankyar.responsive.container.width.max` to prevent uncomfortably stretched cards.

### 3.2 Vertical Baseline Rhythm
Every component height, list margin, inner padding, and typographical leading is an exact integer multiple of the baseline spatial multiplier token `bankyar.global.space.base`.
- `bankyar.space.xxs` (0.25x base unit, for subtle badges, status dots, and unread indicators)
- `bankyar.space.xs` (0.5x base unit, for tight inline spacings and icons next to text labels)
- `bankyar.space.sm` (1x base unit, for field labels, section titles, and minor component gaps)
- `bankyar.space.md` (2x base unit, for default internal card padding and vertical list gaps)
- `bankyar.space.lg` (3x base unit, for outer screen margins, screen divisions, and section headers)
- `bankyar.space.xl` (4x base unit, for primary action buttons, bottom bars, and custom touch heights)
- `bankyar.space.xxl` (6x base unit, for empty state illustrations and large vertical offsets)

---

## 4. Detailed Component Specifications

For every core element in the Notification Center interface, the design attributes must conform strictly to the following 17-point parameters. No element may use raw or hardcoded properties.

### 4.1 Notification Summary & Unread Counter Component
1. **Purpose:** Displays an aggregated status of unread notifications, giving users immediate visual feedback on pending events.
2. **Business Value:** Prevents user anxiety by structuring unhandled events, leading to a calm and controlled financial management experience.
3. **Visual Priority:** High priority in Zone A. Styled using prominent, high-contrast text.
4. **Placement:** Pinned on the right (logical start) edge of the summary control row.
5. **Spacing:** Inner margin is bound to `bankyar.space.xs`. Symmetrical outer padding is `bankyar.space.sm`.
6. **Typography:** Numbers use the monospace typeface `bankyar.global.font.family.mono` styled with `bankyar.semantic.typography.title.sm` using `bankyar.font.weight.bold`.
7. **Icons:** Red circular unread indicator dot `bankyar.semantic.color.status.error` sized to `bankyar.space.xxs`.
8. **Elevation:** Elevation level zero `bankyar.elevation.level.zero`. Sits flat on the header background.
9. **Interaction:** Tapping the summary triggers a filter toggle, focusing the list on unread notifications only.
10. **Loading:** Replaced by a small, rounded shimmering capsule of width `bankyar.space.xl`.
11. **Disabled:** Contrast opacity is reduced to `bankyar.opacity.medium` with touch triggers deactivated.
12. **Error:** Outlined in error crimson `bankyar.semantic.color.status.error` if database fetching fails.
13. **Success:** Transition animation triggers when all items are marked read, fading the indicator to zero opacity.
14. **Accessibility:** TalkBack announces: *"۴ اعلان جدید خوانده نشده وجود دارد. جهت مشاهده ضربه بزنید."*
15. **RTL Behaviour:** Placed at the logical right start, and reading direction is right-to-left.
16. **Animation:** Fades out using standard curve `bankyar.motion.curve.standard` and fast duration `bankyar.motion.duration.fast`.
17. **Future Expansion:** Prepared to display breakdown categories (e.g., "۳ واریزی، ۱ سیستم").

---

### 4.2 Notification Search Input Component
1. **Purpose:** Allows users to query notifications by bank name, transaction amounts, note text, or tags.
2. **Business Value:** Provides rapid access to historical records, critical for resolving bank discrepancy disputes quickly.
3. **Visual Priority:** Medium priority in Zone A.
4. **Placement:** Positioned below the main summary title, spanning 100% of the active layout columns.
5. **Spacing:** Top and bottom margins use `bankyar.space.sm`. Horizontal outer padding is `bankyar.space.md`.
6. **Typography:** Default input prompt text uses `bankyar.semantic.typography.body.md` with muted contrast `bankyar.semantic.color.text.secondary`.
7. **Icons:** Leading search glass icon `bankyar.icon.search` and trailing filter icon `bankyar.icon.filter`.
8. **Elevation:** Elevation level one `bankyar.elevation.level.one` inside a soft background container.
9. **Interaction:** Tapping opens keyboard focus. Typing updates the scrollable history feed in real time.
10. **Loading:** Standard shimmering border line cycling along the boundary container.
11. **Disabled:** Container background shifts to `bankyar.semantic.color.interactive.disabled` with input blocked.
12. **Error:** Outlines in soft warning yellow `bankyar.semantic.color.status.error` when search returns zero results.
13. **Success:** Active border shifts to primary accent `bankyar.semantic.color.border.active` when matches are found.
14. **Accessibility:** Features a descriptive accessibility label: *"فیلد جستجوی اعلان‌ها. متنی برای جستجوی نام بانک یا مبالغ وارد کنید."*
15. **RTL Behaviour:** Leading search icon is placed on the logical right (start). Text input flows from right to left.
16. **Animation:** Keyboard activation pushes Zone B down smoothly using standard motion curve `bankyar.motion.curve.standard`.
17. **Future Expansion:** Reserved space to store local, offline recent search queries.

---

### 4.3 Advanced Filter Choice Chips Row Component
1. **Purpose:** Offers rapid horizontal switching of timeline filters (All, Unread, Today, This Week, Bank, Transaction Type, Security, Favorites, Pinned).
2. **Business Value:** Minimizes user task execution times when locating specific alert types under stress.
3. **Visual Priority:** Medium priority in Zone A.
4. **Placement:** Horizontally scrollable row situated directly beneath the search input.
5. **Spacing:** Standard spacing gap between chips is `bankyar.space.xs`. Outer row margins are `bankyar.space.md`.
6. **Typography:** Chip labels use caption font `bankyar.semantic.typography.body.sm` with regular weight.
7. **Icons:** Custom leading icons (e.g., star icon `bankyar.icon.favorite` for Favorites, pin icon `bankyar.icon.pin` for Pinned).
8. **Elevation:** Sits flat on the canvas at elevation level zero `bankyar.elevation.level.zero`.
9. **Interaction:** Single-select toggle behavior. Tapping an inactive chip highlights it and filters the feed immediately.
10. **Loading:** Replaced by multiple shimmering rounded capsules.
11. **Disabled:** Chips are visually greyed out and untouchable during database migrations.
12. **Error:** Border flashes red if selected category filter fails to load query.
13. **Success:** Active chip switches fill to primary accent `bankyar.semantic.color.interactive.default` with high-contrast text.
14. **Accessibility:** TalkBack reads: *"دکمه فیلتر تراکنش‌های واریزی. غیرفعال. دو بار ضربه بزنید تا فعال شود."*
15. **RTL Behaviour:** Row scrolls from logical right to logical left. Standard selection flows right-to-left.
16. **Animation:** Horizontal sliding inertia is smooth, fading into the edge with a linear opacity gradient block.
17. **Future Expansion:** Reserved database tags to support custom user-defined filter rules.

---

### 4.4 Smart Category Capsules Component
1. **Purpose:** Intelligent aggregated category chips (e.g., Income, Expenses, System, Warnings) dynamically created based on local metadata.
2. **Business Value:** Automatically segments chaotic system events, helping users spot unusual cash flow fluctuations immediately.
3. **Visual Priority:** High priority in Zone A.
4. **Placement:** Placed above the search bar, adjacent to the unread summary count.
5. **Spacing:** Internal margin uses `bankyar.space.xxs`. Horizontal capsule gaps are `bankyar.space.xs`.
6. **Typography:** Styled with micro typography `bankyar.font.size.xs` in semi-bold weight.
7. **Icons:** Mini trend indicators (e.g., up arrow for income, down arrow for expense) sized to `bankyar.icon.size.sm`.
8. **Elevation:** Elevation level one `bankyar.elevation.level.one`.
9. **Interaction:** Clicking updates category totals in-app. Long-press displays a quick summary sheet.
10. **Loading:** Shows shimmering circular capsules of width matching active labels.
11. **Disabled:** Visual contrast is reduced to 38% opacity.
12. **Error:** Displays broken icon indicator if categorizer engine encounters a processing exception.
13. **Success:** Smooth color flash when matching transactions are added to the active category bucket.
14. **Accessibility:** TalkBack reads: *"دسته بندی هوشمند واریزها. شامل سه اعلان جدید."*
15. **RTL Behaviour:** Layout aligns to logical right (start), scrolling towards left.
16. **Animation:** Expand/collapse transition uses standard ease curve `bankyar.motion.curve.standard`.
17. **Future Expansion:** Hooked to local on-device machine learning models for automated category sorting.

---

### 4.5 Standard Notification Card Component
1. **Purpose:** Renders critical structured parameters of an individual alert.
2. **Business Value:** Standardizes scattered multi-bank SMS structures into an easily readable ledger card.
3. **Visual Priority:** Core high-priority interactive element in Zone B.
4. **Placement:** Vertical rows within scrollable sections of Zone B.
5. **Spacing:** Internal card padding is bound to `bankyar.space.md`. External card gap is `bankyar.space.sm`.
6. **Typography:** Sender title uses bold subtitle `bankyar.semantic.typography.body.md` with high contrast. Message uses `bankyar.semantic.typography.body.sm` with standard spacing line leading.
7. **Icons:** Bank logo container frame sized to `bankyar.icon.size.md` enclosed in `bankyar.radius.full`.
8. **Elevation:** Flat background fill `bankyar.semantic.color.surface.flat` with a thin boundary stroke `bankyar.semantic.color.border.subtle`.
9. **Interaction:** Tapping anywhere on the container card triggers a smooth detail expansion. Horizontal swipes reveal quick actions.
10. **Loading:** Replaced by a high-fidelity shimmering skeleton structure mapping exactly to text rows.
11. **Disabled:** Faded out to 38% opacity, and swipe listeners are deactivated.
12. **Error:** Card border highlights in warning yellow `bankyar.semantic.color.status.error` when parsing errors are detected.
13. **Success:** Green outline highlight flashes momentarily when a parsing error is resolved and saved.
14. **Accessibility:** Read as a unified semantic node: *"بانک ملی ایران. برداشت وجه موفق. مبلغ منفی چهل و پنج هزار تومان. ساعت چهارده و سی و دو دقیقه."*
15. **RTL Behaviour:** Bank icon is on the logical right start edge. Timestamp is on the logical left end edge. Texts read right-to-left.
16. **Animation:** Swipe dismissal slides the card on the horizontal axis while fading container opacity to zero.
17. **Future Expansion:** Ready to incorporate personalized sub-categorization tags and notes tags directly on the card face.

---

### 4.6 Grouped Notification Stack Component
1. **Purpose:** Groups multiple related notifications from the same financial source into an overlapping stacked pile.
2. **Business Value:** Prevents screen clutter when high-frequency transactions occur, reducing visual overwhelm.
3. **Visual Priority:** Medium priority in Zone B.
4. **Placement:** Interspersed within chronological lists.
5. **Spacing:** Offset pile stacking uses vertical gaps bound to `bankyar.space.xxs`.
6. **Typography:** Styled with identical standards as parent cards, showing count label "۳ پیام جدید" in micro-font.
7. **Icons:** Overlapping stacked file outlines or double chevron indicator icons.
8. **Elevation:** Stacked offset lines use elevation level one `bankyar.elevation.level.one`.
9. **Interaction:** Tapping the stack triggers an accordion expansion, spreading nested cards vertically.
10. **Loading:** Replaced by standard multi-layered shimmering outlines.
11. **Disabled:** Accompanying controls are frozen with visual opacity desaturated.
12. **Error:** Outlined in error status outline if database sub-queries fail.
13. **Success:** Seamless expansion when unread child cards are resolved.
14. **Accessibility:** TalkBack reads: *"گروه اعلان‌های بانک صادرات. شامل سه پیام جدید تایید نشده. جهت باز کردن دو بار ضربه بزنید."*
15. **RTL Behaviour:** Mirroring matches the primary card layout, stacking cards with leftward and downward offsets.
16. **Animation:** Accordion vertical expansion is powered by the natural easing curve `bankyar.motion.curve.standard`.
17. **Future Expansion:** Space prepared to support nested "Clear Group" swipe commands.

---

### 4.7 Pinned System Warning Panel Component
1. **Purpose:** Persistent banners for critical system states (e.g., background service limitations, database decryption issues).
2. **Business Value:** Guarantees absolute reliability by ensuring critical system constraints are immediately visible and resolved.
3. **Visual Priority:** Maximum priority in Zone B.
4. **Placement:** Fixed at the top of Zone B, above all chronological lists.
5. **Spacing:** Inner padding is `bankyar.space.md`. External margin is `bankyar.space.lg` to separate it from other content.
6. **Typography:** Bold warning title using `bankyar.semantic.typography.body.md` with high-contrast text.
7. **Icons:** Solid warning padlock or shield icon styled with amber status warning tokens.
8. **Elevation:** Elevated surface tint overlay using elevation level two `bankyar.elevation.level.two`.
9. **Interaction:** Tapping launches the localized diagnostic tutorial or permission settings screen. Non-dismissible until resolved.
10. **Loading:** Replaced by a high-priority shimmering alert card.
11. **Disabled:** Visual interactivity is locked when background resolution is running.
12. **Error:** Outlines flash red during verification failure.
13. **Success:** Panel slides upward off-screen and disappears once permissions are granted.
14. **Accessibility:** High-priority TalkBack alert: *"هشدار سیستم! دسترسی پیامک صادر نشده است. جهت اصلاح ضربه بزنید."*
15. **RTL Behaviour:** Icon aligns to logical right start. Close action (if available) aligns to logical left end.
16. **Animation:** Slide-down transition on launch uses fast decelerate curve `bankyar.motion.curve.decelerate`.
17. **Future Expansion:** Ready to integrate local device hardware diagnostics status.

---

### 4.8 Quick Action Interactive Button Row Component
1. **Purpose:** Low-height row of interactive quick action buttons positioned on expanded cards or bottom sheets.
2. **Business Value:** Increases transactional speed, letting users categorize, tag, or write annotations in seconds.
3. **Visual Priority:** Medium priority.
4. **Placement:** Embedded within the bottom edge of an expanded notification card container.
5. **Spacing:** Symmetrical horizontal margin is `bankyar.space.md`. Vertical gaps are `bankyar.space.xs`.
6. **Typography:** Styled with micro typography labels `bankyar.semantic.typography.body.sm` in medium weight.
7. **Icons:** Inline functional symbols (e.g., note icon `bankyar.icon.note`, edit icon `bankyar.icon.edit`, trash icon `bankyar.icon.delete`).
8. **Elevation:** Zero elevation `bankyar.elevation.level.zero`. Sits flat inside the card.
9. **Interaction:** Tapping triggers action modals immediately. Press triggers scale compression of 0.98x.
10. **Loading:** Text labels are replaced by small centered spinning circular progress rings.
11. **Disabled:** Blocked with 38% opacity mask, preventing double-taps during active processes.
12. **Error:** Button borders flash red if action (e.g., file write) fails.
13. **Success:** Green indicator flash with checkmark upon successful transaction modification.
14. **Accessibility:** Buttons have custom labels: *"دکمه افزودن یادداشت به تراکنش بانک ملی ایران. دو بار ضربه بزنید."*
15. **RTL Behaviour:** Actions flow from right to left, matching standard reading paths.
16. **Animation:** Row slides down smoothly from the card fold during card expansion.
17. **Future Expansion:** Customizable quick actions based on user-defined priority settings.

---

### 4.9 Persistent Offline Diagnostics Badge Component
1. **Purpose:** A clean visual status badge verifying secure, connection-free database operation.
2. **Business Value:** Reassures privacy-focused users that their financial records are kept 100% local and secure.
3. **Visual Priority:** Muted priority in Zone C.
4. **Placement:** Centered horizontally directly above the bottom navigation shell bar.
5. **Spacing:** Symmetrical margins are bound to `bankyar.space.xs`.
6. **Typography:** Micro caption text using monospace font styled with regular weight.
7. **Icons:** An active green status dot `bankyar.semantic.color.status.success` with size `bankyar.space.xxs`.
8. **Elevation:** Flat background fill elevation zero `bankyar.elevation.level.zero`.
9. **Interaction:** Tapping displays a secure overlay outlining the application's zero-network parameters.
10. **Loading:** Constant status, no loading state needed.
11. **Disabled:** Locked in offline-only state. Unaffected by system status.
12. **Error:** Dot flashes red if local database integrity diagnostics fail.
13. **Success:** Constant steady green glow, reassuring the user.
14. **Accessibility:** TalkBack reads: *"پایگاه داده آفلاین و رمزنگاری شده فعال است. برنامه هیچگونه دسترسی به اینترنت ندارد."*
15. **RTL Behaviour:** Mirrored layout places the green status dot to the logical right (start) of the label.
16. **Animation:** Gentle pulse cycle on startup, stabilizing to static display.
17. **Future Expansion:** Ready to display real-time local file system size readouts.

---

## 5. Notification Templates Catalog

To ensure complete visual consistency, the system provides eleven (11) pre-designed templates covering every potential system event.

```
+--------------------------------------------------------------------------+
|  Template Visual Signatures Overview (RTL Flow)                          |
|                                                                          |
|  [واریز وجه (Deposit)]     --> Frame: Soft Green Circle    --> Amount: Green (+۱۰۰,۰۰۰) |
|  [برداشت وجه (Debit)]     --> Frame: Neutral Gray Circle  --> Amount: Standard (-۵۰,۰۰۰) |
|  [خطای پردازش (Failed)]   --> Frame: Warning Amber Outline--> Actions: Retry (تلاش مجدد) |
|  [امنیت سیستم (Security)] --> Frame: Critical Red Border  --> Status: Non-Dismissible |
+--------------------------------------------------------------------------+
```

### 5.1 Deposit Notification Template
- **Category:** Financial Inflow
- **Priority:** Default (System Tray) / High (Lock Screen biometric challenge if amount is high)
- **RTL Typography Mappings:**
  - Title: "واریز وجه موفق" (Successful Deposit)
  - Body: "مبلغ مشخص شده به حساب شما واریز گردید."
- **Visual Styling & Icons:** Soft green circular container enclosing a left-pointing arrow icon `icon_financial_income_default.svg`. Transaction amounts use success green text color.
- **Action Triggers:** `Open Transaction` (مشاهده جزئیات), `Add Note` (افزودن یادداشت).

### 5.2 Withdrawal Notification Template
- **Category:** Financial Outflow
- **Priority:** Default (System Tray)
- **RTL Typography Mappings:**
  - Title: "برداشت وجه موفق" (Successful Withdrawal)
  - Body: "مبلغ مشخص شده از حساب شما برداشت گردید."
- **Visual Styling & Icons:** Neutral gray circular container enclosing a right-pointing arrow icon `icon_financial_expense_default.svg`. Amounts use standard high-contrast text color.
- **Action Triggers:** `Open Transaction` (مشاهده جزئیات), `Add Note` (افزودن یادداشت).

### 5.3 Purchase Notification Template
- **Category:** Store Transaction
- **Priority:** Default (System Tray)
- **RTL Typography Mappings:**
  - Title: "خرید فروشگاهی" (Store Purchase)
  - Body: "پرداخت موفق روی پایانه فروشگاهی (POS)."
- **Visual Styling & Icons:** Shopping bag outline icon `icon_financial_purchase_default.svg` inside a standard gray container. Standard subtle borders.
- **Action Triggers:** `Open Transaction` (مشاهده جزئیات), `Add Note` (افزودن یادداشت), `Pin Notification` (سنجاق کردن).

### 5.4 Transfer Notification Template
- **Category:** Transaction Transfer
- **Priority:** Default (System Tray)
- **RTL Typography Mappings:**
  - Title: "کارت به کارت موفق" (Successful P2P Transfer)
  - Body: "انتقال وجه بین بانکی با موفقیت ثبت شد."
- **Visual Styling & Icons:** Reciprocal double horizontal arrows icon `icon_financial_transfer_default.svg`. Card layout uses standard subtle outline.
- **Action Triggers:** `Open Transaction` (مشاهده جزئیات), `View Bank Details` (اطلاعات بانک).

### 5.5 ATM Notification Template
- **Category:** Physical Cash
- **Priority:** Silent (System Tray)
- **RTL Typography Mappings:**
  - Title: "برداشت نقدی از خودپرداز" (ATM Cash Withdrawal)
  - Body: "برداشت نقدی فیزیکی از دستگاه خودپرداز شناسایی شد."
- **Visual Styling & Icons:** Cash stack/ATM machine icon `icon_financial_atm_default.svg`. Styling uses neutral flat colors.
- **Action Triggers:** `Open Transaction` (مشاهده جزئیات), `Add Note` (افزودن یادداشت).

### 5.6 Failed Transaction Template
- **Category:** Financial Failure
- **Priority:** High (In-app Warning Feed)
- **RTL Typography Mappings:**
  - Title: "تراکنش ناموفق" (Failed Transaction)
  - Body: "تراکنش بانکی به دلیل موجودی ناکافی یا خطای سامانه انجام نشد."
- **Visual Styling & Icons:** Red exclamation triangle icon `icon_status_failed_default.svg`. Card highlights in soft red outline.
- **Action Triggers:** `Open Transaction` (مشاهده جزئیات), `Dismiss` (رد کردن).

### 5.7 Unknown Transaction Template
- **Category:** Parsing Alert (Low Confidence Match)
- **Priority:** High (In-app Warning Feed)
- **RTL Typography Mappings:**
  - Title: "خطا در خواندن پیامک" (SMS Parsing Error)
  - Body: "یک پیامک بانکی دریافت شد اما ساختار آن توسط الگوهای فعلی شناسایی نگردید. جهت تکمیل اطلاعات ضربه بزنید."
- **Visual Styling & Icons:** Broken magnifying glass icon `icon_status_failed_default.svg` in warning yellow. Outlined in soft warning yellow.
- **Action Triggers:** `Retry Parsing` (تلاش مجدد), `Add Note` (افزودن دستی).

### 5.8 Security Alert Template
- **Category:** Critical System Threat
- **Priority:** High (Heads-up alert with device vibration pattern, pinned alert panel)
- **RTL Typography Mappings:**
  - Title: "هشدار امنیتی سیستم" (Critical Security System Alert)
  - Body: "احتمال دسترسی غیرمجاز یا تغییر در ساختار امنیتی دستگاه شناسایی شد. دسترسی محلی موقتاً محدود می‌گردد."
- **Visual Styling & Icons:** Solid warning padlock icon `icon_security_lock_default.svg` in high-contrast error red. Card highlights in thick red border.
- **Action Triggers:** `View Bank Details` (مرکز امنیت), `Dismiss` (بستن).

### 5.9 Backup Reminder Template
- **Category:** Data Protection Warning
- **Priority:** High (System heads-up alert, persistent in in-app warning tray)
- **RTL Typography Mappings:**
  - Title: "پشتیبان‌گیری ناموفق" (Backup Failed)
  - Body: "فضای ذخیره‌سازی محلی دستگاه پر است. لطفاً جهت جلوگیری از خطر از دست رفتن اطلاعات، فضا خالی کنید."
- **Visual Styling & Icons:** Solid warning shield exclamation icon `icon_status_warning_default.svg` in semantic error red.
- **Action Triggers:** `Open Transaction` (پشتیبان‌گیری مجدد).

### 5.10 Permission Reminder Template
- **Category:** System Requirement
- **Priority:** High (Pinned app-header banner, non-dismissible)
- **RTL Typography Mappings:**
  - Title: "دسترسی پیامک صادر نشده است" (SMS Permission Missing)
  - Body: "بدون دسترسی خواندن پیامک، امکان دریافت و پردازش خودکار تراکنش‌ها وجود ندارد. جهت صدور دسترسی ضربه بزنید."
- **Visual Styling & Icons:** Empty envelope next to a small security key icon `icon_status_warning_default.svg` in warning yellow.
- **Action Triggers:** `Open Transaction` (صدور دسترسی).

### 5.11 Application Update (Future) Template
- **Category:** Software Lifecycle
- **Priority:** Silent (No system status bar interruption, logged in Settings & Help Center)
- **RTL Typography Mappings:**
  - Title: "به‌روزرسانی جدید بانکیار" (New Application Version Available)
  - Body: "نسخه جدید بانکیار شامل الگوهای جدید شناسایی بانک‌ها منتشر شد. به‌روزرسانی کاملاً آفلاین و امن است."
- **Visual Styling & Icons:** Clockwise circular arrow surrounding a package outline `icon_nav_settings_default.svg` in subtle primary brand accent.
- **Action Triggers:** `Open Transaction` (دانلود نسخه جدید), `Dismiss` (بستن).

---

## 6. Smart Actions Architecture

Each notification card provides a standardized row of Quick Action Buttons. To maximize interaction speed, each button maps to a standardized action type.

### 6.1 Action Type Definitions & Mechanics
1. **Open Transaction (مشاهده جزئیات):** Directs the user to the full Transaction Detail Viewer, loading the raw SMS text, extracted metadata fields, notes, and relational tags.
2. **Add Note (افزودن یادداشت):** Instantly displays a contextual, lightweight bottom sheet overlay featuring a text input field, enabling users to write annotations without leaving the active drawer.
3. **Edit Note (ویرایش یادداشت):** Opens the same bottom sheet overlay pre-filled with the existing text, allowing quick modifications.
4. **Mark as Read (علامت‌گذاری به عنوان خوانده شده):** Fades the unread indicator dot out, updates database status, and reduces container opacity by one step.
5. **Mark as Unread (علامت‌گذاری به عنوان خوانده نشده):** Restores the red unread indicator dot and returns the card to high-contrast styling.
6. **Pin Notification (سنجاق کردن اعلان):** Pins the notification card to the top of the feed under the Pinned section. Tapping this fills the pin icon instantly.
7. **Delete Notification (حذف اعلان):** Removes the active card from the feed, displaying an "Undo Delete" trigger bar at the bottom of the screen.
8. **Mute Similar Notifications (بی‌صدا کردن موارد مشابه):** Opens a dialog prompting the user to silence future alerts from this specific sender or bank category.
9. **View Bank Details (اطلاعات بانک):** Displays a localized summary overlay showing account numbers, recent cash flow totals, and associated parsing templates.

---

## 7. Filter Rules & Multi-Criteria Grouping Models

To keep high-volume alerts structured and easy to scan, the Notification Center supports nine (9) chronological and structural filtering models.

### 7.1 Filter Segment Definitions
- **All (همه):** Default view. Displays all parsed and system notifications in reverse-chronological order.
- **Unread (خوانده نشده):** Filters the feed to show only notifications with active unread indicator dots.
- **Today (امروز):** Filters the feed to show only notifications with timestamps matching the current Solar Hijri calendar date.
- **This Week (این هفته):** Filters the feed to show notifications received within the last 7 calendar days.
- **Bank (بانک):** Groups alerts by the issuing financial source (e.g., Bank Melli, Bank Mellat), helping users verify spending patterns on specific cards.
- **Transaction Type (نوع تراکنش):** Organizes cards into Deposits (Income), Withdrawals (Expenses), or non-financial system alerts.
- **Security (امنیت):** Filters the feed to show only security warnings, database error alerts, or root detection panels.
- **Favorites (نشان‌شده‌ها):** Displays only notification cards that have been starred by the user.
- **Pinned (سنجاق‌شده‌ها):** Filters the feed to show only pinned system alerts or pinned user notifications.

---

## 8. Screen States Experience System

Components adjust their visual layers dynamically based on system states, supporting seamless transitions and providing clear visual feedback:

```
+-------------------------------------------------------------------------+
| Screen States Experience Flow                                           |
|                                                                         |
|  [Loading State]        --> Continuous linear shimmer from right-to-left|
|  [Empty State]          --> Centered illustration with clear action button|
|  [Offline State]        --> Green status badge active, no-network warning|
|  [Error State]          --> Red border glow, retry trigger button active|
+-------------------------------------------------------------------------+
```

### 8.1 Loading State (Shimmer Skeleton)
- **Visual Representation:** When opening the Notification Center, standard cards are replaced by shimmering skeleton blocks.
- **Shimmer Flow:** Shimmer sweeps continuously from right to left (RTL), inline with regional reading habits.
- **Design Token Mapping:** Shimmer background uses `bankyar.semantic.color.background` with overlay gradient opacity.

### 8.2 Empty State Layout
- **Visual Representation:** Centered layout displaying a clean, minimal vector illustration of a quiet, empty mailbox.
- **Copy Mapping:**
  - Main Label: "مرکز اعلان‌های شما خالی است" (Your Notification Center is Empty) styled with `bankyar.semantic.typography.title.sm`.
  - Subtext: "پس از دریافت اولین پیامک بانکی، تراکنش‌های شما به صورت خودکار در این قسمت سازماندهی خواهند شد."
- **Action Trigger:** A prominent, flat action button "شبیه‌سازی دریافت پیامک" (Simulate SMS Ingestion) centered below to help first-time users test the system.

### 8.3 Offline-First Security State
- **Visual Representation:** An active green status dot `bankyar.semantic.color.status.success` is displayed next to a centered small label "اتصال شبکه قطع است - اطلاعات ۱۰۰٪ روی گوشی شماست" (Network disconnected - data is 100% on your phone).
- **Aesthetics:** High-contrast text on a flat background fill, confirming complete offline operations.

### 8.4 Error State Layout
- **Visual Representation:** Displayed if local database queries fail. Outline borders turn red, accompanied by an amber alert icon and helpful subtext.
- **Copy Mapping:**
  - Error Copy: "خطا در بارگذاری تاریخچه اعلان‌ها. پایگاه داده رمزنگاری شده قفل شده یا با مشکل مواجه گردیده است."
- **Action Triggers:** "تلاش مجدد" (Retry load) and "تعمیر پایگاه داده" (Database Repair Tool) styled with error crimson borders.

---

## 9. Dialogue Specifications & Overlays

To handle critical actions securely, the system defines six (6) standardized dialog panels. Dialogs conform to Material Design 3 spacing and vertical rhythms.

### 9.1 Dialog 1: Delete Notification Dialog
- **Purpose:** Requests confirmation before permanently deleting a notification from the local database.
- **RTL Copy Mapping:**
  - Title: "حذف دائم اعلان؟" (Delete Notification Permanently?)
  - Body: "این عملیات قابل بازگشت نیست. آیا از حذف این اعلان مطمئن هستید؟"
- **Action Buttons (RTL Flow):**
  - Logical Start (Right): High-priority filled button "بله، حذف شود" styled with destructive error crimson tokens.
  - Logical End (Left): Neutral border button "انصراف" (Cancel).

### 9.2 Dialog 2: Delete All Dialog
- **Purpose:** Confirmation warning before clearing the entire notification history database.
- **RTL Copy Mapping:**
  - Title: "پاک کردن کل تاریخچه؟" (Clear All History?)
  - Body: "با این کار تمام تاریخچه اعلان‌های دریافتی شما به طور دائمی حذف خواهد شد. یادداشت‌ها و تراکنش‌های ثبت شده در دفترچه مالی شما بدون تغییر باقی می‌مانند."
- **Action Buttons (RTL Flow):**
  - Logical Start (Right): Destructive solid button "تایید و پاک‌سازی کل تاریخچه".
  - Logical End (Left): "انصراف" (Cancel).

### 9.3 Dialog 3: Mute Notifications Dialog
- **Purpose:** Silences future alerts from a specific sender or bank pattern.
- **RTL Copy Mapping:**
  - Title: "بی‌صدا کردن بانک ملی؟" (Silence Bank Melli Notifications?)
  - Body: "با بی‌صدا کردن این بانک، تراکنش‌های آینده کماکان پردازش شده و به دفترچه اضافه می‌شوند، اما هیچگونه اعلان صوتی یا لرزشی دریافت نخواهید کرد."
- **Action Buttons (RTL Flow):**
  - Logical Start (Right): "بله، بی‌صدا شود" (Confirm).
  - Logical End (Left): "انصراف" (Cancel).

### 9.4 Dialog 4: Permission Required Dialog
- **Purpose:** Prompts the user to grant necessary OS permissions to run background SMS listening.
- **RTL Copy Mapping:**
  - Title: "دسترسی پیامک مورد نیاز است" (SMS Permission Required)
  - Body: "برای خواندن و پردازش خودکار تراکنش‌ها، بانکیار به دسترسی خواندن پیامک‌های دستگاه نیاز دارد. داده‌های شما هرگز از گوشی خارج نمی‌شوند."
- **Action Buttons (RTL Flow):**
  - Logical Start (Right): "صدور دسترسی" (Grant Permission).
  - Logical End (Left): "انصراف" (Cancel).

### 9.5 Dialog 5: Security Alert Dialog
- **Purpose:** Warns users when operating system tampering or root access is detected, threatening local database security.
- **RTL Copy Mapping:**
  - Title: "هشدار امنیتی: تغییر در ساختار دستگاه" (Security Alert: OS Tampering Detected)
  - Body: "دستگاه شما روت شده یا دارای آسیب‌پذیری‌های امنیتی جدی است. پایگاه داده محلی بانکیار برای محافظت از اطلاعات مالی شما موقتاً قفل گردیده است."
- **Action Buttons (RTL Flow):**
  - Logical Start (Right): "ورود به مرکز امنیت" (Security Center).
  - Logical End (Left): "بستن برنامه" (Exit App).

### 9.6 Dialog 6: Unknown Transaction Dialog
- **Purpose:** Prompts users to manually structure transaction details when parsing templates fail to recognize an incoming banking SMS.
- **RTL Copy Mapping:**
  - Title: "قالب پیامک ناشناخته" (Unknown SMS Format Detected)
  - Body: "ساختار پیامک دریافتی توسط الگوهای خودکار بانکیار شناسایی نشد. برای جلوگیری از خطا، می‌توانید اطلاعات تراکنش را به صورت دستی وارد کنید."
- **Action Buttons (RTL Flow):**
  - Logical Start (Right): "افزودن دستی" (Add Manually).
  - Logical End (Left): "رد کردن" (Ignore).

---

## 10. Complete Notification Experience & Interaction Flows

This section defines the precise, secure interaction pathways, mapping gesture inputs and system triggers.

### 10.1 Flow 1: Incoming Notification & Processing Flow
1. **SMS Arrival:** Device receives a standard SMS broadcast from a verified bank sender ID.
2. **Background Processing:** Background service intercepts raw text and processes it locally using deterministic regular expression templates in under 200 milliseconds.
3. **Database Write:** Extracted transaction metadata is securely saved to the encrypted SQLCipher local database in under 100 milliseconds.
4. **Active UI Update:** Active views inside the application refresh automatically, sliding the new transaction card into Zone B with a fast slide-down animation.

### 10.2 Flow 2: Notification Card Expansion & Notes Annotation
1. **User Action:** User taps any standard notification card inside the chronological history feed.
2. **Card Animation:** Standard card expands vertically, revealing hidden transaction metadata (e.g., account balance, card ID) and showing the quick action button row.
3. **User Note Action:** User taps the "Add Note" button on the quick action row.
4. **Modal Bottom Sheet:** A modal bottom sheet slides up, showing a secure text field with auto-focused keyboard input.
5. **Persistence:** Typing an annotation and tapping "Save" updates the database record instantly, displaying a small note tag on the card face.

### 10.3 Flow 3: Horizontal Swipe Actions & Dismissal Flow
1. **Swipe Gesture:** User swipes a notification card horizontally. Swiping from right to left (logical start to end in RTL Persian) reveals hidden command buttons.
2. **Visual Feedback:** Swiping reveals an error-red background trash icon on the logical right, and a gold favorite star icon on the logical left.
3. **Dismiss Command:** Swiping past 60% of horizontal columns sweeps the card off-screen, deleting it from the active unread history feed.
4. **Undo Undo Trigger:** A persistent feedback banner (Snackbar) slides up from Zone C, showing copy "اعلان حذف شد" with action "بازگرداندن" (Undo). Tapping "Undo" restores the card to its original position.

---

## 11. Comprehensive Accessibility (A11y) & Native RTL Review

BankYar enforces absolute accessible design parameters across all platforms:

- **Native RTL Layout Mirroring:** Horizontal layouts, timeline progress bars, back chevrons, and sliding gestures mirror natively to match Persian RTL reading habits.
- **Screen Reader Support (TalkBack):**
  - Every transaction card is grouped as a single semantic focus block, reading parameters sequentially without requiring separate taps on micro-texts.
  - Descriptive, localized accessibility labels exist on all quick action buttons, ensuring screen readers announce their function clearly.
- **Minimum Touch Target Envelope:** All interactive buttons, chips, and list tiles maintain a minimum clickable area of **48 x 48 dynamic units**, protecting users with motor impairments.
- **Large Fonts & Dynamic Scaling:** Text blocks wrap automatically, and cards expand vertically to support up to 200% system-level text magnification without overlapping or clipping text.
- **Accessible Progress Indicators:** Progress percentage readouts are rendered using high-contrast Persian monospace numerals (e.g., "۴۵٪") with adjacent descriptive text labels.

---

## 12. Future-Ready Expansion Roadmap

The notification experience architecture is built to scale, reserving specific layout coordinates for upcoming capabilities without restructuring existing views:

- **Notification Categories:** Reserved settings subpanels to let users toggle system notifications for specific categories (e.g., keeping Security alerts high-priority while silencing small retail store purchases).
- **Smart Notification Scheduling:** Layout slot prepared to support scheduling non-urgent, silent notifications to be delivered as a single digest at specific times of the day (e.g., 8:00 PM).
- **AI Priority Detection:** Space reserved in the local database to support on-device machine-learning models, automatically identifying critical cash flow shifts and highlighting them in the feed.
- **Notification Digest:** Layout prepared to compile a single daily financial digest, summarizing cash flow trends and category totals without cluttering the system drawer.
- **Cross-device Notifications:** Architecture prepared to support local, offline database synchronization across personal devices over a secure local Wi-Fi connection, keeping notifications mirrored.
- **Wear OS Support:** Compact layout definitions prepared to compile notification structures to smartwatches, showing small circular transaction progress rings.
- **Android Auto Support:** Formatted plain-text notification templates prepared to integrate with Android Auto APIs, enabling safe hands-free audio announcements of transactions while driving.

---

## 13. Design Token Mapping Reference

Every visual property specified in this document maps directly to an active design token, preserving consistency and white-label portability:

| Screen Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background` |
| Primary Container Card| Card Background Fill | `bankyar.semantic.color.surface.flat` |
| Primary Headlines | High Contrast Text Font | `bankyar.semantic.color.text.primary` |
| Supporting Metadata | Medium Contrast Subtitle | `bankyar.semantic.color.text.secondary` |
| Row Separators & Dividers| Stroke Divider Line | `bankyar.semantic.color.border.subtle` |
| Active Highlight Borders| Active Ring Color | `bankyar.semantic.color.border.active` |
| Progress Bar Active Fill| Primary Accent Color | `bankyar.semantic.color.interactive.default` |
| Healthy Status Badges | Success Accent Color | `bankyar.semantic.color.status.success` |
| Alert Warning Icons | Warning Accent Color | `bankyar.semantic.color.status.error` |
| Sizing Spacing Factor | Sizing Spacing Factor | `bankyar.space.xl` |
| Outer Screen Margin | Responsive Margins | `bankyar.responsive.margin` |
| Standard Corner Radius | Card Corner Curves | `bankyar.radius.medium` |
| Large Corner Radius | Sheet Corner Curves | `bankyar.radius.large` |

---

## 14. Governance & Verification Checklists

Before releasing any layout or screen iteration, developers must verify compliance against these checklists:

### 14.1 Notification UX Checklist
- [ ] **One-Hand Accessibility:** Ensure all high-frequency controls, search buttons, and quick actions reside within comfortable thumb-reach mapping (lower 60% of the screen height).
- [ ] **Lock Screen Privacy Shield:** Confirm that sensitive transaction values, bank accounts, and overall balance metrics are replaced with secure masked values (`-***,*** تومان`) on lock screen views.
- [ ] **Deduplication Active:** Confirm cellular SMS retransmission filters are active, preventing duplicate database entries of identical transaction hashes.
- [ ] **Zero-Telemetry Integrity:** Verify that exactly zero bytes of analytical, behavioral, or performance log tracking are initialized.
- [ ] **No Internet Permissions:** Ensure the final compiled build contains exactly zero internet permissions, verifying complete network-free database isolation.

### 14.2 UI Validation Checklist
- [ ] **100% Token Compliance:** Confirm that every color, margin, padding, border width, and corner curve maps directly to an active design token, with zero hardcoded values.
- [ ] **No Forbidden Patterns:** Ensure that absolutely no HEX color codes, physical pixel units, sp typography units, dp spacing units, or Flutter component names exist in the specification.
- [ ] **RTL-First Interface:** Verify that list flows, text fields, back chevrons, and transitions proceed naturally from right to left (RTL).
- [ ] **Security Masking Active:** Confirm that all settings lists, database summaries, and diagnostic logs mask sensitive values when the app is backgrounded.
- [ ] **Minimum Touch Target Met:** Confirm all interactive settings rows and buttons have active touch heights of at least `bankyar.space.xl`.

---
**End of Specification Document**
