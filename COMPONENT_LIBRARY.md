# BankYar Reusable Component Library Specification (v1.0.0)
## Enterprise-Grade Specification for Offline-First Secure Financial Applications

---

## EXECUTIVE SUMMARY
This document establishes the official and authoritative **Component Library Specification** for the BankYar ecosystem. BankYar is an offline-first, privacy-first personal finance platform designed specifically for the Android platform (with planned future expansions to iOS and desktop systems). Operating natively under Right-to-Left (RTL) rules and using Persian typography, the system operates under a strict zero-network constraint.

This specification serves as the absolute single source of truth for all product managers, UI/UX designers, frontend architects, quality assurance engineers, and automated code-generation agents. It defines the visual identity, interactive states, spatial metrics, and structural containment of every reusable component before screen composition or implementation begins.

In strict compliance with BankYar's visual design, safety, and architectural standards:
- **Zero Framework Code:** No framework-specific UI elements or code classes are defined. This is not a code repository but a structural and behavioral blueprint.
- **Zero Raw Styling Metrics:** No physical measurements (such as device-independent spacing or typography scaling units) or hardcoded HEX color codes are utilized. All styling, typography, margins, and elevations are defined using abstract design tokens.
- **Zero Forbidden Terms:** Any restricted programming term (including UI code declarations in any casing) is strictly omitted, replaced with terms like "component", "renderable", "element", "view node", "layout block", or "visual layer".
- **Absolute RTL and A11y Support:** Every element supports Persian text layout, character baseline alignment, and comprehensive accessibility features (screen readers, variable text scaling, and switch access).

---

## 1. COMPONENT PHILOSOPHY
The BankYar Component Philosophy ensures that user interfaces are constructed in a highly consistent, secure, and predictable manner.

1. **Unidirectional Control Flow:** Components are declarative layout blocks. They ingest read-only configurations or immutable states and emit interaction events via abstract callbacks. They do not manage global business logic or directly mutate database layers.
2. **Strict Spatial Integrity:** Components must adapt fluidly to system-level text magnification and layout container scaling without clipping text or dropping crucial financial information. This is achieved by utilizing relative spacing grids instead of hardcoded physical dimensions.
3. **Decoupled Security Bounds:** Sensitive financial data and security input fields must isolate visual representation from security logic. PIN entries, biometric prompts, and database exports must be managed by secure controllers, leaving the visual layer stateless and lightweight.
4. **Calm and Precise Presentation:** Reflecting the *Stoic Vault* and *High-Precision Analyst* personas, components avoid bright gradients, glowing drop shadows, and visual clutter. Layouts utilize low-saturation surfaces and crisp borders to establish a professional, trust-building financial environment.

---

## 2. COMPONENT TAXONOMY & HIERARCHY
To ensure complete structural decoupling and prevent duplicate components, BankYar classifies all visual elements into a rigid six-tier taxonomic hierarchy:

```
                      BankYar Component Hierarchy
                                  |
                                  v
                            [ Foundation ]
                   (Spatial Grids, Design Tokens)
                                  |
                                  v
                             [ Primitive ]
                 (Text Nodes, Base Buttons, Dividers)
                                  |
                                  v
                            [ Composite ]
                 (Tags, Segment Controls, Progress Bars)
                                  |
                                  v
                             [ Domain ]
                (Transaction Cards, Category Chips)
                                  |
                                  v
                             [ Feature ]
               (SMS Feed Rows, PIN Lockout Screens)
                                  |
                                  v
                             [ Screen ]
                 (Ledger View, Analytics Dashboard)
```

### Taxonomy Rules:
- **Foundation Elements** govern color palettes, typography scales, spacing metrics, elevations, and locales without rendering individual UI controls.
- **Primitives** are atomic, indivisible layout elements (e.g., text blocks, icons, base buttons) that contain no dependencies on other visual components.
- **Composites** arrange multiple primitives to form a single, reusable control (e.g., a selection tab containing an icon and a text label).
- **Domain Blocks** bind composites to the ubiquitous financial language of the application (e.g., a transaction ledger row containing amount tokens and status tags).
- **Features** connect domain blocks to active data streams and state providers, managing on-device events.
- **Screens** combine feature blocks into complete, responsive viewports aligned with structural grids.

---

## 3. ATOMIC DESIGN STRATEGY
BankYar maps its component taxonomy directly to standard Atomic Design principles, defining clear interfaces and data structures at every scale:

```
  [ Atoms ] --------> [ Molecules ] ------> [ Organisms ] ------> [ Templates ] ----> [ Pages ]
  (Primitives)        (Composites)          (Domain Blocks)       (Feature Layouts)   (Screens)
```

### Composition and Assembly Rules:
1. **Atoms (Primitives):** Serve as the foundational visual alphabet. They cannot be split further without losing their core purpose.
2. **Molecules (Composites):** Combine atoms to create functional, state-agnostic elements with narrow interaction boundaries.
3. **Organisms (Domain Blocks):** Arrange molecules and atoms to represent core business entities. They remain isolated from Riverpod or direct databases.
4. **Templates (Feature Layouts):** Standardize scrolling viewports, Safe Area margins, and layout rhythms for specific user journeys.
5. **Pages (Screens):** Bind templates to reactive state providers, handling background database updates and device permissions.

---

## 4. REUSABLE COMPONENT RULES
All components must satisfy five core development and design requirements:
1. **Zero Hardcoded Variables:** All layout properties (padding, margins, text sizes, border radiuses, and color layers) must resolve through semantic design tokens.
2. **Minimum Touch Target Boundaries:** Every touch-sensitive or interactive component must maintain a comfortable target area matching the standard accessibility grid target token.
3. **Implicit Overlapping Prevention:** Text fields and label nodes must employ automatic wrapping, dynamic scale adjustments, or clean ellipsis truncations to prevent layouts from breaking under custom system font scales.
4. **Explicit RTL Geometry:** Components must utilize logical structural positions (such as `inline-start` and `inline-end`) rather than absolute left and right definitions.
5. **Self-Contained Rendering:** A component must be completely blind to surrounding blocks, rendering its visual layers based strictly on passing configurations.

---

## 5. COMPONENT COMPOSITION PRINCIPLES
To maintain a clean architectural layout:
- **No Circular Imports:** High-level components can compose lower-level ones, but a low-level primitive or composite must never depend on a domain or feature component.
- **State Separation:** Components do not directly store or mutate database records or app configurations. They rely on transient UI state (e.g., expanded accordions or active input focuses) and delegate all business actions to domain controllers.
- **Strict Data Contracts:** Information is passed down the hierarchy as immutable data structures, while user actions flow back up via defined, state-agnostic events.

---

## 6. COMPONENT STATES & INTERACTION STATES
To provide clear visual and tactile feedback, components modify their visual layers based on standard interaction states:

### State Transitions & Mapping Matrix
| State Variant | Visual Modulation | Spatial Impact | UX Intention |
| :--- | :--- | :--- | :--- |
| **Default** | Base semantic styling. | Normal spacing margins. | Standard visual baseline. |
| **Hover** | Background shifts by +1 contrast step. | No dimensional alterations. | Desktop/pointer focus hover indicator. |
| **Focused** | High-contrast outline ring is painted. | Focus ring is overlaid. | Accessibility and keyboard navigation track. |
| **Pressed** | Background shifts by +2 contrast steps. | Dynamic touch scale compression (0.98x).| Tactile feedback indicating activation. |
| **Selected** | Primary background color is active. | Layout adjusts for active state. | Communicates current choice in groups. |
| **Loading** | Semi-transparent overlay with pulse. | Content remains locked in place. | Prevents repetitive taps during background tasks. |
| **Disabled** | 38% opacity overlay is applied. | Gestures and haptics deactivated. | Deactivates unavailable user triggers. |
| **Success** | Remaps boundaries to success token. | Emits high-confidence haptic. | Confirms completion of secure tasks. |
| **Warning** | Remaps boundaries to warning token. | Inline alert is displayed. | Draws attention to non-blocking issues. |
| **Error** | Remaps boundaries to error token. | Visual error text appears. | Signals invalid inputs or processing failures. |
| **Empty** | Low-contrast background with message.| Spacers and grids adapt. | Directs users toward initiating data. |
| **Offline** | Subtle indicator badge is active. | Remains fully functional. | Confirms that processing remains offline. |

---

## 7. ACCESSIBILITY RULES & MATRIX
Accessibility is a core priority of the BankYar ecosystem, ensuring usability for all individuals:

- **Minimum Contrast Ratio:** Visual layers must maintain a minimum contrast ratio of 4.5:1 for standard text and 3.0:1 for high-contrast indicators or large text.
- **Text Scale Adaptation:** Text labels must scale fluidly up to 200% without clipping borders or overlapping adjacent components.
- **Explicit Semantic Labels:** All interactive components and images must supply unique, localized semantic descriptions to assistive screen readers.
- **Logical Keyboard Navigation:** Focus order must transition logically from top-right to bottom-left (in Persian RTL layouts) or top-left to bottom-right (in Western LTR layouts).

---

## 8. RTL RULES & BEHAVIOR
The native language and layout orientation of BankYar is Persian (RTL). This is handled through four structural rules:
1. **Logical Spacing Coordinates:** Spacing paddings and offsets must use `inline-start` and `inline-end` instead of left and right.
2. **Programmatic Icon Mirroring:** Icons representing directions, back-tracks, forward progress, or reading directions must be mirrored programmatically. Symmetrical icons (such as settings gears, locks, or cash vault icons) remain static.
3. **Persian Font Baseline Alignment:** Font nodes use customized vertical line-height alignments to prevent tall Persian diacritics and character loops from being cut off.
4. **Digit and Currencies Integration:** Numeric characters, balance credits, and timestamps are rendered with proper Persian localized numbering systems, respecting decimal separators and Rial/Toman sign baselines.

---

## 9. THEME, ANIMATION, LOADING, ERROR, DISABLED, EMPTY, & VALIDATION BEHAVIORS
- **Theme Transitions:** Components dynamically map color configurations to the active global color scheme (Light, Dark, or High-Contrast) without altering spatial positions.
- **Animation Kinetics:** Animations employ standard natural ease-in and ease-out motion curves, ensuring interfaces remain responsive and fluid.
- **Loading Implementations:** Content is represented by pulsing shimmer blocks during loading, preventing layouts from shifting once background processes complete.
- **Graceful Error Recovery:** Error layouts present descriptive, non-technical explanations and clear recovery paths.
- **Disabled State Handling:** Deactivated elements reduce visual contrast and disable haptic responses.
- **Polite Input Validations:** Inputs validate inline, guiding users without aggressive error prompts during active text entry.

---

## 10. COMPONENT GOVERNANCE, NAMING STANDARDS, AND VERSIONING
To maintain a high-quality codebase:
- **Taxonomic Naming Standard:** All component keys must employ the lowercase taxonomic convention:
  `bankyar_[tier]_[category]_[item]_[variant]`
- **Strict Version Control:** The library utilizes semantic versioning principles to manage updates:
  - **MAJOR:** For breaking structural changes or component deprecations.
  - **MINOR:** For backward-compatible feature additions.
  - **PATCH:** For internal layout alignments and bug fixes.
- **Governance Approval:** No custom layout blocks are allowed. All new components require design system review to ensure they align with existing systems.

---

## 11. VALIDATION CHECKLIST & ANTI-PATTERN CATALOG
Before introducing any component, verify that it adheres to the following guidelines:
- [ ] Maps exclusively to semantic tokens, avoiding hardcoded values.
- [ ] Employs logical coordinates (start/end) to support Persian RTL.
- [ ] Includes unique semantic descriptions for screen readers.
- [ ] Maintains a minimum contrast ratio of 4.5:1.
- [ ] Interactive touch zones maintain a comfortable target area.
- [ ] The naming convention complies with lowercase taxonomic rules.

### Prohibited Anti-Patterns:
- Hardcoding color values or physical sizes.
- Creating duplicate or redundant visual layouts.
- Embedding business rules or database operations directly within layout elements.
- Using color alone to communicate financial outcomes.

---

## 12. FUTURE EXPANSION STRATEGY
BankYar is designed to support future cross-platform and multi-brand expansion:
- **Platform-Agnostic Specifications:** Structural layouts remain decoupled from native dependencies, facilitating future iOS, desktop, and web releases.
- **Multi-Brand Support:** Styling parameters are decoupled from component structures, allowing simple theme rebrands with alternative token files.
- **Deprecated Lifecycles:** Deprecated components follow a clear transition path (`Draft -> Active -> Deprecated -> Obsolete`), giving teams ample time to adopt updates.

---

## 13. THE REUSABLE COMPONENT CATALOG
The following section provides detailed specifications for every reusable component in BankYar Version 1.

---

### Component 1: Buttons
- **Purpose**: Provides clean, tactile interaction targets to execute clear user intentions.
- **Business Use Cases**: Initiating database backup, submitting transaction category overrides, or confirming configuration resets.
- **Variants**: Primary Filled, Secondary Outlined, Tertiary Text-Only.
- **Sizes**: Large relative, Medium relative, Small relative.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Label text token, start icon token, end icon token, tap callback identifier, loading state indicator.
- **Content Rules**: Text must use localized strings, limited to a single line with clean ellipsis truncations.
- **Interaction Rules**: Requires a minimum target area matching the standard accessibility grid target token, providing a subtle haptic vibration upon release.
- **Accessibility Rules**: Exposes role "button", reads the localized label text, and supports external keyboard focus tracks.
- **RTL Behaviour**: Icons are mirrored programmatically, text aligns right, and layout follows Persian writing flows.
- **Animation Behaviour**: Subtle touch-scale compression on press using standard curves, with a smooth opacity transition during loading.
- **Validation Rules**: Text label must be non-null and have assigned callback actions unless in disabled mode.
- **Usage Guidelines**: Position Primary Filled for the main action on a viewport. Use Secondary Outlined for secondary choices, and Tertiary Text-Only for cancels.
- **Do & Don't**: DO use active verbs for labels. DON'T pile multiple primary buttons together in a single horizontal layout.
- **Future Extensions**: Dynamic shape-rounding adjustments for future tablet screens.

---

### Component 2: Icon Buttons
- **Purpose**: A compact interactive area displaying a graphic symbol without a text label.
- **Business Use Cases**: Back-tracking in app bars, editing individual rules, or deleting transactions.
- **Variants**: Standard Frameless, Outlined Frame, Filled Frame.
- **Sizes**: Large (touch target envelope optimized), Medium, Small.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Icon asset token, tap callback identifier, accessibility label description.
- **Content Rules**: Displays a single, centered vector symbol. No text is rendered.
- **Interaction Rules**: The touch envelope must match accessibility guidelines even when the icon is small. Triggers haptic confirmation on press.
- **Accessibility Rules**: Must provide a high-quality localized tooltip and text description for screen readers.
- **RTL Behaviour**: Mirror direction-based symbols (such as back arrows), while maintaining symmetrical items.
- **Animation Behaviour**: Clear radial ink-ripple effect expanding from the touch center.
- **Validation Rules**: Must contain a valid vector identifier and a non-null accessibility label.
- **Usage Guidelines**: Use inside app bars or list tiles where horizontal space is constrained.
- **Do & Don't**: DO provide unique accessibility labels. DON'T use generic icons without clear meanings.
- **Future Extensions**: Supports animated vector transitions (e.g., play to pause) in future versions.

---

### Component 3: FAB
- **Purpose**: Displays the primary, high-importance action floating over screen feeds.
- **Business Use Cases**: Creating a manual financial entry, or triggering a custom SMS parsing rule.
- **Variants**: Standard Circle, Extended Oval (with text label).
- **Sizes**: Standard, Extended.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Icon asset token, text label token (extended variant), tap callback identifier.
- **Content Rules**: Icon is centered; the label is positioned inline-start of the icon under RTL layouts.
- **Interaction Rules**: Floats at the bottom inline-end corner of viewports. Shrinks during scrolling.
- **Accessibility Rules**: Primary screen reader target. Emits direct announcements upon focus.
- **RTL Behaviour**: Aligns to the bottom-left corner of the screen (mirrored from Western LTR bottom-right layouts).
- **Animation Behaviour**: Smooth scale-in and scale-out transitions, transitioning to compact circles during scroll feeds.
- **Validation Rules**: Only one primary floating action button can exist per active viewport.
- **Usage Guidelines**: Reserve for the single most frequent action on a major dashboard.
- **Do & Don't**: DO use the extended variant on initial views. DON'T obscure critical financial entries underneath the floating layout.
- **Future Extensions**: Transition into an expanding speed dial menu.

---

### Component 4: Text Fields
- **Purpose**: Accepts and structures user-typed alphanumeric inputs securely.
- **Business Use Cases**: Editing regex pattern strings, typing manual transaction comments, or adding account nicknames.
- **Variants**: Outlined, Filled.
- **Sizes**: Medium, Small.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Label token, hint text token, prefix icon, suffix action, error text label, secure input toggle.
- **Content Rules**: Text alignment follows localized language patterns. Numbers format with correct decimals.
- **Interaction Rules**: Focus brings up the virtual keyboard, shifting viewports to keep inputs visible.
- **Accessibility Rules**: Announces field label, hint text, helper alerts, and active errors.
- **RTL Behaviour**: Text inputs, cursor paths, and icons align right-to-left.
- **Animation Behaviour**: Dynamic floating label animations and smooth warning border transitions.
- **Validation Rules**: Validates length, character types, and secure inputs dynamically.
- **Usage Guidelines**: Place in forms with logical focus flows and clear inline feedback.
- **Do & Don't**: DO keep helper text brief. DON'T use raw character masks without translation support.
- **Future Extensions**: Smart offline autocomplete suggestions based on historical entries.

---

### Component 5: Search Bar
- **Purpose**: Filters list feeds through rapid keyword inputs.
- **Business Use Cases**: Searching through transaction ledgers, or looking up active parsing rules.
- **Variants**: Flat Surface, Floating Card.
- **Sizes**: Standard relative.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Input hint token, prefix icon, suffix clear icon, search query value, query change callback.
- **Content Rules**: Keeps search terms on a single line, offering simple clear buttons.
- **Interaction Rules**: Typing updates lists instantly; back key clears focus.
- **Accessibility Rules**: Announces active result counts and clear state changes.
- **RTL Behaviour**: Search icon sits on the right, clear action on the left, and input direction flows right-to-left.
- **Animation Behaviour**: Smooth search expansion and quick result fade-ins.
- **Validation Rules**: Handles complex Unicode inputs gracefully, trimming spaces.
- **Usage Guidelines**: Position at the top of scrollable lists for quick access.
- **Do & Don't**: DO display instant, inline matches. DON'T hide the clear action when a query is active.
- **Future Extensions**: Pre-loaded search filters for advanced transaction parsing.

---

### Component 6: PIN Input
- **Purpose**: Captures secure passcode inputs for user authentication.
- **Business Use Cases**: Unlocking the secure app vault, or confirming destructive database actions.
- **Variants**: Outlined Boxes, Compact Dots.
- **Sizes**: Standard security size.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Code length (usually 4 or 6), secure mask indicator, entry complete callback.
- **Content Rules**: Displays masked symbols instead of raw numbers.
- **Interaction Rules**: Integrates with secure custom keypads, preventing clipboard copying.
- **Accessibility Rules**: Announces dot entries without reading passcode numbers aloud.
- **RTL Behaviour**: Visual indicator boxes flow right-to-left.
- **Animation Behaviour**: Invalid entries trigger a horizontal shake animation.
- **Validation Rules**: Must validate entry length and match local hashes securely.
- **Usage Guidelines**: Use on the lock screen and prior to sensitive operations.
- **Do & Don't**: DO clear entries instantly on error. DON'T reveal entered credentials in clear text.
- **Future Extensions**: Biometric fallback triggers integrated directly.

---

### Component 7: OTP Input
- **Purpose**: Structures temporal one-time verification code entries.
- **Business Use Cases**: Verifying SMS numbers, or authorizing backup recovery files.
- **Variants**: Individual Segmented Cells.
- **Sizes**: Standard.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Code length (typically 5 or 6), active cell index, complete callback.
- **Content Rules**: Numeric characters only, shown with bold styling.
- **Interaction Rules**: Focuses the first cell automatically, advancing as digits are entered.
- **Accessibility Rules**: High-priority focus announcements. Supports secure auto-fill.
- **RTL Behaviour**: Segment arrays fill from right-to-left.
- **Animation Behaviour**: Focused cells pulse softly, with smooth success indicator transitions.
- **Validation Rules**: Accepts numeric characters only, verifying length.
- **Usage Guidelines**: Limit usage to secure enrollment or device linkage flows.
- **Do & Don't**: DO support clipboard paste. DON'T require users to navigate cells manually.
- **Future Extensions**: Automated SMS capturing and population.

---

### Component 8: Cards
- **Purpose**: Groups related information inside structural containers.
- **Business Use Cases**: Summarizing card analytics, showing parsing templates, or displaying security tips.
- **Variants**: Flat Bordered, Elevated (subtle surface contrast), Filled.
- **Sizes**: Dynamic based on layout grid columns.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Background token, border style, tap callback, content layout.
- **Content Rules**: Structural borders organize content, avoiding crowded items.
- **Interaction Rules**: Tapping opens detail viewports; long presses trigger actions.
- **Accessibility Rules**: Groups nested content, allowing reading as a single semantic block.
- **RTL Behaviour**: Layout structures mirror naturally.
- **Animation Behaviour**: Subtle elevation changes or scale adjustments on hover and press.
- **Validation Rules**: Content must fit layout grids, avoiding text clips.
- **Usage Guidelines**: Group relevant financial details into cards to organize dashboards.
- **Do & Don't**: DO use flat borders for clean layouts. DON'T use heavy shadows or neon borders.
- **Future Extensions**: Supports swipe actions to dismiss cards.

---

### Component 9: Transaction Card
- **Purpose**: Displays specific transaction details within scrollable feeds.
- **Business Use Cases**: Showing ledger lines, recent SMS capture matches, or manual entries.
- **Variants**: Credit, Debit, Pending, Ignored.
- **Sizes**: Standard ledger size.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Amount token, timestamp token, category tag, card/account label, tap callback.
- **Content Rules**: Credits use positive signs (+) and green text; debits use negative signs (-) and neutral text.
- **Interaction Rules**: Tapping opens the slide-up transaction detail sheet.
- **Accessibility Rules**: Announces credit/debit status explicitly, avoiding color-only indicators.
- **RTL Behaviour**: Amount shifts to the left, icon to the right, and Persian text reads right-to-left.
- **Animation Behaviour**: Swipe gestures reveal contextual actions (e.g., delete or categorize).
- **Validation Rules**: Amount and category fields must be valid.
- **Usage Guidelines**: Render inside the primary transaction scrollable list.
- **Do & Don't**: DO show card details clearly. DON'T truncate crucial transaction amounts.
- **Future Extensions**: AI confidence scores shown on parsed transactions.

---

### Component 10: Statistic Card
- **Purpose**: Displays aggregate financial metrics on user dashboards.
- **Business Use Cases**: Showing total income, expense totals, or net monthly savings.
- **Variants**: Positive Trend, Negative Trend, Neutral.
- **Sizes**: Compact (grid split), Wide.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Value label, metric title, comparison trend percentage, visual trend indicator.
- **Content Rules**: Large numeric values, accompanied by descriptive titles.
- **Interaction Rules**: Tapping opens the respective analytics category page.
- **Accessibility Rules**: Announces comparison metrics (e.g., "Expenses up 10%").
- **RTL Behaviour**: Text elements align right, and trend charts read from right-to-left.
- **Animation Behaviour**: Values animate smoothly from zero on initial load.
- **Validation Rules**: Value must be calculated accurately.
- **Usage Guidelines**: Position at the top of analytics dashboards for quick reviews.
- **Do & Don't**: DO keep metrics clear and simple. DON'T display raw, unformatted decimal data.
- **Future Extensions**: Miniature line-charts embedded inside cards.

---

### Component 11: Bank Card
- **Purpose**: Replicates the physical appearance of credit or debit cards for identification.
- **Business Use Cases**: Displaying linked accounts, manual bank configurations, or active SMS filters.
- **Variants**: Brand Colored, Outlined Neutral.
- **Sizes**: Standard aspect ratio card.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Card name, masked number, bank logo asset, card balance token, card color scheme.
- **Content Rules**: Card numbers are masked, showing the final 4 digits.
- **Interaction Rules**: Tapping filters transaction lists by this card.
- **Accessibility Rules**: Announces card nickname, ending digits, and current balance.
- **RTL Behaviour**: Bank logo aligns left, masked digits read left-to-right (for numeric consistency), card label on the right.
- **Animation Behaviour**: Soft card rotation or flip transition when card settings are modified.
- **Validation Rules**: Card name must be provided, and numbers must match standard lengths.
- **Usage Guidelines**: Display in horizontal carousels on the main dashboard.
- **Do & Don't**: DO use distinct card names. DON'T display the full card number in plain text.
- **Future Extensions**: Automatic card logo identification based on card numbers.

---

### Component 12: List Tile
- **Purpose**: A standard list option containing text, icons, and toggles.
- **Business Use Cases**: Structuring app settings, displaying category options, or listing SMS entries.
- **Variants**: Single Line, Multi-line, Action Toggle.
- **Sizes**: Standard list size.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Title token, description token, leading asset, trailing action asset, tap callback.
- **Content Rules**: Title is prominent, descriptions use muted text.
- **Interaction Rules**: Entire tile is tappable, with separate touch areas for trailing toggles.
- **Accessibility Rules**: Reads title, description, and action status (e.g., "Toggle switch: active").
- **RTL Behaviour**: Leading icons align right, trailing actions align left, and text flows right-to-left.
- **Animation Behaviour**: Smooth ripple effect on tap, and toggle slide transitions.
- **Validation Rules**: Title text must be non-null and localized.
- **Usage Guidelines**: Organize settings and list options into clean list tiles.
- **Do & Don't**: DO keep descriptions short. DON'T crowd list tiles with multiple distinct actions.
- **Future Extensions**: Supports slide actions to reveal hidden options.

---

### Component 13: Section Header
- **Purpose**: Labels content groupings in scrollable feeds.
- **Business Use Cases**: Separating date entries, grouping settings categories, or labeling chart metrics.
- **Variants**: Standard, Outlined, Action.
- **Sizes**: Small relative.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Title label token, action button label, action tap callback.
- **Content Rules**: Title is displayed in a bold style, with secondary actions using smaller text.
- **Interaction Rules**: Secondary action button is interactive, while the main title remains non-interactive.
- **Accessibility Rules**: Exposes title as a heading landmark for screen readers.
- **RTL Behaviour**: Title aligns right, and the action button is positioned on the left.
- **Animation Behaviour**: Remains static, pinning to the top during scroll feeds.
- **Validation Rules**: Title text must be provided and translated.
- **Usage Guidelines**: Place before major scroll segments to establish a clear hierarchy.
- **Do & Don't**: DO keep labels short and descriptive. DON'T use long sentences for section headers.
- **Future Extensions**: Support collapsing section contents on tap.

---

### Component 14: Top App Bar
- **Purpose**: Displays the active screen's title and secondary actions at the top of viewports.
- **Business Use Cases**: Main ledger header, settings header, or custom rule editor toolbar.
- **Variants**: Flat, Collapsed Inline, Large Prominent.
- **Sizes**: Mapped from spacing tokens.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Screen title token, navigation back icon, list of actions, scroll offset trigger.
- **Content Rules**: App title is centered or aligned start, remaining on a single line.
- **Interaction Rules**: Back arrow executes pop transitions; action icons trigger settings or filters.
- **Accessibility Rules**: Heading role is declared, reading screen title upon entry.
- **RTL Behaviour**: Back arrow sits on the right, pointing right; actions align to the left.
- **Animation Behaviour**: Smooth color transitions as screens scroll.
- **Validation Rules**: Title cannot be null.
- **Usage Guidelines**: Position at the top of all primary screens.
- **Do & Don't**: DO include a functional back button on sub-screens. DON'T crowd the bar with more than three actions.
- **Future Extensions**: Dynamically changing progress indicators for background processes.

---

### Component 15: Bottom Navigation
- **Purpose**: Places primary app destinations within comfortable reach of the user's thumb.
- **Business Use Cases**: Toggling between dashboard, transaction, rule, and settings screens.
- **Variants**: Standard Bar.
- **Sizes**: Mapped from relative layout tokens.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: List of destinations, active index, destination tap callback.
- **Content Rules**: Displays 3 to 5 destinations with clear icons and brief text labels.
- **Interaction Rules**: Tapping destinations updates viewports, providing a soft haptic confirm.
- **Accessibility Rules**: Uses selected states, announcing destination index (e.g., "Tab 1 of 4").
- **RTL Behaviour**: Destination items order right-to-left.
- **Animation Behaviour**: Smooth transition of active background shapes.
- **Validation Rules**: Active index must correspond to a valid destination.
- **Usage Guidelines**: Position at the bottom of the main shell layout.
- **Do & Don't**: DO keep labels visible. DON'T exceed five distinct navigation tabs.
- **Future Extensions**: Dynamic badges showing unread notification counts.

---

### Component 16: Navigation Rail
- **Purpose**: Replaces bottom navigation on wider viewports (tablets or landscape devices).
- **Business Use Cases**: Tablet-optimized layout for dashboards or rule management screens.
- **Variants**: Standard Vertical Rail.
- **Sizes**: Standard width token.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Navigation items list, active index, item tap callback, header content.
- **Content Rules**: Displays vertical icons with optional labels.
- **Interaction Rules**: Sits on the side of screens, highlighting selections with subtle outlines.
- **Accessibility Rules**: Standard selection announcements.
- **RTL Behaviour**: Sits on the right edge of screens under RTL locales, with labels aligned right.
- **Animation Behaviour**: Smooth vertical transition of selection indicators.
- **Validation Rules**: Requires valid navigation lists.
- **Usage Guidelines**: Activate dynamically on tablets and landscape foldables.
- **Do & Don't**: DO position settings at the bottom. DON'T use on standard phone viewports.
- **Future Extensions**: Collapsible rail that expands into a full drawer layout.

---

### Component 17: Drawer
- **Purpose**: Houses secondary destinations and configuration options.
- **Business Use Cases**: Accessing advanced database utilities, system diagnostics, or about pages.
- **Variants**: Slide-out Panel.
- **Sizes**: Mapped from layout margins.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Header layout, list of destinations, footer copyright.
- **Content Rules**: Clean lists with distinct categories, avoiding visual clutter.
- **Interaction Rules**: Swipe gestures pull drawer into view; tapping outside closes it.
- **Accessibility Rules**: Traps focus inside the panel when open, ensuring screen reader focus remains on drawer options.
- **RTL Behaviour**: Slides out from the right edge under RTL layouts.
- **Animation Behaviour**: Smooth slide transition aligned with motion curve tokens.
- **Validation Rules**: Destructive actions inside drawer require confirmation prompts.
- **Usage Guidelines**: Hide secondary options inside drawers to keep main dashboards clean.
- **Do & Don't**: DO group settings logically. DON'T duplicate bottom navigation options inside the drawer.
- **Future Extensions**: Context-aware recommendations for advanced diagnostics.

---

### Component 18: Tabs
- **Purpose**: Organizes related content channels on a single screen.
- **Business Use Cases**: Swapping between cash flow types, sorting charts, or separating parsed SMS records.
- **Variants**: Scrollable, Fixed.
- **Sizes**: Standard tab size.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Tab headers list, active tab index, tab tap callback.
- **Content Rules**: Brief titles or simple combinations of icons and text.
- **Interaction Rules**: Swipe gestures toggle tabs; tapping selection indicators shifts views.
- **Accessibility Rules**: Announces active tab and count (e.g., "Tab 2 of 3").
- **RTL Behaviour**: Tabs order and transition right-to-left.
- **Animation Behaviour**: Slide transitions of active indicator lines.
- **Validation Rules**: Active tab index must exist in the header list.
- **Usage Guidelines**: Separate views within a single feature to organize content.
- **Do & Don't**: DO keep titles short. DON'T nest tabs inside other tabs.
- **Future Extensions**: Dynamic badge attachments to communicate category changes.

---

### Component 19: Segmented Control
- **Purpose**: Allows selection from mutually exclusive choices on a horizontal bar.
- **Business Use Cases**: Selecting chart intervals, or choosing between dark, light, and system themes.
- **Variants**: Standard Horizontal Control.
- **Sizes**: Medium, Small.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Option labels list, active index, selection change callback.
- **Content Rules**: Option labels are brief, remaining on a single line.
- **Interaction Rules**: Tapping segments shifts selection, updating content instantly.
- **Accessibility Rules**: Announces selected option status and role.
- **RTL Behaviour**: Option elements order right-to-left.
- **Animation Behaviour**: Smooth slide transition of active background fills.
- **Validation Rules**: Requires at least two options.
- **Usage Guidelines**: Limit options to between 2 and 4 to ensure clear selection paths.
- **Do & Don't**: DO use for high-frequency choices. DON'T crowd controls with long option labels.
- **Future Extensions**: Supports localized icon indicators inside segments.

---

### Component 20: Chip
- **Purpose**: Displays interactive elements representing inputs, attributes, or choices.
- **Business Use Cases**: Displaying matched regex keyword tags, or transaction categories.
- **Variants**: Input Chip, Choice Chip, Action Chip.
- **Sizes**: Small, Medium.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Text label token, leading icon, trailing delete icon, selection status, tap callback.
- **Content Rules**: Short text label, remaining on a single line.
- **Interaction Rules**: Tapping selects chips; trailing icons trigger deletion events.
- **Accessibility Rules**: Announces chip labels, selected states, and deletion triggers.
- **RTL Behaviour**: Icons align relative to layout flow; text is right-aligned.
- **Animation Behaviour**: Smooth scale and color fade transitions.
- **Validation Rules**: Text label cannot be empty.
- **Usage Guidelines**: Group chips inside wrapping rows to show tags or attributes.
- **Do & Don't**: DO keep labels short. DON'T use chips for primary action buttons.
- **Future Extensions**: Dynamically colored chips based on brand assets.

---

### Component 21: Filter Chip
- **Purpose**: A specialized chip variant used to refine lists.
- **Business Use Cases**: Filtering transactions by card, date range, or category tag.
- **Variants**: Multi-select, Single-select.
- **Sizes**: Small relative.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Filter label token, selected state, change callback, dropdown indicator icon.
- **Content Rules**: Brief label representing the filter. Displays checkmarks when selected.
- **Interaction Rules**: Tapping toggles selection status, filtering lists instantly.
- **Accessibility Rules**: Announces active filter status explicitly.
- **RTL Behaviour**: Checkmark displays inline-start of text labels under RTL layouts.
- **Animation Behaviour**: Checkmark slides into view when chips are selected.
- **Validation Rules**: Must coordinate with filter state providers.
- **Usage Guidelines**: Display in horizontally scrolling bars at the top of feeds.
- **Do & Don't**: DO show selected states clearly. DON'T obscure active filters.
- **Future Extensions**: Custom counts shown inside chips.

---

### Component 22: Dialog
- **Purpose**: Focuses attention on high-priority alerts or tasks, requiring confirmation.
- **Business Use Cases**: Confirming database purges, warning of unsaved rule changes, or database corruption alerts.
- **Variants**: Decisive Alert, Content Entry Form.
- **Sizes**: Standard adaptive widths.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Title token, body explanation, confirm action, cancel action.
- **Content Rules**: Clear explanations, avoiding technical codes or jargon.
- **Interaction Rules**: Tap outside to dismiss can be disabled for critical alerts; buttons trigger explicit callbacks.
- **Accessibility Rules**: Traps focus inside the dialog, reading titles first.
- **RTL Behaviour**: Text aligns right, actions sit on the left (confirm left, cancel right under RTL standards).
- **Animation Behaviour**: Scales up from screen centers with smooth fade overlays.
- **Validation Rules**: Destructive actions require explicit confirm button inputs.
- **Usage Guidelines**: Limit usage to high-priority events to avoid disrupting workflows.
- **Do & Don't**: DO write clear descriptions. DON'T use dialogs for simple status confirmations.
- **Future Extensions**: Multi-step setup flows inside dialogs.

---

### Component 23: Bottom Sheet
- **Purpose**: Displays secondary content or settings, sliding up from screen bottoms.
- **Business Use Cases**: Showing transaction details, category lists, or ledger filters.
- **Variants**: Standard Collapsible, Draggable Modal.
- **Sizes**: Flexible heights.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Header handle indicator, title token, sheet contents, dismiss callback.
- **Content Rules**: Scrollable content with clear headers and actions.
- **Interaction Rules**: Drag handles down to dismiss, or tap background overlays.
- **Accessibility Rules**: Announces sheet roles, trapping focus inside the panel.
- **RTL Behaviour**: Content mirrors naturally; text is right-aligned.
- **Animation Behaviour**: Slides up from the bottom, with background overlays fading in.
- **Validation Rules**: Complex inputs must save state on dismiss.
- **Usage Guidelines**: Use for detailed content and settings that benefit from vertical scrolling.
- **Do & Don't**: DO position actions within comfortable reach. DON'T stack multiple sheets on top of each other.
- **Future Extensions**: Dynamic resizing based on content lengths.

---

### Component 24: Snackbar
- **Purpose**: Confirms background task completions with transient, non-disruptive notifications.
- **Business Use Cases**: Confirming manual entry creation, database backups, or rule saves.
- **Variants**: Information, Error Warning, Actionable.
- **Sizes**: Standard width.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Message token, action button label, action callback.
- **Content Rules**: Short messages, remaining on a single line.
- **Interaction Rules**: Self-dismisses after a short timeout; actions trigger callbacks.
- **Accessibility Rules**: Announces alerts immediately to screen readers.
- **RTL Behaviour**: Text aligns right, action sits on the left.
- **Animation Behaviour**: Slides up from the bottom of screens.
- **Validation Rules**: Messages must fit within layout limits.
- **Usage Guidelines**: Confirm successful actions without disrupting workflows.
- **Do & Don't**: DO keep actions simple (e.g., "Undo"). DON'T block key navigation elements with snackbars.
- **Future Extensions**: Stacked notifications for rapid events.

---

### Component 25: Toast
- **Purpose**: Displays brief, system-level notices that dismiss automatically.
- **Business Use Cases**: Warning of offline limits, or confirming card copy operations.
- **Variants**: Simple Info Notice.
- **Sizes**: Compact.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Text token message.
- **Content Rules**: Minimal text with no interactive actions or buttons.
- **Interaction Rules**: Passes touch events through, remaining non-interactive.
- **Accessibility Rules**: Polite announcements that do not interrupt active reading.
- **RTL Behaviour**: Text is centered; layouts align right-to-left.
- **Animation Behaviour**: Fades in softly, and fades out after a short timeout.
- **Validation Rules**: Limited to brief status notices.
- **Usage Guidelines**: Use for low-importance, system-level feedback.
- **Do & Don't**: DO use sparingly. DON'T put important navigation actions inside toasts.
- **Future Extensions**: Lightweight native notification overlays.

---

### Component 26: Tooltip
- **Purpose**: Clarifies icons or actions when users long-press on elements.
- **Business Use Cases**: Explaining rule parameters, explaining dashboard stats, or card details.
- **Variants**: Plain Label, Rich Explanatory.
- **Sizes**: Compact.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Message token, target element focus anchor.
- **Content Rules**: Muted, informative text inside compact containers.
- **Interaction Rules**: Appears on hover or long-press; dismisses on release.
- **Accessibility Rules**: Focus triggers screen reader descriptions.
- **RTL Behaviour**: Arrow and tooltip containers align relative to anchor elements.
- **Animation Behaviour**: Scales up smoothly from focus anchors.
- **Validation Rules**: Tooltips cannot block active fields.
- **Usage Guidelines**: Use to explain ambiguous icons or financial metrics.
- **Do & Don't**: DO keep descriptions short. DON'T use tooltips to display essential instructions.
- **Future Extensions**: Context-aware tour flows for first-time setup.

---

### Component 27: Menu
- **Purpose**: Displays a list of contextual options when users tap trigger elements.
- **Business Use Cases**: Transaction card menus, rule filters, or log diagnostics.
- **Variants**: Contextual Popover, Dropdown List.
- **Sizes**: Dynamic based on options.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Menu options list, trigger anchor, selection callback.
- **Content Rules**: List options contain clear labels and icons.
- **Interaction Rules**: Tapping outside closes menus; selections trigger callbacks.
- **Accessibility Rules**: Supports arrow keys for focus transitions.
- **RTL Behaviour**: Icons align right, and options are positioned on the right.
- **Animation Behaviour**: Expands from trigger anchors with subtle fade-ins.
- **Validation Rules**: Items must map to valid callbacks.
- **Usage Guidelines**: Group secondary contextual actions into menus to save screen space.
- **Do & Don't**: DO group similar options. DON'T exceed seven options inside a single menu list.
- **Future Extensions**: Smart option rankings based on usage frequency.

---

### Component 28: Dropdown
- **Purpose**: Allows selection from a list of options inside a compact container.
- **Business Use Cases**: Choosing categories, filtering cards, or selecting SMS templates.
- **Variants**: Outlined Field Selector.
- **Sizes**: Medium relative.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Selected option, options list, helper text token, change callback.
- **Content Rules**: Options are clearly labeled, highlighting selections.
- **Interaction Rules**: Tapping expands lists; selections close dropdowns, updating inputs.
- **Accessibility Rules**: Announces option counts and selection changes.
- **RTL Behaviour**: Dropdown arrows sit on the left; options align right.
- **Animation Behaviour**: Menu options slide down smoothly from fields.
- **Validation Rules**: Selected options must exist in option lists.
- **Usage Guidelines**: Use when selecting from standard option groups in forms.
- **Do & Don't**: DO show selections clearly. DON'T use when there are fewer than three options.
- **Future Extensions**: Search filters built into large dropdown lists.

---

### Component 29: Date Picker
- **Purpose**: Facilitates calendar date selections, supporting Persian Hijri dates.
- **Business Use Cases**: Filtering ledgers by date ranges, or customizing chart timelines.
- **Variants**: Calendar Grid view, Text Entry fields.
- **Sizes**: Standard viewport adaptive.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Initial date, selected range, locale calendar system, selection callback.
- **Content Rules**: Labels use Persian Hijri month names and localized years.
- **Interaction Rules**: Calendar grids support swipe gestures; days are tappable.
- **Accessibility Rules**: High-priority semantic labels for month and day grids.
- **RTL Behaviour**: Calendar grids render right-to-left.
- **Animation Behaviour**: Smooth month-slide transitions.
- **Validation Rules**: Restricts selection to valid financial ranges.
- **Usage Guidelines**: Use for transaction filters and chart timelines.
- **Do & Don't**: DO support range selections. DON'T restrict text inputs for dates.
- **Future Extensions**: Automatically identifies dates from parsed transaction history.

---

### Component 30: Charts
- **Purpose**: Visualizes financial trends and cash flow splits.
- **Business Use Cases**: Showing weekly spending bar graphs, or category breakdowns.
- **Variants**: Bar Chart, Donut Chart, Line Chart.
- **Sizes**: Wide (dashboard layouts).
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Financial data array, interactive segment callback, metric indicators.
- **Content Rules**: Uses high-contrast, flat colors instead of glowing gradients.
- **Interaction Rules**: Tapping segments focuses details, updating dashboard metrics.
- **Accessibility Rules**: Must provide text alternative tables for screen readers.
- **RTL Behaviour**: Time axes read right-to-left.
- **Animation Behaviour**: Graphs animate smoothly from baseline structures.
- **Validation Rules**: Visual segments must calculate percentages accurately.
- **Usage Guidelines**: Highlight financial trends on dashboards using clear charts.
- **Do & Don't**: DO use high-contrast borders. DON'T overlay multiple complex trend lines.
- **Future Extensions**: Pinch-to-zoom gestures for long-term trends.

---

### Component 31: Progress Indicator
- **Purpose**: Signals active background processes with simple animations.
- **Business Use Cases**: Statement importing, database optimizations, or configuration saves.
- **Variants**: Linear Bar, Circular Ring.
- **Sizes**: Medium, Small.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Progress percentage, indeterminate indicator status.
- **Content Rules**: Displays status text labels inline (e.g., "Importing statements...").
- **Interaction Rules**: Blocks interactive fields when processes are critical.
- **Accessibility Rules**: Announces progress updates politely (e.g., "50% complete").
- **RTL Behaviour**: Linear bars fill from right-to-left.
- **Animation Behaviour**: Smooth, linear animations using standard curves.
- **Validation Rules**: Indeterminate states are reserved for unknown durations.
- **Usage Guidelines**: Show active background tasks clearly using progress indicators.
- **Do & Don't**: DO keep animations smooth. DON'T leave screens frozen without visual progress indicators.
- **Future Extensions**: Multi-threaded progress trackers.

---

### Component 32: Loading Skeleton
- **Purpose**: Pre-renders layout grids during data loads to maintain layout stability.
- **Business Use Cases**: Ledger skeletons during startup, or analytics dashboard structures.
- **Variants**: Card Skeleton, List Skeleton, Typography Block.
- **Sizes**: Matches target component boundaries.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Dimensions token, roundness token, shimmer rate.
- **Content Rules**: Flat gray boxes, containing no text or assets.
- **Interaction Rules**: Disables interaction events during loading states.
- **Accessibility Rules**: Announces loading status to screen readers.
- **RTL Behaviour**: Shimmer animations move right-to-left.
- **Animation Behaviour**: Soft, repeating opacity transitions.
- **Validation Rules**: Must match target container dimensions exactly.
- **Usage Guidelines**: Display skeleton cards during database queries.
- **Do & Don't**: DO match actual layouts. DON'T use flashing or high-contrast loading animations.
- **Future Extensions**: Adaptive skeletons that scale with device configurations.

---

### Component 33: Badge
- **Purpose**: Highlights counts or statuses on top of elements.
- **Business Use Cases**: Unread SMS notifications, pending rule overrides, or active card indicators.
- **Variants**: Numeric Count, Dot Status.
- **Sizes**: Compact.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Count value, maximum count limit, semantic color token.
- **Content Rules**: Clear numbers, remaining on a single line.
- **Interaction Rules**: Non-interactive; passes through touch events.
- **Accessibility Rules**: Appends count description to parent elements (e.g., "4 unread items").
- **RTL Behaviour**: Positions at top-left corners of parent elements in RTL layouts.
- **Animation Behaviour**: Soft scale changes when count values update.
- **Validation Rules**: Value must be non-negative.
- **Usage Guidelines**: Position on tab bars or notification icons to draw attention.
- **Do & Don't**: DO keep labels simple. DON'T cover essential element details with badges.
- **Future Extensions**: Custom text tags (e.g., "NEW") for updates.

---

### Component 34: Avatar
- **Purpose**: Displays a circular representation of profile initials or brand logos.
- **Business Use Cases**: Bank account identification, merchant profile icons, or user profiles.
- **Variants**: Icon Profile, Initials Profile, Brand Logo.
- **Sizes**: Medium, Small.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Initials text token, brand logo identifier, semantic background token.
- **Content Rules**: Uses single-character initials or clear brand logos.
- **Interaction Rules**: Tapping opens settings pages or transaction histories.
- **Accessibility Rules**: Announces profile names or bank identifiers.
- **RTL Behaviour**: Positions relative to layouts; initials align right.
- **Animation Behaviour**: Soft scale shifts on press.
- **Validation Rules**: Initials cannot exceed two characters.
- **Usage Guidelines**: Display next to account lists or transaction titles.
- **Do & Don't**: DO use high contrast colors. DON'T use detailed illustrations inside small avatars.
- **Future Extensions**: Dynamic profile updates from secure contacts.

---

### Component 35: Divider
- **Purpose**: Separates visual segments without adding clutter.
- **Business Use Cases**: Separating transaction entries, settings options, or card sections.
- **Variants**: Full Width, Inset.
- **Sizes**: Standard thickness token.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Color token, thickness scale, indent margins.
- **Content Rules**: Contains no text or labels.
- **Interaction Rules**: Non-interactive; passes through touch events.
- **Accessibility Rules**: Exposes semantic role "separator" to screen readers.
- **RTL Behaviour**: Inset indents start on the right edge under RTL layouts.
- **Animation Behaviour**: Static layout block.
- **Validation Rules**: Color contrast must be subtle yet legible.
- **Usage Guidelines**: Organize lists and content blocks using dividers.
- **Do & Don't**: DO keep dividers subtle. DON'T use dark, high-contrast lines that add clutter.
- **Future Extensions**: Adaptive thickness for tablet grids.

---

### Component 36: Switch
- **Purpose**: Standard toggle control providing immediate visual feedback.
- **Business Use Cases**: Activating background parsers, toggling dark modes, or biometric locks.
- **Variants**: Standard Thumb Toggle.
- **Sizes**: Standard.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Switch status, action callback, accessibility label token.
- **Content Rules**: Sits next to descriptive labels, remaining stateless internally.
- **Interaction Rules**: Drag thumbs or tap targets to trigger callbacks.
- **Accessibility Rules**: Announces toggled status clearly (e.g., "Active").
- **RTL Behaviour**: Switches align to the left, and descriptive labels sit on the right.
- **Animation Behaviour**: Slide transitions with color shifts.
- **Validation Rules**: Must coordinate with local configuration settings.
- **Usage Guidelines**: Place in settings and forms for binary preferences.
- **Do & Don't**: DO use for instant preferences. DON'T require secondary saves to apply switch changes.
- **Future Extensions**: Supports embedded checkmark symbols inside thumbs.

---

### Component 37: Checkbox
- **Purpose**: Facilitates multi-selection choices from lists.
- **Business Use Cases**: Multi-selecting transactions for export, or category selections.
- **Variants**: Standard Square Box, Tri-state (indeterminate).
- **Sizes**: Standard size token.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Selected status, selection list, callback identifier.
- **Content Rules**: Standard square borders, showing checkmarks when selected.
- **Interaction Rules**: Tapping checks boxes, emitting tactile vibrations.
- **Accessibility Rules**: Announces checkbox roles and selection states.
- **RTL Behaviour**: Checkboxes sit on the right, and option text is right-aligned.
- **Animation Behaviour**: Checkmarks scale into view.
- **Validation Rules**: Selection changes must propagate instantly.
- **Usage Guidelines**: Group choices in scrollable lists for simple multi-selections.
- **Do & Don't**: DO keep labels clear. DON'T confuse checkboxes with binary settings switches.
- **Future Extensions**: Supports swipe gestures to select multiple boxes.

---

### Component 38: Radio Button
- **Purpose**: Facilitates single selections from mutually exclusive option groups.
- **Business Use Cases**: Choosing primary payment cards, or sorting transaction histories.
- **Variants**: Circle Selector.
- **Sizes**: Standard.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Selected status, group values, selection callback.
- **Content Rules**: Small circle indicators, showing active inner dots when selected.
- **Interaction Rules**: Tapping option targets selects items, clearing adjacent options.
- **Accessibility Rules**: Announces selected status and total option count.
- **RTL Behaviour**: Buttons sit on the right, and option text aligns right.
- **Animation Behaviour**: Inner selection dots expand on select.
- **Validation Rules**: Only one option can be active in a group.
- **Usage Guidelines**: Use for simple option groups in forms.
- **Do & Don't**: DO list options clearly. DON'T exceed five options in a single radio group.
- **Future Extensions**: Dynamic layout adaptation for grid configurations.

---

### Component 39: Slider
- **Purpose**: Facilitates continuous or discrete value selections across ranges.
- **Business Use Cases**: Setting budget limits, or filtering transaction amounts.
- **Variants**: Single Thumb, Range Double Thumb.
- **Sizes**: Standard height token.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Value range, active values, selection callback.
- **Content Rules**: Displays numeric ranges clearly, updating labels in real-time.
- **Interaction Rules**: Drag thumbs across tracks to adjust values.
- **Accessibility Rules**: Announces values clearly as sliders adjust.
- **RTL Behaviour**: Tracks fill and values increase right-to-left.
- **Animation Behaviour**: Thumbs expand softly during drags.
- **Validation Rules**: Ensures active values remain within bounds.
- **Usage Guidelines**: Use for range filters and budget configurations.
- **Do & Don't**: DO show values inline. DON'T use for exact, high-precision numbers.
- **Future Extensions**: Haptic ticks at discrete slider points.

---

### Component 40: Empty State
- **Purpose**: Displays supportive feedback when screens contain no data.
- **Business Use Cases**: New ledgers with no transactions, or empty custom rules list.
- **Variants**: Flat Illustration Panel, Action Call.
- **Sizes**: Centered full viewport.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Title token, descriptive body explanation, action button label, action callback.
- **Content Rules**: Calm, supportive explanations with clear primary action buttons.
- **Interaction Rules**: Primary button is interactive; background illustrations remain static.
- **Accessibility Rules**: Announces explanations and action paths automatically.
- **RTL Behaviour**: Text aligns centered; primary buttons follow RTL layouts.
- **Animation Behaviour**: Soft fade-ins when viewports load empty.
- **Validation Rules**: Primary actions must direct users toward initiating data.
- **Usage Guidelines**: Display centered on empty viewports instead of leaving screens blank.
- **Do & Don't**: DO write helpful descriptions. DON'T use tech codes or place blame on users.
- **Future Extensions**: Adaptive suggestions based on common starting steps.

---

### Component 41: Error State
- **Purpose**: Explains application errors and guides users toward recovery.
- **Business Use Cases**: Backup decryption failures, or biometric login lockout.
- **Variants**: Viewport Centered, Inline Card.
- **Sizes**: Full viewport adaptive, Card width.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Error code token, user explanation, retry action callback, cancel callback.
- **Content Rules**: Direct, simple language that protects users from complex stack traces.
- **Interaction Rules**: Retry buttons trigger tasks; cancel buttons backtrack safely.
- **Accessibility Rules**: Alerts screen readers to high-priority failures immediately.
- **RTL Behaviour**: Text aligns right, and buttons follow Persian layouts.
- **Animation Behaviour**: Invalid retries trigger soft shake animations.
- **Validation Rules**: Action pathways must restore safe application states.
- **Usage Guidelines**: Display centered on screens when critical tasks fail.
- **Do & Don't**: DO offer recovery paths. DON'T present raw stack traces or complex error logs.
- **Future Extensions**: Automated diagnostic logs saved to secure local storage.

---

### Component 42: Permission Card
- **Purpose**: Requests device system permissions with clear security explanations.
- **Business Use Cases**: Granting background SMS access, or biometric authorization.
- **Variants**: Highlighted Form Card, Inline Panel.
- **Sizes**: Card layout matching grids.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Purpose title, security explanation, grant action, deny action.
- **Content Rules**: Explains how data is kept on-device, prioritizing user privacy.
- **Interaction Rules**: Grant buttons trigger OS requests; deny buttons close layouts safely.
- **Accessibility Rules**: High-priority alert announcements that read explanations first.
- **RTL Behaviour**: Text aligns right, and buttons mirror naturally.
- **Animation Behaviour**: Slips smoothly into views from screen headers.
- **Validation Rules**: Explanations must align with on-device privacy tenets.
- **Usage Guidelines**: Display at the top of feeds if key permissions are missing.
- **Do & Don't**: DO explain privacy benefits. DON'T harass users with persistent full-screen prompts.
- **Future Extensions**: Interactive guides to system settings.

---

### Component 43: Notification Banner
- **Purpose**: Displays system alerts at the top of main feeds.
- **Business Use Cases**: Database backup due reminders, or backup import successes.
- **Variants**: Informational, Warning Alert, Success Notice.
- **Sizes**: Full screen width.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Alert message, action buttons list, close button callback.
- **Content Rules**: Short messages, remaining on a single line.
- **Interaction Rules**: Action buttons trigger tasks; close buttons dismiss banners.
- **Accessibility Rules**: High-priority alert announcements.
- **RTL Behaviour**: Icons align right, actions on the left, and text is right-aligned.
- **Animation Behaviour**: Slides down smoothly from app headers.
- **Validation Rules**: Banners must dismiss cleanly.
- **Usage Guidelines**: Position below app bars to highlight important status updates.
- **Do & Don't**: DO use distinct icons. DON'T crowd screens with multiple notification banners.
- **Future Extensions**: Stacked notifications for rapid events.

---

### Component 44: Search Result Item
- **Purpose**: Displays matching transaction details inside search lists.
- **Business Use Cases**: Matching transaction ledgers, or searching custom rules.
- **Variants**: Standard ledger row.
- **Sizes**: Standard size token.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Amount token, title token, matched keyword highlights, category tag, tap callback.
- **Content Rules**: Displays matched keywords clearly, highlighting found text.
- **Interaction Rules**: Tapping opens detail sheets, close buttons backtrack search screens.
- **Accessibility Rules**: Highlights matching keywords explicitly to screen readers.
- **RTL Behaviour**: Amount aligns left, category tag on the right, and text is right-aligned.
- **Animation Behaviour**: Results fade into view smoothly during active searches.
- **Validation Rules**: Highlights must match query entries exactly.
- **Usage Guidelines**: Display inside search result feeds to organize matches.
- **Do & Don't**: DO highlight found keywords. DON'T truncate crucial transaction amounts.
- **Future Extensions**: Supports interactive slide actions to edit.

---

### Component 45: Backup Card
- **Purpose**: Manages secure, local, offline database backup creation.
- **Business Use Cases**: Exporting database files, or manual backup schedules.
- **Variants**: Config card.
- **Sizes**: Card layout matching grids.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Last backup timestamp, backup destination path, backup action callback.
- **Content Rules**: Displays backup size, date, and security details clearly.
- **Interaction Rules**: Action buttons trigger local file creations, showing progress bars.
- **Accessibility Rules**: Announces backup status and size to screen readers.
- **RTL Behaviour**: Icons align right, and actions are positioned on the left.
- **Animation Behaviour**: Smooth progress bar updates.
- **Validation Rules**: Backups must save to secure directories.
- **Usage Guidelines**: Display in settings lists to organize database options.
- **Do & Don't**: DO confirm local security paths. DON'T use cloud-sync references.
- **Future Extensions**: Automated encrypted schedules.

---

### Component 46: Restore Card
- **Purpose**: Restores secure database backups from local directories.
- **Business Use Cases**: Importing database backups, or diagnostic restores.
- **Variants**: Config card.
- **Sizes**: Card layout matching grids.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Backup details, security hash verification, restore action callback.
- **Content Rules**: Warns users of overwrites, prioritizing data safety.
- **Interaction Rules**: Action buttons open system file pickers, triggering decryptions.
- **Accessibility Rules**: Direct, high-priority warnings to screen readers.
- **RTL Behaviour**: Icons align right, and actions are positioned on the left.
- **Animation Behaviour**: Progress bar slide transitions.
- **Validation Rules**: Backups must verify hashes before restorations.
- **Usage Guidelines**: Display in settings lists next to backup cards.
- **Do & Don't**: DO warn of overwrites. DON'T allow restorations without PIN confirmations.
- **Future Extensions**: Automatic file-integrity validations.

---

### Component 47: Security Card
- **Purpose**: Manages application locks, passcodes, and biometric configurations.
- **Business Use Cases**: Changing secure PIN passcodes, or biometrics.
- **Variants**: Highlighted form card.
- **Sizes**: Card layout matching grids.
- **States**: Default, Hover, Pressed, Focused, Selected, Loading, Disabled, Success, Warning, Error, Empty, Offline.
- **Properties**: Security status, toggle actions, change action callback.
- **Content Rules**: Clear explanations of lock benefits, emphasizing local security.
- **Interaction Rules**: Toggle switches activate locks; change actions open inputs.
- **Accessibility Rules**: Announces security status and lock benefits.
- **RTL Behaviour**: Switches align left, and text is right-aligned.
- **Animation Behaviour**: Smooth transition of toggle switches.
- **Validation Rules**: PIN updates require active credentials.
- **Usage Guidelines**: Display at the top of settings categories to prioritize security.
- **Do & Don't**: DO emphasize privacy benefits. DON'T store raw security passcodes.
- **Future Extensions**: Lock-out timers that increase dynamically with incorrect attempts.

---
**End of Document**
