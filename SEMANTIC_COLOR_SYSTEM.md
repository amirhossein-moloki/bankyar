# BankYar Design System: Semantic Color System Architecture

## Executive Summary
This document establishes the official, enterprise-grade Semantic Color System Architecture for BankYar. Designed to implement the core product personality (*Stoic*, *Precise*, *Empowering*) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this architecture serves as the absolute visual and structural authority for all color-related decisions across the BankYar ecosystem.

In strict adherence to the **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets of the product, this color system is optimized for high readability, low cognitive load, professional trust, and Persian RTL-first layouts.

In accordance with architectural directives:
- **No HEX values** are assigned or hardcoded in this system.
- **No brand palette** is locked or chosen.
- **No Flutter code** or `ThemeData` is generated.
- **No UI mockups** or screens are designed.
- This system resides completely at the **Semantic Color Architecture level**, defining relationships, rules, mapping tables, accessibility checklists, and governance structures.

---

## Part 1: Color System Foundation

### 1. Color Philosophy
The BankYar Color Philosophy prioritizes utility over decoration. It treats color as **information carrier, not aesthetic filler**. In a high-integrity financial application, color must establish instant clarity, reinforce security states, and present financial truth with surgical accuracy.

The philosophy is governed by six fundamental principles:
* **Information over Aesthetic (Minimal Noise):** Color is used sparingly. High-contrast neutral canvases dominate, and accent colors are reserved exclusively for interactive elements, primary metrics, or state changes.
* **Calm Visual Experience:** By avoiding highly saturated, erratic, or neon backgrounds, the interface creates a safe, low-stress environment where users can calmly assess their financial health.
* **Semantic Integrity (One Meaning Per Color):** A semantic color channel serves exactly one purpose. For example, the color indicator representing "Income" must never be reused for positive system settings or secondary actions.
* **Color Independence (Accessibility-First):** Meaning is never conveyed solely by color. The color system works in tandem with structural indicators, typographic scaling, and standard labeling (e.g., plus/minus symbols, descriptive badges, and icons).
* **RTL-Optimized Contrast:** Layout hierarchies in Persian RTL are reinforced by subtle typographic and border contrast changes, ensuring effortless scanning from right to left.
* **Absolute Adaptability:** The system separates the "abstract representation" of color from its "physical mapping," facilitating seamless runtime switching between Light, Dark, High-Contrast, and future white-label themes.

---

### 2. Semantic Color Architecture
BankYar implements a strict, multi-tiered token dependency model to isolate UI components from raw color changes.

```
+------------------------------------------------------------+
|                  Tier 1: Primitive Layer                   |
| (Physical Base Scales: Primary, Neutral, Accent, Semantic) |
+------------------------------------------------------------+
                             |
                             v
+------------------------------------------------------------+
|                  Tier 2: Semantic Layer                    |
| (Meaning-Driven Concepts: Canvas, Surface, Text, Border)   |
+------------------------------------------------------------+
                             |
                             v
+------------------------------------------------------------+
|                 Tier 3: Component Layer                    |
| (Element-Specific: button.fill, input.border, card.bg)     |
+------------------------------------------------------------+
                             |
                             v
+------------------------------------------------------------+
|            Tier 4: State & Contextual Modifiers            |
| (State Overrides: Pressed, Hover, Disabled, Focused)       |
+------------------------------------------------------------+
```

#### Layer Interaction Rules:
1. **The Primitive Layer** acts as the registry of available palette scales. It contains abstract tokens mapped to a scale of visual steps (e.g., 50 to 950).
2. **The Semantic Layer** bridges the scale to a functional intent. Components *never* reference the Primitive Layer directly.
3. **The Component Layer** refines the semantic tokens to match specific UI building blocks, preventing styling leakage.
4. **State Modifiers** apply programmatic overlays or scale-shifts to component/semantic tokens under interactive states (e.g., disabled opacity or pressed contrast adjustments).

---

### 3. Primitive Color Layer
The Primitive Color Layer acts as a platform-agnostic, mathematical scale of color palettes. It defines the abstract reference labels and step values used to compile the active theme.

```
       Primitive Scales Structure:
       [Scale Family] -> [Lightness Steps]

       Primary:   [50] - [100] - [200] - ... - [900] - [950]
       Neutral:   [50] - [100] - [200] - ... - [900] - [950]
       Accent:    [50] - [100] - [200] - ... - [900] - [950]
       Success:   [50] - [100] - [200] - ... - [900] - [950]
       Warning:   [50] - [100] - [200] - ... - [900] - [950]
       Error:     [50] - [100] - [200] - ... - [900] - [950]
       Info:      [50] - [100] - [200] - ... - [900] - [950]
```

#### Abstract Primitive Token Registry Matrix:
| Primitive Scale Name | Description | Abstract Definition Steps | Intended Target Mapping |
| :--- | :--- | :--- | :--- |
| `bankyar.global.color.neutral.[50-950]` | Symmetrical Gray Scale | 50 (Lightest) to 950 (Darkest) | System backgrounds, cards, primary/secondary reading copy |
| `bankyar.global.color.primary.[50-950]` | Core Brand Primary Scale | 50 (Lightest) to 950 (Darkest) | Non-destructive interactive actions, brand anchoring elements |
| `bankyar.global.color.accent.[50-950]` | High-Focus Accent Scale | 50 (Lightest) to 950 (Darkest) | Focal indicators, active progress trackers, high-attention chips |
| `bankyar.global.color.success.[50-950]` | Positive System Scale | 50 (Lightest) to 950 (Darkest) | Income transactions, verified balances, success dialog checkmarks |
| `bankyar.global.color.warning.[50-950]` | Alert / Pending Scale | 50 (Lightest) to 950 (Darkest) | Scheduled payments, low-confidence heuristic parser warnings |
| `bankyar.global.color.error.[50-950]` | Critical / Destructive Scale | 50 (Lightest) to 950 (Darkest) | Failed parsed SMS, blocked accounts, destructive PIN purging actions |
| `bankyar.global.color.info.[50-950]` | Informational System Scale | 50 (Lightest) to 950 (Darkest) | In-app guides, system configuration update cues, backup metadata |

---

### 4. Semantic Color Layer
The Semantic Color Layer maps the abstract steps of the Primitive Layer to clear visual intentions. It abstracts the active palette away from the layout, so that changing the primitive bindings immediately updates the entire interface without structural adjustments.

#### Core Structural Semantic Tokens:
```
bankyar.semantic.color.[category].[variant].[sub_variant]
```

* `bankyar.semantic.color.background.canvas`: The base application window background.
* `bankyar.semantic.color.surface.default`: The default card/module background for grouping.
* `bankyar.semantic.color.surface.raised`: The elevation background for persistent navigation/dialog sheets.
* `bankyar.semantic.color.text.primary`: High-contrast typography for transaction amounts and primary labels.
* `bankyar.semantic.color.text.secondary`: Medium-contrast typography for metadata, timestamps, and secondary captions.
* `bankyar.semantic.color.text.disabled`: Low-contrast typography for locked actions or unselectable options.
* `bankyar.semantic.color.border.default`: Subtle line color for structural division.
* `bankyar.semantic.color.border.active`: High-contrast line color indicating keyboard focus or active field states.

---

## Part 2: Structural Surface & Text Layout Strategy

### 5. Surface Color Strategy
Surfaces act as containment vessels that group related financial data. To avoid visual noise, surfaces remain completely flat. Depth is communicated strictly by slight value transitions in the underlying neutral scale rather than using drop shadows or heavy colored fills.

```
+-----------------------------------------------------------+
| Background Canvas (Default Canvas Tone)                    |
|                                                           |
|  +-----------------------------------------------------+  |
|  | Card Surface Default (Grouped Ledger List Container) |  |
|  |                                                     |  |
|  |  +-----------------------------------------------+  |  |
|  |  | Card Surface Raised (Expanded Details Modal)  |  |  |
|  |  +-----------------------------------------------+  |  |
|  +-----------------------------------------------------+  |
+-----------------------------------------------------------+
```

* **Surface Default (`bankyar.semantic.color.surface.default`):** Utilized for flat cards representing parsed transaction items.
* **Surface Raised (`bankyar.semantic.color.surface.raised`):** Utilized for persistent action controls and contextual drawer sheets.
* **Surface Overlay (`bankyar.semantic.color.surface.overlay`):** Utilized for system modal sheets and biometric locking overlays, requiring distinct separation from the background layout.

---

### 6. Background Color Strategy
To minimize eye strain during long analytical reviews, BankYar employs a strict background strategy. The background is divided into functional regions:

* **Canvas Background (`bankyar.semantic.color.background.canvas`):** Implements a clean, solid, non-reflective base. It does not contain any brand tints, preventing conflicts with critical green/red financial colors.
* **Header Background (`bankyar.semantic.color.background.header`):** A distinct region reserved for cash flow summaries. It uses a highly controlled contrast boundary to separate analytic overviews from scrollable transaction lists.
* **System Overlay Canvas (`bankyar.semantic.color.background.scrim`):** Programmatically darkens or blurs the background layout behind modal dialogs and bottom sheets to keep user focus on active tasks.

---

### 7. Text Color Hierarchy
Typography is the primary vehicle for financial truth. Readability is prioritized by using a distinct contrast scale that ensures clean scanning of complex Persian characters.

```
       Visual Importance & Weight Hierarchy:
       [Level 1: Max Contrast] -> Primary transaction amount (Bold, Large)
       [Level 2: Mid Contrast] -> Counterparty / Merchant label (Medium, Regular)
       [Level 3: Low Contrast] -> Transaction timestamp / Core category metadata (Regular, Small)
       [Level 4: Min Contrast] -> System instructions / Placeholder prompts (Regular, Small)
```

* **Text Primary (`bankyar.semantic.color.text.primary`):** Maximum contrast against its underlying surface. Reserved for financial figures, section headers, and core transaction categories.
* **Text Secondary (`bankyar.semantic.color.text.secondary`):** Medium contrast. Used for supplementary transaction metadata, account origin cards, and timestamps.
* **Text Helper (`bankyar.semantic.color.text.helper`):** Low contrast. Used for placeholder text inside input fields, unparsed transaction descriptions, and diagnostic details.
* **Text On-Accent (`bankyar.semantic.color.text.onaccent`):** Extremely high contrast. Designed to be readable when overlaid on primary action fills or success/error chips.

---

### 8. Border Color Strategy
In alignment with our minimalist philosophy, boundaries are defined by subtle borders instead of heavy drop shadows or dark fills. This strategy keeps layouts flat and ensures crisp, clean alignment lines.

* **Border Default (`bankyar.semantic.color.border.default`):** A subtle hairline boundary used to separate transactional detail groups.
* **Border Focus (`bankyar.semantic.color.border.focus`):** High contrast border that clearly indicates keyboard navigation focus or active textfield editing.
* **Border Success / Error (`bankyar.semantic.color.border.success` / `bankyar.semantic.color.border.error`):** Contextual border that highlights verified transactions, parsing validation errors, or input form issues.

---

### 9. Divider Colors
Dividers are used to structure vertically stacked reading lists, such as the ledger feed. They prevent elements from visually merging while minimizing visual noise.

```
  ------------------------------------------------------------- <- Top Ledger Divider
  [Transaction Item 1] Amount: +120,000 IRR | Date: 1402/10/12
  ............................................................. <- Inner Divider (Dotted/Hairline)
  [Transaction Item 2] Amount: -45,000 IRR  | Date: 1402/10/12
  ------------------------------------------------------------- <- Bottom Ledger Divider
```

* **Divider Default (`bankyar.semantic.color.divider.default`):** A thin, low-contrast separator that acts as a structural guideline between adjacent list elements.
* **Divider Strong (`bankyar.semantic.color.divider.strong`):** A slightly thicker, high-contrast line used to divide major content regions, such as separating the header dashboard from the vertical ledger.

---

### 10. Icon Colors
Icons are visual shorthand that support text labeling. They are color-mapped to match the semantic priority of their adjacent text.

* **Icon Primary (`bankyar.semantic.color.icon.primary`):** High contrast icon color used for primary navigation, core actions, and status-defining symbols.
* **Icon Secondary (`bankyar.semantic.color.icon.secondary`):** Mid contrast. Used for minor categories, disclosure arrows, and clean metadata indicators.
* **Icon Contextual (`bankyar.semantic.color.icon.success` / `bankyar.semantic.color.icon.error`):** Used strictly for financial transaction arrows (income vs expense) and security lock status indicators.

---

## Part 3: Interactive & State Color Strategy

### 11. Action Colors
Action colors guide users toward primary interactive triggers, such as saving a transaction template or confirming an offline backup.

* **Action Primary (`bankyar.semantic.color.action.primary`):** High contrast action color that draws immediate focus to the screen's main goal.
* **Action Secondary (`bankyar.semantic.color.action.secondary`):** Mid contrast action color used for secondary triggers, such as adding transaction tags or exporting CSV sheets.

---

### 12. Interactive Colors
Interactive colors provide immediate visual feedback during user touch or click events, confirming that the system has registered their input.

* **Interactive Base (`bankyar.semantic.color.interactive.base`):** The default visual state of standard clickable buttons and navigation elements.
* **Interactive Hover / Pressed (`bankyar.semantic.color.interactive.pressed`):** Programmatic contrast shifts that confirm tap events instantly (response time `< 100ms`).

---

### 13. Focus Colors
Focus indicators are a critical accessibility requirement, helping users navigate the interface using external keyboards, screen readers, or switch controls.

```
  +-------------------------------------------------------+
  | [Focused Action Button]                               |
  |                                                       |
  |  ===================================================  |
  |  ||  Focus Outline Ring: High-Contrast Boundary   ||  |
  |  ===================================================  |
  +-------------------------------------------------------+
```

* **Focus Outline (`bankyar.semantic.color.focus.outline`):** A high-contrast, double-layered outline that remains clearly visible in both light and dark modes, ensuring focused elements stand out.

---

### 14. Selection Colors
Selection colors highlight active states, such as selected transaction rows, chosen template filters, or highlighted ledger periods.

* **Selection Fill (`bankyar.semantic.color.selection.fill`):** A subtle, low-saturation tint that marks selected rows or chips without obscuring the text underneath.
* **Selection Text (`bankyar.semantic.color.selection.text`):** Adjusts typographical contrast to ensure high readability against the selection background.

---

### 15. Disabled Colors
Disabled states communicate that an action is currently locked or unavailable, such as an incomplete form submission button or a biometric scanner while PIN is locking out.

* **Disabled Background (`bankyar.semantic.color.disabled.background`):** Flat, low-contrast gray fill that signals the container is inactive.
* **Disabled Text / Icon (`bankyar.semantic.color.disabled.text`):** Low-contrast gray text/icon that meets accessibility standards for legibility while clearly communicating the disabled state.

---

### 16. Overlay Colors
Overlay colors establish logical depth during high-priority interruptions, such as PIN locks, biometric prompts, or modal confirmation dialogs.

* **Scrim Overlay (`bankyar.semantic.color.overlay.scrim`):** A soft, low-opacity backdrop that darkens the background layout to focus attention on the modal content.
* **Temporary Sheet Backdrop (`bankyar.semantic.color.overlay.sheet`):** Soft, non-intrusive backdrop used behind bottom sheets and quick actions to keep user focus on active tasks.

---

### 17. Shadow Colors
To support our *Stoic* and *Precise* product personality, BankYar rejects heavy, glowing, or colorful shadows.

* **Ambient Shadow (`bankyar.semantic.color.shadow.ambient`):** A soft, highly diffused gray shadow used sparingly to provide subtle physical separation for raised components (such as bottom sheets or floating quick actions). Sourced entirely from neutral grayscale values, never using brand colors.

---

## Part 4: Financial & Status Color Strategy

### 18. Notification Colors
Notifications confirm background operations, such as background SMS parsing or successful local database exports, without disrupting the active flow.

* **Notification Ingestion (`bankyar.semantic.color.notification.ingestion`):** Soft, non-intrusive tone used to signal successful background transaction capture.
* **Notification System (`bankyar.semantic.color.notification.system`):** Clean, neutral tone used to confirm system events, such as database optimization or diagnostic log completion.

---

### 19. Status Colors
Status colors communicate transaction and system states clearly, helping users track and verify their financial record.

```
       Status State Progression Matrix:
       [Scheduled] -> [Pending] -> [Completed] -> [Blocked]
```

* **Completed (`bankyar.semantic.color.status.completed`):** Green tint used to indicate verified, fully parsed transaction records.
* **Pending / Scheduled (`bankyar.semantic.color.status.pending`):** Amber tint used to indicate upcoming scheduled payments, or heuristic parsed records requiring user validation.
* **Failed / Blocked (`bankyar.semantic.color.status.failed`):** Red tint used to indicate parsing template failures, blocked accounts, or critical authentication warnings.

---

### 20. Success Colors
Success indicators confirm positive system events, such as successful database backups, verified PIN creation, or successful transaction template matches.

* **Success Fill (`bankyar.semantic.color.success.fill`):** Soft, low-saturation green background used for success badges and alerts.
* **Success Text (`bankyar.semantic.color.success.text`):** High-contrast green text that remains clearly legible against light or dark success fills.

---

### 21. Warning Colors
Warning indicators highlight conditions that require user attention but do not disrupt system operations, such as low-confidence heuristic parser matches or upcoming scheduled payments.

* **Warning Fill (`bankyar.semantic.color.warning.fill`):** Soft, low-saturation amber background used for warning panels and review chips.
* **Warning Text (`bankyar.semantic.color.warning.text`):** High-contrast amber text that remains clearly legible against light or dark warning fills.

---

### 22. Error Colors
Error indicators highlight critical failures that require immediate user action, such as PIN mismatch lockouts, SQLCipher database corruption, or invalid import formats.

* **Error Fill (`bankyar.semantic.color.error.fill`):** Soft, low-saturation red background used for error banners and validation alerts.
* **Error Text (`bankyar.semantic.color.error.text`):** High-contrast red text that remains clearly legible against light or dark error fills.

---

### 23. Information Colors
Information indicators provide neutral guidance and system tips, such as backup instructions, security advice, or user documentation.

* **Info Fill (`bankyar.semantic.color.info.fill`):** Soft, low-saturation blue background used for information cards and guides.
* **Info Text (`bankyar.semantic.color.info.text`):** High-contrast blue text that remains clearly legible against light or dark info fills.

---

### 24. Financial Colors
Financial colors classify cash flow events, such as income, expense, transfers, and refunds. To ensure clarity, financial colors are distinct and maintain high contrast.

#### Financial Semantic Token Directory:
```
bankyar.semantic.color.financial.[transaction_type].[variant]
```

* `bankyar.semantic.color.financial.income.fill`: Background fill for positive cash flow markers.
* `bankyar.semantic.color.financial.income.text`: Typography representing incoming transactions.
* `bankyar.semantic.color.financial.expense.fill`: Background fill for outgoing cash flow markers.
* `bankyar.semantic.color.financial.expense.text`: Typography representing outgoing transactions.
* `bankyar.semantic.color.financial.transfer.fill`: Neutral fill representing internal account movements.
* `bankyar.semantic.color.financial.refund.fill`: Positive recovery indicator for returned transactions.

---

### 25. Income Colors
Income represents incoming funds, such as salary, interest, deposits, or transfers. It is highlighted with positive visual cues.

```
  +-------------------------------------------------------+
  | [Income Transaction Card]                             |
  |                                                       |
  |   Amount:  +45,000,000 IRR                            |
  |   Type:    Salary                                     |
  |   Status:  [ Income Badge: Success Color Scale ]      |
  +-------------------------------------------------------+
```

* **Income Indicator (`bankyar.semantic.color.financial.income.indicator`):** Bright, high-contrast positive marker. Works alongside the plus symbol (`+`) and upward directional arrow (`↑`) to represent incoming funds.

---

### 26. Expense Colors
Expense represents outgoing funds, such as retail purchases, bills, or fees. It is highlighted with clear, high-contrast markers to ensure spending trends remain obvious.

```
  +-------------------------------------------------------+
  | [Expense Transaction Card]                            |
  |                                                       |
  |   Amount:  -1,250,000 IRR                             |
  |   Type:    Supermarket                                |
  |   Status:  [ Expense Badge: Error Color Scale ]       |
  +-------------------------------------------------------+
```

* **Expense Indicator (`bankyar.semantic.color.financial.expense.indicator`):** High-contrast negative marker. Works alongside the minus symbol (`-`) and downward directional arrow (`↓`) to represent outgoing funds.

---

### 27. Neutral Colors
Neutral colors establish the structural foundation of the interface, providing a clean canvas that highlights financial data and status events.

* **Neutral Light (`bankyar.semantic.color.neutral.light`):** Light gray scales used for backgrounds, cards, and dividers in the light theme.
* **Neutral Dark (`bankyar.semantic.color.neutral.dark`):** Deep gray scales used for backgrounds, cards, and dividers in the dark theme.
* **Neutral Mid (`bankyar.semantic.color.neutral.mid`):** Mid-tone grays used for secondary text, metadata, and placeholder elements.

---

## Part 5: Advanced Visual Strategies

### 28. Chart Color Strategy
To prevent visual clutter, charts remain flat and avoid glowing gradients or complex 3D rendering. They are designed to present data trends with absolute clarity.

```
        Financial Donut Chart Visualization:

            +-------+
          /   ***     \     * = Income Category Slice (Success Theme Step)
         |  **   ...   |    . = Expense Category Slice (Error Theme Step)
         |  **   ...   |    # = Internal Transfer Slice (Info Theme Step)
          \   ###     /
            +-------+
```

* **Category Separation:** Adjacent slices are separated by high-contrast divider rings (`bankyar.semantic.color.surface.default`), preventing color merging.
* **Trend Indication:** Multi-column bar charts use semantic income/expense colors to represent cash flow trends directly.
* **Accessibility Fallback:** Chart slices use text percentages and geometric patterns alongside colors, ensuring the data remains understandable for color-blind users.

---

### 29. Color Accessibility Strategy
BankYar enforces strict accessibility standards, protecting low-vision, high-fatigue, and color-blind users.

* **Contrast Ratios:** Text, icons, and focus indicators must maintain high contrast ratios against their background under all lighting conditions.
  * **Level AAA (where applicable):** Large text (18pt+) and headers must meet a minimum contrast ratio of 4.5:1.
  * **Level AA (mandatory):** Body text (14pt+) must meet a minimum contrast ratio of 4.5:1.
  * **Interactive Triggers:** Core actions and touch boundaries must meet a minimum contrast ratio of 3:1.
* **Text Scaling Support:** Background containers and card layouts must dynamically scale to prevent overlapping or clipping when system-level text magnification is enabled.

---

### 30. Color Blind Support
The interface must never convey meaning solely by color. The color system works alongside structural, textual, and geometric indicators to remain accessible to all color-blind users.

#### Color Independence Pattern Schema:
| Context | Visual Color Cue | Secondary Structural Cue | Secondary Textual Cue |
| :--- | :--- | :--- | :--- |
| **Income Transaction** | Success Green Scale | Upward directional arrow (`↑`) | Plus symbol (`+`) prepended to amount |
| **Expense Transaction** | Error Red Scale | Downward directional arrow (`↓`) | Minus symbol (`-`) prepended to amount |
| **Heuristic Warning** | Warning Amber Scale | Warning exclamation badge (`⚠️`) | "Low Confidence Match" badge |
| **Failed Operation** | Danger Red Scale | Warning alert shield icon | "Operation Failed" descriptive tag |
| **Secure PIN Match** | Success Green Scale | Solid locked padlock icon | "Authenticated" system notification |

---

### 31. Dark Theme Mapping
The dark theme overrides semantic mappings to optimize contrast and comfort in low-light environments, protecting users during night-time analytical reviews.

```
                    Theme Map Context Switch:

  Light Theme                                   Dark Theme
  [Background: White Scale 50]              ->  [Background: Deep Gray Scale 950]
  [Card Surface: Light Gray Scale 100]      ->  [Card Surface: Deep Gray Scale 900]
  [Primary Text: Deep Gray Scale 950]       ->  [Primary Text: Light Gray Scale 50]
```

* **Deep Grayscale Base:** The background uses deep neutral grays (`bankyar.global.color.neutral.950`) to minimize eye strain.
* **Accessible Contrast:** Contrast ratios are verified to ensure body text and functional accents remain readable against dark backgrounds.
* **Elevation via Opacity:** Instead of heavy shadows, elevation in the dark theme is communicated by applying soft white opacity overlays to container surfaces.

---

### 32. Theme Switching Strategy
Theme switching is managed cleanly by updating the active token maps, ensuring a seamless transition across all application layers.

```
                      Active Theme State Change
                                  |
                                  v
                Resolve Active Global Token Mapping
                                  |
                                  v
           Update Semantic Layer Tokens in Active Container
                                  |
                                  v
              UI Components Re-render Instantly (60FPS)
```

* **Zero Layout Impact:** Switching themes must never affect sizes, curves, layout coordinates, or text alignments.
* **Component Isolation:** Components are blind to active themes. They only query component/semantic tokens, which resolve their underlying values based on the active Theme Map.

---

## Part 6: Token, Component, & State Matrices

### 33. Token Mapping
This matrix defines how the semantic token layers map back to the global primitive scales.

| Semantic Token Name | Light Theme Primitive Reference | Dark Theme Primitive Reference |
| :--- | :--- | :--- |
| `bankyar.semantic.color.background.canvas` | `bankyar.global.color.neutral.50` | `bankyar.global.color.neutral.950` |
| `bankyar.semantic.color.surface.default` | `bankyar.global.color.neutral.100` | `bankyar.global.color.neutral.900` |
| `bankyar.semantic.color.surface.raised` | `bankyar.global.color.neutral.200` | `bankyar.global.color.neutral.850` |
| `bankyar.semantic.color.text.primary` | `bankyar.global.color.neutral.950` | `bankyar.global.color.neutral.50` |
| `bankyar.semantic.color.text.secondary` | `bankyar.global.color.neutral.600` | `bankyar.global.color.neutral.400` |
| `bankyar.semantic.color.border.default` | `bankyar.global.color.neutral.300` | `bankyar.global.color.neutral.750` |
| `bankyar.semantic.color.border.active` | `bankyar.global.color.primary.500` | `bankyar.global.color.primary.400` |

---

### 34. Component Color Mapping
This matrix defines how the component layer maps back to the semantic token layers.

| Component Token Name | Target Element Property | Semantic Source Reference |
| :--- | :--- | :--- |
| `bankyar.component.button.primary.fill` | Primary button background | `bankyar.semantic.color.action.primary` |
| `bankyar.component.button.primary.label`| Primary button text color | `bankyar.semantic.color.text.onaccent` |
| `bankyar.component.card.ledger.background`| Ledger transaction card fill | `bankyar.semantic.color.surface.default` |
| `bankyar.component.card.ledger.border` | Ledger transaction boundary | `bankyar.semantic.color.border.default` |
| `bankyar.component.input.text.border` | Outline of textfields | `bankyar.semantic.color.border.default` |

---

### 35. State Color Mapping
State modifiers adjust component tokens dynamically under interactive states, ensuring immediate feedback.

| State Modifier Token | Applied Visual Behavior | Expected UX Response |
| :--- | :--- | :--- |
| `default` | 100% of base semantic mapping | Stable base visual representation |
| `hover` | Shift contrast scale by +1 step | Instant feedback on pointer hover |
| `pressed` | Shift contrast scale by +2 steps | Strong, immediate validation of touch event |
| `disabled` | Apply 38% opacity overlay | Clearly communicates inactive status |
| `focused` | Apply high-contrast outline ring | High visibility highlight for accessibility |

---

## Part 7: Design Governance & System Evolution

### 36. Future Brand Strategy
As an enterprise-grade platform, BankYar is built to support white-label deployments, regional variations, or future branding changes.

```
                    White-label Theme Expansion:

  Core Brand Scale                              Partner Bank Scale
  [Primary: Emerald Scale]                  ->  [Primary: Indigo Scale]
  [Accent: Sapphire Scale]                   ->  [Accent: Gold Scale]
```

* **Logical Decoupling:** Theme styles are isolated from component layout logic, allowing the design system to support new visual configurations without changes to the UI codebase.

---

### 37. Governance Rules
To prevent inconsistent color usage and protect the integrity of the design system, all design contributions must comply with the following governance rules:

1. **Mandatory Token Usage:** Every visual property must reference an architectural design token. No raw color values are allowed.
2. **One Meaning Per Color:** A semantic color channel must serve exactly one purpose. Reusing semantic tokens for secondary meanings is prohibited.
3. **Color Independence:** Meaning must never be conveyed solely by color. The layout must work alongside structural, textual, and geometric indicators.
4. **Approval Required:** Any addition of new colors to the system requires approval from the Design System Governance Board.

---

### 38. Validation Rules
The design system compiler validates all token definitions against a strict rule set before deployment:

* **No Direct Raw Values:** Semantic and component tokens must never directly define raw values.
* **Valid Token References:** Every token reference must point to an active, valid token path within the system schema.
* **Enforced Contrast:** Text, icon, and focus tokens are programmatically verified to ensure they meet WCAG AA contrast standards.

---

### 39. Anti-patterns
The following visual and architectural anti-patterns are strictly prohibited:

* **Raw Colors in Components:** Direct use of raw color values in UI components or styling definitions is prohibited.
* **Dual-purpose Color Meanings:** Using green for both income and positive system confirmations is prohibited.
* **Color as Only Indicator:** Displaying transaction statuses or form validation errors using color alone is prohibited.
* **Gradients and Shadows:** Using heavy gradients, glowing shadows, or neon backgrounds on cards and containers is prohibited.

---

### 40. Migration Strategy
To transition the existing codebase to the structured Semantic Color System, developers follow a phased migration plan:

```
       Phase 1: Audit & Map -> Phase 2: Refactor Components -> Phase 3: Enforce & Automate
```

1. **Audit & Map (Phase 1):** Identify and map all raw color definitions in the codebase, establishing corresponding tokens in the design dictionary.
2. **Refactor Components (Phase 2):** Replace raw color references with token paths across all UI components and page layouts.
3. **Enforce & Automate (Phase 3):** Configure linter rules and compile-time validation checks to prevent the addition of raw color definitions.

---
**End of Document**
