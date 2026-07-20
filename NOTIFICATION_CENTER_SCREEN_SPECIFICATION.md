# BankYar Notification Center & Experience Specification (v1.0.0)
## Enterprise-Grade Screen & Interaction Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Framework Target:** Flutter (Platform-Agnostic Design Blueprint)
**Platform Target:** Android (RTL-Native Layouts with Android System Integration)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Status:** Approved / Core Specification Blueprint

---

## 1. Executive Summary

This document establishes the absolute visual, spatial, and interaction design specifications for the **Notification Center & Experience System** in the BankYar ecosystem. In an offline-first, privacy-first personal finance platform, notifications are not merely alert banners—they represent the primary, highly secure, real-time feedback loop between on-device automation (such as SMS interception) and active user awareness.

Operating with zero internet access and 100% on-device cryptography, BankYar’s notifications must feel premium, trustworthy, incredibly lightweight, and completely unobtrusive. This specification covers both **In-App Notifications (Notification Center, History, and Details)** and **System Notifications (Android Status Bar, Lock Screen, and Heads-Up Alerts)**, providing a cohesive, seamless journey.

In strict compliance with BankYar’s Level 0 Engineering and Visual Design Constitutions:
- **Zero Framework Code:** All layouts, sequences, and structures are platform-independent, with zero Flutter/Dart implementation details.
- **Zero Raw Styling Metrics:** Hardcoded dimensions (pixels, dp, sp, milliseconds) are strictly prohibited. All dimensions and spatial gaps map directly to abstract design tokens (`bankyar.space.*`, `bankyar.radius.*`, etc.).
- **Zero Hardcoded Colors:** No raw HEX color codes are permitted. Every visual surface, status indicator, and typography layer references semantic tokens that adapt dynamically between Light, Dark, and High-Contrast modes.
- **RTL-First Structure:** Horizontal reading paths, vertical grids, swipe gestures, and transitions mirror natively to support Persian RTL workflows from the logical start edge (right) to the logical end edge (left).
- **No Development Markers:** Absolutely no incomplete tags, temporary draft marks, or un-resolved sections exist. All details are fully specified and production-ready.

---

## 2. Design Philosophy & Vision

The BankYar Notification system is engineered to deliver a calm, precise, and empowering financial assistant directly in the user's pocket, minimizing financial anxiety while protecting absolute privacy.

* **Information Clarity & Stoic Beauty:** Consistent with `DESIGN_PHILOSOPHY.md`, notifications utilize a clean, highly structured, minimal style. They prioritize clear typographical hierarchies and comfortable white space to allow instant scanning of numerical and technical alerts.
* **Calm & Unobtrusive Interactions:** Financial events can occur at any time. The system classifies alerts strictly into priority-based buckets, ensuring that daily transaction monitoring remains silent and lightweight, while security anomalies instantly capture attention.
* **Psychological Trust & Security:** In an offline architecture, user trust is the primary asset. By implementing an uncompromising local-only data privacy shield (blurring sensitive values, hiding amounts on the lock screen, and requiring local authentication before viewing), BankYar guarantees that financial secrets are kept strictly private on the physical device.
* **Frictionless Actionability:** Notifications are highly functional. Rather than being passive messages, they provide instant on-device actions (e.g., adding a note, starring a transaction, or retrying a parsing template) directly from the drawer, removing the need to launch the full application.

---

## 3. Spatial Rhythm & Grid Architecture

All visual configurations inside the Notification Center and on-device alert templates conform strictly to the BankYar dynamic 8-unit spatial layout grid, guaranteeing geometric alignment, vertical continuity, and physical comfort.

### 3.1 Horizontal Grid System
- **Compact Viewport (Smartphones):** 4 columns. Symmetrical outer margins are mapped to `bankyar.responsive.margin` (resolving to `bankyar.space.lg` on mobile). Inter-column gutters are bound to `bankyar.responsive.gutter` (`bankyar.space.md`).
- **Medium Viewport (Tablets / Foldables):** 8 columns. Master-detail horizontal splitting. Symmetrical margins scale up to `bankyar.space.xl` and gutters to `bankyar.space.lg`.
- **Expanded Viewport (Landscape / Large Tablets):** 12 columns. Content columns are constrained to `bankyar.responsive.container.width.max` to prevent uncomfortably wide, stretched cards.

### 3.2 Vertical Baseline Rhythm
Every component height, list margin, inner padding, and typographical leading is an exact integer multiple of the baseline spatial multiplier token `bankyar.global.space.base`.
- `bankyar.space.xxs` (0.25x base unit, for subtle status dots, unread indicators, and badge alignments)
- `bankyar.space.xs` (0.5x base unit, for tight inline spacings, icons next to text labels, and action labels)
- `bankyar.space.sm` (1x base unit, for field labels, section titles, and minor component gaps)
- `bankyar.space.md` (2x base unit, for default internal card padding and vertical list gaps)
- `bankyar.space.lg` (3x base unit, for outer screen margins, screen divisions, and section headers)
- `bankyar.space.xl` (4x base unit, for primary action buttons, bottom navigations, and custom touch heights)
- `bankyar.space.xxl` (6x base unit, for empty state illustrations and large vertical offsets)

---

## 4. Layout Zones & Structural Layout

The in-app Notification Center is constructed using the logical three-zone vertical layout model, ensuring that system navigation, scrolling history feeds, and persistent diagnostic statuses remain perfectly separated.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY NOTIFICATION CENTER HEADER & CONTROL BAR]              |
|  +-------------------------------------------------------------------+  |
|  | [Clear All Trigger]      { Notification Center }      [Back Chevron]|  |
|  | [Scrollable RTL Grouping & Filter Chips Row]                      |  |
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
|  |  [Region 2: Active / Unread Notifications Feed (Grouped)]         |  |
|  |     [Section Header: Today / Bank Melli]                          |  |
|  |     - Transaction Expense Card (Unread, amount high-contrast)     |  |
|  |     - Transaction Income Card (Unread, success colored)           |  |
|  |                                                                   |  |
|  |  [Region 3: Notification History Feed (Read / Archived)]          |  |
|  |     [Section Header: Yesterday / Older]                           |  |
|  |     - Backup Completed Card (Read, muted metadata)                |  |
|  |     - Failed Parsing Card (Read, showing retry trigger)           |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: PERSISTENT CONTROLS & SYSTEM DIAGNOSTICS]                     |
|  +-------------------------------------------------------------------+  |
|  | [Offline Privacy Status Badge: "آفلاین و امن - بدون اتصال شبکه"]  |  |
|  | [Shell Bottom Navigation Bar]                                     |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## 5. Screen Regions & Spatial Scaffolding

### 5.1 Zone A: Sticky Notification Center Header & Controls
- **Visual Presentation:** Stays pinned at the top of the viewport. Standard background blends with the canvas background in its default state, showing a thin separator line `bankyar.semantic.color.border.subtle` when scrolling content moves underneath.
- **RTL Composition:**
  - **Logical Start Edge (Right):** Native back chevron icon `bankyar.icon.back.rtl` directing the user back to the Home Dashboard.
  - **Center Block:** Page title "مرکز اعلان‌ها" (Notification Center) styled with `bankyar.semantic.typography.title.sm` in high-contrast primary text color.
  - **Logical End Edge (Left):** Contextual "پاک کردن همه" (Clear All) text button styled in secondary text color, letting users dismiss or mark all readable notifications as read in a single tap.
- **Region 2: Horizontal Grouping & Filter Row (RTL Flow):**
  - Horizontally scrollable row of choice selection chips positioned directly beneath the header title.
  - **RTL Flow:** Flows from right to left, fading smoothly into the logical end (left) edge using a translucent gradient overlay.
  - **Filter Chips:** Pinned "فیلتر پیشرفته" (Advanced Filter) icon chip on the right, followed by "همه" (All), "خوانده نشده" (Unread), "تراکنش‌ها" (Transactions), "پشتیبان‌گیری" (Backup), "امنیتی" (Security), and "سیستم" (System).

### 5.2 Zone B: Scrollable Notification Workspace & History
- **Visual Presentation:** Dynamic vertically scrollable viewport that displays active notifications, chronological history, or a beautiful empty state.
- **Region 1: Pinned Notifications & Active Warnings:**
  - Placed at the top of Zone B, separated from Zone A by `bankyar.space.md`.
  - Displays high-priority, pinned system notifications (e.g., active permission locks, root security warnings, or running background sync tasks).
- **Region 2: Grouped Notification Feed:**
  - Chronological grouped sections separated by `bankyar.space.lg`.
  - Supports logical double-column master-detail splitting on wide displays.
- **Region 3: Historical Archives:**
  - Separated from active alerts by a clean horizontal divider. Displays read or archived alerts in a highly muted visual presentation.

### 5.3 Zone C: Persistent Navigation & System Diagnostics
- **Visual Presentation:** Stays pinned at the bottom of the screen.
- **Core Elements:**
  - **Offline Diagnostics Status:** Centered small label "آفلاین و امن - رمزنگاری شده در دستگاه" (Offline & Secure - Encrypted on device) demonstrating 100% network-free operation.
  - **Shell Bottom Navigation Bar:** Symmetrical 4-tab navigation bar providing rapid routing back to Dashboard, Analytics, Rules, and Settings.

---

## 6. Detailed Component Specifications

### 6.1 Interactive Notification Card Component
The primary container card displaying structured notification metadata inside the app or inside system drawers.

```
+--------------------------------------------------------------------------+
| (Right Edge - Start)                                  (Left Edge - End)  |
| [Unread Indicator]  [Bank/Category Icon]  Bank Name      Timestamp       |
|                     Notification Title String             [Pin Icon]     |
|                                                                          |
|                     Notification Message Text Content                    |
|                     Amount Display (Credit/Debit)                        |
|                                                                          |
|  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  |
|                                                                          |
| [Action Button 1 (RTL)]              [Action Button 2 (RTL)]             |
+--------------------------------------------------------------------------+
```

1. **Unread Indicator Dot:** Centered vertically on the right (start) edge of the card. A small circular dot styled with primary brand accent `bankyar.semantic.color.status.error` and radius `bankyar.radius.full`, measuring `bankyar.space.xxs` in size. Removed instantly when marked as read.
2. **Bank / Category Icon Frame:** Sized to `bankyar.icon.size.md` inside a flat circular container using `bankyar.radius.full`. Shows flat, high-contrast symbols representing the bank or notification class.
3. **Sender / Source Name Title:** Aligned adjacent to the icon. Persian text (e.g. "بانک ملی ایران" or "پشتیبان سیستم") in bold title font `bankyar.semantic.typography.title.xs` using primary text token.
4. **Timestamp Block:** Aligned to the logical end (left) edge. Renders Persian monospace characters (e.g., "۱۴:۳۲" or "دیروز") in low-contrast secondary text color.
5. **Notification Title String:** Bold headline text situated below the top meta row. Styled with standard subtitle typography `bankyar.semantic.typography.body.md` using `bankyar.font.weight.bold`.
6. **Notification Message Body:** Multi-line text block describing the event in clear, supportive language. Styled in standard body font `bankyar.semantic.typography.body.sm` in secondary text color, with line-height set to `bankyar.font.leading.loose` for readability.
7. **Amount Display Label:** Bold numeric text representing financial values, positioned on the logical start (right) or logical end (left) depending on layout density.
   - **Credit (Inflow):** Positive sign `+` (e.g. "+۱۲۵,۰۰۰ تومان") styled in success green `bankyar.semantic.color.status.success`.
   - **Debit (Outflow):** Negative sign `-` (e.g. "-۴۵,۰۰۰ تومان") styled in standard primary text color `bankyar.semantic.color.text.primary`.
8. **Inner Separator:** Symmetrical dashed border `bankyar.border.style.dashed` separating card content from quick actions row.
9. **Quick Action Buttons Row:** Interactive, low-height text buttons aligned to the right (logical start). Sized to meet standard touch boundaries without overlapping.

### 6.2 Grouped Notification Capsule
- **Purpose:** Compresses multiple related notifications from the same sender or date into a single, clean visual stack.
- **Visual Presentation:** Displays the primary (latest) notification card on top, overlaid with overlapping, offset border frames beneath, simulating a physical pile of cards.
- **Interactions:** Tapping the stack triggers a smooth expand animation `bankyar.motion.curve.standard` spreading the nested cards vertically with standard gap spacings.

### 6.3 Pinned Notification Alert Panel
- **Purpose:** Displays high-priority system alerts (such as security warnings or active background optimizations) that cannot be dismissed until resolved.
- **Visual Style:** Rounded rectangle container using `bankyar.radius.medium` with thick boundary strokes `bankyar.border.width.thick` colored in semantic warning or error status tokens.
- **Accent Strip:** A solid vertical indicator strip positioned strictly at the right (logical start) border edge, matching the alert's severity level.

---

## 7. Notification Templates Catalog

To guarantee visual consistency, accessibility, and clean architecture boundaries, the Notification system implements fifteen (15) distinct, pre-designed templates covering every potential system event.

### 7.1 New Bank Transaction Template
- **Category:** Transaction
- **Priority:** Silent (In-app Center) / Default (System Drawer)
- **RTL Typography Mappings:**
  - Title: "تراکنش بانکی جدید" (New Bank Transaction)
  - Body: "تراکنش بانکی جدید از پیامک دریافتی شناسایی شد."
- **Visual Styling & Icons:** Displays the generic bank card outline icon `icon_financial_card_default.svg`. Card border is standard subtle.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Add Note` (افزودن یادداشت).

### 7.2 Income (Credit) Template
- **Category:** Financial Inflow
- **Priority:** Default (System Tray) / High (Biometric Lock Override if Amount is high)
- **RTL Typography Mappings:**
  - Title: "واریز وجه موفق" (Successful Deposit)
  - Body: "مبلغ مشخص شده به حساب شما واریز گردید."
- **Visual Styling & Icons:** Left-pointing arrow icon `icon_financial_income_default.svg` enclosed in a soft green container circle. The cash value utilizes success green text color.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Mark Favorite` (نشان‌گذاری).

### 7.3 Expense (Debit) Template
- **Category:** Financial Outflow
- **Priority:** Default (System Tray)
- **RTL Typography Mappings:**
  - Title: "برداشت وجه موفق" (Successful Withdrawal)
  - Body: "مبلغ مشخص شده از حساب شما برداشت گردید."
- **Visual Styling & Icons:** Right-pointing arrow icon `icon_financial_expense_default.svg` in a neutral gray container circle. Cash value uses standard primary text color.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Add Note` (افزودن یادداشت).

### 7.4 Transfer (P2P Card-to-Card) Template
- **Category:** Transaction Transfer
- **Priority:** Default (System Tray)
- **RTL Typography Mappings:**
  - Title: "کارت به کارت موفق" (Successful P2P Transfer)
  - Body: "انتقال وجه بین بانکی با موفقیت ثبت شد."
- **Visual Styling & Icons:** Reciprocal double horizontal arrows icon `icon_financial_transfer_default.svg`. Uses standard card outlines.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Share Receipt` (اشتراک‌گذاری).

### 7.5 ATM Withdrawal Template
- **Category:** Physical Cash
- **Priority:** Silent (System Tray)
- **RTL Typography Mappings:**
  - Title: "برداشت نقدی از خودپرداز" (ATM Cash Withdrawal)
  - Body: "برداشت نقدی فیزیکی از دستگاه خودپرداز شناسایی شد."
- **Visual Styling & Icons:** Cash stack/ATM machine icon `icon_financial_atm_default.svg`. Card styling is neutral flat.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Add Note` (افزودن یادداشت).

### 7.6 Card Purchase Template
- **Category:** Store Transaction
- **Priority:** Default (System Tray)
- **RTL Typography Mappings:**
  - Title: "خرید فروشگاهی" (Store Purchase)
  - Body: "پرداخت موفق روی پایانه فروشگاهی (POS)."
- **Visual Styling & Icons:** POS terminal or shopping bag outline icon `icon_financial_purchase_default.svg`. Standard semantic border subtle.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Add Note` (افزودن یادداشت), `Mark Favorite` (نشان‌گذاری).

### 7.7 Failed Parsing Template
- **Category:** System Alert (Low Priority Warning)
- **Priority:** High (In-app Warning Feed)
- **RTL Typography Mappings:**
  - Title: "خطا در خواندن پیامک" (SMS Parsing Error)
  - Body: "یک پیامک بانکی دریافت شد اما ساختار آن توسط الگوهای فعلی شناسایی نگردید. جهت تکمیل اطلاعات ضربه بزنید."
- **Visual Styling & Icons:** Broken magnifying glass outline icon `icon_status_failed_default.svg` in low-saturation warning yellow. Card border highlights in soft warning yellow outline.
- **Action Triggers:** `Retry Parsing` (تلاش مجدد), `Add Note` (افزودن دستی).

### 7.8 Duplicate SMS Template
- **Category:** Deduplication Filter (Silent)
- **Priority:** Silent (No status bar alert, logged in In-app Notification History)
- **RTL Typography Mappings:**
  - Title: "پیامک تکراری نادیده گرفته شد" (Duplicate SMS Ignored)
  - Body: "یک پیامک با مشخصات و هش یکسان دریافت و جهت جلوگیری از تکرار اطلاعات، فیلتر گردید."
- **Visual Styling & Icons:** Double overlapping files icon `icon_status_duplicate_default.svg` in highly muted gray opacity.
- **Action Triggers:** `Dismiss` (رد کردن).

### 7.9 Backup Completed Template
- **Category:** Data Protection Success
- **Priority:** Default (System Tray) / Silent (In-app History)
- **RTL Typography Mappings:**
  - Title: "پشتیبان‌گیری موفق" (Backup Completed Successfully)
  - Body: "فایل پشتیبان جدید دیتابیس محلی با موفقیت ایجاد و رمزگذاری گردید."
- **Visual Styling & Icons:** Secure document shield checkmark icon `icon_security_shield_default.svg` in success green.
- **Action Triggers:** `View Details` (مشاهده جزئیات), `Dismiss` (بستن).

### 7.10 Backup Failed Template
- **Category:** Data Protection Warning (High Severity)
- **Priority:** High (System heads-up alert, persistent in in-app warning tray)
- **RTL Typography Mappings:**
  - Title: "پشتیبان‌گیری ناموفق" (Backup Failed)
  - Body: "فضای ذخیره‌سازی محلی دستگاه پر است. لطفاً جهت جلوگیری از خطر از دست رفتن اطلاعات، فضا خالی کنید."
- **Visual Styling & Icons:** Solid warning shield exclamation icon `icon_status_warning_default.svg` in semantic error red.
- **Action Triggers:** `Backup Now` (پشتیبان‌گیری مجدد), `View Logs` (مشاهده گزارش خطا).

### 7.11 Security Warning Template
- **Category:** System Threat (Critical Severity)
- **Priority:** High (Heads-up alert with device vibration pattern, pinned alert panel)
- **RTL Typography Mappings:**
  - Title: "هشدار امنیتی سیستم" (Critical Security System Alert)
  - Body: "احتمال دسترسی غیرمجاز یا تغییر در ساختار امنیتی دستگاه شناسایی شد. دسترسی محلی موقتاً محدود می‌گردد."
- **Visual Styling & Icons:** Solid warning padlock padlock icon `icon_security_lock_default.svg` in high-contrast error red.
- **Action Triggers:** `Security Center` (مرکز امنیت), `Dismiss` (بستن).

### 7.12 Permission Missing Template
- **Category:** System Requirement (High Severity)
- **Priority:** High (Pinned app-header banner, non-dismissible)
- **RTL Typography Mappings:**
  - Title: "دسترسی پیامک صادر نشده است" (SMS Permission Missing)
  - Body: "بدون دسترسی خواندن پیامک، امکان دریافت و پردازش خودکار تراکنش‌ها وجود ندارد. جهت صدور دسترسی ضربه بزنید."
- **Visual Styling & Icons:** Empty envelope next to a small security key icon `icon_status_warning_default.svg` in warning yellow.
- **Action Triggers:** `Grant Permission` (صدور دسترسی), `Open Settings` (تنظیمات گوشی).

### 7.13 Battery Optimization Warning Template
- **Category:** Background Service Health (Medium Severity)
- **Priority:** High (In-app Warning Panel, persistent)
- **RTL Typography Mappings:**
  - Title: "محدودیت مصرف باتری فعال است" (Battery Optimization Restricting Ingestion)
  - Body: "تنظیمات بهینه‌سازی باتری سیستم‌عامل ممکن است باعث بسته شدن سرویس پیش‌زمینه و حذف برخی تراکنش‌ها گردد."
- **Visual Styling & Icons:** Empty battery silhouette with an overlay key icon `icon_status_warning_default.svg` in warning yellow.
- **Action Triggers:** `Ignore Optimization` (غیرفعال‌سازی محدودیت), `Help Guide` (راهنمای گام‌به‌گام).

### 7.14 Database Error Template
- **Category:** Storage Resilience (Critical Severity)
- **Priority:** High (Blocking alert, launches Disaster Recovery Screen)
- **RTL Typography Mappings:**
  - Title: "خطا در خواندن پایگاه داده" (Database Read/Write Error)
  - Body: "ساختار پایگاه داده محلی با مشکل مواجه شده است. لطفاً آخرین فایل پشتیبان امن خود را بارگذاری کنید."
- **Visual Styling & Icons:** Fragmented database cylinder icon `icon_error_database.svg` in high-contrast error red.
- **Action Triggers:** `Restore Backup` (بازیابی پشتیبان), `Retry Repair` (تعمیر خودکار).

### 7.15 Application Update (Future Ready Template)
- **Category:** Software Lifecycle (Silent)
- **Priority:** Silent (No system status bar interruption, logged in Settings & Help Center)
- **RTL Typography Mappings:**
  - Title: "به‌روزرسانی جدید بانکیار" (New Application Version Available)
  - Body: "نسخه جدید بانکیار شامل الگوهای جدید شناسایی بانک‌ها منتشر شد. به‌روزرسانی کاملاً آفلاین و امن است."
- **Visual Styling & Icons:** Clockwise dynamic circular arrow surrounding a package outline `icon_nav_settings_default.svg` in subtle primary brand accent.
- **Action Triggers:** `Go to Download` (دانلود نسخه جدید), `Dismiss` (بستن).

---

## 8. Quick Actions Architecture

To maximize interaction speed, each notification card provides a standardized row of Quick Action Buttons. Quick Actions conform strictly to physical usability guidelines, with zero hardcoded code and absolute pixel density adaptability.

### 8.1 List of Quick Actions & Mappings
1. **View Details (مشاهده جزئیات):** Directs the user to the full Transaction Detail Viewer, loading the raw SMS text, extracted metadata fields, notes, and relational tags.
2. **Add Note (افزودن یادداشت):** Instantly displays a contextual, lightweight bottom sheet overlay featuring a text input field, enabling users to write annotations without leaving the active drawer.
3. **Mark Favorite (نشان‌گذاری):** Toggles the transaction's favorite status. Tapping this fills the star icon instantly using a Gold semantic status color.
4. **Share (اشتراک‌گذاری):** Compiles the extracted transaction parameters into a beautifully structured, plaintext financial statement and launches the native Android Share Sheet, letting the user safely save or send the text.
5. **Dismiss (رد کردن):** Instantly fades the active notification card out of the feed, deleting it from active unread lists.
6. **Open Dashboard (ورود به برنامه):** Launches the application, initiating a biometric challenge and displaying the dashboard.
7. **Retry Parsing (تلاش مجدد):** Re-runs the custom SMS parser templates against the underlying raw SMS body text, updating metadata records in the encrypted SQLite database on a successful match.
8. **Backup Now (پشتیبان‌گیری):** Immediately triggers the local-only database backup pipeline, prompting the user for a password to output an encrypted `.bankyar` file.

### 8.2 Touch Target Compliance
Every action button maintains an invisible physical boundary that meets or exceeds the minimum accessible touch target threshold of **48 dynamic units**, mapped to `bankyar.space.xl` bounds, protecting users with motor impairments.

---

## 9. Multi-Criteria Grouping Models

To keep high-volume alerts structured and easy to scan, the Notification Center supports five (5) programmatic grouping methods. Grouping is processed locally on the encrypted SQLite database using fast indices.

```
+-------------------------------------------------------------------------+
| SELECT GROUPING TYPE:                                                   |
| [Date (تاریخ)]    [Bank (بانک)]    [Type (نوع)]   [Priority (اولویت)]   |
+-------------------------------------------------------------------------+
|  Example Result (Grouped by Bank):                                      |
|  ▼ بانک ملی ایران (Melli Bank Group - 3 Alerts)                          |
|    - -۱۲۵,۰۰۰ تومان (Debit Transaction Card)                            |
|    - +۴۵,۰۰۰ تومان  (Credit Transaction Card)                            |
|  ▼ بانک ملت (Mellat Bank Group - 1 Alert)                                |
|    - -۲,۰۰۰ تومان   (Debit Transaction Card)                            |
+-------------------------------------------------------------------------+
```

### 9.1 Grouping Categories
1. **Date (تاریخ):** Chronological categorization dividing notifications into logical time buckets (e.g., "امروز" - Today, "دیروز" - Yesterday, "هفته گذشته" - Last Week).
2. **Bank (بانک):** Groups alerts by the issuing financial source (e.g., "بانک ملی", "بانک ملت", "بانک صادرات"). Perfect for verifying spending patterns on specific cards.
3. **Transaction Type (نوع تراکنش):** Separates notifications based on cashflow direction, organizing cards into "واریزها" (Deposits/Income), "برداشت‌ها" (Withdrawals/Expenses), and "غیره" (Non-financial system alerts).
4. **Priority (سطح اولویت):** Categorizes notifications by severity: "مهم" (High-priority warnings, root alerts, backup failures) and "عادی" (Silent transactions, background optimizations).
5. **Unread (خوانده نشده):** Groups alerts by read status, placing unread notifications at the top of the feed and collapsing read notifications into a secondary historical list.

---

## 10. Privacy-First Shield Engine

Operating as a secure, offline-first personal finance platform, BankYar implements a robust **Privacy Shield Engine** to prevent local financial exposure on shared devices.

### 10.1 Lock Screen Privacy Options
- **Hide Amount on Lock Screen (مخفی‌سازی مبالغ):** Replaces exact transaction numbers with generic masks on the lock screen (e.g., "-۴۵,۰۰۰ تومان" becomes "-***,*** تومان"). Detailed cash values are only displayed once the device is unlocked.
- **Hide Balance (مخفی‌سازی مانده حساب):** Masks the remaining account balance on system notifications, protecting the user's overall net worth from shoulder surfing.
- **Hide Sensitive Content (مخفی‌سازی اطلاعات حساس):** Replaces detailed bank names and merchant details with neutral, generic text on the lock screen (e.g., "برداشت ۱۲۰,۰۰۰ تومان از بانک ملت" is masked to "تراکنش بانکی ثبت شد").
- **Private Notification Mode (اعلان خصوصی):** A high-security setting that strips all transactional metadata from system notifications, showing only a reassuring, neutral message (e.g., "بانکیار: تراکنش جدید شناسایی شد. جهت مشاهده، برنامه را باز کنید").
- **Unlock Before Viewing (تایید هویت قبل از ورود):** Tapping any system notification requires successful biometric or PIN verification before launching the target screen, protecting local financial files.

---

## 11. Deep-Link Routing Matrix

Deep-link navigation defines the precise, secure routing pathways from notifications to core application sections, wrapping all transitions in biometric challenges to prevent unauthorized local access.

```
                  [System Status Bar / Lock Screen Alert]
                                    │
                                    ▼
                         [User Taps Notification]
                                    │
                                    ▼
                [Active Biometric / PIN Challenge Gate]
                                    │
                                    ├──► (Fails / Cancelled) ──► Lockout / Exit App
                                    │
                                    └──► (Success)
                                          │
                                          ▼
                         [Deep Link Routing Decider]
                                    │
         ┌──────────────────┼──────────────────┼──────────────────┐
         ▼                  ▼                  ▼                  ▼
   [Dashboard]    [Transaction Details] [Backup Center]   [Security Center]
```

### 11.1 Target Routing Paths
- **Dashboard (داشبورد):** Routed from generic transaction notifications or application update logs. Launches the main cashflow summary feed.
- **Transaction Details (جزئیات تراکنش):** Routed from successful income or expense notifications. Launches the Transaction Detail inspector directly, displaying full metadata, the raw SMS text, and annotation options.
- **Backup Center (مرکز پشتیبان‌گیری):** Routed from Backup Completed or Backup Failed alerts. Directs the user to the backup status card and device storage progress displays.
- **Security Center (مرکز امنیت):** Routed from security warnings, root detections, or environment alerts. Launches the centralized Security & Privacy Center to help the user resolve issues.
- **Settings (تنظیمات):** Routed from missing permissions or battery optimization warnings, directing the user to the relevant settings card to resolve the issue.

---

## 12. Dynamic Interaction States Mapping

Components adjust their visual layers dynamically based on system states, supporting seamless transitions and providing clear visual feedback:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed | Accessibility Action (TalkBack Map) |
| :--- | :--- | :--- | :--- |
| **Unread (خوانده نشده)** | High-contrast card borders. A red status dot is displayed on the logical start (right) edge. Title text is bold. | Default loaded state | TalkBack announces: *"اعلان خوانده نشده. [محتوای پیام]."* |
| **Read (خوانده شده)** | Status dot fades out. Background container opacity desaturates by -1 step. Typography shifts to secondary contrast. | Smooth fade `bankyar.motion.duration.fast` | TalkBack announces: *"اعلان خوانده شده. [محتوای پیام]."* |
| **Pinned (سنجاق شده)** | Card borders highlight with thick warning outlines. Displays a pinned pin icon `icon_nav_star_active.svg` at the top edge. Dismiss swipe gestures are blocked. | Instant load | TalkBack announces: *"اعلان سنجاق شده سیستم. غیرقابل حذف."* |
| **Archived (بایگانی شده)**| Removed from the active unread list and collapsed into a secondary history list below. Card contrast is minimized. | Slide-down transition `bankyar.motion.duration.medium` | TalkBack announces: *"به بایگانی منتقل شد."* |
| **Dismissed (حذف شده)**| Card sweeps off the screen on the horizontal axis (RTL swipe flows right to left) and fades to zero opacity. | Decelerated sweep `bankyar.motion.duration.fast` | TalkBack announces: *"اعلان حذف شد."* |
| **Loading (بارگذاری)**| Transaction cards are replaced by shimmering skeleton blocks, sweeping from right to left (RTL) inline with regional reading habits. | Continuous linear shimmer loop | TalkBack announces: *"در حال بارگذاری مرکز اعلان‌ها..."* |
| **Offline (آفلاین)** | A green status badge remains active in the sticky footer, confirming secure connection-free database operation. | Static display | TalkBack announces: *"وضعیت آفلاین و امن فعال است."* |
| **Error (خطا)** | Card borders turn red. Shows warning icon `icon_status_failed_default.svg` with red alert subtext. | Horizontal axis shake on launch | High-priority TalkBack alert: *"خطا در اجرای فرآیند."* |
| **Permission Missing**| Action buttons display a yellow warning icon with helper text, prompting the user to grant permissions. | Fast slide-down | Prominent warning is read immediately to screen readers. |

---

## 13. Responsive Form Factors & Viewport Configurations

The Notification Center and alert templates adapt dynamically to preserve visual balance across different device sizes:

### 13.1 Phone Viewport
- **Visual Grid:** Single-column layout. Standard margins and paddings are applied to maximize readable area.
- **Interactive Sheets:** Quick Actions (such as "Add Note") open a bottom modal sheet spanning 100% of horizontal columns. Persistent Bottom Navigation remains visible in Zone C.

### 13.2 Large Phone Viewport
- **Visual Grid:** Expanded spacing between cards and sections. Card padding is slightly increased to support comfortable touch targets.
- **Interactive Sheets:** Bottom modal sheets restrict their maximum width to 480 dynamic units to prevent excessive stretching.

### 13.3 Tablet Viewport (Split Pane View)
- **Layout Architecture:** Splits the screen into a balanced, dual-pane layout:
  - **Right Panel (Logical Start - 40%):** Sticky Filter Bar, Grouping categories, and Notification summary cards.
  - **Left Panel (Logical End - 60%):** Full Notification Detail inspector and direct Settings toggles side-by-side, removing the need for a modal bottom sheet.
- **Navigation:** Persistent Bottom Navigation is replaced with a lateral Navigation Rail on the right edge.

### 13.4 Foldable Viewport (Hinge Aware)
- **Layout Architecture:** Detects physical hinge coordinates:
  - **Folded State:** Displays standard compact single-column phone layout.
  - **Unfolded State:** Automatically splits the layout, displaying the grouped notification feed on the right fold, and details or quick actions on the left fold.

### 13.5 Landscape Viewport
- **Layout Architecture:** Vertical header and app bar heights are compacted to maximize vertical space. Quick Actions row is arranged horizontally next to the message body.

---

## 14. Accessibility & Inclusive Design Integration

To ensure the notification experience is accessible to everyone, the interface incorporates strict accessibility features:

- **Native RTL Layout Flow:** All horizontal layouts, progress bars, back chevrons, and transitions proceed naturally from right to left (RTL). Swipe gestures are mirrored naturally.
- **Screen Reader Support (TalkBack):**
  - Transaction notifications are grouped into single semantic nodes, letting TalkBack read each card as a single focus block (e.g., "بانک ملی، پرداخت موفق، مبلغ منفی چهل و پنج هزار تومان، دوازدهم دی ماه، دارای یادداشت").
  - Interaction buttons have permanent, descriptive labels positioned outside the container, ensuring screen readers can announce their purpose clearly.
- **Minimum Touch Target Envelope:** All interactive buttons, chips, and list tiles maintain a minimum clickable area of **48 x 48 dynamic units**, protecting users with motor impairments.
- **Large Fonts & Dynamic Scaling:** Text blocks wrap automatically, and cards expand vertically to support up to 200% system-level text magnification without overlapping or clipping text.
- **Accessible Progress Indicators:** Progress percentage readouts are rendered using high-contrast Persian monospace numerals (e.g., "۴۵٪") with adjacent descriptive text labels.

---

## 15. Future-Ready Expansion Roadmap

The notification architecture is built to scale, reserving specific layout coordinates for upcoming capabilities without restructuring existing views:

- **Notification Categories:** Reserved settings subpanels to let users toggle system notifications for specific categories (e.g. keeping Security alerts high-priority while silencing small retail store purchases).
- **Smart Notification Scheduling:** Layout slot prepared to support scheduling non-urgent, silent notifications to be delivered as a single digest at specific times of the day (e.g., 8:00 PM).
- **AI Priority Detection:** Space reserved in the local database to support on-device machine-learning models, automatically identifying critical cash flow shifts and highlighting them in the feed.
- **Notification Digest:** Layout prepared to compile a single daily financial digest, summarizing cash flow trends and category totals without cluttering the system drawer.
- **Cross-device Notifications:** Architecture prepared to support local, offline database synchronization across personal devices over a secure local Wi-Fi connection, keeping notifications mirrored.
- **Wear OS Support:** Compact layout definitions prepared to compile notification structures to smartwatches, showing small circular transaction progress rings.
- **Android Auto Support:** Formatted plain-text notification templates prepared to integrate with Android Auto APIs, enabling safe hands-free audio announcements of transactions while driving.

---

## 16. Design Token Mapping Reference

Every visual property specified in this document maps directly to an active design token, preserving consistency and white-label portability:

| UI Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background` |
| Primary Container Card| Card Background Fill | `bankyar.semantic.color.surface.flat` |
| Notification Title Text | High Contrast Text Font | `bankyar.semantic.color.text.primary` |
| Metadata & Timestamps | Medium Contrast Text | `bankyar.semantic.color.text.secondary` |
| Row Separators & Dividers| Stroke Divider Line | `bankyar.semantic.color.border.subtle` |
| Active Highlight Borders| Active Ring Color | `bankyar.semantic.color.border.active` |
| Success Status Text | Success Accent Color | `bankyar.semantic.color.status.success` |
| Warning / Error Indicators | Error Accent Color | `bankyar.semantic.color.status.error` |
| Icon Standard Sizing | Icon Sizing Scale | `bankyar.icon.size.md` |
| Screen Outer Margin | Outer Spacing Factor | `bankyar.responsive.margin` |
| Standard Corner Radius | Card Corner Curves | `bankyar.radius.medium` |
| Sheet Corner Radius | Sheet Corner Curves | `bankyar.radius.large` |
| Base Spacing Increment | Base Spacing Increment | `bankyar.global.space.base` |

---

## 17. Governance & Quality Rules Validation Checklist

Before releasing any layout or screen iteration, developers must verify compliance against this checklist:

- [ ] **100% Token Compliance:** Confirm that every color, margin, padding, border width, and corner curve maps directly to an active design token, with zero hardcoded values.
- [ ] **No Forbidden Patterns:** Ensure that absolutely no HEX color codes, physical pixel units, sp typography units, dp spacing units, or Flutter component names exist in the specification.
- [ ] **RTL-First Interface:** Verify that list flows, text fields, back chevrons, and transitions proceed naturally from right to left (RTL).
- [ ] **Security Masking Active:** Confirm that all transaction numbers, bank card IDs, and financial totals are masked with secure overlays when lock screen privacy features are enabled.
- [ ] **Minimum Touch Target Met:** Confirm all interactive quick action buttons have active touch heights of at least `bankyar.space.xl`.

---
**End of Specification Document**
