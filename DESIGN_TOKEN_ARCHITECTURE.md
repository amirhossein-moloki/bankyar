# BankYar Design Token Architecture

## Executive Summary
This document establishes the official, enterprise-grade Design Token Architecture for BankYar. Designed to implement the core product personality (Stoic, Precise, Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this architecture serves as the single source of truth for all visual properties. It is built to ensure strict consistency, platform independence, dark mode adaptivity, and seamless RTL (Persian) support in Flutter and future target environments.

Every component, element, and interface property must map to these architectural token constructs. No raw, hardcoded design values are permitted anywhere in the BankYar ecosystem.

---

## 1. Token Philosophy
Our design token philosophy is built on three core tenets:
* **Strict Abstraction:** No visual layer may directly access a raw value. Values must be packaged into layered concepts that separate *what a value is* (Global) from *how it behaves* (Semantic) and *where it is used* (Component).
* **Platform Independence:** Tokens are defined in a platform-agnostic format (such as JSON or YAML schemas) and compiled into target formats (such as Flutter Dart, CSS, or JSON) via a automated pipeline.
* **Deterministic Scalability:** Any future theme, brand variation, white-label setup, or localization (such as English LTR) must be achievable solely by changing the token maps without modifying UI layout structures or component code.

---

## 2. Token Naming Convention
To enforce programmatic safety, readability, and automatic schema parsing, BankYar utilizes a strict, structured BEM-inspired taxonomy. Every token is represented by a lowercase, dot-separated dot-notation path complying with the following layout structure:

`[namespace].[category].[type].[item].[variant].[state]`

### Token Naming Taxonomy Table
| Token Segment | Description | Example Choices |
| :--- | :--- | :--- |
| **namespace** | Identifies the product or library | `bankyar` |
| **category** | The main visual domain | `color`, `space`, `font`, `radius`, `elevation`, `motion` |
| **type** | The sub-classification of the property | `primary`, `neutral`, `border`, `interactive`, `size`, `weight` |
| **item** | The specific functional element | `background`, `accent`, `title`, `body`, `button`, `card` |
| **variant** | Optical weight or sizing variations | `xs`, `sm`, `md`, `lg`, `xl`, `heavy`, `light`, `bold` |
| **state** | Interactive/system state modifier | `default`, `hover`, `focus`, `pressed`, `disabled`, `error` |

### Architectural Naming Standards
* **No Hardcoded Meanings:** Names like `color.red` are prohibited. Instead, use `color.neutral.danger` or `color.semantic.destructive`.
* **Zero Ambiguity:** Every level of the hierarchy must add distinguishing information.
* **Lowercase Only:** Avoid camelCase or snake_case inside the standard naming schema. Use lowercase dot-separated notation.

---

## 3. Token Hierarchy
To prevent duplication and guarantee maintenance integrity, BankYar employs a hierarchical 5-layer design token system:

```
+--------------------------------------------------------------+
|                     1. Foundation / Global                   |
|  (Raw values mapped to generic aliases: color.palette, etc.) |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                      2. Semantic Layers                      |
| (Abstracted context: color.surface, space.layout, text.body) |
+--------------------------------------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                     3. Component Tokens                      |
|   (Context-specific: button.background, card.border.radius)  |
+--------------------------------------------------------------+
            /                  |                  \
           v                   v                   v
+--------------------+ +--------------------+ +--------------------+
|  4. Theme Tokens   | |  5. State Tokens   | |  6. Layout Tokens  |
|  (Dark, High-Con)  | | (Pressed, Disable) | | (RTL/LTR, Density) |
+--------------------+ +--------------------+ +--------------------+
```

### Dependency Flow and Rules
1. **Global Tokens** never reference other tokens; they represent the absolute values.
2. **Semantic Tokens** must *always* reference a Global Token. They are never allowed to define raw values.
3. **Component Tokens** must *always* reference either a Semantic Token or, in highly exceptional scenarios, a Global Token if no matching semantic alias exists.
4. **Theme, State, and Layout Layers** override or swap the mappings of semantic/component tokens without touching the structural layout definitions.

---

## 4. Global Tokens
Global tokens are the fundamental building blocks of our visual system. They assign platform-agnostic, generic names to raw values so they can be managed in one central place. They have no semantic meaning on their own.

### Global Token Registry Standard
| Global Token Name | Category | Reference Value Concept | Purpose |
| :--- | :--- | :--- | :--- |
| `bankyar.global.color.gray.alpha` | Color | Base Neutral (Lightest) | Neutral background scales |
| `bankyar.global.color.gray.omega` | Color | Base Neutral (Darkest) | High-contrast text scales |
| `bankyar.global.color.emerald` | Color | Brand Primary Accent | Main brand color concept |
| `bankyar.global.color.sapphire` | Color | Brand Secondary Accent | Secondary accent and branding |
| `bankyar.global.color.ruby` | Color | Destructive / Danger Accent | System-level error indicator |
| `bankyar.global.space.base` | Spacing | System Base Grid Unit | Multiplier root for all layout spaces |
| `bankyar.global.font.family.primary` | Typography | Font Family (Persian optimized)| Native RTL Persian font stack |
| `bankyar.global.font.family.mono` | Typography | Monospace Font Family | Mathematical alignment font |

---

## 5. Semantic Tokens
Semantic tokens communicate *intent* and *purpose*. They assign meanings to our global tokens based on how they are used within the user experience, shielding components from raw visual values.

### Semantic Mapping Standard
| Semantic Token Name | Source Token (Global Link) | Architectural Intent |
| :--- | :--- | :--- |
| `bankyar.semantic.color.background` | `bankyar.global.color.gray.alpha` | The default application canvas background |
| `bankyar.semantic.color.surface` | `bankyar.global.color.gray.beta` | Standard flat containment cards |
| `bankyar.semantic.color.text.primary` | `bankyar.global.color.gray.omega` | Maximum contrast reading text |
| `bankyar.semantic.color.text.secondary` | `bankyar.global.color.gray.gamma` | Mid-contrast helper text & metadata |
| `bankyar.semantic.color.accent` | `bankyar.global.color.emerald` | Interactive focal points |
| `bankyar.semantic.color.danger` | `bankyar.global.color.ruby` | Error messages, destructive action indicators |
| `bankyar.semantic.space.gap.xs` | `bankyar.global.space.base` x factor | Micro gaps (e.g., icon to text) |
| `bankyar.semantic.space.gap.md` | `bankyar.global.space.base` x factor | Macro gaps (e.g., container padding) |

---

## 6. Component Tokens
Component tokens represent the most specific tier of the architecture. They map directly to individual component properties, decoupling the styling of specific UI modules from the overall theme definitions.

### Component Layer Architecture Standard
```
[Component Name] -> [Element Type] -> [Property Type] -> [State]
```

### Component Token Registry Examples
| Component Token Name | Target Property | Semantic Source Map |
| :--- | :--- | :--- |
| `bankyar.component.button.primary.fill` | Button background fill | `bankyar.semantic.color.accent` |
| `bankyar.component.button.primary.label` | Button text color | `bankyar.semantic.color.background` |
| `bankyar.component.card.ledger.background`| Ledger card fill | `bankyar.semantic.color.surface` |
| `bankyar.component.card.ledger.padding` | Ledger inner spacing | `bankyar.semantic.space.gap.md` |
| `bankyar.component.input.text.border.active` | Focused textfield outline | `bankyar.semantic.color.accent` |

---

## 7. Theme Tokens
Theme tokens manage the structural switching of entire color palettes or visual treatments. In BankYar, themes are treated as context maps that alter the global references of semantic tokens.

### Theme Resolution Architecture
```
[Active Theme State (e.g., Light / Dark / High-Contrast)]
                           |
                           v
    [Overridden Global Reference Table Mapping]
                           |
                           v
[Semantic Token: bankyar.semantic.color.background]
                           |
                           v
  [Translates dynamically based on active theme]
```

* **Zero Layout Impact:** Switching themes must never affect sizes, curves, layout coordinates, or text alignments.
* **Component-Level Immunity:** Components are blind to active themes. They only query component/semantic tokens, which resolve their underlying values based on the active Theme Map.

---

## 8. State Tokens
State tokens capture the interactive state of components (such as default, hover, focused, pressed, disabled, and error). They act as dynamic overrides applied to component tokens during user interaction.

### Interactive State Formula
`Active Visual Value = Base Component Token * State Modifier Token`

### State Modifier Standard
| State Identifier | Applied Modifier / Behavior | Expected UX Feedback |
| :--- | :--- | :--- |
| `default` | 100% of base semantic mapping | Stable base visual representation |
| `hover` | Shift contrast value by scale factor | Instant visual feedback on hover/pointer overlap |
| `pressed` | Scale/Contrast mutation factor | Strong, immediate validation of input touch |
| `disabled` | Flat opacity overlay / Grayscale shift | Indication of unavailable or locked action |
| `error` | Accent mapping shift | Input validation warning overlay |

---

## 9. Layout Tokens
Layout tokens dictate the spatial scaffolding, containment alignment, and structural flow of all BankYar interfaces. They define the boundaries that organize financial data into a clean, easy-to-scan hierarchy.

### Layout Token Standards
* **Orientation Agnostic:** Layout tokens must support both portrait and landscape orientation without restructuring.
* **Direction Independent:** Standard layout structures must support RTL (Right-to-Left) mirroring natively.
* **Padding Hierarchy:** Inner container spacing must grow proportionally with container scale.

---

## 10. Responsive Tokens
Responsive tokens adapt the spacing, container scales, and visibility rules of the interface dynamically across distinct form factors.

### Device Class Mapping Schema
| Token Name | Form Factor Type | Intent |
| :--- | :--- | :--- |
| `bankyar.responsive.target.phone` | Phone | Single-column, thumb-centric, high-density |
| `bankyar.responsive.target.foldable`| Foldable Devices | Adaptive multi-column, expandable details pane |
| `bankyar.responsive.target.tablet` | Tablet | Split-pane navigation, persistent lateral master-details |
| `bankyar.responsive.target.landscape`| Landscape Mode | Horizon alignment, minimized top/bottom paddings |
| `bankyar.responsive.target.split` | Split Screen | Reduced density list views, condensed headers |

---

## 11. Motion Tokens
In accordance with our *Stoic* and *Performance-First* design principles, motion tokens are strictly structured to aid utility and structural understanding. Decorative animations are entirely prohibited.

### Motion Token Attributes
* **Duration Limits:** All visual transition durations must be kept short to prevent slowing down the user.
* **Ease Profiles:** Motion curves must feel linear and consistent, avoiding dramatic, bouncy, or playful transitions.
* **Spatial Logic:** Transitions must help the user track where elements come from and where they go (e.g., a detail pane expanding out of a tapped transaction card).

---

## 12. Elevation Tokens
Elevation tokens establish clear visual depth and structure through surface layering, helping users understand content priority without relying on heavy borders or gradients.

### Elevation Hierarchy
| Elevation Token | Layer Intent | Visual Layer Priority |
| :--- | :--- | :--- |
| `bankyar.elevation.level.zero` | Flat Application Canvas | Lowest priority (system background) |
| `bankyar.elevation.level.one` | Standard Content Cards | Grouped data (transaction feed, settings item) |
| `bankyar.elevation.level.two` | Sticky/Floating Controls | Quick actions, persistent navigation bars |
| `bankyar.elevation.level.three` | Modals & Overlay Sheets | Interruption controls, bottom sheets (highest priority) |

---

## 13. Radius Tokens
Radius tokens define the roundness of visual containers, creating a unified and professional aesthetic across the application.

### Radius Scale Standards
| Token Name | Target Interface Element | Structural Intent |
| :--- | :--- | :--- |
| `bankyar.radius.none` | Screen-edge banners, full-width inputs | Zero rounded corners, maximizes edge alignment |
| `bankyar.radius.sm` | Checkboxes, minor tags, badges | Tight curvature for small, sharp visual structures |
| `bankyar.radius.md` | Primary buttons, text input fields | Moderately rounded corners for interactive touch points |
| `bankyar.radius.lg` | Financial transaction cards, list containers | Elegant framing for primary grouped items |
| `bankyar.radius.xl` | Bottom modal sheets, main dialogue panels | Strong containment framing for overlays |

---

## 14. Border Tokens
Border tokens define the thickness, style, and contrast of container boundaries, ensuring consistent grouping of information without adding unnecessary visual weight.

### Border Standard Specifications
| Token Name | Property Class | Architectural Intent |
| :--- | :--- | :--- |
| `bankyar.border.width.none` | No Outline | Seamless edge-to-edge container styling |
| `bankyar.border.width.thin` | Hairline separator | Subtle division (e.g., between transactions) |
| `bankyar.border.width.thick` | Focus indicator / Active boundary| Accentuated contrast (e.g., active input field) |
| `bankyar.border.style.solid` | Solid line | Default visual separation styling |
| `bankyar.border.style.dashed`| Dashed line | Area for importing, file drops, or empty states |

---

## 15. Shadow Tokens
Shadow tokens represent the soft, non-intrusive ambient occlusion fields that simulate physical depth in our elevation model.

### Shadow Styling Principles
* **Low Intensity:** Shadows must remain subtle, avoiding dark, high-contrast, or colored offsets.
* **Consistent Light Angle:** Ambient lighting is modeled from directly above (top-down), casting symmetrical or slightly downward offsets.
* **Color Neutrality:** Shadows are derived from neutral grayscale values, never using brand colors or vivid accents.

---

## 16. Opacity Tokens
Opacity tokens establish relative hierarchy and visual state transitions, ensuring accessibility and readable layering.

### Opacity Mapping Standard
| Token Name | Percentage Concept | Architectural Application |
| :--- | :--- | :--- |
| `bankyar.opacity.opaque` | 100% | Standard solid text, buttons, and elements |
| `bankyar.opacity.intense` | High | Highlighted subtext, auxiliary content headers |
| `bankyar.opacity.medium` | Medium | Disabled labels, secondary transaction metadata |
| `bankyar.opacity.light` | Low | Inactive states, empty text prompts, subtle background tints |
| `bankyar.opacity.translucent`| Very Low | Soft overlay screens, scrims behind modal sheets |

---

## 17. Icon Size Tokens
Icon size tokens regulate the physical scale of all graphical symbols across the system, ensuring standard touch zones and consistent visual hierarchy.

### Icon Scale Table
| Token Name | Sizing Concept | Intended Application |
| :--- | :--- | :--- |
| `bankyar.icon.size.sm` | Compact | Inline text indicators, minor transaction category badges |
| `bankyar.icon.size.md` | Standard | Primary navigation actions, standard transaction feeds |
| `bankyar.icon.size.lg` | Large | Core actions, dialog headers, empty-state illustrations |

---

## 18. Font Size Tokens
Font size tokens define our responsive typographical scale, ensuring that Persian character complex structures remain readable and clean at any magnification.

### Font Size Scales
| Token Name | Scale Category | Intended Visual Target |
| :--- | :--- | :--- |
| `bankyar.font.size.xs` | Micro | Footnotes, minor metadata timestamps, status labels |
| `bankyar.font.size.sm` | Caption | Secondary transaction descriptions, secondary menu subtext |
| `bankyar.font.size.md` | Body | Default readable body text, input labels, text descriptions |
| `bankyar.font.size.lg` | Subtitle | Section headers, card titles, list categories |
| `bankyar.font.size.xl` | Title | Ledger account balances, prominent transaction amounts |
| `bankyar.font.size.xxl` | Headline | Primary dashboard overview balance numbers |

---

## 19. Font Weight Tokens
Font weight tokens map standard typographical weights to Persian-optimized font attributes, supporting clear hierarchy through weight variations.

### Font Weight Mapping Standard
| Token Name | weight level | Persian Adaptation Guidelines |
| :--- | :--- | :--- |
| `bankyar.font.weight.light` | Light weight scale | Reserved for large headers where stroke width is thick |
| `bankyar.font.weight.regular`| Regular weight scale| Standard reading body copy, text descriptions, notes |
| `bankyar.font.weight.medium` | Medium weight scale | Input text fields, card titles, buttons |
| `bankyar.font.weight.bold` | Bold weight scale | Transaction amount numbers, primary status headers |

---

## 20. Line Height Tokens
Line height tokens define the vertical spacing between text rows, protecting against overlapping ascenders/descenders in Persian text layouts.

### Line Height Scale Standard
| Token Name | Ratio Scale Factor | Typographical Alignment |
| :--- | :--- | :--- |
| `bankyar.font.leading.tight` | Low factor | Large headlines and numbers (decreases vertical spacing) |
| `bankyar.font.leading.standard`| Medium factor | Standard subtitle headers and section listings |
| `bankyar.font.leading.loose` | High factor | Default body reading paragraphs, notes, and raw SMS blocks |

---

## 21. Letter Spacing Tokens
Letter spacing tokens dictate text tracking. Because Persian character connections are cursive, tracking must be handled with architectural care.

### Persian Letter Spacing Rules
* **No Negative Tracking:** Negative letter spacing is entirely prohibited for Persian fonts, as it breaks standard character connection baselines.
* **Monospace Exemption:** Tracking/letter spacing tokens may only be applied to non-cursive fields, such as transaction cards containing numerical values or Western reference tokens (e.g., transaction IDs, IBANs, or transaction dates).

---

## 22. Grid Tokens
Grid tokens define the responsive visual alignment system for our layouts, ensuring clean and consistent reading lines on all devices.

### Grid Parameter Schema
| Token Name | Structure Property | Intent |
| :--- | :--- | :--- |
| `bankyar.grid.columns` | Column Count | Number of structural vertical lanes for visual chunking |
| `bankyar.grid.margin` | Outer Padding | Margin space between screen borders and the outermost column |
| `bankyar.grid.gutter` | Inter-column Spacing| Padding space between individual structural lanes |

---

## 23. Spacing Tokens
Spacing tokens establish the scale for all margin, padding, and gap properties, providing a consistent layout rhythm throughout the application.

### Spacing Scale Formula
`Spacing Value = Base Grid Factor * Step Multiplier`

### Spacing Token Register
* `bankyar.space.xxs` (Micro-spacing: tight alignment markers, indicator dots)
* `bankyar.space.xs` (Compact element gap: icon next to short text, category tag layout)
* `bankyar.space.sm` (Standard element gap: inner text block separations, input field layouts)
* `bankyar.space.md` (Standard container padding: transaction card inner boundaries)
* `bankyar.space.lg` (Macro layout spacing: screen padding, dashboard card separations)
* `bankyar.space.xl` (Extreme layout separation: bottom action buttons spacer)

---

## 24. Breakpoint Tokens
Breakpoint tokens represent the screen width thresholds that trigger layout transitions across different device classes.

### Breakpoint Threshold Specifications
| Token Name | Width Property | Architectural Intent |
| :--- | :--- | :--- |
| `bankyar.breakpoint.compact` | Lower bound boundary | Small smartphone form factors |
| `bankyar.breakpoint.medium` | Medium width scale | Larger smartphones, foldables, compact tablets |
| `bankyar.breakpoint.expanded`| Upper bound boundary | Large tablets and future desktop environments |

---

## 25. Z-index Tokens
Z-index tokens establish deterministic stack layout coordinates, ensuring consistent overlay behavior.

### Z-Index Scale Standard
| Token Name | Stack coordinate level | Layout Application |
| :--- | :--- | :--- |
| `bankyar.zindex.base` | Ground | Standard scroll canvas background items |
| `bankyar.zindex.surface` | Raised | Standard cards, lists, layout components |
| `bankyar.zindex.sticky` | Fixed | Lateral navigation rails, headers |
| `bankyar.zindex.overlay` | Floating | Floating quick actions, snackbars, status overlays |
| `bankyar.zindex.modal` | Sheet | Bottom modal panels, dialogues (highest stacking level) |

---

## 26. Duration Tokens
Duration tokens define the physical time intervals of transition frames, supporting our *Performance-First* design principles.

### Duration Parameter Table
| Token Name | Time Interval Concept | Architectural Intent |
| :--- | :--- | :--- |
| `bankyar.motion.duration.instant` | Extreme speed | Structural UI state changes (e.g., immediate switch) |
| `bankyar.motion.duration.fast` | Rapid | Component transitions (e.g., button feedback, active focus) |
| `bankyar.motion.duration.medium` | Balanced | Card expansions, slide-up bottom modal sheets |

---

## 27. Animation Curve Tokens
Animation curve tokens dictate the velocity transitions of our motions.

### Animation Curve Standards
* `bankyar.motion.curve.linear` (Used for absolute flat opacity changes)
* `bankyar.motion.curve.standard` (Used for subtle, natural spatial expansions like a card detail view opening)
* `bankyar.motion.curve.decelerate` (Used for entry transitions, bringing elements to an ultra-fast stop)
* `bankyar.motion.curve.accelerate` (Used for exit transitions, moving elements off-screen rapidly)

---

## 28. Interaction Tokens
Interaction tokens define touch targets and gestures to ensure comfortable one-handed use.

### Interaction Targets
* **Standard Touch Target:** The minimum touch target size must comply with standard physical limits to prevent mis-taps.
* **Comfort Zones:** High-priority buttons and interactive lists must reside in the lower half of the screen, ensuring comfortable one-handed reach.

---

## 29. Focus Tokens
Focus tokens specify the visual behavior of focused components, supporting screen readers and external keyboards.

### Focus Visual Standards
* **High Contrast Outline:** Focused elements must be highlighted with a highly visible focus ring.
* **Color Neutrality:** Focus rings must use high-contrast primary tokens to ensure visibility in both light and dark themes.

---

## 30. Accessibility Tokens
Accessibility tokens ensure the interface remains highly readable and easy to navigate for all users, implementing the core tenets of `DESIGN_PHILOSOPHY.md`.

### Accessibility Parameter Standards
| Token Name | Accessibility Domain | Architectural Requirement |
| :--- | :--- | :--- |
| `bankyar.accessibility.text.scale` | Typographical Size | Support system-level large font magnification |
| `bankyar.accessibility.motion.toggle`| System Animation Status | Disable motions instantly if reduced motion is enabled |
| `bankyar.accessibility.contrast.level`| Visual Contrast Ratio | Guarantee 4.5:1 ratio for body and 3:1 for headers |

---

## 31. Density Tokens
Density tokens adjust component sizes based on screen real estate and active user preference.

### Density Scales
| Token Name | Scaling Factor | Layout Application |
| :--- | :--- | :--- |
| `bankyar.density.comfortable` | Standard spacing | High readability on phones and small tablets |
| `bankyar.density.compact` | Reduced spacing | High data density on dashboards and lists |

---

## 32. RTL Tokens
RTL tokens govern the logical mirroring of coordinates, padding, gestures, and direction indicators in Persian layouts.

### Mirroring Layout Logic
```
LTR Environment: [margin-left: 16] -> RTL Environment: [margin-right: 16]
LTR Environment: [arrow-right]     -> RTL Environment: [arrow-left]
```

* **Logical Margins:** Padding and margins must be declared logically (e.g., start and end instead of left and right) to ensure seamless RTL scaling.
* **Mirrored Gestures:** Swipe directions, carousels, and progress tracks must mirror dynamically.

---

## 33. Dark Theme Strategy
The dark theme strategy overrides semantic mappings to optimize contrast and comfort in low-light environments.

### Dark Theme Principles
* **Deep Grayscale Canvas:** The background uses deep neutral grays to minimize eye strain.
* **Accessible Contrast:** Contrast ratios must be verified to ensure body text and functional accents remain readable against dark backgrounds.
* **Elevation via Opacity:** Instead of heavy shadows, elevation in the dark theme is communicated by applying soft white opacity overlays to container surfaces.

---

## 34. Future Theme Strategy
The future theme strategy ensures the token system can easily adapt to future brand variations, white-label requests, or target platforms.

### Architecture for Theme Portability
```
                      [Active Theme Definition Schema]
                                     |
                                     v
                 [Map Global Tokens to Semantic Tokens]
                                     |
                                     v
          [Components Render Instantly with the New Visual Styling]
```

* **Logical Decoupling:** Theme styles are isolated from component layout logic, allowing the design system to support new visual configurations without changes to the UI codebase.

---

## 35. Versioning Strategy
To ensure stability across multiple developer teams and future cross-platform builds, the Design Token System utilizes a strict versioning protocol.

### Versioning Protocol
* **Semantic Versioning:** Follows MAJOR.MINOR.PATCH format.
* **Release Checklist:** Breaking changes (e.g., renaming a semantic token) require a major version bump and a migration guide.

---

## 36. Token Governance
Token governance rules protect the design system from unstructured additions and visual inconsistencies.

### Governance Rules
1. **Mandatory Token Usage:** Every visual property must reference an architectural design token. No hardcoded values are allowed.
2. **Platform Independence:** Tokens must be defined in a platform-neutral format (such as YAML/JSON schemas) and compiled into target files.
3. **No Unused Tokens:** Unreferenced tokens are strictly prohibited.
4. **Single Category Ownership:** Every token must belong to exactly one structural namespace and category.

---

## 37. Migration Strategy
The migration strategy outlines the process of replacing hardcoded styling with the structured token architecture.

### Migration Phases
1. **Auditing:** Identify and map all raw styling values in the codebase.
2. **Centralization:** Define the corresponding Global, Semantic, and Component tokens.
3. **Implementation:** Replace raw values with token references across all modules and tests.

---

## 38. Validation Rules
The validation rules ensure that all tokens are syntactically and structurally correct.

### Validation Rules
* **No Direct Raw Values:** Semantic and component tokens must never directly define raw values (e.g., HEX colors or pixel values).
* **Valid Token References:** Every token reference must point to an active, valid token path within the system schema.

---

## 39. Naming Validation
Naming validation ensures that all tokens comply with the standard taxonomy.

### Naming Conventions
* **Segment Alignment:** Every token name must consist of dot-separated lowercase segments matching the defined taxonomy.
* **No CamelCase:** Spaces, camelCase, and snake_case are prohibited within token paths.

---

## 40. AI Usage Rules
The AI usage rules guide automated tools and large language models on how to write code that adheres to the BankYar design system.

### AI Guidelines
* **No Hardcoded Values:** Do not generate style definitions containing hex colors or physical units (px/dp/sp).
* **Reference Tokens:** Always reference the structured token paths.
* **Logical Spacing:** Use start/end coordinates instead of left/right to ensure RTL compatibility.

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

## Appendix B: Best Practices
* **Keep Semantic Separation:** Never map a component token directly to a raw physical value. Always route through the semantic layer.
* **Design RTL-First:** Use logical directions (start, end) rather than physical directions (left, right) in layout spacing.
* **Enforce Clean Contrast:** Validate token contrast ratios programmatically inside the automated theme compilers.

---

## Appendix C: Trade-off Analysis
* **Strict Abstraction vs. Developer Velocity:** Creating three distinct token layers (Global -> Semantic -> Component) adds minor initial configuration overhead, but it guarantees absolute maintainability, future theme expansion, and effortless dark mode support.
* **Platform Independence vs. Platform-Native Conventions:** Standardizing on lowercase dot-notation (e.g., `bankyar.color.primary`) requires a translator pipeline for platforms like Flutter, but it secures multi-platform portability (for future iOS and desktop support) and acts as a single, objective source of truth.
