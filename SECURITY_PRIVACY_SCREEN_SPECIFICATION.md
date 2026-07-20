# BankYar Security & Privacy Center Screen Specification (v1.1.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.1.0
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

## 1. Complete Screen Layout & Spatial Architecture

The Security & Privacy Center represents the absolute apex of defensive UI architecture. Pinned in Zone A is the Top App Bar, giving immediate back navigation and scanning triggers. Zone B spans the dynamic scrollable content space, starting with the interactive Overall Security Score Card, passing through high-impact threat alerts, and leading into granular configuration categories. Zone C anchors the persistent, native-feeling system navigation.

### Horizontal and Vertical Grid Rythm
All layouts strictly adhere to the **8-unit grid system** mapping directly to standard spatial design tokens:
- **Screen Margin (RTL):** Padded with `bankyar.responsive.margin` on the right and left edges, scaling gracefully across viewports.
- **Vertical Spacing:** Section cards and groups are separated by `bankyar.space.lg` (twenty-four units). Items inside a card group use a tight `bankyar.space.md` (sixteen units) or `bankyar.space.xs` (four units) for metadata.
- **Horizontal Alignment:** Completely mirrored for right-to-left Persian. Leading items sit on the right, trailing controls/indicators sit on the left.

---

## 2. Section Hierarchy & Security Information Hierarchy

Information density on this screen is carefully managed to maximize readability, minimize security anxiety, and ensure instant accessibility:

```
[Level 1: Aggregated Security Posture] -> Overall Security Score Card (Instant assessment)
   |
[Level 2: Active Vulnerability Alerts] -> Threat Alerts Stack (High contrast, immediately actionable)
   |
[Level 3: Operational Quick Actions] -> Diagnostic scans and rapid backups
   |
[Level 4: Detailed Control Categories] -> Categorized settings with intuitive toggle switches:
          - Privacy Dashboard (داشبورد حریم خصوصی)
          - Authentication (احراز هویت و قفل)
          - Device Security (امنیت دستگاه)
          - Cryptography & Keys (رمزگذاری و کلیدها)
          - Permissions (وضعیت مجوزها)
   |
[Level 5: Destruction & Recovery Controls] -> High-contrast emergency zeroization zone
```

---

## 3. Component Placement & Interactive Flows

Below is the exhaustive, component-by-component specification for the Security & Privacy Center. In accordance with the enterprise specifications, every interactive control and status element is fully detailed across 18 unique visual and behavioral design properties.

### Reusable Interface Patterns Reference
To maintain absolute consistency, all 24 elements are structured around five primary Material Design 3 interactive patterns. Every single component mapped in the sections below explicitly specifies its override behavior across these properties.

---

### SECTION I: Security Overview Card & Status (کارت کلی وضعیت امنیت)

#### 1. Security Score (امتیاز امنیت)
* **Purpose:** Displays an aggregated, real-time security health score (0-100) of the device and application environment.
* **Business Value:** Provides an immediate, understandable security metric that boosts user trust and encourages proactive risk resolution.
* **Visual Priority:** Primary. The largest visual element on the screen, instantly catching the eye.
* **Placement:** Positioned in Region 1 of Zone B, aligned to the right side of the Security Score Card.
* **Spacing:** Inward padding matching `bankyar.space.lg` with a trailing gap of `bankyar.space.md` before the status sub-label.
* **Typography:** Bold monospaced numerals styled with `bankyar.typography.display.lg` (large headlines).
* **Icons:** None. Pure numeric text representing **"۸۵٪"** (85%).
* **Elevation:** Flat card container using fine outline strokes matching `bankyar.semantic.color.border.subtle`.
* **Interaction:** Tapping the score text opens a persistent modal bottom sheet breaking down the calculation categories.
* **Loading:** Shimmers using a soft horizontal gradient loop with duration token `bankyar.motion.duration.medium`.
* **Disabled:** Reduces overall card opacity to 38% under system lockout conditions.
* **Error:** When the score drops below 70, the text dynamically recolors to `bankyar.semantic.color.status.error` (Crimson).
* **Warning:** For scores between 70 and 89, uses `bankyar.semantic.color.status.warning` (Amber Gold).
* **Success:** For scores of 90+, uses `bankyar.semantic.color.status.success` (Emerald Green).
* **Accessibility:** Screen readers parse as a single semantic entity: "امتیاز امنیت شما هشتاد و پنج درصد است. سطح بهینه‌شده."
* **RTL Behaviour:** Numbers remain localized in Persian numeral characters and sit at the logical start (right) of the card container.
* **Animation:** On screen load, the score count scales and increments from zero to the target number using transition curve `bankyar.motion.curve.decelerate` with duration token `bankyar.motion.duration.long`.
* **Future Expansion:** Slot reserved to overlay external HSM verification indicators.

#### 2. Device Trust Status (وضعیت اعتماد دستگاه)
* **Purpose:** Communicates whether the underlying operating system environment is secure, unrooted, and verified.
* **Business Value:** Prevents application compromise on insecure devices and establishes trust in the host system's hardware sandbox.
* **Visual Priority:** Secondary. Aligned in the details column of the Score Card.
* **Placement:** Region 1, inside the left text stack of the Overall Security Score Card.
* **Spacing:** Separated vertically from the score by `bankyar.space.xs` (four units).
* **Typography:** Styled with `bankyar.typography.title.sm` (small title).
* **Icons:** A small protective shield outline icon `bankyar.icon.shield` next to the text.
* **Elevation:** None (flat inline badge).
* **Interaction:** Tapping this status text navigates to a detailed system diagnostic breakdown.
* **Loading:** Displays a localized text shimmer "در حال ارزیابی دستگاه...".
* **Disabled:** Text opacity drops to 38% if hardware attestation services are completely unavailable.
* **Error:** If the system is rooted or bootloader is unlocked: text turns Crimson (`bankyar.semantic.color.status.error`) with text **"دستگاه آسیب‌پذیر (ناامن)"**.
* **Warning:** Alarms if minor vulnerabilities like outdated OS security patches exist (Amber Gold).
* **Success:** Returns **"دستگاه ایمن و تایید شده"** in Emerald Green when attestation passes.
* **Accessibility:** Explicit semantic label: "وضعیت دستگاه: کاملاً ایمن و تایید شده توسط سیستم امنیتی هسته".
* **RTL Behaviour:** Text is right-aligned; the icon is positioned to the right of the label text.
* **Animation:** Fades in alongside the score card using a subtle vertical slide transition.
* **Future Expansion:** Ready for hardware-attestation APIs (Android Play Integrity or iOS DeviceCheck).

#### 3. Encryption Status (وضعیت رمزگذاری)
* **Purpose:** Visualizes whether the SQLCipher local database is active and encrypted.
* **Business Value:** Provides bulletproof reassurance that financial files cannot be read even if the raw storage is extracted.
* **Visual Priority:** Secondary.
* **Placement:** Below Device Trust Status inside the Score Card left stack.
* **Spacing:** Separated vertically by `bankyar.space.xs`.
* **Typography:** Styled with `bankyar.typography.label.md`.
* **Icons:** Keyhole padlock icon `bankyar.icon.lock`.
* **Elevation:** Flat inline placement.
* **Interaction:** Tapping opens an educational modal panel detailing SQLCipher AES-256 local protection.
* **Loading:** Lock icon rotates smoothly on its center axis while checking cryptographic volumes.
* **Disabled:** Lock icon turns grey and displays an unlocked state if encryption keys are cleared from RAM.
* **Error:** Shows an open padlock in Crimson with text **"عدم رمزگذاری پایگاه داده"** if storage is loaded in plaintext.
* **Warning:** None. Database encryption is binary (either 100% active or failed).
* **Success:** Displays a closed padlock in Emerald Green with text **"پایگاه داده رمزگذاری شده"**.
* **Accessibility:** Read by screen readers as: "وضعیت پایگاه داده: رمزگذاری کامل با الگوریتم اس‌کیو‌ال سایفر فعال است."
* **RTL Behaviour:** Icon displays on the right side of the Persian text label.
* **Animation:** Subtle scale-up animation of the padlock when verification completes.
* **Future Expansion:** Dynamic monitoring of real-time disk write encryption speeds.

#### 4. Database Encryption Details (جزئیات رمزگذاری پایگاه داده)
* **Purpose:** Displays technical metadata for advanced users regarding key size and algorithm.
* **Business Value:** Builds high-end professional credibility for enterprise financial audits.
* **Visual Priority:** Tertiary.
* **Placement:** Category list element within the "Local Encryption Layer" settings group.
* **Spacing:** Standard layout padding of `bankyar.space.md` around the row.
* **Typography:** Monospaced alphanumeric characters styled with `bankyar.typography.body.sm`.
* **Icons:** Cryptographic node icon `bankyar.icon.crypto`.
* **Elevation:** None. Flat row with a bottom divider line.
* **Interaction:** Read-only tile. Long press copies the diagnostic string to clipboard (masked).
* **Loading:** Replaced by a three-dot pulsing loading state.
* **Disabled:** Text colored neutral muted, indicating no active database session.
* **Error:** Replaced with **"خطا در تایید هویت دیسک"** in Crimson.
* **Warning:** None.
* **Success:** Renders text **"SQLCipher AES-256-CBC"** in primary theme colors.
* **Accessibility:** Descriptive label: "الگوریتم رمزگذاری فعال: اس‌کیوال‌سایفر ۲۵۶ بیت حالت سی‌بی‌سی".
* **RTL Behaviour:** Label text aligns right; the technical string "SQLCipher" remains left-to-right (LTR) and aligns left.
* **Animation:** Slides down from the main category header when expanded.
* **Future Expansion:** Toggle for migrating to newer SQLCipher cipher suites.

#### 5. Master Key Status (وضعیت کلید اصلی)
* **Purpose:** Confirms the health and storage vault of the cryptographic master key.
* **Business Value:** Guarantees that keys are bound to physical hardware chips rather than raw application preferences.
* **Visual Priority:** Secondary.
* **Placement:** Category list element under the local encryption settings group.
* **Spacing:** Inside vertical category container with standard spacing.
* **Typography:** Styled with `bankyar.typography.body.md`.
* **Icons:** Golden chip vault icon `bankyar.icon.keyhole.chip`.
* **Elevation:** Flat tile.
* **Interaction:** Tapping details how keys are protected using Android Keystore / iOS Keychain.
* **Loading:** Status text displays a spinning circular loader.
* **Disabled:** Mutes text when hardware keystore is unavailable (e.g., emulator).
* **Error:** Displays **"کلید در حافظه ناامن"** in Crimson if keys are forced to fallback software storage.
* **Warning:** Shows **"پشتیبانی نرم‌افزاری"** in Gold Amber if physical Keystore chip is bypassed.
* **Success:** Displays **"محافظت شده در سخت‌افزار (TEE/StrongBox)"** in Emerald Green.
* **Accessibility:** Semantic description: "وضعیت کلید اصلی: ذخیره‌شده و محافظت شده در تراشه سخت‌افزاری ایمن دستگاه".
* **RTL Behaviour:** Text right-aligned, status value left-aligned.
* **Animation:** Soft fade-in on screen load.
* **Future Expansion:** Integration with quantum-resistant key vault wrappers.

#### 6. Biometric Authentication (احراز هویت زیست‌سنجی)
* **Purpose:** Toggle switch to enable/disable rapid biometric login.
* **Business Value:** Merges top-tier security with instantaneous, frictionless convenience.
* **Visual Priority:** Primary.
* **Placement:** In the "Authentication" category, positioned as the top interactive item.
* **Spacing:** Touch target height expanded to `bankyar.space.xl` (forty-eight units) with outer margins.
* **Typography:** Styled with `bankyar.typography.title.md` with supporting body text in `bankyar.typography.body.sm`.
* **Icons:** Fingerprint scanner outline `bankyar.icon.fingerprint`.
* **Elevation:** Flat surface tile.
* **Interaction:** Tapping the row toggles the switch control, prompting the security authentication confirmation dialogs.
* **Loading:** Switch thumb is replaced by a micro circular loader.
* **Disabled:** Switch is locked to off if system biometrics are not enrolled or hardware is missing.
* **Error:** System error is indicated by a brief vibration and red pulse on the switch background.
* **Warning:** None.
* **Success:** Toggled to on with primary theme coloring when enabled.
* **Accessibility:** Read-aloud: "کلید دو حالته احراز هویت زیست‌سنجی. در حال حاضر فعال است. برای غیرفعال‌سازی دو بار ضربه بزنید."
* **RTL Behaviour:** Persian description on the right, toggle switch aligned to the left edge.
* **Animation:** The switch thumb glides horizontally with an elastic spring animation using standard curves.
* **Future Expansion:** Ready to adapt to upcoming 3D face scan and multi-modal biometrics.

#### 7. PIN Protection (محافظت با پین‌کد)
* **Purpose:** Displays the status of the local application PIN lock and provides a path to change it.
* **Business Value:** Acts as the primary cryptographic password fallback when biometrics fail or are disabled.
* **Visual Priority:** High.
* **Placement:** Below Biometric Authentication in the "Authentication" category.
* **Spacing:** Grid aligned. Vertically separated by `bankyar.space.md`.
* **Typography:** Title text in `bankyar.typography.title.md`, supporting text in `bankyar.typography.body.sm`.
* **Icons:** Padlock key shape `bankyar.icon.key`.
* **Elevation:** Flat tile.
* **Interaction:** Tapping the row navigates the user to the Change PIN flow.
* **Loading:** Read-only indicators pulse briefly during state validation.
* **Disabled:** Disabled only during temporary lockouts.
* **Error:** None.
* **Warning:** Displays a warning badge **"رمز ساده!"** if the chosen PIN is weak or sequential.
* **Success:** Displays a solid green checkmark next to **"فعال - پین‌کد قوی"**.
* **Accessibility:** Actionable tile read as: "تغییر رمز عبور ورود. پین‌کد فعلی فعال و قوی است. برای ویرایش رمز عبور ضربه بزنید."
* **RTL Behaviour:** Caret chevron pointing to the logical left (`bankyar.icon.chevron.left`) anchors the left-most edge.
* **Animation:** Custom horizontal transition when drilling into the change screen.
* **Future Expansion:** Option for variable-length PIN codes (up to twelve characters).

#### 8. Auto Lock Configuration (تنظیمات قفل خودکار)
* **Purpose:** Selects the idle duration before the application automatically locks down the database and requests re-authentication.
* **Business Value:** Erases memory caches and blocks physical shoulder surfing if the phone is left unattended.
* **Visual Priority:** Secondary.
* **Placement:** Third item under "Authentication" category.
* **Spacing:** Aligned on the layout grid.
* **Typography:** Title in `bankyar.typography.body.lg`, status value in `bankyar.typography.body.md` using warning coloring if "Never" is chosen.
* **Icons:** Alarm stopwatch `bankyar.icon.stopwatch`.
* **Elevation:** Flat container.
* **Interaction:** Tapping opens an option sheet containing time options (Immediately, after one minute, five minutes, or never).
* **Loading:** Disabled dropdown click during loading state.
* **Disabled:** Locked to "Immediately" if high-security corporate profile is enforced.
* **Error:** None.
* **Warning:** Displays a warning state if "Never" is selected, flashing the text in Amber Gold.
* **Success:** Selected timer displayed in primary theme color.
* **Accessibility:** Reads: "تنظیم قفل خودکار برنامه. در حال حاضر روی یک دقیقه تنظیم شده است. برای تغییر ضربe بزنید."
* **RTL Behaviour:** Selected value and drop chevron sit on the logical left (left), main text sits on the logical right (right).
* **Animation:** Option menu expands vertically using a clipping boundary transition.
* **Future Expansion:** Adaptive auto-lock based on ambient environment light and motion sensors.

#### 9. Failed Unlock Attempts (دفعات تلاش ناموفق برای ورود)
* **Purpose:** Displays the maximum allowed sequential failed unlock attempts before enforcing a secure cooldown lock.
* **Business Value:** Neutralizes robotic brute-force guessing attacks on physical devices.
* **Visual Priority:** Secondary.
* **Placement:** Bottom item in the "Authentication" category.
* **Spacing:** Vertical padding matching standard tiles.
* **Typography:** Title text in `bankyar.typography.body.lg`, sub-label in `bankyar.typography.body.sm`.
* **Icons:** Exclamation alert shield `bankyar.icon.alert.shield`.
* **Elevation:** Flat tile.
* **Interaction:** Tapping opens a selector sheet to set limit constraints (3, 5, or 10 attempts).
* **Loading:** Click state is temporarily blocked.
* **Disabled:** None.
* **Error:** Highlighting in Crimson if maximum failures have been exceeded, showing lockout duration.
* **Warning:** None.
* **Success:** Shows selected threshold (e.g., "۵ تلاش ناموفق").
* **Accessibility:** Semantic description: "تنظیم سقف تلاش‌های ناموفق. در حال حاضر روی پنج تلاش مجاز تنظیم شده است."
* **RTL Behaviour:** Perfectly aligned to RTL grid; dropdown indicators sit on the left.
* **Animation:** Transition menu opens smoothly.
* **Future Expansion:** Option to self-destruct database files on the fifteenth consecutive failure.

---

### SECTION II: Permission Overview (نمای کلی مجوزها)

#### 10. SMS Permission (مجوز پیامک)
* **Purpose:** Displays the current operating system status for SMS reading permission.
* **Business Value:** Essential for the Core value proposition of BankYar: parsing banking sms alerts automatically.
* **Visual Priority:** Critical. High visual weight.
* **Placement:** First control in the "Permission Overview" category.
* **Spacing:** Extended touch boundaries with standard spacing.
* **Typography:** Title in `bankyar.typography.title.md`, body in `bankyar.typography.body.sm`.
* **Icons:** Envelope incoming message icon `bankyar.icon.sms`.
* **Elevation:** Flat tile.
* **Interaction:** Tapping the row redirects the user to the native operating system settings app to grant or revoke permission.
* **Loading:** None.
* **Disabled:** Disabled if the hardware device does not support mobile cellular radios.
* **Error:** Displays **"دسترسی قطع شده است"** (Denied) in Gold Amber warning color, triggering an alert card.
* **Warning:** Same as error.
* **Success:** Displays a solid green badge **"مجوز صادر شده"** when SMS parsing is fully active.
* **Accessibility:** Screams warning if denied: "هشدار! مجوز پیامک قطع شده است. برای فعال‌سازی ضربه بزنید."
* **RTL Behaviour:** Persian labels align right; redirect arrow points to the left edge.
* **Animation:** Pulse animation when warning card is visible.
* **Future Expansion:** Ready for fine-grained sender blacklist filters.

#### 11. Notification Permission (مجوز اعلان‌ها)
* **Purpose:** Controls whether BankYar is authorized to post immediate background analysis alerts.
* **Business Value:** Keeps the user continuously informed of transaction parsing, maintaining confidence.
* **Visual Priority:** Secondary.
* **Placement:** Second item under "Permission Overview".
* **Spacing:** Aligned grid height.
* **Typography:** Standard title and subtitle scale.
* **Icons:** Notification bell `bankyar.icon.bell`.
* **Elevation:** Flat tile.
* **Interaction:** Toggling switch triggers native OS notification grant prompts.
* **Loading:** Switch locks while requesting permissions.
* **Disabled:** Locked to off if system-wide notifications are disabled.
* **Error:** Displays **"غیرفعال"** in muted tones.
* **Warning:** None.
* **Success:** Active state in primary colored switch.
* **Accessibility:** Reads: "مجوز اعلان‌های سیستمی. فعال است."
* **RTL Behaviour:** Toggle switch is aligned on the left edge.
* **Animation:** Smooth switch sliding.
* **Future Expansion:** Notification channel category selection.

#### 12. Battery Optimization Status (وضعیت بهینه‌سازی باتری)
* **Purpose:** Displays whether the operating system is aggressively restricting background execution.
* **Business Value:** Prevents Android's Doze mode from killing the background SMS monitoring service.
* **Visual Priority:** High (when optimization is active/restricted).
* **Placement:** Aligned in "Permission Overview" settings.
* **Spacing:** Grid aligned.
* **Typography:** Title in `bankyar.typography.body.lg`, status text in warning tones.
* **Icons:** Lightning bolt battery icon `bankyar.icon.battery.bolt`.
* **Elevation:** Flat tile.
* **Interaction:** Tapping opens native system prompt to exclude BankYar from background execution limits.
* **Loading:** Click locked during processing.
* **Disabled:** None.
* **Error:** None.
* **Warning:** Displays gold warning text **"بهینه‌سازی باتری فعال است (خطر قطع شدن تحلیل خودکار)"**.
* **Success:** Displays **"بدون محدودیت پس‌زمینه"** in Emerald Green.
* **Accessibility:** Standard screen reader alert: "هشدار: بهینه‌سازی باتری فعال است و ممکن است پردازش پیامک را با اختلال روبرو کند."
* **RTL Behaviour:** Persian text layout mirroring.
* **Animation:** Transitions smoothly when system state changes.
* **Future Expansion:** Automatically monitor battery level thresholds before pausing heavy data indexing.

#### 13. Secure Backup Status (وضعیت پشتیبان‌گیری امن)
* **Purpose:** Displays the date of the last local encrypted backup and verifies integrity.
* **Business Value:** Protects users against total financial history loss if their physical device is destroyed.
* **Visual Priority:** High.
* **Placement:** Bottom tile under "Permission Overview".
* **Spacing:** Inside categories container.
* **Typography:** Title in `bankyar.typography.body.lg`, supporting label in monospace text showing date.
* **Icons:** Cloud backup lock `bankyar.icon.backup.lock`.
* **Elevation:** Flat.
* **Interaction:** Tapping redirects instantly to the Backup & Restore center.
* **Loading:** Progress bar shimmers while validating backup files on disk.
* **Disabled:** Locked if backup feature is fully restricted.
* **Error:** None.
* **Warning:** If no backup exists or is older than thirty days: **"نیازمند پشتیبان‌گیری"** in warning gold.
* **Success:** Shows **"پشتیبان‌گیری منظم و ایمن"** in green with timestamp.
* **Accessibility:** Speaks: "آخرین پشتیبان‌گیری محلی: ده روز پیش انجام شده است. وضعیت ایمن است."
* **RTL Behaviour:** Text aligns right, caret redirect sits on the left.
* **Animation:** Micro scale-up when backup is initiated.
* **Future Expansion:** Decentralized, end-to-end encrypted local peer sharing.

#### 14. Last Security Check (آخرین بررسی امنیتی)
* **Purpose:** Read-only label showing the precise time of the last local hardware check.
* **Business Value:** Reassures users of continuous, active monitoring.
* **Visual Priority:** Tertiary.
* **Placement:** Bottom-right corner of the Overall Security Score Card.
* **Spacing:** Micro padding.
* **Typography:** Styled with `bankyar.typography.caption.xs` in monospace numerals.
* **Icons:** Checkmark circle `bankyar.icon.check.circle`.
* **Elevation:** None.
* **Interaction:** Non-interactive, updates dynamically after running scans.
* **Loading:** Changes to "درحال بررسی..." with a pulsing fade.
* **Disabled:** None.
* **Error:** Displays **"بررسی ناموفق"** if the system integrity scanner crashes.
* **Warning:** None.
* **Success:** Active timestamp **"۱۴۰۲/۱۰/۱۲ - ۱۲:۳۰"**.
* **Accessibility:** Reads: "زمان آخرین بررسی امنیتی موفق: دوازدهم دی ماه هزار و چهارصد و دو، ساعت دوازده و سی دقیقه."
* **RTL Behaviour:** Numbers align correctly to RTL text flow.
* **Animation:** Content fades in using short fade.
* **Future Expansion:** Connect to a background watchdog service.

#### 15. Recent Security Events (رویدادهای امنیتی اخیر)
* **Purpose:** Visual list showing recent security event logs (e.g., successful backup, PIN change).
* **Business Value:** Provides transparency and a clear audit trail for the user's activities.
* **Visual Priority:** Secondary.
* **Placement:** Bottom region of Section II.
* **Spacing:** Enclosed list group separated by dividers.
* **Typography:** Title in `bankyar.typography.title.sm`, event items in `bankyar.typography.body.sm`.
* **Icons:** Security timeline marker `bankyar.icon.timeline`.
* **Elevation:** Flat card container.
* **Interaction:** Tapping expands the event log, displaying full audit parameters.
* **Loading:** Shows list-skeletons.
* **Disabled:** Locked when secure profile prevents logs display.
* **Error:** None.
* **Warning:** Highlights abnormal access attempts in yellow gold.
* **Success:** All normal events show subtle neutral green icons.
* **Accessibility:** Full reading order of events from top to bottom.
* **RTL Behaviour:** Chronological text flows correctly from right to left.
* **Animation:** Expanding list uses standard slide and clip animations.
* **Future Expansion:** Secure exporting of log files in audit-ready formats.

---

### SECTION III: Privacy Overview (نمای کلی حریم خصوصی)

#### 16. Offline Mode Indicator (نشانگر حالت آفلاین)
* **Purpose:** Explains and proves to the user that BankYar has zero active network permissions.
* **Business Value:** The core foundation of trust: guarantees financial transactions never leave the local silicon chip.
* **Visual Priority:** Primary. Solid, high-contrast banner.
* **Placement:** Top of the "Privacy Overview" settings category.
* **Spacing:** Large interior padding `bankyar.space.lg` to match its visual importance.
* **Typography:** Bold headline title in `bankyar.typography.title.md` with body in `bankyar.typography.body.sm`.
* **Icons:** Wi-Fi off crossed-signal shield `bankyar.icon.offline.shield`.
* **Elevation:** Level 1 elevation token `bankyar.elevation.level1` with a fine emerald green border.
* **Interaction:** Non-interactive card, displays an educational sheet explaining "Privacy-by-Design Offline-first" on tap.
* **Loading:** Static. Never requires network load.
* **Disabled:** None.
* **Error:** None.
* **Warning:** None.
* **Success:** Solid green indicator light next to **"حالت صددرصد آفلاین فعال است"**.
* **Accessibility:** Screen readers emphasize: "محیط برنامه کاملاً ایزوله است. ارتباط با اینترنت وجود ندارد و تمام تحلیل‌ها در تراشه محلی شما انجام می‌شود."
* **RTL Behaviour:** Aligns right; offline green indicator light sits on the left edge.
* **Animation:** Gentle glow pulse of the green status light using decelerate curve.
* **Future Expansion:** Dynamic monitoring of active background network sockets.

#### 17. Collected Data Summary (خلاصه داده‌های جمع‌آوری شده)
* **Purpose:** Summarizes exactly what information is being parsed by the app (bank messages, cards, totals).
* **Business Value:** Full transparency eliminates user fear of background spying or hidden indexing.
* **Visual Priority:** Secondary.
* **Placement:** Second card in the "Privacy Overview" category.
* **Spacing:** Grid aligned.
* **Typography:** Styled with standard layout typography scales.
* **Icons:** Data storage folder `bankyar.icon.folder.data`.
* **Elevation:** Flat card.
* **Interaction:** Tapping details exactly what data is parsed, with educational highlights.
* **Loading:** Shows a rapid horizontal shimmer.
* **Disabled:** None.
* **Error:** None.
* **Warning:** None.
* **Success:** Aligned with green status checking.
* **Accessibility:** Provides clear auditory list of data parsed.
* **RTL Behaviour:** Reading layout is right-to-left.
* **Animation:** Expands horizontally using standard transition curves.
* **Future Expansion:** Interactive data tag management.

#### 18. Stored Data Summary (خلاصه داده‌های ذخیره‌شده)
* **Purpose:** Details how and where data is stored on-disk (SQLCipher encrypted cache).
* **Business Value:** Reinforces local data sovereignty principles.
* **Visual Priority:** Secondary.
* **Placement:** Below Collected Data Summary.
* **Spacing:** Regular margins.
* **Typography:** Title text in `bankyar.typography.body.lg`, metric sizes in monospace.
* **Icons:** Secured server database `bankyar.icon.db.lock`.
* **Elevation:** Flat.
* **Interaction:** Displays an inventory of tables and sizes on click.
* **Loading:** Pulsing circular progress.
* **Disabled:** None.
* **Error:** Displays high-risk error status if database path is accessible outside root directory.
* **Warning:** None.
* **Success:** Shows **"ذخیره‌سازی رمزنگاری شده ایمن"** in green.
* **Accessibility:** Unified metadata read-out.
* **RTL Behaviour:** Size metrics like "2.4 MB" remain left-to-right (LTR) and align left.
* **Animation:** Slide and fade.
* **Future Expansion:** Secure partition selection support.

#### 19. Sensitive Data Storage (ذخیره‌سازی داده‌های حساس)
* **Purpose:** Provides direct toggles to configure visibility and masking rules for sensitive elements.
* **Business Value:** Enables maximum on-screen privacy for public environments.
* **Visual Priority:** High.
* **Placement:** Mid-section of "Privacy Overview".
* **Spacing:** Touch target height matching forty-eight units standard.
* **Typography:** Primary titles.
* **Icons:** Eye crossed out icon `bankyar.icon.eye.slash`.
* **Elevation:** Flat tile.
* **Interaction:** Clicking navigates to detailed masking configuration options.
* **Loading:** Locked switch.
* **Disabled:** None.
* **Error:** None.
* **Warning:** Warning badge if data is fully unmasked in public.
* **Success:** Secure mask confirmation green check.
* **Accessibility:** Fully structured voice control identifiers.
* **RTL Behaviour:** Mirrored layout flow.
* **Animation:** Masking elements blur on and off with standard animations.
* **Future Expansion:** Proximity sensor-based automatic data masking.

#### 20. Export Privacy Report (خروجی گزارش حریم خصوصی)
* **Purpose:** Generates a plaintext offline report detailing exactly what data has been logged locally.
* **Business Value:** Empirical proof that data is localized, meeting strict enterprise audit expectations.
* **Visual Priority:** Secondary.
* **Placement:** Bottom control category under Privacy section.
* **Spacing:** Extended margins.
* **Typography:** Styled with `bankyar.typography.label.lg` on a secondary outlined button style.
* **Icons:** Outgoing report sheet `bankyar.icon.report.export`.
* **Elevation:** Flat outlined style.
* **Interaction:** Tapping prompts the native file saver sheet to export the report.
* **Loading:** Disables interactions and animates a linear progress track.
* **Disabled:** Disabled if storage write permission is revoked.
* **Error:** Triggers a notification banner with an error message on failure.
* **Warning:** None.
* **Success:** Shows a success snackbar "گزارش با موفقیت در پوشه دانلودها ذخیره شد."
* **Accessibility:** Action label: "صادرات گزارش حریم خصوصی. برای دانلود گزارش متنی تاییدیه آفلاین ضربه بزنید."
* **RTL Behaviour:** Icon displays on the right side of the button text.
* **Animation:** Linear indicator fill matches curve.
* **Future Expansion:** PDF format signing support.

#### 21. Delete All Data (حذف کامل تمامی اطلاعات)
* **Purpose:** Instantly purges the database, zeroizes Keystore keys, and resets application preferences.
* **Business Value:** Emergency defensive switch that protects users from physical forensic discovery under high-risk environments.
* **Visual Priority:** Critical. High contrast.
* **Placement:** Pinned at the very bottom of Zone B, under Emergency Actions.
* **Spacing:** Large spatial margins surrounding the destructive card area to avoid accidental interaction.
* **Typography:** Aligned bold text in `bankyar.typography.title.md` colored with Crimson error theme.
* **Icons:** Warning trash can `bankyar.icon.trash.critical`.
* **Elevation:** Low-contrast flat card with thick Crimson borders.
* **Interaction:** Triggers the multi-step confirmation dialog which requires a three-second continuous hold.
* **Loading:** Animates a circular loading track during secure overwrite.
* **Disabled:** Locked during background data processing.
* **Error:** Triggers local encryption error dialog on write lock failures.
* **Warning:** Highlighted with bright warning background elements.
* **Success:** Securely closes application and restarts in clean setup mode.
* **Accessibility:** Screams warning: "اقدام خطرناک! دکمه حذف کامل اطلاعات دستگاه. با تایید این دکمه، تمام تراکنش‌های مالی به طور دائمی پاک خواهند شد."
* **RTL Behaviour:** Persian text layout mirroring. Caret indicators align left.
* **Animation:** Shakes on horizontal axis on launch to indicate critical danger.
* **Future Expansion:** Multi-drive raw block zeroization.

---

## SECTION IV: Security Features (Visual Representation)

The application utilizes high-fidelity visual metaphors to translate abstract security states into high-trust visual layers:

* **Database Encryption (رمزنگاری پایگاه داده):** Visualized as a solid, glowing vault padlock icon `bankyar.icon.vault.shield`. When active, it displays a steady emerald green aura, emphasizing absolute lock-down state.
* **Keystore Protection (محافظت کلیدها):** Rendered as a microchip integrated directly into a secure padlock vault, visually communicating hardware-enforced protection.
* **Master Key Health (سلامت کلید اصلی):** A circular progress gauge showing key derivation security strength, utilizing smooth color gradients mapping to token levels.
* **Biometric Availability (احراز هویت زیست‌سنجی):** Visualized as a fingerprint target ring with circular scanning loops indicating physical device availability.
* **PIN Strength (قدرت پین‌کد):** A segmented visual indicator block (similar to password bars) that maps strength using three-tiered semantic colors.
* **Security Recommendations (توصیه‌های امنیتی):** Carousel cards utilizing friendly sky-blue icons with subtle text blocks offering smart diagnostic solutions.
* **Risk Warnings (هشدارهای امنیتی):** Highlighted alerts featuring octagonal hazard borders and dynamic exclamation icons.
* **Permission Health (مجوزها):** Circle nodes showing granted states using green checkmarks and denied states using yellow alert markers.
* **Backup Encryption (رمزنگاری فایل پشتیبان):** An outgoing document wrapping into a padlock icon, demonstrating end-to-end local data security.

---

## SECTION V: Privacy Features (Educational Explanations)

This center serves as an educational advocate, clearly explaining our core privacy guidelines to non-technical users in plain Persian:

* **Offline-first Policy (سیاست اولویت آفلاین):** Explained with micro-illustrations showing data flows remaining entirely local to the user's phone, with a clear text: "اطلاعات مالی شما هرگز از گوشی شما خارج نمی‌شود."
* **No Internet Access (عدم دسترسی به اینترنت):** Prominently displays the lack of standard Internet permission in the app manifest: "برنامه هیچ دسترسی به شبکه اینترنت ندارد."
* **Local Storage Only (ذخیره‌سازی صرفاً محلی):** Highlights that all databases reside in secure, isolated app directories.
* **No Analytics (بدون ابزارهای تحلیل رفتار):** Explains that no trackers (e.g., Firebase, Amplitude) are compiled into the application bundle.
* **No Cloud Processing (بدون پردازش ابری):** Assures that parsing and text recognition are executed strictly on the local CPU cores.
* **No Third-party Tracking (بدون ردیاب‌های جانبی):** Explains our zero-sharing policy with financial third parties or marketing platforms.

---

## SECTION VI: Quick Actions (اقدامات امنیتی سریع)

Positioned below the Score Card, this region provides rapid shortcuts to essential functions:

* **Enable Biometrics (فعال‌سازی اثر انگشت/چهره):** Starts the system biometric configuration overlay directly.
* **Change PIN (تغییر پین‌کد):** Navigates instantly to the six-digit PIN customization screen.
* **Run Security Audit (اسکن امنیتی):** Triggers an immediate local diagnostic scan of file integrity, background mode, and permissions.
* **Export Security Report (خروجی متنی امنیت):** Exports detailed offline audit records to an encrypted text file.
* **Review Permissions (بررسی مجوزها):** Opens the local permission summary directly.
* **Backup Now (پشتیبان‌گیری فوری):** Creates an AES-GCM encrypted database export to local storage.
* **Delete Sensitive Data (حذف فایل‌های حساس):** Instantly purges cached clipboard contents, temporary file logs, and search histories.

---

## 4. Dialog Specifications

Dialogs represent critical modal checkpoints. All dialog structures adhere to Material Design 3 guidelines: rounded corners matching `bankyar.radius.lg`, background fills matching `bankyar.semantic.color.surface.default`, and persistent accessibility backdrops.

```
+-----------------------------------------------------------+
| [!] Security Alert: Critical Confirmation                 |
|                                                           |
| "آیا از حذف کامل اطلاعات اطمینان دارید؟ این عمل غیرقابل   |
| بازگشت است و دیتابیس با بازنویسی صفر تخریب می‌شود."      |
|                                                           |
| +-------------------------------------------------------+ |
| |       [ HOLD FOR 3 SEC TO DELETE (۳ ثانیه نگه دارید) ]| |
| +-------------------------------------------------------+ |
|                 [ انصراف (Cancel) ]                       |
+-----------------------------------------------------------+
```

---

### 1. Enable Biometrics Dialog
* **Purpose:** Requests secure confirmation to bind biometrics to the Keystore database key wrapper.
* **RTL Layout:**
  * **Header:** Icon `bankyar.icon.fingerprint` positioned on the right of the title **"فعال‌سازی زیست‌سنجی"**.
  * **Content:** Subtext: "برای ورود آسان و امن با اثر انگشت یا چهره، دکمه تایید را فشار داده و انگشت خود را روی حسگر قرار دهید."
  * **Actions:**
    * **Primary (Logical End / Left):** "تایید و اسکن" in primary active colors.
    * **Secondary (Logical Start / Right):** "انصراف" in muted neutral text colors.
* **State Behavior:**
  * Displays system-native biometric prompt on top of the dialog.
  * Transitions to "Success State" with a green checkmark once confirmed.

---

### 2. Disable Biometrics Dialog
* **Purpose:** Warns the user of decreased convenience before revoking biometric keys.
* **RTL Layout:**
  * **Header:** Title **"غیرفعال‌سازی زیست‌سنجی"** with warning shield icon.
  * **Content:** Subtext: "پس از غیرفعال‌سازی، ورود به برنامه صرفاً با پین‌کد ورود امکان‌پذیر خواهد بود. آیا مایل به ادامه هستید؟"
  * **Actions:**
    * **Primary (Logical End / Left):** "بله، غیرفعال شود" in Crimson error colors.
    * **Secondary (Logical Start / Right):** "انصراف" in primary active color.

---

### 3. Change PIN Dialog
* **Purpose:** Multi-step interface to update the application's access lock passcode.
* **RTL Layout:**
  * **Header:** Icon `bankyar.icon.key` next to **"تغییر پین‌کد ورود"**.
  * **Content:** Displays a secure, masked input field.
    * Step 1: "رمز عبور فعلی خود را وارد کنید"
    * Step 2: "رمز عبور جدید ۶ رقمی را وارد کنید"
    * Step 3: "تکرار رمز عبور جدید جهت تایید"
  * **Validation State:** Real-time feedback if keys match or are sequential.
  * **Actions:** "ذخیره پین‌کد جدید" is disabled until validation passes.

---

### 4. Delete All Data Dialog
* **Purpose:** Absolute defensive confirmation screen protecting against accidental data wiping.
* **RTL Layout:**
  * **Header:** Octagonal alert icon `bankyar.icon.alert.critical` in error Crimson next to **"توجه: حذف و انهدام کامل داده‌ها"**.
  * **Content:** Red warning subtext: "این اقدام تمام پایگاه داده محلی شما را به طور برگشت‌ناپذیر با الگوریتم بازنویسی صفر پاک می‌کند. لطفاً کلمه 'حذف' را تایپ کرده و دکمه را سه ثانیه نگه دارید."
  * **Verification Controls:**
    * Persian text entry field expecting input: **"حذف"**.
    * High-contrast Crimson hold-to-confirm button wrapper.
  * **Interactive Rule:** The user must type the text, then hold down the confirm button for three seconds. A circular progress loader fills during the hold.

---

### 5. Reset Security Dialog
* **Purpose:** Resets security levels, auto-lock timeouts, and permission toggles to factory defaults.
* **RTL Layout:**
  * **Header:** Title **"بازنشانی تنظیمات امنیتی"** with a resetting gear icon.
  * **Content:** Subtext: "تمام پارامترهای امنیتی مانند مدت زمان قفل خودکار و تنظیمات اعلان به حالت کارخانه برمی‌گردند. آیا اطمینان دارید؟"
  * **Actions:**
    * **Primary (Logical End / Left):** "تایید بازنشانی" in warning gold.
    * **Secondary (Logical Start / Right):** "لغو" in primary active color.

---

### 6. Permission Required Dialog
* **Purpose:** Explains why SMS or battery optimization permission is critical.
* **RTL Layout:**
  * **Header:** Title **"نیاز به مجوز دسترسی"** with info icon.
  * **Content:** "برنامه برای تحلیل خودکار تراکنش‌ها نیاز به دسترسی پیامک دارد. بدون این مجوز، شما باید تراکنش‌ها را به صورت دستی وارد کنید."
  * **Actions:**
    * **Primary (Logical End / Left):** "انتقال به تنظیمات سیستم" in primary active.
    * **Secondary (Logical Start / Right):** "متوجه شدم" in muted neutral.

---

### 7. Encryption Error Dialog
* **Purpose:** Handles critical hardware-backed Keystore or cryptographic engine crashes.
* **RTL Layout:**
  * **Header:** Warning triangle icon in Crimson next to **"خطای بارگذاری رمزگذاری پایگاه داده"**.
  * **Content:** Subtext: "کلیدهای امنیتی سخت‌افزار با دیتابیس فعلی همخوانی ندارند. این ممکن است به دلیل تعویض رام سیستم‌عامل باشد. برای بازسازی، باید دیتابیس قدیمی را پاک کرده یا کلید بازیابی خود را وارد کنید."
  * **Actions:**
    * **Primary (Logical End / Left):** "وارد کردن کلید بازیابی ۱۲ کلمه‌ای".
    * **Secondary (Logical Start / Right):** "پاک‌سازی و راه‌اندازی مجدد" in Crimson.

---

## 5. UI Layout States (Empty, Loading, Error, Warning, Success)

Consistent layout state transformations reduce cognitive load and prevent user interface panic:

### Empty State (نمای خالی)
* **Visuals:** Displayed inside the Recent Security Events list if no events are recorded.
* **Components:** A flat, clean shield icon styled with soft grey outline tokens next to the text "هیچ رویداد امنیتی اخیر ثبت نشده است. سیستم شما در وضعیت پایدار قرار دارد."
* **Action Button:** Outlined button "اسکن دستی سلامت دستگاه".

### Loading State (نمای در حال بارگذاری)
* **Visuals:** Triggered during security diagnostic scans or report generations.
* **Components:** Score card and list rows display a smooth, linear shimmering transition from right to left (RTL). Toggle switches are temporarily locked to prevent double taps.

### Error State (نمای خطا)
* **Visuals:** Occurs if a local backup fails or critical permissions are permanently blocked.
* **Components:** High-contrast Crimson outlines around the affected component card. An inline error text appears below the title, with a retry button `bankyar.icon.retry`.

### Warning State (نمای هشدار)
* **Visuals:** Triggered if a sequential simple PIN is configured or background battery optimizations are restricted.
* **Components:** Highlighted warning alert cards rendered in warning Gold Amber with high-contrast alert text.

### Success State (نمای موفقیت)
* **Visuals:** Shows when a PIN is updated, backup is completed, or biometrics are enabled.
* **Components:** Transient checkmark icons and progress bars flashing in success Emerald Green.

---

## 6. Accessibility & RTL Review (WCAG 2.2 AA Compliance)

BankYar is designed from the ground up to support users with diverse abilities:

* **RTL Reading Order:** The screen's layout, chevrons, swipe actions, and switch sliders follow the Persian natural reading flow from right to left.
* **Dual-Encoding Status Indicators:** Colors are never used as the sole conveyor of information. All secure/warning/error states are accompanied by distinct iconography (e.g., green shield for "ایمن", red hazard octagons for "خطا").
* **Screen Reader Labels:** Form fields, buttons, and settings tiles expose descriptive accessibility announcements that describe both the component's state and its primary click actions.
* **High Contrast Ratios:** Text color combinations maintain a contrast ratio of at least 4.5:1 against the background under both light and dark system themes.
* **Touch Target Envelopes:** All interactive buttons, toggle switches, and list rows maintain a minimum height and click width of `bankyar.space.xl` (forty-eight units) to accommodate users with motor control impairments.

---

## 7. Security UX Checklist

- [ ] **Data Obfuscation Enforced:** Ensure background blurred states are active, blocking UI screenshots and task-switcher previews.
- [ ] **No Raw Text Logs:** Confirm security events or diagnostics logs never output raw financial totals or personal identifiers.
- [ ] **Safe Destructive Flows:** Verify that raw database wiping actions require typing a confirmation keyword followed by a three-second continuous hold.
- [ ] **Dynamic Score Mapping:** Validate that the overall security score and text indicators adapt color schemes instantly based on risk levels.

---

## 8. Privacy UX Checklist

- [ ] **Zero Internet Footprint:** Verify the application manifest restricts network communications completely, proving offline isolation.
- [ ] **Clear Tracking Disclosure:** Explicitly declare our lack of background behavioral analytics or third-party tracking.
- [ ] **Local Storage Clarity:** Communicate where and how the user's data is secured in local SQLCipher files.
- [ ] **Transparent Privacy Reports:** Guarantee users can easily export and read plaintext summaries of all stored transactions.

---

## 9. UI Validation Checklist

- [ ] **100% Design Token Compliance:** Verify that all layout spacings, padding margins, corner radii, and elevations map directly to active design tokens. No hardcoded styles.
- [ ] **RTL-First Symmetry:** Ensure lists, status badges, and back navigation chevrons mirror naturally in right-to-left layout trees.
- [ ] **No Forbidden Terminology:** Check that absolutely no framework-specific classes or design layout declarations or physical spacing units exist in the document.
- [ ] **Flexible Font Scalability:** Ensure all list tiles, dialogs, and alert cards wrap text and adapt heights gracefully under 200% system font scaling without overlapping.

---
**End of Specification Document**
