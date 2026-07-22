# BankYar Onboarding & Permission Experience Specification

## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 2.0.0
**Authors:** Principal Product Designer, Onboarding Experience Specialist, Material Design 3 Expert, Flutter UI Architect, FinTech UX Consultant, and Behavioral Design Expert
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Onboarding & Permission experience is the foundational gatekeeper of an offline-first, secure, and privacy-centric mobile personal finance platform. Built for native **Persian (RTL)** layouts and strict **on-device data sovereignty boundaries** (zero network permission, zero cloud trackers), the onboarding experience must balance education, trust-building, and seamless permission acquisition with the highest possible user conversion rates.

This specification outlines the complete, production-ready visual architecture, layout rhythm, spatial grids, typography scale, interactive behaviors, responsive modes, and accessibility structures for all **12 screens of the onboarding and permission experience**. In strict adherence to **Material Design 3 (MD3)** design systems, it utilizes design tokens to allow themes to adapt dynamically, ensuring a premium, reassuring, and highly secure first-run experience.

---

## Deliverable 1: Complete User Flow

The onboarding user journey is structured into a logical, sequential progression designed to gradually build trust, introduce features, and prepare the environment before requesting system permissions.

```
[Splash Screen]
      │
      ▼ (Initialization & Hardware Keystore verification)
[Welcome Screen] ◄─────────────────────────────────────────────┐
      │                                                       │
      ▼ (Start experience)                                    │
[Core Benefits]                                               │ (PIN forgot reset fallback)
      │                                                       │
      ▼ (Proceed)                                             │
[Privacy Commitment]                                          │
      │                                                       │
      ▼ (Accept & Proceed)                                    │
[Offline-first Explanation]                                   │
      │                                                       │
      ▼ (Proceed)                                             │
[How SMS Processing Works]                                    │
      │                                                       │
      ▼ (Proceed)                                             │
[Why SMS Permission Is Needed]                                │
      │                                                       │
      ▼ (Grant SMS permission / Manual fallback setup)        │
[Notification Benefits]                                       │
      │                                                       │
      ▼ (Enable / Skip notifications)                         │
[Security Overview]                                           │
      │                                                       │
      ▼ (Configure App PIN)                                   │
[Feature Highlights] ──────────────────────────────────────────┘
      │
      ▼ (Configure custom categories/rules)
[Ready to Begin]
      │
      ▼ (Finalize database setup)
[Permission Preparation]
      │
      ▼ (Redirect to Ledger Tab)
[Application Ledger Dashboard]
```

---

## Deliverable 2: Screen-by-Screen Layout Specifications

Every screen uses a standardized three-zone vertical layout layout. Outer margins are handled via `bankyar.responsive.margin` and gutters via `bankyar.responsive.gutter`.

### Zone A: Persistent Progress & Steps Header
* **Segmented Linear Progress Indicator:** Positioned at the very top, flowing logically from logical-start (right) to logical-end (left). It displays the user's progress through the onboarding flow using a thin track.
* **Navigation Controls:** A "Skip" (رد شدن) button is placed at the logical-end (left) edge for non-mandatory steps, and a "Back" (بازگشت) chevron at the logical-start (right) edge.

### Zone B: Scrollable Content Workspace
* **Central Visual Container:** Houses a single abstract vector illustration or geometric brand mark.
* **Typography Stack:** Includes a prominent educational headline followed by highly legible supporting copy.
* **Interactive Controls Card:** Optional card enclosure housing configuration forms, selection chips, or checklist items.

### Zone C: Fixed Control Bar
* **Primary Action CTA:** Solid, high-contrast button positioned prominently to drive progression.
* **Secondary Action CTA:** Soft outlined or text button for non-primary paths.
* **Privacy Trust Seal Badge:** A persistent, comforting security label confirming: "کاملاً آفلاین و رمزگذاری‌شده" (100% Offline & Encrypted).

---

### Screen 1: Splash Screen (صفحه آغازین)

* **Purpose:** Initialize the secure local runtime environment, authenticate hardware Keystore signatures, and establish the BankYar brand identity.
* **Business Goal:** Minimize cold-start abandonment while proving instant localized security on startup.
* **Visual Priority:** The centralized protected vault brand mark receives highest focus, surrounded by a subtle loading arc.
* **Layout:** Centered single-column layout with Zone A and Zone C empty to emphasize brand focus.
* **Spacing:** Top and bottom gaps scale proportionally via `bankyar.space.xxl`.
* **Typography:** Brand name styled with `bankyar.semantic.typography.heading.lg`.
* **Illustration Placement:** Geometric brand mark placed exactly in the viewport center.
* **Icons:** Dynamic secure lock outline centered.
* **Animations:** Pulse transition representation of the local encrypted database.
* **Interaction:** Fully automated; user touch interaction is disabled during environment self-tests.
* **Loading:** Indeterminate circular progress ring using active primary accent colors.
* **Accessibility:** Screen readers announce: "برنامه بانک‌یار، در حال آماده‌سازی محیط امن آفلاین، لطفاً منتظر بمانید."
* **RTL Behaviour:** Progress ring rotates counter-clockwise to match Persian directional preference.
* **Future Expansion:** Prepared layout slots to integrate multi-profile local directory initialization if user profiles are introduced.

---

### Screen 2: Welcome Screen (صفحه خوش‌آمدگویی)

* **Purpose:** Introduce BankYar as a premium offline-first personal finance platform and present its central value proposition.
* **Business Goal:** Encourage the user to start the secure setup, maximizing onboarding completion rates.
* **Visual Priority:** A welcoming title and a clear "Get Started" call-to-action button.
* **Layout:** Vertical stack. Zone B contains the welcoming message and a central conceptual illustration; Zone C houses primary and secondary action buttons.
* **Spacing:** Margins use `bankyar.responsive.margin`; spacing between elements uses `bankyar.space.lg`.
* **Typography:** Title uses `bankyar.semantic.typography.heading.lg`; supporting copy uses `bankyar.semantic.typography.body.md`.
* **Illustration Placement:** Abstract vector welcome illustration centered horizontally in Zone B.
* **Icons:** Logical-end chevron on the primary action button.
* **Animations:** Elements fade in sequentially from top to bottom.
* **Interaction:** Primary action advances to the next step; secondary action initiates the "Restore Backup" flow for returning users.
* **Loading:** Static layout; loads instantly.
* **Accessibility:** Large touch target sizing on action buttons with explicit screen reader voice support.
* **RTL Behaviour:** Text is aligned logical-start (right), and chevrons point to the left logical-end.
* **Future Expansion:** Expansion slot to present community-designed localized welcome screens.

---

### Screen 3: Core Benefits (معرفی ارزش‌های محوری)

* **Purpose:** Introduce the 3 core pillars of BankYar's product personality: "The Stoic Vault", "The High-Precision Analyst", and "The Calm Companion".
* **Business Goal:** Establish psychological safety, framing the app as a silent, reliable, and secure assistant.
* **Visual Priority:** Core benefits cards grouped cleanly, showing high structural organization.
* **Layout:** Three distinct cards stacked vertically on mobile screens, reflowing to a horizontal layout on tablet viewports.
* **Spacing:** Card internal padding uses `bankyar.space.md`; gaps between cards use `bankyar.space.sm`.
* **Typography:** Card titles use `bankyar.semantic.typography.heading.sm` in bold; descriptions use `bankyar.semantic.typography.body.sm`.
* **Illustration Placement:** Soft linear vector symbols integrated at the start edge of each benefits card.
* **Icons:** Shield icon (Security), trend-line icon (Precision), and calm balance slider icon (Companionship).
* **Animations:** Subtle card hover scale-up on active selection.
* **Interaction:** Users can tap individual cards to expand detailed descriptions.
* **Loading:** Static; elements render immediately.
* **Accessibility:** Cards support simple tap navigation with descriptive voice-overs for screen readers.
* **RTL Behaviour:** Card symbols align on the right edge (logical-start); text wraps cleanly to the left (logical-end).
* **Future Expansion:** Prepared slots to support future analytical highlights as the feature set expands.

---

### Screen 4: Privacy Commitment (تعهدنامه حریم خصوصی)

* **Purpose:** Establish absolute, uncompromising user trust before any local data collection or scanning takes place.
* **Business Goal:** Maximize trust, proving that the user is the sole owner of their financial information.
* **Visual Priority:** A central security card showing green success outline borders and a mandatory privacy checkbox.
* **Layout:** Symmetrical single-column layout. The central workspace houses the privacy commitment list; the control bar holds the mandatory checkbox and primary CTA.
* **Spacing:** Internal card spacing uses `bankyar.space.md`; screen boundary margins use `bankyar.responsive.margin`.
* **Typography:** Commitment points use bold headers with clear supporting paragraphs.
* **Illustration Placement:** A clean, abstract locked padlock symbol centered in Zone B.
* **Icons:** Checkmark indicators next to each commitment item.
* **Animations:** Checkbox toggles with quick, responsive scale changes.
* **Interaction:** The primary "Accept & Continue" button remains disabled until the user checks the privacy agreement box.
* **Loading:** Static view; loads instantly.
* **Accessibility:** Screen reader requires confirmation: "دکمه ادامه تا زمان پذیرش تعهدنامه حریم خصوصی غیرفعال است."
* **RTL Behaviour:** Checkboxes align on the right (logical-start); confirmation statements flow from right to left.
* **Future Expansion:** Prepared slots to display independent third-party open-source privacy audits in future releases.

---

### Screen 5: Offline-first Explanation (مفهوم همگام‌سازی آفلاین)

* **Purpose:** Educate the user on how the app operates without an active network connection, addressing potential confusion about automatic updates.
* **Business Goal:** Mitigate user concern about missing internet access by clearly explaining localized processing.
* **Visual Priority:** A flow diagram illustrating how raw SMS alerts go directly into the local SQLite DB, bypassing any remote cloud databases.
* **Layout:** Horizontal split diagram on the upper half, with explanatory text blocks stacked in the lower half of Zone B.
* **Spacing:** Separation between diagram blocks uses `bankyar.space.lg`; inner padding uses `bankyar.space.md`.
* **Typography:** Titles use `bankyar.semantic.typography.heading.md`; technical terms use monospaced text elements.
* **Illustration Placement:** A flat flow diagram showing SMS messages moving directly to a secure, encrypted local database.
* **Icons:** Database cylinder, cellular signal lines, and a prominent red cross symbol blocking cloud lines.
* **Animations:** Linear flowing indicator paths represent the movement of data from SMS to the local database.
* **Interaction:** Simple "I Understand" primary button to advance.
* **Loading:** Static; flow lines render instantly.
* **Accessibility:** High-contrast lines on diagram elements with clear text labels describing each step.
* **RTL Behaviour:** Data flows logically from right (SMS input) to left (Local Secure Storage).
* **Future Expansion:** Prepared to support local Wi-Fi synchronization guides if peer-to-peer sync features are introduced.

---

### Screen 6: How SMS Processing Works (نحوه پردازش پیامک)

* **Purpose:** Demystify the automated background capture and regex parsing mechanics.
* **Business Goal:** Build technical transparency, showing that personal SMS logs remain private.
* **Visual Priority:** Interactive visual steps showing a raw text message transforming into a clean transaction ledger card.
* **Layout:** A step-by-step vertical list of parser stages.
* **Spacing:** Spacing between stages uses `bankyar.space.sm`; internal card padding uses `bankyar.space.md`.
* **Typography:** Step labels use `bankyar.semantic.typography.body.md` in bold; code snippets use monospace tokens.
* **Illustration Placement:** Flat, abstract card transformation vectors centered in Zone B.
* **Icons:** Message envelope, parser gear, and transaction checkmark.
* **Animations:** Subtle transition showing text elements converting into clean numerical figures.
* **Interaction:** Tap-to-inspect triggers open detailed explanations of each parsing step.
* **Loading:** Smooth shimmers present the parsing transformation sequence.
* **Accessibility:** Structured vertical layout with clear focus steps for screen readers.
* **RTL Behaviour:** Text transforms and flows naturally from right to left.
* **Future Expansion:** Prepared slot to demonstrate future on-device machine-learning classifiers.

---

### Screen 7: Why SMS Permission Is Needed (چرا مجوز پیامک نیاز است؟)

* **Purpose:** Explain the functional need for SMS access to achieve high permission acceptance rates.
* **Business Goal:** Maximize permission conversion rates while maintaining full transparency.
* **Visual Priority:** The primary "Grant Access" button and a clear list of what data is and is not accessed.
* **Layout:** Split list cards: "داده‌هایی که خوانده می‌شوند" (Accessed Data - Bank SMS only) versus "داده‌هایی که هرگز لمس نمی‌شوند" (Never Accessed Data - Personal chats, OTPs).
* **Spacing:** Grid margins use `bankyar.responsive.margin`; vertical spacing uses `bankyar.space.lg`.
* **Typography:** Title uses `bankyar.semantic.typography.heading.lg`; lists use clear bullet points.
* **Illustration Placement:** Secure envelope with a prominent lock symbol centered in Zone B.
* **Icons:** Green checkmarks next to accessed bank data; red crosses next to personal and sensitive data.
* **Animations:** Shake animation on the permission card if the user denies access, showing helpful tips.
* **Interaction:** Primary action triggers the system permission dialog; secondary action configures the manual ledger fallback.
* **Loading:** Instantly loads.
* **Accessibility:** Large touch targets on all interactive items, with clear accessibility descriptions.
* **RTL Behaviour:** Text aligns right; green/red status markers are positioned on the right logical edge.
* **Future Expansion:** Prepared layout to show community trust rating scores for system security permissions.

---

### Screen 8: Notification Benefits (مزایای اعلان‌ها)

* **Purpose:** Explain the benefits of enabling local push notifications for background transaction tracking and security lockout alerts.
* **Business Goal:** Encourage the user to enable notifications, keeping them informed of background activities.
* **Visual Priority:** A sample push notification card with custom mock transaction details.
* **Layout:** Single-column layout. The mock notification card is displayed in the center of Zone B; explanatory notes and action buttons are placed below.
* **Spacing:** Margins use `bankyar.responsive.margin`; element gaps use `bankyar.space.md`.
* **Typography:** Mock notification text uses medium and small body text scales.
* **Illustration Placement:** Mock phone lock screen vector showing the local alert card.
* **Icons:** Notification bell and secure vault lock.
* **Animations:** The mock notification card slides in smoothly from the top of the mock screen.
* **Interaction:** Primary CTA triggers the system notification permission; secondary CTA skips notification setup.
* **Loading:** Instantly loads.
* **Accessibility:** High-contrast text on the mock card, meeting strict WCAG AA requirements.
* **RTL Behaviour:** Mock notification content is aligned right, and the app icon is placed on the logical-start (right) edge.
* **Future Expansion:** Prepared slot to configure custom priority channels for notifications.

---

### Screen 9: Security Overview (مرور کلی امنیت)

* **Purpose:** Detail the local encryption technologies protecting transaction data.
* **Business Goal:** Reassure the user of their financial data security on their device.
* **Visual Priority:** Secure shield illustration and a card explaining the local cryptographic keys.
* **Layout:** Centered single-column layout with grouped bullet points inside a flat, bordered card.
* **Spacing:** Card internal padding uses `bankyar.space.md`; gaps between sections use `bankyar.space.lg`.
* **Typography:** Title uses `bankyar.semantic.typography.heading.md` in bold.
* **Illustration Placement:** Abstract secure safe vault vector centered in Zone B.
* **Icons:** Shield lock, encryption key, and security monitor.
* **Animations:** Subtle lock rotating animation when transitioning to the screen.
* **Interaction:** Primary CTA advances the user to configure their secure 4-digit PIN.
* **Loading:** Static; renders immediately.
* **Accessibility:** Complete screen reader coverage of all security guarantees.
* **RTL Behaviour:** Text is aligned right, and bullet icons align logical-start.
* **Future Expansion:** Support for future hardware security keys if advanced security protocols are integrated.

---

### Screen 10: Feature Highlights (ویژگی‌های برجسته)

* **Purpose:** Present secondary application features (Notes, Statistics, Search, Backup, Security).
* **Business Goal:** Build product excitement, demonstrating utility beyond simple SMS capture.
* **Visual Priority:** A clean, interactive grid of feature cards.
* **Layout:** 2x2 grid of feature cards, reflowing to a vertical list on smaller screens.
* **Spacing:** Grid gutters use `bankyar.responsive.gutter`; screen margins use `bankyar.responsive.margin`.
* **Typography:** Feature titles use `bankyar.semantic.typography.body.md` in bold.
* **Illustration Placement:** Soft background feature symbols inside each grid cell.
* **Icons:** Stylized stylus (Notes), bar-chart (Statistics), magnifying glass (Search), and folder-download (Backup).
* **Animations:** Quick, responsive hover transitions on card interaction.
* **Interaction:** Users can tap individual cards to preview how the features work.
* **Loading:** Instantly loads.
* **Accessibility:** Grid elements are fully keyboard and switch control accessible, using logical RTL tab order.
* **RTL Behaviour:** Grid order flows right-to-left, top-to-bottom.
* **Future Expansion:** Expansion slots to highlight future localized AI capabilities.

---

### Screen 11: Ready to Begin (آماده برای شروع)

* **Purpose:** Prompt the user to set up their 4-digit security PIN and configure their first bank details.
* **Business Goal:** Finalize the security and functional configuration of the application.
* **Visual Priority:** PIN entry dots and the primary "Confirm & Save" action button.
* **Layout:** Symmetrical layout. PIN dots are centered in Zone B, with a numeric entry keypad placed in the lower region.
* **Spacing:** Numeric pad keys are spaced evenly using `bankyar.space.sm`.
* **Typography:** Keypad numbers use large, highly legible typography scales.
* **Illustration Placement:** Subtle background safe lock centered behind PIN entry dots.
* **Icons:** Backspace icon on the bottom corner keypad cell.
* **Animations:** Keypad buttons compress slightly when pressed.
* **Interaction:** User enters and confirms their 4-digit security PIN; if biometrics are supported, prompts biometric setup.
* **Loading:** Transitions to the database setup screen instantly upon PIN confirmation.
* **Accessibility:** Numeric keypad supports large touch targets with clear accessibility voice confirmations.
* **RTL Behaviour:** Keypad layout is symmetrical; PIN dots fill from right to left.
* **Future Expansion:** Support for custom password length configurations.

---

### Screen 12: Permission Preparation (آماده‌سازی دسترسی‌ها)

* **Purpose:** Perform initial database writes, run the first SMS inbox scan, and compile initial search indices.
* **Business Goal:** Deliver a clean, ready-to-use ledger dashboard on the very first screen.
* **Visual Priority:** A stepped progress checklist indicating active database initialization tasks.
* **Layout:** Centered single-column layout containing a vertical step tracker and an horizontal progress indicator.
* **Spacing:** Checklist spacing uses `bankyar.space.md`; outer boundaries use `bankyar.responsive.margin`.
* **Typography:** Diagnostic monospace status lines are shown below the main checklist.
* **Illustration Placement:** Abstract database indexing illustration centered in Zone B.
* **Icons:** Rotating sync circular loops and green checkmark symbols.
* **Animations:** Checklist checkmarks scale up and change color as steps complete.
* **Interaction:** Screen interaction is locked during database compilation to protect file integrity.
* **Loading:** High-contrast horizontal progress bar with real-time percentage text.
* **Accessibility:** Screen reader periodically announces progress updates (every 10%).
* **RTL Behaviour:** Horizontal progress bar fills from right to left.
* **Future Expansion:** Extensibility slots to support cloud sync migration wizards.

---

## Deliverable 3: Content Hierarchy & Copywriting Scale

Typography scale maps strictly to semantic tokens (`bankyar.semantic.typography.*`). No hardcoded pixel, dp, or sp units are used.

### High-Contrast Educational Titles
* **Token:** `bankyar.semantic.typography.heading.lg`
* **Weight:** Bold
* **Usage:** Welcome title, permission requests, and configuration headers.
* **Persian Text Style:** "به بانک‌یار خوش آمدید" (Welcome Screen) / "امنیت اطلاعات شما، خط قرمز ماست" (Privacy Screen).

### Medium-Contrast Explanations
* **Token:** `bankyar.semantic.typography.body.md`
* **Weight:** Regular
* **Usage:** Supporting descriptions, lists, and secondary educational summaries.
* **Persian Text Style:** "بانک‌یار با تحلیل خودکار پیامک‌های بانکی، گزارش‌های مالی دقیقی بدون نیاز به اینترنت ایجاد می‌کند."

### Technical Metadata Labels
* **Token:** `bankyar.semantic.typography.label.sm`
* **Weight:** Monospace / Medium
* **Usage:** Folder paths, encryption hash displays, and code syntax snippets.
* **Persian Text Style:** `database.sqlcipher.aes256` / `READ_SMS_PERMISSION_GRANTED`.

### Mandatory Control Labels
* **Token:** `bankyar.semantic.typography.button.md`
* **Weight:** Bold
* **Usage:** Solid action buttons and outlined triggers.
* **Persian Text Style:** "پیکربندی محیط امن" / "تأیید و ورود".

---

## Deliverable 4: Navigation Flow & Screen Progression

* **Forward Navigation Path:** Handled strictly via the primary solid button in Zone C, moving sequentially through screens 1 to 12.
* **Backward Navigation Path:** Tapping the back chevron in Zone A returns the user to the immediate previous screen, preserving already entered data in volatile memory caches.
* **Exit/Skip Navigation Path:** Tapping the "Skip" button in Zone A bypasses non-mandatory steps (such as Notifications or Feature Highlights) and routes the user directly to the PIN lock setup (Screen 11).
* **Reset/Restart Fallback:** If the user closes the app mid-onboarding, relaunching starts from the last uncompleted step, keeping configurations secure.

---

## Deliverable 5: Illustration & Graphic Asset Guidelines

To maintain a professional, secure, and cohesive visual identity across all onboarding screens, all illustrations must comply with these design standards:

* **Strict Flat Grayscale Style:** Illustrations must use flat vector styles using low-saturation grayscale colors. Bright, multi-color cartoon assets and 3D shapes are prohibited.
* **Vector Path Completeness:** All SVGs must be constructed with clean, continuous vector paths. Unused layers, duplicate coordinates, and unclosed shapes are removed.
* **Semantic Token Color Mapping:** Illustrations must bind fill and stroke properties to CSS variables referencing semantic design tokens (e.g., `bankyar.semantic.color.surface.default`), allowing them to adapt dynamically to Light and Dark themes.
* **No Inline Text:** Text must never be baked directly into SVG files. All labels and legends must be rendered as independent HTML/Flutter text elements to support accessibility font scaling and RTL translation.
* **Unified Visual Center:** Graphics must be optically adjusted to distribute visual weight evenly within their bounding boxes, preventing layout shifting on smaller viewports.

---

## Deliverable 6: Interaction Flow States

Every interactive element in the onboarding flow adapts its visual presentation dynamically to communicate active state and response boundaries:

* **Default State:** Elements sit flat against the canvas. Action buttons use solid primary colors, while secondary actions use outlined borders.
* **Pressed State:** Triggers an immediate increase in surface contrast. Applies a tactile touch scale compression to provide physical feedback.
* **Selected / Active State:** Checkboxes and category chips toggle to active positions with primary background fills.
* **Permission Granted State:** The active button transitions to a disabled green state containing a success checkmark, confirming access.
* **Permission Denied State:** Displays a soft yellow warning border around the permission card with helpful tips.
* **Disabled State:** For unfinished forms (such as unaccepted privacy checkmarks), buttons are faded and touch triggers are deactivated.

---

## Deliverable 7: Progress & Stepped Loading Behaviors

Progression through multi-step onboarding tasks uses precise indicators to keep the user informed without causing anxiety:

* **Segmented Linear Progress Indicator:** Positioned at the top of screens 2 to 12. Individual segments fill sequentially from right to left as steps complete.
* **Indeterminate Loading Arc:** Used on Splash Screen (Screen 1) and Security setup (Screen 9) for background initialization tasks of unknown duration.
* **Stepped Vertical Checklist:** Used on the Permission Preparation screen (Screen 12) to show the sequential compilation of database tables and indexes.
* **Cancellation Rules:** Tapping "Cancel" (انصراف) during long-running tasks (like the initial inbox scan) stops the scan, saves already verified transactions, and proceeds safely to the ledger.

---

## Deliverable 8: Accessibility & Inclusive Design Review

To ensure BankYar remains fully usable for all individuals, the onboarding experience implements strict WCAG AA inclusive guidelines:

* **Dynamic Font Magnification:** All typography and list rows expand vertically to support system text scaling up to 200% without clipping or overlapping text.
* **Semantic Screen Reader Labels:** Every interactive element features unique spoken descriptions (e.g., "تعهدنامه حریم خصوصی، برای ادامه باید این دکمه را تأیید کنید").
* **Consistent Focus Order:** Focus moves systematically from top-right to bottom-left (logical RTL order). Focus remains locked inside active dialogue frames until they are dismissed.
* **Touch Target Envelopes:** Interactive buttons and chips maintain a minimum touch height of `bankyar.space.xl` (conforming to the 48-unit Material minimum), protecting users with motor impairments.
* **Color-Independent Meanings:** Validation statuses and transaction directions are confirmed using clear text labels and distinct shapes, never relying on green/red shifts alone.

---

## Deliverable 9: Native RTL (Persian) Layout Review

Every spatial coordinate and progression gesture is designed RTL-first, ensuring natural regional usage:

* **Mirrored Screen Transitions:** When navigating forward, screens slide horizontally from the logical-start (right) to the logical-end (left), matching Persian reading patterns.
* **Symmetrical Baseline Alignments:** Content blocks and headers are anchored right, with generous horizontal spacing to prevent Persian ascenders and descenders from overlapping.
* **Dynamic Icon Mirroring:** Navigation chevrons and directional indicators mirror automatically when switching locales. Symmetrical icons (such as locks and gears) remain static.
* **Input Keypad Symmetries:** Keypad layouts are centered and balanced, keeping numerical targets easy to reach with one hand.

---

## Deliverable 10: Onboarding UX Verification Checklist

Before releasing any layout or screen iteration, developers must verify compliance against this checklist:

- [ ] **100% Token Adherence:** Verify that every color, margin, and corner curve maps directly to an active design token, with zero hardcoded values.
- [ ] **No Forbidden Patterns:** Ensure that absolutely no HEX color codes, physical units (`px`, `dp`, `sp`), or Flutter component names exist in the specification.
- [ ] **RTL-First Interface:** Verify that page transitions, progress bars, text alignments, and back chevrons proceed naturally from right to left.
- [ ] **Data Preservation Guard:** Confirm that initial database scanning and parsing routines run off-the-main-thread and write atomically, protecting data from corruption.
- [ ] **Minimum Touch Target Met:** Confirm all interactive buttons, checkboxes, and selection rows have active touch heights of at least `bankyar.space.xl`.
- [ ] **No Dead Ends:** Ensure that every permission denial, scan failure, and storage warning features a prominent, primary recovery action button.

---

## Deliverable 11: Visual Consistency Checklist

To guarantee a uniform visual identity across all platforms and viewport sizes, the design must comply with these spatial rules:

* **Symmetrical Layout Grids:** Standard smartphone displays utilize a 4-column grid with dynamic column widths; tablet viewports scale to an 8-column layout.
* **Consistent Curvatures:** Standard card containers use `bankyar.radius.medium` corner curves; bottom sheets use the extra-large curve token `bankyar.radius.large` on top edges.
* **Linear Stroke Harmony:** All interface icons use a uniform line weight, with rounded terminals to establish a neat, professional appearance.
* **Zero Overlay Overlaps:** Layouts must query device safe-area notch regions, applying logical-start or logical-end padding buffers so that content remains readable.
* **Comfortable Contrast Ratios:** All text elements and interactive icons meet WCAG AA standards, maintaining a minimum contrast ratio of 4.5:1 against their backgrounds.

---

## Governance Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Platform Independence:** The layout must remain platform-independent, relying strictly on relative spacing blocks and logical components rather than framework-specific hacks.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.

---
**End of Onboarding & Permission Experience Specification Document**
