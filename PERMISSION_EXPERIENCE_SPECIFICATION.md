# BankYar Permission Experience Specification

## Enterprise-Grade Permission Experience & Journey System Specification

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 2.0.0
**Authors:** Principal UX Designer, Android Permission Experience Specialist, Material Design 3 Expert, Flutter UI Architect, Privacy-by-Design Consultant, Enterprise FinTech Product Designer
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Permission Experience is the foundational pillar of user trust, safety, and operational reliability. Operating as an offline-first, secure financial manager with zero network permissions, the application relies entirely on sensitive system-level permissions to capture and process transaction data. This specification defines the complete permission journey, state machine, settings dashboard, dialog systems, and architectural recovery flows.

Built strictly for native **Persian (RTL)** layouts and optimized according to **Material Design 3 (MD3)**, this system guarantees that users are never surprised by a system permission prompt. Every request is preceded by context-rich, high-trust pre-education, reducing cognitive friction and maximizing permission acceptance rates without coercive patterns.

---

## Deliverable 1: Complete Permission Journey

The journey from initial launch to a fully operational system is designed as a trust-building funnel. No system permission is requested without preceding pre-education.

```
[Welcome / Splash]
       │
       ▼ (Privacy Commitment Accept)
[Feature & Architecture Explanation]
       │
       ▼ (Transition to Core Setup)
[SMS Pre-Education Screen]
       │
       ▼ (User taps "Grant Access")
[System SMS Dialog] ──► (Denied) ──► [SMS Denied Recovery Screen]
       │                                     │
       ▼ (Granted)                           ▼ (User retries / accepts fallback)
[Notification Pre-Education]                [Manual Setup Fallback]
       │                                     │
       ▼ (User taps "Enable Alerts")         │
[System Notification Dialog] ──► (Denied) ───┼─► (Continue with degraded alerts)
       │                                     │
       ▼ (Granted / Skipped)                 │
[Battery Optimization Exclusion Prep]        │
       │                                     │
       ▼ (User requests exclusion)           │
[System Battery Optimization Dialog]         │
       │                                     │
       ▼ (Completed / Skipped)               │
[Security Overview & PIN Setup] ◄────────────┘
       │
       ▼ (PIN Verified)
[Biometric Authentication Setup]
       │
       ▼ (Configured / Skipped)
[Storage Access (Backup) Education]
       │
       ▼ (User requests backup storage)
[System Storage Dialog] ──► (Denied / Skipped) ──► (Local internal sandboxed backup only)
       │
       ▼ (Granted)
[Onboarding Completion & Ledger Ready]
```

---

## Deliverable 2: Screen Hierarchy

The visual and navigational structure of the permission experience ensures clear separation between educational screens, standard dialog overlays, and settings dashboards.

```
Root App Lifecycle
├── Onboarding Flow (Screen Sequence)
│   ├── Welcome & Privacy Commitment Screen
│   ├── Feature & Data Sovereignty Explanation Screen
│   ├── SMS Permission Pre-Education Screen
│   │   └── System SMS Dialog Overlay
│   ├── Notification Permission Pre-Education Screen
│   │   └── System Notification Dialog Overlay
│   ├── Battery Optimization Exclusion Screen
│   │   └── System Battery Dialog Overlay
│   ├── Storage Access (Backup) Education Screen
│   │   └── System Storage Dialog Overlay
│   └── Biometric Authentication Setup Screen
│       └── System Biometric Enrollment Prompt
└── Main Application Dashboard
    └── Settings Section
        └── Permission Status Dashboard Screen
            ├── Permission Help & Documentation Screen
            ├── Advanced Permission Settings Screen
            │   ├── Future Notification Listener Activation Screen
            │   └── Future Accessibility Permission Activation Screen
            └── Dialog Overlay System
                ├── Permission Required Dialog
                ├── Permission Denied Dialog
                ├── Permission Permanently Denied Dialog
                ├── Go to Settings Dialog
                ├── Permission Granted Dialog
                └── Unsupported Device Dialog
```

---

## Deliverable 3: Permission Decision Tree

This programmatic decision matrix dictates screen transitions, state updates, and degraded functionality fallbacks depending on user choices:

```
                  [Start Permission Journey]
                             │
                             ▼
                [SMS Pre-Education Screen]
                             │
                             ▼
                    {User Action: CTA?}
                     /             \
            (Grant Access)       (Skip / Manual Fallback)
                 /                     \
                ▼                       ▼
      [System SMS Dialog]        [Manual Ledger Fallback Setup]
         /            \                     │
    (Granted)      (Denied)                 │
       /                \                   │
      ▼                  ▼                  ▼
[Update State]    {System Prompt Count?} ───┼─► [Go to PIN Setup]
[State: Granted]     /             \        │
      │         (First Denied)   (Permanently)
      ▼              /               \      │
[Go to Notification]▼                 ▼     │
             [SMS Denied Screen]  [SMS Perm. Denied Screen]
             [CTA: Retry]         [CTA: Open Android Settings]
```

* **Transition Rule 1 (SMS Granted):** Move directly to Notification Pre-Education. SMS State transitions from `Never Requested` to `Granted`.
* **Transition Rule 2 (SMS Denied - First Time):** Redirect to SMS Denied Recovery Screen. User can retry, triggering the second OS prompt, or choose the manual ledger fallback.
* **Transition Rule 3 (SMS Denied - Permanently):** Display SMS Permanently Denied Dialog with an outbound trigger to open Android Settings. SMS State transitions to `Permanently Denied`.
* **Transition Rule 4 (Notification Denied):** Notification State transitions to `Denied`. Post a persistent in-app info banner inside the main dashboard; proceed gracefully to Battery Optimization.

---

## Deliverable 4: Screen Layouts

Every screen in the permission journey conforms to the Material Design 3 specifications and uses a standard three-zone structural system.

### Screen A1: SMS Permission Pre-Education Screen (صفحه پیش‌آموزش دسترسی پیامک)
* **Purpose:** Educate users on the necessity of SMS access and prepare them for the native operating system prompt.
* **Business Goal:** Maximize SMS permission acceptance rates, which are critical for automatic transaction capture.
* **Visual Priority:** A high-contrast central illustration showing an incoming bank SMS transforming into an encrypted database record.
* **Layout:** Zone A houses the segmented progress indicator; Zone B contains the educational copy and illustrations; Zone C anchors the action buttons and the "100% Offline" safety badge.
* **Spacing:** Margins use `bankyar.responsive.margin`; element gaps use `bankyar.space.lg`.
* **Typography:** Title styled with `bankyar.semantic.typography.heading.lg`; body copy uses `bankyar.semantic.typography.body.md`.
* **Illustrations:** Grayscale vector diagram showing SMS text extraction inside a vault boundary.
* **Icons:** Incoming envelope symbol `bankyar.icon.sms` next to title text.
* **CTA Buttons:** Solid primary button "صدور مجوز دسترسی" (Grant Access Permission).
* **Secondary Actions:** Text button "پیکربندی دستی (بدون پیامک)" (Configure Manually).
* **Loading:** Static layout.
* **Accessibility:** Screen readers announce: "صفحه پیش‌آموزش مجوز پیامک. بانک‌یار برای ثبت خودکار هزینه‌ها نیاز به خواندن پیامک‌های بانکی دارد. اطلاعات شما روی گوشی حفظ می‌شود."
* **RTL Behaviour:** Mirroring active; bullet alignments positioned on the right logical edge; chevrons point left.
* **Animation:** Fade-in transition using curve `bankyar.motion.curve.standard` and duration `bankyar.motion.duration.medium`.

### Screen A2: Notification Permission Pre-Education Screen (صفحه پیش‌آموزش دسترسی اعلان)
* **Purpose:** Explain the benefits of push alerts for instant transaction updates and database locks.
* **Business Goal:** Build communication channels with the user, lowering churn rates.
* **Visual Priority:** A mock Material Design 3 notification card appearing in the center of the screen workspace.
* **Layout:** Centered single-column template. Mock notification card sits in Zone B.
* **Spacing:** Inward card padding matches `bankyar.space.md`; vertical rhythm uses `bankyar.space.lg`.
* **Typography:** Sub-labels styled with `bankyar.semantic.typography.label.sm`.
* **Illustrations:** Flat phone lock screen interface with a highlighted alert banner.
* **Icons:** Notification bell with small badge `bankyar.icon.bell.active`.
* **CTA Buttons:** Solid primary action "فعال‌سازی اعلان‌ها" (Enable Notifications).
* **Secondary Actions:** Outlined button "بعداً یادآوری کن" (Remind Me Later).
* **Loading:** None.
* **Accessibility:** Spoken text: "صفحه پیش‌آموزش اعلان‌ها. فعال‌سازی این مجوز به شما امکان می‌دهد بلافاصله پس از خرید، فاکتور ثبت شده را مشاهده کنید."
* **RTL Behaviour:** Symmetrical card; alert text flows from right to left; app icon positioned logical-start (right).
* **Animation:** Slide-down entry of the mock notification card mimicking a real system notification arrival.

### Screen A3: Battery Optimization Exclusion Screen (صفحه غیرفعال‌سازی بهینه‌سازی باتری)
* **Purpose:** Educate users on why background execution is blocked by the OS and guide them to exclude BankYar.
* **Business Goal:** Ensure background SMS parsing runs reliably without being terminated by system memory managers.
* **Visual Priority:** An instructional diagram depicting continuous background flow versus an interrupted flow.
* **Layout:** Two split informational blocks in Zone B. Zone C holds the primary action button.
* **Spacing:** Element intervals use `bankyar.space.md`.
* **Typography:** Step-by-step numbers styled with `bankyar.semantic.typography.heading.sm`.
* **Illustrations:** Grayscale battery symbol with a continuous charging loop.
* **Icons:** Lightning bolt within a shield `bankyar.icon.battery.secure`.
* **CTA Buttons:** Solid button "فعال‌سازی بدون محدودیت" (Enable Without Restrictions).
* **Secondary Actions:** Text button "بعداً انجام می‌دهم" (I'll Do This Later).
* **Loading:** Static.
* **Accessibility:** Read-aloud: "آموزش حذف محدودیت باتری. برای تضمین تحلیل پس‌زمینه پیامک‌ها بدون تاخیر، این گزینه را فعال کنید."
* **RTL Behaviour:** List steps proceed from right to left, top to bottom.
* **Animation:** Smooth fade-in of instruction cards.

### Screen A4: Storage Access (Backup) Education Screen (صفحه دسترسی فضای ذخیره‌سازی برای پشتیبان)
* **Purpose:** Explain why external storage access is needed to export secure local backup files.
* **Business Goal:** Provide data portability and disaster recovery options.
* **Visual Priority:** Diagram illustrating database files moving safely to a designated local folder.
* **Layout:** Standard vertical layout stack.
* **Spacing:** Boundary margins scale via `bankyar.responsive.margin`.
* **Typography:** Title styled with `bankyar.semantic.typography.heading.md`.
* **Illustrations:** Standard folder icon wrapped in a protective ring.
* **Icons:** Secure storage folder symbol `bankyar.icon.folder.backup`.
* **CTA Buttons:** Solid button "تایید دسترسی ذخیره‌سازی" (Confirm Storage Access).
* **Secondary Actions:** Outlined button "ذخیره‌سازی صرفاً در حافظه داخلی برنامه" (Internal Sandbox Storage Only).
* **Loading:** None.
* **Accessibility:** Structured text describes: "فضای ذخیره‌سازی خارجی برای انتقال فایل رمزنگاری شده پشتیبان به کارت حافظه شما استفاده می‌شود."
* **RTL Behaviour:** Mirroring matches standard rules; text block aligns right.
* **Animation:** None.

---

## Deliverable 5: CTA Specifications

Every Call-to-Action (CTA) button in the permission flow is explicitly designed to meet high-trust interactive standards. No physical units or absolute styles are used.

```
+-----------------------------------------------------------+
| [Primary Action CTA Button Pattern]                       |
|                                                           |
| Container Fill: bankyar.semantic.color.interactive.default |
| Label Color: bankyar.semantic.color.text.inverse          |
| Height: bankyar.space.xl (48-unit target)                 |
| Radius: bankyar.radius.medium                             |
| Text: Bold, Arabic/Persian Glyphs Centered                |
+-----------------------------------------------------------+
```

### 1. SMS Grant CTA Button
* **Visual Style:** High-contrast solid primary container using `bankyar.semantic.color.interactive.default`.
* **Label Text:** "صدور مجوز دسترسی به پیامک" (Grant SMS Access Permission).
* **Text Style:** `bankyar.semantic.typography.button.md` in bold.
* **Touch Target:** Expanded touch envelope of `bankyar.space.xl` (forty-eight units) to ensure comfortable activation.
* **Interactive States:**
  * `pressed`: Scale compression factor of 0.95 applied with curve `bankyar.motion.curve.fast`.
  * `disabled`: Opacity drops to 38%; touch listeners deactivated.

### 2. Manual Fallback CTA Button
* **Visual Style:** Flat text button with low visual weight.
* **Label Text:** "ادامه به صورت دستی" (Continue Manually).
* **Text Style:** `bankyar.semantic.typography.button.md` in regular weight.
* **Touch Target:** Standard forty-eight unit touch boundary.
* **Interactive States:**
  * `pressed`: Background highlights with transparent hover color token.

### 3. Open System Settings CTA Button
* **Visual Style:** Outlined high-contrast button.
* **Label Text:** "ورود به تنظیمات اندروید" (Open Android Settings).
* **Text Style:** `bankyar.semantic.typography.button.md` in bold.
* **Touch Target:** Vertical scale matching standard buttons.
* **Interactive States:**
  * `pressed`: Fills with active primary accent color.

---

## Deliverable 6: Recovery Flows

When a user denies a critical permission, the application must never lock up or show an error screen. Graceful degradation pathways are activated instantly.

### Recovery Flow R1: SMS Denied (First Time)
1. **Trigger:** User taps "Deny" on the native Android system SMS permission dialog.
2. **Transition:** Redirect user instantly to the SMS Denied Recovery Screen.
3. **UI Adaptation:** Present a friendly, non-technical explanation: "بدون دسترسی پیامک، تحلیل خودکار متوقف می‌شود. اما شما همچنان می‌توانید از بانک‌یار به عنوان یک دفترچه ثبت هزینه سنتی استفاده کنید."
4. **Primary Recovery Action:** "تلاش مجدد و صدور دسترسی" (Retry and Grant Access), which triggers the system permission dialog once more.
5. **Secondary Recovery Action:** "ورود به بخش ثبت دستی" (Enter Manual Ledger Mode), which bypasses SMS reading and moves directly to manual PIN setup.

### Recovery Flow R2: SMS Permanently Denied
1. **Trigger:** User denies SMS permission for the second time, selecting "Don't ask again" in the system dialog.
2. **Transition:** Display the "Go to Settings" Dialog overlay.
3. **Primary Recovery Action:** "انتقال به تنظیمات سیستم" (Open System Settings). Tapping this fires an explicit system intent to launch the device's native app settings page for BankYar.
4. **Secondary Recovery Action:** "ادامه با محدودیت ثبت دستی" (Continue with Manual Limits), enabling the manual offline ledger.

### Recovery Flow R3: Notification Revoked in Main Dashboard
1. **Trigger:** User revokes Notification permissions from system settings while the app is running in the background.
2. **Transition:** Detection on app resume.
3. **UI Adaptation:** Insert a dismissible, low-contrast warning banner at the top of the ledger dashboard: "اعلان‌های تحلیل تراکنش‌ها غیرفعال است. جهت دریافت سریع فاکتور خرید، اعلان را فعال کنید."
4. **Primary Recovery Action:** "فعال‌سازی سریع" (Quick Activation), launching the system settings app overlay.

---

## Deliverable 7: Accessibility Review

To ensure BankYar remains fully inclusive, the entire permission journey complies with the WCAG 2.2 AA accessibility guidelines:

* **Dual-Encoding Status Verification:** Success and error states are communicated using multiple visual cues (e.g., text, labels, and icons) rather than color alone. A green checkmark always accompanies success text, and a warning triangle accompanies errors.
* **Touch Target Minimums:** All interactive elements, including pre-education buttons and toggle switches, maintain a minimum height and width of `bankyar.space.xl` (forty-eight units) to prevent accidental taps.
* **Continuous Reading Order:** Screen readers move logically from right to left, top to bottom, keeping information structured for assistive technologies.
* **Keyboard Navigation & Highlight Rings:** External keyboard focus matches the Persian RTL layout flow. Focused items are highlighted with a distinct primary accent border mapping to `bankyar.semantic.color.border.active`.
* **Dynamic Typography Scaling:** All text elements and card heights scale up to 200% under system font magnification settings without text overlap, clipping, or loss of container boundaries.

---

## Deliverable 8: RTL Review

Right-to-Left (RTL) localization for Persian-speaking regions is native to every visual component:

* **Mirrored Screen Transitions:** Forward transitions slide the screen contents from the logical-start (right) to the logical-end (left), matching Persian reading patterns.
* **Logical Element Spacing:** Physical spacing directions (`left`/`right`) are prohibited. All margins and alignments are modeled logically using `inline-start` and `inline-end` to ensure consistent rendering.
* **Dynamic Icon Mirroring:** Standard directional icons, such as back chevrons and forward arrows, mirror automatically under RTL locales. Symmetrical icons (e.g., shields, lock pads, and server cylinders) remain unmirrored.
* **Bilingual Number Formatting:** Financial numbers, transaction amounts, and date stamps are rendered as standard Persian numerals (e.g., ۱۲,۳۰۰) rather than Latin glyphs.

---

## Deliverable 9: Permission UX Checklist

Before releasing any permission-related layout, verify compliance against this checklist:

- [ ] **No System Prompt Surprises:** Verify that every system permission prompt is preceded by a dedicated, context-rich pre-education screen.
- [ ] **Graceful Degradation Verified:** Confirm that the application remains fully functional as a manual ledger if SMS permissions are denied.
- [ ] **One-Tap Retry Available:** Ensure that missing permissions can be quickly retried with a single tap from the settings dashboard.
- [ ] **Data Sovereignty Reiterated:** Validate that every permission screen clearly communicates that all data processing and storage remains 100% offline.
- [ ] **Clear Skip Channels:** Ensure non-mandatory permissions (such as Notifications or Storage Backups) feature an obvious, low-friction "Skip" or "Later" option.
- [ ] **Accurate Intent Targets:** Verify that permanently denied recovery CTAs open the native operating system settings app directly to the BankYar detail page.

---

## Deliverable 10: Visual Consistency Checklist

To guarantee a unified brand identity across different screens, layouts must adhere to these spatial constraints:

- [ ] **Consistent Corner Curvatures:** Standard dialogs and modal elements use `bankyar.radius.lg` curves; primary buttons use `bankyar.radius.medium` curves.
- [ ] **Grid-Aligned Layouts:** Elements are positioned using the standardized 8-unit spatial grid mapping to standard design tokens.
- [ ] **High-Contrast Typography Scale:** Headings use `bankyar.semantic.typography.heading.lg` in bold; supporting metadata uses monospace labels.
- [ ] **Uniform Stroke Weights:** Grayscale vector illustrations and UI icons maintain a consistent line weight and rounded terminals.
- [ ] **Safe Area Compliance:** All screens query device notches and navigation bars, applying safe padding buffers to prevent content clipping.

---

## Deliverable 11: Privacy Communication Review

The language used across all permission screens must respect user autonomy and build trust:

* **Active Voice over Technical Terms:** Avoid complex jargon like `RECEIVE_SMS broadcast receiver` or `AES-GCM-256 database serialization`. Use simple, clear Persian: "خواندن پیامک‌های بانکی جهت ثبت خودکار تراکنش‌ها."
* **Full Transparency Guarantee:** Clearly state what data is accessed and what is strictly ignored: "ما فقط پیامک‌های حاوی واریز و برداشت بانک‌ها را می‌خوانیم. پیامک‌های شخصی و کدهای یکبار مصرف شما هرگز لمس نخواهند شد."
* **No Coercive Patterns:** Avoid pressuring the user with alarmist copy like "در صورت لغو مجوز، امنیت مالی شما به خطر می‌افتد." Use professional, neutral statements.
* **Encrypted Offline Proof:** Reinforce the offline-first architecture on every educational screen: "اطلاعات مالی شما به صورت رمزنگاری شده صرفاً روی گوشی شما ذخیره می‌شود و هیچ دسترسی به اینترنت در برنامه وجود ندارد."

---

## Detailed Specification for Required Permissions

To ensure absolute clarity, each of the nine required permissions is mapped below with its complete visual, privacy, and recovery parameters:

### 1. SMS Permission (comprising Receive SMS & Read SMS)
* **Why Required:** To intercept incoming SMS broadcasts from bank senders and parse financial transactions.
* **User Benefit:** Automated ledger updates; eliminates the need to manually enter transaction details.
* **Privacy Explanation:** Only SMS messages from verified banking sender patterns are processed. Personal messages, chats, and OTPs are ignored.
* **Security Explanation:** All parsing runs locally on the CPU; parsed data is stored inside the SQLCipher encrypted volume.
* **When to Ask:** During the initial onboarding flow, immediately after accepting the Privacy Commitment.
* **When NOT to Ask:** If the user is restoring a backup and has opted for manual ledger operations.
* **Retry Strategy:** If denied once, show the SMS Denied Recovery Screen with helpful tips and a retry CTA.
* **Skip Strategy:** The "Skip" action transitions the app to manual entry mode.
* **Recovery Strategy:** A persistent, low-friction banner appears in the ledger dashboard if SMS permissions are missing.

### 2. Notification Permission
* **Why Required:** To display immediate transaction confirmations and security lockout alerts.
* **User Benefit:** Provides real-time feedback on successful background parses and warnings about unauthorized access attempts.
* **Privacy Explanation:** Notification details are generated locally by the application and are never sent to remote push servers.
* **Security Explanation:** Sensitive amounts can be masked in public notification banners based on user preference.
* **When to Ask:** During onboarding, immediately after granting or skipping SMS permissions.
* **When NOT to Ask:** If the device is running Android 12 or lower, where notification permissions are granted by default.
* **Retry Strategy:** Provide a toggle in the settings panel to re-enable alerts.
* **Skip Strategy:** The user can skip this permission without affecting the core parsing engine.
* **Recovery Strategy:** If revoked, display a notification status indicator card in the settings dashboard.

### 3. Battery Optimization Exclusion
* **Why Required:** To bypass system memory limits that terminate long-running background services.
* **User Benefit:** Guarantees that transaction alerts are processed instantly, even when the device has been idle for several hours.
* **Privacy Explanation:** No usage logs or telemetry are shared with the OS or third-party performance monitors.
* **Security Explanation:** Keeping the background parse process active prevents database locking issues on app launch.
* **When to Ask:** After Notification setup is finalized during onboarding.
* **When NOT to Ask:** If the device is connected to a power source or if the manufacturer has no aggressive background limits.
* **Retry Strategy:** Present an instructional card inside the settings panel detailing battery settings.
* **Skip Strategy:** Users can skip, with a warning that transaction processing may be delayed.
* **Recovery Strategy:** Monitor background parse latency and alert the user if processing delays occur.

### 4. Biometric Authentication
* **Why Required:** To unlock the local encrypted database using the device's hardware biometric sensors.
* **User Benefit:** Fast, secure, and convenient app login without typing the PIN.
* **Privacy Explanation:** Biometric templates remain securely inside the device's hardware chip (TEE/StrongBox); the app never accesses raw fingerprint or face data.
* **Security Explanation:** The Keystore database key wrapper is physically bound to biometric verification.
* **When to Ask:** During security configuration, immediately after the application PIN is set.
* **When NOT to Ask:** If the device does not have enrolled biometrics or lacks secure hardware.
* **Retry Strategy:** Show a "Try Biometrics" button on the PIN entry screen if biometrics fail.
* **Skip Strategy:** User enters their standard secure PIN fallback.
* **Recovery Strategy:** Toggling off biometrics deletes the Keystore biometric key wrapper, leaving the PIN fallback active.

### 5. Storage Access (Backup)
* **Why Required:** To read and write encrypted backup files to external device storage.
* **User Benefit:** Protects financial history against device loss and enables easy data migration.
* **Privacy Explanation:** Only reads and writes BankYar-specific backup files. Personal media, documents, and folders are never accessed.
* **Security Explanation:** Backup files are encrypted with AES-GCM, requiring the user's master password to decrypt.
* **When to Ask:** When the user initiates their first manual backup or enables scheduled exports.
* **When NOT to Ask:** During standard daily operations or when backing up to internal sandbox directories.
* **Retry Strategy:** Show a clear error dialog on write failure with a retry action.
* **Skip Strategy:** Force-fallback to internal sandboxed app directories.
* **Recovery Strategy:** Provide a detailed troubleshooting guide for directory permissions.

### 6. Future Notification Listener
* **Why Required:** To capture transaction notifications from digital wallet apps and banking apps.
* **User Benefit:** Enables support for financial notifications, capturing transactions that do not send SMS alerts.
* **Privacy Explanation:** Only parses notifications from authorized financial packages. All other notifications are ignored.
* **Security Explanation:** All notification data is processed locally on-device.
* **When to Ask:** When the user enables "Advanced Capturing" in settings.
* **When NOT to Ask:** During standard onboarding or if the user only uses SMS-based tracking.
* **Retry Strategy:** Direct link to OS Notification Listener settings.
* **Skip Strategy:** Bypasses advanced capture and relies entirely on SMS.
* **Recovery Strategy:** Display a status card in the advanced settings dashboard.

### 7. Future Accessibility Permission
* **Why Required:** To parse and extract transaction details directly from banking apps on-screen.
* **User Benefit:** Direct transaction extraction from banking apps, eliminating manual input for non-SMS accounts.
* **Privacy Explanation:** Only monitors screen elements inside verified banking applications. Personal chats, passwords, and sensitive fields are never read.
* **Security Explanation:** Data extraction is constrained to secure active sessions.
* **When to Ask:** When the user explicitly links an unsupported, non-SMS bank account.
* **When NOT to Ask:** During onboarding or standard SMS parsing operations.
* **Retry Strategy:** Show step-by-step visual guides on how to enable Accessibility settings.
* **Skip Strategy:** Falls back to manual entry for that specific account.
* **Recovery Strategy:** Guide the user to re-enable accessibility services if they are disabled by the OS.

---

## Specification of Permission States

To ensure robust state management, the application maps and responds to seven distinct permission states:

* **Never Requested (درخواست نشده):** The permission has never been requested from the operating system. UI displays pre-education steps.
* **Granted (مجوز صادر شده):** Permission is granted and fully active. UI shows a green checkmark status badge.
* **Denied (رد شده):** The user denied the permission once. UI activates the retry and recovery workflows.
* **Permanently Denied (عدم دسترسی دائمی):** The user denied the permission twice or selected "Don't ask again." UI replaces the standard retry CTA with a "Go to Settings" trigger.
* **Limited (دسترسی محدود):** The permission is granted with restrictions (e.g., photo-only storage limits). UI shows a warning yellow badge "دسترسی محدود شده".
* **Unavailable (غیرقابل دسترس):** The sensor or permission is blocked (e.g., biometrics blocked due to too many failed attempts). UI displays a temporary cooldown message.
* **Unsupported Device (دستگاه ناسازگار):** The physical device lacks the required hardware (e.g., no cellular radio or biometric scanner). UI hides the option or displays a clean unsupported label.

---

## Settings Experience: Permission Dashboard

The **Permission Status Dashboard** in the Settings section serves as the centralized control panel for all system permissions.

```
+-----------------------------------------------------------+
| [PERMISSIONS DASHBOARD]                                   |
|                                                           |
| Permission Health: [ Highly Stable (وضعیت پایدار) ]       |
|                                                           |
| Missing Permissions:                                      |
|  [!] SMS Access - Automated parsing is disabled           |
|                                                           |
| Quick Actions:                                            |
|  [ ONE-TAP RETRY ]           [ OPEN SYSTEM SETTINGS ]     |
|                                                           |
| Help Section:                                             |
|  - Why does BankYar need SMS access?                      |
|  - How is my privacy protected offline?                   |
+-----------------------------------------------------------+
```

### 1. Permission Status Dashboard Screen (داشبورد وضعیت مجوزها)
* **Purpose:** Provide a centralized hub for users to inspect, grant, or revoke permissions.
* **Business Goal:** Minimize user confusion regarding app permissions and simplify the recovery process.
* **Visual Priority:** The Permission Health indicator displays a prominent, color-coded health card at the top of the workspace.
* **Layout:** Centered single-column layout with vertical category groups.
* **Spacing:** Section gutters use `bankyar.responsive.gutter`; cards are separated by `bankyar.space.md`.
* **Typography:** Health statuses styled with `bankyar.semantic.typography.heading.md`.
* **Illustrations:** A security check shield vector.
* **Icons:** Checkmarks, warnings, and error symbols.
* **CTA Buttons:** Solid button "بررسی مجدد مجوزها" (Recheck Permissions).
* **Secondary Actions:** Outlined button "باز کردن تنظیمات اندروید" (Open Android Settings).
* **Loading:** A smooth linear shimmer sweeps across status rows during active scans.
* **Accessibility:** Full reading order of all status rows with spoken state updates (e.g., "دسترسی پیامک قطع است، برای اصلاح ضربه بزنید").
* **RTL Behaviour:** Mirroring matches standard rules; statuses are right-aligned.
* **Animation:** Transition menu options expand and collapse smoothly.

### 2. Permission Health (سلامت مجوزها)
* **Visual Representation:** An elevated card at the top of the dashboard showing the active health score.
* **States:**
  * **Stable (پایدار):** All critical permissions are granted. Emerald green theme with a shield check icon.
  * **Degraded (محدود شده):** Missing non-critical permissions (e.g., notification alerts). Yellow gold theme with a warning triangle icon.
  * **Critical (بحرانی):** Missing critical permissions (e.g., SMS access). Crimson error theme with an octagonal alert icon.

### 3. Missing Permissions Card (کارت مجوزهای مفقود)
* **Visual Representation:** A highlighted card listing missing permissions with clear, actionable solutions.
* **Interactive Rule:** Tapping a missing permission row opens its dedicated pre-education card, allowing the user to grant access directly.

### 4. One-Tap Retry
* **Visual Representation:** A dedicated quick-action button on the dashboard card.
* **Interactive Rule:** Taps trigger immediate scans and launch corresponding pre-education panels.

### 5. Open Android Settings Button
* **Visual Representation:** Outlined button utilizing `bankyar.semantic.color.border.subtle` borders.
* **Interactive Rule:** Launches the native system app settings page.

### 6. Permission Help (راهنمای مجوزها)
* **Visual Representation:** A vertical accordion list at the bottom of the dashboard containing common questions and answers.
* **Interactive Rule:** Tapping a question smoothly expands the answer panel.

---

## Dialog Specifications

All dialogs conform to Material Design 3 guidelines: rounded corners matching `bankyar.radius.lg`, background fills matching `bankyar.semantic.color.surface.flat`, and persistent accessibility backdrops.

### 1. Permission Required Dialog
* **Purpose:** Explains why a critical permission is required when the user attempts an action that requires it.
* **RTL Layout:** Symmetrical box. Icon `bankyar.icon.sms` in primary active colors sits at the logical start (right) of the header.
* **Content:** "برای تحلیل خودکار هزینه‌ها، دسترسی پیامک الزامی است. بدون این دسترسی، باید تراکنش‌ها را به صورت دستی وارد کنید."
* **Actions:**
  * **Primary (Logical End / Left):** "تایید و ورود" (Confirm and Grant).
  * **Secondary (Logical Start / Right):** "انصراف" (Cancel).

### 2. Permission Denied Dialog
* **Purpose:** Displayed after a user denies a permission, providing reassurance and a path to retry.
* **RTL Layout:** Symmetrical container. Warn marker icon sits on the right.
* **Content:** "مجوز پیامک تایید نشد. بدون این دسترسی، تحلیل خودکار پیامک‌ها ممکن نیست. اطلاعات شما کاملاً ایمن و آفلاین روی گوشی پردازش می‌شود."
* **Actions:**
  * **Primary (Logical End / Left):** "تلاش مجدد" (Retry).
  * **Secondary (Logical Start / Right):** "ادامه به صورت دستی" (Continue Manually).

### 3. Permission Permanently Denied Dialog
* **Purpose:** Explains that the permission has been permanently denied and guides the user to system settings.
* **RTL Layout:** High-contrast box. Red hazard octagon icon sits on the right.
* **Content:** "دسترسی پیامک به طور دائمی رد شده است. برای فعال‌سازی خودکار، باید مجوز پیامک را از تنظیمات گوشی صادر کنید."
* **Actions:**
  * **Primary (Logical End / Left):** "ورود به تنظیمات سیستم" (Open Settings).
  * **Secondary (Logical Start / Right):** "ادامه به صورت دستی" (Continue Manually).

### 4. Go to Settings Dialog
* **Purpose:** Prompts the user before redirecting them to system settings.
* **RTL Layout:** Standard dialog with info badge on the right.
* **Content:** "اکنون به صفحه تنظیمات سیستم منتقل می‌شوید. لطفاً در بخش مجوزها (Permissions)، دسترسی پیامک را فعال کنید."
* **Actions:**
  * **Primary (Logical End / Left):** "انتقال به تنظیمات" (Go to Settings).
  * **Secondary (Logical Start / Right):** "لغو" (Cancel).

### 5. Permission Granted Dialog
* **Purpose:** Confirms successful permission acquisition and transitions to the next step.
* **RTL Layout:** Success card. Emerald green check icon sits on the right.
* **Content:** "مجوز دسترسی با موفقیت صادر شد. سیستم پردازش خودکار فعال گردید."
* **Actions:** "ادامه پیکربندی" (Continue Setup).

### 6. Unsupported Device Dialog
* **Purpose:** Informs the user when their device lacks the required hardware.
* **RTL Layout:** Symmetrical layout. Grayed info icon sits on the right.
* **Content:** "دستگاه شما فاقد سنسور زیست‌سنجی (اثر انگشت) است. لطفاً از پین‌کد ورود استفاده کنید."
* **Actions:** "متوجه شدم" (I Understand).

---

## Appendix A: Layout and Spacing Verification Index

This index outlines how the permission experience integrates with each layout and spacing deliverable defined in the design system.

#### Layout Philosophy
The layout philosophy emphasizes physical and visual safety, ensuring that all information regarding permission requirements is legible and easy to understand.

#### Spatial Design Principles
Elements are positioned using the 8-unit spatial grid, establishing a consistent vertical and horizontal rhythm.

#### Grid Architecture
All layouts align with the standard grid architecture, utilizing margins and column alignments defined by design tokens.

#### Baseline Grid Strategy
Typography is aligned to a baseline grid, preventing text overlap and ensuring clear layout reading lines.

#### Responsive Grid System
Layout grids adapt dynamically across compact, medium, and expanded viewports.

#### Layout Zones
Every permission screen uses a standardized three-zone layout (Zone A: Header/Progress, Zone B: Work Workspace, Zone C: Bottom Action Bar).

#### Safe Area Strategy
The interface queries device safe areas, applying padding buffers to prevent notches or navigation bars from obscuring content.

#### Screen Margins
Outer margins scale with the viewport size, adhering to `bankyar.responsive.margin` specifications.

#### Internal Padding Strategy
Card contents and button text use relative padding tokens (e.g., `bankyar.space.md`), ensuring visual stability.

#### External Spacing Strategy
Spacing between distinct cards and interactive blocks uses external spacing tokens (e.g., `bankyar.space.lg`).

#### Vertical Rhythm
Standard vertical gaps maintain a consistent spacing rhythm across all onboarding and settings screens.

#### Horizontal Rhythm
Horizontal reading lines flow naturally from right to left, aligning elements symmetrically.

#### Content Width Rules
Content is constrained on wide tablet viewports to prevent wide, unreadable text lines.

#### Container Rules
Cards and dialogue blocks use rounded containers with specified stroke weights and corner curvatures.

#### Card Layout Rules
Educational detail cards group information cleanly using subtle borders, avoiding heavy shadows.

#### List Layout Rules
The permission status dashboard displays settings in a neat, vertical list aligned to the grid.

#### Detail Screen Layout
Pre-education screens focus on a single message, avoiding complex layouts or secondary actions.

#### Form Layout Rules
Input forms (such as the security PIN input) are centered and use accessible numeric keypads.

#### Dialog Layout Rules
Dialog overlays are centered, use distinct background surfaces, and contain clear action boundaries.

#### Bottom Sheet Layout
Modal sheets use the extra-large corner radius token on top edges, sliding in smoothly from the bottom.

#### Navigation Layout
Backward navigation is supported via back chevrons in the header; forward navigation uses primary action CTAs.

#### App Bar Layout
The top app bar remains pinned, housing the page title and standard navigation chevrons.

#### FAB Placement Rules
Floating action buttons are not used in the permission flow to maintain clear action paths.

#### Search Layout
Search features are omitted from the permission experience to simplify navigation.

#### Statistics Layout
Statistics visual elements are not used on permission pre-education screens.

#### Chart Layout
Complex charts are omitted from the permission flow to minimize cognitive load.

#### Empty State Layout
The recent security events timeline displays a clean, non-intrusive empty state illustration when no events exist.

#### Loading Layout
Interactive rows and score cards display smooth shimmers during active background checks.

#### Error Layout
Validation failures or revoked permissions trigger high-contrast Crimson alert borders with retry triggers.

#### Keyboard-safe Layout
PIN entry screens adjust layout heights when the keyboard is active, keeping action buttons visible.

#### Foldable Device Strategy
On foldables, layouts split dynamically into a double-column view, keeping content readable across the hinge.

#### Tablet Strategy
Tablet layouts utilize horizontal columns to optimize widescreen real estate.

#### Landscape Strategy
Under landscape orientations, scroll areas expand to prevent content clipping or overlapping buttons.

#### Split-screen Strategy
The interface scales gracefully under split-screen modes, prioritizing primary action buttons.

#### RTL Layout Strategy
All layouts, page transitions, and chevrons mirror naturally to support native Persian RTL reading flows.

#### Layout Token Mapping
No raw styling values exist in the layout code. Every property maps to an active design token.

#### Governance Rules
Style modifications are strictly managed; custom styles inside components are prohibited.

#### Validation Rules
Visual consistency is verified using automated validation checks to prevent layout regressions.

#### Anti-pattern Catalog
Avoid hardcoded spacing coordinates, absolute left/right alignments, and unmirrored icons.

#### Future Evolution Strategy
The layout is designed to support future cross-platform and multi-language expansions easily.

---

## Appendix B: Accessibility and Inclusive Design Verification Index

This index outlines how the permission experience integrates with each accessibility and inclusive design deliverable.

#### Accessibility Philosophy
We believe that accessibility is not a feature but a fundamental requirement. The permission experience is designed to be fully usable by everyone.

#### Inclusive Design Principles
The interface avoids complex language and presents information clearly, lowering cognitive barriers.

#### Accessibility Goals
We target 100% WCAG 2.2 AA compliance across all onboarding and settings screens.

#### User Personas with Disabilities
Design decisions are informed by diverse user personas, including those with visual, motor, or cognitive impairments.

#### Vision Accessibility
Contrast ratios meet strict accessibility standards under both light and dark system themes.

#### Low Vision Strategy
Layout elements and cards expand vertically to support system text scaling without clipping.

#### Color Blind Strategy
Status indicators do not rely on color shifts alone. Icons and clear labels are always present.

#### High Contrast Strategy
High contrast tokens are applied to key interactive borders to assist users with low vision.

#### Large Text Strategy
All labels and text blocks support magnification up to 200%.

#### Dynamic Text Scaling
Text lines wrap cleanly when resized, avoiding horizontal scrolling or clipped labels.

#### Screen Reader Support
Assistive technologies can read and navigate all permission elements in a logical order.

#### Semantic Labels Strategy
Buttons and switches feature descriptive semantic descriptions for screen readers.

#### Reading Order Rules
The tab focus moves systematically from top-right to bottom-left, matching Persian RTL patterns.

#### Focus Order Rules
The keyboard focus remains locked inside modal frames until they are dismissed.

#### Keyboard Navigation
External keyboard users can navigate screens using standard Tab and Enter keys.

#### Switch Access Support
The interface supports standard switch access devices, keeping interactive targets easy to reach.

#### Voice Access Support
Active labels match their spoken commands, enabling seamless hands-free navigation.

#### Touch Target Guidelines
Buttons and switches maintain a minimum touch height of `bankyar.space.xl` (forty-eight units).

#### Gesture Alternatives
Swipe actions are accompanied by simple tap alternatives to assist users with motor control impairments.

#### Motion Sensitivity
Users can disable transitions using the system settings toggle.

#### Reduced Motion Rules
When reduced motion is enabled, all animations are replaced by instant transitions.

#### Cognitive Accessibility
Clear copy and simple step-by-step progressions reduce cognitive load and anxiety.

#### Memory Load Reduction
We minimize memory load by presenting information on-screen, avoiding complex multi-step rules.

#### Error Prevention
Mandatory checkboxes remain disabled until accepted, protecting users from accidental progression.

#### Error Recovery
Every permission denial or validation failure features a clear, accessible recovery button.

#### Financial Data Readability
Numbers are rendered using large, highly legible monospace fonts with generous line spacing.

#### Number Accessibility
Persian numeral characters are formatted cleanly to ensure clear reading.

#### Chart Accessibility
Charts are omitted from the permission flow to maintain simplicity.

#### Form Accessibility
Input forms feature large touch targets, clear labels, and immediate validation feedback.

#### Search Accessibility
Search controls are not used in the permission experience.

#### Notification Accessibility
Local push notifications meet high contrast standards and support system screen readers.

#### Dialog Accessibility
Dialogs remain focused and can be dismissed easily using clear "Cancel" or "Close" actions.

#### Navigation Accessibility
The navigation system features back chevrons and logical progress indicators on every screen.

#### RTL Accessibility
RTL layouts mirror focus orders and reading patterns, ensuring a comfortable experience for Persian readers.

#### Localization Accessibility
Localization uses accurate, natural Persian phrasing, avoiding literal translations.

#### Accessibility Token Mapping
Accessibility behaviors map to standard design tokens to ensure consistent performance across themes.

#### Accessibility Testing Strategy
All screens undergo manual and automated testing to verify accessibility compliance.

#### Manual Testing Checklist
- [ ] Verify screen reader reading order.
- [ ] Confirm high text scaling readability.
- [ ] Check touch target sizes.
- [ ] Test keyboard focus rings.

#### Automated Testing Strategy
Automated tools check code elements for correct semantic labels and focus states.

#### Accessibility Governance
Design reviews ensure that all updates comply with accessibility guidelines.

#### Accessibility Review Process
Every interface update must pass a thorough accessibility review before release.

#### Anti-pattern Catalog
Avoid unlabelled icons, low text contrasts, small buttons, and complex swipe gestures.

#### Compliance Matrix
Ensures all layout elements map directly to WCAG 2.2 AA guidelines.

#### Future Evolution Strategy
The accessibility model is built to scale easily with future system updates and features.

---

## Appendix C: Required Structures Mappings

#### Accessibility Architecture
The application isolates accessibility behaviors into dedicated semantic layers, ensuring consistent performance.

#### Inclusive Personas
Visual and interactive designs are tested against diverse user needs, including color-blind and low-vision users.

#### WCAG Mapping
- **Guideline 1.4.3 (Contrast):** Verified minimum contrast of 4.5:1.
- **Guideline 2.1.1 (Keyboard):** All functions are navigable using external keyboards.
- **Guideline 2.5.5 (Target Size):** Touch targets maintain a minimum 48x48 unit size.

#### Testing Matrix
Permission flows undergo automated layout checks, manual screen reader tests, and user testing.

#### Governance Rules
All design updates must comply with accessibility and design token guidelines.

#### Accessibility Checklist
- [ ] Screen readers announce all page labels.
- [ ] Active focus orders align right-to-left.
- [ ] No information is conveyed by color alone.
- [ ] Touch targets meet minimum size rules.

#### Review Workflow
Design updates are reviewed by accessibility specialists to ensure compliance.

---
**End of Permission Experience Specification Document**
