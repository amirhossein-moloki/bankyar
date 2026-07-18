# BankYar Design Token Architecture (v1.0.0)
## Enterprise-Grade Specification for Offline-First Secure Financial Applications

---

## Executive Summary
This document establishes the official **Design Token Architecture** for BankYar. Designed to implement the core product personality (Stoic, Precise, Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this architecture serves as the absolute single source of truth for all visual properties. Every visual style, layout structure, interaction boundary, and motion sequence must reference these architectural token schemas.

To ensure strict design consistency, accessibility, and clean architecture boundaries, **no raw, hardcoded design values are permitted anywhere in the codebase.** This architecture supports multi-theme execution (including native Dark Mode), Right-to-Left (RTL) Persian locales, variable pixel densities, accessibility high-contrast regimes, and guarantees effortless white-label portability for future iOS and cross-platform expansions.

---

## TABLE OF CONTENTS
1. [Token Philosophy](#1-token-philosophy)
2. [Token Naming Convention](#2-token-naming-convention)
3. [Token Hierarchy](#3-token-hierarchy)
4. [Global Tokens](#4-global-tokens)
5. [Semantic Tokens](#5-semantic-tokens)
6. [Component Tokens](#6-component-tokens)
7. [Theme Tokens](#7-theme-tokens)
8. [State Tokens](#8-state-tokens)
9. [Layout Tokens](#9-layout-tokens)
10. [Responsive Tokens](#10-responsive-tokens)
11. [Motion Tokens](#11-motion-tokens)
12. [Elevation Tokens](#12-elevation-tokens)
13. [Radius Tokens](#13-radius-tokens)
14. [Border Tokens](#14-border-tokens)
15. [Shadow Tokens](#15-shadow-tokens)
16. [Opacity Tokens](#16-opacity-tokens)
17. [Icon Size Tokens](#17-icon-size-tokens)
18. [Font Size Tokens](#18-font-size-tokens)
19. [Font Weight Tokens](#19-font-weight-tokens)
20. [Line Height Tokens](#20-line-height-tokens)
21. [Letter Spacing Tokens](#21-letter-spacing-tokens)
22. [Grid Tokens](#22-grid-tokens)
23. [Spacing Tokens](#23-spacing-tokens)
24. [Breakpoint Tokens](#24-breakpoint-tokens)
25. [Z-index Tokens](#25-z-index-tokens)
26. [Duration Tokens](#26-duration-tokens)
27. [Animation Curve Tokens](#27-animation-curve-tokens)
28. [Interaction Tokens](#28-interaction-tokens)
29. [Focus Tokens](#29-focus-tokens)
30. [Accessibility Tokens](#30-accessibility-tokens)
31. [Density Tokens](#31-density-tokens)
32. [RTL Tokens](#32-rtl-tokens)
33. [Dark Theme Strategy](#33-dark-theme-strategy)
34. [Future Theme Strategy](#34-future-theme-strategy)
35. [Versioning Strategy](#35-versioning-strategy)
36. [Token Governance](#36-token-governance)
37. [Migration Strategy](#37-migration-strategy)
38. [Validation Rules](#38-validation-rules)
39. [Naming Validation](#39-naming-validation)
40. [AI Usage Rules](#40-ai-usage-rules)
* [Appendix A: Token Lifecycle](#appendix-a-token-lifecycle)
* [Appendix B: Structural Token Dependency Map](#appendix-b-structural-token-dependency-map)
* [Appendix C: Best Practices](#appendix-c-best-practices)
* [Appendix D: Trade-Off Analysis](#appendix-d-trade-off-analysis)

---

## 1. Token Philosophy
Our design token philosophy is built on four core architectural tenets:
1. **Absolute Abstraction (Level-3 Isolation):** Raw values are decoupled from semantic meanings, and semantic meanings are decoupled from components. UI layers query only component or semantic keys, never raw values.
2. **Platform and Format Agnosticism:** Tokens are stored in clean, platform-neutral formats (e.g., JSON schemas) and transformed via compiler pipelines (such as Amazon Style Dictionary) into target assets (Flutter Dart, CSS, Android XML).
3. **Deterministic Scalability:** Any brand variant, high-contrast configuration, theme switch, or regional design swap is resolved purely through schema compilation without altering the layout engine or UI code.
4. **Deterministic RTL Integration:** Directional layout values (padding, margins, boundaries) are modeled logically (`start`, `end`, `inline-start`) rather than physically (`left`, `right`) to ensure flawless, crash-free RTL-first rendering.

---

## 2. Token Naming Convention
BankYar implements a strict BEM-inspired lowercase taxonomic structure. Every token key must conform to the following unified dot-notation schema:

```
[namespace].[layer].[category].[type].[item].[variant].[state]
```

### 2.1 Taxonomy Segment Reference Table
| Segment | Role | Example Keys | Constraint |
| :--- | :--- | :--- | :--- |
| `namespace` | Roots all tokens to the BankYar design system | `bankyar` | Fixed constant |
| `layer` | Identifies the token tier of abstraction | `global`, `semantic`, `component` | Strict tier selection |
| `category` | The physical property category | `color`, `space`, `font`, `radius`, `motion` | Predefined taxonomy list |
| `type` | Functional grouping within the category | `primary`, `neutral`, `border`, `interactive` | Programmatic intent descriptor |
| `item` | The specific logical structure or element | `background`, `ledger-card`, `icon-size` | No camelCase or snake_case |
| `variant` | Relative scale, intensity, or size | `xs`, `sm`, `md`, `lg`, `xl`, `heavy`, `bold` | Ordered scale value |
| `state` | The interactive state context | `default`, `hover`, `focus`, `pressed`, `disabled` | State dictionary key |

### 2.2 Naming Standards
* **No Raw Meanings:** Descriptive color names (e.g., `red`, `green`) or absolute physical sizing names (e.g., `pixels`, `dp`) are strictly prohibited in keys.
* **Lowercase Separation Only:** Only alphanumeric characters and dots are permitted in token paths. Hyphens are allowed only within an individual segment if necessary (e.g., `ledger-card`). No uppercase, camelCase, or snake_case is allowed.
* **Semantic Soundness:** No segment may contain ambiguous names (e.g., `thing`, `etc`, `custom`).

---

## 3. Token Hierarchy
To eliminate code duplication and maintain clear architectural dependencies, BankYar employs a 5-tier hierarchical design token model:

### 3.1 Hierarchy Diagram
```
+--------------------------------------------------------------+
|                     1. Global / Foundation                   |
| (Pure value aliases: colors, scales, base grids, base motion) |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                      2. Semantic Layers                      |
| (Meaningful abstractions: backgrounds, borders, text scales) |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                     3. Component Tokens                      |
| (Direct widget properties: buttons, ledger cards, fields)    |
+--------------------------------------------------------------+
            /                  |                  \
           v                   v                   v
+--------------------+ +--------------------+ +--------------------+
|  4. Theme Tokens   | |  5. State Tokens   | |  6. Layout Tokens  |
| (Light, Dark, High)| | (Pressed, Disabld) | | (RTL, Density, etc)|
+--------------------+ +--------------------+ +--------------------+
```

### 3.2 Dependency Resolution Flow
* **Global Tokens** never reference other tokens. They are pure alias wrappers for raw numbers, curves, or strings.
* **Semantic Tokens** *must* map directly to Global Tokens. They are strictly prohibited from specifying raw values.
* **Component Tokens** *must* map directly to Semantic Tokens or structural state properties.
* **Theme, State, and Layout Layers** act as contextual variant engines. They intercept and resolve the semantic-to-global maps dynamically at runtime without affecting layout logic.

---

## 4. Global Tokens
Global tokens define the absolute values of the design system. They are the base constants that are not exposed to the UI widgets directly.

### 4.1 Structural Registries (Naming-Only)
* `bankyar.global.color.gray.alpha` (The base light-neutral background scale alias)
* `bankyar.global.color.gray.beta` (Medium light-neutral surface scale alias)
* `bankyar.global.color.gray.gamma` (Medium-contrast text scale alias)
* `bankyar.global.color.gray.omega` (Maximum-contrast text scale alias)
* `bankyar.global.color.accent.primary` (Primary brand accent key)
* `bankyar.global.color.accent.secondary` (Secondary brand accent key)
* `bankyar.global.color.status.success` (Positive transactional indicator key)
* `bankyar.global.color.status.danger` (Destructive/Error indicator key)
* `bankyar.global.space.base` (Base pixel grid factor multiplier)
* `bankyar.global.font.family.primary` (RTL Persian-optimized typeface stack alias)
* `bankyar.global.font.family.mono` (Monospace mathematical spacing typeface stack alias)

---

## 5. Semantic Tokens
Semantic tokens attach functional meaning to the Global Tokens based on design intent.

### 5.1 Structural Registries (Naming-Only)
* `bankyar.semantic.color.background` (Default canvas color context)
* `bankyar.semantic.color.surface.flat` (Primary background for contained elements)
* `bankyar.semantic.color.surface.overlay` (Background for high-priority overlays, drawers)
* `bankyar.semantic.color.text.primary` (Body reading color, maximum contrast)
* `bankyar.semantic.color.text.secondary` (Auxiliary metadata, timestamps, notes)
* `bankyar.semantic.color.text.accent` (Highlight texts, balance summaries)
* `bankyar.semantic.color.border.subtle` (Hairline separator divider color)
* `bankyar.semantic.color.border.active` (Focused interactive bounds indicator)
* `bankyar.semantic.color.interactive.default` (Base fill for buttons, actionable chips)
* `bankyar.semantic.color.interactive.disabled` (Fill for deactivated interactions)
* `bankyar.semantic.color.status.success` (Valid status, positive cashflow indicators)
* `bankyar.semantic.color.status.error` (Parsing alerts, invalid fields, destructive boundaries)

---

## 6. Component Tokens
Component tokens represent the most granular tier, mapping semantic properties directly to specific interface components.

### 6.1 Structural Registries (Naming-Only)
* `bankyar.component.button.primary.fill` (Button background fill color mapped from semantic interactive)
* `bankyar.component.button.primary.label` (Button label text color mapped from semantic inverse text)
* `bankyar.component.card.ledger.background` (Financial card container fill color mapped from semantic surface)
* `bankyar.component.card.ledger.padding` (Inner spacing envelope mapped from semantic space)
* `bankyar.component.card.ledger.border` (Card boundary line mapped from semantic subtle border)
* `bankyar.component.input.text.fill` (Textfield box color mapped from semantic background)
* `bankyar.component.input.text.border.default` (Inactive textfield border mapped from semantic subtle border)
* `bankyar.component.input.text.border.active` (Focused textfield border mapped from semantic active border)

---

## 7. Theme Tokens
Theme tokens control how entire groups of semantic tokens translate dynamically depending on the current user setting (Light, Dark, High-Contrast).

### 7.1 Dynamic Resolution Engine
Themes do not introduce new tokens. Instead, they act as an environment switch that remaps semantic tokens to different sets of Global values:

```
[System Active Theme Event]
            |
            v
[Theme Resolver Context (e.g., High-Contrast Dark)]
            |
            +--> Mappings Intercepted:
            |    - bankyar.semantic.color.background => bankyar.global.color.black
            |    - bankyar.semantic.color.text.primary => bankyar.global.color.white
            v
[UI Component Layer Queries Token unchanged: bankyar.semantic.color.background]
```

* **Contract of Theme Independence:** Themes must never modify dimensional tokens (radii, grid alignments, spacing) to guarantee visual stability across visual style changes.

---

## 8. State Tokens
State tokens capture the interactive state of components during user interaction.

### 8.1 State Modification Matrix
Interactive state changes are resolved dynamically by applying multiplier modifier layers onto base component tokens:

| Interaction State | Architectural Modifier Mapping | Expected Visual Translation |
| :--- | :--- | :--- |
| `default` | Base value map (1.0 factor multiplier) | Standard component style state |
| `hover` | Shift contrast value (Contrast adjustment overlay) | Instant desktop/pointer confirmation feedback |
| `pressed` | Scale and contrast mutation (Slight compression, darker shade) | Immediate tactile feedback of user touch |
| `focused` | Highlight ring overlay (Focus ring token applied) | Keyboard/A11y navigation highlighting |
| `disabled` | Desaturate and apply opacity modifier (Reduced opacity layer) | Deactivates touch listeners and shifts elements to low contrast |
| `error` | Accent border remapping (Error color overlay) | Highlighted validation issues on input controls |

---

## 9. Layout Tokens
Layout tokens dictate the spatial scaffolding, containment alignment, and structural flow of all BankYar interfaces.

### 9.1 Layout Standards
* **Physical to Logical Mapping:** All structural layout tokens are declared using logical coordinates (`start`, `end`) to enable seamless mirroring between LTR and RTL.
* **Enforced Density Balance:** Screen padding scales dynamically, maintaining proper proportion with layout container elements.
* **Separation of Structure and Styling:** Layout grids define spacing boundaries without imposing background colors, maintaining clean component isolation.

---

## 10. Responsive Tokens
Responsive tokens adapt spacing, container scales, and visibility rules across different screen sizes.

### 10.1 Responsive Scale Schema
* `bankyar.responsive.container.width.max` (Limits container expansion on tablets to prevent wide, unreadable content lines)
* `bankyar.responsive.columns.compact` (Single-column layout scale for smartphones)
* `bankyar.responsive.columns.medium` (Double-column master-detail layout scale for foldables and small tablets)
* `bankyar.responsive.columns.expanded` (Three-column layout scale for large tablet/desktop orientations)
* `bankyar.responsive.gutter.factor` (Adaptive spacing gutter multiplier based on active screen size)

---

## 11. Motion Tokens
BankYar's animations are strictly functional, supporting system utility and data visualization. Decorative animations are entirely prohibited.

### 11.1 Motion Standards
* **Utility-Focused Transitions:** Motions must only be used to guide the user's attention (e.g., expanding a card to show transaction details).
* **Constant Spatial Logic:** Elements must transition logically along realistic spatial paths. No erratic, bouncy, or playful motions are allowed.
* **System Efficiency:** All motion sequences must have short durations and use efficient interpolation curves to prevent UI lag.

---

## 12. Elevation Tokens
Elevation tokens establish clear visual depth and structure through surface layering, helping users understand content priority without relying on heavy borders or gradients.

### 12.1 Elevation Hierarchy Table
| Elevation Token | Layer Intent | Visual Representation Strategy |
| :--- | :--- | :--- |
| `bankyar.elevation.level.zero` | Flat base canvas background | Standard background color context |
| `bankyar.elevation.level.one` | Default containment surface | Hairline border or very light ambient shadow overlay |
| `bankyar.elevation.level.two` | Sticky headers, floating quick-actions | Elevated surface tint overlay + soft ambient shadow |
| `bankyar.elevation.level.three`| Modal bottom sheets, diagnostic dialogues | High-contrast container styling + maximum shadow radius |

---

## 13. Radius Tokens
Radius tokens define the roundness of visual containers, creating a unified and professional aesthetic across the application.

### 13.1 Curvature Scale Registry
* `bankyar.radius.none` (Zero curvature, used for full-width edge-to-edge screen elements)
* `bankyar.radius.sm` (Tight curve, applied to small UI elements like checkboxes, tags, and badge indicators)
* `bankyar.radius.md` (Medium curve, applied to primary buttons, interactive chips, and textfields)
* `bankyar.radius.lg` (Large curve, applied to main financial transaction cards and ledger feeds)
* `bankyar.radius.xl` (Extra-large curve, applied to modal drawers and bottom dialog sheets)
* `bankyar.radius.full` (Perfect circular curvature, applied to avatar frames, status dots, and round icons)

---

## 14. Border Tokens
Border tokens define the thickness, style, and contrast of container boundaries, ensuring consistent grouping of information without adding unnecessary visual weight.

### 14.1 Border Specification Registry
* `bankyar.border.width.none` (No outline)
* `bankyar.border.width.thin` (Hairline separator divider, used for subtle division inside lists)
* `bankyar.border.width.thick` (Focused active outline width, used for keyboard navigation markers and active inputs)
* `bankyar.border.style.solid` (Continuous border path)
* `bankyar.border.style.dashed` (Dashed indicator line, used to identify file drop areas or empty states)

---

## 15. Shadow Tokens
Shadow tokens represent the soft, non-intrusive ambient occlusion fields that simulate physical depth in our elevation model.

### 15.1 Shadow Architecture
* **Top-Down Lighting Direction:** Ambient lighting is modeled from directly above (top-down), casting symmetrical or slightly downward offsets.
* **Strict Color Neutrality:** Shadow colors must only be derived from neutral grayscale values, never using brand colors or vivid accents.
* **Low Ambient Intensity:** Shadows must remain highly subtle, avoiding dark, high-contrast, or colored offsets.

---

## 16. Opacity Tokens
Opacity tokens establish relative hierarchy and visual state transitions, ensuring accessibility and readable layering.

### 16.1 Opacity Scale Registry
* `bankyar.opacity.opaque` (100% visibility, used for primary reading text, focus rings, and solid buttons)
* `bankyar.opacity.intense` (High visibility, used for secondary headings and body content)
* `bankyar.opacity.medium` (Medium visibility, used for tertiary text descriptions, disabled buttons, and secondary borders)
* `bankyar.opacity.light` (Low visibility, used for disabled background fills, placeholder text, and subtle card tints)
* `bankyar.opacity.translucent` (Scrim visibility, used for overlay backgrounds behind modal drawers and dialogs)

---

## 17. Icon Size Tokens
Icon size tokens regulate the physical scale of all graphical symbols across the system, ensuring standard touch zones and consistent visual hierarchy.

### 17.1 Icon Scale Registry
* `bankyar.icon.size.sm` (Compact icon scale, used inline with text captions or category tags)
* `bankyar.icon.size.md` (Standard icon scale, used inside list items, buttons, and navigation bar actions)
* `bankyar.icon.size.lg` (Large icon scale, used inside system headers and dialog banners)
* `bankyar.icon.size.xl` (Extra-large icon scale, used inside empty state illustrations and error screens)

---

## 18. Font Size Tokens
Font size tokens define our responsive typographical scale, ensuring that Persian character complex structures remain readable and clean at any magnification.

### 18.1 Typography Scale Registry
* `bankyar.font.size.xs` (Micro typography scale, used for minor metadata timestamps, labels, and status badges)
* `bankyar.font.size.sm` (Caption typography scale, used for secondary ledger descriptions)
* `bankyar.font.size.md` (Body typography scale, used for primary readable text, notes, and labels)
* `bankyar.font.size.lg` (Subtitle typography scale, used for section titles and card headings)
* `bankyar.font.size.xl` (Title typography scale, used for transaction amounts and account balance displays)
* `bankyar.font.size.xxl` (Headline typography scale, used for high-level main dashboard balance overview numbers)

---

## 19. Font Weight Tokens
Font weight tokens map standard typographical weights to Persian-optimized font attributes, supporting clear hierarchy through weight variations.

### 19.1 Font Weight Scale Registry
* `bankyar.font.weight.light` (Light typographic weight, reserved for large headline scales where strokes are thick)
* `bankyar.font.weight.regular` (Regular typographic weight, used for default body copy, description text, and SMS logs)
* `bankyar.font.weight.medium` (Medium typographic weight, used for input fields, buttons, and card labels)
* `bankyar.font.weight.bold` (Bold typographic weight, used for financial values, active status indicators, and main headings)

---

## 20. Line Height Tokens
Line height tokens define the vertical spacing between text rows, protecting against overlapping ascenders/descenders in Persian text layouts.

### 20.1 Leading Scale Registry
* `bankyar.font.leading.tight` (Low line height spacing, used for large headline scales and numerical balances)
* `bankyar.font.leading.standard` (Medium line height spacing, used for section headings and title components)
* `bankyar.font.leading.loose` (High line height spacing, used for body reading text blocks, custom notes, and raw SMS blocks)

---

## 21. Letter Spacing Tokens
Letter spacing tokens dictate text tracking. Because Persian character connections are cursive, tracking must be handled with architectural care.

### 21.1 Cursive Letter Spacing Rules
* **No Negative Persian Tracking:** Negative tracking is strictly prohibited for Persian fonts, as it breaks standard character connection baselines.
* **Monospace Exemption:** Tracking/letter spacing tokens may only be applied to non-cursive fields, such as transaction cards containing numerical values or Western reference tokens (e.g., transaction IDs, IBANs, or transaction dates).

---

## 22. Grid Tokens
Grid tokens define the responsive visual alignment system for our layouts, ensuring clean and consistent reading lines on all devices.

### 22.1 Grid Layout Metrics
* `bankyar.grid.columns` (Responsive vertical column count, dynamically adjusting based on device class)
* `bankyar.grid.margin` (Outer boundary margin, separating screen borders from outermost columns)
* `bankyar.grid.gutter` (Inter-column gutter margin, separating horizontal visual layout chunks)

---

## 23. Spacing Tokens
Spacing tokens establish the scale for all margin, padding, and gap properties, providing a consistent layout rhythm throughout the application.

### 23.1 Spacing Scale Registry
* `bankyar.space.xxs` (Micro-spacing, used for tight alignment indicators, badge dots, and status markers)
* `bankyar.space.xs` (Compact spacing, used for element gaps like inline icons next to text labels)
* `bankyar.space.sm` (Standard element gap, used for inner paragraph margins, input field labels, and list item spacing)
* `bankyar.space.md` (Default container padding, used for transaction card inner bounds and button content padding)
* `bankyar.space.lg` (Macro layout spacing, used for screen margins and separations between dashboard cards)
* `bankyar.space.xl` (Large layout spacing, used for spacing above primary bottom action buttons)
* `bankyar.space.xxl` (Extra-large spacing, used for empty-state illustration offsets and login form heights)

---

## 24. Breakpoint Tokens
Breakpoint tokens represent the screen width thresholds that trigger layout transitions across different device classes.

### 24.1 Breakpoint Threshold Registry
* `bankyar.breakpoint.compact` (Upper width boundary for standard smartphones)
* `bankyar.breakpoint.medium` (Upper width boundary for foldables and standard tablets)
* `bankyar.breakpoint.expanded` (Upper width boundary for large tablets and future desktop environments)

---

## 25. Z-index Tokens
Z-index tokens establish deterministic stack layout coordinates, ensuring consistent overlay behavior.

### 25.1 Z-Index Scale Registry
* `bankyar.zindex.base` (Ground coordinate, used for standard background elements and scroll canvases)
* `bankyar.zindex.surface` (Raised coordinate, used for default transaction cards, list elements, and structural widgets)
* `bankyar.zindex.sticky` (Fixed coordinate, used for lateral navigation rails, sticky table headers, and app bars)
* `bankyar.zindex.overlay` (Floating coordinate, used for floating quick actions, snackbar alerts, and popover actions)
* `bankyar.zindex.modal` (Sheet coordinate, used for modal sheets, biometric unlock drawers, and diagnostic dialogs)

---

## 26. Duration Tokens
Duration tokens define the physical time intervals of transition frames, supporting our *Performance-First* design principles.

### 26.1 Motion Duration Registry
* `bankyar.motion.duration.instant` (Instant feedback transition, used for simple status indicators and color swaps)
* `bankyar.motion.duration.fast` (Fast transition, used for component interactions like button presses and text focus rings)
* `bankyar.motion.duration.medium` (Balanced transition, used for modal entries, card details expansion, and drawer slides)

---

## 27. Animation Curve Tokens
Animation curve tokens dictate the velocity transitions of our motions.

### 27.1 Motion Curve Registry
* `bankyar.motion.curve.linear` (Absolute flat motion, used only for opacity fade-ins and fade-outs)
* `bankyar.motion.curve.standard` (Natural easing curve, used for spatial expansions like expanding transaction card details)
* `bankyar.motion.curve.decelerate` (Fast entry curve, used to quickly bring elements onto the screen with zero bounce)
* `bankyar.motion.curve.accelerate` (Exit acceleration curve, used to move departing elements off the screen rapidly)

---

## 28. Interaction Tokens
Interaction tokens define touch targets and gestures to ensure comfortable one-handed use.

### 28.1 Interaction Architecture
* **Minimum Interactive Touch Targets:** All touch targets must comply with accessible physical standards (e.g., minimum 48dp on Android) to prevent accidental taps.
* **One-Hand Reach Comfort Map:** Core action components (like transaction categorization lists, search buttons, and entry triggers) must reside in the lower half of the screen, ensuring comfortable one-handed reach.

---

## 29. Focus Tokens
Focus tokens specify the visual behavior of focused components, supporting screen readers and external keyboards.

### 29.1 Focus Highlight Standard
* **Accessible Outline Mapping:** Focused items must render a clear, high-contrast outline indicator using the focused border token.
* **Contrast Independence:** Focus rings must use high-contrast primary tokens to ensure visibility in both light and dark themes.

---

## 30. Accessibility Tokens
Accessibility tokens ensure the interface remains highly readable and easy to navigate for all users, implementing the core tenets of `DESIGN_PHILOSOPHY.md`.

### 30.1 Accessibility Parameters Registry
* `bankyar.accessibility.text.scale` (Typographical multiplier, dynamically scaling system typography based on system accessibility text parameters)
* `bankyar.accessibility.motion.toggle` (Motion activation status; if active, motion tokens immediately switch to instant duration)
* `bankyar.accessibility.contrast.level` (Enforced minimum contrast ratio; ensures AA or AAA standard conformance across active themes)

---

## 31. Density Tokens
Density tokens adjust component sizes based on screen real estate and active user preference.

### 31.1 Density Scale Registry
* `bankyar.density.comfortable` (Comfortable spacing layout, optimized for single-column mobile layouts)
* `bankyar.density.compact` (High density layout, optimized for analytical views, wide tables, and complex dashboard feeds)

---

## 32. RTL Tokens
RTL tokens govern the logical mirroring of coordinates, padding, gestures, and direction indicators in Persian layouts.

### 32.1 Directional Mirroring Architecture
* **Logical Margin Mapping:** Physical left/right styling is completely prohibited. Code layouts must use logical spacing structures (e.g., `start` and `end`) to guarantee proper rendering on LTR and RTL devices.
* **Mirrored Gesture Direction:** Swipe tracks, carousels, and progress bars must mirror dynamically based on active locale direction.
* **Directional Icon Mirroring:** Icons representing direction (e.g., chevron arrows and text alignment markers) must mirror dynamically based on the active language.

---

## 33. Dark Theme Strategy
The dark theme strategy overrides semantic mappings to optimize contrast and comfort in low-light environments.

### 33.1 Dark Theme Principles
* **Deep Grayscale Canvas:** The background uses deep neutral grays rather than pure black, reducing eye strain and preventing pixel smearing.
* **Elevation via Opacity:** Standard shadows are ineffective against dark backgrounds. Elevation is instead communicated by applying soft white opacity overlays to container surfaces.
* **Accessible Contrast Guarantee:** Contrast ratios must be verified to ensure body text and functional accents remain readable against dark backgrounds.

---

## 34. Future Theme Strategy
The future theme strategy ensures the token system can easily adapt to future brand variations, white-label requests, or target platforms.

### 34.1 Multi-Tenant Theme Portability
```
                        [Active Theme Specification]
                                     |
                                     v
                 [Map Global Tokens to Semantic Tokens]
                                     |
                                     v
          [Components Render Instantly with the New Visual Styling]
```

* **Complete Decoupling:** Theme styles are isolated from component layout logic, allowing the design system to support new visual configurations without changes to the UI codebase.

---

## 35. Versioning Strategy
To ensure stability across multiple developer teams and future cross-platform builds, the Design Token System utilizes a strict versioning protocol.

### 35.1 Semantic Versioning Rules
* **MAJOR (Breaking Changes):** Renaming or removing existing tokens. Triggered major release cycles and migration guides.
* **MINOR (Additions):** Introducing new tokens to support features without affecting existing component styles.
* **PATCH (Fixes):** Modifying the underlying value of an existing global token without changing taxonomy structures.

---

## 36. Token Governance
Token governance rules protect the design system from unstructured additions and visual inconsistencies.

### 36.1 Governance Rules
1. **Mandatory Token Usage:** Every visual property must reference an architectural design token. No hardcoded values are allowed.
2. **Platform Independence:** Tokens must be defined in a platform-neutral format (such as YAML/JSON schemas) and compiled into target files.
3. **No Unused Tokens:** Unreferenced tokens are strictly prohibited.
4. **Single Category Ownership:** Every token must belong to exactly one structural namespace and category.

---

## 37. Migration Strategy
The migration strategy outlines the process of replacing hardcoded styling with the structured token architecture.

### 37.1 Migration Phasing
```
+------------------+     +------------------+     +------------------+
| 1. Code Audit    | --> | 2. Centralize    | --> | 3. Replace Style |
| (Find raw styling|     | (Map global to   |     | (Use token keys  |
| values in code)  |     | semantic values) |     | in all widgets)  |
+------------------+     +------------------+     +------------------+
```

1. **Audit Phase:** Identify all raw colors, spaces, and fonts within existing widgets.
2. **Centralization Phase:** Define and map corresponding global, semantic, and component tokens.
3. **Implementation Phase:** Replace hardcoded values with token references across all modules and tests.

---

## 38. Validation Rules
Validation rules ensure that all tokens are syntactically and structurally correct.

### 38.1 Schema Constraints
* **No Direct Raw Values:** Semantic and component tokens must never directly define raw values (e.g., HEX colors or pixel values).
* **Valid Token References:** Every token reference must point to an active, valid token path within the system schema.

---

## 39. Naming Validation
Naming validation ensures that all tokens comply with the standard taxonomy.

### 39.1 Automated Linting Checks
* **Strict Case Rules:** Every token segment must be lowercase alphanumeric. Use hyphens only for item groupings. No uppercase, camelCase, or snake_case is permitted.
* **Enforced Path Segments:** Every token key must contain at least five segments matching the defined taxonomy structure.

---

## 40. AI Usage Rules
The AI usage rules guide automated tools and large language models on how to write code that adheres to the BankYar design system.

### 40.1 Guidelines for AI Assistants
* **Never Hardcode Styles:** Do not generate layout definitions containing raw hex colors, physical units, or hardcoded margins.
* **RTL Logical Layouts:** Use logical alignment properties (start, end) rather than physical left/right coordinates in all layouts.
* **Reference Tokens:** Always query and utilize token keys from the official design token registries.

---

## Appendix A: Token Lifecycle
To manage the evolution of the BankYar Design System over time, every design token follows a defined architectural lifecycle:

```
[Draft] -> [Active] -> [Deprecated] -> [Obsolete (Removed)]
```

* **Draft:** The token is proposed, reviewed by the Design System team, and validated against naming rules.
* **Active:** The token is published in the active schema, compiled to target platforms, and widely referenced.
* **Deprecated:** The token is flagged for replacement. It remains functional in the compilation output, but generating tools will output compile-time warnings when referenced.
* **Obsolete:** The token is removed from the active dictionary. All references in components must be resolved before this stage.

---

## Appendix B: Structural Token Dependency Map
The diagram below details the structural reference paths and layer dependencies of the token system:

```
+-------------------------------------------------------------+
| GLOBAL LAYER (Aliases)                                      |
| [bankyar.global.color.gray.omega]                           |
+-------------------------------------------------------------+
                               ^
                               | (References)
+-------------------------------------------------------------+
| SEMANTIC LAYER (Intent)                                     |
| [bankyar.semantic.color.text.primary]                       |
+-------------------------------------------------------------+
                               ^
                               | (References)
+-------------------------------------------------------------+
| COMPONENT LAYER (Elements)                                  |
| [bankyar.component.button.primary.label]                    |
+-------------------------------------------------------------+
```

---

## Appendix C: Best Practices
1. **RTL-First Layouts:** Design layouts with logical directions (start, end) rather than physical directions (left, right) to ensure seamless RTL compatibility.
2. **Keep Semantic Separation:** Never map a component token directly to a raw physical value. Always route through the semantic layer.
3. **Programmatic Contrast Verification:** Theme compilers must automatically validate contrast ratios against WCAG 2.1 accessibility standards before generating target styles.

---

## Appendix D: Trade-Off Analysis
* **Strict Abstraction vs. Developer Velocity:** Creating three distinct token layers (Global -> Semantic -> Component) adds minor initial configuration overhead, but it guarantees absolute maintainability, future theme expansion, and effortless dark mode support.
* **Platform Independence vs. Platform-Native Conventions:** Standardizing on lowercase dot-notation (e.g., `bankyar.color.primary`) requires a translator pipeline for platforms like Flutter, but it secures multi-platform portability (for future iOS and desktop support) and acts as a single, objective source of truth.
