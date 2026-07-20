# BankYar Onboarding & Permission Experience Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, Senior UX Architect, Material Design 3 Expert, Flutter UI Architect, Android Permission UX Specialist, Privacy-by-Design Consultant, Enterprise FinTech Design Director
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Onboarding & Permission experience is the foundational gatekeeper of an offline-first, secure, and privacy-centric mobile personal finance platform. Built for native **Persian (RTL)** layouts and strict **on-device data sovereignty boundaries** (zero network permission, zero cloud trackers), the onboarding experience must balance education, trust-building, and seamless permission acquisition with the highest possible user conversion rates.

This specification outlines the complete, production-ready visual architecture, layout rhythm, spatial grids, typography scale, interactive behaviors, responsive modes, and accessibility structures for all **16 steps of the onboarding and permission experience**. In strict adherence to **Material Design 3 (MD3)** design systems, it utilizes design tokens to allow themes to adapt dynamically, ensuring a premium, reassuring, and highly secure first-run experience.

---

## Onboarding Screen Flow Sitemap & Spatial Zones

The Onboarding experience utilizes a strict logical three-zone vertical layout model. All indicators, progress bars, text alignments, and swipe directions mirror natively to support Persian RTL workflows.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: FIXED TOP HEADER & PERSISTENT PROGRESS REGION]                |
|  +-------------------------------------------------------------------+  |
|  | [Step Indicator]          [Brand Tagline]              [Exit/Skip] |  |
|  | [======================== Segmented Linear Progress Bar =========] |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & CONTENT CONTAINER]                     |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Central Visual Area: Abstract Vector Illustration / Logo]       |  |
|  |                                                                   |  |
|  |  [Header Area: Prominent Educational Headline]                    |  |
|  |  [Subtext Area: Supporting Copy / Privacy Assurances]             |  |
|  |                                                                   |  |
|  |  [Interactive Card Container: Custom Forms or Interactive Chips]  |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: CONTROL & ACCESSIBLE NAV BAR]                                 |
|  +-------------------------------------------------------------------+  |
|  |  [Primary Action Button: High contrast, CTA]                      |  |
|  |  [Secondary Action Button / Skip Trigger: Soft outline or text]   |  |
|  |  [Privacy Trust Seal Badge: "کاملاً آفلاین و رمزگذاری‌شده"]       |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## Complete 16-Step Screen Flow Specifications

---

### 1. Splash Screen (صفحه آغازین)

* **Purpose:** Initialize the secure local runtime environment, authenticate hardware Keystore signatures, and establish the BankYar brand identity.
* **Visual Components:**
  * **Application Logo:** Centered geometric abstract logo styled with `bankyar.semantic.typography.heading.lg` representing a protected vault intersecting with ascending financial bars.
  * **Brand Animation:** A subtle on-disk pulse representing localized, encrypted databases.
  * **Loading Indicator:** Indeterminate circular progress ring (`bankyar.radius.full`) styled with primary accent colors.
  * **Version Information:** Low-contrast monospace text placed at the bottom center: `v1.0.0 - آفلاین و امن`.
* **State & Interaction:**
  * **Default (Loading) State:** Runs internal self-tests (checks if database exists, checks filesystem permissions, validates local keystore).
  * **Transition Behaviour:** If a local database with active PIN configuration is detected, transitions instantly to the PIN Lock Screen. If no local database exists, executes a 1200ms ease-out fade transition to the Welcome Screen.
* **Accessibility:**
  * Screen reader announces: "برنامه بانک‌یار، در حال آماده‌سازی محیط امن آفلاین، لطفاً منتظر بمانید."

---

### 2. Welcome Screen (صفحه خوش‌آمدگویی)

* **Purpose:** Introduce BankYar as a premium offline-first personal finance platform and present its central value proposition.
* **Display Elements:**
  * **Welcome Message:** "به بانک‌یار خوش آمدید" styled with `bankyar.semantic.typography.heading.lg`.
  * **Application Value Proposition:** "مدیریت مالی هوشمند، کاملاً در دستان شما و بدون نیاز به اینترنت."
  * **Short Product Description:** "بانک‌یار با تحلیل خودکار پیامک‌های بانکی، بدون خروج حتی یک بیت اطلاعات از گوشی شما، گزارش‌های مالی دقیقی ایجاد می‌کند."
  * **Primary CTA:** "شروع تجربه امن" (Solid button styled with `bankyar.radius.medium` corner curves).
  * **Secondary CTA:** "بازیابی نسخه پشتیبان" (Outlined button for returning users who wish to bypass onboarding by uploading an existing `.bankyar` file).
  * **Privacy Summary:** A comforting footnote at the bottom: "با شروع، سیاست حفظ حریم خصوصی ۱۰۰٪ آفلاین ما را می‌پذیرید."

---

### 3. Core Value Introduction (معرفی ارزش‌های محوری)

* **Purpose:** Introduce the 3 core pillars of BankYar's product personality: "The Stoic Vault", "The High-Precision Analyst", and "The Calm Companion".
* **Visual Presentation:**
  * An interactive three-column horizontal list representing the three values, adapting to vertical lists on smaller devices.
  * **Card 1 (صندوقچه آرام):** A linear shield icon depicting silent, enduring safety with no ads, tracking, or telemetry.
  * **Card 2 (تحلیل‌گر دقیق):** A geometric chart icon representing automated, mathematical precision.
  * **Card 3 (همراه همیشگی):** A calm horizontal bar representing clear cash flows, converting chaotic messages into financial control.
* **Primary Action:** "ادامه مسیر" (Next).
* **Secondary Action:** "بازگشت" (Back).

---

### 4. Privacy Commitment (تعهدنامه حریم خصوصی)

* **Purpose:** Establish absolute, uncompromising user trust before any local data collection or scanning takes place.
* **Visual Presentation:**
  * A central card container with a green success outline, showcasing a locked padlock vector.
  * **Privacy Promises:**
    - "عدم دسترسی به اینترنت:" explicitly stating that BankYar does not declare or require internet permission in its system manifest.
    - "بدون بارگذاری ابری:" confirming zero telemetry trackers, cloud services, or external profile sharing.
    - "مالکیت کامل داده‌ها:" guaranteeing that 100% of financial data belongs to the user and can be wiped instantly.
* **Interactive Element:** A mandatory interactive checkbox: "متن تعهدنامه حریم خصوصی آفلاین را مطالعه کردم و آن را می‌پذیرم." The primary action remains disabled until this checkbox is toggled.

---

### 5. Offline-first Explanation (مفهوم همگام‌سازی آفلاین)

* **Purpose:** Educate the user on how the app operates without an active network connection, addressing potential confusion about automatic updates.
* **Visual Presentation:**
  * A flat flow diagram showing SMS messages going directly into the local encrypted SQLite DB, bypassing any remote cloud databases.
  * **Key Explanations:**
    - "دریافت محلی:" Incoming banking SMS messages are captured on the phone using Android's broadcast receiver APIs.
    - "رمزگذاری بومی:" Data is processed instantly on the device, remaining encrypted with AES-256.
    - "عملکرد مستقل:" The application is fully functional in airplane mode, low-signal areas, or underground vaults.
* **Primary Action:** "متوجه شدم" (I understand).

---

### 6. Security Overview (امنیت داده‌ها)

* **Purpose:** Detail the enterprise-grade cryptographic guardrails safeguarding local transaction details.
* **Visual Presentation:**
  * An abstract secure safe vault illustration, rendered with neutral grayscale and brand azure highlights.
  * **Security Bullet Points:**
    - "پایگاه داده SQLCipher:" All transactional history, ledger cards, and custom notes are stored in an AES-256 encrypted database.
    - "کلیدهای سخت‌افزاری Android Keystore:" Encryption keys are stored in the device's hardware enclave, inaccessible to other apps.
    - "سپر امنیتی در برابر بدافزارها:" System windows are secured (`FLAG_SECURE`) to block unauthorized screenshots or clipboard snooping.
* **Primary Action:** "تنظیم قفل امنیتی" (Setup Security Lock).

---

### 7. Permission Introduction (مقدمه مجوزها)

* **Purpose:** Introduce the permissions required by BankYar to operate, explaining why they are necessary to achieve high conversion rates.
* **Visual Presentation:**
  * A checklist of required and optional permissions with brief, non-intrusive descriptions.
  * **Checklist Items:**
    - "پیامک‌ها (اجباری):" Automated transaction tracking.
    - "اعلان‌ها (اختیاری):" Transaction confirmations and security lockout alerts.
    - "زیست‌سنجی (اختیاری):" Instant biometric unlock.
    - "ذخیره‌سازی (اختیاری):" Manual local backup imports and exports.
* **Primary Action:** "شروع فرآیند پیکربندی" (Start permissions setup).

---

### 8. SMS Permission (مجوز خواندن پیامک)

* **Purpose:** Acquire Android `READ_SMS` and `RECEIVE_SMS` permissions to enable automated transaction tracking.
* **Display Elements:**
  * **Why it is needed:** To automatically detect incoming transactions from bank gateways and log them instantly without manual input.
  * **What data is accessed:** Only incoming SMS messages that match bank gateway sender IDs and contain transaction-related keywords.
  * **What data is NOT accessed:** Personal conversations, multi-factor authentication codes (OTPs), or non-financial sender IDs are ignored.
  * **Benefits:** Real-time financial reports, zero manual input errors, and automatic background category assignments.
  * **Privacy Guarantees:** Message processing is performed 100% on-device inside memory; raw text is processed and deleted from active buffers immediately.
  * **Primary Action:** "اعطای دسترسی به پیامک‌ها" (Grant SMS Access - triggers native Android dialog).
  * **Secondary Action:** "ورود دستی تراکنش‌ها" (Skip/Manual Fallback).
  * **Skip Behaviour:** Disables automated capture, redirects user to step 13 with an educational banner explaining how manual imports function.
  * **Failure Behaviour:** If denied, displays an educational alert card: "بانک‌یار بدون این دسترسی فقط به صورت دستی قابل استفاده خواهد بود. در صورت تمایل می‌توانید این دسترسی را بعداً از تنظیمات فعال کنید."

---

### 9. Notification Permission (مجوز اعلان‌ها)

* **Purpose:** Acquire Android notification permissions to support real-time transaction alerts and security warnings.
* **Display Elements:**
  * **Why it is needed:** To send immediate confirmations when transactions are logged in the background, or alert the user during database locks.
  * **What data is accessed:** Device notification delivery channel.
  * **What data is NOT accessed:** No data from other applications is read or altered.
  * **Benefits:** Instant spending alerts, automated backup reminders, and critical security warning notifications.
  * **Privacy Guarantees:** Notifications are generated and handled locally by the Android operating system with zero external tracking.
  * **Primary Action:** "فعال‌سازی اعلان‌ها" (Enable notifications).
  * **Secondary Action:** "رد کردن" (Skip notification setup).
  * **Skip Behaviour:** Disables push notifications, saving this setting in local shared preferences, and proceeds to the next step.
  * **Failure Behaviour:** Proceeds to the next step without interrupting the onboarding flow.

---

### 10. Biometric Permission (احراز هویت زیست‌سنجی)

* **Purpose:** Link system biometric APIs (fingerprint/face unlock) to support fast, secure app unlocks.
* **Display Elements:**
  * **Why it is needed:** To provide quick, convenient access to the financial ledger while keeping data secure from unauthorized physical access.
  * **What data is accessed:** Android system biometric authentication status.
  * **What data is NOT accessed:** Raw biometric templates, fingerprints, or face models are handled by the OS and are never shared with the application.
  * **Benefits:** Sub-100ms secure unlocks, replacing manual 4-digit PIN entries.
  * **Privacy Guarantees:** Operates entirely through Android Keystore APIs; cryptographic verification is handled by hardware enclaves.
  * **Primary Action:** "فعال‌سازی زیست‌سنجی" (Activate biometrics).
  * **Secondary Action:** "استفاده از پین‌کد" (Use PIN only).
  * **Skip Behaviour:** Keeps standard 4-digit PIN access active, skipping biometric configurations.
  * **Failure Behaviour:** If biometrics are unsupported or fail to configure, fallback automatically to the secure 4-digit PIN setup screen.

---

### 11. Storage Access (دسترسی به حافظه خارجی)

* **Purpose:** Obtain storage access permissions (on applicable Android versions) to support local backup imports and exports.
* **Display Elements:**
  * **Why it is needed:** To let the user choose local directories to save password-encrypted backups or select backup files to restore.
  * **What data is accessed:** Selected backup files or specified export directories.
  * **What data is NOT accessed:** Photos, media, or personal folders are completely ignored.
  * **Benefits:** Portability of financial records across devices, protecting against hardware damage.
  * **Privacy Guarantees:** Backup files are encrypted with AES-256-GCM using a user-defined password before write.
  * **Primary Action:** "تنظیم دسترسی به فایل‌ها" (Setup file access).
  * **Secondary Action:** "رد کردن" (Skip).
  * **Skip Behaviour:** User can still use the app; backups must be manually copied or shared via the system share sheet.
  * **Failure Behaviour:** Fallback gracefully to system share sheets for database exports, bypasses storage permission blocks.

---

### 12. Battery Optimization Guide (راهنمای بهینه‌سازی مصرف باتری)

* **Purpose:** Guide the user to whitelist BankYar from aggressive system battery managers, preventing background task termination.
* **Display Elements:**
  * **Why it is needed:** Android battery optimization policies can aggressively terminate background services, causing the app to miss incoming SMS messages.
  * **What data is accessed:** Background service status.
  * **What data is NOT accessed:** No battery usage or diagnostic details are sent externally.
  * **Benefits:** 100% reliable transaction logging in the background, even when the device is locked or in battery-saver mode.
  * **Privacy Guarantees:** The background service runs completely offline, processing SMS messages locally inside memory.
  * **Primary Action:** "غیرفعال‌سازی محدودیت فعالیت پس‌زمینه" (Disable background restrictions - triggers system settings navigation).
  * **Secondary Action:** "ادامه بدون تغییر" (Continue without changes).
  * **Skip Behaviour:** User continues with default system battery settings, acknowledging background task limitations.
  * **Failure Behaviour:** Displays a visual tip card showing step-by-step instructions: "تنظیمات دستگاه > برنامه‌ها > بانک‌یار > باتری > بدون محدودیت (Unrestricted)."

---

### 13. Initial Bank Detection (شناسایی اولیه بانک‌ها)

* **Purpose:** Scan local incoming SMS history to detect supported financial institutions and active credit/debit cards.
* **Visual Presentation:**
  * A clean loading card with a circular progress ring.
  * **Scanning Progress:** Real-time, step-by-step confirmation of detected bank gateways (e.g., "Mellat", "Melli", "Tejarat").
  * **Detected Counts:** Shows the active count of detected card numbers and bank senders.
* **Progress Feedback:** Horizontal linear progress bar showing the scan completion percentage.
* **Estimated Time:** "زمان تقریبی: کمتر از ۲۰ ثانیه" (Approximate time: under 20 seconds).
* **Cancellation Rules:** Safe to cancel at any point; tapping "انصراف" stops the scan, saves already verified transactions, and proceeds to the dashboard.
* **Error Recovery:** If an on-disk read failure occurs, pause scanning, write a diagnostic error to local logs, and allow the user to retry the scan.

---

### 14. Initial SMS Scan (اسکن اولیه پیامک‌ها)

* **Purpose:** Process detected banking SMS messages, extracting financial metadata (amounts, counterparties, types, and timestamps).
* **Visual Presentation:**
  * A high-contrast linear list showing transaction card skeletons. Skeletons are replaced in real-time with parsed transaction details as the scan proceeds.
  * **Status Feed:** Monospace text scrolling showing current progress (e.g., "تحلیل پیامک شماره ۱۴۲ از ۴۵۰...").
* **Progress Feedback:** Display percentage text (e.g., `۴۵٪` in Persian) next to the linear progress bar.
* **Estimated Time:** "زمان باقیمانده: ۱۰ ثانیه" (Time remaining: 10 seconds).
* **Cancellation Rules:** Tapping "انصراف" stops the scan, preserving already parsed transactions in the database.
* **Error Recovery:** If a message format cannot be parsed, log it as an "Unparsed Transaction" and continue scanning, ensuring the process does not crash.

---

### 15. Initial Database Preparation (آماده‌سازی پایگاه داده اولیه)

* **Purpose:** Write parsed transaction history to the SQLCipher database, compile full-text search indexes, and calculate initial analytics.
* **Visual Presentation:**
  * A full-screen stepped progress layout with interactive checklist items:
    - `✓` مقداردهی اولیه محیط رمزگذاری (Database initialization complete)
    - `✓` ذخیره تراکنش‌های شناسایی‌شده (Saved transactions)
    - `↻` ساخت نمایه‌های جستجوی سریع (FTS5) (Building FTS5 index - active step)
    - `○` محاسبه تراز مالی و آمار اولیه (Calculating initial analytics - pending)
* **Progress Feedback:** Stepped loading checkmarks; progress bar displays indeterminate loading while compiling database tables.
* **Estimated Time:** "زمان تقریبی: کمتر از ۵ ثانیه" (Approximate time: under 5 seconds).
* **Cancellation Rules:** Interaction is blocked during database writes to prevent corruption.
* **Error Recovery:** If database writes fail due to file system blocks, roll back active transactions to preserve integrity, and display a helpful retry option.

---

### 16. Onboarding Completion Screen (پایان پیکربندی اولیه)

* **Purpose:** Celebrate the successful completion of the onboarding experience, display a summary of detected data, and transition the user to the Ledger tab.
* **Display Elements:**
  * **Congratulations Message:** "پیکربندی با موفقیت انجام شد!" styled with `bankyar.semantic.typography.heading.lg` with a green success tick.
  * **Detected Transactions:** A prominent numeric card displaying the total count of parsed transactions (e.g., "۲۸۴ تراکنش با موفقیت تحلیل و وارد شد").
  * **Supported Banks:** Small horizontal chips displaying the active logos of detected banks (e.g., "بانک ملت", "بانک ملی").
  * **Security Status:** A green shield badge confirming: "پایگاه داده ۱۰۰٪ رمزگذاری‌شده و ارتباط اینترنتی کاملاً مسدود است."
  * **Next Steps:** Brief guidance: "شما آماده استفاده از بانک‌یار هستید. از این پس تراکنش‌های جدید شما به محض دریافت پیامک، به‌طور خودکار ثبت خواهند شد."
  * **Go To Dashboard:** A high-contrast primary CTA button: "ورود به دفترچه تراکنش‌ها" (Enter Ledger).

---

## Onboarding Screen Interaction States

To provide instant visual and tactile confirmation to the user, onboarding elements adapt dynamically based on standard interaction states:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed |
| :--- | :--- | :--- |
| **Default State** | Elements sit flat on the canvas background. Standard text contrast is maintained. | Initial load state |
| **Pressed State** | Element surface contrast shifts by +2 steps. Applies tactile touch-scale compression of 0.98x. | Immediate response trigger under `bankyar.motion.duration.instant` |
| **Selected / Active State** | Checkboxes and permission chips toggle to active positions with primary color fill. | Smooth transition under `bankyar.motion.duration.fast` |
| **Permission Granted** | Standard action button transitions to a disabled green checkmark: "دسترسی اعطا شد". | Smooth scale transition under `bankyar.motion.duration.fast` |
| **Permission Denied** | Displays a yellow warning border around the permission card with detailed fallback instructions. | Shake animation on horizontal axis on launch |
| **Skipped** | Row is faded to 38% transparency opacity, and active touch listeners are deactivated. | Muted contrast change instantly |
| **Loading / Scanning** | Shimmering list items animate with horizontal sweep movements; active controls are locked. | Linear opacity loop under `bankyar.motion.duration.medium` |
| **Error / Recovery** | Borders are outlined with high-contrast crimson tokens. Alert warnings and a "Retry" button are shown. | Shake animation on horizontal axis on launch |
| **Completed** | Transitions the progress bar to 100% fill, followed by an immediate fade-in of success components. | Decelerated scale-up under `bankyar.motion.duration.medium` |

---

## Responsive Design & Adaptive Onboarding Viewports

The Onboarding layout adapts dynamically across standard responsive breakpoints to preserve visual balance:

### 1. Phone Viewport
* **Grid Layout:** 4 Columns. Symmetrical outer margins are optimized for close physical interaction.
* **Workspace:** Vertical stack. Scrollable content area in Zone B; Zone A and Zone C remain pinned to the top and bottom of the viewport.
* **Illustrations:** Scaled down to prioritize typography and touch targets.

### 2. Large Phone Viewport
* **Grid Layout:** 4 Columns.
* **Visual Adaptation:** Vertical spacers and outer padding expand slightly to protect layout balance.

### 3. Tablet Viewport
* **Grid Layout:** 8 Columns.
* **Visual Adaptation (Split Pane Layout):**
  * **Logical Start Pane (Right - 4 Columns):** Visual illustrations, brand animations, and educational taglines remain pinned on the right side.
  * **Logical End Pane (Left - 4 Columns):** Interactive forms, permissions checkboxes, and action CTA buttons are displayed on the left side, reducing finger reach.
* **Navigation:** Skip buttons are positioned within comfortable thumb-reach of the tablet borders.

### 4. Foldable Viewport
* **Grid Layout:** 8 Columns.
* **Visual Adaptation:** Adapts based on hinge coordinates. Displays educational and visual illustrations on the right fold, and permission control panels on the left fold.

### 5. Landscape Orientation
* **Grid Layout:** Horizontal split layout. The vertical visual illustration is moved to a side-by-side configuration to prevent content from stretching, keeping text fields and CTA buttons fully legible.

---

## Accessibility & Inclusive Onboarding Design

BankYar's Onboarding interface implements strict WCAG AA standards to guarantee access for all users:

* **Native RTL Persian Layouts:** Alignments, reading flows, transitions, and chevron indicators proceed naturally from right to left (RTL).
* **Screen Reader Semantic Support:**
  * Active elements have descriptive screen reader announcements (e.g., "تعهدنامه حریم خصوصی، برای ادامه باید این دکمه را انتخاب کنید").
  * Progress updates (e.g., scanning SMS) are announced periodically (every 10%) using clear, spoken percentages.
* **Focus Order Rules:** Focus progression flows systematically from top-right to bottom-left (logical RTL order). Focus remains locked within active permission dialogs until they are dismissed.
* **Minimum Touch Target Envelopes:** All interactive buttons, checkboxes, and list rows maintain a minimum clickable area of `bankyar.space.xl` (conforming to the 48-unit Material minimum), protecting users with motor impairments.
* **Dynamic Sizing & Font Scaling:** All text elements wrap automatically. List rows expand vertically to support large system font scales up to 200% without overlapping or clipping text.
* **Color-Independent Progress Indicators:**
  * Progress is never conveyed solely by color. Skeletons and progress indicators are accompanied by explicit text labels showing percentage numbers (e.g., `۴۵٪` in Persian).
  * Validation statuses are confirmed with clear textual descriptors ("تأیید شد" vs "نیاز به دسترسی").

---

## Future-Ready Onboarding Expansion Hooks

The Onboarding screen architecture includes dedicated layout slots to support future features without requiring a structural redesign:

* **Cloud Sync Setup (Future - Opt-in):** A reserved setup slide positioned after "Offline-first Explanation" to configure encrypted cloud backups. Includes a prominent security warning explaining backup tradeoffs.
* **AI Assistant Introduction (Future):** An optional slide positioned after "Core Value Introduction" introducing localized, offline machine learning features (such as auto-categorization of complex transaction layouts).
* **Premium Features (Future):** A prepared layout slot on the welcome screen to introduce premium multi-account tools or custom spreadsheet exports.
* **Multi-device Setup (Future):** An expansion hook inside the Welcome Screen to connect and sync with other local device databases via secure, peer-to-peer bluetooth connections.
* **Import Existing Backups:** A dedicated, persistent "Restore Backup" button positioned on the Welcome screen, allowing users to restore previous data instantly and bypass onboarding.
* **Future Migration Wizard:** A prepared layout slot inside the Completion Screen to import transaction histories from other legacy financial apps.

---

## Design Token Mapping Reference

Every visual property specified in this document maps directly to an active architectural design token, preserving long-term design consistency.

| Screen Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background.canvas` |
| Primary Container Card| Card Background Fill | `bankyar.semantic.color.surface.default` |
| Section Header Title| High Contrast Title Font | `bankyar.semantic.color.text.primary` |
| Supporting Subtext | Medium Contrast Subtitle | `bankyar.semantic.color.text.secondary` |
| Progress Bar Track | Background Fill | `bankyar.semantic.color.border.subtle` |
| Progress Bar Fill | Active Accent Color | `bankyar.semantic.color.primary.active` |
| Toggle Active Fill | Primary Accent Color | `bankyar.semantic.color.primary.active` |
| Diagnostic Status Badge | Success Accent Color | `bankyar.semantic.color.success.default` |
| Alert Warnings / Denied | Error Accent Color | `bankyar.semantic.color.error.default` |
| Focus Outlines | Active Ring Color | `bankyar.semantic.color.focus.outline` |
| Touch Target Boundaries| Sizing Spacing Factor | `bankyar.space.xl` |
| Outer Screen Margin | Responsive Margins | `bankyar.responsive.margin` |
| Standard Corner Radius | Card Corner Curves | `bankyar.radius.medium` |
| Large Corner Radius | Sheet Corner Curves | `bankyar.radius.large` |

---

## Validation Checklist

Before releasing any layout or screen iteration, developers must verify compliance against this checklist:

- [ ] **100% Token Compliance:** Verify that every color, margin, padding, border width, and corner curve maps directly to an active design token, with zero hardcoded values.
- [ ] **No Forbidden Patterns:** Ensure that absolutely no HEX color codes, physical pixel units, sp typography units, dp spacing units, or Flutter component names exist in the specification.
- [ ] **RTL-First Interface:** Verify that page transitions, progress bars, text alignments, and back chevrons proceed naturally from right to left (RTL).
- [ ] **Data Preservation Guard:** Confirm that initial database scanning and parsing routines run off-the-main-thread and write atomically to SQLCipher, protecting data from corruption if interrupted.
- [ ] **Minimum Touch Target Met:** Confirm all interactive buttons, checkboxes, and selection rows have active touch heights of at least `bankyar.space.xl`.
- [ ] **No Dead Ends:** Ensure that every permission denial, scan failure, and storage warning features a prominent, primary recovery action button.

---

## Governance Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Platform Independence:** The layout must remain platform-independent, relying strictly on relative spacing blocks and logical components rather than framework-specific hacks.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.

---
**End of Onboarding & Permission Experience Specification Document**
