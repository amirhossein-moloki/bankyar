# BankYar Typography System Architecture

## Executive Summary
This document establishes the official, enterprise-grade Typography System Architecture for BankYar. Designed to implement the core product personality (Stoic, Precise, Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this system is the absolute and non-negotiable authority for all text elements across the BankYar ecosystem.

As an offline-first financial application natively targeting Persian (RTL) with future scalability to Arabic and English (LTR), text readability is our most critical interaction medium. This system ensures high-precision text processing, absolute visual clarity for complex financial metrics, robust accessibility, and seamless responsive design without introducing framework dependencies or platform-specific constraints.

To maintain perfect abstraction, this architecture prohibits the selection of specific font families, hardcoded pixel measurements, color hex values, or framework-specific code implementations. All typographic properties are defined as abstract tokens, logical constraints, and governance rules.

---

## 1. Typography Philosophy
Typography in BankYar is treated as a core functional layout element, not an aesthetic embellishment. In alignment with our *Content-as-Interface* design philosophy, our typographic structures are built on three fundamental tenets:
* **Information Over Decoration:** Typography must never compete for the user's attention. Every text classification exists solely to organize financial truth, accelerate scan-readability, and minimize visual noise.
* **Precise Chronology and Hierarchy:** Financial values (amounts, balances) possess highest visual priority, while descriptions and metadata remain visually nested. The user’s eye must glide effortlessly from primary transactional amounts down to structural metadata.
* **Localization-First Geometry:** Persian typography (RTL) behaves differently from Latin typography (LTR). This system uses logical, layout-agnostic spatial tokens and custom baseline safeguards to ensure that text lines, spacing, and characters align perfectly across any language.

---

## 2. Readability Principles
To ensure error-free comprehension of financial transactions under diverse mobile reading conditions, we enforce five core readability principles:
* **Mathematical Preservation:** Financial numbers represent the ultimate truth. Numbers must never be clipped, rounded, or visually obscured by neighboring elements. Vertical alignment of digits must remain completely stable.
* **Contrast-Bound Separation:** Meaning must never be conveyed solely by color. Typographic weight, size contrast, and logical tags must work together to distinguish credit and debit operations, transaction states, and warnings.
* **Cursive Connectivity Safeguard:** Persian characters utilize a cursive baseline. Compressing letter-spacing breaks connection ligatures. Therefore, letter-spacing must remain strictly neutral for cursive text.
* **Ascender/Descender Collision Prevention:** Persian and Arabic characters feature tall ascenders (such as Alef and Lam) and deep descenders (such as Ye and Re). Line heights must be sufficiently loose to prevent overlapping text lines.
* **Cognitive Load Chunking:** Text density is controlled by clear grouping. Long numerical runs (such as bank card numbers and transaction IDs) must be chunked into readable sub-blocks.

---

## 3. Typography Hierarchy
To organize financial records clearly, BankYar employs a strict, six-tier vertical typographic hierarchy. This hierarchy ensures that primary numbers receive maximum focus, while helper text is tucked away neatly.

### Typography Hierarchy Diagram
```
+-----------------------------------------------------------------------+
|  DISPLAY: Primary Account Overview / Balance Numbers                 |
|  [Sizing: XXL] [Weight: Bold] [Leading: Tight]                         |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|  HEADING / TITLE: Section Dividers / Core Cards / Modal Titles        |
|  [Sizing: XL / LG] [Weight: Bold / Medium] [Leading: Standard]        |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|  SUBTITLE / BODY: Descriptions / Notes / Core Interactive Inputs      |
|  [Sizing: MD] [Weight: Regular / Medium] [Leading: Loose]             |
+-----------------------------------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------+
|  CAPTION / LABEL / BUTTON: Form Labels / Timestamps / Action triggers  |
|  [Sizing: SM / XS] [Weight: Regular / Bold] [Leading: Tight]          |
+-----------------------------------------------------------------------+
```

### Typography Matrix
The following matrix binds text classifications to design token structures and usage contexts across the application:

| Text Category | Token Name | Size Token Reference | Weight Token Reference | Leading Token Reference | Primary Usage Context |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Display** | `bankyar.text.display.large` | `bankyar.font.size.xxl` | `bankyar.font.weight.bold` | `bankyar.font.leading.tight` | Main dashboard total balance, primary income/expense numbers |
| **Heading** | `bankyar.text.heading.medium` | `bankyar.font.size.xl` | `bankyar.font.weight.bold` | `bankyar.font.leading.standard` | Core card section titles, bottom sheet headers |
| **Title** | `bankyar.text.title.medium` | `bankyar.font.size.lg` | `bankyar.font.weight.medium` | `bankyar.font.leading.standard` | Bank/Merchant name in ledger list, dialog box headers |
| **Subtitle** | `bankyar.text.subtitle.medium` | `bankyar.font.size.md` | `bankyar.font.weight.medium` | `bankyar.font.leading.loose` | Form input section descriptors, dialog description |
| **Body** | `bankyar.text.body.medium` | `bankyar.font.size.md` | `bankyar.font.weight.regular` | `bankyar.font.leading.loose` | Transaction notes, unparsed raw SMS text blocks |
| **Caption**| `bankyar.text.caption.medium` | `bankyar.font.size.sm` | `bankyar.font.weight.regular` | `bankyar.font.leading.standard` | Transaction timestamps, auxiliary card metadata |
| **Label** | `bankyar.text.label.medium` | `bankyar.font.size.xs` | `bankyar.font.weight.regular` | `bankyar.font.leading.tight` | Form input header labels, active state indicators |
| **Button** | `bankyar.text.button.medium` | `bankyar.font.size.md` | `bankyar.font.weight.medium` | `bankyar.font.leading.tight` | Primary and secondary dialog and action button triggers |

---

## 4. Text Categories

### 5. Display Typography
* **Intent:** Maximum visual emphasis. Reserved for high-level account status numbers and total financial summaries.
* **Leading Rules:** Tight tracking is applied to bring the large numbers closer, saving vertical layout space.
* **Layout Safeguards:** Displays must be wrapped in layout containers that allow numbers to scale down if the text exceeds screen bounds on smaller devices.

### 6. Heading Typography
* **Intent:** Screen and page level separation. Used to group transaction lists, charts, and configuration panels.
* **Leading Rules:** Standard tracking balances the bold weight of section markers.
* **Layout Safeguards:** Headings must align strictly to the logical start edge of the layout container.

### 7. Title Typography
* **Intent:** Component-level hierarchy. Used for primary text entries inside functional containers (such as bank and merchant names in transaction cards).
* **Leading Rules:** Standard leading ensures clean vertical separation from secondary descriptions.
* **Layout Safeguards:** Titles must support logical truncation if they collide with inline metrics (like transaction amounts).

### 8. Subtitle Typography
* **Intent:** Mid-level structural grouping. Used for auxiliary section details, settings item headers, and card subheadings.
* **Leading Rules:** Standard leading preserves vertical legibility.
* **Layout Safeguards:** Subtitles must share the identical start alignment of their parent title components.

### 9. Body Typography
* **Intent:** Primary reading passages. Reserved for multi-line text blocks, including transaction notes, raw banking SMS inspect blocks, and system notices.
* **Leading Rules:** Loose leading is enforced to protect Persian reading baselines across multiple lines.
* **Layout Safeguards:** Body styles must support automatic wrapping at standard container margins.

### 10. Caption Typography
* **Intent:** Minor auxiliary metadata. Used for date/time stamps, card numbers, transaction ID strings, and auxiliary diagnostics.
* **Leading Rules:** Standard leading ensures compact layout nesting.
* **Layout Safeguards:** Caption text uses secondary contrast tokens to maintain proper visual hierarchy.

### 11. Label Typography
* **Intent:** Input indicator titles and badge text. Used to frame data entry contexts and transaction tags (such as categorization chips).
* **Leading Rules:** Tight leading minimizes the vertical footprint of metadata.
* **Layout Safeguards:** Labels must be vertically centered inside their containing shapes.

### 12. Button Typography
* **Intent:** Action triggers. Applied to primary, secondary, and boundary action controls.
* **Leading Rules:** Tight leading centers the label vertically inside button shapes.
* **Layout Safeguards:** Button labels must remain single-line and align horizontally center.

### 13. Navigation Typography
* **Intent:** Navigation bar labels and tab structures.
* **Leading Rules:** Tight leading ensures compact layout nesting.
* **Layout Safeguards:** Navigation text must scale proportionally with active/inactive states without causing layout jumps.

### 14. Dialog Typography
* **Intent:** Informational overlays and system confirmations.
* **Leading Rules:** Tight leading for headers; loose leading for descriptive body copy.
* **Layout Safeguards:** Dialog titles must align to the logical start edge, supporting rapid scan-reading.

### 15. Form Typography
* **Intent:** Interactive user inputs and field validation.
* **Leading Rules:** Standard leading provides comfortable visual spacing.
* **Layout Safeguards:** Form text must align logical-start, matching system directionality.

### 16. Table Typography
* **Intent:** Multi-row transactional spreadsheets and category matrices.
* **Leading Rules:** Tight leading maximizes vertical density.
* **Layout Safeguards:** Text columns must align logical-start; numerical value columns must align logical-end.

### 17. Chart Typography
* **Intent:** Graph values, axis labels, and chart legends.
* **Leading Rules:** Tight leading prevents overlapping graph elements.
* **Layout Safeguards:** Monospace fonts are used for numbers to align values on horizontal gridlines.

### 18. Notification Typography
* **Intent:** Real-time system updates and background parsing alerts.
* **Leading Rules:** Standard leading ensures immediate legibility.
* **Layout Safeguards:** Text must wrap and support a maximum of two lines.

---

## 5. Financial Typography

### 19. Financial Typography Principles
To represent financial transactions with absolute clarity, we enforce the following rules:
* **Visual Priority:** Financial amounts must always carry higher visual weight (using larger sizing and bolder weights) than neighboring descriptive text.
* **Color Independence:** Credit (income) and debit (expense) transactions must not be distinguished solely by color. They must use clear mathematical symbols (e.g., `+` for credit, `-` for debit) next to the currency symbol.
* **Metadata Hierarchy:**
  1. Transaction Amount (Highest emphasis)
  2. Currency Symbol (Medium emphasis)
  3. Bank Name & Merchant (Standard emphasis)
  4. Date, Timestamp, & Notes (Lowest emphasis)

### 20. Number Formatting Strategy
* **Chunking:** Numbers longer than four digits must utilize standard local digit grouping separators (e.g., thousands separators) to facilitate immediate reading.
* **Decimal Alignment:** For tabular lists, decimal points must align vertically to preserve structural readability.
* **No Arbitrary Rounding:** Transaction amounts must preserve exact fractional values to ensure financial accuracy.

### 21. Currency Display Rules
* **Positioning:** In RTL Persian layouts, the currency symbol or text (e.g., "ریال" or "تومان") must reside at the logical end of the numerical value (to the left of the digits).
* **Alignment:** The currency symbol must be separated from the digit block by a non-breaking space to prevent orphan line wraps.

```
RTL Layout:   [Currency Symbol] [Space] [Numerical Digits]  <- (Reading flows Right-to-Left)
```

### 22. Persian Digit Strategy
* **Usage:** Persian digits (e.g., ۱, ۲, ۳) must be used across all primary localized content, including transaction lists, balances, input fields, and dashboard overview screens.
* **Ligatures:** Numbers must not use cursive ligatures; each digit must remain visually separated.

### 23. Latin Digit Strategy
* **Usage:** Latin digits (e.g., 1, 2, 3) must be used for technical values, including bank card numbers, IBANs, transaction IDs, verification codes, and debug logs.
* **Monospace:** Monospace tracking must be enabled for Latin digit runs to ensure characters align vertically.

### 24. Mixed-language Rules
When Persian text, English terms, and numerical strings are mixed, layouts must follow these constraints:
* **LTR Insertion:** Technical English names, transaction reference codes, and URLs must render as Left-to-Right blocks nested inside the Right-to-Left container.
* **Neutral Punctuation:** Parentheses and punctuation marks must inherit the direction of the dominant language to avoid misplaced characters.

---

## 6. Text Flow, Alignment, & Layout

### 25. Line Length Guidelines
* **Paragraph Text:** For body paragraphs (e.g., transaction notes, terms of service, and descriptions), line lengths must be constrained to a comfortable reading range (between 45 and 75 characters per line).
* **Metadata Text:** For metadata fields, lines must remain single-line and utilize truncation safeguards.

### 26. Text Alignment Rules
* **Logical Alignment:** Physical alignments (left/right) are prohibited. All text elements must use logical alignments (`start` and `end`) to ensure layouts adapt automatically when switching between RTL and LTR locales.
* **Mixed Text Direction:** If a text block begins with a Persian character, the container must use RTL directionality. If it begins with a Latin character, LTR directionality is applied.

### 27. RTL Layout Rules
* **Mirroring:** Layout structures, reading flows, navigation gestures, and back buttons must mirror naturally when switching locales.
* **Logical Spacing:** Inner padding and margins must be declared logically (e.g., start and end instead of left and right) to ensure seamless RTL scaling.

```
LTR Locale:  [Margin Start (Left)]  --------->  [Margin End (Right)]
RTL Locale:  [Margin Start (Right)] --------->  [Margin End (Left)]
```

### 28. Truncation Rules
* **Middle Truncation:** Technical strings (such as transaction IDs, bank accounts, and IBANs) must use middle truncation (e.g., `1234...9012`) to preserve both the start and end identifiers of the record.
* **End Truncation:** Merchant names and notes must use end truncation (e.g., `Merchant Name...`) to maximize readability in tight lists.

### 29. Wrapping Rules
* **Hyphenation:** Persian typography does not support hyphenation; words must remain unbroken.
* **Orphan Control:** High-priority metadata (such as dates, times, and currencies) must use non-breaking spaces to ensure they wrap together as a unified block.

### 30. Overflow Handling
* **Dynamic Scaling:** Numerical display components must scale text sizes down dynamically as text length grows.
* **Ellipsis Safeguards:** All text views in transaction lists must have explicit ellipsis handling to prevent overlapping lines on small screens.

---

## 7. Accessibility Strategy & Dynamics

This system is built to meet WCAG AA contrast standards and support diverse accessibility needs:

### 31. Accessibility Checklist
- [ ] **Contrast Ratio:** Text-to-background contrast maintains a minimum ratio of 4.5:1 for body copy and 3:1 for large display headers.
- [ ] **Color Independence:** Visual signals (e.g., successful SMS parses) do not rely on color alone. They use explicit text labels, icons, or badges.
- [ ] **Dynamic Scaling:** Text elements support system-level layout magnification (up to 200%) without overlapping.
- [ ] **Screen Reader Labels:** Text elements utilize descriptive semantic labels (e.g., "Debit Transaction: Ten Thousand Tomans" instead of raw numerical outputs).
- [ ] **Interactive Targets:** Form fields and button labels maintain comfortable, touch-friendly touch targets to prevent mis-taps.
- [ ] **Reading Order:** Semantic reading order matches logical text layout (RTL for Persian; LTR for English).

### 32. Large Text Support
* **Dynamic Scaling:** All typographic boundaries must adapt proportionally when the user adjusts their system-level text magnification.
* **Responsive Layouts:** When text scales up significantly, vertical containers must expand dynamically, and horizontal rows must wrap into vertical stacks to prevent text clipping.

```
Normal Scale:  [Label]  [Value]
Large Scale:   [Label]
               [Value]
```

### 33. Font Weight Strategy
* **Hierarchy:** We use relative weights (Light, Regular, Medium, Bold) to establish visual priority, rather than relying on color or size shifts alone.
* **Accessibility:** Bold weights are reserved for key financial metrics, titles, and active buttons to ensure legibility for users with low vision.

### 34. Letter Spacing Strategy
* **Cursive Rule:** Cursive scripts (Persian/Arabic) must use zero tracking (`0.0`) to avoid breaking character connections.
* **Latin Rule:** Latin text and technical monospace blocks may apply tight tracking to optimize horizontal layout space in transaction tables.

### 35. Line Height Strategy
* **Ascender Buffer:** Persian character lines require a larger line-height buffer than Latin characters. We enforce a minimum line height multiplier of `1.4` for body paragraphs and `1.2` for display numbers to prevent overlapping ascenders and descenders.

---

## 8. Token Mapping, Governance, & Validation

### 36. Token Mapping
This system links design tokens to semantic layout classes, separating visual styling from application layout code:

```
[System Token: bankyar.font.size.xxl] ---> [Semantic Token: bankyar.text.display.large] ---> [App Component: Ledger Balance]
```

* Components must only reference **Semantic Typography Tokens** (e.g., `bankyar.text.body.medium`).
* Raw physical units and specific font files are managed exclusively by the **Global Design Token Dictionary**.

### 37. Governance Rules
To maintain typographic consistency, we enforce five core governance rules:
1. **Mandatory Token Reference:** Every text element must map to a semantic typography token. Hardcoded visual values are strictly prohibited.
2. **Unified Scale Constraints:** Layout alignments, line lengths, and tracking multipliers must use the values defined in this specification.
3. **No Arbitrary Combinations:** Changing font weights or leading values outside of the approved token combinations is prohibited.
4. **Platform Independence:** Typography rules must be defined in a platform-agnostic format (e.g., JSON schemas) and compiled into target frameworks.
5. **Mandatory Compliance Review:** All new features must pass the official Typography Review Checklist before being released.

### 38. Validation Matrix
This matrix defines validation rules for automated linting and design system verification:

| Rule ID | Check Target | Validation Condition | Failure Penalty |
| :--- | :--- | :--- | :--- |
| **VAL-TYP-01** | Color Values | Typography files must not contain raw HEX colors | Build Failure |
| **VAL-TYP-02** | Font Sizes | Typography files must not define raw pixel units | Build Failure |
| **VAL-TYP-03** | Token Reference | Every text style must map to an active token | Compile Warning |
| **VAL-TYP-04** | Letter Spacing | Persian cursive blocks must use zero tracking | Build Failure |
| **VAL-TYP-05** | Line Height | Persian body paragraphs must use line heights >= 1.4 | Build Failure |

---

## 9. Anti-Pattern Catalog

The following typographic anti-patterns are strictly prohibited:

* **Physical Unit Hardcoding:** Defining text sizes in raw pixel units (e.g., raw number inputs like `fontSize: 14` or physical suffix values) or using physical margins instead of logical start/end spacing.
* **Arbitrary Weights:** Using non-standard font weights (e.g., thin or ultra-bold weights) that do not align with our core design system.
* **Color-Only Indication:** Distinguishing debit and credit operations solely by shifting text colors, without adding mathematical signs or text labels.
* **Compressed Persian Tracking:** Compressing letter-spacing on Persian cursive words, which breaks baseline connections and reduces legibility.
* **Fixed Height Overflows:** Placing body text or transaction details inside fixed-height containers that clip text when system font scale is increased.

---

## 10. Future Evolution Strategy

As BankYar expands, the Typography System is built to scale:
* **Universal Localization:** The typography system supports a platform-agnostic design, easing future integration with target platforms (e.g., iOS and desktop environments).
* **Multi-Brand Compatibility:** Theme tokens isolate visual styles from component logic, allowing the design system to support new visual configurations and future localization requirements (such as English and Arabic) without changes to the core layout code.
* **Backward Compatibility:** Deprecated typography tokens must follow our standard lifecycle (`Draft -> Active -> Deprecated -> Obsolete`), providing development teams with clear migration pathways between updates.
