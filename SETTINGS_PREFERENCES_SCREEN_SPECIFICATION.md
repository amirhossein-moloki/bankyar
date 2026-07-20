# BankYar Settings & Preferences Screen Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, Senior UX Architect, Flutter UI Architect, Material Design 3 Expert, Privacy-by-Design Consultant, Android Human Interface Specialist, Enterprise FinTech Designer
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Settings & Preferences experience is designed as the administrative command center of an offline-first, secure, and privacy-centric mobile personal finance platform. Under native **Persian (RTL)** layouts and strict **on-device data sovereignty boundaries** (zero network permission, zero cloud trackers), configuring the app must be clear, transparent, and completely under the user's control.

This specification outlines the complete, production-ready visual architecture, layout rhythm, spatial grids, typography scale, interactive behaviors, responsive modes, and accessibility structures for the Settings screen. Built entirely on **Material Design 3 (MD3)** design systems, it utilizes design tokens to allow themes to adapt dynamically, ensuring a premium, reassuring, and highly secure digital workspace.

---

## Screen Blueprint & Spatial Mapping

The Settings & Preferences screen utilizes the logical three-zone vertical layout model. Horizontal scrolling lanes, list tile structures, search elements, and interactive dividers mirror natively to support Persian RTL workflows.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY APP BAR & INTEGRATED SEARCH]                           |
|  +-------------------------------------------------------------------+  |
|  | [Diagnostic Badge]        [Screen Title]             [Back Chevron] |
|  |                                                                   |  |
|  | [Integrated Search Input / Text Field (With Masking Toggle)]      |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & SETTINGS REGIONS]                      |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 1: Security Status Overview Card]                        |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | Shield Icon | Status: Fully Encrypted & Offline       |     |  |
|  |     | Encryption: SQLCipher AES-256 | Active Session        |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 2: Profile Section (Future Sync / Lock State Indicator)] |  |
|  |                                                                   |  |
|  |  [Region 3: Scrollable Settings List Grouped by Categories]       |  |
|  |                                                                   |  |
|  |     [Category Header: عمومی (General)]                            |  |
|  |     - Default Startup Screen | Date & Number Format | Currency      |  |
|  |     - App Version & Storage Usage                                 |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: پوسته و ظاهر (Appearance)]                  |  |
|  |     - Theme | Font Size | Animation | Contrast | Dynamic Color    |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: اعلان‌ها (Notifications)]                   |  |
|  |     - Enable | Sound | Vibration | Priority | Preview | Silent    |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: حریم خصوصی (Privacy)]                       |  |
|  |     - Hide Amounts | Hide Balance | Blur Recent | Screens/Clipboard |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: امنیت و قفل (Security)]                     |  |
|  |     - PIN Lock | Biometric Auth | Auto Lock | Attempts | Timeout  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: مدیریت بانک‌ها (Bank Management)]            |  |
|  |     - Active Banks | SMS Templates Override & Future Updates      |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: شناسایی پیامک (SMS Detection)]              |  |
|  |     - Real-Time Listeners | Inbox Scan | Permissions | Battery    |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: پشتیبان‌گیری (Backup & Restore)]             |  |
|  |     - Manual Local Backup | Restore | Encrypted Key Export        |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: ورود و خروج داده (Import & Export)]         |  |
|  |     - JSON/CSV Export | Settings Profiles Import                  |  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: زبان و منطقه (Language & Region)]           |  |
|  |     - Interface Language | Regional Calendar | First Day of Week  |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: دسترسی‌پذیری (Accessibility)]               |  |
|  |     - Large Fonts | High Contrast | Reduce Motion | Screen Reader |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: درباره بانک‌یار (About)]                    |  |
|  |     - App Version | Licenses | Support | Privacy Policy | Roadmap   |
|  |     ---------------------------------------------------------     |  |
|  |     [Category Header: تنظیمات توسعه‌دهندگان (Developer Options)]   |  |
|  |     - Sandbox Parsers | DB Inspector | Diagnostic Logs             |  |
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
The Settings & Preferences Screen provides a comprehensive, centralized administrative environment for BankYar. Operating natively in **Persian (RTL)**, its objective is to let the user customize system behaviors, toggle privacy controls, auditing parameters, modify accessibility scaling, configure security lockouts, and manage local database backups, while reinforcing absolute trust via continuous offline diagnostics status cues.

### 2. Business Objectives
* **Build Digital Sovereignty Trust:** Deliver visible security status indicators highlighting the local, encrypted SQLite/SQLCipher storage with zero cloud dependencies.
* **Streamline Configuration Paths:** Logical category groupings reduce cognitive overhead and eliminate search friction.
* **Reduce Customer Support Demands:** Clear instructions, self-test diagnostics tools, and offline backup-and-restore facilities reduce user errors and help users self-recover.

### 3. User Goals
* **Lock Down Personal Data:** Toggle screenshot blocks, restrict clipboard snooping, enable biometric locks, and activate automatic background blurs.
* **Tailor SMS Parsing Behaviors:** Select specific active bank profiles, adjust SMS background monitoring permissions, and fine-tune heuristics rules.
* **Customize Visual Presentation:** Swap color themes, increase body font scales, and toggle user interface animations.
* **Secure Database Portability:** Generate encrypted backup keys and export databases to portable local file formats.

### 4. Entry Points
* **Shell Bottom Navigation Bar Tap:** Selecting the Settings icon tab (logical end, far left on RTL layout) opens the main Settings workspace.
* **Quick Settings App Bar Shortcut:** Tapping the profile avatar or settings icon inside the Home Dashboard header navigates to the Settings screen.
* **Security Lockout Prompts:** Post-biometric authentication failure options link directly to the local security parameters page of this screen.

### 5. Exit Points
* **Shell Bottom Navigation Bar Tap:** Selecting Ledger, Analytics, or Rules instantly updates the navigation shell context.
* **System Back Gesture / Native Back Chevron:** Returns the user to their immediate preceding workspace context.
* **System Decryption Lockout:** Initiating a destructive PIN purge or local database wipe safely locks the app and exits to the OS launch screen.

### 6. Navigation Behaviour
* **Cross-Fade Navigation Transitions:** Switching between settings tabs utilizes instant cross-fades to ensure standard device layouts respond immediately.
* **Hierarchical Push Transitions:** Drilling down into a settings detail screen (e.g., individual bank templates) slides horizontally from the logical start edge (right) to the logical end edge (left).
* **Dismissible Sheets:** Choosing settings options (e.g., currency default selection) triggers a bottom sheet that slides up from Zone C.

### 7. Information Hierarchy
* **Primary Visual Tier:** Security Status Overview Card showing the current encryption state and the search settings container in Zone A.
* **Secondary Visual Tier:** Settings Category Groups (عمومی, امنیت, حریم خصوصی, بانک‌ها) styled with uppercase, high-contrast typography.
* **Tertiary Visual Tier:** Interactive settings list rows displaying visual icons, descriptive title labels, active parameter values, and standard toggle selectors.
* **Contextual Meta Tier:** Software version indicators, license declarations, and the hidden developer options section.

---

## Detailed Category Specifications

### 1. General Settings (تنظیمات عمومی)
* **Default Startup Screen (صفحه شروع پیش‌فرض):**
  * *Layout:* Interactive Selector Tile.
  * *Persian Term:* "صفحه شروع پیش‌فرض"
  * *Values:* Ledger ("دفترچه تراکنش‌ها"), Analytics ("داشبورد نمودارها"), Rules ("مدیریت قوانین").
  * *Interaction:* Displays a system bottom sheet displaying selection list.
* **Date Format (فرمت تاریخ):**
  * *Layout:* Interactive Selector Tile.
  * *Persian Term:* "فرمت تاریخ"
  * *Values:* Solar Hijri standard format (e.g., "۱۴۰۲/۱۰/۱۲"), Relative format (e.g., "امروز، ۳ ساعت پیش"), Gregorian format ("۲۰۲۴/۰۱/۰۲").
* **Number Format (فرمت اعداد):**
  * *Layout:* Toggle Switch Option.
  * *Persian Term:* "فرمت اعداد"
  * *Options:* Localized Persian numerals ("۱۲,۴۰۰,۰۰۰") vs Standard Latin digits ("12,400,000") for financial fields.
* **Currency Display (نمایش واحد پولی):**
  * *Layout:* Selector Option.
  * *Persian Term:* "نمایش واحد پولی"
  * *Values:* Tomans ("تومان") by default, Rials ("ریال").
* **App Version (نسخه برنامه):**
  * *Layout:* Static Text Row with Copy Action.
  * *Persian Term:* "نسخه برنامه"
  * *Value:* Active semantic version (e.g., "v1.0.0").
  * *Secret Trigger:* Tapping this row seven consecutive times triggers a success toast ("شما اکنون توسعه‌دهنده هستید!") and reveals the Hidden Developer Options category.
* **Storage Usage (میزان فضای ذخیره‌سازی):**
  * *Layout:* Subtitle Row with Cleanup Trigger.
  * *Persian Term:* "میزان فضای ذخیره‌سازی"
  * *Display:* Monospace storage metrics (e.g., "۱۴.۲ مگابایت" - representing encrypted DB and cached assets). Includes a secondary action button "پاک‌سازی حافظه موقت" to prune diagnostic log files.

---

### 2. Appearance (پوسته و ظاهر)
* **Theme (پوسته برنامه):**
  * *Layout:* Horizontal Choice Chip Segmented Control.
  * *Persian Term:* "پوسته برنامه"
  * *Options:* Light ("روشن"), Dark ("تاریک"), System ("سیستم").
  * *Behavior:* Selecting an option changes the global theme immediately, applying the respective semantic tokens without requiring a reload.
* **Font Size (اندازه قلم):**
  * *Layout:* Linear Slider Option.
  * *Persian Term:* "اندازه قلم"
  * *Values:* Standard ("استاندارد"), Medium ("متوسط"), Large ("بزرگ"), Extra Large ("خیلی بزرگ").
  * *Behavior:* Dragging the slider modifies the active typography scale token, updating all text sizes immediately.
* **Animation Toggle (تغییر وضعیت پویانمایی):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "تغییر وضعیت پویانمایی"
  * *Subtext:* "بهینه‌سازی روان‌بودن حرکت صفحات در دستگاه‌های قدیمی"
  * *Behavior:* Disabling this option enforces immediate visual jumps and disables transition curves, saving system resources.
* **High Contrast Mode (حالت کنتراست بالا):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "حالت کنتراست بالا"
  * *Behavior:* Elevates black-and-white background contrast levels, satisfying WCAG AAA standards for low-vision readability.
* **Dynamic Color Support (پشتیبانی از رنگ پویا):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "پشتیبانی از رنگ پویا"
  * *Subtext:* "انطباق رنگ‌های برنامه با تصویر زمینه گوشی (اندروید ۱۲ به بالا)"
  * *Behavior:* Resolves Foundation theme tokens dynamically against Android Monet engine palettes.

---

### 3. Notifications (اعلان‌ها)
* **Enable Notifications (فعال‌سازی اعلان‌ها):**
  * *Layout:* Primary Switch Control Tile.
  * *Persian Term:* "فعال‌سازی اعلان‌ها"
  * *Behavior:* Master switch. Disabling this option grays out all subsequent child notification settings, applying the inactive state opacity to them.
* **Notification Sound (صدای اعلان):**
  * *Layout:* Interactive Selector.
  * *Persian Term:* "صدای اعلان"
  * *Values:* Standard System Tone ("صدای پیش‌فرض سیستم"), Subtle Cash Register Tone ("صدای سکه مالی"), Silent ("بی‌صدا").
* **Vibration (لرزش):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "لرزش هنگام دریافت تراکنش"
* **Priority (اولویت):**
  * *Layout:* Dropdown Selector.
  * *Persian Term:* "اولویت نمایش"
  * *Options:* High ("بالا - نمایش فوری به صورت پاپ‌آپ"), Standard ("استاندارد - ثبت در نوار اعلان‌ها").
* **Silent Mode (حالت بی‌صدا):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "حالت بی‌صدا در ساعات استراحت"
  * *Subtext:* "عدم مزاحمت اعلان‌ها از ساعت ۲۳:۰۰ الی ۰۷:۰۰"
* **Grouped Notifications (اعلان‌های گروه‌بندی شده):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "گروه‌بندی هوشمند اعلان‌ها"
  * *Subtext:* "تجمیع تراکنش‌های مکرر مربوط به یک بانک در یک گروه اعلان"
* **Notification Preview (پیش‌نمایش اعلان):**
  * *Layout:* Segmented Choice Control.
  * *Persian Term:* "جزئیات پیش‌نمایش"
  * *Options:* Full Info ("نمایش کامل مبلغ و بانک"), Hide Amount ("پنهان‌سازی مبلغ تراکنش"), Secure Cover ("فقط عنوان بانک‌یار"). Protects privacy when lockscreen is visible.

---

### 4. Privacy (حریم خصوصی)
* **Hide Sensitive Amounts (پنهان‌سازی مبالغ حساس):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "پنهان‌سازی مبالغ حساس"
  * *Subtext:* "تاریک‌سازی و ماسک‌کردن خودکار مبالغ در صفحات پرتردد"
* **Hide Balance (پنهان‌سازی موجودی کل):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "پنهان‌سازی موجودی کل حساب‌ها"
* **Blur Recent Apps (محوسازی در برنامه‌های اخیر):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "محوسازی در پیش‌نمایش برنامه‌های اخیر"
  * *Subtext:* "جلوگیری از خوانده‌شدن موجودی در منوی چندوظیفگی سیستم‌عامل"
* **Screenshot Protection (محافظت در برابر عکس‌برداری):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "محافظت در برابر عکس‌برداری از صفحه"
  * *Subtext:* "مسدودسازی تهیه اسکرین‌شات و ضبط ویدیو از محیط برنامه"
  * *Behavior:* Enforces system secure window flags (`FLAG_SECURE`), displaying a black screen to screen recorders.
* **Clipboard Protection (محافظت از حافظه موقت):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "محافظت از حافظه موقت (کلیپ‌بورد)"
  * *Subtext:* "پاک‌سازی خودکار مبالغ کپی‌شده پس از ۳۰ ثانیه"
* **Privacy Mode (حالت حریم خصوصی عمومی):**
  * *Layout:* Master Selector Tile.
  * *Persian Term:* "سطح حریم خصوصی عمومی"
  * *Values:* Standard ("استاندارد"), Ultra-Secure ("فوق امنیتی - قفل خودکار سریع و پنهان‌سازی دائم اطلاعات").

---

### 5. Security (امنیت و قفل)
* **PIN Lock (قفل پین‌کد):**
  * *Layout:* Switch Control Tile with Sub-Action.
  * *Persian Term:* "قفل پین‌کد ورود"
  * *Subtext:* "تنظیم رمز عبور ۴ رقمی عددی اختصاصی"
  * *Behavior:* Activating this prompts the local Secure PIN Setup flow.
* **Biometric Authentication (احراز هویت زیست‌سنجی):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "احراز هویت زیست‌سنجی"
  * *Subtext:* "ورود سریع با اثر انگشت یا تشخیص چهره سیستم‌عامل"
* **Auto Lock (قفل خودکار):**
  * *Layout:* Selector Option.
  * *Persian Term:* "قفل خودکار برنامه"
  * *Values:* Immediately ("فوری پس از خروج"), After 1 Minute ("پس از ۱ دقیقه"), After 5 Minutes ("پس از ۵ دقیقه"), Never ("هرگز").
* **Failed Attempts (تلاش‌های ناموفق):**
  * *Layout:* Selector Dropdown.
  * *Persian Term:* "حد مجاز تلاش‌های ناموفق"
  * *Options:* 3 Attempts ("۳ بار تلاش"), 5 Attempts ("۵ بار تلاش"), 10 Attempts ("۱۰ بار تلاش").
  * *Destructive Rule:* Reaching the threshold locks the application database for 30 minutes, requiring a secure physical recovery flow.
* **Session Timeout (زمان انقضای نشست):**
  * *Layout:* Selector Dropdown.
  * *Persian Term:* "زمان انقضای نشست فعال"
  * *Options:* 5 Minutes ("۵ دقیقه"), 15 Minutes ("۱۵ دقیقه"), 30 Minutes ("۳۰ دقیقه").
* **Security Status Card (کارت وضعیت امنیت عمومی):**
  * *Layout:* Centered Status Card Container.
  * *Persian Term:* "وضعیت امنیت عمومی دستگاه"
  * *Visual Components:* Displays a green shield with "پایگاه داده ۱۰۰٪ رمزگذاری‌شده" (100% Encrypted Database). It details active SQLCipher on-disk encryption, local Android Keystore status, and the zero-network status confirming no external connections are active.

---

### 6. Bank Management (مدیریت بانک‌ها)
* **Supported Banks (بانک‌های پشتیبانی‌شده):**
  * *Layout:* Informational Count Badge.
  * *Persian Term:* "بانک‌های پشتیبانی‌شده فعال"
  * *Value:* e.g., "۲۴ بانک فعال" (24 active banks).
* **Enable/Disable Individual Banks (فعال/غیرفعال‌سازی هر بانک):**
  * *Layout:* Drilling Navigation Tile to List.
  * *Persian Term:* "مدیریت و فعال‌سازی بانک‌ها"
  * *Subtext:* "انتخاب کارت‌ها و پیامک‌های بانکی ورودی برای تحلیل"
  * *Behavior:* Navigates to a sub-screen listing all banks (e.g., Melli, Mellat, Tejarat, Saman) with individual switches. Turning a bank off ignores future SMS parsing requests for that bank.
* **Custom SMS Templates (قالب‌های پیامکی سفارشی):**
  * *Layout:* Drilling Navigation Tile.
  * *Persian Term:* "قالب‌های پیامکی اختصاصی"
  * *Subtext:* "تعریف الگوهای دستی برای قالب‌های پیامکی جدید یا تغییریافته"
* **Future Template Updates (بروزرسانی قالب‌های پیامکی):**
  * *Layout:* Interactive Option.
  * *Persian Term:* "بروزرسانی خودکار قالب‌ها"
  * *Values:* Off ("غیرفعال"), Manual Local File Import ("دریافت آفلاین از فایل قالب"). In keeping with zero-network policies, updates are imported via offline configuration files, preserving complete privacy.

---

### 7. SMS Detection (تنظیمات شناسایی پیامک)
* **Read Existing SMS (خواندن پیامک‌های موجود):**
  * *Layout:* Primary Call-to-Action Button inside list tile.
  * *Persian Term:* "اسکن و تحلیل پیامک‌های قدیمی صندوق ورودی"
  * *Subtext:* "تحلیل خودکار پیامک‌های بانکی گذشته در گوشی"
  * *Behavior:* Prompts local database scan, showing progress bar.
* **Listen for New SMS (رصد و دریافت پیامک‌های جدید):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "دریافت خودکار پیامک‌های جدید"
* **Background Monitoring Status (وضعیت نظارت در پس‌زمینه):**
  * *Layout:* Status Badge.
  * *Persian Term:* "وضعیت سرویس پس‌زمینه"
  * *Status:* Active ("فعال و در حال رصد") with green dot, or Disabled ("متوقف‌شده") with gray dot.
* **Permissions (مجوزهای دسترسی پیامک):**
  * *Layout:* Action Selector Tile.
  * *Persian Term:* "مجوز دسترسی به پیامک‌ها (SMS Permission)"
  * *Status:* Granted ("اعطا شده") or Missing ("دسترسی قطع است - نیاز به اقدام"). Tapping triggers native OS permission request popup.
* **Optimization Status (وضعیت بهینه‌سازی مصرف باتری):**
  * *Layout:* Status Info Tile.
  * *Persian Term:* "بهینه‌سازی باتری سیستم‌عامل (Battery Optimization)"
  * *Subtext:* "جلوگیری از توقف ناگهانی رصد پیامک‌ها توسط سیستم‌عامل"
  * *Status:* Optimized ("بدون محدودیت فعالیت پس‌زمینه") or Restricted ("محدود شده - مصرف باتری بهینه‌سازی شده").

---

### 8. Backup & Restore (پشتیبان‌گیری و بازیابی)
* **Manual Backup (پشتیبان‌گیری دستی):**
  * *Layout:* Action Button Tile.
  * *Persian Term:* "تهیه پشتیبان دستی (فایل آفلاین)"
  * *Subtext:* "تولید فایل پشتیبان رمزگذاری‌شده در حافظه گوشی"
* **Automatic Backup (پشتیبان‌گیری خودکار محلی - آتی):**
  * *Layout:* Switch Control (Future Ready).
  * *Persian Term:* "پشتیبان‌گیری دوره‌ای خودکار (آتی)"
* **Encrypted Export (خروجی رمزنگاری‌شده):**
  * *Layout:* Subtext Action.
  * *Persian Term:* "خروجی با کلید رمزگذاری اختصاصی"
  * *Behavior:* Prompts the user to write down a secure 12-word passphrase key. The database backup file cannot be restored on any device without this key, ensuring absolute data security.
* **Restore Backup (بازیابی فایل پشتیبان):**
  * *Layout:* Action Button Tile.
  * *Persian Term:* "بازیابی اطلاعات از فایل پشتیبان"
  * *Subtext:* "جایگزینی یا ادغام پایگاه داده با فایل پشتیبان قدیمی"
  * *Behavior:* Launches OS file picker, validates backup schema, prompts for password key.
* **Backup Information (اطلاعات آخرین فایل پشتیبان):**
  * *Layout:* Static Metadata Text.
  * *Persian Term:* "وضعیت آخرین پشتیبان‌گیری"
  * *Value:* "۱۴۰۲/۱۰/۱۲ - ساعت ۱۴:۳۲ (اندازه: ۲.۴ مگابایت)".

---

### 9. Import / Export (ورود و خروج داده)
* **Encrypted Export (صادرات رمزنگاری‌شده داده‌ها):**
  * *Layout:* Action Tile.
  * *Persian Term:* "صادرات امن بانک اطلاعاتی (.db)"
* **CSV Export - Future Ready (صادرات به قالب اکسل / CSV - آتی):**
  * *Layout:* Action Tile with "به‌زودی" (Coming Soon) badge.
  * *Persian Term:* "خروجی فایل اکسل (CSV)"
* **JSON Export - Developer (صادرات به قالب JSON):**
  * *Layout:* Developer Action Tile.
  * *Persian Term:* "صادرات تراکنش‌ها به قالب ساختاریافته (JSON)"
* **Import Settings (وارد کردن فایل تنظیمات):**
  * *Layout:* Action Tile.
  * *Persian Term:* "وارد کردن پیکربندی تنظیمات برنامه"
  * *Subtext:* "تنظیم سریع ترجیحات، بانک‌های فعال و قوانین شخصی از فایل"

---

### 10. Language & Region (زبان و منطقه)
* **Interface Language (زبان برنامه):**
  * *Layout:* Interactive Selector Tile.
  * *Persian Term:* "زبان برنامه"
  * *Values:* Persian ("فارسی - RTL") by default, English ("English - LTR") as an alternative fallback.
  * *Behavior:* Switching language changes layout flow parameters and typography baselines immediately.
* **Regional Calendar (گاه‌شمار منطقه):**
  * *Layout:* Selector Option.
  * *Persian Term:* "گاه‌شمار منطقه"
  * *Values:* Solar Hijri ("خورشیدی") by default, Gregorian ("میلادی").
* **First Day of the Week (اولین روز هفته):**
  * *Layout:* Dropdown Selector.
  * *Persian Term:* "اولین روز هفته"
  * *Options:* Saturday ("شنبه") by default, Sunday ("یکشنبه"), Monday ("دوشنبه") for regional localization alignment.

---

### 11. Accessibility (دسترسی‌پذیری)
* **Large Fonts (قلم‌های بزرگ):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "فعال‌سازی قلم‌های بزرگ"
  * *Behavior:* Overrides system text baseline, increasing layout scaling constraints.
* **Contrast (کنتراست پیشرفته):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "کنتراست رنگی پیشرفته"
* **Touch Target (حداقل اندازه اهداف لمسی):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "بزرگ‌نمایی مناطق لمسی"
  * *Subtext:* "افزایش ابعاد دکمه‌ها و کلیدها به حداقل ۴۸ واحد لمسی جهت ناوبری آسان‌تر"
* **Reduce Motion (کاهش پویانمایی‌ها):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "کاهش حرکات نمایشی (Reduce Motion)"
* **Screen Reader Support (پشتیبانی از صفحه‌خوان):**
  * *Layout:* Switch Control Tile.
  * *Persian Term:* "خوانش صوتی ساختار صفحه (Screen Reader)"
  * *Subtext:* "افزودن توضیحات صوتی و برچسب‌های متنی برای افراد نابینا و کم‌بینا"

---

### 12. About (درباره بانک‌یار)
* **Application Version (نسخه نرم‌افزار):**
  * *Layout:* Static Text.
  * *Persian Term:* "نسخه نرم‌افزار"
  * *Value:* "نسخه ۱.۰.۰ - آفلاین و امن"
* **Licenses (مجوزها):**
  * *Layout:* Navigation Tile.
  * *Persian Term:* "توافق‌نامه کاربری و مجوزها"
* **Privacy Policy (سند حریم خصوصی):**
  * *Layout:* Navigation Tile.
  * *Persian Term:* "سیاست حفظ حریم خصوصی داده‌ها"
  * *Subtext:* "تعهدنامه رسمی عدم خروج اطلاعات از تلفن همراه شما"
* **Open Source Libraries (کتابخانه‌های متن‌باز):**
  * *Layout:* Navigation Tile.
  * *Persian Term:* "کتابخانه‌های متن‌باز استفاده‌شده"
* **Contact Support (ارتباط با پشتیبانی آفلاین):**
  * *Layout:* Navigation Tile.
  * *Persian Term:* "ارتباط با پشتیبانی و گزارش خطا"
  * *Subtext:* "ارسال گزارش عیب‌یابی آفلاین بدون نیاز به اتصال مستقیم اینترنت"
* **Roadmap (نقشه راه توسعه):**
  * *Layout:* Navigation Tile.
  * *Persian Term:* "نقشه راه توسعه بانک‌یار"

---

### 13. Developer Options - Hidden (گزینه‌های توسعه‌دهنده - مخفی)
* **Diagnostic Logs (گزارش‌های عیب‌یابی):**
  * *Layout:* Action Tile.
  * *Persian Term:* "مشاهده گزارش خطای سیستم"
  * *Behavior:* Displays diagnostic console log stack.
* **Sandbox Test Parsing (محیط شبیه‌ساز تحلیل پیامک):**
  * *Layout:* Input Field and Tester.
  * *Persian Term:* "شبیه‌ساز و تست پیامک جدید"
  * *Behavior:* Developer inputs arbitrary mock SMS text strings to verify parsing accuracy against current regex structures instantly.
* **DB Inspector (بازرس مستقیم پایگاه داده محلی):**
  * *Layout:* Action Tile.
  * *Persian Term:* "بازرس پایگاه داده محلی (SQLite)"
  * *Behavior:* Read-only inspection table of raw database records.

---

### 14. Experimental Features - Future (ویژگی‌های آزمایشی - آتی)
* **Smart SMS Aggregation (تجمیع هوشمند تراکنش‌های پیامکی):**
  * *Layout:* Future-ready toggle list.
  * *Persian Term:* "تجمیع هوشمند تراکنش‌ها"
  * *Status:* Locked ("آزمایشی") with future indicator.

---

## Screen Regions & Layout Grid Architecture

The Settings & Preferences Screen is divided into four distinct visual layout zones managing vertical scrolling, interactive density, and search inputs:

```
+------------------------------------------------------------+
|  Region 1: App Bar Header & Integrated Search (Zone A - Pinned) |
+------------------------------------------------------------+
|  Region 2: General Security Status & Vault Card (Zone B - Scroll) |
+------------------------------------------------------------+
|  Region 3: Scrollable Categorized Settings List (Zone B - Scroll) |
+------------------------------------------------------------+
|  Region 4: Navigation Shell Footer (Zone C - Pinned)       |
+------------------------------------------------------------+
```

### 1. Region 1: App Bar Header & Integrated Search (Zone A - Pinned)
* **Visual Presentation:** Remains pinned at the top edge of the screen viewport, acting as the structural entrance anchor.
* **Layout Flow (RTL):**
  * **Logical Start Edge (Right):** The back navigation chevron (`bankyar.icon.back.rtl`) to exit back to previous page.
  * **Center:** Localized title text "تنظیمات و ترجیحات" (Settings & Preferences) styled with `bankyar.semantic.typography.heading.md`.
  * **Logical End Edge (Left):** Green status icon indicating the on-device secure encryption engine and fully offline mode badge.
* **Integrated Search Box:** Positioned immediately below the header row, spanning the full width of the spatial grid.
  * *Sizing & Spacing:* Uses `bankyar.radius.full` corner rounding and `bankyar.space.md` external margin padding.
  * *Interactions:* Typing localized keywords (e.g., "رمز", "پشتیبان", "باتری") dynamically filters the scrollable settings list below, displaying only matching rows and highlighting search phrases.

### 2. Region 2: General Security Status & Vault Card (Zone B - Scroll)
* **Visual Presentation:** The top card element in the scrollable content container, reinforcing user trust immediately on load.
* **Layout Flow (RTL):** Spans the entire horizontal workspace grid, utilizing symmetric `bankyar.responsive.margin` gutters.
  * *Containment:* Styled with `bankyar.radius.large` corner curve and a low-saturation background fill (`bankyar.semantic.color.surface.default`).
  * *RTL Internal Grid:*
    * **Logical Start (Right):** Linear vector shield icon symbolizing the local secure key store.
    * **Center Column:** Title text "وضعیت صندوقچه امن محلی" (Local Secure Vault Status) with secondary description text stating database encryption type ("رمزگذاری پیشرفته SQLite AES-256") and connection-free operations ("ارتباط اینترنتی کاملاً مسدود است").
    * **Logical End (Left):** Flat circular badge "کاملاً آفلاین" (100% Offline) in success green theme.

### 3. Region 3: Scrollable Categorized Settings List (Zone B - Scroll)
* **Visual Presentation:** The primary scrolling body container hosting setting controls.
* **Rhythm & Sectioning (RTL):**
  * **Category Section Headers:** Styled with high-contrast, bold typography (`bankyar.semantic.typography.title.sm`), left-aligned to the right (logical start) edge of the page. It utilizes a vertical separation spacer of `bankyar.space.lg` from previous elements.
  * **Settings List Rows (List Tiles):** Each row is structured as an interactive list tile container of `bankyar.space.xl` height to ensure spacious readability.
    * **Logical Start (Right):** Linear theme icon representing the settings option (e.g., notification bell, gear, key padlock).
    * **Middle Text Block:** Option title in primary text color with secondary description text below it.
    * **Logical End (Left):** Active control component. Matches option type: Toggle Switch, Right-pointing Arrow chevron, or active parameter status text (e.g., "تومان", "نسخه ۱.۰.۰").
  * **Dividers:** Low-contrast hairline dividers (`bankyar.semantic.color.border.subtle`) are placed below individual setting rows to prevent vertical clutter.

### 4. Region 4: Navigation Shell Footer (Zone C - Pinned)
* **Visual Presentation:** Persistent Bottom Navigation Bar pinned to the bottom edge of the screen, supporting standard thumb navigation.
* **Tabs RTL Distribution (Right to Left):**
  1. **دفترچه (Ledger):** De-selected default state.
  2. **نمودارها (Analytics):** De-selected state.
  3. **قوانین (Rules):** De-selected state.
  4. **تنظیمات (Settings):** Active state, highlighted with a soft back-pill indicator styled with primary color tokens.

---

## Detailed Component Specifications

### 1. Integrated Settings Search Bar
* **Purpose:** Lets users quickly locate settings options, reducing cognitive fatigue.
* **Position:** Zone A (Pinned).
* **Priority:** High.
* **Visual Style:** Outlined box container using `bankyar.radius.full` corner curves and subtle focus outlines on tap.
* **Interactions:**
  * Typing text dynamically filters settings list.
  * Tapping the clear icon (logical left edge) resets input.
* **Accessibility:** Screen reader announces: *"Search settings, text field. Double tap to enter keywords."*
* **RTL Mirroring:** Text input cursor aligns right (start edge).

### 2. General Settings Toggle List Card
* **Purpose:** Hosts core behavioral preferences.
* **Position:** Zone B (Scrollable).
* **Priority:** High.
* **Visual Style:** Flat list container separated by hairline dividers.
* **Interactive Elements:**
  * **Toggle Switch Component:** Material Design 3 Switch. Tapping the switch toggles binary configurations (e.g., number format, notifications sound) with smooth sliding transitions.
  * **Selector Chevron Component:** Interactive row with trailing chevron pointing left (`bankyar.icon.chevron.rtl`). Tapping opens options menu in bottom sheet.

### 3. Security Lockout Shield Card
* **Purpose:** Displays general application-wide security parameters and local database health.
* **Position:** Zone B (Scrollable).
* **Priority:** Critical.
* **Visual Style:** Flat, low-contrast container card using `bankyar.radius.medium` curves and green status borders.
* **Interactions:** Read-only data presentation. Tapping triggers self-test diagnostic routines, blinking the green border under normal conditions.

### 4. Database Export & Backup Progress Component
* **Purpose:** Provides progress feedback during local SQLCipher backups and database imports.
* **Position:** Zone B (Scrollable).
* **Priority:** Medium.
* **Visual Style:** Linear progress indicator bar nestled below the Backup Action card.
* **Interactions:**
  * Disabled when backup operation is inactive.
  * Shows a smooth, horizontal progress filling bar from right to left (RTL) when backup or restore is running.
  * Displays percentage text (e.g., "۷۵٪") using monospace numbers.

### 5. Destructive Security Action Drawer
* **Purpose:** Confirms destructive tasks (e.g., purging local database history).
* **Position:** Zone C (System Sheet Overlay).
* **Priority:** High.
* **Visual Style:** Bottom sheet sliding vertically up from Zone C, containing warning messages.
* **RTL Button Actions:**
  * **Logical Start (Right):** "تایید و حذف کامل اطلاعات" (Confirm and Delete All Data) styled with semantic error crimson scale.
  * **Logical End (Left):** "انصراف" (Cancel Action) styled with neutral background border.

---

## Interactive State Visual Mapping

To provide instant visual and tactile confirmation to the user, components modify their visual layers based on standard interaction states:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed |
| :--- | :--- | :--- |
| **Default State** | Components sit flat on the canvas background. Standard text contrast is maintained. | Initial load state |
| **Pressed State** | Element surface contrast shifts by +2 steps. Applies tactile touch-scale compression of 0.98x. | Immediate response trigger under `bankyar.motion.duration.instant` |
| **Selected / Active State** | Toggle switches slide to active positions with primary color fill. Highlight pills appear. | Smooth transition under `bankyar.motion.duration.fast` |
| **Expanded State** | Selector menus expand vertically to display nested dropdown items. | Decelerated slide-down curve under `bankyar.motion.duration.medium` |
| **Collapsed State** | Dropped menus slide back into flat parent containers, hiding sub-fields. | Accelerated slide-up curve under `bankyar.motion.duration.fast` |
| **Loading State** | Progress bars animate with shimmering linear movements. Active toggles are locked. | Linear opacity loop under `bankyar.motion.duration.medium` |
| **Disabled State** | Row is overlayed with a 38% transparency opacity mask. Active touch listeners are deactivated. | Muted contrast change instantly |
| **Error / Alert State** | Borders are outlined with high-contrast crimson tokens. Alert warnings are displayed inline. | Shake animation on horizontal axis on launch |
| **Offline SECURE State** | Diagnostic badges display a steady green dot confirming no data packets are transmitted. | Steady status state |
| **Permission Missing State** | Toggle rows show yellow alert status icons with "مجوز دسترسی صادر نشده است" label. | Highlights component with warning amber outlines |
| **Success State** | Displays temporary checkmark icons with green theme colors. | Transitions smoothly back to default state after 2 seconds |

---

## Responsive Design & Adaptive Viewports

The Settings layout adapts dynamically across standard responsive breakpoints to preserve visual balance:

### 1. Phone Viewport
* **Grid Layout:** 4 Columns. Symmetrical outer margins are optimized for close physical interaction.
* **Navigation:** Persistent Bottom Navigation Bar positioned within comfortable thumb reach.
* **Workspace:** Single scrollable ledger view. Items are stacked vertically in a single column.

### 2. Large Phone Viewport
* **Grid Layout:** 4 Columns.
* **Visual Adaptation:** Spacing between categories and list items expands slightly to protect visual balance.

### 3. Tablet Viewport
* **Grid Layout:** 8 Columns.
* **Visual Adaptation (Split Pane Master-Detail View):**
  * **Logical Start Pane (Right - 3 Columns):** The primary Categories list (General, Appearance, Privacy, Security, SMS, Backup). Clicking a category updates the active detail view.
  * **Logical End Pane (Left - 5 Columns):** Detailed setting parameters page of the selected category, preventing deep menu navigations.
* **Navigation:** Bottom Navigation Bar is replaced with a lateral Navigation Rail on the logical start (right) edge, optimizing screen real estate.

### 4. Foldable Viewport
* **Grid Layout:** 8 Columns.
* **Visual Adaptation:** Adapts based on hinge coordinates. Supports dual-screen layouts with Categories list on the right fold, and settings control parameters on the left fold.

### 5. Landscape Orientation
* **Grid Layout:** Horizontal split layout. Categorized list moves to a double-column configuration to prevent settings rows from stretching, preserving readability.

---

## Accessibility & Inclusive Design

BankYar's Settings interface implements strict WCAG AA standards to guarantee access for all users:

* **Native RTL Persian Layouts:** Alignments, reading flows, transitions, and chevron indicators point naturally from right to left.
* **Screen Reader Semantic Support:**
  * Active elements must have clear, descriptive screen reader announcements (e.g., "اعلان‌ها فعال است، تغییر وضعیت" - Notifications enabled, toggle).
  * Grouped settings read hierarchical headings before reading nested lists.
* **Keyboard & Switch Navigation:**
  * Highlight focus indicators (`bankyar.semantic.color.focus.outline`) wrap active fields when navigating using tab keys or external switches.
  * Focus progression flows systematically from top-right to bottom-left (logical RTL order).
* **Minimum Touch Target Envelopes:** All interactive buttons, toggle switches, and list rows maintain a minimum clickable area of `bankyar.space.xl` (conforming to the 48-unit Material minimum), protecting users with motor impairments.
* **Dynamic Sizing & Font Scaling:** All text elements wrap automatically. List rows expand vertically to support large system font scales up to 200% without overlapping or clipping text.
* **Accessible Toggles & Color-Independent Indicators:**
  * Meaning is never conveyed solely by color. Toggle switches use tactile shapes (e.g., checkmark vs circle symbols) within the active switch slider track, assisting color-blind users.
  * Active states are confirmed with textual descriptors ("فعال" vs "غیرفعال").

---

## Future-Ready Expansion Hooks

The Settings layout includes dedicated architectural slots to support seamless upcoming features without redesigning the interface:

* **Cloud Sync (Future - Opt-in):** Reserved category slot below "Backup & Restore" to toggle encrypted cloud sync. Includes clear warnings explaining security tradeoffs.
* **Multiple Profiles (Future):** Allocated header section above categories to swap between "حساب شخصی" (Personal account) and "حساب کاری" (Business account).
* **AI Preferences (Future):** Reserved settings slot under "SMS Settings" to toggle localized AI-assisted transaction descriptions and automated categorizations.
* **Multi-device Sync (Future):** Slot prepared to list synced local hardware devices using encrypted peer-to-peer bluetooth connections.
* **Smart Notification Rules (Future):** Reserved settings submenu to let users define custom notification filters and transaction budget alerts.
* **Plugin System (Future):** Slot prepared under Developer settings to load custom offline bank SMS parsing plugins securely.
* **Advanced Security Center (Future):** Prepared layout card to show real-time security score assessments and local hardware-tamper audit logs.

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
| Diagnostic Status Badge | Success Accent Color | `bankyar.semantic.color.success.default` |
| Alert Warnings | Error Accent Color | `bankyar.semantic.color.error.default` |
| Settings List Icon | Icon Stroke Color | `bankyar.semantic.color.icon.default` |
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
