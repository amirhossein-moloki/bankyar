# BankYar Design System: Dark Theme Design Specification (v1.0.0)
## Enterprise-Grade Specification for Secure, Low-Strain Offline Financial Platforms

---

## Executive Summary
This document establishes the official and authoritative **Dark Theme Design Specification** for the BankYar ecosystem. Designed to implement the core product personality (*Stoic, Precise, Empowering*) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this specification serves as the absolute visual and structural blueprint for all dark mode interfaces.

As an offline-first personal finance platform designed specifically for Android with future portability to iOS and desktop systems, BankYar manages sensitive financial transaction data natively in Persian (RTL). This premium dark theme is engineered to improve visual readability, reduce eye strain during night-time analytical reviews, preserve OLED battery life, and project a highly secure, trustworthy financial workspace.

In strict adherence to the **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets of the product:
* **No Direct HEX/Hardcoded Styles:** All color and structural relationships are defined as abstract tokens and logical maps.
* **No Hardcoded Physical Units:** There are zero hardcoded physical measurements (such as `px`, `dp`, or `sp`) in the styling guidelines. All spatial metrics reference the design token scales defined in `LAYOUT_SPACING_SYSTEM.md` or relative constraints.
* **No Framework Widget Code:** This system resides completely at the Semantic Color Architecture and Component Specification level, ensuring a platform-agnostic blueprint suitable for direct Flutter implementation.

---

## TABLE OF CONTENTS
1. [Dark Theme Design Philosophy & Vision](#1-dark-theme-design-philosophy--vision)
2. [Abstract Dark Theme Palette (Primitive Layer)](#2-abstract-dark-theme-palette-primitive-layer)
3. [Dark Mode Semantic Color Mapping Matrix](#3-dark-mode-semantic-color-mapping-matrix)
4. [Tonal Elevation, Depth, & Layering Architecture](#4-tonal-elevation-depth--layering-architecture)
5. [Typography & Readability Hierarchy Rules](#5-typography--readability-hierarchy-rules)
6. [Universal Component-Specific Dark Themes](#6-universal-component-specific-dark-themes)
7. [Transaction State & Category Semantic Colors](#7-transaction-state--category-semantic-colors)
8. [Financial Chart & Data Visualization Palettes](#8-financial-chart--data-visualization-palettes)
9. [Accessibility, Contrast, & Color-Blind Validation](#9-accessibility-contrast--color-blind-validation)
10. [Material You Dynamic Color Integration](#10-material-you-dynamic-color-integration)
11. [Future-Ready Adaptations (Multi-Device Targets)](#11-future-ready-adaptations-multi-device-targets)
12. [Anti-Patterns, Validation, & Governance Checklist](#12-anti-patterns-validation--governance-checklist)

---

## 1. Dark Theme Design Philosophy & Vision

The BankYar Dark Theme is **not a simple mathematical inversion of light theme values**. Instead, it is a custom-designed, low-fatigue color system engineered around the visual behaviors of OLED/AMOLED screens and the psychological needs of users reviewing financial records in low-light environments.

```
       Light Theme                                   Dark Theme (Premium)
+------------------------+                       +------------------------+
| Background: White (50) |                       | Background: Gray (950) |
| Cards: Light Gray (100)|   (Custom Mapping)    | Cards: Deep Gray (900) |
| Text: Deep Gray (950)  | --------------------> | Text: Light Gray (50)  |
| Accents: Saturated     |                       | Accents: Softened/Pastel|
+------------------------+                       +------------------------+
```

Our dark theme strategy is built on four core design tenets:
1. **The Stoic Void (True Dark Foundation):** To maximize OLED battery life and prevent "gray-glow" backlight bleeding under dark conditions, we use a deep neutral charcoal grayscale (`950`) as the absolute canvas foundation.
2. **Visual Ergonomics & Zero Smear:** Pure black backgrounds paired with high-contrast pure white text produce severe visual "smearing" and halation effects during rapid scrolling. We soften the typography to high-readability off-whites (e.g., `50` or `100` scales) and restrict absolute whites to primary amounts and focus highlights.
3. **Muted Financial Semantics (No Visual Panic):** Bright, neon red and green statuses cause severe cognitive fatigue in dark environments. We utilize desaturated, pastel-shifted semantic color scales that hold high WCAG contrast but feel calm and professional.
4. **Physicality via Tonal Elevation:** Since shadows are virtually invisible on dark backgrounds, we represent layout depth and information nesting through dynamic, cumulative white-opacity tonal overlays. This avoids flat, unreadable, and confusing cards.

---

## 2. Abstract Dark Theme Palette (Primitive Layer)

The Dark Theme Primitive Layer provides the mathematical palette scales used to compile the active dark theme. These tokens define the relative visual steps from darkest (`950`) to lightest (`50`).

```
         Primitive Scale Steps:
         [950] -> [900] -> [850] -> [800] -> ... -> [100] -> [50]
         (Darkest Canvas)                 ->                  (Lightest Highlight)
```

### 2.1 Grayscale Scale (Base Neutrals)
* `bankyar.global.color.neutral.950`: Pure obsidian gray (absolute canvas base, minimizes OLED power consumption).
* `bankyar.global.color.neutral.900`: Deep slate gray (default flat card surface containment).
* `bankyar.global.color.neutral.850`: Elevated slate gray (raised surface containers, sticky app bars, bottom sheets).
* `bankyar.global.color.neutral.800`: Medium-deep gray (active field fills, dropdown items, selected states).
* `bankyar.global.color.neutral.700`: Medium gray (subtle border dividers, unselected icon tracks).
* `bankyar.global.color.neutral.600`: Medium-light gray (disabled text backgrounds, inactive outlines).
* `bankyar.global.color.neutral.400`: Cool steel gray (helper copy, caption text, placeholder prompts).
* `bankyar.global.color.neutral.200`: Muted silver gray (secondary reading typography, unselected menu icons).
* `bankyar.global.color.neutral.100`: Off-white silver (standard body reading text, dialog content headings).
* `bankyar.global.color.neutral.50`: Absolute paper white (primary transaction balances, focus highlight rings).

### 2.2 Brand Azure Scale (Interactive Anchor - Primary)
* `bankyar.global.color.primary.950`: Extremely deep midnight indigo (primary button container pressed state).
* `bankyar.global.color.primary.800`: Deep navy sapphire (primary button container default background).
* `bankyar.global.color.primary.500`: Slate-blue azure (secondary action outlines, unselected active indicators).
* `bankyar.global.color.primary.300`: Pastel cobalt azure (focused borders, active navigation selectors, interactive highlights).
* `bankyar.global.color.primary.100`: Ultra-soft baby blue (on-primary text highlights, accent badge backgrounds).

### 2.3 Brand Teal/Slate Scale (Secondary Accent)
* `bankyar.global.color.secondary.950`: Ultra-deep teal slate (container boundary shading).
* `bankyar.global.color.secondary.800`: Deep forest-teal charcoal (secondary status background container).
* `bankyar.global.color.secondary.300`: Pastel teal-cyan (secondary badge highlights, unselected active indicators).
* `bankyar.global.color.secondary.100`: Soft seafoam mint (secondary text emphasis, helper tags).

### 2.4 Brand Gold/Bronze Scale (Tertiary Accent)
To support goal tracking, achievements, local gamification, and special financial rewards, a desaturated Tertiary palette is specified:
* `bankyar.global.color.tertiary.950`: Ultra-deep bronze gold (tertiary button/badge container background pressed state).
* `bankyar.global.color.tertiary.800`: Deep antique copper/gold (tertiary item background container).
* `bankyar.global.color.tertiary.300`: Soft desaturated gold/bronze (savings goals tracker line, verified custom tags, achievement labels).
* `bankyar.global.color.tertiary.100`: Pastel cream gold (tertiary on-container texts, reward chips highlights).

### 2.5 Semantic Status Scales (Desaturated Pastels)
To satisfy accessibility constraints without causing screen glare, status colors use desaturated pastel values:

| Status Scale | Lightest Step (50/100) | Mid-Tone Step (300/400) | Deepest Step (800/900) |
| :--- | :--- | :--- | :--- |
| **Success (Green)** | `bankyar.global.color.success.100` (Income background badge) | `bankyar.global.color.success.300` (Default positive income typography) | `bankyar.global.color.success.900` (Deep container, silent complete status) |
| **Warning (Amber)** | `bankyar.global.color.warning.100` (Heuristic review background) | `bankyar.global.color.warning.300` (Pending payment / Scheduled tag text) | `bankyar.global.color.warning.900` (Low-confidence template container) |
| **Error (Crimson)** | `bankyar.global.color.error.100` (Parsing failure background) | `bankyar.global.color.error.300` (Default negative expense typography) | `bankyar.global.color.error.900` (Destructive purge alert container) |
| **Info (Cobalt)** | `bankyar.global.color.info.100` (Backup tip panel background) | `bankyar.global.color.info.300` (Instructional icon / Guide label) | `bankyar.global.color.info.900` (Metadata diagnostic container) |

---

## 3. Dark Mode Semantic Color Mapping Matrix

This matrix establishes how semantic concepts query the abstract Dark Theme Palette. Components must **always** query the semantic tokens, which resolve dynamically under the Dark Theme.

```
+-----------------------------------------------------------+
| Component Token (e.g. card.ledger.bg)                     |
|                           |                               |
|                           v                               |
| Semantic Token  (bankyar.semantic.color.surface.default)  |
|                           |                               |
|                           v                               |
| Dark Theme Map  (bankyar.global.color.neutral.900)        |
+-----------------------------------------------------------+
```

| Semantic Token Name | Resolved Dark Primitive Token | Functional Design Intent |
| :--- | :--- | :--- |
| `bankyar.semantic.color.background.canvas` | `bankyar.global.color.neutral.950` | Default application window background canvas. |
| `bankyar.semantic.color.surface.default` | `bankyar.global.color.neutral.900` | Flat card container background for transactional cards. |
| `bankyar.semantic.color.surface.raised` | `bankyar.global.color.neutral.850` | Elevated containers: sticky app bars, bottom sheets. |
| `bankyar.semantic.color.surface.overlay` | `bankyar.global.color.neutral.800` | Popovers, modal dialog content, biometric screens. |
| `bankyar.semantic.color.text.primary` | `bankyar.global.color.neutral.50` | Maximum contrast typography: balances, section headers. |
| `bankyar.semantic.color.text.secondary` | `bankyar.global.color.neutral.200` | Standard readable copy: body text, ledger labels. |
| `bankyar.semantic.color.text.helper` | `bankyar.global.color.neutral.400` | Secondary metadata, dates, diagnostic timestamps. |
| `bankyar.semantic.color.text.disabled` | `bankyar.global.color.neutral.600` | Deactivated labels, inactive button copy. |
| `bankyar.semantic.color.border.subtle` | `bankyar.global.color.neutral.700` | Hairline list separators, card container boundaries. |
| `bankyar.semantic.color.border.active` | `bankyar.global.color.primary.300` | Focused input borders, keyboard focus rings. |
| `bankyar.semantic.color.interactive.fill` | `bankyar.global.color.primary.800` | Default primary button and high-attention chip fill. |
| `bankyar.semantic.color.interactive.text` | `bankyar.global.color.primary.100` | Typography inside interactive fills (contrast optimized). |
| `bankyar.semantic.color.tertiary.fill` | `bankyar.global.color.tertiary.800` | Tertiary category tracker fill (desaturated gold). |
| `bankyar.semantic.color.tertiary.text` | `bankyar.global.color.tertiary.100` | Typography inside tertiary containers. |
| `bankyar.semantic.color.inverse.surface` | `bankyar.global.color.neutral.100` | Reverse high-contrast canvas mapping (off-white silver). |
| `bankyar.semantic.color.inverse.text` | `bankyar.global.color.neutral.950` | Reverse high-contrast text mapping (obsidian gray). |
| `bankyar.semantic.color.inverse.primary` | `bankyar.global.color.primary.100` | Dynamic high-contrast link/accent indicator. |
| `bankyar.semantic.color.disabled.background`| `bankyar.global.color.neutral.850` | Deactivated card/button containers (flat, low contrast). |
| `bankyar.semantic.color.overlay.scrim` | `bankyar.global.color.neutral.950` | 60% opacity background backdrop overlay. |
| `bankyar.semantic.color.ripple.color` | `bankyar.global.color.neutral.50` (`8%` opacity) | Ripple ink color on interaction touches. |
| `bankyar.semantic.color.selection.fill` | `bankyar.global.color.primary.800` (`30%` opacity) | Background fill color of selected rows/chips. |
| `bankyar.semantic.color.selection.text` | `bankyar.global.color.primary.100` | Text color of selected interactive elements. |

---

## 4. Tonal Elevation, Depth, & Layering Architecture

Flat design in dark mode leads to severe cognitive disorientation, as users struggle to distinguish layout boundaries. Symmetrical drop shadows are virtually invisible against deep gray backgrounds.

To resolve this, BankYar uses **Material Design 3 Tonal Elevation overlays**. Instead of physical shadows, elevated surfaces dynamically overlay a semi-transparent white tint (represented as an opacity modifier on top of the base surface color) to simulate light exposure from above.

```
+-----------------------------------------------------------+
| Level 3: Overlay (Dialogs / Lock screen)                  |
| [Surface 800 + Opacity Tint Layer]                         |
|   +-----------------------------------------------------+  |
|   | Level 2: Raised (Sheets / AppBars)                  |  |
|   | [Surface 850 + Opacity Tint Layer]                   |  |
|   |   +-----------------------------------------------+  |  |
|   |   | Level 1: Default (Ledger Cards)               |  |  |
|   |   | [Surface 900]                                 |  |  |
|   |   +-----------------------------------------------+  |  |
|   +-----------------------------------------------------+  |
+-----------------------------------------------------------+
| Level 0: Canvas (Window Background) [Surface 950]         |
+-----------------------------------------------------------+
```

### 4.1 Elevation Overlay Rules Matrix
* **Level 0 (Canvas Background):**
  - Token: `bankyar.elevation.level.zero`
  - Mapping: `bankyar.semantic.color.background.canvas` (`neutral.950`)
  - Tint Overlay: `0%` Opacity
  - Boundaries: Hairline boundary on edge-to-edge screens.
* **Level 1 (Default Containers & Flat Cards):**
  - Token: `bankyar.elevation.level.one`
  - Mapping: `bankyar.semantic.color.surface.default` (`neutral.900`)
  - Tint Overlay: `2%` Semi-transparent white overlay (`0.02` opacity factor).
  - Boundaries: Bound with a thin border using `bankyar.semantic.color.border.subtle` (`neutral.700`) to guarantee contrast against Canvas.
* **Level 2 (Sticky Headers, AppBars, Bottom Sheets, Rails):**
  - Token: `bankyar.elevation.level.two`
  - Mapping: `bankyar.semantic.color.surface.raised` (`neutral.850`)
  - Tint Overlay: `6%` Semi-transparent white overlay (`0.06` opacity factor).
  - Boundaries: Distinct contrast edge; can cast a soft ambient shadow (`bankyar.semantic.color.shadow.ambient`) with high blur radius and very low opacity.
* **Level 3 (Modal Dialogs, Biometric Overlays, Quick Action Popups):**
  - Token: `bankyar.elevation.level.three`
  - Mapping: `bankyar.semantic.color.surface.overlay` (`neutral.800`)
  - Tint Overlay: `12%` Semi-transparent white overlay (`0.12` opacity factor).
  - Boundaries: Must be framed with a high-contrast boundary or active outline ring when focus is active.

---

## 5. Typography & Readability Hierarchy Rules

To maximize Persian (RTL) reading speed and eliminate halation and glare, typography in dark mode must follow strict contrast and spacing boundaries.

```
       Contrast Strategy:
       Primary Figures (Balances) -> Absolute White (950 contrast level: 12:1)
       Secondary Copy (Merchant)  -> Off-White Silver (800 contrast level: 7:1)
       Metadata (Timestamps)      -> Cool Steel Gray (400 contrast level: 4.5:1)
```

### 5.1 Contrast Boundaries Matrix
* **Display / Numerical Balances:**
  - Font Size: `bankyar.font.size.xxl` to `bankyar.font.size.xl`
  - Font Weight: `bankyar.font.weight.bold`
  - Color Token: `bankyar.semantic.color.text.primary` (`neutral.50`)
  - Reading Rule: Digital numbers must employ monospace scaling, formatted with standard digit separators.
* **Body / Merchant Names / Template Rules:**
  - Font Size: `bankyar.font.size.md`
  - Font Weight: `bankyar.font.weight.regular` to `bankyar.font.weight.medium`
  - Color Token: `bankyar.semantic.color.text.secondary` (`neutral.200`)
  - Reading Rule: Zero letter-spacing tracking must be applied to Persian text, ensuring baseline connection ligatures remain clean.
* **Metadata / Timestamps / Diagnostic Messages:**
  - Font Size: `bankyar.font.size.sm` to `bankyar.font.size.xs`
  - Font Weight: `bankyar.font.weight.regular`
  - Color Token: `bankyar.semantic.color.text.helper` (`neutral.400`)
  - Reading Rule: Text must wrap dynamically, meeting a minimum WCAG 2.2 AA contrast ratio of `4.5:1` against elevated card surfaces.

---

## 6. Universal Component-Specific Dark Themes

This section establishes the specific dark theme visual styling rules for all core application elements.

### 6.1 AppBar (Navigation Header)
* **Background Fill:** Mapped to Level 2 Raised Surface (`neutral.850`) when scrolled; blends into Canvas (`neutral.950`) when resting at top of container.
* **Divider Edge:** Thin hairline divider utilizing `bankyar.semantic.color.border.subtle` (`neutral.700`). No heavy drop shadows.
* **Typography & Actions:** Back chevron icon and screen title map to `bankyar.semantic.color.text.primary` (`neutral.50`), ensuring instant scanning.

### 6.2 Navigation Bar & Bottom Navigation
* **Container Fill:** Level 2 Raised Surface (`neutral.850`) to group elements physically above bottom of the device viewport.
* **Active Selector Shape:** Pill-shaped indicator utilizing `bankyar.global.color.primary.800` (desaturated cobalt) to avoid blinding halos.
* **Label & Icon States:**
  - Active Tab: Mapped to `bankyar.semantic.color.text.primary` (`neutral.50`).
  - Inactive Tab: Mapped to `bankyar.semantic.color.text.helper` (`neutral.400`) with unselected icon tracks.
* **RTL Mirroring:** Tab items array from right-to-left. Swipe gestural sweeps follow RTL direction.

### 6.3 Navigation Rail (Tablet / Foldable lateral navigation)
* **Container Fill:** Vertical column utilizing Level 1 Default Surface (`neutral.900`), providing subtle contrast against window background.
* **Dividers & Focus:** Active icon maps to primary cobalt indicator; unselected track remains steel gray (`neutral.400`). Sequential keyboard focus cycles vertically.

### 6.4 Cards (Transaction, Notification, Statistics, Security, Backup)
* **Transaction Card:** Mapped to Level 1 Surface (`neutral.900`). Highlighted with thin border (`neutral.700`). Transaction direction (Income/Expense) is dual-encoded (plus/minus sign, arrow icon, and desaturated status color).
* **Notification Card:** Soft informational slate background (`neutral.900`). Standard state-defining symbols (e.g. green circle for successful background capture) are paired with direct label alerts.
* **Statistics Card:** Elevated flat panel (`neutral.900`). Charts and balance ratios utilize high-contrast, text-equivalent lists located directly below the visual component.
* **Security & Backup Cards:** Heavy structural cards (`neutral.900`) showing clear state locks (e.g. padlock icons). Primary confirmations are positioned in comfortable reach of a single thumb at the bottom margin.

### 6.5 Dialogs & Bottom Sheets
* **Dialog Overlays:** Level 3 Surface (`neutral.800`). Screen background utilizes scrim overlay (`neutral.950` with `60%` opacity). Keyboard and screen reader focus must be locked entirely inside the dialog bounds.
* **Bottom Sheets:** Rounded top margins (defined by `radius.large`) using Level 2 Surface (`neutral.850`). Slide-in transition from bottom margin settles in the lower half to ensure comfortable one-handed reach.

### 6.6 Snackbars (Transient Notifications)
* **Container Fill:** High-contrast inverse surface (`neutral.50` off-white). This reverse theme guarantees that temporary alerts pop out against deep dark background canvases.
* **Text & Actions:** Typography maps to inverse text (`neutral.950` pure black), maintaining extreme contrast ratio of `12:1`.
* **Action Trigger:** Inline text button utilizing primary midnight azure, positioned on the end margin.

### 6.7 FAB (Floating Action Button)
* **Container Fill:** High-contrast brand primary azure (`bankyar.global.color.primary.500`).
* **Icon Labeling:** Linear open shape symbol (e.g., simple plus `+` icon) mapping to high-contrast white text (`neutral.50`).
* **Haptic feedback:** Short tactile confirmation on click events to verify action triggering.

### 6.8 Buttons (Filled, Tonal, Outlined, Text)
* **Filled Primary Button:** Background uses `bankyar.semantic.color.interactive.fill` (`primary.800`); text uses `bankyar.semantic.color.interactive.text` (`primary.100`). Pressed state shifts to midnight sapphire (`primary.950`).
* **Tonal Secondary Button:** Background uses level 2 container gray (`neutral.800`); text uses secondary gray (`neutral.100`).
* **Outlined Button:** Border outline uses `bankyar.semantic.color.border.subtle` (`neutral.700`); text uses brand primary cobalt (`primary.300`).
* **Text Button:** No background fill. Icon and text label map to brand primary azure (`primary.300`). Under pressed state, applies a very soft `8%` white opacity highlight.

### 6.9 Text Fields & Dropdowns
* **Input Container:** Mapped to deep slate gray (`neutral.900`). Filled style is preferred in dark mode to provide a clear interactive target area.
* **Active Focus Outline:** Thick boundary outline specified by `bankyar.border.width.thick` mapping to `bankyar.semantic.color.border.active` (`primary.300`).
* **Dropdown Selection Sheets:** Options expand as standard bottom sheets or vertical popup menus utilizing Level 2 Surface (`neutral.850`), with active items highlighted using a low-saturation tint overlay.

### 6.10 Search Bar
* **Container Fill:** Rounded container (`radius.full`) mapping to Level 1 Surface (`neutral.900`).
* **Dismiss Trigger:** A persistent clear icon button (`neutral.400`) resides at the end margin, allowing the user to reset search results in a single tap.
* **Search Results Feed:** Results render immediately beneath the search input in structured lists, separated by hairline dividers (`neutral.700`).

### 6.11 Lists (Chronological Transaction Ledger)
* **Scrolling Container:** The list canvas uses the base Canvas color (`neutral.950`) to keep the scrolling workspace completely clean and non-reflective.
* **Item Dividers:** List items (transaction cards) are separated vertically by a physical spatial gap bound to `bankyar.space.sm`, stacked with a hairline divider (`neutral.700`) mapping to `bankyar.semantic.color.border.subtle`.
* **Zero Swipe Regressions:** Horizontal swipe actions are entirely locked during vertical scrolling to avoid mis-taps. Editing/deleting template items or category allocations require an explicit context menu tap or bottom sheet trigger.

### 6.12 Settings View & Preferences Screen
* **Menu Background:** Grouped menu items are encapsulated inside flat card segments mapping to Level 1 Surface (`neutral.900`) against the background Canvas (`neutral.950`).
* **Item Row Layout:** Every row displays a left/start-aligned linear metadata indicator or action chevron (`neutral.400`), and a right/end-aligned primary Persian text label (`neutral.50`).
* **Switches & Adjustments:** Settings switches (e.g., toggling background SMS parsing or Dark Mode) utilize a desaturated Primary accent slider (`primary.300`), which turns deep slate-gray (`neutral.800`) when switched off, satisfying clear accessibility constraints.

---

## 7. Transaction State & Category Semantic Colors

To support rapid scanning of ledger feeds without creating visual noise, transaction types and statuses are represented by soft, desaturated pastels that meet WCAG AA requirements (`4.5:1` minimum contrast) against card surfaces.

```
       RTL Financial List Item Layout:
       [Date/Timestamp] <------- [Counterparty Name] <------- [+120,000 IRR (Success Green)]
```

### 7.1 Transaction Types Mapping Matrix
* **Income (Credit):**
  - Text Color Token: `bankyar.global.color.success.300` (Soft pastel emerald).
  - Background Badge: `bankyar.global.color.success.900` (`20%` opacity).
  - Secondary Cue: Prepended plus symbol `+` and upward directional arrow icon `↑`.
* **Expense (Debit):**
  - Text Color Token: `bankyar.global.color.error.300` (Soft pastel crimson).
  - Background Badge: `bankyar.global.color.error.900` (`20%` opacity).
  - Secondary Cue: Prepended minus symbol `-` and downward directional arrow icon `↓`.
* **Transfer (Internal):**
  - Text Color Token: `bankyar.global.color.neutral.100` (Off-white silver).
  - Background Badge: `bankyar.global.color.neutral.700` (`20%` opacity).
  - Secondary Cue: Bidirectional horizontal arrow icon `⇄`.
* **Purchase / ATM Cash:**
  - Text Color Token: `bankyar.global.color.info.300` (Pastel blue-indigo).
  - Background Badge: `bankyar.global.color.info.900` (`20%` opacity).
  - Secondary Cue: Specific card payment or ATM terminal symbols.
* **Refund / Chargeback:**
  - Text Color Token: `bankyar.global.color.success.100` (Soft pastel mint).
  - Background Badge: `bankyar.global.color.success.800` (`30%` opacity).
  - Secondary Cue: Return curved arrow icon `↫` with descriptive tags.

### 7.2 Transaction Operational States
* **Pending / Scheduled:**
  - Text Color Token: `bankyar.global.color.warning.300` (Soft pastel amber).
  - Secondary Cue: Exclamation warning icon `⚠️` with "بررسی نهایی" (Heuristic Validation Pending) text badge.
* **Failed / Blocked:**
  - Text Color Token: `bankyar.global.color.error.300` (Soft pastel crimson).
  - Secondary Cue: Prohibited shield symbol with "پرداخت ناموفق" (Failed Payment) alert tag.
* **Unknown / Unparsed Sender:**
  - Text Color Token: `bankyar.global.color.neutral.400` (Cool steel gray).
  - Secondary Cue: Interrogation question symbol `?` with raw unparsed sender string displayed.

---

## 8. Financial Chart & Data Visualization Palettes

Charts in dark mode are highly simplified. We completely prohibit neon glowing lines, heavy gradient areas, and 3D bar shapes, which create severe visual noise on dark canvases.

```
       Donut Chart Separation:
            +-------+
          /   ***     \     * = Income Slice (Success Green 300)
         |  ** | ...   |    | = Symmetrical Divider (Canvas 950 Divider Gap)
         |  ** | ...   |    . = Expense Slice (Error Crimson 300)
          \   ###     /
            +-------+
```

### 8.1 Chart-Specific Palette Schemes
* **Pie & Donut Charts (Category Allocations):**
  - Slices are mapped to distinct, desaturated status steps: Success `300` (Green), Error `300` (Red), Info `300` (Blue), Warning `300` (Amber), and Primary `300` (Azure).
  - **Symmetrical Divider Gap:** Adjacent slices must be separated by a physical border stroke mapped to the background canvas (`neutral.950`), preventing visual bleeding of adjacent colors.
* **Bar Charts (Monthly Inflow vs Outflow):**
  - Incomes are rendered as flat vertical blocks using desaturated Green (`success.300`); Expenses use desaturated Crimson (`error.300`).
  - Gridlines utilize hairline steel dividers (`neutral.700`), keeping the focus on the data column values.
* **Line & Area Charts (Net Cash Trends):**
  - Trend lines utilize brand primary cobalt (`primary.300`) with a thin, solid stroke width.
  - Area fills beneath the line are restricted to a very light, soft opacity overlay (`5%` factor) of the primary color, avoiding screen glare.
* **Statistics & Trend Indicators:**
  - Percentage growth indicators must include mathematical signs (e.g. `+12.4%` or `-3.2%`) next to semantic success/error text tokens.

---

## 9. Accessibility, Contrast, & Color-Blind Validation

universal financial usability is a core release blocker. The BankYar Dark Theme has been strictly validated against Web Content Accessibility Guidelines (WCAG 2.2) AA and AAA standards.

### 9.1 Accessibility Mapping & Performance Matrix
* **WCAG 2.2 AA Contrast Compliance:**
  - Standard body text, secondary transaction details, and input labels must maintain a minimum contrast ratio of `4.5:1` against elevated card backgrounds (`neutral.900`).
  - Large numerical balances, section titles, and action triggers must exceed a contrast ratio of `3:1` against their backgrounds.
* **WCAG 2.2 AAA Contrast Compliance (High Contrast Mode):**
  - When the user activates High Contrast Mode inside Settings, the dark theme dynamically remaps its Canvas to absolute pure black (`#000000`) and elevated cards to deep charcoal (`#121212`), with all typography elevated to absolute white (`#FFFFFF`), achieving a contrast ratio of `16:1`.
* **Universal Color-Blind Protection:**
  - Meaning is **never conveyed solely by color**. If a transaction amount turns red, a minus sign `-` and downward arrow icon `↓` must be prepended. If an input field displays an validation error, a warning icon `⚠️` and a permanent visible text descriptor must align directly beneath the container.

---

## 10. Material You Dynamic Color Integration

BankYar natively supports Android 12+ Material You Dynamic Color extraction, allowing the interface to adapt beautifully to the user's active device wallpaper while maintaining strict financial safety.

```
+-----------------------------------------------------------+
| Android User Wallpaper Accent (System Palette Seed)      |
|                           |                               |
|                           v                               |
| Dynamic Color Engine resolves:                            |
| - Primary seed => bankyar.global.color.primary            |
| - Neutral seed => bankyar.global.color.neutral            |
|                           |                               |
|                           v                               |
| Strict Security Sanitizer Overrides:                      |
| - Force-locks success.300 (Green) to Emerald Scale        |
| - Force-locks error.300 (Red) to Crimson Scale          |
+-----------------------------------------------------------+
```

### 10.1 Dynamic Harmonization Rules
1. **Dynamic Brand Seed Extraction:** The core brand primary scale (`bankyar.global.color.primary.*`) and base neutrals (`bankyar.global.color.neutral.*`) can be dynamically generated from the user's system wallpaper seed, ensuring beautiful visual integration with the Android system.
2. **Strict Security Sanitizer Override:** The semantic status scales (Success, Warning, Error) **must remain completely isolated from dynamic wallpaper seeds**. This prevents a red-saturated wallpaper from turning critical parsing failure errors or credit/debit indicators into dynamic orange or pink tints, preserving clear system state indicators.
3. **Harmonized Accents:** Subtle inline highlights (such as selected tag chips and custom category markers) can apply a dynamically harmonized pastel tint to blend cleanly with active device accent colors.

---

## 11. Future-Ready Adaptations (Multi-Device Targets)

The Dark Theme Specification is designed to scale natively across diverse device form factors, ensuring complete layout stability.

### 11.1 Multi-Device Dark Specifications
* **Tablet & Landscape views:**
  - Uses master-detail dual columns. The left lateral navigation rail utilizes Level 1 Surface (`neutral.900`), and the scrollable transactional feed uses Canvas (`neutral.950`).
  - Content details expand as a flat, stable right-side panel, preventing intrusive popups.
* **Foldables (Dual-screen states):**
  - When unfolded, the layout grid splits dynamically. Structural sheets utilize Level 2 Raised Surface (`neutral.850`) across the fold axis to maintain clear visual separation.
* **Wear OS (Smartwatch):**
  - The watch face uses absolute pure black (`#000000`) to maximize OLED battery life. Circular cards utilize Level 1 Surface (`neutral.900`) with generous physical touch targets.
* **Automotive Views (CarPlay / Android Auto):**
  - Visual density shifts to high-contrast comfortable scales. Text sizes are enlarged, and all secondary metadata descriptions are hidden, prioritizing large, actionable elements to prevent driver distraction.

---

## 12. Anti-Patterns, Validation, & Governance Checklist

To maintain visual purity and prevent the accumulation of "visual debt" during future features development, all dark theme implementations must comply with these design rules.

### 12.1 Prohibited Visual Anti-Patterns
* **The "Pure-Black halation" Anti-Pattern:** Pairing pure black backgrounds (`#000000`) with absolute pure white text (`#FFFFFF`) for standard reading copy. This creates visual fatigue and severe pixel smearing during scrolling.
* **The "Color-Only status" Anti-Pattern:** Representing cash flow direction or input errors using colored text alone, without adding mathematical signs, descriptive tags, or icons.
* **The "Glowing shadows" Anti-Pattern:** Using colorful, neon, or glowing box shadows around card elements. Depth must be simulated strictly using tonal overlays and borders.
* **The "Backlight bleed" Anti-Pattern:** Using saturated primary colors or medium-gray backgrounds for large canvas areas. Large regions must remain deep neutral charcoal (`neutral.950`).

### 12.2 Automated Compliance Validator Rules
Before committing any changes to the dark theme stylesheets, compilers must verify the following checks:

- [ ] **No Hardcoded Hex Values:** All colors must reference active, validated token paths (e.g., `bankyar.semantic.color.background.canvas`).
- [ ] **No Physical Spacing Units:** Sizing, paddings, and margins must be declared logically and reference active spacing tokens.
- [ ] **WCAG AA Compliance Verification:** Automated scans must verify that text-to-background contrast mappings maintain a minimum ratio of `4.5:1`.
- [ ] **Persian RTL Logic Check:** Directional properties must use logical layout parameters (`start`, `end`) rather than physical coordinates (`left`, `right`).

---
**End of Document**
