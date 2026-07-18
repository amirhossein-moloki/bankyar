# BankYar Design System: Surface & Elevation Architecture Specification (v1.0.0)

## Executive Summary
This document establishes the official, enterprise-grade Surface, Elevation, Border, Radius, Shadow, and Layering System Architecture for BankYar. Designed to implement the core product personality (*Stoic*, *Precise*, *Empowering*) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this system is the absolute visual and structural authority for all layering, depth, containment, and boundary decisions across the BankYar ecosystem.

In strict adherence to the **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets of the product, this visual depth system is optimized for high readability, low cognitive load, professional trust, and Persian RTL-first layouts. By enforcing a highly structured layering system, BankYar avoids visual noise, preserves absolute visual consistency, and ensures a clean, predictable reading path.

In accordance with architectural directives:
- **No Flutter code** or `ThemeData` is generated.
- **No actual pixel values** (e.g., `8px`, `12dp`) or physical shadow blur values are defined.
- **No UI mockups** or visual screen assets are designed.
- This system resides completely at the **Visual Depth & Surface Architecture level**, defining relationships, logic, mapping tables, accessibility rules, checklists, and governance structures.

---

## Part 1: Visual Depth & Surface Philosophy

### 1. Surface Philosophy
The BankYar Surface Philosophy prioritizes utility and clarity over decoration. In a high-integrity financial application, depth must communicate meaning, and elevation must be earned, not decorative. The user’s attention is a precious, finite asset that must not be squandered with arbitrary visual layers or distracting depth indicators.

The philosophy is governed by seven fundamental principles:
* **Meaningful Depth:** Depth is not used for aesthetic variation. Every layer change must correspond directly to a change in interactive priority, layout containment, or temporal context.
* **Earned Elevation:** Components do not default to elevated states. Most screens must remain visually flat to minimize visual noise. Elevation is applied only when a component must overlap or direct focus away from primary content.
* **Whitespace Before Shadows:** Contrast and logical spacing (using the layout grid) are always preferred over shadows to define structure. Shadows represent the ultimate layer separation and are used as a final resort.
* **Borders Before Shadows:** Fine outlines and borders are the primary tool for container separation. Before elevation or shadow is added, thin borders must be used to group related information.
* **Subtle Hierarchy:** All depth visual indicators (tints, outlines, shadows) must remain extremely subtle. High-contrast neon, glowing gradients, or deep 3D-styled shapes are strictly prohibited.
* **Financial Focus:** Financial data (amounts, transaction records) is the center of the user experience. Surface designs must never distract from the readability of Persian cursive texts and mathematical scales.
* **RTL Baseline Alignment:** Depth transitions and container alignments are optimized to guide the eye naturally from right to left, matching standard Persian reading flows.

---

### 2. Visual Depth Strategy
The visual depth strategy defines how physical depth and optical hierarchy are simulated within a 2D screen space. Rather than utilizing physical measurements, BankYar maps depth using structural relationships and logical layers:

```
+--------------------------------------------------------------+
| LEVEL 4: MODALS & DIALOGS (Highest Interactive Focus)        |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
| LEVEL 3: OVERLAYS, BOTTOM SHEETS, & QUICK ACTIONS            |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
| LEVEL 2: NAVIGATION & APP BARS (Sticky, Persistent Controls)  |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
| LEVEL 1: CONTENT LAYERS & CARDS (Parsed Financial Groupings) |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
| LEVEL 0: SCREEN CANVAS BACKGROUND (Default Ground Layer)     |
+--------------------------------------------------------------+
```

Depth transitions must occur predictably along this axis. Direct jumps from Level 0 to Level 4 are heavily restricted, requiring a visual transition (such as background darkening or a scrim layer) to bridge the focus shift.

---

### 3. Surface Hierarchy
To organize financial records clearly, BankYar employs a strict, 5-tier vertical surface hierarchy. This hierarchy ensures that primary numbers receive maximum focus, while background elements remain non-intrusive.

#### Surface Hierarchy Matrix:
| Hierarchy Level | Logical Name | Primary Visual Role | Adaptive Relationship |
| :--- | :--- | :--- | :--- |
| **Level 0** | `Canvas Background` | Base layout container for the entire screen. | Always stationary, non-elevated. |
| **Level 1** | `Content Surface` | Standard transaction cards, category chips, list grouping containers. | Renders flat or with thin borders relative to Level 0. |
| **Level 2** | `Raised Control` | Active textfields, filter bars, sticky headers, system app bars. | Visually separated from Level 1 using subtle values or hairline outlines. |
| **Level 3** | `Floating Container` | Floating quick actions, snackbars, bottom sheets. | Elevated with ambient shadows; overlaps Level 1 and 2. |
| **Level 4** | `Modal Overlay` | Diagnostic dialogs, biometric unlock screens, pin entries. | Captures full focus; forces Level 0-3 background to dim or blur. |

---

### 4. Surface Categories
To ensure consistent component development, all UI elements must map back to one of three primary surface categories:
* **Structural Surfaces:** Stationary layout boundaries (e.g., screen backgrounds, app bar blocks, and horizontal separators). They provide the visual architecture of the screen.
* **Container Surfaces:** Data-grouping containers (e.g., transaction cards, alert panels, and input fields) that organize content into readable logical blocks.
* **Interactive Surfaces:** Clickable widgets (e.g., action buttons, selection chips, and modal sheets) that change their elevation, border, or tint in response to user touch.

---

## Part 2: Surface & Layering Architecture

### 5. Primary Surface Rules
Primary surfaces (`bankyar.semantic.surface.primary`) represent the base content container of the application.
* **Usage Context:** Standard transaction cards, main account summaries, and ledger feeds.
* **Layout Constraints:** Must align strictly to the logical layout grid margins. No primary surface may span edge-to-edge unless explicitly configured for low-density compact phone screens.
* **Border Constraints:** Must use a continuous thin outline (`bankyar.border.width.thin`) to separate content from the canvas background. Drop shadows are strictly prohibited on primary surfaces.

---

### 6. Secondary Surface Rules
Secondary surfaces (`bankyar.semantic.surface.secondary`) are nested inside primary surfaces to represent logical sub-groups.
* **Usage Context:** Custom notes inside transaction detail cards, tag groups, and category chips.
* **Visual Presentation:** Must use a slightly different color tint (e.g., a darker step in the neutral gray scale) rather than introducing a new border or shadow.
* **Layer Nesting Limits:** Nesting is limited to a single layer (Secondary inside Primary). Deeply nested container loops are strictly prohibited to prevent visual clutter.

---

### 7. Tertiary Surface Rules
Tertiary surfaces (`bankyar.semantic.surface.tertiary`) represent temporary, contextual containers.
* **Usage Context:** Low-confidence parser warning chips, diagnostic file info boxes, and minor inline tooltip indicators.
* **Contrast Rules:** Must maintain highly contrasted typography to ensure immediate readability against secondary or primary backdrops.
* **Border Constraints:** May employ dashed borders (`bankyar.border.style.dashed`) to signal a temporary state or drop target.

---

### 8. Background Layer Strategy
The background layer strategy regulates the visual canvas to prevent eye strain and maintain readability.
* **Canvas Tinting:** The base background is solid and non-reflective. It does not contain any brand tints or colorful gradients, preventing visual conflict with the red and green financial status colors.
* **Header Segments:** Cash flow summaries and account selection headers reside in a dedicated region at the top of the screen. This region uses a distinct visual boundary to separate scrollable lists from stationary summaries.

---

### 9. Content Layer Strategy
Content layers manage the horizontal and vertical relationships of data inside surfaces.
* **RTL Reading Lines:** Content layers must align RTL-first. Primary financial numbers (amounts) reside at the logical end (left side), while merchant names and transaction categories reside at the logical start (right side).
* **Whitespace Isolation:** Text elements must be separated using logical spacing tokens rather than drawing internal lines, maintaining a clean visual layout.

---

### 10. Overlay Layer Strategy
Overlay layers handle temporary interface elements that appear on top of standard content.
* **System Overlay Controls:** Volume sliders, system permissions, and in-app alerts are positioned at the highest z-index level (`bankyar.zindex.overlay`).
* **Exit Strategy:** Overlays must be dismissible with a simple, standard gesture (such as tapping the background canvas or swiping downward), ensuring the user remains in complete control.

---

### 11. Modal Layer Strategy
Modal layers present high-priority, contextual tasks that require direct user interaction before dismissal.
* **Interactive Lock:** While a modal layer is active, interaction with the underlying content layers is completely disabled.
* **Scrim Dimming:** Modals require a dark, semi-transparent background scrim (`bankyar.semantic.color.overlay.scrim`) to visually separate the modal container from the active screen below.

---

### 12. Dialog Layer Strategy
Dialog layers are used for critical system alerts, verification steps, and database management actions.
* **Centering Rules:** Dialogs are centered on the screen and must not expand to fill the entire layout.
* **Actions Limit:** Dialogs are strictly limited to a maximum of two horizontal actions (e.g., "Confirm" and "Cancel"). In RTL Persian layouts, the primary action button is positioned at the logical start (right side) to ensure immediate focus.

---

### 13. Bottom Sheet Layer Strategy
Bottom sheets are our primary container for mobile controls, bringing interactions directly to the user's thumb.
* **Interaction Zone:** Bottom sheets expand from the bottom of the screen, occupying the comfortable one-handed reach zone.
* **Curvature Guidelines:** The top edge of the bottom sheet container must feature a distinct large curvature (`bankyar.radius.xl`) to visually separate it from the rectangular content cards underneath.

---

### 14. Floating Component Strategy
Floating components (e.g., floating action buttons) are used sparingly to prevent blocking primary financial data.
* **No Action Bloat:** Screens are limited to a maximum of one floating action button. Floating button clusters or expanding "radial" action menus are strictly prohibited.
* **Elevation Priority:** Floating buttons use elevated semantic tokens (`bankyar.elevation.level.two`) to ensure they remain visible above scrollable list feeds.

---

## Part 3: Component Elevation Rules

### 15. App Bar Elevation Rules
The app bar provides primary navigation and screen-level context.
* **Flat State by Default:** On screen launch, the app bar must remain completely flat relative to the background canvas.
* **Scroll-Induced Elevation:** When the user scrolls content underneath the app bar, it must dynamically apply a subtle border or light color shift to indicate separation, reverting back to flat when scrolled to the top.

---

### 16. Navigation Bar Elevation Rules
The persistent bottom navigation bar allows rapid switching between primary app sections.
* **Stable Elevation:** The bottom navigation bar resides at a fixed elevated z-index coordinate (`bankyar.zindex.sticky`).
* **Visual Isolation:** The bar is separated from the scrolling content canvas using a top boundary border (`bankyar.semantic.color.border.default`). Drop shadows are not used on the navigation bar to maintain a clean layout.

---

### 17. Card Elevation Rules
Cards are the primary container for grouped financial transactions.
* **Flat Containment:** Transaction cards remain flat by default, relying on thin outlines for separation.
* **Interactive Elevation:** When a card is pressed, it must not lift or float. Instead, it indicates the press using a brief, subtle background tint shift, preventing visual jumping.

---

### 18. List Item Surface Rules
List items represent single transactions in scrollable feeds.
* **Hairline Separation:** Adjacent list items are separated using fine, low-contrast hairline borders (`bankyar.semantic.color.border.default`) rather than individual margins, optimizing screen space and reducing visual noise.
* **Logical Mirroring:** List items mirror logical layouts naturally when switching between RTL and LTR locales.

---

### 19. Form Surface Rules
Forms capture sensitive user input, such as transaction amounts, category rules, and security pins.
* **Input Box Style:** Input fields use a clear container box style (`bankyar.component.input.text.fill`) to provide a comfortable, obvious touch target.
* **Active Boundary:** Focused input fields render a high-contrast active outline (`bankyar.component.input.text.border.active`), drawing immediate attention to the active typing context.

---

## Part 4: Border & Radius Systems

### 20. Border System
The BankYar Border System acts as our primary containment tool, replacing heavy shadows and complex fills to group data clearly.
* **Visual Purpose:** Borders define clear reading lines and content containers.
* **No Decorative Outlines:** Outlines must only be used to define functional containers (e.g., inputs, cards, and buttons) or separate distinct screen regions. Decorative borders are strictly prohibited.

---

### 21. Border Hierarchy
Borders are structured logically based on component role and interaction priority:

#### Border Hierarchy Specification:
```
+-------------------------------------------------------------+
| BORDER ACTIVE (Thick, High Contrast Outline)                |
| Mapped from: bankyar.border.width.thick                     |
| Context: Active inputs, focused elements, navigation focus. |
+-------------------------------------------------------------+
                               ^
                               | (Increases Contrast)
+-------------------------------------------------------------+
| BORDER DEFAULT (Thin, Low Contrast Hairline)                |
| Mapped from: bankyar.border.width.thin                      |
| Context: Standard cards, list items, structural separators. |
+-------------------------------------------------------------+
                               ^
                               | (Base Structure)
+-------------------------------------------------------------+
| BORDER NONE (No Outline)                                    |
| Mapped from: bankyar.border.width.none                      |
| Context: Full-width headers, edge-to-edge system bars.      |
+-------------------------------------------------------------+
```

---

### 22. Radius System
The Radius System regulates the curvature of containers, establishing a soft, professional, and consistent visual language across the application.
* **Functional Meaning:** Curve scales must communicate component identity. For example, circular shapes represent active status indicators, while subtle rectangular rounded corners are used for standard textfields and buttons.

---

### 23. Corner Philosophy
The BankYar corner philosophy guides the selection of corner shapes based on container scale:
* **Large Containers (`bankyar.radius.xl` / `bankyar.radius.lg`):** Applied to modal bottom sheets and primary transaction cards. The soft curves reinforce containment, signaling that the content is grouped securely.
* **Compact Components (`bankyar.radius.md` / `bankyar.radius.sm`):** Applied to buttons, input fields, tags, and badge indicators. Sharp but softened corners optimize interactive target alignment.
* **Edge Containment:** When a container is positioned flush against a device margin (e.g., a full-width header or footer bar), the matching outer corners must flatten to `bankyar.radius.none`, aligning cleanly with the physical device boundaries.

---

## Part 5: Shadow & Elevation Strategy

### 24. Shadow Strategy
Shadows represent ambient physical depth. To support our *Stoic* and *Precise* product personality, BankYar rejects heavy, glowing, or colorful shadows.
* **Symmetrical Light Modeling:** Shadows simulate light source positioned directly above, casting highly diffused, symmetrical, and non-intrusive ambient occlusion fields.
* **Grayscale Only:** Shadow fills are derived entirely from neutral grayscale values (`bankyar.semantic.color.shadow.ambient`). They must never utilize accent colors or brand tints.
* **Contrast Over Elevation:** If high-contrast accessibility mode is active, shadows are completely disabled, and containers rely entirely on thick solid borders.

---

### 25. Elevation Hierarchy
Components map their depth coordinates to one of five logical elevation levels:

#### Elevation Relationship Matrix:
| Elevation Level | Structural Intent | Active Token Path | Expected Depth Behavior |
| :--- | :--- | :--- | :--- |
| **Level 0** | Base Canvas Background | `bankyar.elevation.level.zero` | Flat base. Casts no shadow. |
| **Level 1** | Primary Grouping Cards | `bankyar.elevation.level.one` | Hairline border. No shadow or flat tint. |
| **Level 2** | Sticky App Bars, Navigation | `bankyar.elevation.level.two` | Fine outline + highly diffused ambient shadow. |
| **Level 3** | Floating Actions, Sheets | `bankyar.elevation.level.three` | Medium ambient shadow; overlaps Level 1 & 2. |
| **Level 4** | Modal Dialogs, Lockscreens | `bankyar.elevation.level.four` | Deep ambient shadow + background dimming scrim. |

---

### 26. Layer Interaction Rules
When layers overlap, they must conform to strict physical constraints:
* **No Collisions:** Two distinct active interactive layers must never occupy the identical elevation coordinate, preventing layout conflicts and visual clipping.
* **Focus Shift Flow:** When a higher level surface (e.g., a Level 4 dialog) becomes active, interactive elements in the underlying layers (Level 0 to 3) are completely disabled.
* **Dismissal Path:** Higher-level overlays must provide an obvious, intuitive exit path (such as tapping the background canvas or utilizing a standard close action), returning the user directly to the previous level.

---

### 27. Z-Layer Mapping
The z-layer mapping maps design system layout components directly to deterministic z-index values, securing layout consistency across development teams:

```
Z-Index Stack Definition:

  [z-index: 50] -> Dialogs & Lock Screens (Level 4)
  [z-index: 40] -> Bottom Sheets & Floating Actions (Level 3)
  [z-index: 30] -> Sticky App Bars & Navigation Rails (Level 2)
  [z-index: 20] -> Primary Content Cards & Inputs (Level 1)
  [z-index: 10] -> Base Screen Canvas Background (Level 0)
```

By enforcing a strict z-index scale, BankYar prevents z-index pollution and ensures modal components never slip beneath standard content.

---

## Part 6: Advanced Visual Strategies & Custom States

### 28. Dark Theme Surface Strategy
In a dark environment, standard dark shadows are visually ineffective. BankYar adapts its visual depth strategy dynamically when dark theme is active:
* **Deep Grayscale Base:** The background canvas uses deep neutral grays (`bankyar.global.color.neutral.950`) rather than pure pitch black, preventing eye strain and reducing OLED pixel smearing.
* **Elevation via Opacity:** Instead of heavy shadows, elevation in the dark theme is communicated by applying soft white opacity overlays to container surfaces. As the elevation level increases, the white opacity layer becomes slightly more intense, making elevated containers appear closer to the user:

```
Dark Theme Elevation Strategy:

  Level 0 Surface -> Deep Base (Solid Neutral Gray 950)
  Level 1 Surface -> Base + 2% White Opacity Overlay
  Level 2 Surface -> Base + 5% White Opacity Overlay
  Level 3 Surface -> Base + 8% White Opacity Overlay
  Level 4 Surface -> Base + 12% White Opacity Overlay
```

---

### 29. Accessibility Considerations
The visual depth system is optimized to support diverse accessibility needs:
* **Color Blind Support:** Meaning must never be conveyed solely by container color or elevation shifts. Containers must work alongside explicit text labels, mathematical symbols, and structural badges to communicate status clearly.
* **Responsive Sizing:** Surface paddings, margins, and boundaries use logical spacing tokens, allowing containers to scale up dynamically without clipping or overlapping content when system-level text magnification is enabled.

---

### 30. High Contrast Strategy
For users with low vision or high visual fatigue, BankYar provides an enforced High Contrast Theme:
* **Borders Only:** In high contrast mode, all drop shadows, ambient glow, and subtle opacity overlays are completely disabled.
* **Enforced Outlines:** Containers must rely exclusively on thick, high-contrast solid borders (`bankyar.border.width.thick`), guaranteeing maximum visibility.
* **Contrast Ratios:** Contrast between text, background surfaces, and borders is programmatically verified to meet strict WCAG AAA standards.

---

### 31. Focus Ring Strategy
Focus indicators are a critical requirement for accessibility, supporting screen readers, external keyboards, and switch controls:
* **High Contrast Outline:** Focused elements must render a clear, high-contrast outline indicator using the focused active border token (`bankyar.semantic.color.border.active`).
* **Double-Layer Ring:** To ensure visibility against any background, the focus indicator uses a double-layered outline: an inner white ring followed by an outer high-contrast primary color ring.

---

### 32. Disabled Surface Strategy
Deactivated buttons, inputs, and actions must communicate their inactive state clearly while remaining accessible:
* **Flat Gray Fill:** Disabled components use a flat, low-contrast gray background fill (`bankyar.semantic.color.disabled.background`), signaling that they are inactive.
* **Deactivated Touch:** Interactive touch listeners are completely disabled, preventing accidental triggers.
* **Reduced Opacity:** Text and icon elements within disabled containers use reduced opacity levels, communicating the inactive status while preserving legibility.

---

### 33. Hover / Pressed Surface Behavior
Interactive surfaces provide immediate visual feedback during user touch or pointer events:
* **Pointer Hover:** Confirms active target selection by applying a subtle contrast adjustment to the container background.
* **Tactile Pressed State:** When pressed, containers indicate the touch event by applying a slightly darker shade or compressing slightly, confirming the interaction within under 100 milliseconds.

---

## Part 7: Token Mapping, Governance, & System Evolution

### 34. Surface Token Mapping
This matrix defines how the semantic surface and elevation layers map back to the global design token dictionary:

| Component Token Name | Target Property | Semantic Source Reference | State Modification Map |
| :--- | :--- | :--- | :--- |
| `bankyar.component.card.ledger.background` | Card fill color | `bankyar.semantic.color.surface.default` | Pressed: Shift tint scale +1 step. |
| `bankyar.component.card.ledger.border` | Card boundary line | `bankyar.semantic.color.border.default` | Focused: Active double-layer outline. |
| `bankyar.component.button.primary.fill` | Button background | `bankyar.semantic.color.action.primary` | Disabled: Flat gray fill + opacity overlay. |
| `bankyar.component.input.text.border` | Textfield outline | `bankyar.semantic.color.border.default` | Active: Thick focus border token. |

---

### 35. Governance Rules
To prevent visual fragmentation and protect the integrity of the design system, all design contributions must comply with the following governance rules:

1. **Mandatory Token Usage:** Every visual property must reference an architectural design token. Hardcoded visual values or raw hex colors are strictly prohibited.
2. **One Meaning Per Container:** Surface layers must remain predictable. Reusing custom shapes, unique curvatures, or custom borders outside of the approved token configurations is prohibited.
3. **Borders Before Elevation:** Outlines and margins are our primary containment tool. Elevation is earned, and shadows must only be added when whitespace and borders are insufficient.
4. **Approval Required:** Any addition of new elevation levels, custom shadow tokens, or custom curvatures requires approval from the Design System Governance Board.

---

### 36. Validation Rules
The design system compiler validates all token definitions against a strict rule set before deployment:

* **No Direct Raw Values:** Semantic and component tokens must never directly define raw values (e.g., HEX colors or pixel values).
* **Valid Token References:** Every token reference must point to an active, valid token path within the system schema.
* **Enforced Contrast:** Text, icon, and focus tokens are programmatically verified to ensure they meet WCAG AA contrast standards against their underlying surfaces.

---

### 37. Anti-pattern Catalog
The following visual and architectural anti-patterns are strictly prohibited:

* **Deep Shadows & Neumorphism:** Direct use of heavy, dark, glowing shadows or glowing gradients on cards and containers is prohibited.
* **Arbitrary Curvatures:** Creating custom roundings or combining different corner radii inside a single container (e.g., mixing a large curve with flat corners on a standard card) is prohibited.
* **Elevation-Only Status:** Displaying transaction statuses, financial categories, or form validation errors using elevation or shadow changes alone, without adding explicit text labels or icons.
* **Floating Bloat:** Placing multiple floating action buttons on a single screen, or using expanding "radial" action buttons.

---

### 38. Migration Strategy
To transition the existing codebase to the structured Surface and Elevation System, developers follow a phased migration plan:

```
+-------------------+     +-------------------------+     +------------------------+
| 1. Audit & Map    | --> | 2. Refactor Containers  | --> | 3. Enforce & Automate  |
| (Identify raw     |     | (Replace raw margins,   |     | (Configure linter      |
| shadows, borders) |     | borders with tokens)    |     | and compile-time rules)|
+-------------------+     +-------------------------+     +------------------------+
```

1. **Audit & Map (Phase 1):** Identify and map all raw curvatures, custom outlines, and manual elevation definitions in the codebase, establishing corresponding tokens in the design dictionary.
2. **Refactor Containers (Phase 2):** Replace raw styling references with token paths across all UI components, buttons, fields, and page layouts.
3. **Enforce & Automate (Phase 3):** Configure linter rules and compile-time validation checks to prevent the addition of raw visual definitions.

---

### 39. Future Evolution Strategy
As BankYar expands, the Surface and Elevation System is built to scale:
* **Universal Portability:** The design system is platform-agnostic, easing future integration with target platforms (such as iOS and desktop environments).
* **Multi-Brand Compatibility:** Theme tokens isolate visual styles from component logic, allowing the design system to support new visual configurations, white-label requests, and future localization requirements without changes to the core layout code.
* **Backward Compatibility:** Deprecated tokens must follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing development teams with clear migration pathways between updates.

---

### 40. Review Checklist
Before implementing a screen or component layout, verify compliance against this checklist:

- [ ] Does the screen focus on a single, clear primary goal?
- [ ] Are all container elevations, borders, and curvatures mapped directly to design tokens?
- [ ] Are all drop shadows, ambient glow, and visual gradients excluded?
- [ ] Do interactive elements indicate press and touch events using subtle background tints instead of visual lifts?
- [ ] Do focused elements render a clear, high-contrast double-layer outline?
- [ ] Are all Persian text layouts aligned RTL-first within their containing cards?
- [ ] Does the screen maintain clear visual contrast and accessibility labeling across active themes?

---
**End of Document**
