# BankYar Design System: Iconography & Illustration System Architecture (v1.0.0)

## Executive Summary
This document establishes the official **Iconography & Illustration System Architecture** for BankYar. Designed to implement the core product personality (*Stoic*, *Precise*, *Empowering*) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this architecture serves as the absolute visual and structural authority for all graphical assets beyond typography and color.

In strict adherence to BankYar’s **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets:
* **No Flutter code** is generated.
* **No SVG files** are defined.
* **No visual mockups** are created.
* **No brand colors or HEX values** are hardcoded.

This system resides entirely at the visual language, design system architecture, and governance level. It defines structural properties, logical behaviors, mirroring mechanics, and semantic mappings for every icon and illustration, ensuring absolute consistency across Light, Dark, High-Contrast, and future multi-platform (Android, iOS, Desktop) themes.

---

## TABLE OF CONTENTS
1. [Icon Philosophy](#1-icon-philosophy)
2. [Illustration Philosophy](#2-illustration-philosophy)
3. [Visual Language Principles](#3-visual-language-principles)
4. [Icon Categories](#4-icon-categories)
5. [Navigation Icons](#5-navigation-icons)
6. [Action Icons](#6-action-icons)
7. [Financial Icons](#7-financial-icons)
8. [Status Icons](#8-status-icons)
9. [Notification Icons](#9-notification-icons)
10. [Settings Icons](#10-settings-icons)
11. [Security Icons](#11-security-icons)
12. [Search Icons](#12-search-icons)
13. [Filter Icons](#13-filter-icons)
14. [Empty State Illustrations](#14-empty-state-illustrations)
15. [Error Illustrations](#15-error-illustrations)
16. [Loading Illustrations](#16-loading-illustrations)
17. [Success Illustrations](#17-success-illustrations)
18. [Onboarding Illustrations](#18-onboarding-illustrations)
19. [Placeholder Graphics](#19-placeholder-graphics)
20. [Financial Symbol Guidelines](#20-financial-symbol-guidelines)
21. [Icon Sizing Strategy](#21-icon-sizing-strategy)
22. [Stroke Style Strategy](#22-stroke-style-strategy)
23. [Filled vs Outlined Rules](#23-filled-vs-outlined-rules)
24. [Icon Alignment Rules](#24-icon-alignment-rules)
25. [Icon + Text Rules](#25-icon--text-rules)
26. [RTL Mirroring Rules](#26-rtl-mirroring-rules)
27. [Animation Readiness](#27-animation-readiness)
28. [Accessibility Guidelines](#28-accessibility-guidelines)
29. [Color Independence](#29-color-independence)
30. [Dark Theme Compatibility](#30-dark-theme-compatibility)
31. [Semantic Mapping](#31-semantic-mapping)
32. [Token Mapping](#32-token-mapping)
33. [Asset Naming Convention](#33-asset-naming-convention)
34. [Versioning Strategy](#34-versioning-strategy)
35. [Governance Rules](#35-governance-rules)
36. [Validation Rules](#36-validation-rules)
37. [Anti-pattern Catalog](#37-anti-pattern-catalog)
38. [Review Checklist](#38-review-checklist)
39. [Migration Strategy](#39-migration-strategy)
40. [Future Evolution Strategy](#40-future-evolution-strategy)

---

## 1. Icon Philosophy
Icons in BankYar are primary information carriers. They are **functional visual signals, not decoration.**
* **Functional Utility over Decoration:** An icon is only introduced to reduce cognitive load, accelerate spatial navigation, or group visual components. If an icon does not serve an immediate functional purpose, it is excluded.
* **Meaning Communication:** Icons exist to support and clarify, never to replace, critical text descriptions. No critical financial action may rely solely on a visual metaphor.
* **Consistency over Variation:** The system enforces a single, unified geometric syntax. There are no artistic flourishes, stylistic variations, or mixed stroke weights within the active theme.
* **Recognition before Novelty:** Common, globally understood metaphors are utilized to ensure instant recognition. Culturally ambiguous or overly abstract symbols are prohibited.

---

## 2. Illustration Philosophy
Illustrations represent high-level conceptual summaries. They are used to guide users through initial setup or complex recovery steps.
* **Anxiety Reduction:** Illustrations must evoke calmness, reliability, and security. They present clear, supportive visuals that guide users through stressful states (e.g., failed parsing or empty ledger feeds).
* **Calm & Professional Tone:** Creative, overly playful, or childish illustration styles (such as flat-character cartoon aesthetics with exaggerated limbs) are strictly prohibited. The tone is sober, technical, and precise.
* **Zero Cognitive Distraction:** Illustrations occupy secondary reading space. They must never compete with primary financial text data, transaction values, or active balance charts.
* **Supportive Guidance:** Illustrations work alongside clear, actionable copy and a prominent primary action button, offering immediate paths forward.

---

## 3. Visual Language Principles
Every visual asset in BankYar is built on three visual design rules, implementing the core product personality:
1. **Geometric Precision (The "Precise" Trait):** Icons and illustration bases conform to a strict 24dp grid. Angles are mathematically calculated (using increments of 45 and 90 degrees), and curves maintain a consistent radius scale mapped from `DESIGN_TOKEN_ARCHITECTURE.md`.
2. **Minimalist Volume (The "Stoic" Trait):** Visual representations are stripped to their minimal geometric lines. Unnecessary details, complex patterns, and heavy fills are omitted to preserve reading clarity.
3. **Structured Focus (The "Empowering" Trait):** Visual assets direct focus directly to financial truths. High contrast is reserved strictly for primary indicators (e.g., active locked security states or directional transaction flow arrows), keeping secondary elements neutral.

---

## 4. Icon Categories
To simplify development and structure design, BankYar organizes all system symbols into a formal **Icon Taxonomy**:

```
                              BankYar Icon Taxonomy
                                        |
         +------------------+-----------+-----------+------------------+
         |                  |                       |                  |
   System Control      Financial & Ledger       User Context       Contextual Safety
   - Navigation Icons  - Financial Icons        - Settings Icons   - Security Icons
   - Action Icons      - Search Icons           - Notification     - Status Icons
                       - Filter Icons
```

Every icon must be categorized under exactly one taxonomic branch, ensuring predictable asset organization and clean code reference mappings.

---

## 5. Navigation Icons
Navigation icons are the primary structural guides used inside the persistent bottom tab bar, header navigation rails, and lateral menu structures.

### Design Constraints
* Navigation icons must use outline-style vectors by default. They switch to filled versions strictly when the item becomes active, providing clear, immediate visual confirmation of the user's current section.
* In RTL Persian layouts, back-navigation and forward-transition markers must be mirrored programmatically to preserve natural chronological flow.

### Core Registry
* `bankyar.icon.nav.ledger`: A flat, structured vertical sheet metaphor. Represents the main ledger and transaction list feed.
* `bankyar.icon.nav.analytics`: A clean, flat bar-chart metaphor with vertical bars of varying heights. Represents reports and spending summaries.
* `bankyar.icon.nav.rules`: A structured flowchart or interlocking gears metaphor. Represents automated SMS parsing templates and categorization rules.
* `bankyar.icon.nav.diagnostics`: A technical checklist or heart-rate monitor metaphor. Represents offline logs, database optimization, and parser debugging.
* `bankyar.icon.nav.settings`: A single, precise hexagonal mechanical gear. Represents configuration panels and backup tools.

---

## 6. Action Icons
Action icons provide visual support for interactive controls, such as confirming inputs, initiating exports, or deleting invalid templates.

### Design Constraints
* Action icons must remain visually secondary to their text labels. They align logical-start inside button wrappers, preserving RTL balance.
* Destructive actions must utilize clear, non-ambiguous visual warning metaphors, ensuring users are fully aware of the consequences.

### Core Registry
* `bankyar.icon.action.add`: A mathematically centered plus symbol (+). Represents creating a manual transaction or writing a new parsing rule.
* `bankyar.icon.action.edit`: A clean, diagonal precision stylus or pencil drawing on a flat baseline. Represents modifying category details, notes, or rules.
* `bankyar.icon.action.delete`: A flat, top-down recycling bin or trash can with a removable lid. Represents deleting custom rules or wiping unparsed SMS logs.
* `bankyar.icon.action.confirm`: A sharp checkmark. Represents saving custom categories or approving heuristic parsing results.
* `bankyar.icon.action.close`: A centered multiplication cross (×). Represents dismissing bottom sheets, closing dialog boxes, or canceling actions.

---

## 7. Financial Icons
Financial icons are the primary shorthand used to identify transaction categories, cash flow directions, and wallet formats.

### Design Constraints
* Transaction flow indicators must never rely on color alone. They must use clear, distinct directional arrow metaphors alongside color to distinguish income and expenses.
* Financial icons must maintain a highly technical, objective look, avoiding gamified or emotional styling.

### Core Registry
* `bankyar.icon.financial.income`: A bold, diagonal arrow pointing up-left (`↖` in LTR, mirrored to `↗` in RTL). Represents incoming salary, deposits, or transfers.
* `bankyar.icon.financial.expense`: A bold, diagonal arrow pointing down-right (`↘` in LTR, mirrored to `↙` in RTL). Represents retail purchases, bills, or fees.
* `bankyar.icon.financial.transfer`: Two parallel, horizontal or vertical arrows pointing in opposite directions. Represents internal transfers between accounts.
* `bankyar.icon.financial.card`: A flat, horizontal card outline with an off-center magnetic strip. Represents debit or credit cards.
* `bankyar.icon.financial.wallet`: A small, rectangular container with a curved latch. Represents cash or unparsed SMS transaction logs.

---

## 8. Status Icons
Status icons are high-level indicators that communicate system health, process states, and database validation results.

### Design Constraints
* Status icons must use a highly consistent geometric style. Warning states use flat triangles, while errors are represented by circles, ensuring clear recognition through shape alone.
* Icons must match the exact semantic state mappings defined in `SEMANTIC_COLOR_SYSTEM.md`.

### Core Registry
* `bankyar.icon.status.completed`: A solid circle containing a clear centered checkmark. Represents fully parsed transactions or successful database backups.
* `bankyar.icon.status.pending`: A flat, equilateral triangle containing a centered vertical exclamation mark (!). Represents pending actions or upcoming scheduled payments.
* `bankyar.icon.status.failed`: A solid circle containing a centered diagonal multiplication cross (×). Represents failed parsing attempts or invalid backup formats.
* `bankyar.icon.status.heuristic`: A clean, flat magnifying glass overlaid with a small warning exclamation badge. Represents parsing matches requiring manual review.

---

## 9. Notification Icons
Notification icons confirm background operations (such as SMS parsing or automatic database optimization) without disrupting active user tasks.

### Design Constraints
* Notification icons are kept minimal. They must use clean, solid geometries that do not create visual clutter inside the status bar or notification drawers.
* They must never contain promotional, gamified, or red-dot badges by default, respecting the user's cognitive boundaries.

### Core Registry
* `bankyar.icon.notification.sms`: A flat envelope icon containing a small incoming arrow. Represents a successfully captured banking SMS.
* `bankyar.icon.notification.backup`: A clean cloud icon containing an upward-pointing arrow. Represents a successful, secure offline database backup.
* `bankyar.icon.notification.optimize`: A technical checklist icon showing a checkmark. Represents completed on-device database optimizations.

---

## 10. Settings Icons
Settings icons organize configuration panels, metadata directories, and system-level toggle controls.

### Design Constraints
* Settings icons must use outline-style vectors with a highly consistent geometric weight, ensuring lists remain readable and clean.
* Icons must align logical-start in settings rows, balancing text labels in RTL layouts.

### Core Registry
* `bankyar.icon.settings.backup`: A circular, clockwise directional arrow surrounding a centered document icon. Represents backup management.
* `bankyar.icon.settings.restore`: A circular, counter-clockwise directional arrow surrounding a centered document icon. Represents data restoration.
* `bankyar.icon.settings.theme`: A clean, half-shaded circular disk. Represents theme adjustments (Light, Dark, High-Contrast).
* `bankyar.icon.settings.locale`: A flat, grid-lined globe icon with an overlaid text symbol. Represents language preferences.

---

## 11. Security Icons
Security icons identify the safety boundaries of our local storage, encryption systems, and biometric lock screens.

### Design Constraints
* Security indicators must use highly clear, non-ambiguous visual metaphors. A padlock, for example, must clearly show locked or unlocked states.
* They must use primary accent or success tokens to communicate safety and trust.

### Core Registry
* `bankyar.icon.security.lock`: A solid, closed padlock with a thick curved shackle. Represents secured databases or active screen locks.
* `bankyar.icon.security.unlock`: A solid, open padlock with a raised curved shackle. Represents unlocked sessions or verified PINs.
* `bankyar.icon.security.biometric`: A clean fingerprint diagram or face outline with scan lines. Represents biometric authentication.
* `bankyar.icon.security.shield`: A flat shield icon containing a centered checkmark. Represents active SQLCipher encryption and database integrity.

---

## 12. Search Icons
Search icons support text and template lookups, helping users find specific transaction records and rules.

### Design Constraints
* Search icons must align logical-start inside search inputs, providing a clear visual anchor for text entry.
* The search metaphor must mirror logically when switching between RTL and LTR layouts.

### Core Registry
* `bankyar.icon.search.default`: A flat magnifying glass angled down-right (mirrored to down-left in LTR). Represents active search input triggers.
* `bankyar.icon.search.clear`: A flat, solid circular button containing a centered diagonal multiplication cross (×). Represents clearing active searches.

---

## 13. Filter Icons
Filter icons organize transaction list views, allowing users to categorize records by date, value, or bank.

### Design Constraints
* Filter icons must clearly indicate active or inactive states. Active filters use filled styles or highlight chips to show that a filter is currently applied.
* They must align logical-end in input headers, leaving search controls at the start.

### Core Registry
* `bankyar.icon.filter.default`: Three parallel horizontal lines of decreasing lengths stacked vertically. Represents ledger filtering tools.
* `bankyar.icon.filter.active`: A funnel or filter icon with a small solid circle badge at the top corner. Represents applied filter states.

---

## 14. Empty State Illustrations
Empty state illustrations appear when screens contain no data, such as a ledger with no transactions or an empty rule feed.

### Design Guidelines
* Empty states must never feel like an error or a failure. They must offer supportive, clear guidance that helps the user get started.
* The illustration must align vertically centered, remaining secondary to a brief description and a clear primary action button.

```
                  Empty State Layout
             +--------------------------+
             |                          |
             |       Illustration       |  <- Minimal, non-distracting
             |                          |
             |       Title Copy         |  <- Clear, calm, and direct
             |    Descriptive Copy      |  <- Reassuring context
             |                          |
             |     [Primary Button]     |  <- Actionable path forward
             +--------------------------+
```

### Core Assets
* `bankyar.illustration.empty.ledger`: A flat, outline-style open document showing empty vertical lines. Tells the user how to grant SMS permissions or manually import their statement.
* `bankyar.illustration.empty.rules`: A clean, flat diagram of disconnected nodes with a gear. Encourages the user to create their first SMS parsing rule.

---

## 15. Error Illustrations
Error illustrations handle system failures, such as file import issues, database errors, or biometric lockouts.

### Design Guidelines
* Error illustrations must avoid alarmist, high-saturation, or threatening visuals. They are designed to reduce user anxiety by presenting a calm, structured explanation.
* They must use soft, low-saturation error fills programmatically to signal the state while keeping the text and primary recovery action readable.

### Core Assets
* `bankyar.illustration.error.database`: A flat diagram of a vault or storage cylinder with horizontal division lines. Explains how to recover from a database error or import a backup.
* `bankyar.illustration.error.auth`: A flat shield icon containing a centered multiplication cross. Appears during biometric lockout, directing the user to enter their PIN.

---

## 16. Loading Illustrations
Loading illustrations represent active background processes, such as database optimization, SMS ingestion, or backup exports.

### Design Guidelines
* Loading states must remain stable and avoid sudden layout jumps. Full-screen loading blocks are prohibited; instead, layouts must use stable skeleton frames.
* The loading motion must use simple, smooth linear interpolations that do not cause UI lag.

### Core Assets
* `bankyar.illustration.loading.skeleton`: A set of flat, grey blocks representing text lines and cards. Animates with a soft, pulsing opacity transition to indicate loading feeds.
* `bankyar.illustration.loading.ingest`: A horizontal progress bar that pulses with a linear animation curve during database imports or backups.

---

## 17. Success Illustrations
Success illustrations confirm major system achievements, such as completed data restoration or successful PIN setup.

### Design Guidelines
* Success states must use a calm, subtle design. They must avoid flashy, childish animations (like confetti bursts or trophy icons) to preserve our professional tone.
* The success panel must dismiss itself automatically within a short time, returning the user to their active task with zero extra taps.

### Core Assets
* `bankyar.illustration.success.restore`: A flat document icon showing a checkmark inside a shield. Confirms successful database restorations.
* `bankyar.illustration.success.setup`: A clean, flat vault door with a checkmark. Confirms secure PIN and biometric setup.

---

## 18. Onboarding Illustrations
Onboarding illustrations introduce the core product values during initial application launch, such as privacy-first operation and local parsing.

### Design Guidelines
* Onboarding screens must use highly precise, professional visuals that build trust. They must explicitly illustrate why zero network access is requested.
* The illustrations must align with our flat-card layout, keeping descriptions and navigation buttons in the bottom half of the screen.

### Core Assets
* `bankyar.illustration.onboard.privacy`: A clean, flat shield protecting a mobile device with zero external connection lines. Explains offline-only local storage.
* `bankyar.illustration.onboard.sms`: A flat diagram showing an incoming envelope being parsed into structured ledger cards on-device. Explains background parsing.

---

## 19. Placeholder Graphics
Placeholder graphics occupy temporary image containers while the system loads assets or categories.

### Design Guidelines
* Placeholders must use highly neutral, low-contrast grayscale colors to prevent them from drawing attention away from active elements.
* They must adapt automatically to Dark Mode and high-contrast themes.

### Core Assets
* `bankyar.placeholder.avatar`: A flat, outline circular silhouette. Used for category or bank logos when no custom icon is available.
* `bankyar.placeholder.chart`: A flat, dotted horizontal gridline block. Used while chart assets are being calculated in the background.

---

## 20. Financial Symbol Guidelines
To represent transactions with absolute mathematical rigor, financial symbols must follow these strict rules:

```
  Credit Layout:  [ Currency Label ] [ Non-breaking Space ] [ + ] [ Digit Run ]
  Debit Layout:   [ Currency Label ] [ Non-breaking Space ] [ - ] [ Digit Run ]
```

1. **Mandatory Symbols:** Income must be preceded by a plus symbol (`+`), and expenses must be preceded by a minus symbol (`-`). Currency symbols must never be omitted.
2. **Horizontal Alignment:** The symbol and the digit block must be separated by a non-breaking space, ensuring they wrap together as a unified block and preventing clipping on small devices.
3. **No Decorative Graphs:** Simple bar charts must use semantic success and error colors to represent cash flow trends directly, avoiding decorative, non-functional visual elements.

---

## 21. Icon Sizing Strategy
To maintain a consistent layout rhythm and comfortable touch targets, all icons conform to a strict, non-negotiable sizing scale mapped to `DESIGN_TOKEN_ARCHITECTURE.md`:

| Sizing Token | Dimension | Target Use Cases | Minimum Interactive Target |
| :--- | :--- | :--- | :--- |
| `bankyar.icon.size.sm` | 16dp × 16dp | Inline category badges, table cell markers, metadata timestamps | 48dp × 48dp (via touch envelope padding) |
| `bankyar.icon.size.md` | 24dp × 24dp | Bottom navigation tabs, settings rows, textfield anchors, primary buttons | 48dp × 48dp |
| `bankyar.icon.size.lg` | 32dp × 32dp | Dialog banners, success panels, dashboard summary headers | 48dp × 48dp |
| `bankyar.icon.size.xl` | 48dp × 48dp | Empty state layouts, onboarding graphics, error screen summaries | 48dp × 48dp |

---

## 22. Stroke Style Strategy
To ensure all icons feel unified, they must use a single, shared stroke style across all active themes:
* **Uniform Stroke Weight:** Every icon must use a single stroke weight of 2.0px. Combining variable line weights within a single icon is prohibited.
* **Rounded Terminals:** Outer ends and joints must use rounded terminal styles (`stroke-linecap: round`, `stroke-linejoin: round`), providing a clean, professional look.
* **Non-Scaling Strokes:** Strokes must maintain their physical width (2.0px) regardless of asset magnification, preventing lines from becoming too thin or too thick on high-density screens.

---

## 23. Filled vs Outlined Rules
Filled and outlined styles must be used consistently to represent interactive states:

```
                  Navigation Icon State Switch
  [ Ledger: Outlined (Default) ]  --->  [ Ledger: Filled (Active Tab) ]
```

1. **Default State (Outlined):** Inactive bottom navigation tabs, settings options, and secondary actions must use outlined styles.
2. **Active State (Filled):** Active navigation tabs, selected filters, and highlighted statuses must switch to filled styles to provide clear, immediate visual feedback.
3. **Selection Rule:** Filled and outlined styles must never be mixed within a single list; all inactive options must remain outlined.

---

## 24. Icon Alignment Rules
Icons must be perfectly aligned inside their parent containers to prevent visual distortion:

```
                 Perfect Icon Grid Centering
            +-----------------------------------+
            |  Active Touch Envelope (48dp)     |
            |                                   |
            |      +---------------------+      |
            |      |  Icon Vector (24dp) |      |
            |      |   (Exactly Centered)|      |
            |      +---------------------+      |
            |                                   |
            +-----------------------------------+
```

* **Grid Centering:** Vector paths must be mathematically centered within their bounding grid (e.g., 24dp).
* **Baseline Preservation:** Inline icons next to text labels must align to the text baseline rather than the container cap, ensuring clean reading lines.
* **Touch Target Envelopes:** Smaller icons (16dp) must use symmetrical padding to meet the minimum touch target requirement (48dp) without distorting the vector.

---

## 25. Icon + Text Rules
When icons and text are grouped, layouts must maintain a balanced and readable spacing:

```
  RTL Layout:  [ Text Label ] [ 8dp Gutter ] [ Icon (Start-Aligned) ]  <- Reading Flows RTL
  LTR Layout:  [ Icon (Start-Aligned) ] [ 8dp Gutter ] [ Text Label ]  <- Reading Flows LTR
```

1. **Logical Spacing:** In RTL Persian layouts, the icon must align logical-start (to the right of the text), separated by an 8dp spacing gutter.
2. **Size Proportion:** The icon size must scale proportionally with the text height (e.g., a 24dp icon paired with 16pt body copy).
3. **No Orphan Icons:** Icons must wrap together with their text labels to prevent them from becoming detached on narrow screens.

---

## 26. RTL Mirroring Rules
Directional icons must mirror programmatically to preserve natural chronological flow in Persian layouts:

### RTL Mirroring Matrix
| Icon Identifier | Default Direction (LTR) | Mirrored Direction (RTL) | Mirroring Rationale |
| :--- | :--- | :--- | :--- |
| `bankyar.icon.nav.back` | Pointing Left (`←`) | Pointing Right (`→`) | In Persian RTL, back steps move to the right. |
| `bankyar.icon.nav.forward`| Pointing Right (`→`) | Pointing Left (`←`) | Forward progress moves to the left. |
| `bankyar.icon.financial.income`| Up-Left (`↖`) | Up-Right (`↗`) | Matches the starting edge of RTL text lines. |
| `bankyar.icon.financial.expense`| Down-Right (`↘`)| Down-Left (`↙`) | Matches the trailing edge of RTL text lines. |
| `bankyar.icon.search` | Glass on Left | Glass on Right | Magnifying handle aligns with the RTL text baseline. |

### Exceptions
* **Universal Symbols:** Security padlocks, credit cards, hexagonal gears, and mechanical dials must not mirror; they remain identical across all locales.

---

## 27. Animation Readiness
To support future updates, all icons must be built to support simple, functional animations:
* **Clean Vector Paths:** Vector lines must use continuous paths with explicit start and end anchors.
* **Separated Layers:** Interactive elements (such as lock shackles or checkmarks) must be layered separately, allowing them to animate independently.
* **Zero Bounce Curves:** Animations must use smooth linear curves and short durations (under 200ms) to prevent UI lag.

---

## 28. Accessibility Guidelines
All visual assets must meet strict accessibility standards to ensure they remain usable for all users:
* **Large Touch Targets:** All interactive icons must maintain a minimum touch target of 48dp × 48dp, preventing accidental mis-taps.
* **Screen Reader Labels:** Every icon and illustration must have a clear, descriptive semantic label (e.g., `semanticsLabel: "Locked Security State"`), ensuring they are read correctly by screen readers.
* **High Contrast:** Icons must maintain a minimum contrast ratio of 4.5:1 against their backgrounds under all lighting conditions.

---

## 29. Color Independence
Meaning must never be conveyed solely by color. The visual system must always combine color with clear secondary indicators:

```
  Color-Only (Prohibited): [ Red Text Block ] Amount: -1,250,000 IRR
  Accessible (Mandatory):  [ Minus Sign (-) ] [ Downward Arrow (↓) ] [ Red Text Block ]
```

* **Income vs Expense:** Incoming and outgoing transactions must use mathematical signs (`+` / `-`) and directional arrows (`↖` / `↗`) alongside green/red colors.
* **System Statuses:** Parsing warnings and errors must use explicit text labels and distinct geometric shapes (e.g., warning triangles and error circles) alongside color.

---

## 30. Dark Theme Compatibility
All visual assets must adapt automatically to Dark Mode and low-light environments, protecting users during night-time reviews:

```
                  Theme Mapping Switch
  Light Theme:  [ Background: White ] ---> [ Stroke Color: Dark Gray ]
  Dark Theme:   [ Background: Deep Gray ] ---> [ Stroke Color: Light Gray ]
```

* **No Hardcoded Fills:** Fills and stroke colors must reference semantic tokens, allowing them to remap automatically when switching themes.
* **Accessible Contrast:** Contrast ratios must be verified to ensure icons remain clearly readable against deep gray backgrounds, meeting WCAG AA standards.
* **Deep Grayscale Canvas:** Dark backgrounds must use deep neutral grays rather than pure black, minimizing eye strain.

---

## 31. Semantic Mapping
This matrix defines how our visual asset categories map directly to functional user contexts:

| Asset Category | Target User Context | Primary UX Objective | Mapping Target |
| :--- | :--- | :--- | :--- |
| **Navigation Icons** | Persistent bottom bars, page headers | Guide users through main application sections | `bankyar.semantic.color.icon.primary` |
| **Action Icons** | Dialog actions, primary buttons | Support interactive controls and inputs | `bankyar.semantic.color.action.primary` |
| **Financial Icons**| Ledger transaction lists, trends | Classify cash flow directions and transaction types | `bankyar.semantic.color.financial.income` |
| **Status Icons** | Parsing logs, database validation | Confirm system states and database health | `bankyar.semantic.color.status.completed` |
| **Security Icons** | PIN lock screens, biometric drawers | Confirm active encryption and database safety | `bankyar.semantic.color.security.lock` |

---

## 32. Token Mapping
This matrix links our semantic icon tokens to the global primitive scales defined in `DESIGN_TOKEN_ARCHITECTURE.md`:

| Semantic Icon Token Name | Target Property | Light Theme Mapping | Dark Theme Mapping |
| :--- | :--- | :--- | :--- |
| `bankyar.semantic.icon.primary` | System navigation stroke | `bankyar.global.color.neutral.950` | `bankyar.global.color.neutral.50` |
| `bankyar.semantic.icon.secondary`| Metadata, secondary icons | `bankyar.global.color.neutral.600` | `bankyar.global.color.neutral.400` |
| `bankyar.semantic.icon.disabled` | Deactivated action stroke | `bankyar.global.color.neutral.300` | `bankyar.global.color.neutral.750` |
| `bankyar.semantic.icon.success` | Income indicator stroke | `bankyar.global.color.success.600` | `bankyar.global.color.success.400` |
| `bankyar.semantic.icon.error` | Expense indicator stroke | `bankyar.global.color.error.600` | `bankyar.global.color.error.400` |

---

## 33. Asset Naming Convention
To ensure consistent file structures across developer teams and future platforms, all asset file names must follow a strict, lowercase taxonomic convention:

```
[category]_[sub_category]_[asset_name]_[state].[extension]
```

### Taxonomy Rules
* **Strict Case Rules:** Every segment must use lowercase alphanumeric characters. Separation is handled strictly by underscores. No uppercase, camelCase, or hyphens are allowed.
* **Descriptor Accuracy:** Names must use precise, non-ambiguous descriptors (e.g., `icon_nav_ledger_active.png` instead of `my_icon_v2.png`).

### Examples
* `icon_nav_ledger_default.svg`
* `icon_nav_ledger_active.svg`
* `icon_status_failed.svg`
* `illustration_empty_ledger.svg`
* `illustration_success_setup.svg`

---

## 34. Versioning Strategy
To ensure layout stability across development teams, the Iconography & Illustration System uses a strict semantic versioning protocol:
* **MAJOR (Breaking Changes):** Renaming, removing, or changing the geometry of existing icons. Triggers a major release cycle and migration guide.
* **MINOR (Additions):** Introducing new icons or illustrations to support features without affecting existing component layouts.
* **PATCH (Fixes):** Refining vector strokes or paths within an existing icon without modifying its taxonomic key or layout dimensions.

---

## 35. Governance Rules
To prevent inconsistent icon usage and protect the design system, all design contributions must comply with the following governance rules:

1. **Mandatory Token Reference:** Every icon and illustration must map to an active design token. Hardcoded visual parameters are strictly prohibited.
2. **One Meaning Per Icon:** A semantic icon must serve exactly one purpose. Reusing icons for secondary, unrelated meanings is prohibited.
3. **Color Independence:** Meaning must never be conveyed solely by color. Visual signals must work alongside text labels, signs, or distinct shapes.
4. **No Decorative Assets:** Purely decorative icons and emoji-based UIs are prohibited; every symbol must serve an active functional purpose.
5. **Approval Required:** Any addition of new icons or illustrations to the system requires approval from the Design System Governance Board.

---

## 36. Validation Rules
The design system compiler validates all asset definitions against a strict validation matrix before deployment:

### Validation Matrix
| Rule ID | Check Target | Validation Condition | Failure Penalty |
| :--- | :--- | :--- | :--- |
| **VAL-AST-01** | Asset Naming | File names must use lowercase alphanumeric and underscores | Build Failure |
| **VAL-AST-02** | Stroke Width | SVGs must use a uniform stroke weight of 2.0px | Build Failure |
| **VAL-AST-03** | Token Mapping| Every asset must link to a valid token reference | Build Failure |
| **VAL-AST-04** | Touch Target | Interactive icons must meet the minimum 48dp target | Build Failure |
| **VAL-AST-05** | Mirroring | Directional assets must have explicit RTL mirroring rules | Compile Warning |

---

## 37. Anti-pattern Catalog
The following visual and architectural anti-patterns are strictly prohibited:

* **Hardcoded Styling:** Defining stroke widths, colors, or sizes directly in UI files instead of referencing design tokens.
* **Dual-purpose Icon Meanings:** Reusing a single icon for multiple, unrelated meanings (e.g., using a gears icon for both rules and settings).
* **Color as Only Indicator:** Displaying transaction credit/debit statuses or validation errors using color alone, without adding text or structural markers.
* **Playful Cartoon Illustrations:** Using childish, exaggerated cartoon illustrations that do not align with our professional, secure tone.
* **Unstructured Asset Naming:** Saving files with arbitrary, non-standard names (e.g., `temp_icon_1.png` or `ledgericon_new.svg`).

---

## 38. Review Checklist
Before releasing any screen or visual asset, verify compliance against this checklist:

- [ ] Does the icon map to a semantic design token, avoiding hardcoded values?
- [ ] Does the icon serve a clear functional purpose, avoiding pure decoration?
- [ ] Is the icon paired with a descriptive label for screen readers?
- [ ] Does the icon maintain a minimum contrast ratio of 4.5:1 against its background?
- [ ] Are directional icons mirrored programmatically for RTL layouts?
- [ ] Do interactive icons maintain a comfortable touch target of at least 48dp × 48dp?
- [ ] Does the asset file name comply with the lowercase taxonomy convention?

---

## 39. Migration Strategy
To transition the existing codebase to the structured Iconography & Illustration System, development teams follow a phased migration plan:

```
+------------------+     +------------------+     +------------------+
| 1. Audit & Map   | --> | 2. Asset Cleanup | --> | 3. Refactor UI   |
| (Identify raw    |     | (Rename and      |     | (Replace raw     |
| icons in code)   |     | optimize SVGs)   |     | paths with keys) |
+------------------+     +------------------+     +------------------+
```

1. **Audit & Map (Phase 1):** Identify and map all raw icon files and styling definitions in the codebase, establishing corresponding tokens in the design dictionary.
2. **Asset Cleanup (Phase 2):** Rename all SVG files to comply with the lowercase taxonomy convention, and verify stroke styles and grid alignments.
3. **Refactor UI (Phase 3):** Replace raw asset references with token paths across all UI components and page layouts, and run automation tests to verify rendering.

---

## 40. Future Evolution Strategy
As BankYar expands, the Iconography & Illustration System is built to scale:
* **Universal Portability:** The asset system uses a platform-agnostic design (SVG standard), ensuring future portability to iOS and desktop environments.
* **Multi-Brand Compatibility:** Theme tokens isolate visual styles from component logic, allowing the design system to support new visual configurations and white-label demands without changes to the core layout code.
* **Backward Compatibility:** Deprecated icons must follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing development teams with clear migration pathways between updates.

---
**End of Document**
