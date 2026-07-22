# BankYar Authentication & Security Experience Specification (v2.0.0)
## Enterprise-Grade Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 2.0.0
**Authors:** Principal Product Designer, Security UX Architect, Material Design 3 Expert, Flutter UI Architect, Authentication Experience Specialist, and Enterprise FinTech Design Director
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The authentication experience of **BankYar** is the absolute gatekeeper of financial privacy, trust, and on-device data sovereignty. As an offline-first, secure mobile financial application optimized for Persian RTL environments, the app must deliver a security posture that is bulletproof to local threats while remaining incredibly fast and accessible to users. Natively integrated with **Material Design 3 (MD3)** design patterns and abstract design tokens (`bankyar.*`), the authentication system ensures **zero hardcoded styles, colors, or physical layout coordinates**, guaranteeing seamless theme switches (including dynamic Dark Mode), full WCAG 2.2 AA accessibility compliance, and absolute user confidence.

This comprehensive specification outlines the complete, production-ready visual architecture, user flows, screen-by-screen UX layouts, dialog specifications, state matrices, and validation guidelines for the entire BankYar authentication journey.

---

## Section 1: Complete Authentication Journey

The authentication journey is a closed-loop system designed to guide the user from first-time setup to daily fast-access unlock, with secure fail-safe and recovery procedures.

```
FIRST-TIME SETUP (ONBOARDING)
  [Screen A.1: Welcome to Security] ──> [Screen A.2: Why Protect Your Data]
                 │
                 ▼
  [Screen B.1: Create PIN (4-Digit)] ──> [Screen B.2: Confirm PIN]
                 │ (Strength and Validation Checks)
                 ▼
  [Screen C.1: Enable Biometrics Prompt] ──> [Screen C.2: Biometric Enrollment (Native Override)]
                 │
                 ▼
  [Onboarding Complete / Proceed to Ledger Tab]

DAILY UNLOCK FLOW
  [App Launch / Resume]
                 │
                 ▼
  [Is Biometrics Enabled?]
       ├── Yes ──> [Screen E.1: Daily Quick Unlock (Biometric Overlay)]
       │             ├── Success ──> [Access Granted]
       │             └── Failure ──> [Fallback to PIN Interface]
       │
       └── No ───> [Screen D.1: Daily Unlock (PIN Input Keypad)]
                     ├── Success ──> [Access Granted]
                     └── Failure ──> [Increment Failed Counter]
                                       │
                                       ▼
                       [Reached Maximum Attempts?]
                            ├── Yes ──> [Screen F.2: Security Lockout State]
                            │             └── PIN Blocked (Temporary/Permanent)
                            └── No ───> [Display Actionable Error Inline]

MAINTENANCE & RECOVERY GATES
  [Settings Preferences Center]
       ├── [Screen G.1: Change PIN Flow] (Verify Old -> Create New -> Confirm)
       ├── [Screen G.2: Disable PIN Lock] (High-risk warning -> Authenticate -> Disable)
       ├── [Screen G.3: Toggle Biometrics] (Enable/Disable state-bindings)
       └── [Screen F.1: Forgot PIN / Recovery Flow] (Emergency recovery verification)
```

The journey covers 17 distinct operational states and touchpoints:
1. **Welcome to Security**: Transitioning from general onboarding to the dedicated security onboarding phase.
2. **Why Protect Your Data**: Clear educational framing showing why on-device financial ledgers need protection.
3. **Create PIN**: Entry point for setting up the mandatory 4-digit PIN access key.
4. **Confirm PIN**: Interactive secondary input gate ensuring correct sequence entry.
5. **PIN Strength Feedback**: Real-time evaluation (warning of simple patterns, sequences, or repeated digits).
6. **Enable Biometrics**: Direct opt-in interface to register fast biometric logins.
7. **Biometric Enrollment**: Seamless hand-off to native system biometrics.
8. **Authentication Success**: Visual and haptic confirmation of granted access.
9. **Authentication Failure**: Inline high-contrast error messages paired with descriptive iconography.
10. **Forgot PIN Flow**: Multi-tiered secure recovery gate that doesn't compromise data sovereignty.
11. **Security Lockout**: Cooldown timers protecting against automated local brute-force attacks.
12. **Change PIN**: Inside-settings pathway to securely update active credentials.
13. **Disable PIN**: Destructive settings pathway with high-risk prompts and confirmations.
14. **Disable Biometrics**: Instant opt-out toggle that clears local cryptographic wrapper bindings.
15. **App Unlock**: Fast-access secure gateway presented on every application cold-start.
16. **Auto Lock**: Dynamic idle listener that locks the application when sent to the background or left inactive.
17. **Session Expiration**: Automatic purging of volatile cryptographic keys from RAM after 5 minutes of total inactivity.

---

## Section 2: Screen Hierarchy

The BankYar authentication interface resides in a dedicated vertical slice of the application architecture, structured systematically according to the three-zone layout model.

```
[Application Shell Root]
  ├── [Zone A: Persistent High-Security Sticky Header]
  │     ├── [Screen Title / Brand Mark] (Centered, high-contrast, no back-arrow on cold launch)
  │     ├── [System Status Indicator] (Integrity status, on-device encryption active badge)
  │     └── [Emergency Actions Trigger] (Quick-lock or secure wipe indicator)
  │
  ├── [Zone B: Scrollable Workspace / Main Keypad Canvas]
  │     ├── [Screen A.1: Welcome to Security Screen]
  │     ├── [Screen A.2: Why Protect Your Data Screen]
  │     ├── [Screen B.1: Create PIN Screen]
  │     ├── [Screen B.2: Confirm PIN Screen]
  │     ├── [Screen C.1: Enable Biometrics Screen]
  │     ├── [Screen D.1: Daily App Unlock Screen (PIN Input)]
  │     ├── [Screen E.1: Daily Quick Unlock (Biometric Fallback Screen)]
  │     ├── [Screen F.1: Forgot PIN & Emergency Recovery Screen]
  │     ├── [Screen F.2: Security Lockout Screen]
  │     ├── [Screen G.1: Change PIN Screen]
  │     ├── [Screen G.2: Disable PIN Screen]
  │     └── [Screen G.3: Manage Biometrics Screen]
  │
  └── [Zone C: Interactive Footer & Security Attestation]
        ├── [Primary Solid Action Button / Next Key / Keypad Panel]
        ├── [Secondary Ghost Recovery Buttons]
        └── [Absolute Privacy Seal Label] ("۱۰۰٪ آفلاین و رمزگذاری‌شده در سخت‌افزار")
```

All screens within this hierarchy are structured around five primary Material Design 3 interactive patterns:
1. **Interactive Cards (`bankyar.radius.lg`):** For educational copy, security score progress, and feedback components.
2. **Keypad Button Cells (`bankyar.radius.full`):** Round circular buttons for entering numerical digits, maintaining a huge 64x64 unit touch target.
3. **Primary Solid CTA Buttons (`bankyar.radius.md`):** High-contrast buttons anchored at the bottom (Zone C) of onboarding screens.
4. **Interactive Text Fields (`bankyar.radius.md`):** Highlighted inputs featuring real-time validations.
5. **Dynamic Modals (`bankyar.radius.xl`):** Bottom sheets and system-dialog frames overlaying the main canvas during verification checkpoints.

---

## Section 3: Screen-by-Screen Specifications

Below is the exhaustive screen-by-screen specification for the core authentication, biometric setup, and unlock experiences of BankYar.

### SUB-SECTION I: PIN Setup Flow (پیکربندی پین‌کد امنیتی)

#### Screen B.1: Create PIN (صفحه ایجاد پین‌کد)
* **Purpose:** Allows the user to enter their initial 4-digit security PIN during onboarding to encrypt the database wrapper.
* **Business Goal:** Get the user to configure a reliable, secure fallback key without cognitive fatigue.
* **Visual Priority:** PIN entry indicator dots (large and glowing) followed by the large touch-friendly custom numerical keypad.
* **Layout:** Centered single-column layout inside Zone B. No text inputs; users tap keys on a custom grid-aligned keypad located in the lower region of Zone B.
* **Spacing:** Margins use `bankyar.responsive.margin`. The spacing between the instructional title and PIN dots is `bankyar.space.xl` (48 units). Keypad buttons are spaced evenly with `bankyar.space.sm` (8 units) on all sides.
* **Typography:** Title is styled with bold `bankyar.font.size.xl` under `bankyar.semantic.typography.heading.lg`. Sub-labels use regular `bankyar.font.size.md`. Monospaced keypad characters use large `bankyar.font.size.xxl` for maximum readability.
* **Icons:** Backspace deletion icon `bankyar.icon.backspace` is positioned inside the bottom-left keypad cell. Secure lock outline `bankyar.icon.lock` is shown inside the instructional title.
* **Illustrations:** A soft-drawn geometric vector illustration representing "PIN Code Security" centered in Zone B behind the instruction stack, styled using `bankyar.semantic.color.surface.flat`.
* **CTA Buttons:** None. Standard progression is automated the moment the 4th digit is entered successfully.
* **Secondary Actions:** "Skip Security Setup" (رد شدن) is positioned at the logical-end (left) of Zone A, redirecting the user to a high-risk confirmation warning modal.
* **Loading:** If checking cryptographic Keystore availability, the keypad dims with an overlay containing a circular spinner.
* **Accessibility:** Screen reader announces: "مرحله ایجاد پین‌کد امنیتی ۴ رقمی. لطفاً ۴ رقم را با استفاده از صفحه‌کلید پایین وارد کنید." Individual key presses trigger discrete haptic feedback and speak the numeric character (e.g., "عدد ۵ وارد شد"). PIN dots expose an explicit semantic label "پین‌کد دارای ۲ رقم وارد شده".
* **RTL Behaviour:** Symmetrical 3x4 layout for the keypad. Numbers remain standard Persian characters. Keypad navigation moves logically from right-to-left.
* **Animation:** Keypad button cells scale down by 10% on touch press (`bankyar.motion.duration.fast`) utilizing curve `bankyar.motion.curve.decelerate`. Input confirmation dots transition with a subtle pop-scale effect.

#### Screen B.2: Confirm PIN (صفحه تأیید پین‌کد)
* **Purpose:** Requires the user to re-enter the newly created 4-digit PIN to prevent typos before finalizing database encryption.
* **Business Goal:** Guarantee 100% key accuracy to prevent immediate user lockouts.
* **Visual Priority:** Glowing confirm PIN dots in the center. An animated checkmark highlights successful matches.
* **Layout:** Identical centered layout matching Screen B.1 to minimize visual shifts.
* **Spacing:** Matches Screen B.1 perfectly. Standardizes structural alignment tokens.
* **Typography:** Matches Screen B.1. The feedback text dynamically scales up using `bankyar.font.size.md`.
* **Icons:** Backspace indicator and lock checkmark `bankyar.icon.check.circle`.
* **Illustrations:** Visual lock layout scales down and integrates into the center of the viewport to represent cryptographic confirmation.
* **CTA Buttons:** "Save & Proceed" button (`bankyar.component.button.primary.fill`) is enabled only when the confirmed sequence matches the original sequence exactly.
* **Secondary Actions:** "Cancel & Reset PIN" (شروع مجدد) is presented at the logical-start (right) of Zone A, returning the user to Screen B.1 with empty states.
* **Loading:** Displays a pulsing transition with text "درحال مقداردهی پایگاه داده امن..." upon saving.
* **Accessibility:** Emits high-contrast state transitions. Screen reader warns on mismatch: "تکرار پین‌کد همخوانی ندارد. لطفاً دوباره تلاش کنید."
* **RTL Behaviour:** Mirrored keypad grid. Confirm message text flows from right to left.
* **Animation:** Confirmed input dots slide on the horizontal axis with a gentle shake if a mismatch occurs, utilizing `bankyar.motion.curve.standard` and Crimson color alerts.

#### Screen B.3: PIN Strength Feedback (نمایش قدرت پین‌کد)
* **Purpose:** Real-time visual panel displaying the complexity and vulnerability status of the selected PIN (rejects simple or sequential combinations like `1234` or `1111`).
* **Business Goal:** Mitigate physical dictionary and shoulder-surfing attacks by steering users toward stronger passcode sequences.
* **Visual Priority:** Dynamic color-coded segmented bar situated immediately below the PIN input dots.
* **Layout:** Integrated inline layout directly inside Screen B.1 and Screen B.2, positioned in the middle stack of Zone B.
* **Spacing:** Segmented feedback bar sits `bankyar.space.sm` below the PIN dots, with horizontal margins matching the card container.
* **Typography:** Feedback label styled with bold `bankyar.font.size.xs`.
* **Icons:** Warning triangle `bankyar.icon.alert.warning` (for simple PINs) or secure shield check `bankyar.icon.shield.check` (for strong PINs).
* **Illustrations:** None. Uses simple abstract progress bars.
* **CTA Buttons:** None.
* **Secondary Actions:** None.
* **Loading:** Static. Updates in real-time within 50ms of the 4th digit's entry.
* **Accessibility:** Screen readers speak: "پین‌کد انتخابی ضعیف است. لطفاً از رمزهای غیرتکراری و غیرمتوالی استفاده کنید."
* **RTL Behaviour:** The strength segment bar fills from right to left. Warning icons are placed on the logical-start (right) of the text.
* **Animation:** Segmented indicators transition colors from red (Crimson) to amber (Gold) to green (Emerald) using curve `bankyar.motion.curve.linear` over `bankyar.motion.duration.instant`.

---

### SUB-SECTION II: Biometric Flow (پیکربندی هویت زیست‌سنجی)

#### Screen C.1: Enable Biometrics (صفحه فعال‌سازی اثر انگشت)
* **Purpose:** Asks the user to authorize biometric access (fingerprint/face recognition) for daily rapid unlocking.
* **Business Goal:** Boost daily active retention by providing a frictionless, single-second login option.
* **Visual Priority:** High-contrast fingerprint scanner illustration with a glowing pulse ring, followed by the main solid confirmation button.
* **Layout:** Centered single-column layout. Section is enclosed in an interactive card container matching `bankyar.radius.lg`.
* **Spacing:** Spacing between the scanning illustration and the explanatory text card is `bankyar.space.lg` (24 units). Control actions in Zone C are separated by `bankyar.space.md`.
* **Typography:** Explanatory text uses standard `bankyar.font.size.md` under `bankyar.font.leading.loose`.
* **Icons:** Dynamic fingerprint icon `bankyar.icon.fingerprint` and face outline `bankyar.icon.face`.
* **Illustrations:** A detailed vector showing a physical thumb scanning on a device, rendered in dark gray tones using `bankyar.semantic.color.text.secondary`.
* **CTA Buttons:** Solid button "Enable Biometric Unlock" (فعال‌سازی ورود سریع) positioned in Zone C.
* **Secondary Actions:** "Skip & Use PIN Only" (ورود با پین‌کد) styled as an outlined low-contrast button.
* **Loading:** While checking hardware biometric sensors, the screen displays a spinning radar loop with text "درحال بررسی سنسور زیست‌سنجی...".
* **Accessibility:** Direct touch access targets exceed `bankyar.space.xl` (48 units). Text describes advantages clearly for voice output.
* **RTL Behaviour:** Symmetrical illustrations. Explanatory list bullets are positioned on the right logical edge.
* **Animation:** Thumb scanning illustration features a glowing horizontal radar line moving up and down via curve `bankyar.motion.curve.standard` with duration `bankyar.motion.duration.medium`.

#### Screen C.2: Biometric Enrollment (صفحه ثبت‌نام زیست‌سنجی)
* **Purpose:** Handles the actual secure handshake with the system's hardware credential vault (Android BiometricPrompt overlay).
* **Business Goal:** Ensure biometric keys are securely generated in the hardware TEE (Trusted Execution Environment) and tied to the SQLCipher database.
* **Visual Priority:** Pinned native system bottom sheet overlay containing the secure lock verification.
* **Layout:** Dynamic bottom modal panel (`bankyar.radius.xl`) overlaying the dimmed Screen C.1.
* **Spacing:** Handled by operating system native constraints. The background container utilizes standard padding.
* **Typography:** Native monospace font parameters.
* **Icons:** Key vault lock `bankyar.icon.keyhole.chip`.
* **Illustrations:** Multi-ring secure visual shield.
* **CTA Buttons:** Managed by native system (Cancel button on standard alignment).
* **Secondary Actions:** None.
* **Loading:** Keyring derivation indicator shimmers smoothly.
* **Accessibility:** Fully supports native Android TalkBack screen reader interfaces and dynamic accessibility font scaling.
* **RTL Behaviour:** Native overlay adapts instantly to the system-wide Persian locale settings.
* **Animation:** Native secure overlay slide and fade transformations.

#### Screen C.3: Biometric Changed on Device (هشدار تغییر بیومتریک دستگاه)
* **Purpose:** Displays a critical warning screen if the host operating system detects that a new fingerprint or face profile was added/removed outside the application.
* **Business Goal:** Intercept session hijacking attacks where a malicious actor registers their own fingerprint on the user's unlocked device to bypass app security.
* **Visual Priority:** Crimson hazard alert shield followed by an mandatory PIN authorization prompt.
* **Layout:** Full-width warning card filling Zone B, blocking access to all app features.
* **Spacing:** Margins use `bankyar.responsive.margin`. Critical list items are padded with `bankyar.space.md`.
* **Typography:** Title is styled with Crimson `bankyar.semantic.color.status.error` and bold `bankyar.font.size.lg`.
* **Icons:** Octagonal warning outline `bankyar.icon.alert.critical`.
* **Illustrations:** Abstract diagram showing fingerprint profiles mismatching.
* **CTA Buttons:** Solid CTA "Verify with App PIN" (تأیید هویت با پین‌کد اصلی) to re-bind biometrics.
* **Secondary Actions:** Destructive "Delete and Purge Local Data" (حذف کامل اطلاعات) styled as a red outlined button.
* **Loading:** Disabled during active prompt inputs.
* **Accessibility:** Voice screen reader alerts: "هشدار امنیتی بسیار مهم! اثر انگشت جدیدی روی دستگاه شما تعریف شده است. دسترسی موقتاً مسدود گردید. برای بازگشایی، پین‌کد اصلی را وارد کنید."
* **RTL Behaviour:** Text is aligned right. Primary action remains at the logical-end (left) of the bottom action bar.
* **Animation:** The warning icon pulses slowly with a Crimson glow, changing scale by 5% every 2 seconds.

---

### SUB-SECTION III: Daily Unlock Flow (قفل‌گشایی روزانه برنامه)

#### Screen D.1: App Unlock (صفحه قفل‌گشایی اصلی)
* **Purpose:** Presented on every application cold-launch or dynamic resume if lock state is active.
* **Business Goal:** Block physical unauthorized access to on-device ledger databases.
* **Visual Priority:** Glowing lock status indicator with interactive PIN entry indicators, followed by the rapid numerical keypad.
* **Layout:** Vertical stack. Zone A contains the secure status header; Zone B houses the input field and keypad.
* **Spacing:** Layout grids perfectly match Screen B.1 to ensure visual familiarity.
* **Typography:** Lock subtitle styled with `bankyar.font.size.md`. Monospaced keypad targets use `bankyar.font.size.xl`.
* **Icons:** Closed lock padlock `bankyar.icon.lock` inside the centered status circle.
* **Illustrations:** Minimal background secure shield vector.
* **CTA Buttons:** None. Validation is triggered automatically upon entering the 4th digit.
* **Secondary Actions:** "Forgot PIN?" (فراموشی پین‌کد) is positioned as an outlined text link in Zone C. "Quick Biometrics Scan" is placed on the bottom-right corner of the keypad.
* **Loading:** Screen fades out inside 150ms upon successful master key derivation.
* **Accessibility:** Screen readers read: "بانک‌یار قفل است. لطفاً رمز ورود ۴ رقمی خود را وارد کنید." Keyboard navigation maps buttons in natural reading sequence.
* **RTL Behaviour:** Symmetrical keypad layout. Numbers align to logical center.
* **Animation:** Successful authentication triggers the padlock icon to morph into an open padlock shape `bankyar.icon.lock.open` while turning green (Emerald), scaling up and fading away smoothly inside `bankyar.motion.duration.medium`.

#### Screen D.2: Auto Lock (قفل خودکار پس‌زمینه)
* **Purpose:** Automatically triggers the lock-screen overlay (Screen D.1) if the application remains in the background or inactive for longer than the auto-lock threshold.
* **Business Goal:** Mitigate shoulder-surfing risks and secure data if the device is lost, stolen, or left unattended.
* **Visual Priority:** Immediate overlay transition.
* **Layout:** Full-screen modal overlay.
* **Spacing:** Full safe area padding.
* **Typography:** Matches Screen D.1.
* **Icons:** Lock indicator.
* **Illustrations:** None (instant security shielding).
* **CTA Buttons:** None.
* **Secondary Actions:** None.
* **Loading:** Static.
* **Accessibility:** Invisible to recent task switchers (displays a solid black/theme surface block in recent tasks list).
* **RTL Behaviour:** Natural logical mirroring on recovery inputs.
* **Animation:** When the app resumes after background lock, it transitions to Screen D.1 using a slide-up transition from the bottom edge.

#### Screen D.3: Session Expiration (منقضی شدن نشست کاربری)
* **Purpose:** Safely purges master encryption keys from RAM after 5 minutes of total application inactivity, forcing a hardware-level re-authentication on the next launch.
* **Business Goal:** Prevent cold memory scraping attacks and minimize key exposure in active device memory.
* **Visual Priority:** Solid screen shield overlay.
* **Layout:** Immediate transition to Screen D.1, showing an inline notification banner "نشست منقضی شد".
* **Spacing:** Spacing matches standard alert components.
* **Typography:** Alert banner text uses `bankyar.font.size.sm`.
* **Icons:** Out-of-time hourglass `bankyar.icon.hourglass`.
* **Illustrations:** None.
* **CTA Buttons:** None.
* **Secondary Actions:** None.
* **Loading:** Performs silent cryptographic key erasure on memory volumes.
* **Accessibility:** Screen reader speaks: "مدت زمان استفاده شما به پایان رسید. جهت امنیت، کلیدهای محلی پاکسازی شدند. مجدداً احراز هویت کنید."
* **RTL Behaviour:** Mirrored alert notification layout.
* **Animation:** Seamless fade transition.

---

## Section 4: Error Recovery Flow (روند بازیابی و مدیریت خطاها)

When local authentication credentials fail or are compromised, BankYar implements a multi-tiered, high-security recovery system. Since the application is 100% offline, cloud-based OTP resets or email verification links are mathematically impossible. Recovery must rely entirely on local hardware attestation, local recovery backups, and secure cryptographic key overrides.

```
       [USER ENTERS WRONG PIN]
                 │
                 ▼
     [Increment Fail Counter (C)]
                 │
         ┌───────┴───────┐
         ▼               ▼
      [C < 3]         [C >= 3] ──> [Enforce Temporary Lockout]
         │                                   │
         ▼                                   ▼
[Show Wrong PIN Inline]           [Start 60-Second Cooldown]
                                             │
                                             ▼
                                  [Lockout Counter Reaches 5 Blocks?]
                                             ├── Yes ──> [Screen F.2: Permanent Lockout State]
                                             │             └── Prompt: Type 12-Word Recovery Key
                                             │                   ├── Match ──> [Decrypt & Reset PIN]
                                             │                   └── Fail ───> [Force Emergency Data Wipe]
                                             │
                                             └── No ───> [Allow PIN re-entry after Timer expires]
```

### 1. Forgot PIN Flow (بازیابی پین‌کد فراموش‌شده)
* **Trigger:** Accessible via the "Forgot PIN?" text link on the App Unlock screen (Screen D.1).
* **Security Rule:** Prevents trivial bypassing. Bypassing authentication requires verification of the **12-Word Secure Recovery Key** generated during the initial backup setup (specified in `BACKUP_RESTORE_SCREEN_SPECIFICATION.md`).
* **Visual Presentation:** Clean list of twelve sequential input text fields styled with `bankyar.radius.md` and bordered outlines.
* **Result:**
  * **Success Match:** Derives the Master Key wrapper using the 12-word seed, decrypts the SQLCipher database, and prompts the user to configure a new PIN immediately.
  * **Failed Match:** Increments the global lockout block.

### 2. Temporary Lockout (محدودیت موقت دسترسی)
* **Enforced Threshold:** After 3 consecutive failed PIN attempts.
* **Visual Layout:** Replaces the keypad with a full-width card container displaying a ticking countdown timer circle.
* **UX Rule:** Keypad is disabled and dimmed to 38% opacity. The screen rejects all physical and touch gestures.
* **Timer Duration:** 60 seconds for the first block, doubling on subsequent failures up to a maximum of 30 minutes.

### 3. Permanent Lockout & Decoupled Data Purge (انسداد دائمی و انهدام امن)
* **Trigger:** Reached after 15 consecutive failed attempts or 5 continuous temporary lockout violations.
* **UX Safeguard:** The application declares physical access compromised.
* **Enforced Action:** Displays the **Permanent Recovery Portal**. The user has three attempts to input their 12-word recovery seed. If all three fail, the cryptographic engine triggers a silent background **zeroization** of on-device Keystore values and erases the entire offline SQLite database directory, protecting financial assets from hardware extraction.

---

## Section 5: Dialog Specifications

All security dialogs are constructed as modal alert overlays featuring rounded corners (`bankyar.radius.lg`), background canvas mapping to `bankyar.semantic.color.surface.flat`, high-contrast accessibility backdrops with 60% opacity (`bankyar.opacity.translucent`), and clear RTL action sequences.

### 1. Create PIN Dialog (تأییدیه ساخت رمز)
* **Purpose:** Explains the cryptographic significance of the 4-digit PIN before generating Keystore elements.
* **Layout Structure:** Header icon, bold title text, explanatory text block, horizontal separator, and bottom-aligned action rows.
* **Content:**
  * **Header Icon:** Golden keyhole chip `bankyar.icon.keyhole.chip`.
  * **Title:** "تولید کلید امنیتی پایگاه داده"
  * **Body:** "پین‌کد انتخابی شما به عنوان کلید اصلی برای رمزگذاری دیتابیس گوشی استفاده می‌شود. این رمز را در جایی یادداشت کنید، چرا که به دلیل آفلاین بودن برنامه، بازیابی آن بدون رمز پشتیبان غیرممکن است."
  * **Primary (Logical End / Left):** "پیکربندی و ادامه"
  * **Secondary (Logical Start / Right):** "بازگشت و اصلاح"

### 2. Confirm PIN Dialog (مطبوعیت تکرار پین‌کد)
* **Purpose:** Acts as the confirmation overlay if the secondary sequence entry fails or succeeds.
* **Content:**
  * **Header Icon:** Checked shield circle `bankyar.icon.shield.check`.
  * **Title:** "پین‌کد با موفقیت ثبت شد"
  * **Body:** "دیتابیس شخصی بانک‌یار با الگوریتم رمزگذاری سخت‌افزاری با موفقیت مقداردهی شد."
  * **Primary Action:** "ورود به داشبورد مالی" (Solid, Emerald color style).

### 3. Wrong PIN Dialog (خطای پین‌کد اشتباه)
* **Purpose:** Displays temporary warning flags when an incorrect PIN is registered.
* **Content:**
  * **Header Icon:** Error alert circular badge `bankyar.icon.alert.warning`.
  * **Title:** "رمز ورود نادرست است"
  * **Body:** "پین‌کد وارد شده با رمز ذخیره شده مطابقت ندارد. تلاش‌های ناموفق متوالی منجر به مسدود شدن موقت برنامه می‌گردد."
  * **Primary Action:** "تلاش مجدد" (High-contrast blue color style).

### 4. PIN Locked Dialog (انسداد موقت صفحه‌کلید)
* **Purpose:** Overlay indicating active cooldown timers on brute-force attempts.
* **Content:**
  * **Header Icon:** Hourglass timer `bankyar.icon.hourglass`.
  * **Title:** "برنامه موقتاً قفل شد"
  * **Body:** "به دلیل وارد کردن مکرر رمز اشتباه، دسترسی به بانک‌یار به مدت ۶۰ ثانیه قطع گردید. لطفاً منتظر بمانید."
  * **Action Button:** Fully disabled button displaying: "منتظر بمانید (۵۹ ثانیه)" with real-time numeric decrement.

### 5. Forgot PIN Dialog (بازیابی رمز عبور)
* **Purpose:** Triggered when initiation recovery keys.
* **Content:**
  * **Header Icon:** Safe folder unlock `bankyar.icon.backup.lock`.
  * **Title:** "بازیابی کلید آفلاین با کلمات پشتیبان"
  * **Body:** "برای بازیابی دیتابیس امن، باید کلمات بازیابی ۱۲ گانه‌ای که قبلاً یادداشت کرده‌اید را در کادرهای مربوطه بنویسید. آیا آماده‌اید؟"
  * **Primary Action (Left):** "بله، شروع بازیابی"
  * **Secondary Action (Right):** "انصراف"

### 6. Enable Biometrics Dialog (فعال‌سازی اثر انگشت)
* **Purpose:** Prompts confirmation before binding biometric authentication to Keystore values.
* **Content:**
  * **Header Icon:** Touch scanner profile `bankyar.icon.fingerprint`.
  * **Title:** "تأییدیه احراز هویت زیست‌سنجی"
  * **Body:** "با فعال‌سازی این قابلیت، امضای رمزنگاری اثر انگشت شما در تراشه امن سخت‌افزار ذخیره شده و از این پس می‌توانید برنامه را با اثر انگشت باز کنید."
  * **Primary Action (Left):** "تأیید و فراخوانی سنسور"
  * **Secondary Action (Right):** "انصراف"

### 7. Disable Biometrics Dialog (غیرفعال‌سازی ورود سریع)
* **Purpose:** Confirms safety parameters before destroying the local biometric key wrapper.
* **Content:**
  * **Header Icon:** Closed lock warning `bankyar.icon.lock`.
  * **Title:** "حذف کلید ورود سریع زیست‌سنجی"
  * **Body:** "آیا از غیرفعال‌سازی ورود اثر انگشت اطمینان دارید؟ پس از حذف، ورود به برنامه صرفاً از طریق وارد کردن پین‌کد دستی امکان‌پذیر خواهد بود."
  * **Primary Action (Left):** "بله، حذف شود" (Crimson warning style).
  * **Secondary Action (Right):** "لغو"

### 8. Authentication Failed Dialog (شکست در اسکن اثر انگشت)
* **Purpose:** Displays inline modal parameters if biometric sensor matches fail.
* **Content:**
  * **Header Icon:** Red-alert fingerprint error `bankyar.icon.alert.critical`.
  * **Title:** "تطبیق زیست‌سنجی ناموفق بود"
  * **Body:** "اثر انگشت اسکن شده با الگوی سیستم همخوانی ندارد. لطفاً انگشت خود را تمیز کرده و مجدداً امتحان کنید یا پین‌کد ورود را وارد نمایید."
  * **Primary Action (Left):** "پین‌کد ورود دستی"
  * **Secondary Action (Right):** "تلاش مجدد اثر انگشت"

### 9. Security Warning Dialog (هشدار محیط غیرامن دستگاه)
* **Purpose:** Displayed on cold-start if host device integrity checks fail (rooted device, unsecure bootloader).
* **Content:**
  * **Header Icon:** Warning hazard octagon `bankyar.icon.alert.critical`.
  * **Title:** "محیط اجرای آسیب‌پذیر و ناامن"
  * **Body:** "هشدار! گوشی شما روت شده یا قفل سیستم‌عامل آن باز است. اجرای بانک‌یار در این حالت به دلیل امکان نشت اطلاعات توسط سایر برنامه‌های مخرب روت، توصیه نمی‌شود."
  * **Primary Action (Left):** "متوجه شدم و مایل به ادامه هستم" (Amber warning style).
  * **Secondary Action (Right):** "خروج ایمن از برنامه"

---

## Section 6: Authentication State Matrix

The following state matrix maps the active relationship between configuration parameters, cryptographic availability, and UI presentation flows.

| Current Config State | Operating System integrity Status | User Trigger Context | Expected UI Render Path | Cryptographic Vault Status |
| :--- | :--- | :--- | :--- | :--- |
| **No Auth Configured** | Normal Device Secure | Application Cold-Start | Displays onboarding Screen A.1 (Welcome) and routes to Screen B.1 (Create PIN). | Keyring empty. DB in uninitialized plaintext cache. |
| **PIN Enabled Only** | Normal Device Secure | Application Cold-Start | Displays Screen D.1 (PIN Unlock Keypad) directly. Keypad fully interactive. | Cryptographic Master Key bound to Keystore alias. |
| **Biometric Enabled** | Normal Device Secure | Application Cold-Start | Displays Screen D.1 with immediate automated system BiometricPrompt overlay. | Cryptographic wrapper bound to biometric verification. |
| **PIN + Biometric Enabled** | Normal Device Secure | App Resume from Bg | Displays Screen D.1 with immediate biometric prompt; user can cancel to use fallback PIN. | Dual key binding configuration active. |
| **PIN + Biometric Enabled** | Normal Device Secure | 5 failed biometrics | Dismisses biometric scan immediately, falls back to Screen D.1 PIN keypad. | Biometric key locked by OS; fallback to hardware master PIN. |
| **Authentication Failed** | Normal Device Secure | Wrong PIN Input (<3) | Shakes PIN entry dots, displays inline error message, increments failed counter. | Master Key wrapper locked in memory. |
| **Authentication Locked** | Normal Device Secure | Wrong PIN Input (>=3) | Keys locked; displays Screen F.2 countdown timer card. Keypad disabled. | Memory keys purged; lockout timer active. |
| **Session Expired** | Normal Device Secure | 5 Min App Inactivity | Instantly displays Screen D.1 overlay, wiping active RAM caches. | DB session closed, cryptographic volume keys purged from RAM. |
| **Device Security Unsupported** | OS Rooted / Attestation Fail | Application Cold-Start | Triggers Screen B.3 / Security Dialog 9 warning prompt before continuing. | Enforces fallback software-derived encryption wrappers. |

---

## Section 7: Accessibility Review (بررسی سهولت دسترسی - WCAG 2.2 AA)

To ensure that the secure authentication layers of BankYar do not introduce exclusionary barriers for users with diverse visual, motor, or cognitive abilities, we enforce strict compliance with **WCAG 2.2 AA standards**.

### 1. Large Text & Font Scale Robustness
* **Scaling Ceiling:** All typography scales gracefully up to **200% system font magnification** without clipping content, overlapping lines, or hiding keypad cells.
* **Auto-Wrapping Grid:** Keypad button labels automatically scale down slightly or expand cell paddings to prevent overflow, utilizing dynamic height wrappers instead of absolute heights.

### 2. Screen Readers (TalkBack / VoiceOver)
* **Spoken Password Masking:** Numeric key presses in screen reader modes do NOT announce the actual digit (e.g. "5"). Instead, they announce the action (e.g. "کلید وارد شد") or read out masked identifiers (e.g. "رمز وارد شده، دایره دوم").
* **Grouping Element Focus:** PIN entry dots are grouped into a single focus block with the semantic value: "رمز عبور ورود، ۳ رقم از ۴ رقم وارد شده است."
* **Announce Screen Transitions:** On screen load, screen readers immediately read the screen's secondary helper message: "صفحه قفل‌گشایی بانک‌یار. لطفاً رمز خود را وارد کنید."

### 3. Motion Cancellation (Reduce Motion)
* **Duration Override:** If the system-wide "Reduce Motion" setting is active, all dynamic transitions (such as lock pad morphs, shake animations, and sliding modals) are instantly disabled (`bankyar.accessibility.motion.toggle = false`), converting animations to zero-duration opacity swaps.

### 4. Color-Blind Safe Indicators
* **Multi-Modal Verification:** Colors are never used as the sole conveyor of state.
  * Strength indicators combine color segments (Crimson/Amber/Emerald) with explicit descriptive label tags ("ضعیف", "متوسط", "قوی") and icon changes (warning triangle vs. check shield).
  * Wrong inputs highlight borders in red while simultaneously playing a short dual-pulse vibration and showing text warnings.

### 5. Keyboard & Hardware Switch Navigation
* **Natural Tab Index:** External Bluetooth keyboards or hardware switch devices navigate the custom keypad grid in intuitive row-by-row sequence (1 -> 2 -> 3 -> ... -> 9 -> Biometric -> 0 -> Backspace).
* **Focus Outline Overlay:** Focused elements render a clear, high-contrast double-outline ring with 100% opacity (`bankyar.opacity.opaque`), keeping selected buttons highly visible.

### 6. High Contrast Ratios
* **Minimum Contrast Met:** All text and critical status icons maintain a contrast ratio of at least **4.5:1** (for body text) and **3:1** (for large titles) against their backgrounds under both default Light and Dark themes.

---

## Section 8: RTL Review (انطباق با راست‌به‌چپ فارسی)

Since Persian is n-directional (RTL), spatial coordinates and user flows must be designed RTL-first to ensure native, low-friction readability.

### 1. Mirrored Keypad Grid
* **Keypad Layout Symmetry:** The numerical keypad is centered and symmetrical. Action keys reside in the logical bottom corners:
  * **Logical Start (Right Corner):** Quick Biometrics Trigger `bankyar.icon.fingerprint` (for rapid scanning activation).
  * **Logical End (Left Corner):** Backspace Delete `bankyar.icon.backspace`.
* **Flow Direction:** Digit entry indicators populate from right to left as digits are tapped.

### 2. Directional Icons & Chevrons
* **Mirroring Exclusions:** Padlock shapes `bankyar.icon.lock` and fingerprint lines are symmetrical and must not be mirrored.
* **Mirroring Mandates:** Back navigations and chevron caret indicators are automatically mirrored:
  * Forward chevron carets point to the logical-end (left) `bankyar.icon.chevron.left`.
  * Backward chevron carets point to the logical-start (right) `bankyar.icon.chevron.right`.

### 3. Absolute Logical Spacing
* **No Physical Anchors:** Absolutely no physical layouts (such as `paddingLeft` or `marginRight`) are permitted. All specifications and components utilize logical styling blocks (`paddingStart`, `paddingEnd`, `inline-start`).

### 4. Mixed Text String Handling
* **Persian & English Mix:** Persian helper instructions wrap right-aligned. In cases where LTR values exist (e.g. "AES-256-CBC"), the LTR string resides in an isolated logical container to prevent bidirectional punctuation jumping.

---

## Section 9: Security UX Checklist (چک‌لیست امنیت حریم خصوصی)

Developers implementing the BankYar authentication experience must audit code blocks against these non-negotiable security requirements:

- [ ] **Data Obfuscation Active:** Enforce system background flags (`FLAG_SECURE` on Android) to block screenshots and blur application viewports inside recent-task switchers.
- [ ] **No Text Logging:** Confirm that absolute plain-text PIN entries or derived key hashes are never captured inside local diagnostics log files.
- [ ] **Keystore Key Binding:** Verify that SQLCipher master key wrappers are securely derived inside hardware-protected storage (TEE/StrongBox) rather than shared application preferences.
- [ ] **Memory Key Purging:** Ensure volatile password strings and decrypted database keys are cleared from RAM caches within 5 minutes of inactivity or upon session exit.
- [ ] **Safe Destructive Wipes:** Verify that raw data purges on lockout require holding down confirmation actions for 3 seconds to prevent accidental triggered wipes.
- [ ] **Haptic Shoulder-Surfing Block:** Enable subtle, discrete vibration pulses on tap to give physical confirmation without sound cues or visual button presses that could be spotted by bystanders.

---

## Section 10: UI Validation Checklist (چک‌لیست ارزیابی پیکربندی)

Ensure absolute visual harmony by confirming compliance with these design language guidelines:

- [ ] **100% Token Adherence:** Every margin, gap, text color, corner radius, and anim curve must reference a dot-separated design token (`bankyar.semantic.color.background`). Zero hardcoded hex colors or pixel dimensions.
- [ ] **Dynamic Contrast Compliance:** Confirm contrast ratios meet the WCAG 4.5:1 AA target for every interactive button and background surface in both Light and Dark themes.
- [ ] **Smooth Transition curves:** Validate that modal popups use standard decelerate curves with durations of exactly `bankyar.motion.duration.medium`. No linear movements on physical objects.
- [ ] **Zero Platform Dependencies:** Confirm that no native code implementations, direct biometric imports, or encryption libraries are hardcoded into visual layout modules.
- [ ] **Clean Layout Wrapping:** Verify that cards and keypads wrap gracefully without screen-edge overflows on compact displays (e.g., 320-unit compact screen widths).

---
**End of Specification Document**
