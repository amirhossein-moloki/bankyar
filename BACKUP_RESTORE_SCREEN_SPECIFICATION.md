# BankYar Backup & Restore Center Screen Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, Senior UX Architect, Material Design 3 Expert, Flutter UI Architect, Data Protection Specialist, Android Storage Consultant, Enterprise FinTech Design Director
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Backup & Restore Center is the central security, portability, and resilience vault of an offline-first, private personal finance platform. Operating under strict on-device data sovereignty boundaries (zero network permissions, zero cloud trackers, and complete local SQLCipher encryption), users must have a foolproof, high-confidence way to manage, export, and restore their financial database.

This specification establishes the absolute visual, spatial, and interaction design of the **Backup & Restore Center** under native **Persian (RTL)** layouts. Built strictly on **Material Design 3 (MD3)** systems, the design features premium financial styling, comfortable vertical rhythms, zero hardcoded values (colors, measurements, animations), and complete inclusive accessibility.

---

## Screen Blueprint & Spatial Mapping

The Backup & Restore Center utilizes the logical three-zone vertical layout model. All elements, progress indicators, action grids, and lists mirror natively to support Persian RTL workflows from the logical start edge (right) to the logical end edge (left).

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY APP BAR]                                               |
|  +-------------------------------------------------------------------+  |
|  | [Info Trigger]           [Screen Title]              [Back Chevron] |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & BACKUP SECTIONS]                       |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 1: Data Protection & Sovereignty Alert]                  |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | Shield Icon | All backups are encrypted. No cloud sync|     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 2: Backup Status Overview Card]                          |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | [Health Indicator]  آخرین پشتیبان‌گیری موفق: دیروز      |     |  |
|  |     | اندازه: ۲.۴ مگابایت | نسخه دیتابیس: ۱ | سلامت: ۱۰۰٪   |     |  |
|  |     | فضا: ۷۲٪ خالی (نمودار میله‌ای مصرف حافظه گوشی)          |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 3: Quick Actions Grid]                                   |  |
|  |     [ایجاد فایل پشتیبان]                [بازیابی اطلاعات]           |  |
|  |     [خروجی رمزنگاری شده]                [بررسی سلامت فایل]          |  |
|  |     [اشتراک‌گذاری فایل]                  [حذف فایل پشتیبان]          |  |
|  |                                                                   |  |
|  |  [Region 4: Backup History List]                                  |  |
|  |     [عنوان بخش: تاریخچه پشتیبان‌گیری]                              |  |
|  |     - پشتیبان‌گیری دستی | ۱۴۰۲/۱۰/۱۲ - ۱۴:۳۲ | ۲.۴ مگابایت | سالم     |  |
|  |     - پشتیبان‌گیری دوره‌ای| ۱۴۰۲/۱۰/۰۵ - ۰۸:۰۰ | ۲.۲ مگابایت | سالم     |  |
|  |                                                                   |  |
|  |  [Region 5: Export / Import Operations]                           |  |
|  |     - صادرات امن دیتابیس به حافظه خارجی                             |  |
|  |     - بارگذاری دستی فایل پشتیبان (.bankyar)                       |  |
|  |                                                                   |  |
|  |  [Region 6: Recovery Information & Emergency Recovery]            |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | وضعیت کلید امنیتی: فعال | الگوریتم: AES-GCM-256         |     |  |
|  |     | [دکمه: نمایش پین بازیابی اضطراری]                             |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: CONTROL & NAVIGATION]                                         |
|  +-------------------------------------------------------------------+  |
|  | [Persistent Bottom Navigation Bar]                                |  |
|  | [تراکنش‌ها]             [نمودارها]             [قوانین]   [تنظیمات]* |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## Core Design & Spatial Principles

The Backup & Restore Center conforms strictly to BankYar's unified spatial layout grid to guarantee absolute geometric consistency and visual comfort on all form factors.

### 1. Horizontal Grid System
* **Compact Viewport (Smartphones):** 4 columns. Symmetrical outer margins are bound to the token `bankyar.responsive.margin` (mapping to `bankyar.space.lg` on mobile). Inter-column gutters are bound to `bankyar.responsive.gutter` (`bankyar.space.md`).
* **Medium Viewport (Tablets / Foldables):** 8 columns. Master-detail horizontal splitting. Symmetrical margins are bound to `bankyar.space.xl` and gutters to `bankyar.space.lg`.
* **Expanded Viewport (Landscape / Large Tablets):** 12 columns. Content columns are constrained to `bankyar.responsive.container.width.max` to prevent uncomfortably long reading lines.

### 2. Vertical Rhythm & Baseline Grid
* **Base Spatial Multiplier:** All vertical gaps, list margins, component heights, and text line-height leadings are exact integer multiples of the baseline token `bankyar.global.space.base`.
* **Standard Spatial Increments:**
  - `bankyar.space.xxs` (0.25x base unit, for subtle badges and indicator offsets)
  - `bankyar.space.xs` (0.5x base unit, for tight inline spacings)
  - `bankyar.space.sm` (1x base unit, for form titles and field gaps)
  - `bankyar.space.md` (2x base unit, for default internal container padding)
  - `bankyar.space.lg` (3x base unit, for outer margins and section dividers)
  - `bankyar.space.xl` (4x base unit, for primary action buttons and bottom bars)
  - `bankyar.space.xxl` (6x base unit, for empty state illustrations and large vertical offsets)

---

## Screen Regions & Spatial Scaffolding

### 1. Top App Bar Header (Zone A - Pinned)
* **Visual Presentation:** Pinned to the top edge of the screen. Standard background blends with the canvas background, displaying a thin separator line `bankyar.semantic.color.border.subtle` when the content is scrolled underneath.
* **Layout Flow (RTL):**
  - **Logical Start Edge (Right):** Native back chevron icon `bankyar.icon.back.rtl` to exit to Settings.
  - **Center Block:** Page title "مرکز پشتیبان‌گیری و بازیابی" (Backup & Restore Center) styled with `bankyar.semantic.typography.heading.md`.
  - **Logical End Edge (Left):** Contextual info icon button `bankyar.icon.info` displaying a modal sheet with offline data security guarantees on tap.

### 2. Region 1: Data Protection Alert (Zone B - Scrollable)
* **Visual Presentation:** A flat, high-priority info card spanning the full width of the spatial grid.
* **Layout Flow (RTL):**
  - **Logical Start (Right):** Linear vector padlock shield icon representing local cryptography.
  - **Center Column:** Localized title "حاکمیت کامل بر داده‌ها" (Complete Data Sovereignty) with description text: "تمام فایل‌های پشتیبان رمزگذاری شده هستند. هیچ داده‌ای به صورت خودکار یا بدون تأیید شما از دستگاه خارج نمی‌شود."
  - **Design Token Mapping:** Background uses `bankyar.semantic.color.surface.flat` with corner curves mapped to `bankyar.radius.medium`.

### 3. Region 2: Backup Status Overview Card (Zone B - Scrollable)
* **Visual Presentation:** A prominent, high-fidelity card container providing a summary of the backup engine's health.
* **Core Elements & Spacing:**
  - Separated from Region 1 by `bankyar.space.lg`.
  - Internal padding uses `bankyar.space.md` symmetrically.
  - **Backup Health Indicator:** A colored circular ring badge indicating the security score (e.g., "۱۰۰٪") and health status.
  - **Status Metadata Grid (RTL):**
    * **آخرین پشتیبان‌گیری موفق (Last Successful Backup):** Timestamp in Solar Hijri ("دیروز - ساعت ۱۴:۳۲").
    * **آخرین تلاش ناموفق (Last Failed Backup):** Green neutral status "بدون خطا" (No failures) or warning timestamp.
    * **توصیه بعدی (Next Recommended Backup):** "امروز تا ساعت ۲۳:۰۰ (توصیه هفتگی)".
    * **اندازه فایل (Backup Size):** Monospace metric ("۲.۴ مگابایت").
    * **نسخه پایگاه داده (Database Version):** "نسخه ۱ - پایگاه داده ایمن".
    * **وضعیت رمزگذاری (Encryption Status):** "رمزگذاری شده با AES-GCM-256".
  - **Storage Information:** A progress bar representing device storage, detailing available space (e.g., "۷۲٪ فضای آزاد گوشی").

### 4. Region 3: Quick Actions Grid (Zone B - Scrollable)
* **Visual Presentation:** A responsive double-column grid hosting primary backup management commands.
* **Composition:**
  - **Button 1 (Create Backup):** "ایجاد پشتیبان دستی" with leading action icon.
  - **Button 2 (Restore Backup):** "بازیابی اطلاعات دیتابیس" with trailing warning indicator.
  - **Button 3 (Export Encrypted):** "خروجی با رمز عبور اختصاصی".
  - **Button 4 (Verify Integrity):** "بررسی سلامت فایل پشتیبان".
  - **Button 5 (Share Backup):** "اشتراک‌گذاری فایل پشتیبان".
  - **Button 6 (Delete Backup):** "حذف فایل‌های قدیمی" in semantic error color.
  - Grid spacing uses `bankyar.space.sm` gaps horizontally and vertically.

### 5. Region 4: Backup History List (Zone B - Scrollable)
* **Visual Presentation:** A vertical list of historical backup files detected on the local file system.
* **RTL Layout Flow:**
  - Section header "تاریخچه فایل‌های پشتیبان" styled with `bankyar.semantic.typography.title.sm`.
  - Each list row is wrapped inside a flat card using `bankyar.radius.medium` with hairline divider lines.
  - Displays: File date, time, size, encryption type ("AES-GCM"), verification status ("✓ تایید شده"), and restore action triggers.

### 6. Region 5: Recovery Information & Emergency Recovery (Zone B - Scrollable)
* **Visual Presentation:** A dedicated security information panel designed to help users prepare for device loss or hardware failures.
* **Core Elements:**
  - **Recovery PIN Status:** "پین امنیتی بازیابی فعال است".
  - **Encryption Algorithm:** Monospace indicator "AES-GCM-256 / PBKDF2 with 100,000 iterations".
  - **Backup Compatibility:** "سازگار با تمامی نسخه‌های اندروید ۸.۰ به بالا".
  - **Emergency Recovery Trigger Button:** Prominent trigger button "دریافت اطلاعات بازیابی اضطراری" styled with a gold padlock icon.

### 7. Bottom Navigation & Diagnostics (Zone C - Pinned)
* **Visual Presentation:** Persistent Bottom Navigation Bar pinned to the bottom of the viewport, with centered tabs representing standard screens.
* **Diagnostics Badge:** Center-aligned small label "اتصال شبکه کاملاً قطع است - آفلاین و امن" displaying an active green status dot.

---

## Detailed Component Specifications

### 1. Last Backup Card & Storage Info
* **Purpose:** Provides instantaneous verification of data protection status on app launch.
* **Visual Style:** Rounded rectangle container with `bankyar.radius.large` curves and soft border stroke `bankyar.semantic.color.border.subtle`.
* **Internal Grid (RTL):**
  - **Logical Start (Right):** Large vertical health badge showing a circular progress ring bound to `bankyar.semantic.color.status.success` enclosing the numerical score "۱۰۰".
  - **Middle Block:** Vertical stack of text rows:
    * Primary: "وضعیت فایل‌های پشتیبان شما عالی است" (Your backup status is excellent) in regular body typography.
    * Secondary: "آخرین فایل پشتیبان شما دیروز در ساعت ۱۴:۳۲ تولید شده و در حافظه محلی ذخیره گردید."
  - **Bottom Block (Storage Bar):** Linear progress bar representing device storage allocation. Filled proportion uses monospace metrics: "کل حافظه: ۱۲۸ گیگابایت | مصرف‌شده: ۳۶.۵ گیگابایت (۷۲٪ آزاد)".

### 2. Backup Health Indicator & Score
* **Purpose:** Aggregates database encryption status, backup frequency, and file integrity into a single understandable metric.
* **Component Type:** Circular graphic card with high-contrast colored borders.
* **Aesthetics:** Uses semantic color tokens:
  - Green (`bankyar.semantic.color.status.success`): Score 90-100 (Safe, frequent backups, healthy database).
  - Amber (`bankyar.semantic.color.status.warning`): Score 60-89 (Warning, last backup exceeded 7 days, or permissions missing).
  - Crimson (`bankyar.semantic.color.status.error`): Score 0-59 (Error, no local backup exists, database unencrypted, or file corrupted).

### 3. Quick Action Chips/Tiles
* **Purpose:** Primary interactive buttons used to manage backup files.
* **Height & Dimensions:** Bound to `bankyar.space.xl` (48-unit minimum touch envelope) with standard spacing boundaries to prevent accidental taps.
* **States & Design Tokens:**
  - **Pressed State:** Background surface contrast increases by +2 steps, accompanied by tactile touch compression of 0.98x.
  - **Disabled State:** Overlayed with 38% opacity mask, deactivating touch listeners when backing up or restoring is active.

### 4. Backup History List Item
* **Purpose:** Displays individual backup files available on-device.
* **RTL Layout Flow:**
  - **Logical Start Edge (Right):** Document vector icon with color badge indicating backup type (Manual: Blue icon, Scheduled: Green icon).
  - **Middle Text Column:** Bold date header (e.g., "۱۲ دی ۱۴۰۲") with small subtext timestamp ("ساعت ۱۴:۳۲") and database compatibility level ("نسخه دیتابیس: ۱").
  - **Logical End Edge (Left):** File size metrics ("۲.۴ مگابایت") directly adjacent to a localized "Restore" text button with an inline back-arrow symbol.

### 5. Encrypted Export Component
* **Purpose:** Safely exports the local database to an external backup file.
* **Interactions:**
  - Tapping "Encrypted Export" prompts the user to write down a secure 12-word passphrase or enter a strong custom password.
  - The export engine compiles database pages, encrypts the payload using AES-256-GCM, and launches the native Android Share Sheet, letting the user securely save the file to an SD card, copy it to a PC, or share it via secure channels.

### 6. Manual Import & File Picker
* **Purpose:** Allows users to manually load external backup files.
* **Visual Style:** Rectangular dashed boundary card with a centered file-upload icon, signaling interactive drop-file capabilities.
* **Interactions:**
  - Tapping the container launches the secure system file picker.
  - Only `.bankyar` file formats are displayed, graying out non-compliant file types to prevent user errors.

### 7. Emergency Recovery Card
* **Purpose:** Establishes a fallback recovery mechanism for users who lose their devices or forget their access PINs.
* **Visual Style:** Flat warning card highlighted with thick borders in amber semantic warning tokens `bankyar.semantic.color.border.warning`.
* **Interactions:**
  - Tapping the trigger prompts biometric authentication. Upon verification, it displays the 12-word master seed key and a custom Recovery QR Code, which can be printed or stored securely offline.

---

## Complete Restore Experience Flow

The restore process is a high-priority, multi-step transaction wrapping all actions in database rollbacks to prevent data corruption.

```
[ Step 1: Select File ] ──► [ Step 2: Verify Integrity ] ──► [ Step 3: PBKDF2 Decrypt ]
                                                                       │
                                                                       ▼
[ Step 6: Success ] ◄─── [ Step 5: Progress ] ◄─── [ Step 4: Enter Recovery PIN ]
        │
        └─► [ Fallback: Step 7: Conflict Resolution Dialog (If discrepancies found) ]
        │
        └─► [ Error Fallback: Step 8: Restore Failure Panel (Safe rollback triggered) ]
```

### 1. Step 1: Select Backup File
* **Action:** User taps "Restore Backup" on the Quick Actions grid.
* **UI Behavior:** Launches the system file picker. The interface is dimmed with a translucent dark scrim overlay `bankyar.opacity.translucent` to focus the user's attention.
* **Aesthetics:** File picker is filtered to display only `.bankyar` secure file formats.

### 2. Step 2: Verify Integrity & Schema
* **Action:** The system captures the selected file descriptor and initiates pre-verification.
* **UI Behavior:** Displays a centered circular progress ring with status text: "در حال بررسی ساختار فایل پشتیبان..." (Verifying backup file structure).
* **Cryptographic Checks:** Checks the 16-byte AES-GCM authentication tag and verifies database schema compatibility levels to prevent file mismatch errors.

### 3. Step 3: Verify Encryption & PBKDF2 Check
* **Action:** Prompts the user to enter their backup decryption password.
* **UI Behavior:** Displays a modal input dialog. The text entry field is masked by default, and features a leading eye icon `bankyar.icon.eye` to toggle character visibility.
* **Security Constraints:** The decryption key is derived locally using PBKDF2 with 100,000 iterations, protecting the backup archive from brute-force attempts.

### 4. Step 4: Enter Recovery PIN
* **Action:** Secondary authentication checkpoint to verify active user authorization.
* **UI Behavior:** Launches the secure scrambled PIN keypad overlay. The keypad digits are randomized to prevent grease-trail analysis or shoulder surfing.
* **Lockout Rules:** Restricts PIN checks to 3 consecutive attempts. Exceeding limits triggers a strict 1-minute lockout.

### 5. Step 5: Preview Restore Information
* **Action:** Before committing the restore, present a clear, high-contrast preview comparing the current database with the backup file.
* **Visual Layout:** Side-by-side transaction metrics grid:
  * **کارت‌های بانکی (Bank Cards):** Current: 3 active cards | Backup: 4 cards.
  * **کل تراکنش‌ها (Total Transactions):** Current: 1,420 entries | Backup: 1,840 entries.
  * **تاریخ آخرین سند (Last Entry Date):** Current: ۱۴۰۲/۱۰/۰۱ | Backup: ۱۴۰۲/۱۰/۱۲.
* **Action Buttons (RTL):**
  - **Logical Start (Right):** High-priority filled button "تایید و جایگزینی کامل اطلاعات" (Confirm and Replace All Data).
  - **Logical End (Left):** Neutral button "انصراف" (Cancel).

### 6. Step 6: Conflict Resolution Screen
* **Action:** Triggered if discrepancies or overlapping records are detected between the active database and the backup archive.
* **UI Behavior:** Displays an interactive list prompting the user to select their desired resolution:
  - **گزینه ۱ (Replace):** "جایگزینی کامل دیتابیس فعلی" (Overwrites local database with backup).
  - **گزینه ۲ (Merge):** "ادغام هوشمند و حذف تراکنش‌های تکراری" (Merges records and deduplicates based on unique SMS hashes).
  - **گزینه ۳ (Cancel):** "لغو عملیات بازیابی".

### 7. Step 7: Restore Progress Screen
* **Action:** Displays during actual database migration.
* **UI Behavior:** A full-screen, blocking progress layout. Interactive touch gestures are disabled, and a progress bar displays determinate percentage progress (e.g., "۴۵٪" in Persian monospace).
* **Stepped Logs checklist:**
  - `✓` تأیید امضای دیجیتال فایل (Digital signature verified)
  - `✓` رمزگشایی جداول تراکنش‌ها (Tables decrypted)
  - `↻` بازسازی نمایه‌های پایگاه داده (Rebuilding database indexes - Active)
  - `○` تطبیق الگوهای شناسایی پیامک (Matching SMS templates - Pending)

### 8. Step 8: Restore Success Experience
* **Action:** Triggered when migration completes successfully.
* **UI Behavior:** Full-screen success overlay featuring a green checkmark icon. Displays success copy: "اطلاعات با موفقیت بازیابی شد. ۲۴۰ تراکنش جدید به دفترچه شما افزوده گردید."
* **Primary Action:** "ورود به دفترچه تراکنش‌ها" (Navigate to Ledger).

### 9. Step 9: Restore Failure Experience
* **Action:** Triggered if decryption keys fail or filesystem writes are blocked.
* **UI Behavior:** Full-screen error overlay with amber warning borders.
* **Resilience Rule (Atomic Rollback):** The active database transaction is rolled back, restoring the app state to its pre-restore baseline. Displays clear error copy: "خطا در رمزگشایی فایل پشتیبان. پایگاه داده قبلی شما بدون تغییر باقی ماند."
* **Primary Recovery Actions:** "تلاش مجدد" (Retry password) and "مشاهده گزارش خطای عیب‌یابی" (View diagnostic logs).

---

## Data Protection & Privacy Architecture

As an offline-first financial platform, BankYar enforces robust privacy-by-design controls within the Backup & Restore Center:

* **All Backups are Encrypted:** Backup files are encrypted using AES-GCM-256. Decryption is impossible without the user's custom passphrase or emergency master key, ensuring complete privacy even if backup files are stolen.
* **No Data Leaves the Device Automatically:** Automatic background backups to cloud servers are disabled. The application manifest sets `android:allowBackup="false"`, ensuring no third-party cloud trackers can access local databases.
* **No Cloud Synchronization by Default:** All backups are written locally to the application's secure sandboxed storage. Sharing or archiving backups (e.g., to Google Drive or external SD cards) requires explicit, manual user actions.
* **Recovery Requires User Authentication:** Restoring backups or viewing recovery information requires successful biometric or PIN verification, preventing unauthorized local access.

---

## Visual Requirements & Material Design 3 Styling

* **Premium Financial Aesthetic:** Minimalist layouts utilizing comfortable white space, subtle margins, and flat container cards, conveying a professional, trustworthy, and precise financial workspace.
* **Symmetrical Spacing & Spatial Grid:** Spacing, margins, paddings, and heights align with integer multiples of the spatial multiplier factor, ensuring a stable layout rhythm.
* **Rounded Card Enclosures:** Standard containers use `bankyar.radius.medium` curves, while bottom sheets and modal dialogs use `bankyar.radius.large` corner curves.
* **Soft Visual Elevation:** Surface depth is communicated using clean border lines `bankyar.semantic.color.border.subtle` and flat background fills `bankyar.semantic.color.surface.default`, avoiding heavy gradients or dark drop shadows.
* **Accessible Typography Scales:** Title, subtitle, and body text styles use high-contrast color tokens and comfortable line leading, ensuring complex Persian script remains readable.

---

## Interactive States Visual Mapping

Components modify their visual layers dynamically based on standard interaction states to provide real-time visual feedback:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed | Accessibility Action |
| :--- | :--- | :--- | :--- |
| **Default** | Components sit flat. High-contrast text matches default color tokens. | Initial state | TalkBack announces status. |
| **Backing Up** | Progressive progress bars animate with smooth horizontal sweeps. Input elements are locked. | Linear loop under `bankyar.motion.duration.medium` | Screen reader announces: *"در حال تهیه فایل پشتیبان"* |
| **Restoring** | Interactive touch zones are disabled, and a full-screen stepped progress indicator is displayed. | Decelerated smooth curves | Focus is locked on the progress checklist. |
| **Verifying** | Spinning circular rings are displayed inline inside the Quick Actions buttons. | Continuous loop | TalkBack announces: *"در حال بررسی سلامت فایل"* |
| **Success State** | Full-screen overlay displays a green checkmark icon, with primary action buttons centered below. | Fast fade-in `bankyar.motion.curve.standard` | Screen reader confirms operation success. |
| **Warning State** | Component borders turn yellow, accompanied by an amber alert icon and helpful subtext. | Fast slide-down | Focus is directed to the warning details. |
| **Error State** | Outline borders turn red. Full-screen error panels display descriptive error copy. | Horizontal axis shake on launch | High-priority screen reader announcement. |
| **Offline SECURE** | Diagnostic status badge displays a steady green dot confirming connection-free operation. | Constant display | TalkBack announces: *"وضعیت امن آفلاین فعال است"* |
| **No Backup** | Warning banner displays text: "هیچ فایل پشتیبان محلی یافت نشد" with a primary action button below. | Immediate load | Prominent warning is read to screen readers. |
| **Corrupted Backup**| Quick actions highlight with red alert borders, disabling restore buttons. | Standard fade-in | Focuses on the "Run schema check" button. |
| **Permission Missing**| Backup actions display yellow alert icons with helper text: "دسترسی به حافظه گوشی صادر نشده است". | Fast slide-down | Prompts native OS permission dialog. |

---

## Responsive Viewport Configurations

The Backup & Restore Center layout adapts dynamically to preserve visual balance across all screen sizes:

* **Phone Viewport:** Vertical stacking. Standard margins and paddings are applied to maximize readable area. Quick Actions are arranged in a dual-column grid.
* **Large Phone Viewport:** Spacing between sections and cards expands slightly, and button touch areas are increased to support comfortable thumb interaction.
* **Tablet Viewport (Split Pane View):** Splits the screen into a balanced dual-pane layout:
  - **Right Panel (Logical Start - 40%):** Backup Status Overview Card, Device Storage progress bar, and Quick Actions grid.
  - **Left Panel (Logical End - 60%):** Backup History list and detailed Recovery Information.
  - **Navigation:** Bottom navigation bar is replaced with a lateral Navigation Rail on the right edge.
* **Foldable Viewport (Hinge Aware):** Detects the device's physical hinge coordinates, arranging the Backup Status Overview on the right fold, and the Backup History and Recovery Information on the left fold.
* **Landscape Viewport:** Vertical app bar heights are compacted, and Quick Actions arrange into a three-column layout to prevent uncomfortably wide, stretched cards.

---

## Accessibility & Inclusive Design Integration

* **Native RTL Flow:** Layouts, reading lines, progress bars, and chevrons point naturally from right to left, matching regional reading habits.
* **Screen Reader Semantic Support (TalkBack):**
  - Interactive components feature clear, localized semantic labels (e.g., "دکمه ایجاد فایل پشتیبان دستی. دو بار ضربه بزنید.").
  - Backup history items read nested metrics sequentially as a single focus block (e.g., "فایل پشتیبان دستی، تاریخ دوازدهم دی ماه، اندازه دو ممیز چهار مگابایت، وضعیت سالم.").
* **Large Fonts & Dynamic scaling:** Text blocks wrap automatically, and list rows expand vertically to support up to 200% system-level text magnification without overlapping or clipping text.
* **Touch Target Envelopes:** All interactive buttons, chips, and list tiles maintain a minimum clickable area of 48 x 48 dynamic units, protecting users with motor impairments.
* **Accessible Progress Indicators:** Progress percentage readouts are rendered using high-contrast Persian monospace numerals (e.g., "۴۵٪") with adjacent descriptive text labels.
* **Accessible File Picker:** The system file picker highlights compatible backup files clearly, and provides helpful auditory feedback to screen readers upon selection.

---

## Future-Ready Expansion Hooks

* **Google Drive Backup (Opt-in):** Reserved category slot below Backup History to toggle encrypted cloud exports. Includes clear warnings explaining security tradeoffs.
* **Local Network Backup:** Slot prepared to support automated exports to local home servers (NAS) over secure local networks.
* **Wi-Fi Direct Transfer:** Reserved action tile to support direct device-to-device database migrations using localized Wi-Fi Direct.
* **QR Code Migration:** Slot allocated to display and scan localized migration QR codes for instant account transfers.
* **End-to-End Encrypted Cloud Backup:** Prepared layout container to support secure, zero-knowledge cloud backups.
* **Automatic Scheduled Backup:** Toggle switch slot prepared to support automatic, scheduled daily or weekly local database exports.
* **Multi-Device Migration:** Prepared layout tab to handle encrypted database synchronization across multiple personal devices.
* **Versioned Backup History:** Space allocated to manage multiple historical backup versions, allowing users to restore from specific points in time.

---

## Design Token Mapping Reference

Every visual property specified in this document maps directly to an active design token, preserving consistency and white-label portability:

| Screen Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background.canvas` |
| Primary Container Card| Card Background Fill | `bankyar.semantic.color.surface.default` |
| Group Headings | High Contrast Text Font | `bankyar.semantic.color.text.primary` |
| Supporting Metadata | Medium Contrast Subtitle | `bankyar.semantic.color.text.secondary` |
| Row Separators & Dividers| Stroke Divider Line | `bankyar.semantic.color.border.subtle` |
| Active Highlight Borders| Active Ring Color | `bankyar.semantic.color.focus.outline` |
| Progress Bar Active Fill| Primary Accent Color | `bankyar.semantic.color.primary.active` |
| Healthy Status Badges | Success Accent Color | `bankyar.semantic.color.success.default` |
| Alert Warning Icons | Warning Accent Color | `bankyar.semantic.color.warning.default` |
| Critical Failure Outlines| Error Accent Color | `bankyar.semantic.color.error.default` |
| Sizing Spacing Factor | Sizing Spacing Factor | `bankyar.space.xl` |
| Outer Screen Margin | Responsive Margins | `bankyar.responsive.margin` |
| Standard Corner Radius | Card Corner Curves | `bankyar.radius.medium` |
| Large Corner Radius | Sheet Corner Curves | `bankyar.radius.large` |

---

## Validation Checklist

Before releasing any layout or screen iteration, developers must verify compliance against this checklist:

- [ ] **100% Token Compliance:** Verify that every color, margin, padding, border width, and corner curve maps directly to an active design token, with zero hardcoded values.
- [ ] **No Forbidden Patterns:** Ensure that absolutely no HEX color codes, physical pixel units, sp typography units, dp spacing units, or Flutter component names exist in the specification.
- [ ] **RTL-First Interface:** Verify that list flows, text fields, back chevrons, and transitions proceed naturally from right to left (RTL).
- [ ] **Security Masking Active:** Confirm that all settings lists, database summaries, and diagnostic logs mask sensitive values when the app is backgrounded.
- [ ] **Minimum Touch Target Met:** Confirm all interactive settings rows and buttons have active touch heights of at least `bankyar.space.xl`.

---

## Governance Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Platform Independence:** The layout must remain platform-independent, relying strictly on relative spacing blocks and logical components rather than framework-specific hacks.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.

---
**End of Specification Document**
