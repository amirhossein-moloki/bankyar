# BankYar Search & Advanced Filter Screen Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Framework Target:** Flutter (Code-Agnostic Design Blueprint)
**Platform Target:** Android (RTL-Native Layout)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Status:** Approved / Core Specification Blueprint

---

## 1. Executive Summary

This document establishes the absolute visual, spatial, and interaction specification for the **Search & Advanced Filter Experience** in the BankYar ecosystem. Designed to help users locate transactions, notes, and financial records instantly across thousands of secure on-device entries, this experience operates under an uncompromising **offline-first, zero-network privacy constraint**.

By transforming high-volume financial logs into a highly discoverable, blazing-fast, and premium search ledger, this design eliminates financial navigation friction. In strict compliance with BankYar’s Level 0 Engineering and Visual Design Constitutions:
- **Zero Framework Code:** All layouts, interactions, and component structures are platform-independent, with zero Flutter/Dart implementation details.
- **Zero Raw Styling Metrics:** Hardcoded dimensions (pixels, dp, sp) are strictly prohibited. All dimensions and spatial gaps map directly to abstract design tokens.
- **Zero Hardcoded Colors:** No raw hex color strings are allowed. Every visual surface, state indicator, and typography layer references semantic tokens that adapt dynamically between Light, Dark, and High-Contrast modes.
- **RTL-First Structure:** Horizontal reading paths, vertical grids, gesture swipes, and transition vectors mirror natively to support Persian RTL workflows from the logical start edge (right) to the logical end edge (left).

---

## 2. Design Philosophy & Vision

The BankYar Search and Filter system is engineered to reduce financial searching anxiety, replacing standard, confusing search inputs with an active, reassuring, and premium financial command center.

* **Speed and Responsiveness:** In an offline-only architecture, latency must feel non-existent. Queries on local SQLCipher vaults execute instantly, supported by debounced inputs and transition effects that resolve visual weight within 100 milliseconds.
* **Stoic, Precise, and Empowering Aesthetic:** Following `DESIGN_PHILOSOPHY.md`, the visual canvas is calm and uncluttered. It employs a professional Material Design 3 8-unit proportional grid, comfortable white space, flat containers, and rounded cards to emphasize clear numerical readability.
* **Universal Discoverability:** Advanced searching is simplified. Complex parameters (such as bank sources, date ranges, and custom amounts) are grouped logically into progressive layers—from immediate Horizontal Quick Filter Chips to a structured Advanced Bottom Sheet—enabling effortless one-handed reach and operation.
* **Privacy-First Visibility:** Since the app runs 100% on-device, search indexing, recent histories, and custom query saves remain fully local and cryptographically locked, with zero external tracking or cloud sync.

---

## 3. Grid Architecture & Spatial Principles

The Search & Filter interface conforms to the BankYar dynamic layout system, ensuring spatial stability and clean scanning lines across all device sizes.

### 3.1 Horizontal Grid System
* **Compact Phone Viewport:** 4 columns. Symmetrical outer margins are mapped to `bankyar.responsive.margin` (resolving to `bankyar.space.lg` on mobile). Gutters are bound to `bankyar.responsive.gutter` (`bankyar.space.md`).
* **Medium Tablet / Foldable Viewport:** 8 columns. Master-detail horizontal splitting. Margin is scaled up to `bankyar.space.xl` and gutters to `bankyar.space.lg`.
* **Expanded Viewport (Tablet / Landscape):** 12 columns. Restrained to `bankyar.responsive.container.width.max` to prevent wide, unreadable lines.

### 3.2 Vertical Baseline Rhythm
* **Base Spatial Multiplier:** All component heights, row gaps, internal margins, and text leadings are integer multiples of the base multiplier `bankyar.global.space.base`.
* **Spatial Gaps Scale:**
  - `bankyar.space.xxs` (0.25x base unit, for subtle badges and status indicators)
  - `bankyar.space.xs` (0.5x base unit, for tight inline spacings and label offsets)
  - `bankyar.space.sm` (1x base unit, for field labels and minor component gaps)
  - `bankyar.space.md` (2x base unit, for default internal card padding)
  - `bankyar.space.lg` (3x base unit, for external card gaps and screen margins)
  - `bankyar.space.xl` (4x base unit, for bottom navigation offsets and sticky actions)
  - `bankyar.space.xxl` (6x base unit, for empty state illustrations and large offsets)

---

## 4. Screen Layout Structure & Layout Zones

The Search page is constructed using the logical three-zone vertical layout model, isolating navigation, scrolling content, and persistent quick actions.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY SEARCH HEADER & FILTER BAR]                            |
|  +-------------------------------------------------------------------+  |
|  | [Voice Target]  [Persistent Search Input Box]  [Back Chevron Arrow] |  |
|  | [Advanced Filter Btn]  [Scrollable RTL Quick Filter Chips Row]      |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE SEARCH CONTENT WORKSPACE]                         |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Context 1: Empty Search (Recent Searches, Saved Searches)]      |  |
|  |                                                                   |  |
|  |  [Context 2: Suggestion / Typing Overlay]                         |  |
|  |                                                                   |  |
|  |  [Context 3: Results Feed (Results Counter, Matched Ledger List)]  |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY SYSTEM NAVIGATION & OFFLINE CONTROL]                   |
|  +-------------------------------------------------------------------+  |
|  | [Offline Security Diagnostics Badge]                               |  |
|  | [Persistent Bottom Navigation Bar]                                |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## 5. Screen Regions & Spatial Scaffolding

### 5.1 Region 1: Top Search App Bar (Zone A - Sticky Header)
* **Visual Presentation:** Remains strictly pinned to the top of the screen during scrolling content shifts. Its background blends with the canvas background in its idle state, displaying a thin dividing boundary line `bankyar.semantic.color.border.subtle` once lists scroll underneath.
* **Horizontal Flow (RTL):**
  - **Logical Start Edge (Right):** Native back chevron arrow `bankyar.icon.back.rtl` directing the user back to the Home Dashboard view.
  - **Center Block:** Container textfield representing the persistent Search Field. It expands horizontally, maintaining symmetrical margins bound to `bankyar.responsive.margin`.
  - **Logical End Edge (Left):** Contextual clear query icon button when text is entered, and the future-ready Voice Search temporary icon.

### 5.2 Region 2: Horizontal Quick Filter Row (Zone A - Under Search Box)
* **Visual Presentation:** A horizontally scrollable row of choice selection chips positioned directly beneath the search input container. Its scrolling direction flows from right to left (RTL).
* **RTL Composition:**
  - **Logical Start Edge (Right):** Pinned "Advanced Filter" trigger button styled with a trailing tuning icon and a divider vertical rule.
  - **Linear List:** Quick chips flowing in order of popularity: "All Inflows" (ورودی‌ها), "All Outflows" (خروجی‌ها), "Favorites" (علاقه‌مندی‌ها), "Has Notes" (یادداشت‌دار), "Last 7 Days" (۷ روز اخیر).
  - **Scrolling Behavior:** Fades smoothly into the logical end (left) edge using a translucent gradient overlay.

### 5.3 Region 3: Results Counter & Sort Trigger Row (Zone B - Top of Feed)
* **Visual Presentation:** Standard horizontal text row that precedes result card listings. Separated from the quick chips row by `bankyar.space.md`.
* **RTL Layout Flow:**
  - **Logical Start Edge (Right):** Results Counter displaying "تعداد نتایج: ۲۴ تراکنش" (Result count: 24 transactions) in monospace numeric formatting using `bankyar.semantic.typography.monospace.standard`.
  - **Logical End Edge (Left):** Sort option selector dropdown trigger displaying the active sort key (e.g. "جدیدترین‌ها" - Newest First) with a leading sort directional icon.

### 5.4 Region 4: Scrollable Search Content Workspace (Zone B - Scrollable)
* **Visual Presentation:** Dynamic vertically scrollable viewport containing different layout contexts depending on the search stage:
  - **Stage A: Empty Search View:** Pre-typing screen showing recent queries, saved searches, and helpful configuration tips.
  - **Stage B: Typing Suggestion Screen:** Interactive real-time completion overlays that guide text entry.
  - **Stage C: Active Results Ledger:** Grouped list cards presenting matched transactions, notes, and references.
  - **Stage D: No Results State:** Specialized illustration panel explaining query misses.

### 5.5 Region 5: Persistent Control & System Diagnostics (Zone C - Sticky Footer)
* **Visual Presentation:** Remains pinned to the bottom of the screen.
* **Core Composition:**
  - **Offline Security Indicator:** Low-contrast centered label "آفلاین و امن - رمزنگاری شده در دستگاه" (Offline & Secure - Encrypted on device) demonstrating 100% on-device cryptography.
  - **Shell Bottom Navigation Bar:** Symmetrical 4-tab bar (Ledger, Analytics, Rules, Settings) distributing focus to help users coordinate system flows.

---

## 6. Detailed Component Specifications

### 6.1 Persistent Search Input Field
* **Purpose:** Primary query box capturing user text strings.
* **Layout Sizing:** Spans full horizontal column width, with height bound to `bankyar.space.xl` to ensure a touch target height of at least 48 dynamic units.
* **Curvature:** Mapped to `bankyar.radius.full` (completely rounded) to establish high-fidelity Material Design 3 style.
* **Internal RTL Elements:**
  - **Start (Right):** Leading search icon `bankyar.icon.search` to signal query intent.
  - **Text Field:** RTL-aligned text input using primary text color token `bankyar.semantic.color.text.primary` and body typography `bankyar.semantic.typography.body.md`.
  - **End (Left):** Voice Search temporary icon `bankyar.icon.voice` (idle state) which transforms into a Clear Search cross icon button `bankyar.icon.clear` as soon as typing begins.
* **Interactive Borders:** Idle state utilizes thin outline boundary `bankyar.semantic.color.border.subtle`. Active focused state shifts instantly to thicker boundary `bankyar.border.width.thick` colored with primary brand accent `bankyar.semantic.color.border.active`.

### 6.2 Quick Filter Chips
* **Purpose:** Provides instantaneous, one-tap scoping of transaction queries directly on the main feed.
* **Height:** Bound to `bankyar.space.lg` to guarantee standard tap touch areas.
* **Curvature:** Mapped to `bankyar.radius.md` to distinguish chips visually from rounded cards.
* **States & Design Tokens:**
  - **Active Selected State:** Background container is filled with primary accent `bankyar.semantic.color.interactive.default` and white contrast text. A leading checkmark icon `bankyar.icon.checkmark` animates into view on the right edge.
  - **Inactive Unselected State:** Container uses transparent background with thin outline `bankyar.semantic.color.border.subtle`. Text uses secondary readable token `bankyar.semantic.color.text.secondary`.
* **Micro-interactions:** Tapping a chip triggers an instant on-device filtering query in the local SQLite database.

### 6.3 Advanced Filter Button
* **Purpose:** Triggers the comprehensive Bottom Filter Sheet for deep, structured querying.
* **Layout Sizing:** Positioned strictly on the logical start (right) of the Horizontal Quick Filter row, separated by a vertical separator hairline `bankyar.border.width.thin`.
* **Visual Style:** Flat circular container utilizing `bankyar.radius.full` and subtle surface elevation `bankyar.elevation.level.one`. Shows a professional MD3 tuning icon.
* **Touch Target:** Invisible touch envelope scales outer dimensions to meet minimum 48 x 48 target bounds.

### 6.4 Results Counter
* **Purpose:** Reports the exact volume of current matches to keep the user oriented.
* **Typography:** Bold Persian monospace characters via `bankyar.semantic.typography.monospace.standard` and small text size `bankyar.font.size.xs`.
* **Spacing:** Inset horizontally by `bankyar.responsive.margin` to align with the chronological transaction card borders.

### 6.5 Transaction Results List Card
* **Purpose:** Primary item card presenting matched transaction metadata.
* **Curvature & Outlines:** Curvature mapped to `bankyar.radius.lg` with thin boundary borders `bankyar.semantic.color.border.subtle`.
* **Internal Spatial Grid & Fields (RTL Flow):**
  ```
  +--------------------------------------------------------------------------+
  | (Right Edge)                                                (Left Edge)  |
  | [Bank Logo Avatar]  Bank Name (Melli / Mellat)      Matched Cash Amount  |
  |                     Transaction Type Indicator      and Currency Label   |
  |                                                                          |
  |  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  |
  |                                                                          |
  | [Security Icon] [Note Icon]  Date & Time Stamps      [Favorite Star Icon] |
  +--------------------------------------------------------------------------+
  ```
  1. **Bank Logo Avatar:** Medium circular frame `bankyar.radius.full` positioned on the right (start) edge. Displays flat monochromatic bank symbols. Size matches `bankyar.icon.size.md`.
  2. **Bank Name & Type Title:** Aligned adjacent to bank avatar. Persian text (e.g. "بانک ملی ایران") in bold title font `bankyar.semantic.typography.title.sm`. Directly underneath, the cash type indicator displays (e.g. "خرید پایانه", "کارت به کارت").
  3. **Matched Cash Amount:** Large, bold numeric text positioned on the left (end) edge of the top row.
     - **Inflow (Credit):** Mapped with positive sign `+` (e.g. "+۱۲۵,۰۰۰") in green success text `bankyar.semantic.color.status.success`.
     - **Outflow (Debit):** Mapped with negative sign `-` (e.g. "-۴۵,۰۰۰") in standard primary text `bankyar.semantic.color.text.primary`.
  4. **Monospace Currency Label:** Persian text "تومان" (Toman) or "ریال" (Rial) positioned next to or directly below the amount.
  5. **Inner Divider:** Dashed border `bankyar.border.style.dashed` separating top info from bottom indicators.
  6. **Security Shield Padlock Icon:** Positioned at the bottom start (right) corner to reassure the user of local security.
  7. **User Note Indicator:** A custom notebook icon displayed next to the padlock icon if notes are written. Tapping this launches the Note Editor sheet.
  8. **Date and Time Stamps:** Centered in the bottom row. Uses monospace numerals (e.g., "۱۴۰۲/۱۰/۱۲ - ۱۴:۳۲") in secondary text color `bankyar.semantic.color.text.secondary`.
  9. **Favorite Indicator:** A filled star icon `bankyar.icon.star` positioned at the bottom-left (end) corner. Shows in active gold tint if transaction is starred, and outline grey if unstarred.

### 6.6 Search Match Highlight Component
* **Purpose:** Provides immediate visual feedback indicating **why** a transaction card was returned.
* **Visual Execution:** Matching characters inside notes, transaction names, or bank references are highlighted using high-contrast, low-saturation yellow background tint.
* **Typography:** Bold character weights apply to matched text, keeping reading lines clear and accessible.

---

## 7. Advanced Bottom Filter Sheet Specification

To preserve physical comfort, advanced filtering is handled via a modal sheet expanding upwards from Zone C. This sheet restricts its maximum vertical coverage to 75% of active viewport heights, utilizing standard scrollbars.

```
+-------------------------------------------------------------------------+
| Bottom Sheet Header Container Zone C Slide Up                           |
|                   === [ Drag Handle bar ] ===                            |
|                                                                         |
|  [Close Drawer Button]    { Advanced Filters Title }     [Reset All Actions]|
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
| Scrollable Filtering Grid Workspace                                      |
|                                                                         |
|  [1. Bank Source Grid]                                                  |
|     (X) Bank Melli      ( ) Bank Mellat     ( ) Bank Saderat            |
|                                                                         |
|  [2. Transaction Flow Selection]                                        |
|     [Income Chip]    [Expense Chip]   [Purchase Chip]    [ATM Chip]     |
|     [Transfer Chip]  [Cash Withdrawal Chip]                             |
|                                                                         |
|  [3. Custom Date Range Options]                                         |
|     [Start Hijri Date Selector Input]  <->  [End Hijri Date Selector]   |
|                                                                         |
|  [4. Secure Amount Boundaries Slider & Monospace Inputs]                |
|     Min: [  10,000 Toman ]  <====== Slider ======>  Max: [ 5,000,000 ]  |
|                                                                         |
|  [5. Financial Metadata Filters]                                        |
|     [ ] Favorites Only  [ ] Has Custom Notes  [ ] No Custom Notes       |
|     [ ] Verified (Local SMS Source)   [ ] Heuristic (Warning Status)     |
|                                                                         |
+-------------------------------------------------------------------------+
| Sticky Operational Footer Container                                      |
|                                                                         |
|  [ Apply Search Filter (Filled Button) ]  -  [ Cancel (Bordered Btn) ]  |
+-------------------------------------------------------------------------+
```

### 7.1 Drag Handle Bar
* **Visual Style:** Rounded capsule bar centered horizontally at the top sheet edge. curvs are bound to `bankyar.radius.full` and colored in light-gray outline. Signals downward gestural swipe dismissals.

### 7.2 Sheet Header Actions
* **RTL Composition:**
  - **Logical Start Edge (Right):** "انصراف" (Cancel/Close) icon button `bankyar.icon.close` to abort sheet inputs without state mutation.
  - **Center:** Title "فیلترهای پیشرفته" (Advanced Filters) styled with bold subtitle typography `bankyar.semantic.typography.title.sm`.
  - **Logical End Edge (Left):** Action text "پاک کردن همه" (Clear All) in secondary text, letting users reset filter fields in a single tap.

### 7.3 Filter Group 1: Bank Selector
* **Purpose:** Restricts search to specific card issuers.
* **Visual Grid:** Responsive double-column grid of radio selection buttons inside a flat card surface.
* **Options:** "بانک ملی ایران" (Melli Bank), "بانک ملت" (Mellat Bank), "بانک تجارت" (Tejarat Bank), "بانک صادرات" (Saderat Bank), "سایر بانک‌ها" (Other banks).

### 7.4 Filter Group 2: Transaction Type
* **Purpose:** Restricts query to active cashflow classes.
* **Layout Sizing:** Horizontally wrapping row of choice chips with standard spaces `bankyar.space.xs`.
* **Options:**
  - **Income (درآمد):** Credit events. Mapped with success green outlines.
  - **Expense (هزینه):** Debit events. Mapped with standard red outlines.
  - **Purchase (خرید فروشگاهی):** Matched store purchases.
  - **Transfer (کارت به کارت):** P2P transfer events.
  - **Cash Withdrawal (برداشت وجه):** Cash extractions.
  - **ATM (خودپرداز):** Physical machine interactions.

### 7.5 Filter Group 3: Custom Date Range Selector
* **Purpose:** Scopes transactions to a custom chronological interval.
* **Visual Layout:** Double-column row of input textfields styled with calendar icons.
* **Options:**
  - **Start Date Input:** Solar Hijri calendar picker (e.g. "۱۴۰۲/۱۰/۰۱").
  - **End Date Input:** Solar Hijri calendar picker (e.g. "۱۴۰۲/۱۰/۳۰").
* **Behavior:** Tapping a field opens an on-screen Shamsi month calendar selector modal.

### 7.6 Filter Group 4: Custom Amount Boundaries
* **Purpose:** Restricts search to precise transaction values.
* **Visual Components:** Dual slider controls accompanied by companion monospace textboxes.
  - **Min Amount Field:** Captures lower bound (e.g., "۱۰,۰۰۰ تومان"). Uses `bankyar.semantic.typography.monospace.standard`.
  - **Max Amount Field:** Captures upper bound (e.g., "۵,۰۰۰,۰۰۰ تومان").
  - **Currency Selector:** Dropdown menu showing "تومان" (Toman) and "ریال" (Rial).

### 7.7 Filter Group 5: Annotation & Security Status
* **Purpose:** Advanced searching based on ledger attributes.
* **Visual Layout:** List of checkboxes aligned to the right (logical start).
* **Options:**
  - **Favorites:** Starred items only.
  - **Has Notes:** Transactions containing user comments.
  - **No Notes:** Transactions without annotations.
  - **Verified SMS Source:** High-confidence decrypted SMS texts.
  - **Heuristic Warning:** Unverified parser guesses requiring review.

### 7.8 Filter Group 6: Future Infrastructure Slots
* **Purpose:** Preallocated slots reserved for upcoming capabilities.
* **Visual Layout:** Hidden or dashed outlines indicating "Tags" (دسته‌ب بندی‌ها) and "AI Smart Categories" (دسته‌بندی هوش مصنوعی) to preserve layout scalability without shifting components.

### 7.9 Sticky Operational Footer Row
* **Purpose:** Confirms or discards advanced filtering settings.
* **RTL Layout Flow:**
  - **Logical Start Edge (Right):** Primary prominent filled button "اعمال فیلتر" (Apply Filters), displaying the active criteria count (e.g., "اعمال فیلتر (۳ فیلتر)").
  - **Logical End Edge (Left):** Bordered button "لغو" (Cancel).
* **Touch Target:** Sized to full touch envelope width for easy thumb interaction.

---

## 8. Sorting Menu Specifications

* **Purpose:** Reorders matching records.
* **Trigger:** Text dropdown link inline with Results Counter in Region 3.
* **Visual Layout:** Small flat dropdown card popping up underneath the trigger. Sized to comfortable container boundaries.
* **Supported Options (Ordered Scale):**
  1. **Newest First (جدیدترین‌ها):** Chronological descending order (default).
  2. **Oldest First (قدیمی‌ترین‌ها):** Chronological ascending order.
  3. **Highest Amount (بیشترین مبلغ):** Numerical descending.
  4. **Lowest Amount (کمترین مبلغ):** Numerical ascending.
  5. **Alphabetical - Merchant (الفبا - پذیرنده):** Alphabetical order of matched merchants.
  6. **Bank Name (نام بانک):** Alphabetical grouping of financial sources.
  7. **Most Recent Update (آخرین بروزرسانی):** Sorts based on last local modification timestamp.

---

## 9. Search Experience & Intelligent Retrieval

To deliver an instantaneous, smart retrieval experience, the search engine utilizes several local heuristics:

### 9.1 Instant & Incremental Search
Queries are processed instantly on each keystroke. Results are calculated on the secure local SQLite database using fast indices, updating the active ledger list in real-time.

### 9.2 Debounced Inputs
Typing inputs are debounced by 200 milliseconds (`bankyar.motion.duration.fast`). This prevents unnecessary database queries during rapid text input, keeping the rendering thread highly responsive.

### 9.3 Suggestion Ranking & History
When the search input field is focused but empty, Region 4 displays:
* **Recent Searches (تاریخچه جستجو):** List of 5 most recent queries with a leading clock icon and a trailing clear button. Ranked based on chronological selection.
* **Saved Searches (جستجوهای ذخیره‌شده):** Quick links to frequently used filters (e.g. "خریدهای بالای ۱۰۰ هزار تومان بانک ملی") with a leading star icon.
* **Search Suggestions (پیشنهادات هوشمند):** Smart suggestions that adapt based on frequent terms (e.g., "اسنپ", "قبض آب").

### 9.4 Search Recovery
If the app process is closed or backgrounded during an active search, the state manager caches the active query string and filters. On return, the search results are restored instantly to prevent lost progress.

---

## 10. Interactive States Visual Mapping

The Search and Filter interface adapts its visual layers dynamically based on system states:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed | Accessibility Action |
| :--- | :--- | :--- | :--- |
| **Default (Idle)** | Persistent search field centered with label text "جستجو در تراکنش‌ها، یادداشت‌ها...". Recent search list displayed below. | Instant transition | TalkBack announces: *"جستجو، کادر ویرایش. برای شروع نوشتن ضربه بزنید."* |
| **Typing** | Displays close cross icon in search input. Typing completion suggestions overlay the workspace. | Fast easing `bankyar.motion.curve.decelerate` | Read suggestions sequentially on Tab sweeps. |
| **Searching** | Small, non-intrusive circular progress ring spinning on the left edge of the input container. | Smooth continuous animation | Screen reader verbalizes: *"در حال جستجوی تراکنش‌ها..."* |
| **Loading Search** | Visual skeleton blocks replace ledger cards, shimmering smoothly from right to left (RTL). | Linear opacity loop | Screen reader announces: *"در حال بارگذاری نتایج تراکنش‌ها."* |
| **Empty Search View**| Standard default layout presenting Recent and Saved search blocks. | Smooth fade-in | Focuses automatically on the first Recent Search chip. |
| **No Results View** | Displays an illustration of an empty magnifying glass pointing to a blank line. Shows text "تراکنشی با این مشخصات یافت نشد". Primary button "پاک کردن فیلترها" is centered below. | Scale-in illustration | Screen reader announces: *"هیچ نتیجه‌ای یافت نشد. دکمه پاک کردن فیلترها."* |
| **Offline State** | Normal application state. Green status badge remains active in the App Bar header, confirming data privacy. | Static display | TalkBack announces: *"وضعیت آفلاین و امن فعال است."* |
| **Error State** | Outline borders turn red. Inline warning banner shows text: "خطایی در خواندن اطلاعات محلی رخ داده است". Primary retry button is centered below. | Shake animation on horizontal axis | High-priority screen reader announcement. |
| **Filter Applied** | Quick Filter chips highlight in active green/blue accent. Advanced Filter Button displays count badge (e.g. "+3"). | Fast fade-in | Read active filter count to screen reader. |
| **Sorting Applied** | Sort dropdown trigger updates text to match selected sort key. Recent transaction feed reorders. | Decelerated smooth shift | Announce: *"ترتیب نتایج تغییر کرد."* |
| **Search Cleared** | Search field string clears. suggestions collapse, restoring default idle layout instantly. | Instant transition | TalkBack announces: *"کادر جستجو پاک شد."* |
| **Background Multitasking**| Sensitive numbers, amounts, and note strings are blurred with secure visual masks. | Standard scale change | Mute screen reader announcements. |

---

## 11. Responsive Design & Adaptive Viewports

The Search and Filter layout adapts dynamically to different device sizes:

* **Compact Phone:** Vertical stacking. Standard margins applied. Advanced Filter Button opens a full-screen Bottom Sheet modal. Persistent Bottom Navigation remains visible in Zone C.
* **Large Phone (Foldable folded):** Standard mobile layout. Expanded padding applied to category chips to support physical comfort.
* **Tablet Viewport (Unfolded / Landscape):** Transforms into a double-column split layout:
  - **Right Panel (Logical Start - 40%):** Persistent Search Input with a list of recent and saved searches. Horizontal Quick Filter Chips row.
  - **Left Panel (Logical End - 60%):** Detailed Advanced Filters grid layout. Displays results feed side-by-side with filter controls, removing the need for a modal bottom sheet.
  - **Navigation:** Bottom Navigation transitions into a lateral Navigation Rail on the right edge.
* **Landscape Orientation:** Compacts vertical app bar heights. Arranges the advanced filter options row horizontally to maximize screen real estate.

---

## 12. Accessibility & Inclusive Design Integration

To ensure the search experience is accessible to everyone, the interface incorporates strict accessibility features:

* **RTL Persian Layout native flow:** All horizontal sequences, back chevrons, text fields, and list layouts proceed from right to left. Swipe gestures are mirrored naturally.
* **Screen Reader Support (WCAG SC 1.1.1, 1.3.1):**
  - Search results are grouped into single semantic nodes, letting TalkBack read each transaction card as a single focus block (e.g., "بانک ملی، پرداخت موفق، مبلغ منفی چهل و پنج هزار تومان، دوازدهم دی ماه، دارای یادداشت").
  - Matches highlighted in text blocks are announced clearly (e.g., "عبارت انطباق‌یافته: اسنپ").
* **Keyboard Navigation (WCAG SC 2.1.1):**
  - Fully navigable using standard keyboard arrow and Tab keys.
  - Pressing `Escape` instantly clears active search inputs, closes sorting dropdowns, or dismisses bottom sheets.
* **Large Fonts & Dynamic Scaling (WCAG SC 1.4.4):**
  - Standard text cards adapt to system dynamic font magnification up to 200% without clipping or layout shifts.
  - Horizontal components (e.g. metadata rows) wrap vertically into single columns to prevent horizontal overflow.
* **Minimum Touch Target 48-unit bounds (WCAG SC 2.5.5):**
  - Small elements (like the advanced filter button and textfield close icons) expand their touch targets invisibly to meet the 48-unit physical target minimum, preventing accidental taps.
* **Accessible Search Suggestions & Filter Controls (WCAG SC 3.3.2):**
  - Form filters have permanent visible labels positioned outside the input container, avoiding floating text inside fields.
  - Interactive selection checkmarks are announced clearly to screen readers.

---

## 13. Future-Ready Expansion Hooks

* **Natural Language Search:** Space reserved in the search indexer to support offline conversational queries (e.g., "خریدهای هفته گذشته بالای ۵۰ هزار تومان").
* **AI Search Assistant:** Designated slot at the top of suggestions to display smart summaries parsed on-device.
* **Voice Search:** Active temporary icon prepared to integrate local speech-to-text engines.
* **OCR Receipt & Image Search:** Reserved metadata tags inside transaction schemas to support searching parsed receipt text.
* **Semantic Search:** Index structures prepared to support offline vector database embeddings.
* **Smart Filter Recommendations:** Local ML engine prepared to suggest filters based on user habits (e.g., "آخر ماه است، نمایش هزینه‌های مسکن؟").

---

## 14. Governance & Validation Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Deterministic Destructive Flow:** Clearing search history or resetting active filters must always trigger a non-disruptive, auto-saved undo banner.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.
4. **Data Privacy Masking:** Financial values and search queries must be masked with secure visual overlays when the app transitions to the multitasking switcher.

---
**End of Search & Advanced Filter Screen Specification**
