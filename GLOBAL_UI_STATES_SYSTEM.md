# BankYar Global UI States System Specification

**Project Name:** BankYar
**System Version:** 1.0.0
**Design Language:** Material Design 3
**Target Locale:** Persian (RTL)
**Status:** Baseline Specification (Production-Ready)

---

## Executive Summary & Core Architectural Tenets

This document defines the single, unified, and absolute source of truth for every shared user interface state across the BankYar application. Because BankYar is designed to operate as an offline-first, privacy-by-design financial personal ledger with zero network access, the resilience of its UI states is critical.

Every view, dialogue, and screen in the application must reuse the patterns defined here. No screen or module may implement custom loading, empty, success, warning, or error designs.

### Core Architectural Rules:
1. **Zero Raw Values:** Hardcoded hex colors, physical measurements, physical time durations, or raw physics curves are strictly prohibited. All styles must reference semantic tokens in `DESIGN_TOKEN_ARCHITECTURE.md`.
2. **Platform Agnostic Specification:** The visual, spatial, and interaction designs are documented independently of the target platform. No Flutter code or framework elements may appear in this specification.
3. **No Dead Ends:** Every state—particularly empty, error, warning, and offline configurations—must provide a clear, logical recovery path or next step.
4. **Symmetrical RTL Mirroring:** Direct physical directions (left/right) are prohibited. Spacing, layouts, and gestures must be designed logically using logical alignments (start, end) to support natural RTL flow.
5. **Accessible Design by Default:** Accessibility is not an overlay; it is baked directly into the state system through text scaling, screen reader annotations, color-independent shapes, and reduced motion rules.

---

## SECTION 1: State Library

The Global UI States System consists of thirty-seven distinct system states. These states are classified into seven major visual categories to cover every possible scenario within BankYar's offline architecture.

### 1.1 Loading States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.loading.generic` | Full-screen loading when data is fetched from local secure storage. | Symmetrical background overlay with a rotating loading wheel centered. | Confirm system is operating; wait briefly for data load. |
| `state.loading.skeleton` | Inline structural templates for lists or cards during background compilation. | Pulsing geometric skeleton structures matching the structural shapes of lists. | Expect content layout to populate immediately in place. |
| `state.loading.progress` | Determinate progress for longer file operations. | Centered linear or circular progress indicators with dynamic percentage text. | Track exact completion rates for secure processes. |
| `state.loading.refreshing` | Manual swipe-to-refresh pull actions on lists. | Top pull-down progress wheel aligned logically in the horizontal center. | Refresh ledger entries from updated local databases. |
| `state.loading.syncing` | Background local P2P sync with an alternate device. | Static app bar sync status icon transforming into rotating progress. | Synchronize transaction list without network access. |
| `state.loading.importing` | Parsing raw backup data or SMS lists. | Full blocking overlay displaying list counts and verification checks. | Safely import files without database corruption. |
| `state.loading.exporting` | Packaging, encrypting, and writing backup files. | Minimalist status block detailing ZIP and security steps. | Copy encrypted file safely into public downloads directory. |
| `state.loading.db_opening` | Decrypting SQLCipher container during boot. | Secure animated shield with progress indication. | Reassure that local financial keys are verified. |
| `state.loading.db_migration` | Altering schema configurations during system update. | Dynamic step-list showing past, current, and future structure updates. | Update database format without losing historical entries. |

### 1.2 Empty States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.empty.transactions` | Absolute first boot or database reset scenario. | Large metaphorical outline illustration centered, primary and secondary CTA. | Populate ledger by scanning SMS or adding manually. |
| `state.empty.search` | Query returned zero rows from database. | Empty document icon, suggestions list, reset search action. | Reset search string or refine criteria easily. |
| `state.empty.statistics` | Zero records found to generate local charts. | Faded background skeleton chart overlays with informational text. | Input data manually or run SMS scanner to unlock graphs. |
| `state.empty.notes` | Transaction detail loaded with zero private notes. | Thin pencil indicator next to highlighted note container. | Click to add details, labels, or tracking reference. |
| `state.empty.backup` | Restore center with zero backup files found. | Isolated safe folder with dashed outlines, manually select file. | Locate external backup files or trigger backup creation. |
| `state.empty.notifications`| Zero entries in system alerts log. | Centered envelope with a gentle check outline. | Rest assured that system and ledger alerts are clean. |
| `state.empty.permissions` | App launched with no background SMS permissions. | Security warning shield, logical educational explanation, permissions CTA. | Grant background system access or select manual entry. |
| `state.empty.banks` | custom SMS analyzer contains no registered banks. | Symmetrical card layout displaying default templates checklist. | Register customized parsing rules or load default bank list. |

### 1.3 Offline States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.offline.working` | Standard operating state showing offline security. | Small, reassuring lock badge inside the primary app bar. | Confirm that data remains completely isolated on device. |
| `state.offline.limited` | Attempting to access cloud features (future). | Explanatory modal with physical lock graphic and return CTA. | Understand why cloud features are inactive. |
| `state.offline.recovery` | Restoring offline integrity after an unexpected reboot. | Progress dialogue running verification checks on tables. | Safely resume tracking transactions offline. |
| `state.offline.error` | Local storage lock preventing write permissions. | Screen alert overlay, technical detail button, retry action. | Unlock files or clear storage to restore operations. |
| `state.offline.disabled` | System baseline indicating absolute network blockade. | Small, un-clickable cloud icon with a diagonal line inside settings. | Confirm zero internet access permission in manifest. |

### 1.4 Error States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.error.generic` | Fallback for unhandled UI exceptions. | Metaphorical broken gear outline, clear description, retry CTA. | Recover normal interface display with one click. |
| `state.error.database` | SQLite / SQLCipher read or write locks. | Severe warning icon, descriptive non-technical copy, safe reboot CTA. | Secure financial database without losing history. |
| `state.error.permission` | User denied permissions multiple times. | High-contrast warning screen, settings link button, tutorial option. | Understand permission requirements to run. |
| `state.error.import` | Parsing invalid CSV schema format. | Split list indicating invalid rows, schema template download. | Adjust columns in CSV or re-export file. |
| `state.error.export` | Destination directory locked or storage full. | Alert dialogue indicating space limits, secondary export target CTA. | Clear on-device storage space or select another path. |
| `state.error.backup` | Password verification or encryption failed. | Broken key icon, PIN/password entry focus state, cancel action. | Re-enter correct security password to proceed. |
| `state.error.parsing` | Regex analyzer unable to parse bank SMS. | Raw text indicator block with highlighted missing tokens. | Map unknown banking templates manually. |
| `state.error.unexpected` | Severe application runtime exception. | Gentle crash feedback screen with on-device log export action. | Restart application safely to continue. |

### 1.5 Maintenance States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.maint.optimization` | Cleaning unused DB pages and sorting indices. | Progress indicator with circular gears rotating smoothly. | Wait briefly while data speed is restored. |
| `state.maint.recovery` | Repairing corrupted SQLite blocks. | Step-by-step validation markers with check and warning highlights. | Recover as many transaction records as possible. |
| `state.maint.verification` | Running physical root checks and tamper checks.| Dynamic glowing security barrier with standard status feedback. | Confirm app environment is fully secure. |
| `state.maint.migration` | Transforming schema tables to match new versions. | Multi-stage migration checklist with non-destructive status labels. | Complete structure updates without losing details. |
| `state.maint.mode_future` | System baseline consistency check. | Ambient loading screen with diagnostic step summaries. | Verify structural ledger alignment. |

### 1.6 Success States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.success.backup` | Secure backup file exported. | Symmetrical shield outline with a solid check overlay, dismiss CTA. | Confirm backup file is written in public storage. |
| `state.success.restore` | Backup decrypted and loaded. | Celebration check outline, dynamic count of loaded items, reset home CTA. | Resume ledger with fully restored transaction list. |
| `state.success.import` | Manual CSV / clipboard parsing done. | Complete list preview showing imported rows, ledger navigation CTA. | Access imported transactions in the main feed. |
| `state.success.export` | CSV ledger exported to storage. | Green success banner displaying exact file destination directory. | Locate CSV ledger output for spreadsheet use. |
| `state.success.pin_change` | Passcode securely updated. | Solid key with double check indicator, authentication restart. | Access application using new custom PIN. |
| `state.success.perm_grant` | Permissions granted on device settings. | Success toast showing scanning starting status. | Experience seamless transaction capture. |
| `state.success.tx_saved` | Manual entry saved to SQLCipher database. | Quick success toast with inline view detail action. | Verify newly recorded entry in ledger list. |
| `state.success.settings` | Preferences saved to device. | Brief system feedback banner, instant layout updates. | Ensure customized parameters are applied. |

### 1.7 Warning States
| State Key | Purpose | Visual Presentation Strategy | User Goal / Expectation |
| :--- | :--- | :--- | :--- |
| `state.warning.low_storage` | Storage space dropping below critical limit. | Warning banner with a caution icon, memory management link. | Understand risks of database locks. |
| `state.warning.perm_missing` | Features limited due to denied permissions. | Symmetrical info card in page header, permission request link. | Understand limits of manual operation mode. |
| `state.warning.battery` | OS background restriction detected. | Explanatory list card detailing steps to disable limits. | Ensure background SMS parsing operates reliably. |
| `state.warning.outdated` | No backups created in last standard period. | Persistent dashboard card with prompt to trigger backup. | Protect personal financial history. |
| `state.warning.weak_pin` | Low passcode complexity selected. | Passcode complexity meter, change security passcode action. | Secure ledger with stronger PIN pattern. |
| `state.warning.biometric` | System biometric verification disabled. | Status flag with standard configuration toggle link. | Enable convenient fingerprint authentication. |
| `state.warning.old_db` | Schema mismatch with backup files. | Warning banner explaining dynamic conversion parameters. | Match data structure to the updated software. |

---

## SECTION 2: State Hierarchy

In a complex financial application running on varying system states, multiple conditions may be met simultaneously. To prevent interface overlapping, screen layout crashes, or confusing feedback patterns, the system resolves visual presentation according to a strict, single-tier hierarchy.

```
[System Event Stream Triggered]
               |
               v
  +--------------------------+
  |  1. Critical Security    | -> Dominates all views. Immediately overlays biometric verification
  |  (Jailbreak/PIN Lockout) |    or security alerts, locking standard interfaces.
  +--------------------------+
               | (If clear)
               v
  +--------------------------+
  |    2. Maintenance / DB   | -> Overlays standard application views. Displays step checklists,
  |     (Migration/Vacuum)   |    blocking standard user interactions.
  +--------------------------+
               | (If clear)
               v
  +--------------------------+
  |     3. Critical Error    | -> Replaces the active viewport with a full-screen recovery layout
  |     (Database Locked)    |    including explanatory texts and a primary recovery CTA.
  +--------------------------+
               | (If clear)
               v
  +--------------------------+
  |     4. Full Screen Load  | -> Renders standard content structural templates or shimmer skeletons,
  |    (Skeletons/Launchers) |    blocking interactions until data is parsed.
  +--------------------------+
               | (If clear)
               v
  +--------------------------+
  |      5. Empty States     | -> Renders centered metaphorical illustration and specific CTAs in
  |     (No Transactions)    |    place of the empty list element.
  +--------------------------+
               | (If clear)
               v
  +--------------------------+
  | 6. Warning/Success Alerts| -> Displays non-blocking app bars, toast banners, or header cards
  |    (Low Space/Saved Toast)|   to communicate system status without disrupting the view.
  +--------------------------+
```

---

## SECTION 3: Component Specification

Every global state screen and overlay is composed of nine standard, reusable components. To guarantee perfect visual cohesion, each component is specified below across fifteen core attributes.

### 3.1 Illustration
1. **Purpose:** Provide an elegant, metaphoric visual representation of the current state to reduce user anxiety.
2. **User Goal:** Quickly understand the context of the empty or error state through non-threatening imagery.
3. **Visual Priority:** Primary visual focal point, positioned in the vertical center above the text stack.
4. **Illustration Style:** Thin, clean outline strokes using semantic tokens. Solid fills are prohibited.
5. **Spacing:** Standard layout space `bankyar.space.xxl` above and below the illustration container.
6. **Typography:** Not applicable (pure visual graphic element).
7. **Icons:** Built-in metaphorical shapes aligned inside the illustration boundaries.
8. **Buttons:** Not applicable.
9. **CTA:** Not applicable.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Soft pulsing opacity or entry scale transition using curve `bankyar.motion.curve.standard`.
12. **Accessibility:** Detailed description assigned via semantic label (e.g., "تصویر خطی از یک صندوقچه امن قفل شده").
13. **RTL Behaviour:** Symmetrically centered. Multi-element paths inside the illustration must mirror chronologically.
14. **Dark Mode:** Stroke color automatically shifts to high-contrast neutral token `bankyar.semantic.color.text.secondary`.
15. **Future Expansion:** Local custom icons mapping to on-device categorization indicators.

### 3.2 Headline
1. **Purpose:** Provide a clear, bold title summarizing the current state in a single line.
2. **User Goal:** Fast context identification in less than two seconds.
3. **Visual Priority:** Highest text hierarchy, located directly under the illustration.
4. **Illustration Style:** Not applicable.
5. **Spacing:** Spacing offset `bankyar.space.md` below the headline element.
6. **Typography:** Size `bankyar.font.size.xl`, weight `bankyar.font.weight.bold`, line height `bankyar.font.leading.tight`.
7. **Icons:** Optional status icon prefixed inline to the text.
8. **Buttons:** Not applicable.
9. **CTA:** Not applicable.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Fade-in and vertical slide transition synchronized with the visual stack.
12. **Accessibility:** Enforced high-contrast ratio against the primary canvas surface, supports dynamic font scaling.
13. **RTL Behaviour:** Right-aligned Persian text with appropriate baseline matching.
14. **Dark Mode:** Remapped to color token `bankyar.semantic.color.text.primary`.
15. **Future Expansion:** Local translation hooks based on user language preferences.

### 3.3 Description
1. **Purpose:** Explain *why* the state occurred and provide direct, actionable steps to resolve it.
2. **User Goal:** Understand the system context and find a clear solution without feeling blamed.
3. **Visual Priority:** Medium hierarchy, located between the headline and the primary action buttons.
4. **Illustration Style:** Not applicable.
5. **Spacing:** Generous spacing padding `bankyar.space.lg` below the description text block.
6. **Typography:** Size `bankyar.font.size.md`, weight `bankyar.font.weight.regular`, line height `bankyar.font.leading.loose`.
7. **Icons:** Not applicable.
8. **Buttons:** Not applicable.
9. **CTA:** Not applicable.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Seamless fade-in transition along with the headline block.
12. **Accessibility:** Text wraps dynamically up to three lines without clipping, maintaining full screen-reader accessibility.
13. **RTL Behaviour:** Right-aligned Persian text.
14. **Dark Mode:** Remapped to subtle neutral text color token `bankyar.semantic.color.text.secondary`.
15. **Future Expansion:** Automatic diagnostic detail expansion triggers for power users.

### 3.4 Action Button
1. **Purpose:** Trigger the primary logical action required to transition out of the current state.
2. **User Goal:** Perform the most logical recovery step with a single tap.
3. **Visual Priority:** Highest interactive priority, rendered as a filled Material Design 3 container.
4. **Illustration Style:** Not applicable.
5. **Spacing:** Spacing margin `bankyar.space.sm` separating it from secondary action elements.
6. **Typography:** Size `bankyar.font.size.md`, weight `bankyar.font.weight.medium`.
7. **Icons:** Symmetrically placed icon prefixed to the button label.
8. **Buttons:** Solid filled container with rounded corners mapping to `bankyar.radius.md`.
9. **CTA:** Serves as the primary Call-to-Action for state transitions.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Immediate scale-down compression on press state to simulate physical tactile depth.
12. **Accessibility:** Physical touch target size configured to a minimum of forty-eight density units.
13. **RTL Behaviour:** Text and pre-fixed icon align from right to left inside the container bounds.
14. **Dark Mode:** Container fill maps to token `bankyar.semantic.color.interactive.default` in dark execution.
15. **Future Expansion:** Dynamic context-sensitive button actions.

### 3.5 Secondary Action
1. **Purpose:** Provide an alternate, non-blocking path or fallback feature.
2. **User Goal:** Dismiss the state or select a manual alternative when the primary path is not preferred.
3. **Visual Priority:** Medium interactive priority, rendered as an outlined or text-only button.
4. **Illustration Style:** Not applicable.
5. **Spacing:** Standard spacing margin surrounding the container bounds.
6. **Typography:** Size `bankyar.font.size.md`, weight `bankyar.font.weight.medium`.
7. **Icons:** Not applicable.
8. **Buttons:** Outlined container mapping to radius token `bankyar.radius.md`.
9. **CTA:** Not applicable.
10. **Secondary CTA:** Serves as the secondary choice for users.
11. **Animation:** Alpha hover highlight and quick tap compression feedback.
12. **Accessibility:** Minimum forty-eight density units interaction target.
13. **RTL Behaviour:** Symmetrical Persian text alignment inside container.
14. **Dark Mode:** Outlined boundary maps to color token `bankyar.semantic.color.border.subtle`.
15. **Future Expansion:** Smart menu overlays triggering multiple fallback options.

### 3.6 Retry Button
1. **Purpose:** Re-run the failed network-free query or storage write operation instantly.
2. **User Goal:** Try the action again after correcting environmental issues (such as storage or database locks).
3. **Visual Priority:** Equal to the primary action button on severe error recovery screens.
4. **Illustration Style:** Not applicable.
5. **Spacing:** Standard spacing layout parameters matching primary action guidelines.
6. **Typography:** Size `bankyar.font.size.md`, weight `bankyar.font.weight.bold`.
7. **Icons:** Rotating action arrow icon prefixed to the label text.
8. **Buttons:** High-visibility filled or outlined container depending on the error context.
9. **CTA:** Primary error state recovery path.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Immediate rotating icon animation on user tap to indicate process retrial.
12. **Accessibility:** Focus ring outline applied during keyboard/switch access navigation.
13. **RTL Behaviour:** Mirror-flipped rotating arrow direction to support standard RTL rotation cues.
14. **Dark Mode:** Remapped to high-contrast error recovery tokens.
15. **Future Expansion:** Exponential automatic retry countdown loops with visual indicators.

### 3.7 Help Button
1. **Purpose:** Load an offline educational tutorial or explanatory sheet detailing features.
2. **User Goal:** Find detailed explanations regarding permission safety or backup cryptography.
3. **Visual Priority:** Low-key interactive priority, positioned in the top-start corner of error blocks.
4. **Illustration Style:** Not applicable.
5. **Spacing:** Isolated boundary spacing margin.
6. **Typography:** Size `bankyar.font.size.sm`, weight `bankyar.font.weight.regular`.
7. **Icons:** Inline question mark status icon.
8. **Buttons:** Icon button with a circular touch boundary mapping to `bankyar.radius.full`.
9. **CTA:** Educational reference path.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Soft fading expand on tap.
12. **Accessibility:** Explicit semantic description: "راهنمای عیب‌یابی آفلاین سیستم".
13. **RTL Behaviour:** Positioned on the top-left edge of the layout viewport.
14. **Dark Mode:** Text and icon elements map to subtle neutral token `bankyar.semantic.color.text.secondary`.
15. **Future Expansion:** Integrated contextual checklist overlay matching local system warnings.

### 3.8 Status Icon
1. **Purpose:** Provide a quick, color-coded visual indicator of state priority (Success, Warning, Error).
2. **User Goal:** Instantly identify safety, danger, or pending status on dashboard cards.
3. **Visual Priority:** High visual priority within localized alerts, banners, and toast elements.
4. **Illustration Style:** Solid vector geometry with bold, simplified contours.
5. **Spacing:** Spacing gap `bankyar.space.xs` separating it horizontally from text headings.
6. **Typography:** Not applicable.
7. **Icons:** Predefined system alert symbols (Lock, Check, Danger Shield).
8. **Buttons:** Not applicable.
9. **CTA:** Not applicable.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Smooth bounce transition upon element entry.
12. **Accessibility:** Never communicates state through color alone; paired with distinct symbolic geometry.
13. **RTL Behaviour:** Located on the right-hand side of textual content streams.
14. **Dark Mode:** Remapped to designated dark system accent tokens.
15. **Future Expansion:** Animated transitions reflecting dynamic status resolution.

### 3.9 Progress Indicator
1. **Purpose:** Communicate active background calculation progress to reassure users.
2. **User Goal:** Track operational progress and verify that the system is functioning.
3. **Visual Priority:** Primary focal point on active processing screens.
4. **Illustration Style:** Clean, circular ring path or flat horizontal tracking line.
5. **Spacing:** Standard spacing buffer surrounding the component layout.
6. **Typography:** Size `bankyar.font.size.xs`, weight `bankyar.font.weight.bold` (when displaying progress counts).
7. **Icons:** Not applicable.
8. **Buttons:** Not applicable.
9. **CTA:** Not applicable.
10. **Secondary CTA:** Not applicable.
11. **Animation:** Constant angular velocity rotation mapping to motion duration `bankyar.motion.duration.medium`.
12. **Accessibility:** Dynamic percentage announcements read to screen readers at regular intervals.
13. **RTL Behaviour:** Horizontal progress indicators must flow from right to left.
14. **Dark Mode:** Primary fill track maps to bright system color token `bankyar.semantic.color.primary`.
15. **Future Expansion:** Dynamic step verification checklist integration.

---

## SECTION 4: Interaction Rules

The states system is designed to provide responsive interaction patterns across touch, gesture, and keyboard navigation.

### 4.1 Focus Navigation Map
When an error overlay, dialog, or empty state screen is loaded, the application's focus sequence must adapt instantly:
1. **Focus Trap:** Focus must be programmatically restricted to the active overlay. Assistive technologies must not access background screen elements.
2. **Default Focus Target:** Focus must be placed directly on the primary action button or retry CTA, minimizing the steps required for state recovery.
3. **Tab Order Loop:** The focus loop sequence is structured as follows:
   `Primary Action Button` -> `Secondary Action Button` -> `Help Button` -> `Close Icon (if present)`.

### 4.2 State Transitions
All visual states must transition smoothly to prevent sudden visual jumps or screen flicker:
* **Skeleton-to-Content Handshake:** When content finishes loading, content card elements fade in while matching skeleton blocks fade out simultaneously.
* **Alert Entry-Exit:** Dialog sheets slide up from the bottom boundary on entry and slide down on dismissal, maintaining standard spatial depth relationships.

### 4.3 Recovery Loops
* **The No-Network Guarantee:** No retry action may attempt external network pings. Standard retry loops must verify local resources (e.g., SQLite connection, storage folder permissions).
* **Automated Timeout Fallback:** If a loading process exceeds the expected time threshold, the system must display an error screen with a manual recovery action.

---

## SECTION 5: Motion Guidelines

Animation is strictly functional and designed to guide user attention. Playful, bouncy, or complex visual effects are prohibited to maintain a professional fintech aesthetic.

### 5.1 Loading Animation
* **Behavior:** Infinite rotation of the secure loading spinner.
* **Duration Token:** Mapping to circular loop duration `bankyar.motion.duration.medium`.
* **Curve Token:** Flat, constant linear interpolation `bankyar.motion.curve.linear`.
* **Reduced Motion:** Spinners must instantly switch to a static loading indicator if reduced motion is enabled.

### 5.2 State Transition
* **Behavior:** Seamless cross-fade transition when shifting views.
* **Duration Token:** Mapping to standard transition duration `bankyar.motion.duration.fast`.
* **Curve Token:** Standard material easing curve `bankyar.motion.curve.standard`.

### 5.3 Retry Animation
* **Behavior:** The circular retry arrow icon spins 360 degrees when clicked to indicate query execution.
* **Duration Token:** Fast rotation mapping to `bankyar.motion.duration.fast`.
* **Curve Token:** Easing deceleration curve `bankyar.motion.curve.decelerate`.

### 5.4 Success Animation
* **Behavior:** The solid success checkmark scales up slightly from the center, accompanied by a soft opacity fade-in of the containing shield.
* **Duration Token:** Gentle transition mapping to `bankyar.motion.duration.medium`.
* **Curve Token:** Standard easing curve `bankyar.motion.curve.standard`.

### 5.5 Error Animation
* **Behavior:** The error dialog or warning card executes a subtle horizontal shake animation (left-to-right-to-left) to draw attention to the issue.
* **Duration Token:** Highly compact alert sequence mapping to `bankyar.motion.duration.fast`.
* **Curve Token:** Rapid, alternating velocity transitions.

---

## SECTION 6: Accessibility Review

This system meets the strict requirements of WCAG 2.1 Level AA conformance through several key design features.

### 6.1 WCAG Conformance Matrix
* **Guideline 1.1 (Non-text Content):** Every state illustration and icon has a matching localized semantic description.
* **Guideline 1.4 (Distinguishable):** Contrast ratios must remain above 4.5:1 for body copy and 3.0:1 for large headings against active canvases.
* **Guideline 2.1 (Keyboard Accessible):** All interactive states are fully navigable using standard keyboard inputs.

### 6.2 Screen Reader Voice Mapping
The system announces status changes clearly to assistive technologies:
* **Generic Loading:** `در حال بارگذاری اطلاعات مالی به صورت امن... لطفاً منتظر بمانید.`
* **Determinate Progress:** `عملیات پشتیبان‌گیری چهل و پنج درصد انجام شده است.`
* **Severe Error:** `خطا در اتصال به پایگاه داده محلی رخ داده است. تکمه راه‌اندازی مجدد آماده فشردن است.`

### 6.3 Large Font Scaling Support
* **Responsive Row Wrapping:** Standard cards and dialog blocks wrap content columns vertically when text scaling exceeds 150%. No text is clipped or truncated.
* **Min-Max Height Boundaries:** Interactive button containers utilize relative sizing factors instead of fixed heights to ensure text labels scale comfortably.

---

## SECTION 7: RTL Review

Because Persian is a Right-to-Left language, the layout, hierarchy, and gestures of BankYar must adapt to match regional reading directions.

### 7.1 Text Alignment Rules
* **Enforced RTL Flow:** Heading text, descriptions, and list items must align to the right margin of layouts. Left-aligned Persian blocks are prohibited.
* **Arabic Numerals:** Monetary values and dates must utilize standard regional numerals within text strings, aligned to RTL text flow.

### 7.2 Logical Mirroring Guidelines
* **Horizontal Icons:** Directional icons (such as chevrons, arrows, and checklists) must mirror horizontally when rendering in the Persian locale.
* **Progress Flows:** Circular progress indicators rotate clockwise, but linear progress lines must fill from right to left.
* **Swipe Gestures:** Dismiss-to-delete swipes must flow from left to right, matching natural Persian handwriting patterns.

---

## SECTION 8: Empty State Library

Every empty state in BankYar is designed to guide the user toward the next logical interaction, preventing empty views from feeling like a broken app interface.

### 8.1 No Transactions
* **Context:** Database is empty upon initial launch.
* **Headline:** `هیچ تراکنشی ثبت نشده است`
* **Description:** `پیامک‌های بانکی دریافتی به صورت خودکار اسکن و در این بخش دسته‌بندی می‌شوند. همچنین می‌توانید تراکنش‌ها را دستی اضافه کنید.`
* **Illustration:** Secured safe outline with circular pattern overlay.
* **Primary CTA:** `فعال‌سازی دریافت خودکار` (Triggers background SMS scanner).
* **Secondary CTA:** `ثبت تراکنش دستی` (Opens manual transaction ledger form).

### 8.2 No Search Results
* **Context:** Active search query returns zero matching records.
* **Headline:** `تراکنشی یافت نشد`
* **Description:** `هیچ تراکنشی منطبق با عبارت جستجو شده پیدا نشد. لطفاً املاء کلمات را بررسی کنید یا فیلترها را ریست کنید.`
* **Illustration:** Centered document icon with a magnifying glass search overlay.
* **Primary CTA:** `پاک کردن فیلترهای جستجو` (Resets query inputs).
* **Secondary CTA:** `تغییر معیارهای جستجو` (Re-focuses query field).

### 8.3 No Statistics
* **Context:** Dashboard lacks sufficient transaction records to generate analytics.
* **Headline:** `نمودارها آماده نیستند`
* **Description:** `گزارش‌های تحلیلی و آماری پس از ثبت حداقل چند تراکنش فعال می‌شوند. همین حالا اولین تراکنش خود را وارد کنید.`
* **Illustration:** Skeleton bar chart graphic with dotted line details.
* **Primary CTA:** `وارد کردن فایل پشتیبان` (Opens restore import drawer).
* **Secondary CTA:** `ثبت تراکنش دستی` (Opens manual transaction ledger form).

### 8.4 No Notes
* **Context:** Transaction detail modal loaded with zero private notes.
* **Headline:** `توضیحاتی ثبت نشده است`
* **Description:** `می‌توانید برای دسته‌بندی دقیق‌تر و یادداشت جزئیات، توضیحات اختصاصی خود را به این تراکنش اضافه کنید.`
* **Illustration:** Standard document page outline with light pencil sketch guidelines.
* **Primary CTA:** `افزودن یادداشت` (Focuses note input textfield).
* **Secondary CTA:** `بستن صفحه` (Closes transaction sheet).

### 8.5 No Backup
* **Context:** Restore dashboard finds zero backup files.
* **Headline:** `هیچ فایل پشتیبانی یافت نشد`
* **Description:** `هیچ فایل پشتیبان پیش‌فرضی در حافظه دستگاه یافت نشد. می‌توانید فایلی را دستی انتخاب کنید.`
* **Illustration:** Dotted folder outline with a warning indicator.
* **Primary CTA:** `انتخاب فایل از حافظه دستگاه` (Opens OS system picker).
* **Secondary CTA:** `ساخت فایل پشتیبان جدید` (Redirects to backup generator).

### 8.6 No Notifications
* **Context:** Alert log is empty.
* **Headline:** `صندوق پیام‌ها خالی است`
* **Description:** `اعلانات تراکنش‌های جدید و هشدارهای امنیتی مربوط به پشتیبان‌گیری در این بخش به شما اطلاع داده می‌شوند.`
* **Illustration:** Envelope outline overlaid with a solid check indicator.
* **Primary CTA:** `بازگشت به صفحه پیشخوان` (Redirects to home dashboard).
* **Secondary CTA:** `تنظیمات اعلانات` (Opens notification preferences).

### 8.7 No Permissions
* **Context:** App lacks background SMS permissions.
* **Headline:** `عدم دسترسی به پیامک‌ها`
* **Description:** `برای ردیابی خودکار و دسته‌بندی تراکنش‌ها، دسترسی به پیامک‌ها ضروری است. بدون این دسترسی برنامه به صورت دستی کار خواهد کرد.`
* **Illustration:** Locked shield outline with warning elements.
* **Primary CTA:** `اعطای مجوز پیامک` (Triggers background system permission prompt).
* **Secondary CTA:** `ادامه به صورت دستی` (Continues without access).

### 8.8 No Banks
* **Context:** No custom banks are configured in preferences.
* **Headline:** `بانکی تعریف نشده است`
* **Description:** `برای پردازش پیامک‌های بانکی، باید قالب‌های پیامک بانک خود را فعال یا طراحی کنید.`
* **Illustration:** Blank financial card with dotted question mark.
* **Primary CTA:** `فعال‌سازی قالب‌های پیش‌فرض` (Loads baseline bank templates).
* **Secondary CTA:** `طراحی قالب پیامک جدید` (Opens custom template designer).

---

## SECTION 9: Error Library

Error screens must help users resolve issues independently, avoiding technical jargon or confusing crash codes.

### 9.1 Generic Error
* **Headline:** `خطا در اجرای برنامه`
* **Description:** `سیستم با مشکل مواجه شد. اطلاعات مالی شما محفوظ است. لطفاً چند لحظه دیگر دوباره تلاش کنید.`
* **Primary CTA:** `تلاش مجدد` (Re-renders UI viewport).
* **Secondary CTA:** `ارسال گزارش خطا` (Exports log to secure file).

### 9.2 Database Error
* **Headline:** `عدم دسترسی به صندوق اطلاعات`
* **Description:** `بانک اطلاعاتی موقتاً در دسترس نیست. ممکن است فایل توسط فرآیند دیگری قفل شده باشد. لطفاً برنامه را ببندید و مجدداً باز کنید.`
* **Primary CTA:** `تلاش مجدد` (Resets database connections).
* **Secondary CTA:** `راهنمای بازیابی اضطراری` (Opens database help guide).

### 9.3 Permission Error
* **Headline:** `مجوز پیامک صادر نشد`
* **Description:** `بدون دسترسی پیامک، استخراج خودکار تراکنش‌ها غیرفعال است. می‌توانید این مجوز را در تنظیمات دستگاه فعال کنید.`
* **Primary CTA:** `تنظیمات دستگاه` (Redirects to system settings).
* **Secondary CTA:** `ادامه در حالت ثبت دستی` (Switches to manual ledger).

### 9.4 Import Error
* **Headline:** `قالب فایل معتبر نیست`
* **Description:** `ساختار فایل وارد شده با مشخصات مورد انتظار مطابقت ندارد. لطفاً ستون‌های فایل اکسل یا فایل متنی را بررسی کنید.`
* **Primary CTA:** `انتخاب فایل جدید` (Re-opens document picker).
* **Secondary CTA:** `دانلود نمونه الگو` (Exports schema guide).

### 9.5 Export Error
* **Headline:** `ذخیره‌سازی ناموفق بود`
* **Description:** `فضای ذخیره‌سازی دستگاه پر است یا مسیر انتخاب شده قابل نوشتن نیست. لطفاً حافظه دستگاه خود را بررسی کنید.`
* **Primary CTA:** `تلاش مجدد` (Re-executes write process).
* **Secondary CTA:** `تغییر مسیر ذخیره` (Opens folder browser).

### 9.6 Backup Error
* **Headline:** `خطا در رمزگذاری فایل پشتیبان`
* **Description:** `امکان رمزگذاری فایل پشتیبان به دلیل عدم تطابق گذرواژه وجود ندارد. لطفاً رمز عبور انتخابی را مجدداً بررسی کنید.`
* **Primary CTA:** `ورود مجدد گذرواژه` (Focuses key entry textfield).
* **Secondary CTA:** `انصراف` (Cancels operation).

### 9.7 Parsing Error
* **Headline:** `خطا در تحلیل متن پیامک`
* **Description:** `ساختار پیامک بانکی وارد شده معتبر نیست یا با الگوهای استاندارد همخوانی ندارد.`
* **Primary CTA:** `طراحی الگو به صورت دستی` (Opens parser custom mapping).
* **Secondary CTA:** `ثبت تراکنش دستی` (Opens ledger entry form).

### 9.8 Unexpected Error
* **Headline:** `برنامه متوقف شد`
* **Description:** `خطایی غیرمنتظره در اجرای فرآیند رخ داد. هیچ اطلاعاتی آسیب ندیده است. لطفاً برنامه را دوباره راه‌اندازی کنید.`
* **Primary CTA:** `راه‌اندازی مجدد` (Wipes caches and boots system).
* **Secondary CTA:** `ذخیره لاگ عیب‌یابی` (Writes log export).

---

## SECTION 10: Success Library

Success notifications validate completed tasks, providing a positive feedback loop for users.

### 10.1 Backup Completed
* **Headline:** `پشتیبان‌گیری امن انجام شد`
* **Description:** `فایل پشتیبان شما با موفقیت رمزگذاری و در حافظه داخلی دستگاه شما ذخیره شد.`
* **Illustration:** Secure folder outline overlaid with solid check.
* **Primary Action Button:** `تایید` (Closes success dialog).

### 10.2 Restore Completed
* **Headline:** `بازیابی اطلاعات موفقیت‌آمیز بود`
* **Description:** `اطلاعات با موفقیت رمزگشایی و بازنشانی شدند. تمام تراکنش‌های شما بازیابی شدند.`
* **Illustration:** Success celebration check outline.
* **Primary Action Button:** `مشاهده لیست تراکنش‌ها` (Redirects to home ledger feed).

### 10.3 Import Completed
* **Headline:** `تراکنش‌ها وارد شدند`
* **Description:** `اطلاعات جدید استخراج شده با موفقیت به پایگاه داده محلی افزوده شدند.`
* **Illustration:** Solid checking document icon.
* **Primary Action Button:** `مشاهده تراکنش‌های جدید` (Filters feed to imported items).

### 10.4 Export Completed
* **Headline:** `فایل خروجی ذخیره شد`
* **Description:** `اطلاعات تراکنش‌های شما با موفقیت در قالب فایل اکسل در بخش دانلودهای دستگاه ذخیره شد.`
* **Illustration:** Circular folder icon with arrow point down.
* **Primary Action Button:** `تایید` (Dismisses alert).

### 10.5 PIN Changed
* **Headline:** `رمز عبور به‌روزرسانی شد`
* **Description:** `گذرواژه اصلی برنامه تغییر یافت. برای دسترسی بعدی از رمز عبور جدید استفاده کنید.`
* **Illustration:** Solid security lock icon.
* **Primary Action Button:** `تایید و راه‌اندازی مجدد` (Triggers app lock screen reset).

### 10.6 Permission Granted
* **Headline:** `دسترسی پیامک فعال شد`
* **Description:** `مجوز دسترسی با موفقیت تایید شد. سیستم آماده دریافت خودکار تراکنش‌ها است.`
* **Illustration:** Symmetrical phone layout with checking stars.
* **Primary Action Button:** `شروع اسکن پیامک‌ها` (Launches background scan loop).

### 10.7 Transaction Saved
* **Headline:** `تراکنش ذخیره شد`
* **Description:** `تراکنش جدید با موفقیت در پایگاه داده رمزگذاری شده محلی ثبت شد.`
* **Illustration:** Symmetrical ledger line with check overlay.
* **Primary Action Button:** `ثبت تراکنش جدید` (Clears manual form and keeps active).

### 10.8 Settings Updated
* **Headline:** `تغییرات ذخیره شدند`
* **Description:** `تنظیمات انتخابی شما با موفقیت ثبت و بر روی رابط کاربری اعمال شدند.`
* **Illustration:** Configuration gears with mini success badge.
* **Primary Action Button:** `تایید` (Dismisses alert banner).

---

## SECTION 11: Warning Library

Warning states alert users to immediate risks or system degradations without creating unnecessary panic.

### 11.1 Low Storage
* **Warning Icon:** Warning outline triangle.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `حافظه داخلی دستگاه پر شده است. این موضوع ممکن است باعث بروز خطا در ثبت تراکنش‌های جدید شود.`
* **Primary Target Button:** `پاک‌سازی حافظه برنامه` (Triggers db index optimization/vacuum).
* **Secondary Target Button:** `انصراف` (Dismisses caution banner).

### 11.2 Permission Missing
* **Warning Icon:** Security alert icon.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `دسترسی به پیامک‌ها غیرفعال است. برنامه هم‌اکنون به صورت دستی اجرا می‌شود و تراکنش‌های دریافتی خودکار ردیابی نخواهند شد.`
* **Primary Target Button:** `فعال‌سازی دسترسی پیامک` (Opens device permission launcher).
* **Secondary Target Button:** `متوجه شدم` (Dismisses alert banner).

### 11.3 Battery Optimization Enabled
* **Warning Icon:** Battery outline with a warning dot.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `بهینه‌ساز باتری اندروید فعال است. این قابلیت ممکن است از دریافت سریع پیامک‌های بانکی در پس‌زمینه جلوگیری کند.`
* **Primary Target Button:** `غیرفعال‌سازی در تنظیمات` (Directs to OS battery options).
* **Secondary Target Button:** `رد کردن` (Dismisses warning card).

### 11.4 Backup Outdated
* **Warning Icon:** Clock alert symbol.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `بیش از سی روز از آخرین پشتیبان‌گیری شما گذشته است. برای حفظ امنیت داده‌ها، تهیه پشتیبان جدید توصیه می‌شود.`
* **Primary Target Button:** `تهیه پشتیبان جدید` (Opens backup generation panel).
* **Secondary Target Button:** `یادآوری در هفته آینده` (Postpones alert).

### 11.5 Weak PIN
* **Warning Icon:** Lock alert symbol.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `رمز عبور انتخابی شما ساده و قابل حدس است. برای محافظت بهتر از اطلاعات مالی، رمز عبور قوی‌تری انتخاب کنید.`
* **Primary Target Button:** `تغییر رمز عبور` (Redirects to PIN editor).
* **Secondary Target Button:** `ادامه با همین رمز` (Saves despite warning).

### 11.6 Biometric Disabled
* **Warning Icon:** Fingerprint outline with warning strike.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `حسگر اثر انگشت روی سیستم غیرفعال است. برای امنیت بالاتر پیشنهاد می‌شود اثر انگشت را فعال کنید.`
* **Primary Target Button:** `فعال‌سازی حسگر` (Launches OS biometric registrar).
* **Secondary Target Button:** `ادامه با رمز عبور` (Keeps standard password authentication active).

### 11.7 Old Database Version
* **Warning Icon:** Database cylinders with warning clock.
* **Color Token:** Alert yellow warning indicator mapping `bankyar.semantic.color.warning`.
* **Description Copy:** `نسخه پایگاه داده موجود در فایل پشتیبان با نسخه فعلی برنامه متفاوت است. تبدیل داده‌ها ممکن است چند لحظه طول بکشد.`
* **Primary Target Button:** `شروع تبدیل ایمن` (Launches migration pipeline).
* **Secondary Target Button:** `لغو عملیات بازیابی` (Cancels import process).

---

## SECTION 12: UI Consistency Checklist

This consistency checklist provides designers and developers with a clear checklist to ensure newly built screens conform fully to the Global UI States System.

* [ ] **Design Token Conformance:** The layout contains zero hardcoded hex values, pixel measurements, or physical millisecond numbers. All visual properties reference standard tokens.
* [ ] **Single-Tier State Priority:** The screen state respects the hierarchy. It does not display a standard loading indicator if a critical PIN lockout overlay is required.
* [ ] **Logical Mirroring Support:** All margins, layouts, gestures, and chevrons adapt logically when switching to Persian (RTL). No physical direction keywords (left/right) exist in styling configurations.
* [ ] **RTL Flow Compliance:** All Persian text blocks align to the right margin of layouts, and circular or linear progress indicators flow correctly from right to left.
* [ ] **No Dead Ends Rule:** Empty, warning, and error states provide a primary call-to-action or recovery route. The user is never left on a static screen without a next step.
* [ ] **Technical Redaction:** Technical log traces, SQLite codes, or programming terms are fully hidden from user-facing screens, replaced by friendly, supportive copy.
* [ ] **Minimum Interaction Footprint:** Interactive button elements maintain a physical touch target of at least forty-eight density-independent units.
* [ ] **Accessibility Focus Lock:** Active modal dialogs programmatically trap the navigation focus, restricting keyboard or switch access users from navigating background screens.
* [ ] **Reduced Motion Support:** All looping animations or slide-up transitions disable instantly when system reduced-motion options are active.
* [ ] **Color Independence Principle:** Warning and error indicators are paired with distinct symbolic icon geometry, ensuring they remain accessible for colorblind users.

---
**End of BankYar Global UI States System Specification**
