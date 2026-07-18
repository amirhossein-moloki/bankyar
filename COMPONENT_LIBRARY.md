# BankYar Component Library Architecture (v1.0.0)
## Enterprise-Grade Specification for Offline-First Secure Financial Applications

---

## EXECUTIVE SUMMARY
This document establishes the official **Component Library Architecture** for BankYar. Built to implement the core product personality (Stoic, Precise, Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this architecture serves as the absolute single source of truth for UI composition and visual presentation.

In strict adherence to the **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets of BankYar, this system resides entirely at the structural, behavioral, and architectural level. Every screen within the application must be composed exclusively of the components defined in this library.

To ensure strict design consistency, accessibility, and platform-agnostic flexibility:
- **No Flutter widgets** or raw implementation code are defined.
- **No physical measurement units** (such as pixels, dp, or sp) are utilized; all dimensions reference abstract layout and spacing tokens from `DESIGN_TOKEN_ARCHITECTURE.md`.
- **No HEX values** or hardcoded colors are assigned; all styling references abstract tokens from `SEMANTIC_COLOR_SYSTEM.md`.
- **No forbidden terms** (such as the word "widget", "widgets", or capital "Widget" configurations) are used in definitions, relying instead on "component", "element", "view node", "renderable", "layout block", or "visual layer".
- Fully supports Right-to-Left (RTL) Persian typography and layouts natively.

---

## 1. COMPONENT PHILOSOPHY
The BankYar Component Philosophy is guided by six primary architectural tenets to ensure complete consistency, predictability, and safety:

1. **Unidirectional Data Flow (UDF) Compliance:** Components are purely declarative presentation nodes. They accept immutable configuration structures and state payloads, dispatching user actions outward via abstract event callbacks. They never directly modify global application state.
2. **Strict Statelessness (Whenever Possible):** Components must not maintain internal business state. Transient visual state (such as an expanded accordion or active focus frame) is isolated within the presentation layer, while financial and user-input states are managed exclusively by feature-level state providers (such as Riverpod).
3. **Pure RTL-First Architecture:** Logical coordinates (such as `inline-start` and `inline-end`) are used in place of physical directions (left and right). Directional mirroring occurs programmatically, ensuring native support for Persian typography and reading lines.
4. **Color Independence & Multi-Theme Security:** No component contains hardcoded color values. Visual meaning is never conveyed by color alone; all status indicators combine semantic color tokens with distinct geometric shapes, numerical signs (+/-), and descriptive text labels.
5. **Mathematical Spatial Grid Alignment:** Spacing, padding, margins, and content boundaries are determined strictly by relative grid factor multipliers mapped from `LAYOUT_SPACING_SYSTEM.md`. This prevents layout clipping and overlapping text when system-level accessibility text magnification is enabled.
6. **Zero External Framework Leakage:** Presentation components are entirely blind to database drivers, file systems, background services, and native operating system channels. They interact with data strictly through domain entities and clean, injected repositories.

---

## 2. COMPONENT TAXONOMY
To eliminate duplication and maintain clean boundaries, BankYar organizes all user interface elements into a rigid six-tier taxonomic hierarchy. Components at any tier may only compose elements from tiers below them:

```
                      BankYar Component Taxonomy
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

### Component Taxonomy Mapping Matrix
| Taxonomic Tier | Role and Intent | Allowed Dependencies | Prohibited Practices |
| :--- | :--- | :--- | :--- |
| **Foundation** | Non-visual rules, design tokens, spatial grids, and global themes. | None | Including visual markup or layout structures. |
| **Primitive** | Atomic, indivisible visual elements (Atoms). | Foundation | Referencing other primitive components or feature state. |
| **Composite** | Combinations of primitives serving a single layout purpose (Molecules). | Primitive, Foundation | Importing domain entities or feature business logic. |
| **Domain** | Components bound to the ubiquitous language but independent of feature state. | Composite, Primitive | Injecting Riverpod providers or handling database connections. |
| **Feature** | State-bound containers managing specific user flows and data streams. | Domain, Composite, Primitive | Accessing another feature's private data or UI components. |
| **Screen** | High-level coordinate frames composing feature blocks into complete views. | Feature, Domain, Composite | Directly styling visual boundaries or bypassing the taxonomy. |

---

## 3. ATOMIC DESIGN STRATEGY
BankYar adapts standard Atomic Design principles to the requirements of secure, mobile financial applications. This system ensures that visual consistency flows upward from individual pixels to entire user screens:

```
  [ Atoms ] --------> [ Molecules ] ------> [ Organisms ] ------> [ Templates ] ----> [ Pages ]
  (Primitives)        (Composites)          (Domain Blocks)       (Feature Layouts)   (Screens)
```

### Composition and Assembly Rules:
1. **Atoms (Primitives)** represent the base design system syntax. They cannot be broken down further without losing their visual purpose (e.g., an icon container, a typography string, or a base button).
2. **Molecules (Composites)** combine two or more Atoms to perform a specific interaction (e.g., combining an icon and a text block to build a tappable category tag).
3. **Organisms (Domain Blocks)** group Molecules and Atoms to represent discrete business concepts (e.g., composing a category tag, a bold currency block, and a text metadata string to build a transaction ledger card).
4. **Templates (Feature Layouts)** establish logical arrangement grids for Organisms, defining the vertical rhythm and Safe Area boundaries of a specific flow (e.g., a scrollable list view with filter headers and empty states).
5. **Pages (Screens)** bind Templates to reactive data streams and system events, handling permissions, authentication locks, and active database transitions.

---

## 4. FOUNDATION COMPONENTS
Foundation components define the core design tokens, spatial constraints, and visual systems of BankYar. They are non-visual architectural building blocks that govern rendering behavior across all platforms:

* `bankyar_foundation_token_system`: Coordinates color palettes, spacing metrics, typography sizes, motion curves, and elevation scales. It ensures that any theme adjustment (such as activating Dark Mode or high-contrast styles) propagates instantly.
* `bankyar_foundation_spatial_grid`: Implements the base relative grid system. It enforces horizontal and vertical rhythms, grid columns, and safe margin offsets based on active screen sizes.
* `bankyar_foundation_theme_context`: Manages theme resolution rules, mapping semantic token requests to global primitive scales without affecting component layout engines.
* `bankyar_foundation_locale_context`: Tracks language rules, character alignment baselines, and directional mirroring properties for RTL Persian and LTR Western locales.

---

## 5. PRIMITIVE COMPONENTS
Primitive components are the basic visual elements of the design system. They are highly decoupled, accepting immutable configurations and dispatching user actions via abstract events:

* `bankyar_primitive_text`: Renders Persian typography with proper character baselines and line heights, preventing overlapping ascenders/descenders at any zoom level.
* `bankyar_primitive_icon`: Displays graphical symbols on a mathematically centered grid, applying programmatic mirroring rules for directional vectors in RTL layouts.
* `bankyar_primitive_button_base`: A raw interactive area that handles touch target envelopes, state modifications (Default, Hover, Pressed, Disabled), and haptic confirmations.
* `bankyar_primitive_divider`: Generates clean, low-contrast separator lines inside lists and panels to separate content without adding visual noise.
* `bankyar_primitive_spacer`: Creates consistent gaps between adjacent elements using scale factors from the design token system.
* `bankyar_primitive_checkbox`: A binary choice controller that uses distinct outlined and filled states alongside semantic icons to ensure clear selections.
* `bankyar_primitive_switch`: A toggle control providing immediate visual feedback for system state adjustments, optimized for one-handed reach.
* `bankyar_primitive_radio_button`: Facilitates single selections from mutually exclusive option groups.

---

## 6. COMPOSITE COMPONENTS
Composite components combine multiple Primitive elements to perform a single, focused interaction, remaining entirely agnostic of feature logic and domain models:

* `bankyar_composite_segment_control`: A horizontal selection bar with mutually exclusive options, using low-saturation fills to highlight active states.
* `bankyar_composite_tab_bar`: Coordinates top-level navigation zones, using mirrored swipe gestures and animated active states to guide users.
* `bankyar_composite_badge`: A compact visual indicator used to display numeric counts, transaction types, or status highlights in layout headers.
* `bankyar_composite_tag`: A small, interactive element combining an icon and a text label, ideal for displaying category selections.
* `bankyar_composite_chip`: A flexible input and filtering chip, supporting active, inactive, and disabled states.
* `bankyar_composite_avatar`: A circular, high-contrast frame used to display bank logos or user profile initials.
* `bankyar_composite_progress_bar`: A linear progress tracker used to communicate background processes, such as statement parsing or database exports.

---

## 7. DOMAIN COMPONENTS
Domain components are bound to the business concepts of BankYar (such as transactions, templates, and categories) but remain independent of feature states and active data streams:

* `bankyar_domain_transaction_row`: Composes a transaction's amount, merchant label, timestamp, and category tag into a single, scan-friendly ledger row.
* `bankyar_domain_category_card`: Displays a category's name, localized icon, and aggregated spending totals inside a flat, structured card.
* `bankyar_domain_bank_account_badge`: Renders a bank's logo and masked card number, using consistent brand identifiers to support rapid scanning.
* `bankyar_domain_rule_summary_block`: Summarizes SMS parsing rules, displaying matching keywords, target categories, and confidence tags.

---

## 8. FEATURE COMPONENTS
Feature components bind Domain and Composite elements to active data streams, managing specific user flows and handling interactions directly through state providers:

* `bankyar_feature_sms_detection_feed`: Observes raw background SMS streams, rendering incoming logs in a secure, local ingestion queue.
* `bankyar_feature_rule_editor_form`: Provides input fields and validation checks for creating and modifying custom regular expression templates.
* `bankyar_feature_analytics_card_group`: Subscribes to analytical summaries, rendering cash flow overviews, spending trends, and category comparisons.
* `bankyar_feature_pin_unlock_shield`: Intercepts system launch events, displaying a PIN entry screen and managing biometric verification flows.

---

## 9. LAYOUT COMPONENTS
Layout components enforce spatial grids and visual containment rules, managing content structure without applying background styles or decorative elements:

* `bankyar_layout_screen_container`: Defines the main viewport, managing safe area paddings, software keyboard offsets, and responsive margin boundaries.
* `bankyar_layout_list_container`: Manages scroll performance, vertical spacing, and list separators for stacked feeds.
* `bankyar_layout_grid_container`: Arranges elements across responsive column grids, automatically adjusting based on screen widths and orientations.
* `bankyar_layout_section_header`: Establishes clear visual separation between content blocks, displaying a title label and secondary actions.
* `bankyar_layout_sticky_header`: Keeps section headers locked at the top of scrolling feeds, providing persistent context during reviews.

---

## 10. NAVIGATION COMPONENTS
Navigation components guide users across main application views, prioritizing comfort and immediate visual clarity:

* `bankyar_navigation_bottom_bar`: Places primary navigation zones within comfortable one-handed reach, using outlined and filled states to identify active tabs.
* `bankyar_navigation_top_app_bar`: Displays the active screen's title and secondary utility actions, supporting native back-gestures and RTL mirroring.
* `bankyar_navigation_rail`: A vertical menu bar designed to save horizontal space on tablet layouts and foldables.
* `bankyar_navigation_lateral_drawer`: A secondary, slide-out navigation menu reserved for advanced diagnostics and system configuration tools.

---

## 11. FORM COMPONENTS
Form components manage inputs, selections, and field validations, protecting databases from corrupt or invalid entries:

* `bankyar_form_text_field`: A secure text entry container supporting RTL character tracking, floating helper labels, and real-time input validation markers.
* `bankyar_form_dropdown_selector`: A compact selection panel that expands to display available category list options.
* `bankyar_form_checkbox_group`: Manages multiple checkbox options, coordinating selections across vertical or horizontal grids.
* `bankyar_form_date_picker`: A modular date selector optimized for Persian Solar Hijri calendars, supporting comfortable one-handed selection.
* `bankyar_form_time_picker`: A simple clock interface used to define transaction and template scheduling times.

---

## 12. FEEDBACK COMPONENTS
Feedback components communicate system statuses, background processes, and input validations clearly, avoiding intrusive pop-ups:

* `bankyar_feedback_snackbar`: A brief, self-dismissing notification banner used to confirm database backups or successful configuration updates.
* `bankyar_feedback_banner`: A persistent warning panel that appears at the top of feeds to signal critical issues, such as missing background permissions.
* `bankyar_feedback_inline_alert`: A compact inline panel used to highlight form validation issues or parsing template warnings directly inside the active context.

---

## 13. DIALOG COMPONENTS
Dialog components manage high-priority interruptions, requiring explicit confirmation before proceeding:

* `bankyar_dialog_security_warning`: Warns users of destructive actions, such as purging database tables or resetting security PINs.
* `bankyar_dialog_disaster_recovery`: Guides users through recovery steps if database corruption is detected, facilitating empty state initialization and backup imports.
* `bankyar_dialog_form_abandonment`: Prompts users for confirmation when attempting to close modified rule forms without saving.

---

## 14. BOTTOM SHEET COMPONENTS
Bottom sheets slide up from the bottom of viewports, bringing primary controls and details within comfortable reach:

* `bankyar_sheet_transaction_detail`: Displays detailed metadata for selected transactions, including raw SMS text, matching rule IDs, and manual category overrides.
* `bankyar_sheet_category_selector`: Displays a scrollable grid of available categories and custom tags, allowing quick transaction categorization in under two taps.
* `bankyar_sheet_filter_panel`: Coordinates ledger filters, allowing users to refine lists by bank accounts, dates, and cash flow types.

---

## 15. CARD COMPONENTS
Cards organize related financial details into distinct visual blocks, using subtle borders instead of heavy shadows or fills:

* `bankyar_card_transaction_summary`: Highlights transaction amounts, currency labels, and category metadata within a flat container.
* `bankyar_card_statistic_metric`: Displays high-level analytics, such as net cash flows or monthly spending averages.
* `bankyar_card_alert_notice`: Highlights diagnostic issues, such as low-confidence heuristic matches or unparsed SMS entries.
* `bankyar_card_config_setting`: Groups settings controls into logical blocks, supporting readability and clear information hierarchy.

---

## 16. LIST COMPONENTS
List components manage vertically scrolling feeds, optimizing performance during large-volume historical reviews:

* `bankyar_list_scrollable_ledger`: Renders transaction lists efficiently, managing dividers and section headers during scrolls.
* `bankyar_list_rule_feed`: Renders custom parsing rules, supporting quick activation toggles and template-building actions.
* `bankyar_list_settings_options`: Organizes system settings, backup tools, and diagnostic logs into clean, scan-friendly lists.

---

## 17. STATISTICS COMPONENTS
Statistics components summarize cash flows and spending trends, presenting data with mathematical accuracy:

* `bankyar_stats_cash_flow_counter`: Displays incomes, expenses, and net balances, updating dynamically as transaction feeds update.
* `bankyar_stats_expense_breakdown`: Summarizes spending by category, displaying percentages and absolute amounts in a scan-friendly layout.

---

## 18. CHART COMPONENTS
Charts visualize spending trends and category balances, remaining completely flat and avoiding glowing gradients or complex 3D rendering:

* `bankyar_chart_flat_donut`: Renders spending shares by category, separating adjacent slices with high-contrast borders and using text labels to support accessibility.
* `bankyar_chart_flat_bar`: Displays weekly or monthly spending trends using vertical bars, color-coded programmatically to identify cash flow types.

---

## 19. SEARCH COMPONENTS
Search components coordinate text lookups and filter matches across transaction lists and rule feeds:

* `bankyar_search_input_bar`: A textfield containing a start-aligned magnifying glass and an end-aligned clear button, supporting instant lookups.
* `bankyar_search_result_row`: Displays matching records, highlighting found keywords to help users scan results.

---

## 20. FILTER COMPONENTS
Filter components manage list refinements, helping users isolate transactions by accounts, values, or dates:

* `bankyar_filter_chip_list`: A horizontally scrolling row of filter chips, supporting quick activation and dismissal.
* `bankyar_filter_panel_sheet`: A slide-up bottom sheet containing advanced filters, optimized for one-handed reach.

---

## 21. EMPTY STATE COMPONENTS
Empty states appear when screens contain no data, offering supportive guidance instead of displaying blank viewports:

* `bankyar_empty_ledger_panel`: Explains how to grant background SMS permissions or manually import transaction records.
* `bankyar_empty_rules_panel`: Encourages users to build their first parsing rule, providing clear instructions and a primary action button.

---

## 22. LOADING COMPONENTS
Loading components communicate active background processes, maintaining layout stability during database transitions:

* `bankyar_loading_shimmer_skeleton`: Displays a grey skeleton representation of cards and lists, pulsing with smooth opacity transitions during content loads.
* `bankyar_loading_progress_line`: Displays a horizontal progress bar that pulses with a linear animation curve during database imports or backups.

---

## 23. ERROR COMPONENTS
Error components handle system failures gracefully, reducing user anxiety through calm, structured explanations:

* `bankyar_error_import_panel`: Explains file-system or decryption failures during backup imports, offering clear recovery paths.
* `bankyar_error_auth_lockout`: Explains biometric lockout, directing users to enter their security PIN to restore access.

---

## 24. SECURITY COMPONENTS
Security components secure storage, local encryption, and biometric unlock screens, protecting sensitive financial data:

* `bankyar_security_pin_grid`: A clean, non-reflective numeric keypad, randomized occasionally to prevent visual finger-path tracking.
* `bankyar_security_biometric_overlay`: A full-screen security shield that hides transaction details, requesting biometric verification on launch.

---

## 25. NOTIFICATION COMPONENTS
Notification components confirm background operations, keeping users informed without disrupting active tasks:

* `bankyar_notification_sms_captured`: Displays a non-intrusive status bar confirmation when background SMS messages are successfully captured and parsed.
* `bankyar_notification_backup_success`: Confirms successful, secure offline database backups inside the active settings view.

---

## 26. SETTINGS COMPONENTS
Settings components organize configuration panels and backup management tools, using clean structures:

* `bankyar_settings_row_item`: A standard list option containing a start-aligned icon, a title label, a description, and an end-aligned toggle.
* `bankyar_settings_action_button`: A specialized button used to trigger database backups, file restoration, or diagnostics.

---

## 27. ACCESSIBILITY COMPONENTS
Accessibility components wrap visual elements to support screen readers, external keyboards, and variable system text scales:

* `bankyar_accessibility_semantic_wrapper`: Exposes descriptive labels and interaction states to screen readers, ensuring elements are read correctly.
* `bankyar_accessibility_focus_frame`: Renders a high-contrast outline around active components during keyboard or switch navigation.

---

## 28. STATE VARIANTS
To maintain visual consistency during user interaction, components must map their styles across six standardized state variants:

```
  +--------------+     +--------------+     +--------------+
  |   Default    | --> |    Hover     | --> |   Pressed    |
  | (Base Style) |     | (Pointer over|     | (Active Tap) |
  +--------------+     +--------------+     +--------------+
         |                    |                    |
         v                    v                    v
  +--------------+     +--------------+     +--------------+
  |   Focused    | --> |   Disabled   | --> |    Error     |
  | (A11y/Focus) |     | (Deactivated)|     | (Validation) |
  +--------------+     +--------------+     +--------------+
```

### Component State Variant Matrix
| Component State | Color Token Modulation | Spacing/Layout Behavior | Expected UX Response |
| :--- | :--- | :--- | :--- |
| **Default** | Base semantic mapping. | Standard margins and paddings. | Baseline visual state. |
| **Hover** | Shift contrast scale by +1 step. | No dimensional changes. | Instant pointer-hover confirmation. |
| **Pressed** | Shift contrast scale by +2 steps. | Touch compression (0.98x scale). | Immediate tactile tap feedback. |
| **Focused** | High-contrast outline ring. | Frame highlight overlay. | Visual path for keyboard navigation. |
| **Disabled** | Apply 38% opacity overlay. | Deactivate all touch gestures. | Communicates unavailable actions. |
| **Error** | Remap borders to error color. | Inline validation notice. | Highlights input issues or failures. |

---

## 29. COMPONENT LIFECYCLE
Every component in BankYar follows a strict lifecycle, ensuring proper state initialization, performance optimization, and memory safety:

```
  [ Instantiate ]
         |
         v
  [ Resolve Theme ]  <-- Bind semantic tokens & locales (Light/Dark/RTL)
         |
         v
  [ Bind Providers ] <-- Listen to state and stream providers (Riverpod)
         |
         v
  [ Render / Layout ]<-- Measure constraints & paint on spatial grid
         |
         v
  [ Mutate / Interact ]<-- Handle touch events, gesture loops, & hover states
         |
         v
  [ Dispose ]        <-- Cancel listeners, clear buffers, & free resources
```

### Lifecycle Specifications:
1. **Instantiate:** The component is declared in the layout tree with immutable configurations.
2. **Resolve Theme:** The layout engine maps the component's semantic tokens to active global scales and configures locales (RTL/LTR).
3. **Bind Providers:** The component establishes read/watch connections with injected state providers, listening for updates.
4. **Render / Layout:** The engine calculates boundary constraints on the spatial grid, painting the component.
5. **Mutate / Interact:** Touch inputs, swipe gestures, and hover states trigger state updates, re-rendering affected layers in under 100 milliseconds.
6. **Dispose:** When removed from the layout tree, the component cancels active streams, clears caches, and frees memory to prevent leaks.

---

## 30. COMPONENT COMPOSITION RULES
To ensure scalability and keep code simple, composition is governed by four strict rules:

1. **One Responsibility Per Component:** A component must focus on a single task. For example, `bankyar_domain_transaction_row` is responsible only for rendering transaction details; it must not handle editing, deletions, or database updates directly.
2. **No Circular Nesting:** Components must compose hierarchically. A primitive component may reside inside a composite, but a composite must never depend on a domain component, avoiding circular references.
3. **Strict State Delegation:** Business logic, regular expressions, database queries, and platform channel interactions are strictly forbidden inside components, remaining delegated to use cases and repositories.
4. **Consistency over Novelty:** Custom layouts are prohibited. All new feature views must compose existing components, maintaining layout consistency.

---

## 31. COMPONENT NAMING CONVENTION
To maintain clean registries across developer teams, all components follow a strict lowercase taxonomic naming convention:

```
bankyar_[tier]_[category]_[item]_[variant]
```

### Naming Segments:
- `bankyar`: Standard namespace constant identifying the design system.
- `tier`: The taxonomic level of abstraction (`foundation`, `primitive`, `composite`, `domain`, `feature`, `layout`, `navigation`, `form`, `feedback`, `dialog`, `sheet`, `card`, `list`, `stats`, `chart`, `search`, `filter`, `empty`, `loading`, `error`, `security`, `notification`, `settings`, `accessibility`).
- `category`: The functional or structural grouping (e.g., `button`, `input`, `text`, `icon`).
- `item`: The specific component name (e.g., `ledger_row`, `pin_grid`, `theme_toggle`).
- `variant`: The style or layout variation (e.g., `default`, `active`, `disabled`, `error`).

### Valid Examples:
- `bankyar_primitive_button_confirm_default`
- `bankyar_composite_tag_category_active`
- `bankyar_domain_transaction_row_failed`
- `bankyar_feature_pin_unlock_shield_lockout`

---

## 32. TOKEN MAPPING
Components must never use hardcoded colors, sizes, or spatial offsets. They reference semantic tokens, which resolve dynamically based on active themes:

| Component Token Name | Target Visual Property | Semantic Source Reference | Mapped Global Scale Reference |
| :--- | :--- | :--- | :--- |
| `bankyar.comp.button.primary.fill` | Primary button background. | `bankyar.semantic.color.action.primary` | `bankyar.global.color.primary.500` |
| `bankyar.comp.button.primary.text` | Primary button label. | `bankyar.semantic.color.text.onaccent` | `bankyar.global.color.neutral.50` |
| `bankyar.comp.card.ledger.background`| Transaction card container. | `bankyar.semantic.color.surface.default` | `bankyar.global.color.neutral.100` |
| `bankyar.comp.card.ledger.padding` | Transaction card inner margins. | `bankyar.semantic.space.md` | `bankyar.global.space.base` (x4 multiplier) |
| `bankyar.comp.input.text.border` | Input outline indicator. | `bankyar.semantic.color.border.default` | `bankyar.global.color.neutral.300` |

---

## 33. STATE MAPPING
Interactive states apply programmatic overlays or scale adjustments to component tokens, providing immediate visual feedback:

| Component Active State | Target Property | Applied Design Token Modifier | Expected Visual Output |
| :--- | :--- | :--- | :--- |
| **Default** | Scale & Opacity. | No modifier (1.0 factor). | Base layout state. |
| **Hover** | Background Fill. | Shift contrast scale by +1 step. | Subtle color highlight. |
| **Pressed** | Layout Transform. | Touch compression (0.98x scale). | Subtle visual shrink. |
| **Focused** | Outline Frame. | Apply high-contrast outline ring. | Highlight outline ring. |
| **Disabled** | Volatile Opacity. | Apply 38% opacity overlay. | Low-contrast deactivated state. |
| **Error** | Border Color. | Remap border to error color. | Visual alert frame. |

---

## 34. INTERACTION RULES
To ensure comfortable mobile usage and reduce input errors, all component interactions must comply with three core rules:

1. **Large Touch Targets:** All interactive zones (such as buttons, toggles, checkboxes, and tabs) must maintain a minimum touch envelope of 48dp × 48dp, preventing accidental mis-taps.
2. **One-Handed Comfort Zones:** High-frequency actions (such as transaction categorization lists, filters, and form confirm triggers) must reside in the lower half of the screen, ensuring comfortable thumb reach.
3. **Immediate Tactile Feedback:** Tapping interactive elements must trigger system haptic confirmations and visual state updates in under 100 milliseconds.

---

## 35. COMPONENT VERSIONING
To maintain stability across multiple developer teams and future cross-platform builds, the Component Library uses a strict semantic versioning protocol:

* **MAJOR (Breaking Changes):** Renaming or removing existing components, or modifying their public configurations or interfaces in ways that break layout structures. Requires a major release cycle and migration guide.
* **MINOR (Additions):** Introducing new components or layout variants to support features without affecting existing component structures.
* **PATCH (Fixes):** Refining inner geometries, layout alignment, or accessibility tags inside an existing component without modifying its taxonomic key or external parameters.

---

## 36. GOVERNANCE RULES
Governance rules protect the Component Library from unstructured additions and visual inconsistencies:

1. **Mandatory Library Compliance:** Every screen must be composed exclusively from the components defined in this library. Raw, custom layouts are prohibited.
2. **No Inlined Styles:** Defining raw color hex values, physical sizes (pixels/dp/sp), or custom fonts directly inside layouts is prohibited.
3. **One Meaning Per Component:** A component must serve exactly one visual purpose. Reusing components for secondary, unrelated meanings is prohibited.
4. **Documentation and Usage Examples:** Every component must include detailed usage documentation and visual composition examples before merge.
5. **Accessibility Review:** All component modifications require an accessibility review, ensuring contrast compliance and screen reader support.

---

## 37. VALIDATION RULES
The design system compiler validates all component definitions against a strict validation matrix before deployment:

### Validation Matrix
| Rule ID | Check Target | Validation Condition | Failure Penalty |
| :--- | :--- | :--- | :--- |
| **VAL-COMP-01** | Component Naming | Component keys must use lowercase alphanumeric and underscores. | Build Failure |
| **VAL-COMP-02** | Token References | Visual properties must reference valid semantic or layout tokens. | Build Failure |
| **VAL-COMP-03** | Touch Targets | Interactive components must maintain the minimum 48dp target envelope. | Build Failure |
| **VAL-COMP-04** | Accessibility | Interactive elements must contain descriptive labels for screen readers. | Build Failure |
| **VAL-COMP-05** | RTL Mirroring | Directional components must support logical coordinates (start/end). | Compile Warning |

---

## 38. ANTI-PATTERN CATALOG
The following visual and structural anti-patterns are strictly prohibited:

* **Inline Styles:** Hardcoding color hex values, margins, paddings, or font sizes directly in layout files.
* **Duplicate Components:** Building custom, one-off variations of existing components (such as a unique search input bar or a custom warning card).
* **Business Logic Leakage:** Including regular expressions, database transactions, background tasks, or network calls inside presentation components.
* **Color as Only Indicator:** Displaying transaction credits/debits, validation errors, or security locks using color alone, without adding text or structural markers.
* **Overloaded Dashboards:** Crowding multiple charts, summaries, and actions onto a single screen, violating the *Minimalist* design principle.

---

## 39. REVIEW CHECKLIST
Before releasing any screen or component update, verify compliance against this checklist:

- [ ] Does the element map exclusively to semantic design tokens, avoiding hardcoded values?
- [ ] Are logical coordinates (start/end) used instead of physical directions (left/right) to support RTL Persian?
- [ ] Is the element paired with a descriptive label for screen readers?
- [ ] Does the element maintain a minimum contrast ratio of 4.5:1 against its background?
- [ ] Do interactive zones maintain a comfortable touch target of at least 48dp × 48dp?
- [ ] Does the component key comply with the lowercase taxonomic naming convention?
- [ ] Has the component been tested to ensure smooth scrolls and zero UI lag?

---

## 40. FUTURE EVOLUTION STRATEGY
As BankYar expands, the Component Library is built to scale:

* **Universal Portability:** The library uses platform-agnostic definitions, ensuring a seamless future migration to iOS, desktop, and web environments.
* **Multi-Brand Compatibility:** Theme tokens isolate visual styles from component logic, allowing the design system to support new visual configurations and white-label demands without changes to the core layout code.
* **Backward Compatibility:** Deprecated components must follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing development teams with clear migration pathways between updates.

---
**End of Document**
