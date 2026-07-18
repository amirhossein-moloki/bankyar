# BankYar Design System: Forms & Input Experience System Architecture (v1.0.0)

## Executive Summary
This document establishes the official **Forms & Input Experience System Architecture** for BankYar. Designed to implement the core product personality (*Stoic*, *Precise*, *Empowering*) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this system defines every user input pattern across the application.

In strict adherence to the **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets of BankYar, this system is optimized for high-integrity financial operations, zero network reliance, and Persian Right-to-Left (RTL) locales. It establishes clear guidelines for layout strategies, input methods, validation models, security boundaries, and accessibility frameworks.

To maintain perfect abstraction:
- **No Flutter code** or framework implementations are used.
- **No UI mockups** or visual screens are designed.
- **No hardcoded dimensions** (such as pixels, dp, or sp) or color hex values are allowed.
- This system resides completely at the **UX Architecture & Governance level**, defining the relationships, logical structures, interaction behaviors, and token contracts (`bankyar.*`) that ensure a cohesive and compliant input experience.

---

## 1. Form Philosophy
The BankYar Form Philosophy treats inputs as high-stakes portals through which financial truth is recorded. In a local-only, secure banking manager, user errors can lead to corrupt records or lost metadata. The form experience must respect the user's focus, reduce manual input effort, and prevent errors before they happen.

Three foundational laws govern this philosophy:
* **Inputs are Conversations:** Forms are structured as logical, predictable dialogues. The interface must guide the user with a calm visual cadence, presenting inputs in a strict chronological sequence.
* **Typing is a Security and Usability Tax:** On mobile viewports, text entry is error-prone and slow. The architecture prioritizes quick selections, intelligent defaults, heuristics, and automatic parsers (e.g. SMS capturing) over manual typing.
* **Guaranteed Predictability:** Input behaviors must never surprise the user. Form states, validation triggers, keyboard focus changes, and formatting masks are unified across all screens.

---

## 2. Input Design Principles
Every input element and form layout in BankYar must fulfill four core UX principles:
* **Absolute Cognitive Ease:** Complex financial configurations (such as parsing rules or manual ledger templates) are broken into simple, progressive steps. Field boundaries are unmistakable, and active inputs are clearly highlighted.
* **Color-Independent Security:** Color is never used as the sole indicator of status or error. All states are reinforced with explicit textual explanations, logical icons, and structural changes.
* **Frictionless Error Recovery:** Validations are supportive rather than punitive. If an error is detected, the system does not just report a failure; it explains exactly how to fix it and suggests recovery steps.
* **One-Handed Mobile Reach:** Input elements, quick filters, and primary action buttons reside strictly within the lower physical half of mobile viewports, ensuring comfortable one-handed reach.

---

## 3. Form Architecture
The BankYar Form Architecture enforces a strict separation between data storage, state management, and user interaction.

### Form Architecture Diagram
```
  [User Action / Key Stroke]
              |
              v
  [Input Masking & Formatting Engine] (e.g., Persian Number Map, Grouping Separators)
              |
              v
  [Interactive State Notifier] (Fires Active States: Default, Focused, Inputted, Error)
              |
              +---> [Real-Time Validator] ---> (If Invalid: Show Inline Message & Assist Action)
              |
              v
  [Local Result Aggregator] (Aggregates inputs, manages cross-field dependencies)
              |
              v
  [Form-Level Validator] ---> (If Valid: Unlocks Primary Button; If Invalid: Focuses First Error)
              |
              v
  [SQLCipher Local Database Session] (Secure Offline Persistence)
```

This architecture ensures that user inputs undergo real-time formatting and sanitization at the presentation boundary before being processed by the validation engine and securely persisted.

---

## 4. Form Layout Strategy
To minimize scanning fatigue and prevent cognitive overload, forms adhere to a single-column, logical-start aligned layout strategy.

* **Single-Column Rule:** Inputs must be stacked vertically in a single column. Multi-column forms are strictly prohibited on mobile viewports, as they disrupt vertical scanning lines and lead to missed inputs.
* **Spacing Multipliers:** Gaps between distinct input blocks are governed by design tokens. The gap between an input field and its top text label is mapped to `bankyar.layout.form.label.gap` (which resolves to `bankyar.space.sm`). The vertical gap between adjacent input rows is mapped to `bankyar.layout.form.field.gap` (which resolves to `bankyar.space.lg`).
* **Interactive Containment:** Related input clusters are grouped within flat containers (`bankyar.semantic.color.surface.default`), using physical spacing boundaries rather than heavy dark shadows or complex borders.

---

## 5. Field Hierarchy
Clear typographical contrast establishes an intuitive field hierarchy, allowing users to scan forms effortlessly.

```
       Visual Importance & Interaction Hierarchy:
       [Level 1: Label]       -> Small, Medium Weight (Readable instruction, always visible)
       [Level 2: Input Field] -> High-contrast border, clear internal prompt, distinct cursor
       [Level 3: Assist Text] -> Subtle text below the input field (Validation status, recovery suggestion)
```

- **Top Labels:** Labels reside above the input container to remain visible when the input field is active or filled.
- **Consistent Sizing:** Label text is mapped to `bankyar.text.label.medium` using the `bankyar.font.size.xs` token. Active input values are mapped to `bankyar.text.body.medium` using the `bankyar.font.size.md` token to ensure readable text size.

---

## 6. Input Categories
BankYar divides all inputs into four clear, functional categories, each optimized for specific data types:
1. **Free-Form Text Inputs:** Used for transaction notes and template names, utilizing standard keyboard maps.
2. **Constrained Numeric Inputs:** Used for transaction amounts, PIN locks, and verification codes, using custom numeric keypads.
3. **Structured Selectors:** Used for dates, times, categories, and payment accounts, replacing manual typing with simple, thumb-friendly selectors.
4. **Binary Toggles:** Used for system preferences and boolean settings, utilizing clear, state-based switches and checkbox groups.

---

## 7. Single-line Inputs
Single-line inputs handle short, single-sentence text entries (e.g. transaction names or custom template tags).

- **Unified Height:** The input field container maintains a comfortable vertical size aligned with the minimum touch target token `bankyar.layout.touch.target.min`.
- **Automatic Truncation:** If entered text exceeds the field width, the input field scroll viewport shifts horizontally to keep the cursor and active character visible, while applying end truncation to inactive values.
- **Clear Action:** A single-tap clear button is positioned at the logical end edge of the text field, allowing users to wipe the input quickly.

---

## 8. Multi-line Inputs
Multi-line inputs handle extended text descriptions (e.g. raw SMS inspect panels or multi-paragraph transaction notes).

- **Vertically Adaptive Heights:** The input field container must adapt dynamically, supporting a minimum vertical size of three text lines up to a maximum of six lines before enabling vertical scrolling.
- **Disabled Enter Keys:** The soft keyboard Enter action is reserved for inserting new paragraphs, rather than submitting the form.
- **Character Count Counter:** A real-time character count is anchored to the logical bottom-end corner of the input surface, tracking content limits without covering text.

---

## 9. Numeric Inputs
Numeric inputs are used for entering mathematical coordinates, account references, and card numbers.

- **Persian Digit Integration:** Entered Western numbers are mapped in real-time to Persian numerals (e.g. 1 -> ۱) for localized interfaces.
- **Visual Grouping Separators:** Card numbers are grouped into segments of four digits (e.g. `۶۰۳۷-۹۹۱۱-۲۲۳۳-۴۴۵۵`) separated by non-breaking hyphens to improve legibility.
- **Numeric-Only Keyboard:** Selecting a numeric input must trigger the system numeric-only keypad, preventing alphabetical typing mistakes.

---

## 10. Currency Inputs
Currency inputs handle high-priority transaction amounts and account balances.

- **Right-Aligned Flow:** In RTL Persian interfaces, the active cursor and active digits are positioned at the logical start (right), while the currency symbol (e.g. "تومان") is anchored to the logical end (left).
- **Thousands Separators:** Digits are grouped in real-time with local thousands separators (e.g. `۴۵,۰۰۰,۰۰۰`) as the user types.
- **Zero-Input Protection:** Empty values default to zero (`۰`) rather than remaining blank, avoiding null errors in financial calculations.

---

## 11. Password Inputs
Password inputs manage secure backup encryptions and local database recovery passwords.

- **Masking Rules:** Characters are masked using secure circular symbols (`•`) immediately after typing, with a short visual delay of 800 milliseconds on the active character.
- **Visibility Toggle:** A high-contrast eye icon is positioned at the logical end edge of the field, allowing users to toggle between masked and unmasked states.
- **Password Strength Indicators:** A real-time strength bar is positioned below the field, changing colors and text labels (Weak, Good, Strong) based on character complexity.

---

## 12. PIN Entry
PIN entries manage high-speed biometric-lock bypasses and app-wide lockouts.

```
  RTL Layout:   [ PIN Circle 4 ]   [ PIN Circle 3 ]   [ PIN Circle 2 ]   [ PIN Circle 1 ]
                ( State: Empty )   ( State: Empty )   ( State: Filled )  ( State: Filled )
```

- **Separated Character Boxes:** The PIN input uses a row of separate visual circles or boxes, rather than a single text field.
- **Filled State Indication:** Entering a digit highlights the corresponding circle using the active state token (`bankyar.semantic.color.border.active`).
- **Input Limit Lock:** The PIN length is strictly constrained to four digits. Once the fourth digit is entered, the validation engine executes automatically, avoiding the need for a manual submit button.

---

## 13. OTP Entry
OTP entries handle secure one-time verification inputs.

- **Auto-Fill Extraction:** The system parses incoming verification SMS messages in real-time, extracting the security code and automatically populating the OTP fields to minimize manual typing.
- **Unified Spacing Gaps:** OTP character boxes are separated by equal horizontal gaps mapped to `bankyar.space.md` to ensure readability.
- **Expiration Countdown:** A visual countdown timer is displayed below the fields, disabling inputs once the expiration limit is reached.

---

## 14. Search Fields
Search fields manage quick queries across transaction histories, category records, and rules.

```
  RTL Layout:   [ Clear Action ] [ Active Query Text ] [ Search Icon ]
                ( Logical End )                        ( Logical Start )
```

- **Inline Search Icon:** A search glass icon is positioned at the logical start edge of the field, signaling search functionality.
- **Real-Time Queries:** Queries execute in real-time as the user types, using a debounce filter of 300 milliseconds to prevent layout lag.
- **Instant Reset:** Clicking the clear icon wipes the query and restores the full transaction feed immediately.

---

## 15. Filter Controls
Filter controls refine long ledger lists, letting users filter by dates, accounts, and transaction categories.

- **Horizontal Chip Rows:** Filter options are displayed as a horizontal row of interactive chips, allowing users to scroll chips horizontally to adjust filters.
- **Immediate Screen Refresh:** Selecting a filter chip applies the filter instantly, updating the main layout view within 100 milliseconds.
- **Selected Count Indicator:** If multiple options are selected, a counter badge is appended to the main filter button, making active filters obvious.

---

## 16. Dropdowns
Dropdowns offer structured selections from predefined lists (e.g. choosing a payment bank or origin card).

- **Tap Trigger:** Tapping a dropdown field opens a persistent bottom sheet rather than a floating overlay menu, keeping options within comfortable thumb-reach on mobile screens.
- **Logical Groupings:** Options are grouped by utility, using standard division lines to separate core options from secondary actions.
- **Selected Highlights:** The active selection is highlighted with a checkmark and a subtle tint (`bankyar.semantic.color.selection.fill`), confirming the active choice.

---

## 17. Combo Boxes
Combo boxes combine free-text entry with structured selections, used for adding custom transaction tags or category identifiers.

- **Smart Filtering:** Typing in a combo box filters the suggestions in real-time.
- **Inline Tag Creation:** If a typed term does not match any existing options, a "Create Tag" action is displayed at the top of the suggestion list, allowing users to save new tags instantly.
- **Standard Keyboard Behaviors:** The soft keyboard is kept open as users select suggestions, enabling rapid tag creation.

---

## 18. Chips & Multi-select
Chips provide compact, interactive triggers for applying tags, categorizing expenses, and managing search filters.

- **Standard Dimensions:** Chips maintain comfortable heights aligned with design tokens, ensuring easy touch access.
- **Active State Indicators:** Selected chips use high-contrast fills (`bankyar.semantic.color.selection.fill`) and bold typography to differentiate them from inactive chips.
- **Removable Triggers:** Active filter chips include a small "x" icon at the logical end edge, allowing users to dismiss individual filters in a single tap.

---

## 19. Date Pickers
Date pickers manage date selections for ledger filters, budget periods, and financial reports.

- **Persian Calendar System:** The date picker defaults to the Solar Hijri calendar (Shamsi) system, featuring standard Persian month names (Farvardin, Ordibehesht, etc.).
- **Visual Grid Balance:** Days of the week are aligned horizontally, starting from Saturday (RTL) down to Friday, matching regional layout expectations.
- **Common Presets:** Quick-select shortcuts (e.g. "Today", "This Month", "Last 30 Days") are displayed at the top of the picker to speed up common selections.

---

## 20. Time Pickers
Time pickers manage precise scheduling times for system exports, automatic backups, and scheduled ledger transactions.

- **RTL Dial Rotation:** Time dials rotate logically, matching standard clockwise rotations while displaying Persian numerals.
- **Clear Period Selectors:** AM/PM selection switches are displayed as high-contrast toggle chips next to the main dial, ensuring clear period selections.
- **Single-Tap Validation:** Tapping outside the picker or selecting a confirm action validates the time selection and closes the overlay instantly.

---

## 21. Range Selectors
Range selectors define numerical intervals, such as filtering transactions by specific amount ranges.

- **Dual Interaction Sliders:** Range pickers utilize two horizontal slider controls to define the minimum and maximum boundaries of the range.
- **Dynamic Text Displays:** Active range values are displayed in real-time above the slider, updating as the user drags the sliders.
- **Touch Targets Buffer:** Sliders maintain sufficient physical separation to prevent users from accidentally dragging both controls at the same time.

---

## 22. Toggle Controls
Toggle controls allow users to change binary (yes/no) settings, such as system preferences, backup options, or biometric locks.

- **State Independence:** Meaning must never be conveyed solely by color. Toggle states are reinforced with distinct visual cues (such as changing icon shapes and layout configurations).
- **Consistent Response Times:** Toggling a setting updates the state instantly, providing tactile feedback within 100 milliseconds.
- **Explicit Labels:** Every toggle must include a clear, descriptive label next to the control, making its functionality obvious.

---

## 23. Checkboxes
Checkboxes manage multi-choice selections inside lists and forms (e.g. selecting multiple transaction records to export).

- **Unified Curvatures:** Checkbox borders use the tight curve token `bankyar.radius.sm` to maintain a consistent visual style.
- **Text-Wrap Protection:** Checklist labels are placed at the logical end (left) of the checkbox control, wrapping to a new line if text length exceeds screen boundaries.
- **Tap Zone Enlargement:** The active touch target spans the entire checkbox row, allowing users to select options easily without tapping the checkbox icon directly.

---

## 24. Radio Groups
Radio groups manage mutually exclusive selections, where users can choose only one option from a list (e.g. choosing a default currency system).

```
  RTL Layout:   ( Radio Circle Filled )   { Option Label A }
                ( Radio Circle Empty  )   { Option Label B }
```

- **Symmetrical Dial Circles:** Radio dials use circular outlines. The selected dial contains a solid inner dot using the primary accent color.
- **Vertical Alignment:** Radio options are arranged in a vertical stack to support comfortable scrolling and scanning on mobile screens.
- **Default Selections:** A radio group must always have a default option selected, avoiding unselected states.

---

## 25. Switches
Switches are used for high-impact system preferences that apply instantly (e.g. enabling secure offline backup syncs or Dark Theme).

- **Tactile Sliders:** The switch contains a sliding thumb within a horizontal track.
- **High-Contrast State Fills:** The track changes fill colors between inactive and active states, ensuring clear visual differentiation.
- **No Manual Saving:** Switches execute their actions immediately upon sliding, removing the need for a manual "Save Settings" button.

---

## 26. Sliders
Sliders allow users to make continuous or discrete adjustments along a range (e.g. adjusting screen lock timeout intervals).

- **Visible Tick Markers:** Discrete sliders include visual tick marks along the horizontal bar to indicate available options clearly.
- **Enlarged Touch Thumbs:** The slider thumb maintains an enlarged touch target to support comfortable drag gestures without covering active values.
- **Accessible Text Displays:** Active values are displayed in real-time above the slider, adjusting as the user drags the control.

---

## 27. File Selection
File selection interfaces handle offline database imports, backup restorations, and raw transaction log exports.

- **Dashed Interaction Zones:** File drop zones are highlighted with a dashed boundary (`bankyar.border.style.dashed`) to signal drop functionality.
- **Immediate Metadata Feedback:** Selecting a file displays its name, size, and modification date inside a flat card, verifying the selection before processing.
- **Format Validation Warnings:** If an invalid file format is selected, the interface displays an immediate, high-contrast warning banner explaining the format requirements.

---

## 28. Backup Password Inputs
Backup password inputs protect exported local databases and raw transactions.

- **Strict Complexity Guidelines:** Entering a backup password triggers a real-time checklist below the field, checking password complexity (length, numbers, symbols).
- **Match Verification:** Form submissions require the password to be entered twice, using a second "Confirm Password" field to prevent typos.
- **Clear Warning Banners:** A prominent warning banner is displayed above the fields, explaining that because the application is local-only, lost backup passwords cannot be recovered.

---

## 29. Notes Editor
Notes editors allow users to append custom descriptions, budget explanations, and categorization notes to transaction records.

- **Formatting Toolbar:** A horizontal formatting bar is positioned above the soft keyboard, providing quick buttons to insert common transaction tags, currency symbols, and emojis.
- **Automatic Auto-Saves:** Entered notes are auto-saved to the local database as the user types, protecting entries from being lost if the application is closed.
- **Horizontal Scrolling Protections:** Long, continuous text blocks wrap vertically, avoiding horizontal layout scrolls that break scanning lines.

---

## 30. Validation Strategy
The BankYar Validation Strategy is built to catch errors early, protect database integrity, and guide users back to successful states.

```
+-----------------------------------------------------------------------------+
|                               VALIDATION FLOW                               |
+-----------------------------------------------------------------------------+
| [User Keystroke] ---> [Real-Time Formatter] ---> [Sanitizer]                |
|                                                      |                      |
| (Check Syntax) <--- [State Transition (Focused -> Unfocused)]               |
|       |                                                                     |
|       +---> If Invalid: Show Inline Message & Assist Action                 |
|       |                                                                     |
| [Submit Action] ---> [Deferred Validation Check]                            |
|       |                                                                     |
|       +---> If Invalid: Focus First Error Row & Play Subtle Animation       |
|       |                                                                     |
|       +---> If Valid: Write Encrypted Transaction to SQLCipher               |
+-----------------------------------------------------------------------------+
```

Our strategy separates validation into three distinct phases:
1. **Real-Time Validation:** Captures syntax issues (such as invalid characters or incorrect email formats) as the user types, using a debounce filter to prevent premature warnings.
2. **Deferred Validation:** Executes when the input field loses focus, validating field content (such as verifying if a card number contains the correct amount of digits).
3. **Async Validation:** Handles local database verification checks (such as checking if a parsing rule name already exists).

---

## 31. Required Field Strategy
Required fields represent core variables that must be populated before a form can be submitted (e.g. transaction amounts or rule templates).

- **No Star Glyphs:** The system avoids using red asterisk stars (`*`), which add visual clutter and can confuse screen readers.
- **Logical Groupings:** Instead of highlighting required fields, the system groups required fields into a primary section, while clearly labeling optional fields with "(Optional)" in their top labels.
- **Active Submission Locks:** The primary submit button remains disabled (`bankyar.semantic.color.disabled.background`) until all required fields are populated with valid inputs.

---

## 32. Error Messaging Rules
Error messages must be supportive and clear, explaining exactly what went wrong and how to fix it.

- **No System Code Speak:** Technical error logs and database codes (e.g. `ERR_SQLITE_CONSTRAINT_19`) are scrubbed from user-facing messages.
- **Actionable Recovery Suggestions:** Messages must provide clear, actionable instructions (e.g. write "Amount must be greater than zero" instead of "Invalid amount").
- **Consistent Placements:** Error messages are displayed directly below the active input container, aligned to the logical start edge of the form.

---

## 33. Success Feedback
Success feedback confirms that a form submission or database operation completed successfully.

- **Visual Confirmation Cards:** Submitting a form displays a success card using a soft green fill (`bankyar.semantic.color.success.fill`) and a clear checkmark icon.
- **Brief Notification Banners:** Minor operations (such as auto-saving a note) display a quick, non-intrusive alert banner at the bottom of the screen.
- **Short Presentation Durations:** Success alerts remain visible for 2,500 milliseconds before auto-dismissing, keeping the interface feeling fast.

---

## 34. Warning Feedback
Warning feedback highlights conditions that require user attention but do not block system operations (e.g. low-confidence parsing heuristic matches).

- **Soft Amber Highlights:** Warning elements use soft amber backgrounds (`bankyar.semantic.color.warning.fill`) and warning icons to draw attention.
- **Dual-Action Prompts:** Warnings include two clear action buttons, allowing users to either confirm the warning or edit the active input.
- **Readable Explanations:** Warn messages explain the potential risks in plain language, helping users make informed decisions.

---

## 35. Inline Validation
Inline validation provides real-time feedback within the input field as users enter data.

- **State-Based Transitions:** Input containers change border colors to green (`bankyar.semantic.color.border.success`) for valid inputs or red (`bankyar.semantic.color.border.error`) for errors.
- **Adaptive Height Gaps:** Field heights expand dynamically to display validation messages below the input container, ensuring layout lines remain stable.
- **Prevent Pre-Type Warnings:** Validation warnings are delayed until the user finishes typing or moves focus away from the field, avoiding premature errors.

---

## 36. Form-level Validation
Form-level validation executes when the user taps the primary submit button, performing final checks across all fields.

- **Automatic Error Focus:** If validation issues are discovered, the page scrolls automatically to focus on the first error field, opening the soft keyboard.
- **Subtle Motion Shake:** Fields containing errors play a quick, subtle horizontal shake animation to draw attention.
- **Disable Submit Action:** The submit button is locked if any form validation issues remain active, protecting database integrity.

---

## 37. Keyboard Behavior
Keyboard behaviors must be optimized to ensure comfortable typing and prevent layout overlaps.

- **Contextual Keypads:** Fields automatically launch their optimized keyboard layouts (alphabetical keyboards for notes; numeric keypads for amounts; email keypads for addresses).
- **Logical Navigation Actions:** Keyboards replace the standard Enter key with a logical "Next" action to move focus to the adjacent field, or a "Done" action on the final field.
- **Keyboard Dismiss Actions:** Tapping outside input fields or dragging down the form view closes the soft keyboard, maximizing readable screen area.

---

## 38. Autofill Strategy
The Autofill Strategy speeds up form entry by utilizing saved local data and secure system credentials.

- **Secure Platform Vaults:** Fields use standard autofill hints (such as username and password) to integrate with native system password managers safely.
- **Offline Ingestion History:** Common fields (such as merchant names or categories) suggest matches based on the user's offline transaction history.
- **Zero Cloud Connections:** Suggestion lists are processed entirely on-device, ensuring user data remains completely private.

---

## 39. Focus Management
Focus management ensures that keyboard navigation remains logical and accessible.

- **Logical Focus Ordering:** Pressing the Next key moves focus sequentially down the form, matching the vertical layout order.
- **Visible Focus Rings:** Focused fields are highlighted with a high-contrast focus outline (`bankyar.semantic.color.focus.outline`), supporting screen reader navigation.
- **Keyboard Auto-Scroll:** Focusing an input scrolls the form viewport to position the active field in the center of the screen, keeping inputs clearly visible.

---

## 40. Cursor Behavior
Cursor behaviors provide subtle visual guides that clarify the active editing point.

- **Symmetrical Placements:** In RTL Persian layouts, the cursor is positioned at the right edge of the empty text field, moving left as characters are entered.
- **Constant Color Accents:** The cursor uses the primary brand color token to stand out clearly from entered text.
- **No Text Overlaps:** The cursor maintains a tight horizontal separation buffer from adjacent letters to prevent character overlapping.

---

## 41. Input Formatting
Input formatting cleans and sanitizes entered data in real-time, preventing input mistakes.

- **Real-Time Input Sanitization:** Non-numeric characters are blocked from currency inputs, and invalid symbols are stripped from numeric entries automatically.
- **Enforced Character Capitalization:** Text fields (such as transaction references or codes) capitalize letters automatically.
- **Double Space Conversions:** Pressing the spacebar twice inserts a standard dot separator and a space, speeding up sentence entry.

---

## 42. Currency Formatting
Currency formatting ensures that financial amounts are displayed clearly and accurately across all screens.

- **Persian Suffix Placements:** In RTL layouts, the currency indicator is placed at the logical end (left) of the digits, separated by a non-breaking space.
- **Real-Time Separator Insertions:** Thousands separators are inserted automatically as the user types, updating the display on every keystroke.
- **Decimal Exclusions:** Because currencies like Rial and Toman do not use decimals, currency inputs block decimal points completely to avoid entries.

---

## 43. Persian Number Strategy
The Persian Number Strategy ensures that numbers are presented in standard localized formats.

- **Real-Time Digits Conversion:** The formatting engine intercepts Latin digits as they are typed, converting them to Persian numerals (e.g. 123 -> ۱۲۳) instantly.
- **Unified Number Systems:** Numerical values inside list items, transaction amounts, and budgets must utilize Persian numbers to ensure a consistent experience.
- **Unconverted Reference Fields:** Technical references (such as card numbers, IBANs, and transaction IDs) keep their Latin digit formats to support technical copying.

---

## 44. Mixed RTL/LTR Inputs
Mixed RTL/LTR inputs handle fields that combine Persian text with Latin characters (e.g. transaction reference codes, card identifiers, and emails).

- **Dynamic Direction Alignments:** Fields align to the logical start edge (right) by default. If the first typed character is Latin, the field switches dynamically to LTR alignment (left).
- **Isolated Character Blocks:** Latin character runs (such as card numbers or emails) are treated as isolated LTR blocks, preventing punctuation from jumping out of place.
- **Standard Bracket Placements:** Parentheses and brackets inherit the direction of the dominant text block to avoid misplaced characters.

---

## 45. Clipboard Behavior
Clipboard behaviors protect sensitive financial data while supporting convenient copy-paste actions.

- **Sensitive Data Blockers:** Copy and paste actions are blocked on secure fields (such as PIN locks and passwords) to prevent data leaks.
- **Clipboard Format Sanitizers:** Pasted text is passed through formatting filters, stripping out empty spaces, hidden control symbols, and invalid characters automatically.
- **Pasted Data Alerts:** Pasting content into a field displays a quick, non-intrusive alert verifying that content was imported successfully from the clipboard.

---

## 46. Secure Input Handling
Secure input handling protects sensitive user data from local security risks and screenshot tools.

- **Secure Screen Overlays:** Screens containing sensitive data (such as passwords, balances, or PIN entries) use secure native flags to redact content from task switchers and screenshots.
- **Memory Buffer Clears:** Sensitive input data is stored in short-lived memory buffers, clearing data immediately after form submissions or if the application is minimized.
- **Disable Cloud Keyboards:** Secure fields request system-level private keypads, preventing third-party soft keyboards from caching sensitive entries.

---

## 47. Accessibility Rules
Every form element is built to comply with WCAG AA accessibility standards, ensuring comfortable navigation for all users.

- **Touch Target Minimums:** Interactive targets (such as buttons, toggles, and selection rows) maintain a minimum physical height aligned with accessibility standards to prevent mis-taps.
- **Color Independence:** Meaning must never be conveyed solely by color. Error states, success feedback, and transaction trends must use clear icons and text labels.
- **Logical Navigation Orders:** Keyboard focus flows sequentially down the page, matching the visual vertical layout order.

---

## 48. Large Text Support
Large text support ensures that form elements remain readable and functional at any text magnification.

- **Responsive Vertical Wrapping:** When system text magnification is increased, horizontal rows wrap into vertical stacks to prevent text clipping.
- **No Fixed Heights:** Input containers and card boundaries use responsive heights that expand vertically, ensuring text never overlaps.
- **Scrollable Form Enclosures:** Forms are placed inside scrollable containers to ensure all fields remain accessible if text magnification exceeds screen boundaries.

---

## 49. Screen Reader Strategy
The Screen Reader Strategy ensures that form elements are read clearly and logically by screen readers.

- **Descriptive Content Labels:** Input fields use explicit accessibility labels (e.g., read "Transaction Amount Input: Forty-Five Thousand Tomans" instead of raw numbers).
- **Real-Time State Announcements:** Error alerts, inline validation updates, and form submissions are announced immediately to screen readers.
- **Read Order Symmetry:** Screen readers process form fields sequentially from top to bottom, matching the visual layout flow.

---

## 50. Governance Rules
To prevent inconsistent input styles and protect the integrity of the design system, all form designs must comply with these governance rules:

1. **Mandatory Token Usage:** Every input property (borders, colors, spacing, typography) must reference an active design token. Hardcoded values are strictly prohibited.
2. **Never Rely Only on Color:** Meaning must never be conveyed solely by color. All state shifts (errors, success) must use explicit icons and text descriptions.
3. **Labels Must Remain Visible:** Input labels must remain visible above the field at all times, preventing users from losing context.
4. **No Replacement Prompts:** Input hints and empty value prompts must never replace main labels.
5. **Minimize Typing Effort:** Forms must prioritize quick selection chips, intelligent defaults, and automation over manual typing.
6. **Validation Must Be Predictable:** Input validations must execute consistently across all screens, caught before form submissions.
7. **Secure Sensitive Fields:** High-priority inputs (PINs, passwords) must utilize secure native flags and auto-clear buffers.

---

## 51. Validation Checklist
Before releasing an input form, verify compliance against this checklist:

- [ ] Does every input element map to an active design token?
- [ ] Are all physical alignments replaced with logical start/end coordinates?
- [ ] Do input fields support up to 200% text magnification without clipping text?
- [ ] Are labels visible above the input containers at all times?
- [ ] Do currency and numeric inputs block invalid characters automatically?
- [ ] Is copy-paste blocked on sensitive PIN and password fields?
- [ ] Do all error messages explain exactly how to recover?

---

## 52. Anti-pattern Catalog
The following form design anti-patterns are strictly prohibited:

- **Floating Overlay Dropdowns:** Placing long choice selectors inside floating menus that overflow screens, rather than using bottom sheets.
- **Hardcoded Dimensions:** Defining input fields with fixed pixel dimensions that clip text under large font sizes.
- **Asterisk Required Indicators:** Using red star asterisks (`*`) to mark required fields, without adding explicit text labels.
- **Delayed Input Validations:** Delaying validation until form submission, rather than checking syntax inline as users type.
- **Insecure Clipboard Cache:** Allowing users to copy sensitive PIN codes or passwords directly into the system clipboard.

---

## 53. Future Evolution Strategy
The Forms & Input Experience System is built to scale alongside BankYar:

- **Universal Localization:** Input styles are decoupled from language engines, allowing the design system to support future localization updates (such as English and Arabic) without changes to layout code.
- **Biometric API Integrations:** Secure input structures are prepared to integrate seamlessly with native biometric APIs (FaceID, fingerprint scanners), replacing manual passcode entries.
- **Component Lifecycle Governance:** Deprecated input elements follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing clear migration pathways for development teams.

---

## Financial Inputs
This section defines specific UX rules for core financial forms inside BankYar:

- **Transaction Search:** Uses debounced query inputs, horizontally scrollable filter chips, and an instant clear action.
- **Transaction Notes:** Employs an adaptive-heightNotes Editor with an inline formatting toolbar for adding tags and emojis.
- **Currency Amount:** Uses right-aligned numeric entries with real-time thousands separators and a Persian currency suffix.
- **Balance Input:** Implements constrained numeric inputs with zero-input protection, ensuring valid financial records.
- **Manual Transaction:** Combines vertical single-column inputs, auto-suggest histories, and a disabled submit button until all required fields are validated.
- **Backup Password:** Features strict password complexity checks with visual match verifications and a prominent warning banner.
- **Restore Password:** Verifies entered passwords inline before executing database decrypt operations.
- **PIN Unlock:** Uses separated character boxes with instant auto-validation on the fourth digit.
- **Export Password:** Secures database exports by requiring a strong backup password with real-time complexity meters.
- **Import Password:** Safely unlocks imported database backups, using masked input boxes with visibility toggles.
- **Date Filters:** Employs Shamsi calendar pickers with common quick-select presets for date filters.
- **Advanced Search:** Integrates date pickers, amount range sliders, and tag selectors inside a clean vertical form.
- **Statistics Filters:** Uses horizontal filter chip groups to quickly adjust period reports on the analytics dashboard.
- **Settings Forms:** Uses Switches for preferences and Radio Groups for mutual selections, updating states instantly.

---

## Validation Matrix
The validation matrix defines automated checks used to ensure all form inputs remain structurally sound and secure:

| Field Context | Validation Type | Execution Trigger | Visual Action | Error Recovery Message |
| :--- | :--- | :--- | :--- | :--- |
| **Transaction Amount** | Non-zero numeric validation | Real-time entry / On submit | Show red outline & assist text | "Amount must be greater than zero." |
| **PIN Lock Setup** | Exact 4-digit numeric verification | Auto-fires on 4th digit | Shake circles if mismatch | "PIN codes do not match. Please try again." |
| **Card Number** | 16-digit structure validation | Deferred on focus loss | Display warning warning icon | "Please enter a valid 16-digit card number." |
| **Backup Password** | Complexity requirement | Real-time entry | Highlight checklist items | "Password must contain at least 8 characters." |
| **Parsing Rule Name** | Unique local DB verification | Real-time query | Display warning alert card | "This rule name already exists. Please choose another." |

---

## Security Guidelines
To protect user privacy and financial data, all forms must adhere to these security guidelines:

1. **Secure Input Masking:** Passwords and PIN codes are masked using circular symbols (`•`) with a short visual delay of 800 milliseconds on the active character.
2. **Auto-Clear Buffers:** Sensitive input data is stored in short-lived memory buffers, clearing data immediately after form submissions or if the application is minimized.
3. **Block Clipboard Actions:** Copy and paste actions are blocked on secure fields (such as PIN locks and passwords) to prevent data leaks.
4. **Secure Task Switchers:** Screens containing sensitive data (such as balances or PIN entries) use secure native flags to redact content from task switchers and screenshots.
5. **Secure Autofills:** Secure fields request private system keypads, preventing third-party soft keyboards from caching sensitive entries.

---

## Governance Rules Matrix
The governance rules matrix establishes priority weights and validation checks for the primary input rules:

| Governance Rule | Core Usability Goal | Verification Mechanism | Priority Weight | Status |
| :--- | :--- | :--- | :---: | :---: |
| **One Meaning Per Color** | Prevents confusion by using color channels consistently. | Checked by semantic system compiler | **Highest** | Mandatory |
| **Always Explain Recovery** | Guides users back to successful states with actionable text. | Verified during design review checklist | **Highest** | Mandatory |
| **Visible Labels** | Keeps input labels visible at all times to preserve context. | Checked by component design audit | **High** | Mandatory |
| **Minimize Typing Effort** | Speeds up entry using quick selection chips and defaults. | Checked during UX planning reviews | **High** | Mandatory |

---

## Form Architecture Diagrams
The following diagrams illustrate the layout scaffolding and interaction flow of the input fields:

### Symmetrical Field Scaffolding
```
  +-------------------------------------------------------------+
  | Logical Start Edge (Right-aligned in RTL)                   |
  |                                                             |
  |   { Text Input Label } (bankyar.font.size.xs)                |
  |   +-----------------------------------------------------+   |
  |   | [ Icon ] | Active Value Text         | [ Clear ]    |   |
  |   | (Start)  | (bankyar.font.size.md)    | (End)        |   |
  |   +-----------------------------------------------------+   |
  |   ( Inactive state: Subtle gray border; Active: Highlight ) |
  |                                                             |
  |   { Actionable Assist or Error Text }                       |
  +-------------------------------------------------------------+
```

This scaffolding ensures that input elements, labels, and assist messages maintain symmetrical alignments and comfortable spacing across all screens.

---

## Validation Flow Charts
The interaction flow chart maps how user inputs are checked, validated, and processed by the system:

```
                  [ User inputs content into text field ]
                                     |
                                     v
                  [ Masking & Formatting Engine applies ]
                                     |
                                     v
               Is character valid for field category syntax?
                 /                                       \
               YES                                        NO
               /                                           \
    [ Update active cursor ]                    [ Block character entry ]
              |                                             |
              v                                             v
     Is input complete?                        [ Play subtle audio click ]
     /                \
   YES                 NO
   /                     \
[ Check dependencies ]  [ Wait for next keystroke ]
```

---

## Input Taxonomy
The input taxonomy structures design tokens, separating visual styles from input code:

- `bankyar.component.input.text.fill`: Mapped to `bankyar.semantic.color.background.canvas` (Light neutral input field fill).
- `bankyar.component.input.text.border.default`: Mapped to `bankyar.semantic.color.border.default` (Subtle separator line).
- `bankyar.component.input.text.border.active`: Mapped to `bankyar.semantic.color.border.focus` (High-contrast active highlight border).
- `bankyar.component.input.text.border.error`: Mapped to `bankyar.semantic.color.border.error` (Red validation warning border).
- `bankyar.component.input.text.text.primary`: Mapped to `bankyar.semantic.color.text.primary` (Readable text value).
- `bankyar.component.input.text.text.helper`: Mapped to `bankyar.semantic.color.text.helper` (Subtle inline validation text).

---

## Accessibility Checklist
The accessibility checklist ensures that all input components are usable by everyone:

- [ ] Interactive touch targets (buttons, inputs) maintain a minimum physical height.
- [ ] Text elements support up to 200% system magnification without clipping.
- [ ] Screen readers read input fields using clear, descriptive accessibility labels.
- [ ] Meaning is never conveyed solely by color; all states use text and icons.
- [ ] Focus indicators remain visible during keyboard and screen reader navigation.
- [ ] Forms stack vertically in a single column to support natural scrolling.

---

## Architecture Alignment
This Forms & Input Experience System Architecture is fully aligned with the **BankYar Architecture Specification**:

* **Offline-First Security:** All input validations, calculations, and auto-suggest histories are processed entirely on-device, requiring zero network access.
* **Performance-First Rendering:** Masking, formatting, and validation calculations are highly optimized, ensuring smooth 60FPS scrolling and typing.
* **Local SQLCipher Integrity:** Validated inputs are mapped directly to database models, ensuring secure offline storage.

---
**End of Document**
