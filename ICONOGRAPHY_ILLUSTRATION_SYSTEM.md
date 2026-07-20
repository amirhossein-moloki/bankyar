# BankYar Design System: Iconography & Illustration System Architecture (v1.0.0)

## Executive Summary
This document establishes the official **Iconography & Illustration System Architecture** for BankYar. Designed to implement the core product personality (*Stoic*, *Precise*, *Empowering*) and UX principles defined in `DESIGN_PHILOSOPHY.md` and `VISUAL_DESIGN_LANGUAGE_SPECIFICATION.md`, this architecture serves as the absolute visual and structural authority for all graphical assets beyond typography and color.

In strict adherence to BankYar’s **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets:
* **No Flutter code** is generated.
* **No SVG files** are defined.
* **No visual mockups** are created.
* **No brand colors or HEX values** are hardcoded.
* **No physical units** (such as pixels, dp, sp, or milliseconds) are utilized.
* **No development markers** (such as incomplete comments, template tags, or mock text) are allowed; all text is fully resolved.

This system resides entirely at the visual language, design system architecture, and governance level. It defines structural properties, logical behaviors, mirroring mechanics, and semantic mappings for every icon and illustration, ensuring absolute consistency across Light, Dark, High-Contrast, and future multi-platform (Android, iOS, Desktop) themes.

---

## TABLE OF CONTENTS
- [1. Icon System Philosophy](#1-icon-system-philosophy)
- [2. Illustration Philosophy](#2-illustration-philosophy)
- [3. Visual Asset Strategy](#3-visual-asset-strategy)
- [4. Financial Icon Language](#4-financial-icon-language)
- [5. Security Icon Language](#5-security-icon-language)
- [6. Banking Symbol Standards](#6-banking-symbol-standards)
- [7. Transaction Status Icons](#7-transaction-status-icons)
- [8. Notification Icons](#8-notification-icons)
- [9. Navigation Icons](#9-navigation-icons)
- [10. Action Icons](#10-action-icons)
- [11. Category Icons](#11-category-icons)
- [12. Empty State Illustrations](#12-empty-state-illustrations)
- [13. Error Illustrations](#13-error-illustrations)
- [14. Loading Illustrations](#14-loading-illustrations)
- [15. Success Illustrations](#15-success-illustrations)
- [16. Warning Illustrations](#16-warning-illustrations)
- [17. Onboarding Illustrations](#17-onboarding-illustrations)
- [18. Accessibility Icon Rules](#18-accessibility-icon-rules)
- [19. RTL Icon Considerations](#19-rtl-icon-considerations)
- [20. SVG Standards](#20-svg-standards)
- [21. Stroke Rules](#21-stroke-rules)
- [22. Fill Rules](#22-fill-rules)
- [23. Corner Style Rules](#23-corner-style-rules)
- [24. Grid Alignment](#24-grid-alignment)
- [25. Pixel Alignment](#25-pixel-alignment)
- [26. Optical Balance Rules](#26-optical-balance-rules)
- [27. Size Categories](#27-size-categories)
- [28. Color Usage Rules](#28-color-usage-rules)
- [29. Theming Strategy](#29-theming-strategy)
- [30. Dark Mode Adaptation](#30-dark-mode-adaptation)
- [31. Animation Readiness](#31-animation-readiness)
- [32. Asset Naming Convention](#32-asset-naming-convention)
- [33. Folder Organization](#33-folder-organization)
- [34. Versioning Strategy](#34-versioning-strategy)
- [35. Asset Governance](#35-asset-governance)
- [36. Quality Standards](#36-quality-standards)
- [37. Validation Checklist](#37-validation-checklist)
- [38. Anti-patterns](#38-anti-patterns)
- [39. Future Expansion Strategy](#39-future-expansion-strategy)

---

## 1. Icon System Philosophy
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

## 3. Visual Asset Strategy
The visual asset strategy outlines the lifecycle, production pipeline, and integration model for all graphical assets inside the BankYar ecosystem.
* **Mathematical Vector Base:** All icons are generated as pure mathematical vectors on a normalized reference coordinate box. This ensures infinite scaling across low-density and high-density screens.
* **Zero External HTTP Calls:** In alignment with our offline-first constraint, all icons and illustrations are bundled natively within the application binary. No external graphic networks or dynamic asset servers are contacted.
* **Multi-Theme Compilation:** Vector assets are compiled without baked-in fill or stroke colors. Instead, styles are injected dynamically by referencing the active semantic theme tokens.
* **Unified Visual Grid System:** A strict geometric layout is applied to ensure that visual weight is distributed evenly across all assets, preventing rendering shifts.

---

## 4. Financial Icon Language
Financial icons represent the primary visual vocabulary for cash flow, transactions, accounts, and monetary categories.
* **Directional Arrow Precision:** Directional transaction arrows represent flow: income points upwards and inwards, while expenses point downwards and outwards.
* **Mathematical Truth over Abstraction:** Icons represent real financial categories and actions (e.g., bank cards, cash, bank transactions) with absolute objectivity, avoiding speculative concepts.
* **Consistency in Meaning:** A financial icon mapped to a specific cash-flow state or category retains its symbolic mapping across the entire application workspace.

---

## 5. Security Icon Language
Security is a core value of BankYar's offline-first database. The security icon language builds psychological trust through structural, protective, and encryption symbols.
* **Protective Shielding:** The shield symbol represents verified data integrity, active database encryption, and platform security.
* **Lock State Clarity:** Physical locks represent localized sessions. A closed padlock signifies encrypted local databases, while an open padlock signifies authenticated read-write access.
* **Biometric Verification Patterns:** Fingerprint and scanning arcs represent localized device authentication, explicitly separated from online networks.

---

## 6. Banking Symbol Standards
Banking symbols identify account types, banks, payment channels, and financial sources.
* **Objective Formats:** Icons represent the physical format of the payment source (e.g., cards, wallets, direct wire bank accounts) rather than individual commercial bank logos.
* **Bank SMS Source Indicators:** Technical symbols represent on-device SMS parsing feeds, distinguishing raw data from user-entered accounts.
* **Neutral Weighting:** Banking symbols are kept visually neutral to avoid cluttering the transaction list, allowing the primary financial transaction values to stand out.

---

## 7. Transaction Status Icons
Transaction status icons communicate the exact state of processed, pending, or failed payments in the local ledger.
* **Completed States:** Validated, confirmed transactions are marked with a flat, circular checkmark symbol using success color tokens.
* **Heuristic Alerts:** Low-confidence automated SMS parses are highlighted with an interactive alert tag, prompting user review.
* **Failed Processes:** Invalid entries or failed database operations are marked with a circular cross symbol using error color tokens.

---

## 8. Notification Icons
Notification icons confirm background operations (such as SMS parsing or automatic database optimization) without disrupting active user tasks.
* **Minimal Geometric Footprints:** Notifications use highly compressed, outline-only visual forms to avoid cluttering status bars or alert banners.
* **Zero Promotional Badges:** Notification icons do not support decorative red dots or gamified alert bubbles, respecting the user's attention.
* **Status Updates:** Icons change state to show task progress, reverting to simple system outlines once complete.

---

## 9. Navigation Icons
Navigation icons are the primary structural guides used inside the persistent bottom tab bar, header navigation rails, and lateral menu structures.
* **Active vs. Inactive States:** Navigation icons use outline-style vectors by default. They switch to filled versions strictly when the item becomes active, providing clear, immediate visual confirmation of the user's current section.
* **Symmetrical Layout Adaptability:** Icons adapt to right-to-left Persian layouts. Navigation paths (e.g., back and forward chevrons) mirror dynamically.
* **Consistent Height Baselines:** Navigational elements align perfectly with adjacent typography baselines, ensuring horizontal continuity.

---

## 10. Action Icons
Action icons provide visual support for interactive controls, such as confirming inputs, initiating exports, or deleting invalid templates.
* **Semantic Alignment:** Icons share the exact color token of their parent button, preventing visual confusion.
* **Destructive Indicators:** Actions like deletion or rule wipes use clear, high-contrast symbols to ensure users are aware of the consequences.
* **Consistent Visual Weights:** Action icons use a uniform stroke weight token to ensure buttons across the UI look cohesive.

---

## 11. Category Icons
Category icons categorize user transactions (e.g., bills, groceries, utilities, transfers).
* **Simplified Metaphors:** Categories use highly recognizable shapes (e.g., a home outline for utilities, an envelope for bills) to minimize cognitive search times.
* **Background Isolation:** Category icons reside inside circular or rounded visual containers, separating them from adjacent transaction lists.
* **Standardized Sizing:** Every category icon uses the small icon size token, preserving vertical list spacing.

---

## 12. Empty State Illustrations
Empty state illustrations appear when screens contain no data, such as a ledger with no transactions or an empty rule feed.
* **Calm & Instructive Layout:** The illustration works alongside clear, descriptive copy and a single primary action button to guide the user forward.
* **Non-Alarmist Style:** Empty states represent natural starting points rather than system errors. They use highly muted neutral grays to keep the layout feeling clean and spacious.
* **Horizontal Balance:** The illustration is mathematically centered, maintaining visual balance on both compact and wide displays.

---

## 13. Error Illustrations
Error illustrations handle system failures, such as file import issues, database errors, or biometric lockouts.
* **Anxiety Reduction:** Error screens are designed to reduce user panic. They use structured, clean visuals and clear recovery steps.
* **Diagnostic Accuracy:** A technical symbol represents the failure type (e.g., a cylinder division line for database issues, a broken key for authentication failures).
* **Semantic Warning Fills:** Low-saturation error fills are applied programmatically to highlight the issue while keeping all diagnostic text readable.

---

## 14. Loading Illustrations
Loading illustrations represent active background processes, such as database optimization, SMS ingestion, or backup exports.
* **Skeleton Layouts:** Empty feeds use stable skeleton frames that mirror the actual content layout, preventing sudden screen shifts when data renders.
* **Smooth Infinite Motion:** Spinners or linear progress bars use continuous, linear interpolation curves to ensure smooth motion without impacting system performance.
* **Interactive Freedom:** Full-screen blocking spinners are prohibited. The user can continue navigating and interacting with other areas of the interface.

---

## 15. Success Illustrations
Success illustrations confirm major system achievements, such as completed data restoration or successful PIN setup.
* **Muted Celebrations:** Success illustrations use professional, calm symbols (e.g., a shield checkmark), avoiding childish animations like confetti bursts.
* **Self-Dismissing Timing:** Success panels dismiss themselves automatically using short timing duration tokens, returning the user to their active task with zero extra taps.
* **High Contrast:** Text labels and primary actions remain clearly readable under all lighting conditions, meeting WCAG AA standards.

---

## 16. Warning Illustrations
Warning illustrations highlight states that require user attention but do not disrupt system operations.
* **Heuristic Review Fills:** Applied to low-confidence SMS parsing results, inviting the user to verify the transaction details with a single tap.
* **Soft Amber Boundaries:** Warning areas are framed with soft amber borders, keeping the transaction legible without creating visual panic.
* **Graceful Fallbacks:** If a template cannot resolve a merchant name, the layout falls back to display the raw SMS sender ID, ensuring data is never hidden.

---

## 17. Onboarding Illustrations
Onboarding illustrations introduce the core product values during initial application launch, such as privacy-first operation and local parsing.
* **Trust-Building Visuals:** Onboarding screens use precise, professional graphics to clearly illustrate why zero network access is requested.
* **Structured Progress:** Works alongside standard layout zones, keeping all descriptive copy and navigation controls in the bottom half of the screen.
* **Perfect Scaling:** Onboarding illustrations adapt to compact, tablet, and foldable screens without clipping text or overlapping borders.

---

## 18. Accessibility Icon Rules
To ensure the interface remains accessible to all users, every icon must comply with the following rules:
* **Descriptive Semantic Labels:** All icons must include a descriptive semantic text string (e.g., `semanticsLabel: "Secure Encryption Verified"`), allowing screen readers to communicate their purpose.
* **Minimum Interactive Touch Targets:** Interactive icons must maintain a comfortable touch target envelope mapped to the standard interactive touch size token.
* **Contrast Independence:** Core informational icons must maintain a minimum contrast ratio of 4.5:1 against their backgrounds under all lighting conditions.

---

## 19. RTL Icon Considerations
Because Persian is read from right to left, directional assets must adapt automatically to mirror natural reading patterns:
* **Programmatic Vector Mirroring:** Directional navigation arrows, forward progress indicators, and text entry icons mirror horizontally in RTL layouts.
* **Static Visuals:** Universal symbols (e.g., security padlocks, credit cards, settings gears, and dials) must not mirror; they remain identical across all locales.
* **Alignment Margins:** In RTL layouts, icons paired with text are aligned logical-start (to the right of the text block), separated by an 8-unit spatial gap token.

---

## 20. SVG Standards
All vector assets are structured according to these SVG specifications:
* **Clean Vector Paths:** Paths must use continuous coordinate points with explicit start and end anchors. Unused layers, hidden groups, and duplicate nodes are removed.
* **Semantic Attribute Bindings:** Stroke and fill attributes are bound to CSS variables or platform-neutral design tokens. Hardcoded hex values are strictly prohibited.
* **Strict Grid Packaging:** SVGs are bounded by standard dimension scales (e.g., standard size token `bankyar.icon.size.md` equivalent to standard medium scale bounds) to ensure alignment.

---

## 21. Stroke Rules
To ensure all icons look cohesive, they must follow these stroke standards:
* **Uniform Stroke Weights:** Every icon must use a single stroke weight of standard weight tokens (equivalent to standard medium line weight). Combining variable line weights within a single icon is prohibited.
* **Rounded Terminals:** Outer ends and joints must use rounded terminal styles (`stroke-linecap: round`, `stroke-linejoin: round`), providing a clean, professional look.
* **Non-Scaling Strokes:** Strokes must maintain their physical width regardless of asset magnification, preventing lines from becoming too thin or too thick on high-density screens.

---

## 22. Fill Rules
Fills are used systematically to represent state changes and visual grouping:
* **Outline by Default:** Inactive bottom navigation tabs, settings options, and secondary actions must use outlined styles.
* **Filled Active States:** Active navigation tabs, selected filters, and highlighted statuses switch to filled styles to provide clear, immediate visual feedback.
* **Consistent Application:** Filled and outlined styles must never be mixed within a single list or menu; all inactive options must remain outlined.

---

## 23. Corner Style Rules
Curves soften geometric containers, helping users distinguish separate interactive cards and input fields:
* **Corner Sharp (`radius.none`):** Used for absolute fullscreen containers, status bar blocks, and layout dividing lines.
* **Corner Default (`radius.medium`):** Applied to transaction ledger cards, setting cards, and dashboard panels.
* **Corner Soft (`radius.large`):** Applied to expanded bottom sheets and modular modal dialogues, signaling container transition focus.

---

## 24. Grid Alignment
Visual elements align strictly to a unified spatial layout grid to maintain horizontal and vertical balance:
* **Unified Layout Grid:** All icons align to a standard layout grid to ensure visual balance.
* **Structural Alignments:** Container borders and structural lines align strictly to the grid margins, preventing visual drift.
* **Horizontal Centering:** Central elements inside cards align horizontally, maintaining clean reading lines.

---

## 25. Pixel Alignment
Pixel alignment ensures that all vector paths render cleanly without blurriness:
* **Integer Grid Coordinates:** Vector anchor points must align strictly to integer coordinates on the reference box, avoiding fractional values.
* **Anti-Aliasing Prevention:** Straight lines must lie precisely on the grid lines to prevent the rendering engine from creating blurry edges.
* **Uniform Spacing:** Adjacent lines must maintain standard spacing intervals to remain legible on low-resolution screens.

---

## 26. Optical Balance Rules
Because geometric and visual centers do not always match, icons are optically adjusted:
* **Visual Weight Distribution:** Icons with asymmetrical shapes (e.g., play arrows, triangles) are offset slightly to ensure they look centered inside their buttons.
* **Symmetrical Outlines:** Outward strokes are adjusted to distribute physical space evenly, preventing the icon from looking lopsided.
* **Whitespace Allocation:** White space is balanced on all sides of the vector path to ensure clean optical alignments.

---

## 27. Size Categories
All icons conform to a strict, non-negotiable sizing scale mapped to `DESIGN_TOKEN_ARCHITECTURE.md`:
* **Small (`bankyar.icon.size.sm`):** Mapped to inline category badges, table cell markers, and metadata timestamps.
* **Medium (`bankyar.icon.size.md`):** Mapped to bottom navigation tabs, settings rows, textfield anchors, and primary buttons.
* **Large (`bankyar.icon.size.lg`):** Mapped to dialog banners, success panels, and dashboard summary headers.
* **Extra Large (`bankyar.icon.size.xl`):** Mapped to empty state layouts, onboarding graphics, and error screen summaries.

---

## 28. Color Usage Rules
Color in BankYar is used strictly as an information carrier, never as a decorative filler:
* **Semantic Scale Mapping:** Icons and illustrations query semantic tokens (e.g., `bankyar.semantic.color.background`), allowing them to adapt automatically when switching themes.
* **Color Independence:** Meaning must never be conveyed solely by color. Every financial transaction amount must use explicit math symbols next to semantic color scales.
* **Contrast Requirements:** Fills and stroke colors must maintain a contrast ratio that meets WCAG AA standards.

---

## 29. Theming Strategy
Theme tokens control how entire groups of semantic tokens translate dynamically depending on the current user setting (Light, Dark, High-Contrast):
* **No Direct Raw Color Mappings:** All UI components reference semantic tokens exclusively, isolating physical palette bindings from structural layouts.
* **Dimensional Stability:** Swapping themes modifies color and border tokens, leaving sizes, margins, and spatial grid alignments completely untouched.
* **Dynamic Environment Swapping:** Remaps semantic tokens to different sets of global values instantly at runtime without altering layout code.

---

## 30. Dark Mode Adaptation
The dark theme strategy optimizes visual comfort in low-light environments, protecting users during night-time reviews:
* **Deep Grayscale Base:** The background uses deep neutral grays (`neutral.950`) to minimize eye strain and prevent pixel smearing.
* **Elevation via Opacity:** Standard shadows are ineffective against dark backgrounds. Elevation is instead communicated by applying soft white opacity overlays to container surfaces.
* **Accessible Contrast Guarantee:** Contrast ratios are verified to ensure body text and functional accents remain readable against dark backgrounds.

---

## 31. Animation Readiness
All vector assets are structured to support future functional animations:
* **Continuous Vector Paths:** Path lines must use continuous anchor points to ensure smooth, predictable motion.
* **Layered Elements:** Interactive elements (such as lock shackles, checkmarks, and progress indicators) are layered separately, allowing them to animate independently.
* **Linear Curve Transitions:** Animated states use smooth, linear curves with short durations to prevent UI lag.

---

## 32. Asset Naming Convention
To ensure consistent file structures across developer teams and future platforms, all asset file names must follow a strict, lowercase taxonomic convention:
* **Naming Schema:** `[category]_[sub_category]_[asset_name]_[state].[extension]`
* **Strict Case Rules:** Every segment must use lowercase alphanumeric characters and underscores. Hyphens, uppercase, and camelCase are prohibited.
* **Descriptor Accuracy:** Names must use precise, non-ambiguous descriptors (e.g., `icon_nav_ledger_active.svg` instead of `my_icon_v2.svg`).

---

## 33. Folder Organization
All visual assets are organized in a structured, platform-agnostic directory hierarchy:
* **Icons Directory (`assets/icons/`):** Organized into standard taxonomic subfolders (e.g., `nav/`, `financial/`, `security/`, `status/`).
* **Illustrations Directory (`assets/illustrations/`):** Organized by user states (e.g., `onboarding/`, `empty/`, `error/`, `success/`).
* **Fallback Directory (`assets/fallbacks/`):** Contains default avatar silhouettes and generic indicators.

---

## 34. Versioning Strategy
To ensure layout stability across development teams, the Iconography & Illustration System uses a strict semantic versioning protocol:
* **MAJOR (Breaking Changes):** Renaming, removing, or changing the geometry of existing icons. Triggers a major release cycle and migration guide.
* **MINOR (Additions):** Introducing new icons or illustrations to support features without affecting existing component layouts.
* **PATCH (Fixes):** Refining vector strokes or paths within an existing icon without modifying its taxonomic key or layout dimensions.

---

## 35. Asset Governance
Asset governance rules protect the design system from unstructured additions and visual inconsistencies:
* **Mandatory Token Reference:** Every icon and illustration must map to an active design token. Hardcoded visual parameters are strictly prohibited.
* **One Meaning Per Icon:** A semantic icon must serve exactly one purpose. Reusing icons for secondary, unrelated meanings is prohibited.
* **Approval Required:** Any addition of new icons or illustrations to the system requires approval from the Design System Governance Board.

---

## 36. Quality Standards
Quality standards ensure that all visual assets are technically and visually consistent:
* **Strict File Validations:** Automated scripts scan all assets before commits, verifying that files are under size limits and use clean SVG formatting.
* **Standard Viewport Mapping:** Icons are packaged on standard rectangular templates to prevent scaling distortion.
* **Pixel Grid Cleanliness:** Paths must align strictly to integer coordinates on the reference box to prevent rendering artifacts.

---

## 37. Validation Checklist
Before releasing any screen or visual asset, verify compliance against this checklist:
- [ ] Does the icon map to a semantic design token, avoiding hardcoded values?
- [ ] Is the icon paired with a descriptive label for screen readers?
- [ ] Are directional icons mirrored programmatically for RTL layouts?
- [ ] Do interactive icons maintain a comfortable touch target envelope?
- [ ] Does the asset file name comply with the lowercase taxonomy convention?

---

## 38. Anti-patterns
The following visual and interaction anti-patterns are strictly prohibited:
* **Hardcoded Styling:** Defining stroke widths, colors, or sizes directly in UI files instead of referencing design tokens.
* **Dual-purpose Icon Meanings:** Reusing a single icon for multiple, unrelated meanings (e.g., using a gears icon for both rules and settings).
* **Color as Only Indicator:** Displaying transaction credit/debit statuses or validation errors using color alone, without adding text or structural markers.
* **Playful Cartoon Illustrations:** Using childish, exaggerated cartoon illustrations that do not align with our professional, secure tone.

---

## 39. Future Expansion Strategy
As BankYar expands, the Iconography & Illustration System is built to scale:
* **Universal Portability:** The asset system uses a platform-agnostic design (SVG standard), ensuring future portability to iOS and desktop environments.
* **Multi-Brand Compatibility:** Theme tokens isolate visual styles from component logic, allowing the design system to support new visual configurations and white-label demands without changes to the core layout code.
* **Backward Compatibility:** Deprecated icons must follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing development teams with clear migration pathways between updates.

---

## Section II: Icon System Specification

This section defines the core visual, semantic, and structural standards for every icon category in BankYar. Every symbol must reside under exactly one taxonomic branch, ensuring predictable asset organization and clean code reference mappings.

### 1. Navigation Icons
* **Purpose:** Guide users through primary persistent sections (bottom bar, header rails, and menus).
* **Visual Style:** Outline-style vectors by default, switching to filled versions when selected.
* **Meaning:** Represent core application modules (Ledger, Reports, SMS Parser, Diagnostics, Settings).
* **Priority:** Critical (Level 1).
* **Consistency Rules:** Must share a uniform stroke weight token and coordinate baseline across all tabs.
* **Accessibility Notes:** Must be paired with a unique local semantic label for screen readers.
* **RTL Behaviour:** Mirror horizontally to reflect RTL reading patterns (e.g., back/forward chevrons).
* **Scalability:** Must scale smoothly from standard to large layout sizes without line distortion.
* **Animation Compatibility:** Built with layered vector lines to support smooth horizontal slide transitions.
* **Future Expansion:** Standard structural paths allow the addition of future modules (e.g., Budgeting) without altering the layout.

### 2. Financial Icons
* **Purpose:** Classify cash flow directions, account types, and payment channels.
* **Visual Style:** Clean, high-contrast mathematical symbols and direct outline vectors.
* **Meaning:** Differentiate income (`+` and upward arrow) from expenses (`-` and downward arrow).
* **Priority:** Critical (Level 1).
* **Consistency Rules:** Arrow angles must align strictly to diagonal grid layout lines.
* **Accessibility Notes:** Meaning must be clear through shape and math symbols, never relying on green/red color alone.
* **RTL Behaviour:** Directional arrows mirror horizontally to align with RTL flow.
* **Scalability:** Small size scale optimization ensures readability inside dense transaction rows.
* **Animation Compatibility:** Layered arrow paths allow subtle vertical slide animations on hover.
* **Future Expansion:** Path architecture scales to support new payment methods (e.g., contactless mobile pay) with ease.

### 3. Security Icons
* **Purpose:** Confirm data protection, active encryption, and device locking.
* **Visual Style:** Strong, solid protective outline vectors (e.g., padlocks, shields).
* **Meaning:** Closed locks signify active local database encryption (SQLCipher); open locks signify decrypted read-write sessions.
* **Priority:** High (Level 2).
* **Consistency Rules:** Padlock shackle curvature must match the standard border radius tokens.
* **Accessibility Notes:** Pair with high-contrast success and alert colors to reinforce security states.
* **RTL Behaviour:** Standard security padlocks do not mirror; they remain identical across all locales.
* **Scalability:** Optimized for large scales in authentication screens and small scales in list footers.
* **Animation Compatibility:** Shackle paths are isolated to allow smooth rotational opening animations.
* **Future Expansion:** Scalable layout supports biometric additions (e.g., facial scan boundaries) without restructuring.

### 4. Notifications Icons
* **Purpose:** Confirm background operations (e.g., SMS captured, backup success) inside notification drawers.
* **Visual Style:** Muted, highly simplified outline shapes with low geometric weight.
* **Meaning:** Communicate automatic background tasks that do not disrupt the active screen workspace.
* **Priority:** Medium (Level 3).
* **Consistency Rules:** Must use the small icon size token to fit comfortably inside system bars.
* **Accessibility Notes:** Notifications must include rich semantic descriptors for external screen readers.
* **RTL Behaviour:** Progress lines and incoming symbols mirror to slide from start (right) to end (left).
* **Scalability:** Muted layouts prevent visual clutter on small, high-density notification bars.
* **Animation Compatibility:** Line components support subtle opacity fades to indicate active ingestion.
* **Future Expansion:** Generic status slots support future background tasks (e.g., scheduled sync) without rework.

### 5. Action Icons
* **Purpose:** Assist interactive buttons, forms, and dialog operations (e.g., Add, Edit, Delete, Close).
* **Visual Style:** Linear mathematical shapes (plus, edit stylus, trash bin, confirmation check, cross).
* **Meaning:** Represent user triggers for modifying, saving, or deleting local files and rules.
* **Priority:** High (Level 2).
* **Consistency Rules:** Align logical-start inside button containers, maintaining consistent gutters.
* **Accessibility Notes:** Minimum interactive touch target envelopes are enforced across all actions.
* **RTL Behaviour:** Actions mirror logical coordinates automatically when changing languages.
* **Scalability:** Muted visual weights prevent actions from competing with text buttons.
* **Animation Compatibility:** Checkmarks and delete lids support rotational shifts on touch interactions.
* **Future Expansion:** Action sets scale to support batch actions (e.g., multi-row selection checks).

### 6. Settings Icons
* **Purpose:** Organize configuration subpanels, theme switches, and regional adjustments.
* **Visual Style:** Single mechanical gear, half-shaded circular theme disk, or line globe symbols.
* **Meaning:** Represent advanced settings, localized rules, and offline data management.
* **Priority:** Medium (Level 3).
* **Consistency Rules:** Kept strictly outlined to maintain layout clarity inside lists.
* **Accessibility Notes:** Labels describe the settings category explicitly, avoiding technical jargon.
* **RTL Behaviour:** Symmetrical symbols (gears, globes) do not mirror; list indicators mirror natively.
* **Scalability:** Scale standardly to match list item heights, preserving clean horizontal baselines.
* **Animation Compatibility:** Gears support continuous linear rotation during active system checks.
* **Future Expansion:** Clear taxonomic division allows settings expansion without cluttering menus.

### 7. Search Icons
* **Purpose:** Trigger and clear database lookups for transactions and custom rules.
* **Visual Style:** Angular magnifying glass, circular cross delete button.
* **Meaning:** Active text entry trigger and query clearing control.
* **Priority:** High (Level 2).
* **Consistency Rules:** Center vertically within the search input field bounding box.
* **Accessibility Notes:** Search buttons must be announced as text input search triggers.
* **RTL Behaviour:** The magnifying handle mirrors horizontally to align with RTL text starts.
* **Scalability:** Standard medium sizing ensures comfortable click regions inside headers.
* **Animation Compatibility:** Cross button fades in smoothly when search text is entered.
* **Future Expansion:** Interface scales to support advanced, multi-parameter search chips.

### 8. Statistics Icons
* **Purpose:** Represent spending trends, summaries, and financial reports.
* **Visual Style:** Flat bar-charts, line-graphs, or pie slice outline metaphors.
* **Meaning:** Financial analysis, category distribution, and trend summaries.
* **Priority:** High (Level 2).
* **Consistency Rules:** Charts are kept simple and linear, avoiding heavy, complex 3D graphics.
* **Accessibility Notes:** Visual charts are accompanied by tabular screens with full text labels.
* **RTL Behaviour:** Time-series charts progress chronologically from right to left in RTL.
* **Scalability:** Optimized for large dashboard banners and compact detail cards.
* **Animation Compatibility:** Charts animate with smooth vertical bar slide-ins on display.
* **Future Expansion:** Design scales to support multi-account comparisons and advanced analytics.

### 9. Backup Icons
* **Purpose:** Manage on-device secure database exports.
* **Visual Style:** Circular clockwise arrow surrounding a flat document outline.
* **Meaning:** Local encrypted database export and storage operations.
* **Priority:** Critical (Level 1).
* **Consistency Rules:** Shared visual weight matches settings row icons.
* **Accessibility Notes:** Inform the user clearly of local file destinations.
* **RTL Behaviour:** Arrow points clockwise, maintaining a universal direction across all locales.
* **Scalability:** Mapped to standard settings sizes to maintain neat layout lines.
* **Animation Compatibility:** Dynamic circular path rotates during active local file writes.
* **Future Expansion:** Scalable model supports multi-profile backups in future editions.

### 10. Restore Icons
* **Purpose:** Manage on-device database imports.
* **Visual Style:** Circular counter-clockwise arrow surrounding a flat document outline.
* **Meaning:** Local encrypted database restoration and file validation.
* **Priority:** Critical (Level 1).
* **Consistency Rules:** Pair with high-priority warnings during active data overrides.
* **Accessibility Notes:** Clear labels warn that active data will be overwritten.
* **RTL Behaviour:** Arrow points counter-clockwise, representing a backward chronological restoration.
* **Scalability:** Matches backup icon size to ensure uniform list layout.
* **Animation Compatibility:** Circular path rotates counter-clockwise during file imports.
* **Future Expansion:** Architecture scales to support selective category imports.

### 11. PIN Icons
* **Purpose:** Secure localized sessions and verify authorization.
* **Visual Style:** Secure numeric grids, lock keys, or masked pass-dot grids.
* **Meaning:** Device lock screen, session authorization, and security gates.
* **Priority:** Critical (Level 1).
* **Consistency Rules:** Align strictly with screen margins to prevent off-center grids.
* **Accessibility Notes:** Grids support large touch target scaling for physical ease of use.
* **RTL Behaviour:** Numeric keypad layout remains standard; entry progress indicators flow RTL.
* **Scalability:** key shapes scale to occupy vertical screen space on varying mobile heights.
* **Animation Compatibility:** Masked pass-dots pulse subtly to confirm keyboard entry.
* **Future Expansion:** Pad layout scales to support custom-length passcodes.

### 12. Authentication Icons
* **Purpose:** Confirm localized biometric verifications (biometric fingerprint or face scanning).
* **Visual Style:** Fingerprint patterns or face frames with scan indicators.
* **Meaning:** Biometric validation, device verification, and session opening.
* **Priority:** High (Level 2).
* **Consistency Rules:** Symmetrical layout centered inside biometric bottom sheets.
* **Accessibility Notes:** Biometric prompts provide immediate fallback to manual PIN input.
* **RTL Behaviour:** Fingerprint lines are symmetrical and do not mirror; scan lines follow RTL paths.
* **Scalability:** Standard large size ensures easy identification during authentication prompts.
* **Animation Compatibility:** Scan line animates with a vertical linear slide curve.
* **Future Expansion:** System scales to support future device security APIs with ease.

### 13. Accessibility Icons
* **Purpose:** Highlight settings for large text, high contrast, or screen readers.
* **Visual Style:** Unified outline figure or stylized eye symbol.
* **Meaning:** Accessibility enhancements, text scaling, and low-vision tools.
* **Priority:** High (Level 2).
* **Consistency Rules:** Position at the primary level of configuration lists.
* **Accessibility Notes:** Screen readers must announce this action with highest focus.
* **RTL Behaviour:** Universal symbols are symmetrical; reading lines mirror programmatically.
* **Scalability:** Extra large sizing options ensure visibility for low-vision users.
* **Animation Compatibility:** Simple fade transitions confirm selected configuration shifts.
* **Future Expansion:** Scale to support advanced reading assistants in subsequent releases.

### 14. Help Icons
* **Purpose:** Access documentation, FAQs, and database parser tips.
* **Visual Style:** Outline circle containing a centered question mark (`?`).
* **Meaning:** In-app assistance, user guides, and parser troubleshooting.
* **Priority:** Medium (Level 3).
* **Consistency Rules:** Kept small and secondary to avoid cluttering forms.
* **Accessibility Notes:** Question mark remains clear and high-contrast in all themes.
* **RTL Behaviour:** The question mark symbol mirrors in Arabic/Persian scripts (`؟`).
* **Scalability:** Inline sizing allows help icons to sit cleanly next to form labels.
* **Animation Compatibility:** Subtle outline expand transition when tapped.
* **Future Expansion:** Paths support future contextual help bubbles on specific fields.

### 15. About Icons
* **Purpose:** Access legal information, system version details, and privacy manifestos.
* **Visual Style:** Outline circle containing a centered letter (`i`).
* **Meaning:** Information, software version details, and legal licenses.
* **Priority:** Low (Level 4).
* **Consistency Rules:** Positioned at the bottom of settings lists.
* **Accessibility Notes:** Clearly state that this is read-only application metadata.
* **RTL Behaviour:** Symmetrical circle and vertical glyph require no mirroring.
* **Scalability:** Standard medium size matches secondary setting list items.
* **Animation Compatibility:** Simple fade-out when transitioning to details sub-pages.
* **Future Expansion:** Supports expanded license lists in future builds.

### 16. System Status Icons
* **Purpose:** Report on-device database health, storage use, and parser logs.
* **Visual Style:** Heart-rate monitor pulses or clean vertical checklist indicators.
* **Meaning:** Database optimization status, log levels, and memory safety indicators.
* **Priority:** High (Level 2).
* **Consistency Rules:** Keep lines clean, matching active diagnostic dashboard grids.
* **Accessibility Notes:** Screen readers announce exact status numbers alongside icons.
* **RTL Behaviour:** Status paths and charts progress RTL.
* **Scalability:** Scales standardly to sit in top headers or settings items.
* **Animation Compatibility:** Pulse paths animate with soft linear expand curves.
* **Future Expansion:** Interface scales to support real-world memory usage charts.

### 17. Empty States Icons
* **Purpose:** Ground the vertical center of empty lists and ledger screens.
* **Visual Style:** Clean, muted outline document with disconnected lines.
* **Meaning:** Empty ledger feeds, inactive rule boards, or zero search results.
* **Priority:** Medium (Level 3).
* **Consistency Rules:** Centered horizontally within the parent layout zones.
* **Accessibility Notes:** Text captions explain clearly why the container is empty.
* **RTL Behaviour:** Symmetrical layouts centered horizontally, ensuring visual balance.
* **Scalability:** Extra large sizing provides a strong visual anchor for blank feeds.
* **Animation Compatibility:** Simple opacity fade-in when active lists are emptied.
* **Future Expansion:** Support contextual illustration shifts depending on specific empty triggers.

### 18. Future AI Features Icons
* **Purpose:** Highlight future local on-device machine-learning and rule heuristics.
* **Visual Style:** Interconnected node clusters, clean sparkle symbols, or brain-pulse outlines.
* **Meaning:** Smart automatic categorizations, localized predictive templates, and analytical tips.
* **Priority:** Medium (Level 3).
* **Consistency Rules:** Styled to match high-precision analytical indicators.
* **Accessibility Notes:** Describe the action clearly as automated system suggestions.
* **RTL Behaviour:** Node paths and progress circles mirror RTL natively.
* **Scalability:** Medium sizing allows placement inside header action lists or list items.
* **Animation Compatibility:** Nodes pulse softly during active background heuristics.
* **Future Expansion:** Adapt to represent advanced, on-device prediction models as features roll out.

---

## Section III: Illustration System Specification

This section defines visual standards for onboarding, fallback visuals, empty feeds, and system alerts. Illustrations must use geometric abstraction and low-saturation grayscale colors to maintain a professional, secure tone.

### 1. Onboarding Guidelines
* **Target Scenario:** First launch screens introducing local privacy, secure on-device parsing, and automated bank categories.
* **Visual Standards:** Clean device outline framed by a solid protective shield. Disconnected network lines highlight our offline-first architecture.
* **Tone:** Professional, calming, and highly secure.

### 2. No Data Guidelines
* **Target Scenario:** The main transaction ledger is empty, with no records parsed from SMS messages.
* **Visual Standards:** Outline document containing empty text baselines, centered horizontally.
* **Tone:** Reassuring, helpful, and non-alarmist.

### 3. No Search Result Guidelines
* **Target Scenario:** Active ledger searches or template filtering yields zero results.
* **Visual Standards:** Large magnifying glass looking over empty rows of dashed dots.
* **Tone:** Calm, clear, and direct.

### 4. Offline Mode Guidelines
* **Target Scenario:** Reassuring the user that offline-first operation is active and secure.
* **Visual Standards:** Symmetrical globe outline overlaid with a prominent, secure local padlock.
* **Tone:** Confident, quiet, and trustworthy.

### 5. Permission Required Guidelines
* **Target Scenario:** Application requires access to SMS logs to parse banking notifications.
* **Visual Standards:** Message envelope accompanied by a subtle lock key indicator.
* **Tone:** Objective, instructive, and trust-building.

### 6. Database Error Guidelines
* **Target Scenario:** Failures during on-device database imports or file decryption.
* **Visual Standards:** Vault door cylinder divided by a prominent visual warning triangle.
* **Tone:** Diagnostic, secure, and helpful.

### 7. Backup Success Guidelines
* **Target Scenario:** Successful database export to a secure local file.
* **Visual Standards:** Document icon containing a centered checkmark inside a protective shield.
* **Tone:** Confident, supportive, and clean.

### 8. Restore Success Guidelines
* **Target Scenario:** Successful restoration of all ledger transactions from an encrypted local backup.
* **Visual Standards:** Solid storage vault with a checkmark on the door.
* **Tone:** Reassuring, successful, and professional.

### 9. Unexpected Error Guidelines
* **Target Scenario:** General system failures or unparsed SMS template formats.
* **Visual Standards:** High-contrast warning circle with clear recovery action steps.
* **Tone:** Direct, helpful, and calm.

### 10. Maintenance Guidelines
* **Target Scenario:** Automated on-device database optimizations and index rebuilds.
* **Visual Standards:** Linear gear systems aligning with horizontal layout baselines.
* **Tone:** Technical, precise, and quiet.

### 11. Future Features Guidelines
* **Target Scenario:** Previewing upcoming advanced local analytics and local prediction engines.
* **Visual Standards:** Symmetrical sparkle clusters framed by precise geometric layout guides.
* **Tone:** Inspiring, minimal, and clean.

---

## Section IV: Asset Taxonomy & Naming Standards

### 1. Asset Naming Convention
To ensure consistent file structures across developer teams and future platforms, all asset file names must follow a strict, lowercase taxonomic convention:

```
[category]_[sub_category]_[asset_name]_[state].[extension]
```

#### Taxonomy Rules
* **Strict Case Rules:** Every segment must use lowercase alphanumeric characters. Separation is handled strictly by underscores. No uppercase, camelCase, or hyphens are allowed.
* **Descriptor Accuracy:** Names must use precise, non-ambiguous descriptors (e.g., `icon_nav_ledger_active.svg` instead of `my_icon_v2.svg`).

#### Examples
* `icon_nav_ledger_default.svg`
* `icon_nav_ledger_active.svg`
* `icon_status_failed.svg`
* `illustration_empty_ledger.svg`
* `illustration_success_setup.svg`

### 2. Folder Organization
All visual assets are organized in a structured, platform-agnostic directory hierarchy:

```
assets/
  ├── icons/
  │   ├── nav/
  │   │   ├── icon_nav_ledger_default.svg
  │   │   └── icon_nav_ledger_active.svg
  │   ├── financial/
  │   │   ├── icon_financial_income_default.svg
  │   │   └── icon_financial_expense_default.svg
  │   ├── security/
  │   │   └── icon_security_lock_default.svg
  │   └── status/
  │       ├── icon_status_completed_default.svg
  │       └── icon_status_failed_default.svg
  ├── illustrations/
  │   ├── onboarding/
  │   │   └── illustration_onboard_privacy.svg
  │   ├── empty/
  │   │   └── illustration_empty_ledger.svg
  │   └── error/
  │       └── illustration_error_database.svg
  └── fallbacks/
      ├── fallback_avatar_default.svg
      └── fallback_chart_default.svg
```

---

## Section V: Governance & Quality Rules

### 1. Asset Governance
This section defines the mandatory operational lifecycle and rules for adding, reviewing, and deprecating visual assets:
* **Approval Workflow:** Proposing a new asset requires submitting a formal design request to the Governance Board. The proposal must document the semantic token mapping, the exact target screens, and provide proof of WCAG AA compliance.
* **Version Control:** Assets are checked into version control using our semantic naming convention. Vector modifications trigger minor or patch version increments based on their visual impact.
* **Deprecation Policy:** Deprecated assets follow a standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`). Deprecated files remain in the codebase for a single release cycle, during which developers must migrate all references.
* **Review Process:** The Design System team reviews all additions. Automated scripts run as pre-commit hooks, validating assets against stroke rules, sizing scales, and name structures.
* **Accessibility Validation:** All new icons must be tested to ensure they maintain a minimum contrast ratio of 4.5:1 against the active theme backgrounds.
* **Quality Assurance:** Assets are verified to ensure that vector paths contain zero overlapping lines, use integer coordinates, and align perfectly with the grid.

### 2. Validation Checklist
Before releasing any screen or visual asset, verify compliance against this checklist:
- [ ] Does the icon map to a semantic design token, avoiding hardcoded values?
- [ ] Does the icon serve a clear functional purpose, avoiding pure decoration?
- [ ] Is the icon paired with a descriptive label for screen readers?
- [ ] Does the icon maintain a minimum contrast ratio of 4.5:1 against its background?
- [ ] Are directional icons mirrored programmatically for RTL layouts?
- [ ] Do interactive icons maintain comfortable touch targets?
- [ ] Does the asset file name comply with the lowercase taxonomy convention?

---

## Section VI: Accessibility Matrix

The following matrix maps WCAG AA accessibility requirements directly to our iconography and illustration standards:

| Accessibility Target | WCAG AA Requirement | Design System Rule |
| :--- | :--- | :--- |
| **Visual Legibility** | Minimum 4.5:1 contrast ratio for graphical controls | Icons must map to active semantic tokens (`bankyar.semantic.icon.primary`), allowing them to adapt automatically when switching themes. |
| **Color Independence** | Meaning must not be conveyed by color alone | Financial cash flow must use explicit mathematical symbols (`+` / `-`) next to directional arrows. Warnings must use distinct shapes. |
| **Touch Usability** | Minimum interactive touch targets of 48 units | Interactive icons must use symmetrical padding to meet the minimum touch target envelope without distorting the vector. |
| **Screen Reader Support** | Accessible text alternatives for visual content | Every icon and illustration must include a descriptive semantic label (e.g., `semanticsLabel: "Locked Security State"`). |
| **Cognitive Simplicity** | Minimize visual clutter and cognitive search times | Icons must use highly recognizable shapes (e.g., home for utility bills) to help users scan transaction feeds. |

---

## Section VII: Future Expansion Strategy

As BankYar expands, the Iconography & Illustration System is built to scale:
* **Universal Portability:** The asset system uses a platform-agnostic design (SVG standard), ensuring future portability to iOS and desktop environments.
* **Multi-Brand Compatibility:** Theme tokens isolate visual styles from component logic, allowing the design system to support new visual configurations and white-label demands without changes to the core layout code.
* **On-Device Machine Learning (ML) Visualization:** Ready to scale with advanced ML predictors and automated SMS categorization engines.

---
**End of Document**
