# BankYar Visual Design Language Specification

## Executive Summary

This document establishes the official and authoritative Visual Design Language Specification for the BankYar ecosystem. BankYar is an offline-first, privacy-first personal finance platform designed specifically for the Android platform, with planned future expansions to iOS and desktop systems. Natively targeting the Persian language (RTL) and operating under absolute on-device security boundaries with zero network permission, the visual presentation of BankYar must evoke uncompromising trust, professional rigour, and high-precision clarity.

This specification serves as the absolute visual and structural directive for all product managers, UI/UX designers, frontend architects, quality assurance engineers, and automated AI code-generation agents. It defines the visual identity, spatial rules, typographic parameters, color semantics, elevation structures, motion rules, and interface languages before any screen layout is implemented.

This document is entirely platform-independent, framework-agnostic, and contains:
- Zero hardcoded hex color values.
- Zero physical design units (such as pixels, dp, or sp).
- Zero duration units (such as milliseconds or seconds).
- Zero code framework constructs (such as Flutter Widgets or classes).
- Zero development markers or templates.

Every visual interface in BankYar must be composed strictly by referencing the design tokens and structural rules defined herein.

---

## 1. Brand Personality

The brand personality of BankYar represents the core identity and behavioral traits of the product. It is defined by three distinct dimensions:

* **The Stoic Vault:** Silent, completely secure, and enduring. The product does not demand user attention. It has no promotional pop-ups, gamified notifications, or marketing alerts. It sits quietly in the background, serving as a reliable on-device financial vault.
* **The High-Precision Analyst:** Objective, scientific, and mathematically precise. Information is presented with zero emotional bias, using exact, clear figures and structured tables. It treats financial records with complete correctness.
* **The Calm Companion:** Peaceful, stress-reducing, and helpful. Facing financial SMS notifications can evoke user anxiety. The brand visual personality uses low-saturation, structured layouts to present cash flow in a calm, structured format, converting chaotic SMS messages into a peaceful financial harbor.

---

## 2. Brand Values

BankYar's brand identity is anchored on four non-negotiable brand values:

* **Absolute Privacy:** Data never leaves the device. The visual language must reflect this by avoiding references to cloud synchronization, external profiling, or remote servers. It must explicitly reassure users of their complete ownership of data via clear local markers.
* **Surgical Clarity:** Financial information must be legible at a single glance. Visual layouts must prioritize clear data structures, using typography and high-contrast spacing over decorative artwork.
* **Ergonomic Trust:** Interaction paradigms must feel safe and predictable. Destructive actions require secondary confirmations, and interfaces are designed to minimize accidental touch triggers.
* **Inherent Accessibility:** The product belongs to all users. Visual choices must support high readability under extreme conditions (low-spec screens, direct sunlight, high system font-sizes) without compromising layout integrity.

---

## 3. Emotional Design Goals

The BankYar visual and interactive experience is engineered to evoke six key emotional states in the user:

* **Trust & Safety:** Confident that their sensitive SMS messages and bank balances are stored securely in a local, encrypted, on-device vault.
* **Calm & Peace:** Relief from financial stress, achieved through a clean, spacious, and non-intrusive dashboard interface.
* **Clarity & Control:** Direct understanding of where their money flows, with instant categorization and zero cognitive complexity.
* **Speed & Responsiveness:** Direct confirmation of actions under sub-one-hundred-unit timelines, ensuring the application feels immediate.
* **Reliability:** Confident that the app functions perfectly offline, under any battery state, with zero dependency on network connection.
* **Dignity & Respect:** A premium, professional, and mature user experience that respects their time, attention, and native Persian language heritage.

---

## 4. Design Philosophy

The core design philosophy of BankYar is **Content as Interface**.

We reject decorative elements that do not serve an informational purpose. Traditional aesthetic markers, such as deep 3D gradients, glowing box shadows, rounded floating visual shapes, and complex loading spinner shapes, are excluded. Instead, the raw financial transaction data (Amounts, Counterparties, Timestamps, and Status Tags) defines the spatial structure, layout boundaries, and visual focus of the screen.

The layout adapts dynamically to wrap real-world Persian banking SMS text strings without clipping, preserving the literal truth of the communication. Visual contrast is reserved strictly for primary metrics (such as net cash balance) and primary navigation targets.

---

## 5. Visual Identity

The Visual Identity of BankYar represents the system's graphic language, built around high-density typography, structured geometric layout grids, and flat surface layers.

* **Geometric Rigor:** Every component and card aligns strictly to a unified spatial layout grid. Structural lines and borders are straight, using precise curves only to soften containment boundaries.
* **Abstract Symbolism:** We avoid detailed realistic illustrations. Graphics are strictly abstract, flat, and high-contrast, designed to symbolize security, financial growth, or structural organization.
* **Bespoke Persian Adaptation:** The visual identity is optimized around the baseline and vertical height demands of Persian character curves. Text alignments, card flows, and reading patterns flow natively from right to left (RTL).

---

## 6. Color Psychology

Color in BankYar is used strictly as an **information carrier, never as a decorative filler**.

We select low-saturation, highly legible color scales that correlate directly with security, financial stability, and system trust:
* **The Grounding Gray (Neutral Scale):** Establishes a highly focused, stable, and calm canvas that minimizes cognitive eye fatigue during long financial reviews.
* **The Primary Azure (Brand Scale):** Evokes stability, enterprise-grade safety, and analytical intelligence. Used exclusively for primary interactive actions and brand anchors.
* **The Wealth Green (Success Scale):** Denotes incoming cash flows (Income), verified bank balances, and validated database matches.
* **The Guarding Amber (Warning Scale):** Denotes upcoming scheduled payments, or low-confidence heuristic SMS parsing results requiring user verification.
* **The Alert Crimson (Error/Destructive Scale):** Denotes outgoing cash flows (Expenses), parsing failures, database optimization errors, or critical biometric PIN issues.

---

## 7. Color Palette Strategy

The Color Palette Strategy implements a multi-tier dependency architecture that isolates physical palette bindings from structural application layouts:

```
+--------------------------------------------------------+
|                 1. Primitive Palette                   |
|  (Abstract Grayscale, Azure, Emerald, Amber, Crimson)  |
+--------------------------------------------------------+
                           |
                           v
+--------------------------------------------------------+
|                  2. Semantic Color                     |
|  (Canvas, Surface, Text Primary, Text Secondary)       |
+--------------------------------------------------------+
                           |
                           v
+--------------------------------------------------------+
|                3. Component Override                   |
|  (Button Fill, Input Border, Dialog Backdrop)          |
+--------------------------------------------------------+
```

* **No direct raw color calls:** UI components query semantic tokens exclusively.
* **Theme Independence:** Swapping the underlying physical mapping automatically reflows the entire application theme (Light, Dark, or High-Contrast) without altering any screen layout code.

---

## 8. Semantic Color Rules

The following semantic color rules bind abstract intent to clear visual outcomes:

* **Canvas Background:** Solid, non-reflective base. It must be free of brand tints to ensure critical green/red financial states remain fully legible.
* **Surface Containers:** Flat, slightly contrasted vessels used to group adjacent information fields.
* **Primary Text:** Absolute highest contrast against its background, reserved for financial figures and section headers.
* **Secondary Text:** Medium contrast, used for transaction metadata, account origins, and timestamps.
* **Disabled States:** Low-contrast muted tones combined with soft opacity, communicating inactive interaction zones.
* **Focus Outlines:** High-contrast rings that visually highlight interactive components during keyboard, biometric, or tab navigation.

---

## 9. Typography System

The BankYar Typography System is designed to present Persian financial text with high-precision scan-readability. Typography is the primary medium of the interface, structured to guide the user's eye from high-priority amounts down to secondary transaction metadata.

* **Character Integrity:** Zero letter-spacing tracking is applied to cursive Persian scripts, ensuring baseline connection ligatures remain unbroken and highly legible.
* **Numeric Stability:** Monospace tracking is applied to Latin-character number runs (such as card numbers and transaction IDs) to ensure columns align perfectly.
* **Collision Prevention:** Minimum line-height multipliers are enforced to buffer tall Persian ascenders (such as Alef and Lam) and deep descenders (such as Ye and Re), preventing lines from overlapping in dense lists.

---

## 10. Font Scale

The abstract typographic scale utilizes logical sizes and weights to establish a clear visual hierarchy across all screens:

| Typography Classification | Size Token | Weight Token | Leading Token | Usage Context |
| :--- | :--- | :--- | :--- | :--- |
| **Display Large** | `font.size.xxlarge` | `font.weight.bold` | `font.leading.tight` | Main account balance totals, primary cash summaries |
| **Heading Medium** | `font.size.xlarge` | `font.weight.bold` | `font.leading.standard` | Screen section titles, bottom sheet headers |
| **Title Medium** | `font.size.large` | `font.weight.medium` | `font.leading.standard` | Bank counterparty names, modal title cards |
| **Body Standard** | `font.size.medium` | `font.weight.regular` | `font.leading.loose` | Transaction notes, raw parsed SMS text blocks |
| **Caption Small** | `font.size.small` | `font.weight.regular` | `font.leading.standard` | Dates, secondary metadata, transaction IDs |
| **Label Tiny** | `font.size.xsmall` | `font.weight.bold` | `font.leading.tight` | Form labels, status indicators, categories |
| **Action Button** | `font.size.medium` | `font.weight.medium` | `font.leading.tight` | Interactive buttons and main navigational tabs |

---

## 11. Spacing System

BankYar uses a logical, proportional spacing system based on a stable base unit. This system guarantees spatial balance across varying device dimensions.

* **Base Unit Spacing:** Every dimension, padding, margin, and gap is derived as a multiple of the base layout unit token.
* **Logical Spacing Definitions:** Spacing is defined using start, end, top, and bottom parameters instead of physical left/right coordinates, ensuring layouts mirror naturally in RTL locales.
* **Proportional Scaling:** Spacing tokens are scaled progressively to accommodate density requirements:
  * `spacing.xxxsmall` (Quarter base unit)
  * `spacing.xxsmall` (Half base unit)
  * `spacing.xsmall` (Single base unit)
  * `spacing.small` (One and a half base units)
  * `spacing.medium` (Double base unit)
  * `spacing.large` (Triple base unit)
  * `spacing.xlarge` (Quadruple base unit)

---

## 12. Layout Rhythm

Layout rhythm ensures vertical and horizontal balance across all screens, helping users scan complex financial data with minimal cognitive effort.

```
+-----------------------------------------------------------+
|  Screen Outer Margin (Left/Right Start/End Gaps)          |
|                                                           |
|  +-----------------------------------------------------+  |
|  | Card Element                                        |  |
|  |                                                     |  |
|  |  [Header Title]                                     |  |
|  |  =================================================  |  |
|  |  Content Element Gaps (Logical Spacer Token)        |  |
|  |  =================================================  |  |
|  |  [Financial Amount]                                 |  |
|  +-----------------------------------------------------+  |
|                                                           |
|  Vertical Card Spacing Gaps (Logical Stack Token)        |
+-----------------------------------------------------------+
```

* **Outer Margins:** Enforced consistently at the logical edges of all viewports to protect content from screen borders.
* **Component Gaps:** Internal spacing inside containers utilizes strict standard spacing tokens, preventing adjacent data fields from merging.
* **Vertical Stack Rhythm:** Lists and cards are stacked vertically using standard vertical spacers, creating a predictable visual grid as the user scrolls.

---

## 13. Elevation System

In alignment with our minimal and flat design philosophy, elevation in BankYar does not rely on heavy 3D drop shadows. Instead, depth is communicated strictly through surface color variations and subtle borders.

* **Layer 0 (Canvas):** The base application canvas, representing the lowest logical depth.
* **Layer 1 (Surface Default):** Standard cards and listing panels that sit flat on the canvas.
* **Layer 2 (Surface Raised):** Floating action modules, bottom sheets, and sticky headers. Deeper contrast boundaries separate this layer from underlying lists.
* **Layer 3 (Surface Overlay):** Biometric lockout screens and modal dialogues. Uses high-contrast scrim filters to temporarily obscure Layer 0-2 content.

---

## 14. Shadow Language

For situations where physical separation is necessary (such as floating actions or high-priority bottom sheets), the shadow language uses a highly controlled, ambient styling:

* **Monochromatic Grayscale:** Shadows must be derived exclusively from the neutral grayscale palette. Brand-colored or neon shadows are prohibited.
* **Subtle Diffuse Ambient:** Shadows represent highly diffused ambient occlusion, utilizing broad blur parameters and low-opacity settings.
* **No Direct Light Casts:** Avoid using sharp, direct offsets. The shadow must expand symmetrically from the container center, ensuring the component feels floating rather than cast.

---

## 15. Corner Radius System

Corner curves soften geometric containers, helping users distinguish separate interactive cards and input fields:

* **Corner Sharp (`radius.none`):** Used for absolute fullscreen containers, status bar blocks, and layout dividing lines.
* **Corner Subtle (`radius.small`):** Applied to form textfields, transaction tag chips, and small alert banners.
* **Corner Default (`radius.medium`):** Applied to transaction ledger cards, setting cards, and dashboard panels.
* **Corner Soft (`radius.large`):** Applied to expanded bottom sheets and modular modal dialogues, signaling container transition focus.
* **Corner Round (`radius.full`):** Applied exclusively to circular action buttons and search bars.

---

## 16. Border System

Borders are the primary structural tool in BankYar, replacing heavy shadows to define clear boundaries around cards, forms, and lists:

* **Hairline Separators (`border.width.thin`):** Sub-single-unit width dividers used to separate transaction items in vertical lists.
* **Standard Container Borders (`border.width.medium`):** Used to frame textfields, card boundaries, and selection chips.
* **Active Focus Borders (`border.width.thick`):** Thick boundaries applied to active text fields, focused interactive elements, or critical error alerts to draw immediate user attention.

---

## 17. Iconography Rules

Icons act as visual shorthand, supporting text labels to speed up navigation and action recognition:

* **Linear Precision:** All icons must use consistent, thin strokes with open, simplified shapes. Filled icons are reserved exclusively for active states (such as active navigation buttons).
* **Logical Directional Mirroring:** Directional icons (such as back chevrons, forward arrows, parsing progress indicators, and textfield prefixes) must mirror dynamically when switching between RTL and LTR locales.
* **Semantic Correlation:** Icons must share the identical semantic color of their adjacent text label, ensuring a unified visual hierarchy.

---

## 18. Illustration Style

To preserve a professional, mature, and clutter-free interface, BankYar restricts the use of decorative artwork:

* **Geometric Abstraction:** Illustrations must use flat, abstract geometric layouts. Character-based drawings, cartoon figures, and colorful 3D rendering are prohibited.
* **Monochromatic Themes:** Graphics are rendered using the neutral scale, with accent colors used sparingly to highlight key focal points.
* **Minimal Assets:** Reserved exclusively for onboarding flows, empty state states, and critical system errors, ensuring they do not clutter daily transactional review tasks.

---

## 19. Motion Philosophy

Motion in BankYar is used strictly to **communicate spatial relationships, confirm states, and guide user focus**.

We reject playful, slow, or purely decorative animations that delay task execution. Motion is designed to feel direct, functional, and immediate, with response times kept under tight limits. If an animation does not improve usability or ease cognitive load, it must be excluded.

---

## 20. Animation Principles

All interface animations must comply with three core principles:

* **Immediate Response:** Transition feedback must trigger immediately upon user touch (sub-one-hundred-unit response times).
* **Linear Ease Control:** Animations use clean, standard, or decelerated curves to ensure transitions start immediately and settle smoothly into their destination.
* **Spatial Logic Preservation:** Components must expand and move from their literal physical touch origins. For example, expanding a ledger card into a details inspector must animate directly from that card's screen coordinates, preserving spatial continuity.

---

## 21. Transition Rules

Transitions manage the spatial movement of screens and menus during navigation:

* **Screen Push Transitions:** When opening a detail screen (such as transaction inspector), the content slides horizontally from the logical start edge to the logical end edge, matching RTL reading patterns.
* **Bottom Sheet Transitions:** Slide vertically from the bottom edge of the screen, settling in the lower half to ensure easy one-handed reach.
* **Modal Dialog Transitions:** Fade in centrally, combined with a subtle scale expansion, drawing instant focus to the system interruption.

---

## 22. Loading Experience

Under zero-network constraints, BankYar updates data almost instantly. However, for background parsing tasks or database backup imports, the loading language remains clean and non-intrusive:

* **Stable Layout Containers:** Loading states must use stable layout outlines, preserving existing layout boundaries to prevent awkward screen shifts when data renders.
* **No Blocking Overlays:** Avoid using fullscreen blocking spinners; the user must remain free to browse and interact with other regions of the screen.
* **Linear Progress Indicators:** For multi-step tasks (such as importing CSV histories), a thin linear progress bar displays deterministic progress clearly.

---

## 23. Empty State Language

Empty screens (such as a ledger with no transaction history or a rules list with no templates) must never present blank voids. They are designed to reassure and guide the user:

* **Reassuring Clarification:** Explain clearly why the screen is empty, explicitly reassuring the user of their security and privacy boundaries (e.g., "All SMS data is stored securely on your device").
* **Single Direct Action:** Provide a single primary action button to get started (e.g., "Import SMS History" or "Create Parsing Rule").
* **Abstract Visual Anchor:** Place a flat, monochromatic icon at the vertical center of the container to ground the layout.

---

## 24. Error State Language

Error states communicate system failures or invalid inputs, helping users recover quickly and calmly:

* **Supportive Messaging:** Error messages must use plain, non-technical Persian text, explaining the issue and providing clear recovery steps.
* **Contextual Borders:** Containers with errors must be highlighted with high-contrast borders and the semantic error scale.
* **No Intrusive Interruptions:** Minor errors (such as weak regex validation) must use inline warnings, reserving fullscreen blocking modals for critical system failures (such as database decryption lockouts).

---

## 25. Success State Language

Success feedback confirms completed actions, reinforcing a sense of control and progress:

* **Self-Dismissing Overlays:** Quick success alerts must dismiss themselves automatically, returning the user to their active flow with zero extra taps.
* **Calm Confirmations:** Use soft, low-saturation success tones, avoiding neon colors or loud decorative animations.
* **Explicit Context:** State clearly what has been completed successfully (e.g., "Rule Saved" or "Database Backup Completed").

---

## 26. Warning State Language

Warnings highlight states that require user attention but do not disrupt system operations:

* **Interactive Chips:** Low-confidence SMS parses use a distinct, interactive tag chip, inviting the user to verify the transaction details with a single tap.
* **Subtle Visual Cues:** Warnings use soft amber boundaries and status tags, keeping the transaction legible without creating visual panic.
* **Graceful Fallbacks:** If a template cannot resolve a merchant name, the warning state displays the raw SMS sender ID, ensuring data is never hidden.

---

## 27. Information State Language

Information alerts provide tips and guidance without interrupting active workflows:

* **Inline Help Banners:** Integrated directly into lists and forms, utilizing soft blue canvas scales.
* **Dismissible Design:** All informational cards must include a clear, logical close button, allowing users to hide the help tip once read.
* **Purely Descriptive Copy:** Avoid promotional language, keeping the text concise, helpful, and objective.

---

## 28. Card Language

Cards are the primary visual container in BankYar, used to group related transactional metadata:

* **Absolute Flatness:** Cards sit flat on the base canvas background, defined by subtle borders instead of heavy shadows.
* **Inner Structural Margins:** Maintain consistent internal spacing around content to ensure card boundaries do not squeeze typography.
* **Clean Typographic Layout:** Organize data hierarchically: place financial amounts at the visual start edge, with merchant names and timestamps aligned logically.

---

## 29. List Language

Lists display chronological ledger transactions and parsed templates:

* **Vertical Scrolling Efficiency:** Lists scroll vertically, preserving a consistent visual grid as elements move.
* **Subtle Item Separators:** Adjacent list elements are separated by thin, low-contrast hairline dividers to prevent rows from visually merging.
* **No Accidental Swipes:** Swiping actions inside lists are strictly restricted. Destructive edits (such as rule deletions) must use explicit taps to prevent accidental deletions while scrolling.

---

## 30. Navigation Language

The BankYar navigation hierarchy is linear, simple, and flat, designed to reduce cognitive search paths:

```
+-----------------------------------------------------------+
|  Active Screen Workspace                                  |
+-----------------------------------------------------------+
|  Persistent Bottom Navigation Bar                         |
|  [Ledger Tab]  [Analytics Tab]  [Rules Tab]  [Settings]   |
+-----------------------------------------------------------+
```

* **Flat Linear Hierarchy:** Primary screens are accessible via a persistent bottom navigation bar. Deep nesting is prohibited, with sub-pages limited to a maximum depth of one layer.
* **Predictable Bottom Sheets:** Configuration settings and categorization flows expand as bottom sheets, keeping controls within comfortable reach of a single thumb.
* **Standard Back Actions:** The system back gesture or tap always returns the user to their immediate previous screen.

---

## 31. Surface Hierarchy

The surface hierarchy defines the spatial depth relationships of interface elements:

| Depth Level | Layer Name | Token Reference | Visual Presentation | Interaction Focus |
| :--- | :--- | :--- | :--- | :--- |
| **Level 0** | Base Canvas | `color.canvas` | Solid gray background, zero shadows | Scrollable background area |
| **Level 1** | Standard Cards | `color.surface.default` | Flat panels, thin borders | Read-only ledger rows |
| **Level 2** | Interactive Controls | `color.surface.raised` | Slightly elevated, subtle shadow | Form textfields, active chips |
| **Level 3** | Modal Sheets | `color.surface.overlay` | High elevation, scrim background | PIN locking screens, dialog prompts |

---

## 32. Accessibility Color Rules

To protect low-vision, high-fatigue, and color-blind users, BankYar enforces strict WCAG AA contrast rules:

* **Rigorous Contrast Ratios:** All body text and functional icons must maintain a minimum contrast ratio of 4.5:1 against their active background states. Large displays (over 18pt) must maintain a minimum contrast ratio of 3:1.
* **Color Independence:** Meaning must never be conveyed solely by color. Every financial transaction amount must use explicit math symbols (e.g., `+` or `-`) next to semantic color scales.
* **Dynamic Scale Protection:** Text background containers must expand dynamically, preventing text from overlapping or clipping when system-level text magnification is increased.

---

## 33. RTL Visual Principles

BankYar is designed RTL-first, ensuring layouts flow naturally for Persian-speaking users:

* **Mirrored Layout Flows:** Chronological lists, forms, and chevrons slide and align from right to left by default.
* **Logical Spacing Alignments:** Layouts use start and end parameters instead of left and right coordinates, ensuring margins adapt automatically when switching languages.
* **Persian Typographic Adaptation:** Layout structures use custom vertical spacing boundaries to accommodate the baseline and height requirements of Persian font characters.

---

## 34. Dark Theme Strategy

The Dark Theme strategy optimizes visual comfort in low-light environments, protecting users during night-time analytical reviews:

* **Deep Grayscale Base:** The background uses deep neutral grays (`neutral.950`) to minimize eye strain.
* **Accessible Contrast:** Contrast ratios are verified to ensure body text and functional accents remain readable against dark backgrounds.
* **Elevation via Opacity:** Instead of heavy shadows, elevation in the dark theme is communicated by applying soft white opacity overlays to container surfaces.

---

## 35. Light Theme Strategy

The Light Theme strategy provides clean, high-contrast readability under bright lighting conditions (such as direct sunlight):

* **Pure Neutral Canvas:** The background uses light gray scales (`neutral.50`), maintaining a clean, spacious layout.
* **Crisp Card Boundaries:** Cards are defined by thin, medium-contrast borders (`neutral.300`), keeping layouts flat and tidy.
* **Highly Legible Typography:** Text uses deep neutral grays (`neutral.950`), providing maximum typographic contrast.

---

## 36. Future Theme Expansion

To support white-label deployments or future brand requirements, the design system architecture decouples visual tokens from layout logic:

* **Decoupled Theme Schemas:** Theme definitions are stored as platform-agnostic JSON schemas. Component layouts query logical tokens, which resolve their physical values based on the active theme.
* **Unified Component Logic:** Swapping themes modifies color and border tokens, leaving sizes, margins, and spatial grid alignments completely untouched.
* **Standard Token Suffixes:** All future theme expansions must use our standard naming taxonomy, ensuring long-term consistency.

---

## 37. Visual Consistency Rules

To prevent "visual debt" and protect the integrity of the design system, BankYar enforces strict consistency rules:

* **Mandatory Token Usage:** Every color, spacing margin, border, corner curve, and typography style must reference an active design token. Hardcoded visual values are prohibited.
* **One Purpose Per Token:** A semantic token must serve exactly one purpose. Reusing semantic tokens for secondary meanings is prohibited.
* **Component-First Composition:** New screens must compose existing, documented design system components instead of introducing custom layouts.

---

## 38. Anti-patterns

The following visual and interaction anti-patterns are strictly prohibited:

* **Overloaded Dashboards:** Crowding multiple graphs, summaries, and lists onto a single view, which increases cognitive load.
* **Decorative Animations:** Slow slide transitions, spinning shapes, or playful loading screens that delay task completion.
* **Color-Only Indicators:** Relying exclusively on green or red color shifts to convey credit/debit operations, without adding math symbols or badges.
* **Un-Masked Previews:** Leaving sensitive card details and balances visible when the app transitions to the background multitasking task-switcher menu.
* **Gradients and Shadows:** Using heavy gradients, glowing shadows, or neon colors on cards and containers.

---

## 39. Governance Rules

The design system is managed under a federated governance model:

* **Federated Stewardship:** While any developer can propose a token or component update, the Design System Guild retains final architectural approval.
* **Semantic Versioning:** Token and component changes follow SemVer 2.0.0 guidelines. API updates must include clear migration guides.
* **Automated Static Validation:** Automated checkers scan all code checkins, rejecting any commits containing hardcoded values or incorrect token suffixes.

---

## 40. Validation Checklist

Before releasing any screen, layout, or feature, verify compliance against this checklist:

- [ ] Does the layout rely 100% on active design tokens, with zero hardcoded values?
- [ ] Are all sensitive balances and transaction details masked when the app transitions to the background task switcher?
- [ ] Do all text elements meet WCAG AA contrast standards against their background?
- [ ] Is meaning conveyed through text labels, badges, or shapes, rather than relying solely on color shifts?
- [ ] Do all Persian text layouts, chevrons, and forms align RTL-first by default?
- [ ] Do interactive elements avoid complex gestures, relying on clear clicks instead?
- [ ] Are all decorative gradients, 3D elements, and unnecessary animations excluded?
- [ ] Are all layout boundaries and vertical lists stacked using standard spacing tokens?
