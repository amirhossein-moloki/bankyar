# BankYar Security & Privacy Center Screen Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Security UX Designer, Senior Product Designer, Material Design 3 Expert, Flutter UI Architect, Privacy-by-Design Specialist, Android Security Consultant, Enterprise FinTech Design Director
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Security & Privacy Center is the absolute administrative shield and cryptographic control room of this offline-first, personal finance platform. Natively localized in **Persian (RTL)** under strict **on-device data sovereignty boundaries** (zero network permissions, zero cloud trackers), the center provides a premium, high-assurance environment. Here, users can dynamically monitor, verify, and lock down the security and privacy postures of their financial ledger.

This specification outlines the complete, production-ready visual architecture, spatial layout rhythm, typography scale, interactive state matrices, multi-viewport adaptations, and WCAG-compliant accessibility structures for the Security & Privacy Center screen. Built entirely on the **Material Design 3 (MD3)** design language, it utilizes abstract design tokens to guarantee seamless theme re-rendering, zero hardcoded styles, and absolute user confidence under all operating conditions.

---

## Screen Blueprint & Spatial Mapping

The Security & Privacy Center screen utilizes the three-zone vertical layout model. Horizontal scrolling lanes, list tile structures, action matrices, and interactive cards mirror natively to support Persian RTL workflows.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY APP BAR]                                               |
|  +-------------------------------------------------------------------+  |
|  | [Live Refresh/Diagnostic]        [Screen Title]        [Back Chevron] |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & SECURITY REBOOT REGIONS]               |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 1: Overall Security Score Card]                          |  |
|  |     +-------------------------------------------------------+     |  |
|  |     |   [85 / 100]  |  Status: Highly Secure (سطح بهینه‌شده)  |     |  |
|  |     |   Security Level Badge  | Risk Indicator              |     |  |
|  |     |   Last Check: 1402/10/12 | 2 Improvements Pending     |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 2: Security Status Summary]                              |  |
|  |     - Subtext: "۹ از ۱۲ شاخص امنیتی در بهترین وضعیت قرار دارند."   |  |
|  |                                                                   |  |
|  |  [Region 3: Quick Security Actions]                               |  |
|  |     [ اسکن مجدد ]    [ رفع خودکار ایرادات ]    [ پشتیبان‌گیری فوری ]  |  |
|  |                                                                   |  |
|  |  [Region 4: Threat Alerts Stack (Dynamic Warning Cards)]          |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | [!] Missing SMS Permission (مجوز دسترسی قطع شده)      |     |  |
|  |     | [!] Outdated Backup (پشتیبان‌گیری قدیمی)                |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 5: Scrollable Configuration Categories]                  |  |
|  |                                                                   |  |
|  |     [Category Header: داشبورد حریم خصوصی (Privacy Dashboard)]     |  |
|  |     - Hide Amounts | Hide Balance | Blur App in Recent            |  |
|  |     - Block Screenshots | Clipboard Protection | Privacy Mode    |  |
|  |     - Sensitive Information Visibility                            |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: احراز هویت (Authentication)]                |  |
|  |     - PIN Lock Status | Change PIN Code | Biometric Auth Toggle    |  |
|  |     - Auth Method Status | Auto Lock Timer | Failed Login Counter |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: امنیت دستگاه (Device Security)]            |  |
|  |     - Root Detection | Developer Mode Warning | USB Debug Warning   |  |
|  |     - System Integrity Status | System Device Lock Status         |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: لایه رمزگذاری محلی (Encryption)]             |  |
|  |     - DB Encrypt Status | Algorithm (SQLCipher AES-256)           |  |
|  |     - Master Key Storage | Backup Encrypt | Integrity Verifier    |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: وضعیت مجوزهای سیستمی (Permissions)]          |  |
|  |     - SMS Reading | System Notification | Biometrics Access       |  |
|  |     - Storage Writing | OS Battery Optimization Status            |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: توصیه‌های امنیتی هوشمند (Recommendations)]    |  |
|  |     - Recommendation Card 1 | Recommendation Card 2               |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: اقدامات اضطراری - انهدام (Emergency)]        |  |
|  |     - Lock App Now | Temporary Logout | Erase Local Data          |  |
|  |     - Reset Security Settings | Export Local Security Report      |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: CONTROL & NAVIGATION]                                         |
|  +-------------------------------------------------------------------+  |
|  | [Persistent Bottom Navigation Bar]                                |  |
|  | [Ledger]              [Analytics]             [Rules]   [Settings]*|  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## Core Specification Deliverables

### 1. Screen Purpose
The Security & Privacy Center serves as the cryptographic control tower of BankYar. Operating completely offline behind hardware-backed key vaults, its mission is to let users diagnose operating integrity, enforce user-interface obfuscation, adjust biometric credentials, verify SQLCipher local volume metrics, and initiate immediate emergency data zeroization under physical threats.

### 2. Business Objectives
* **Cultivate Absolute Sovereignty Trust:** Deliver high-assurance diagnostic visual queues proving that financial sms records and derived ledgers are strictly bounded to the local chip, without network pathways.
* **Eliminate Technical Friction:** Translate complex security concepts (such as cryptographic salts, OS integrity indicators, and sandbox permissions) into clear, actionable statuses.
* **Facilitate Self-Defensive Actions:** Offer immediate, easy-to-reach security configurations and emergency data wiping buttons, protecting the user from forensic physical discovery in high-stress situations.

### 3. User Goals
* **Assess Vulnerability instantly:** Review a unified, color-blind safe overall security score card to identify security risks immediately upon opening the center.
* **Configure Input/Output Obfuscation:** Block native screen-captures, enforce recent-apps blurring, restrict clipboard exposures, and toggle balance-masking rules.
* **Audit Local Cryptography:** Verify active SQLCipher AES-256 databases, inspect Android Keystore hardware-backed keys, and monitor backup encryption.
* **Resolve Alerts Actionably:** Tap warnings (e.g. missing permissions, weak PIN) and resolve them instantly via native system redirects.
* **Trigger Critical Destructs:** Securely purge the entire database and reset settings with a multi-step emergency confirmation flow.

### 4. Entry Points
* **Settings & Preferences Subsection:** Tapping the Security Card or drilling into "امنیت و حریم خصوصی" under Settings navigates here.
* **Home Dashboard Diagnostic Avatar:** Tapping the yellow warning badge or active green status icon inside the main dashboard app bar opens this center.
* **Deep Link Notification:** Background SMS parsing warnings or backup reminders trigger notifications that route the user directly to this center.

### 5. Exit Points
* **App Bar Native RTL Back Chevron:** Slides the context back to Settings & Preferences.
* **Bottom Navigation Tab Switch:** Tapping "Ledger" or "Analytics" redirects to those contexts immediately.
* **Destructive Zeroization Redirect:** Triggering "Erase Local Data" securely terminates the app session and exits to the OS launch sequence.

### 6. Navigation Behaviour
* **Cross-Fade peer transitions:** Instant peer-to-peer screen shifts to guarantee zero UI lag.
* **Logical Sliding Transitions:** Drilling into detailed subsections (such as individual PIN setups or advanced permissions) slides content from the logical start edge (right) to the logical end edge (left).
* **Modal Bottom Sheets:** Displaying confirmation menus (e.g., confirming Erase Local Data) slides upward from Zone C.

### 7. Information Hierarchy
* **Primary Visual Tier (Zone A / Top of Zone B):** sticky app bar with live diagnostics alongside the Overall Security Score Card showing the numeric rating.
* **Secondary Visual Tier:** Threat Alerts Stack highlighting critical or outstanding actions using security-focused color states.
* **Tertiary Visual Tier:** Categorized rows divided by clear headers containing individual switches, badges, and trailing chevrons.
* **Destructive Control Tier (Bottom of Zone B):** High-contrast Emergency Actions cards utilizing warning amber and crimson color scales.

---

## Section Detailed Specifications

### 1. Top App Bar (نوار ابزار بالا)
* **Purpose:** Acts as the persistent navigation anchor and live diagnostics trigger.
* **Layout Flow (RTL):**
  * **Logical Start Edge (Right):** Native back chevron (`bankyar.icon.back.rtl`) styled with `bankyar.semantic.color.text.primary`.
  * **Center:** Title "امنیت و حریم خصوصی" (Security & Privacy Center) styled with `bankyar.semantic.typography.heading.md`.
  * **Logical End Edge (Left):** Dynamic refreshing icon (`bankyar.icon.refresh.rtl`) with a green dot badge indicating the on-device secure sandbox status.
* **Interactions:**
  * Tapping the refresh icon triggers a 1.5-second live hardware diagnostic scan, transitioning the App Bar and Score Card into the "Checking Security" state.

---

### 2. Overall Security Score Card (کارت امتیاز امنیت عمومی)
* **Purpose:** Displays an aggregated numeric score representing on-device security, alongside active threat classifications.
* **Visual Style:** Rounded card container using `bankyar.radius.lg` with symmetrical `bankyar.space.md` padding. Uses a low-contrast neutral surface fill (`bankyar.semantic.color.surface.default`).
* **Visual Elements (RTL Layout):**
  * **Right Column (Score Section):** Large monospaced numeric text representing the score: **"۸۵٪"** (85 / 100), styled with `bankyar.semantic.typography.heading.xxl`. The font color adapts dynamically based on score ranges:
    * *90 - 100:* Emerald Green (`bankyar.semantic.color.status.success`)
    * *70 - 89:* Amber Gold (`bankyar.semantic.color.status.warning`)
    * *0 - 69:* Crimson Red (`bankyar.semantic.color.status.error`)
  * **Left Column (Status Details):**
    * **Security Level Badge:** A pill-shaped container styled with `bankyar.radius.full`. Displays the text **"سطح بهینه‌شده"** (Optimized Level) for 85%.
    * **Risk Indicator:** Text sub-label **"۲ مورد نیازمند بهبود"** (2 items need improvement), styled with `bankyar.semantic.typography.title.sm` using warning gold tokens.
    * **Last Security Check:** Monospace text timestamp: **"آخرین بررسی: ۱۴۰۲/۱۰/۱۲ - ۱۲:۳۰"** (Last check: 1402/10/12 - 12:30), styled with `bankyar.semantic.typography.caption.xs`.
* **Interactions:** Tapping the card opens a bottom drawer presenting a detailed breakdown of the 100-point scoring algorithm.

---

### 3. Security Status Summary (خلاصه وضعیت امنیت)
* **Purpose:** Provides a brief, human-readable summary of the current security state to reduce cognitive fatigue.
* **Visual Style:** Simple flat container card placed directly below the Score Card.
* **Text Structure:** Title **"خلاصه وضعیت"** followed by body text: **"سیستم پایگاه داده شما کاملاً رمزگذاری شده و آفلاین است. برای دسترسی به امتیاز ۱۰۰، دسترسی به مجوز پیامک را مجدداً برقرار کرده و یک پشتیبان‌گیری محلی انجام دهید."**
* **Typography:** Styled with `bankyar.semantic.typography.body.md` using maximum-contrast text tokens.

---

### 4. Quick Security Actions (اقدامات امنیتی سریع)
* **Purpose:** Offers immediate shortcuts to initiate key security tasks.
* **Layout Flow (RTL):** Horizontal scrolling chip lane spanning the full width of the spatial grid.
* **Interactive Chips:**
  1. **"بررسی مجدد امنیت" (Scan Security):**
     * *Icon:* Standard scanning circle icon.
     * *State:* Outlined border chip.
     * *Behavior:* Triggers the live diagnostic scanning animation.
  2. **"رفع خودکار ایرادات" (Auto-Resolve):**
     * *Icon:* Standard magic wand / shield icon.
     * *State:* Solid filled chip.
     * *Behavior:* Prompts native system screens to resolve permissions or settings.
  3. **"پشتیبان‌گیری فوری" (Instant Backup):**
     * *Icon:* Secure folder export icon.
     * *State:* Outlined border chip.
     * *Behavior:* Redirects directly to the encrypted backup key generation screen.

---

### 5. Privacy Dashboard (داشبورد حریم خصوصی)
* **Purpose:** Provides switches to obfuscate and protect user interface data.
* **Visual Structure:** Flat list group separated by hairline dividers (`bankyar.semantic.color.border.subtle`).
* **Controls & Options:**
  * **Hide Transaction Amounts (پنهان‌سازی مبالغ تراکنش):**
    * *Layout:* Switch Control Tile.
    * *Subtext:* "جلوگیری از نمایش خودکار مبالغ در صفحات پرتردد" (Masks transaction totals with blurred masking blocks).
  * **Hide Balance (پنهان‌سازی موجودی کل):**
    * *Layout:* Switch Control Tile.
    * *Subtext:* "ماسک‌کردن موجودی کل حساب‌ها تا زمان لمس مستقیم" (Hides the total balance indicator).
  * **Blur App in Recent Apps (محوسازی در برنامه‌های اخیر):**
    * *Layout:* Switch Control Tile.
    * *Subtext:* "محو کردن تصویر برنامه در منوی چندوظیفگی سیستم‌عامل" (Hides interface previews in the task switcher).
  * **Block Screenshots (مسدودسازی عکس‌برداری و ضبط صفحه):**
    * *Layout:* Switch Control Tile.
    * *Subtext:* "جلوگیری از تهیه اسکرین‌شات و ضبط ویدیو از برنامه" (Enforces system secure window flags (`FLAG_SECURE`)).
  * **Clipboard Protection (محافظت از حافظه موقت):**
    * *Layout:* Switch Control Tile.
    * *Subtext:* "پاک‌سازی خودکار مبالغ کپی‌شده پس از ۳۰ ثانیه" (Clears financial figures from clipboard).
  * **Privacy Mode (سطح حریم خصوصی کلی):**
    * *Layout:* Selector Option Tile.
    * *Values:* Standard ("استاندارد"), Ultra-Secure ("فوق امنیتی - قفل خودکار سریع و پنهان‌سازی دائم اطلاعات").
  * **Sensitive Information Visibility (نمایش اطلاعات حساس):**
    * *Layout:* Selector Option Tile.
    * *Values:* Always Show ("نمایش همیشگی"), Mask in Public ("پنهان‌سازی در محیط عمومی"), Always Mask ("همیشه ماسک‌شده").

---

### 6. Authentication Section (احراز هویت و قفل)
* **Purpose:** Manages access parameters and local lockouts.
* **Controls & Options:**
  * **PIN Lock Status (وضعیت رمز عبور):**
    * *Layout:* Status Info Tile.
    * *Status:* Active ("فعال") styled with success green.
  * **Change PIN Code (تغییر پین‌کد ورود):**
    * *Layout:* Navigation Detail Tile.
    * *Subtext:* "تنظیم رمز عبور ۶ رقمی اختصاصی غیرتکراری" (Redirects to PIN entry).
  * **Biometric Authentication (احراز هویت زیست‌سنجی):**
    * *Layout:* Switch Control Tile.
    * *Subtext:* "ورود سریع با اثر انگشت یا تشخیص چهره سخت‌افزار" (Requires biometrics prompt).
  * **Authentication Method Status (وضعیت روش احراز هویت):**
    * *Layout:* Status Read-Only Tile.
    * *Value:* "سخت‌افزاری فعال - کلاس ۳ امن" (Class 3 hardware active).
  * **Auto Lock (قفل خودکار برنامه):**
    * *Layout:* Selector Option Tile.
    * *Values:* Immediately ("فوری"), After 1 Minute ("پس از ۱ دقیقه"), After 5 Minutes ("پس از ۵ دقیقه"), Never ("هرگز").
  * **Failed Login Counter (سقف مجاز تلاش‌های ناموفق):**
    * *Layout:* Dropdown Selector Tile.
    * *Options:* 3 Attempts ("۳ بار تلاش"), 5 Attempts ("۵ بار تلاش"), 10 Attempts ("۱۰ بار تلاش").
    * *Action subtext:* "در صورت رد کردن سقف مجاز، پایگاه داده به مدت ۳۰ دقیقه قفل خواهد شد."

---

### 7. Device Security Section (امنیت دستگاه و سیستم‌عامل)
* **Purpose:** Monitors operating system integrity and active developer environments.
* **Controls & Options (Read-Only Statuses):**
  * **Root Detection Status (وضعیت روت بودن دستگاه):**
    * *Layout:* Status Row.
    * *Status:* Unrooted / Safe ("عدم شناسایی روت - امن") styled with emerald green, or Rooted / Vulnerable ("دستگاه روت شده است - آسیب‌پذیر") with crimson red.
  * **Developer Mode Warning (وضعیت گزینه‌های توسعه‌دهنده):**
    * *Layout:* Status Row with Warning.
    * *Status:* Active / Warning ("فعال - خطر احتمالی") styled with gold amber, or Disabled / Safe ("غیرفعال - امن") with emerald green.
  * **USB Debugging Warning (اشکال‌زدایی USB):**
    * *Layout:* Status Row with Warning.
    * *Status:* Active / Warning ("فعال - خطر ردیابی") styled with gold amber.
  * **System Integrity Status (یکپارچگی امنیت سیستم‌عامل):**
    * *Layout:* Status Row.
    * *Status:* Verified ("تایید شده توسط سرویس امنیتی هسته") with emerald green.
  * **Device Lock Status (وضعیت قفل سیستمی صفحه نمایش):**
    * *Layout:* Status Row.
    * *Status:* Active ("قفل صفحه نمایش فعال است") with emerald green.

---

### 8. Encryption Section (لایه رمزگذاری و کلیدها)
* **Purpose:** Audits the database storage encryption layer.
* **Controls & Options (Read-Only Statuses):**
  * **Database Encryption Status (وضعیت رمزنگاری پایگاه داده محلی):**
    * *Layout:* Status Row.
    * *Status:* Fully Encrypted ("۱۰۰٪ رمزگذاری‌شده و محافظت‌شده") with emerald green.
  * **Encryption Algorithm (الگوریتم رمزنگاری فعال):**
    * *Layout:* Subtext Metadata Row.
    * *Value:* "SQLCipher AES-256-CBC" styled with monospace fonts.
  * **Master Key Status (وضعیت کلید اصلی سخت‌افزار):**
    * *Layout:* Status Row.
    * *Status:* Bound to TEE ("ذخیره‌شده در تراشه سخت‌افزاری TEE / StrongBox") with emerald green.
  * **Backup Encryption Status (وضعیت رمزنگاری فایل‌های پشتیبان):**
    * *Layout:* Status Row.
    * *Status:* AES-GCM Encrypted ("رمزگذاری‌شده با کلید مشتق‌شده PBKDF2") with emerald green.
  * **Integrity Verification (بررسی صحت و یکپارچگی فایل‌ها):**
    * *Layout:* Action Selector.
    * *Subtext:* "بررسی خودکار عدم دستکاری داده‌های دیسک محلی" (Triggers integrity checksum routine).

---

### 9. Permission Status (وضعیت مجوزهای سیستمی)
* **Purpose:** Displays active permissions needed for automated operations.
* **Controls & Options:**
  * **SMS Permission (مجوز دسترسی به پیامک‌ها):**
    * *Layout:* Switch/Action Tile.
    * *Status:* Granted ("اعطا شده") with green dot, or Denied ("دسترسی قطع است") with gold amber alert. Tapping redirects to native OS permission settings.
  * **Notification Permission (مجوز اعلان‌های سیستم):**
    * *Layout:* Switch/Action Tile.
    * *Status:* Granted ("فعال") with green dot.
  * **Biometric Permission (دسترسی زیست‌سنجی سیستمی):**
    * *Layout:* Switch/Action Tile.
    * *Status:* Granted ("تایید شده") with green dot.
  * **Storage Permission (مجوز دسترسی به فایل‌های محلی):**
    * *Layout:* Switch/Action Tile.
    * *Status:* Denied ("مجوز صادر نشده است") with gold amber. (Used only for local backups).
  * **Battery Optimization Status (وضعیت بهینه‌سازی مصرف باتری):**
    * *Layout:* Switch/Action Tile.
    * *Status:* Restricted / Warning ("محدود شده - خطر قطع شدن رصد پیامک‌ها") with gold amber. Tapping redirects to background activity exemption screen.

---

### 10. Threat Alerts (هشدارهای امنیتی پویا)
* **Purpose:** Visually highlights security risks that require immediate user action.
* **Visual Style:** Alerts are stacked at the top of Region 4 in Zone B. Each warning is rendered as a prominent card using warning gold amber or critical crimson red color tokens, utilizing `bankyar.radius.md` and a bold border outline (`bankyar.border.width.thick`).
* **Threat Alert Cards Mapping:**
  1. **Weak PIN Alert Card (کارت هشدار پین‌کد ضعیف):**
     * *Icon:* Warning circle icon with an exclamation mark.
     * *Background:* Light amber gold tint.
     * *Text:* **"پین‌کد ورود ضعیف است"** (Weak PIN). Subtext: "رمز عبور انتخابی شما ساده یا تکراری است. لطفاً برای امنیت بیشتر آن را تغییر دهید."
     * *Action Button (Logical End):* "اصلاح" (Change PIN).
  2. **Missing Permission Alert Card (کارت هشدار مجوز دسترسی قطع شده):**
     * *Icon:* Warning shield icon.
     * *Background:* Light amber gold tint.
     * *Text:* **"دسترسی به پیامک‌ها قطع شده است"** (Missing SMS Permission). Subtext: "بانک‌یار بدون این مجوز قادر به تحلیل خودکار پیامک‌های بانکی نیست."
     * *Action Button (Logical End):* "فعال‌سازی" (Grant Permission).
  3. **Outdated Backup Alert Card (کارت هشدار پشتیبان‌گیری قدیمی):**
     * *Icon:* Outdated history clock icon.
     * *Background:* Light amber gold tint.
     * *Text:* **"از آخرین پشتیبان‌گیری بیش از ۳۰ روز گذشته است"** (Outdated Backup). Subtext: "برای جلوگیری از دست رفتن ناگهانی اطلاعات، فایل پشتیبان جدید تهیه کنید."
     * *Action Button (Logical End):* "پشتیبان‌گیری" (Backup Now).
  4. **Disabled Encryption Alert Card (کارت هشدار رمزنگاری غیرفعال):**
     * *Icon:* Critical warning octagonal shield icon.
     * *Background:* Light crimson red tint.
     * *Text:* **"رمزگذاری پایگاه داده موقتاً غیرفعال است!"** (Disabled Encryption). Subtext: "پایگاه داده به علت خطای سیستمی بدون رمزنگاری لود شده است. امنیت مالی شما در خطر است."
     * *Action Button (Logical End):* "فعال‌سازی مجدد" (Re-encrypt).
  5. **Battery Optimization Issue Alert Card (کارت هشدار بهینه‌سازی باتری):**
     * *Icon:* Power battery flash icon.
     * *Background:* Light amber gold tint.
     * *Text:* **"محدودیت مصرف باتری در پس‌زمینه"** (Battery optimization active). Subtext: "ممکن است سیستم‌عامل فرآیند رصد پیامک‌های جدید را در پس‌زمینه متوقف کند."
     * *Action Button (Logical End):* "حذف محدودیت" (Ignore Optimization).
  6. **Potential Risk Notification (اعلان هشدارهای پتانسیل ریسک):**
     * *Icon:* Information shield icon.
     * *Background:* Light neutral blue tint.
     * *Text:* **"بررسی محیط توسعه‌دهنده"** (Developer mode warning). Subtext: "فعال بودن گزینه‌های توسعه‌دهنده احتمال نفوذ محلی را افزایش می‌دهد."
     * *Action Button (Logical End):* "توضیحات" (Details).

---

### 11. Security Recommendations (توصیه‌های امنیتی هوشمند)
* **Purpose:** Offers personalized, smart suggestions to improve the user's security posture.
* **Visual Style:** Horizontal scrolling lane displaying two-toned cards styled with `bankyar.radius.md` and standard borders.
* **Recommendations Content:**
  * **Recommendation 1:** **"کلید بازیابی ۱۲ کلمه‌ای خود را صادر کنید"** (Export Recovery Phrase). Subtext: "در صورت مفقود شدن رمز عبور، این کلید تنها راه دسترسی مجدد به پایگاه داده است."
  * **Recommendation 2:** **"محافظت در برابر برنامه‌های جانبی را فعال کنید"** (Enable overlay block). Subtext: "بستن دسترسی برنامه‌هایی که می‌توانند روی صفحه برنامه پنجره‌های مخفی باز کنند."

---

### 12. Emergency Actions (اقدامات اضطراری - انهدام)
* **Purpose:** Provides direct controls to lock the app or erase data under physical threats.
* **Visual Style:** Grouped within a high-contrast container at the bottom of Region 5. Employs prominent error crimson and warning amber color tokens.
* **Actions & Interfaces:**
  * **Lock Application (قفل فوری نرم‌افزار):**
    * *Layout:* Destructive Red Action Button.
    * *Text:* "قفل فوری پایگاه داده و خروج" (Locks database connection, zeroizes RAM caches, and closes).
  * **Logout - Future Ready (خروج موقت - آتی):**
    * *Layout:* Action Button styled with "به‌زودی" (Coming Soon) badge.
    * *Text:* "غیرفعال‌سازی موقت نشست ورود" (Invalidates the active session safely).
  * **Erase Local Data (حذف کامل پایگاه داده و اطلاعات):**
    * *Layout:* High-contrast Solid Crimson Button.
    * *Text:* **"حذف کامل و انهدام تمامی اطلاعات محلی"** (Purges all databases, zeroizes keys, and wipes files).
    * *Destructive Rule:* Triggers a multi-step confirmation bottom sheet. The user must hold down the confirm button for 3 seconds to complete the deletion, protecting against accidental taps.
  * **Reset Security Settings (بازنشانی تنظیمات امنیتی):**
    * *Layout:* Outlined Action Button.
    * *Text:* "بازنشانی تمامی تنظیمات امنیتی به حالت پیش‌فرض".
  * **Export Security Report (خروجی گزارش امنیتی محلی):**
    * *Layout:* Outlined Action Button.
    * *Text:* "صادرات گزارش عیب‌یابی آفلاین به فایل متنی".

---

### 13. Bottom Navigation (ناوبری پایینی پایدار)
* **Purpose:** Coordinates system-wide tab navigation.
* **Visual Style:** Persistent Bottom Navigation Bar pinned to the bottom of Zone C.
* **Tabs RTL Distribution (Right to Left):**
  1. **دفترچه (Ledger):** Default de-selected state.
  2. **نمودارها (Analytics):** De-selected state.
  3. **قوانین (Rules):** De-selected state.
  4. **تنظیمات (Settings):** Active state, highlighted with a soft back-pill indicator styled with primary color tokens.

---

## Visual Requirements

The Security & Privacy Center utilizes the **Material Design 3 (MD3)** design language, featuring high-contrast visual hierarchies and clean geometric layouts:

* **Security-Focused Color Hierarchy:**
  * **Emerald Green:** Represents secure, verified, and optimal states (`bankyar.semantic.color.status.success`).
  * **Amber Gold:** Represents active warnings, missing permissions, or items requiring attention (`bankyar.semantic.color.status.warning`).
  * **Crimson Red:** Represents critical security risks, disabled encryption, or destructive actions (`bankyar.semantic.color.status.error`).
  * **Teal Blue:** Represents general security info and educational tips.
* **Layout Grid & Spacing:**
  * Strictly aligns with the **8-unit grid System** utilizing standard design tokens (e.g. `bankyar.space.xs`, `bankyar.space.md`, `bankyar.space.lg`).
  * Screen margins scale dynamically based on screen sizes, matching the `bankyar.responsive.margin` token.
* **Rounded Cards & Containers:**
  * Primary cards and lists are styled with standard rounded corners matching `bankyar.radius.lg` (large corner curves).
  * Warning alert panels and recommendation cards use tighter `bankyar.radius.md` (medium corner curves) corners.
* **Typography:**
  * Styled with the Persian-optimized typeface family `bankyar.global.font.family.primary`, adjusting line heights and tracking to prevent character overlapping.
* **Soft Elevations:**
  * Complies with physical containment principles: cards are rendered flat using fine outlines (`bankyar.semantic.color.border.subtle`) rather than heavy drop shadows, minimizing visual clutter.

---

## Interactive State Visual Mapping

To provide instant visual and tactile confirmation to the user, components modify their visual layers based on standard interaction states:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed |
| :--- | :--- | :--- |
| **Default State** | Components sit flat on the background. Standard contrast levels are maintained. | Initial load state |
| **Loading State** | Progress bars animate with shimmering linear movements. Active toggles are locked. | Linear opacity loop under `bankyar.motion.duration.medium` |
| **Checking Security** | Score Card displays a spinning circular loading indicator. Borders pulse with a subtle gold glow. | Smooth pulse curve under `bankyar.motion.duration.slow` |
| **Success State** | Displays temporary checkmark icons with emerald green theme colors. | Transitions smoothly back to default state after 2 seconds |
| **Warning State** | Highlights components with gold amber borders (`bankyar.semantic.color.status.warning`) and text labels. | Immediate response trigger under `bankyar.motion.duration.instant` |
| **Critical Risk State**| Highlights components with high-contrast crimson red borders and warning icons. | Shake animation on horizontal axis on launch |
| **Error State** | Highlights input fields with high-contrast crimson borders and inline validation text. | Immediate response trigger under `bankyar.motion.duration.instant` |
| **Offline State** | Displays a flat, steady green status dot confirming no internet packets are transmitted. | Steady status state |
| **Permission Denied** | Toggle rows show yellow warning badges with "مجوز دسترسی صادر نشده است" subtext. | Highlights component with warning amber outlines |

---

## Responsive Design & Adaptive Viewports

The layout adapts dynamically across standard responsive breakpoints to preserve visual balance:

### 1. Phone Viewport (Standard Smartphones)
* **Grid Layout:** 4 Columns. Symmetrical outer margins are optimized for close physical interaction (`bankyar.space.lg`).
* **Navigation:** Persistent Bottom Navigation Bar positioned within comfortable thumb reach in Zone C.
* **Workspace:** Single scrollable ledger view. Items are stacked vertically in a single column in Zone B.

### 2. Large Phone Viewport
* **Grid Layout:** 4 Columns.
* **Visual Adaptation:** Spacing between cards and list items expands slightly (`bankyar.space.xl`) to protect visual balance.

### 3. Tablet Viewport
* **Grid Layout:** 8 Columns.
* **Visual Adaptation (Split Pane Master-Detail View):**
  * **Logical Start Pane (Right - 3 Columns):** The primary Categories list (Overall Security Score, Privacy Dashboard, Permissions).
  * **Logical End Pane (Left - 5 Columns):** Detailed parameters of the active category, preventing deep menu navigations.
* **Navigation:** Bottom Navigation Bar is replaced with a lateral Navigation Rail on the logical start (right) edge, optimizing screen real estate.

### 4. Foldable Viewport
* **Grid Layout:** 8 Columns.
* **Visual Adaptation:** Adapts based on hinge coordinates. Supports dual-screen layouts with the Category overview list on the right fold, and advanced settings control parameters on the left fold.

### 5. Landscape Orientation
* **Grid Layout:** Horizontal split layout. Categorized list moves to a double-column configuration to prevent settings rows from stretching, preserving readability.

---

## Accessibility & Inclusive Design

The Security & Privacy Center is built to satisfy **WCAG 2.2 AA Compliance** standards natively:

* **Native RTL Persian Layouts:** Alignments, reading flows, transitions, and chevron indicators point naturally from right to left.
* **Screen Reader Semantic Support:**
  * Every switch, button, and alert card exposes clear, descriptive accessibility labels (e.g. "کلید حریم خصوصی پنهان‌سازی مبالغ، غیرفعال است. دو بار ضربه بزنید تا فعال شود.").
  * Screen readers read the overall security score and level badge as a single unified semantic block.
* **Large Fonts & Infinite Scalability:**
  * All containers, cards, and app bars expand vertically without clipping or overlapping text under dynamic system font scaling up to 200%.
* **Minimum Touch Target Envelopes:**
  * All interactive buttons, toggle switches, and list rows maintain a minimum clickable area of `bankyar.space.xl` (conforming to the 48-unit Material minimum), protecting users with motor impairments.
* **Color Blind Safe Dual-Encoding:**
  * Visual indicators (such as score ratings, root status, and alert levels) never rely on color alone. Status values are dual-encoded with distinct icons and bold text labels (e.g., a green shield icon alongside the text "امن", and an amber octagonal icon alongside "هشدار").

---

## Future-Ready Expansion Hooks

The Security & Privacy Center includes dedicated architectural slots to support upcoming enterprise security integrations without requiring a visual redesign:

* **Hardware Security Module (HSM) Support:** Reserved slot inside the Encryption section to monitor hardware-backed HSM integration.
* **Passkeys & FIDO2 Authentication:** Prepared interface hooks to register biometrics as a system-wide passkey.
* **Cloud Security Dashboard (Opt-in):** Reserved category slot below "Encryption" to toggle secure cloud integrations. Includes clear warnings explaining security tradeoffs.
* **Security Audit History Log:** Slot prepared under the Threat Alerts section to view local, tamper-proof security audit history.
* **AI Security Advisor:** Reserved interface space within Security Recommendations to display localized, AI-powered security suggestions.
* **Multiple User Profiles:** Prepared header section to quickly swap between "حساب شخصی" (Personal account) and "حساب کاری" (Business account).
* **Remote Device Verification:** Prepared layout hooks to register and verify secondary secure local devices.

---

## Design Token Mapping Reference

Every visual property specified in this document maps directly to an active architectural design token, preserving long-term design consistency.

| Screen Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background.canvas` |
| Primary Container Card| Card Background Fill | `bankyar.semantic.color.surface.default` |
| Settings Section Header| High Contrast Title Font | `bankyar.semantic.color.text.primary` |
| Supporting Subtext | Medium Contrast Subtitle | `bankyar.semantic.color.text.secondary` |
| Row Separators & Dividers| Stroke Line | `bankyar.semantic.color.border.subtle` |
| Focus Outlines | Active Ring Color | `bankyar.semantic.color.focus.outline` |
| Toggle Active Fill | Primary Accent Color | `bankyar.semantic.color.primary.active` |
| Score Green Accent | Success Status Color | `bankyar.semantic.color.success.default` |
| Score Amber Accent | Warning Status Color | `bankyar.semantic.color.status.warning` |
| Score Crimson Accent | Error Status Color | `bankyar.semantic.color.status.error` |
| List & Menu Icons | Icon Stroke Color | `bankyar.semantic.color.icon.default` |
| Touch Target Boundaries| Sizing Spacing Factor | `bankyar.space.xl` |
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
