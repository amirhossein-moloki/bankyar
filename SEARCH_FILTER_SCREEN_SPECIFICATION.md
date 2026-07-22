# BankYar Search & Advanced Filter Screen Specification (v2.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Framework Target:** Flutter (Code-Agnostic Design Blueprint)
**Platform Target:** Android & iOS (RTL-Native Layouts)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Theme Philosophy:** Professional, Minimal, Secure, Offline-First
**Classification:** Enterprise Design System Specification
**Document Version:** 2.0.0
**Status:** Approved / Core Specification Blueprint

---

## 1. Executive Summary

This document establishes the absolute visual, spatial, and interaction specification for the **Search & Advanced Filter Experience** in the BankYar ecosystem. Designed to help users locate transactions, notes, and financial records instantly across thousands of secure on-device entries, this experience operates under an uncompromising **offline-first, zero-network privacy constraint**.

By transforming high-volume financial logs into a highly discoverable, blazing-fast, and premium search ledger, this design eliminates financial navigation friction. In strict compliance with BankYar’s Level 0 Engineering and Visual Design Constitutions:
- **Zero Framework Code:** All layouts, interactions, and component structures are platform-independent, with zero Flutter/Dart implementation details.
- **Zero Raw Styling Metrics:** Hardcoded dimensions (such as pixels, dp, or sp) are strictly prohibited. All dimensions and spatial gaps map directly to abstract design tokens.
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
|  [ZONE B: SCROLLABLE SEARCH CONTENT WORKSPACE]                          |
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
* **Visual Presentation:** Pinned to the top of the screen during scrolling content shifts. Its background blends with the canvas background in its idle state, displaying a thin dividing boundary line `bankyar.semantic.color.border.subtle` once lists scroll underneath.
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

## 6. Detailed Component Specifications (The 13 Sections)

Every individual component listed below has its design and behavior parameters defined to eliminate any ambiguity during mobile interface development.

### 6.1 Top App Bar
* **Purpose:** Provides a persistent anchor for navigation back to the Home Dashboard and hosts the screen's main structural title context.
* **Visual Priority:** Secondary. Serves as a framing container for search inputs.
* **Placement:** Positioned strictly in Zone A (Sticky Header) at the uppermost boundary of the viewport.
* **Spacing:** Height is locked to `bankyar.space.xl`. Symmetrical horizontal padding bound to `bankyar.responsive.margin`.
* **Typography:** Subtitle text uses `bankyar.semantic.typography.title.sm` matching `bankyar.font.weight.bold`.
* **Icons:** Back action uses logical directional arrow symbol `bankyar.icon.back.rtl`.
* **Elevation:** Mapped to `bankyar.elevation.level.zero` when idle; morphs to `bankyar.elevation.level.one` during scrolling actions.
* **States:**
  - **Loading:** Background shows a subtle horizontal linear progress sweep `bankyar.semantic.color.interactive.default` at its lowermost boundary.
  - **Disabled:** All icon buttons fade to `bankyar.opacity.medium` and drop pointer click events.
  - **Empty:** Standard rendering with minimal text label "جستجو و فیلتر تراکنش‌ها".
  - **Error:** Background shifts container highlight lines to `bankyar.semantic.color.status.error` to communicate system faults.
  - **Offline:** Unaltered. A tiny secure status label remains visible.
* **Accessibility:** Screen readers announce: *"بالای صفحه، دکمه بازگشت به داشبورد"*. Keyboard focus order starts at the Back Button logical action.
* **RTL Behaviour:** The back chevron mirrors natively (pointing right for Persian RTL layout). Title text is aligned right.
* **Animation:** Slide-in from top during screen loading using standard easing `bankyar.motion.curve.decelerate` over `bankyar.motion.duration.medium`.
* **Future Expansion:** Reserved space on the left edge for future Quick Diagnostics and Security Score indicators.

### 6.2 Search Field
* **Purpose:** Primary user text string entry field to search across local transactions.
* **Visual Priority:** Critical. Highest focus point on the screen.
* **Placement:** Located immediately below the Top App Bar title within Zone A.
* **Spacing:** Standard height of `bankyar.space.xl` (providing a minimum 48-unit tap target). Vertical gap below is `bankyar.space.md`.
* **Typography:** Active text matches `bankyar.semantic.typography.body.md` with monospace Persian characters for typed numbers.
* **Icons:** Leading icon uses `bankyar.icon.search`. Trailing icon toggles dynamically: showing the future voice icon `bankyar.icon.voice` when empty, and the clear cross `bankyar.icon.clear` when text is active.
* **Elevation:** Flat card structure matching `bankyar.elevation.level.one` with outline boundary `bankyar.semantic.color.border.subtle`.
* **States:**
  - **Loading:** Display a tiny circular loading indicator spinning on the left.
  - **Disabled:** Text input box background shifts to `bankyar.semantic.color.interactive.disabled` with reduced opacity.
  - **Empty:** Shows subtle placeholder text "جستجو در مبالغ، بانک‌ها، یادداشت‌ها..." using `bankyar.semantic.color.text.secondary`.
  - **Error:** Outlines shift to `bankyar.semantic.color.status.error`.
  - **Offline:** Fully active. Performs instant on-device searching.
* **Accessibility:** Linked directly to system accessibility focus. TalkBack announces: *"کادر جستجو، دو بار ضربه بزنید تا کیبورد باز شود"*. Focus target size is expanded to prevent input misses.
* **RTL Behaviour:** Text cursor begins on the far right. Icons mirror their lateral alignment points natively.
* **Animation:** Scale-up border thickness from `bankyar.border.width.thin` to `bankyar.border.width.thick` when focused, transitioning over `bankyar.motion.duration.fast`.
* **Future Expansion:** Integrated with on-device natural language parsing APIs to translate conversational queries offline.

### 6.3 Recent Searches
* **Purpose:** Displays the last 5 transaction searches to avoid re-typing queries.
* **Visual Priority:** Low. Displayed only when the search field is focused and empty.
* **Placement:** Top section of the Scrollable Workspace in Zone B (Stage A).
* **Spacing:** Row-by-row layout with vertical spacing `bankyar.space.sm` between items. Symmetrical horizontal padding `bankyar.responsive.margin`.
* **Typography:** Query titles utilize standard body typeface `bankyar.semantic.typography.body.md` in regular weights.
* **Icons:** Leading query history icon `bankyar.icon.clock`, trailing delete icon `bankyar.icon.close`.
* **Elevation:** Surface is flat, blending with the default canvas background.
* **States:**
  - **Loading:** Hidden during query result calculations.
  - **Disabled:** Read-only mode; delete buttons are hidden.
  - **Empty:** The entire section collapses out of view.
  - **Error:** Unaffected.
  - **Offline:** Active. Data is loaded from the encrypted local storage.
* **Accessibility:** Tab order moves cleanly down the chronological list. Screen readers read: *"عبارت جستجو شده قبلی: [متن]"*.
* **RTL Behaviour:** Historical queries start on the right, clear icons align to the far left.
* **Animation:** Fades out list items with scale reduction when deleted, using linear curve.
* **Future Expansion:** Cloud-free backup-encrypted synchronization of search history between local devices.

### 6.4 Suggested Searches
* **Purpose:** Proposes smart search shortcuts dynamically using frequent terms (e.g., utility bills, transport services).
* **Visual Priority:** Low-Medium. Appears adjacent to Recent Searches when the field is focused.
* **Placement:** Located directly under the Recent Searches block in Zone B.
* **Spacing:** Items are arranged inside a wrapping row with standard spacing gaps `bankyar.space.xs`.
* **Typography:** Persian characters in small size `bankyar.font.size.sm` and medium weight.
* **Icons:** Subtle leading search keyword tag symbol `bankyar.icon.tag`.
* **Elevation:** Low elevation chips matching `bankyar.elevation.level.one`.
* **States:**
  - **Loading:** Replaced by loading skeleton cards.
  - **Disabled:** Chips ignore tap interactions and render in low contrast.
  - **Empty:** Hidden if no smart suggestions are available.
  - **Error:** Hidden.
  - **Offline:** 100% operational based on local statistical indices.
* **Accessibility:** Sized correctly to meet touch criteria. Announcements: *"پیشنهاد جستجو: [عبارت]"*.
* **RTL Behaviour:** Chips flow from right to left, wrapping down to subsequent rows naturally.
* **Animation:** Fast fade-in staggered layout using standard decelerating motion.
* **Future Expansion:** Intelligent on-device machine learning suggesting contextual matches based on calendar schedules.

### 6.5 Filter Chips
* **Purpose:** Allows instant, one-tap scoping of transaction queries directly from the active search viewport.
* **Visual Priority:** High. Positioned immediately beneath the main search input.
* **Placement:** Region 2 (Zone A), flowing horizontally below the persistent Search Field.
* **Spacing:** Scrollable row with horizontal gaps bound to `bankyar.space.xs`. Height is set to `bankyar.space.lg`.
* **Typography:** Label text mapped to `bankyar.font.size.sm` and bold weight when selected.
* **Icons:** Checked chips show a leading checkmark icon `bankyar.icon.checkmark`.
* **Elevation:** Blends with Zone A backgrounds when unselected; slightly elevated when selected.
* **States:**
  - **Loading:** Displayed in a semi-transparent shimmer state.
  - **Disabled:** Grayed out container borders; ignores user touch inputs.
  - **Empty:** Standard default unselected layout.
  - **Error:** Shift outlines to red status color.
  - **Offline:** Fully operational.
* **Accessibility:** Focus moves horizontally. TalkBack verbalizes selection states clearly: *"فیلتر تراکنش‌های ورودی، انتخاب شده"*.
* **RTL Behaviour:** Horizontal scroll starts at the right screen margin and flows leftwards.
* **Animation:** Horizontal sliding motion with translucent edge fade. Tapping a chip triggers an instant bounce scaling.
* **Future Expansion:** Custom user-defined smart filter chips pinned to the persistent row.

### 6.6 Advanced Filter Panel
* **Purpose:** Triggers the comprehensive Bottom Filter Sheet for detailed transaction scoping.
* **Visual Priority:** High. Serves as the primary operational gateway for complex queries.
* **Placement:** Pinned strictly to the right (logical start) of the Horizontal Quick Filter row.
* **Spacing:** Circle container with height and width set to `bankyar.space.lg` (with an expanded touch target envelope of 48 units).
* **Typography:** None directly on the button. Modal sheet text uses subtitle weights.
* **Icons:** Tuning icon matching `bankyar.icon.filter`.
* **Elevation:** Level one elevation with a light border outline.
* **States:**
  - **Loading:** Shows a subtle rotating outline segment.
  - **Disabled:** Opacity fades to `bankyar.opacity.medium`. Taps are ignored.
  - **Empty:** Default idle appearance.
  - **Error:** Button outline flashes red on failure.
  - **Offline:** Active. Performs queries on the encrypted SQLite database.
* **Accessibility:** High contrast focus outlines apply. Accessibility label reads: *"دکمه فیلترهای پیشرفته تراکنش"*.
* **RTL Behaviour:** Positioned logically on the far right. Mirrored icon layout applies.
* **Animation:** Rotates the internal tuning icon slightly on click; sheet slides up from the bottom.
* **Future Expansion:** Dynamic AI-generated filter recommendations appearing as prominent header tags.

### 6.7 Search Result Summary
* **Purpose:** Reports the exact match count and displays sorting controls.
* **Visual Priority:** Medium. Keeps the user oriented during high-volume query matches.
* **Placement:** Positioned at the top of Region 3 (Zone B) directly preceding the result list.
* **Spacing:** Vertical height `bankyar.space.md`. Symmetrical margin offsets.
* **Typography:** Monospace numeric characters `bankyar.semantic.typography.monospace.standard` in bold.
* **Icons:** Sort trigger displays leading directional arrow symbol `bankyar.icon.sort`.
* **Elevation:** Flat surface integrated with the background.
* **States:**
  - **Loading:** Text fades to low opacity.
  - **Disabled:** Read-only mode; sort triggers are deactivated.
  - **Empty:** Text reads: "نتایجی یافت نشد".
  - **Error:** Replaced by inline error warnings.
  - **Offline:** Active.
* **Accessibility:** Reads match counts instantly upon query updates. Grouped as a single semantic focus node.
* **RTL Behaviour:** Result text is right-aligned, sort selector is left-aligned.
* **Animation:** Numerical increment ticks use rolling transitions.
* **Future Expansion:** Dynamic summary charts of matched values rendering directly below.

### 6.8 Transaction Result List
* **Purpose:** Displays the matched transaction cards in chronological order.
* **Visual Priority:** Critical. Represents the primary data presentation layer.
* **Placement:** Located in Zone B, below the Search Result Summary.
* **Spacing:** Continuous vertical list with card gaps set to `bankyar.space.md`.
* **Typography:** Main headers use standard text sizing. Cash amounts use bold headline sizes.
* **Icons:** Star indicators, padlock encryption symbols, and note indicators.
* **Elevation:** Level one rounded cards with thin borders.
* **States:**
  - **Loading:** Replaced by shimmering block skeletons.
  - **Disabled:** Ignores selection actions.
  - **Empty:** Shows a clean Empty state screen.
  - **Error:** Displays system error messages with retry buttons.
  - **Offline:** Standard performance.
* **Accessibility:** Grouped cards allow reading of all elements in a single sequential block. Numbers are formatted clearly for screen readers.
* **RTL Behaviour:** Flows from top to bottom. Bank icons align right; cash amounts align left.
* **Animation:** Fluid scrolling performance (60fps+) with sliding transition effects on load.
* **Future Expansion:** Batch selection and multi-item categorizations.

### 6.9 Quick Actions
* **Purpose:** Provides instantaneous inline shortcuts (e.g. adding a note, toggling favorites) directly on each transaction item.
* **Visual Priority:** Medium-Low. Unveiled dynamically via touch actions or nested within card frames.
* **Placement:** Nested inside the Transaction Results List Card logical container.
* **Spacing:** Sized to touch target limits with gaps set to `bankyar.space.sm`.
* **Typography:** Captions match `bankyar.font.size.xs` in regular weight.
* **Icons:** Notebook edit indicator and favorite star.
* **Elevation:** Low elevation offsets to prevent visual clutter.
* **States:**
  - **Loading:** Disabled during state saves.
  - **Disabled:** Buttons ignore pointer inputs.
  - **Empty:** Default unselected style.
  - **Error:** Outlines flash red on local write failures.
  - **Offline:** Active. Saves records instantly to local storage.
* **Accessibility:** Clear descriptive names provided for screen readers. Minimum touch zones enforced.
* **RTL Behaviour:** Swiping left on a card reveals quick actions on the right side.
* **Animation:** Smooth horizontal swipe slide-in using standard decelerating curves.
* **Future Expansion:** Quick export shortcuts to share specific transactions offline via QR codes.

### 6.10 Empty Search State
* **Purpose:** Encourages the user to start searching when the screen is opened.
* **Visual Priority:** Medium. Helps guide onboarding.
* **Placement:** Center of Zone B, displayed only before search inputs are entered.
* **Spacing:** Vertical layout centered with top and bottom margins set to `bankyar.space.xxl`.
* **Typography:** Main title uses subtitle sizing; descriptions use standard body sizes.
* **Icons:** Medium-sized illustration matching `bankyar.icon.search.empty`.
* **Elevation:** Flat visual canvas.
* **States:**
  - **Loading:** Hidden behind loaders.
  - **Disabled:** Interactive guides are deactivated.
  - **Empty:** Active state.
  - **Error:** Hidden behind error states.
  - **Offline:** Fully operational.
* **Accessibility:** Reads onboarding text instantly. Focus centers on the main instructions.
* **RTL Behaviour:** Symmetrical alignment centering text and elements.
* **Animation:** Fade-in transition using linear curve.
* **Future Expansion:** Dynamic onboarding tutorials matching user spending patterns.

### 6.11 No Result State
* **Purpose:** Explains search misses and offers actionable recovery options.
* **Visual Priority:** High. Reassures users when queries return empty.
* **Placement:** Center of Zone B, displayed only when active queries match zero records.
* **Spacing:** Centered layout with vertical gaps set to `bankyar.space.xl`.
* **Typography:** Persian characters in large and readable fonts.
* **Icons:** Large empty search symbol.
* **Elevation:** Flat visual canvas.
* **States:**
  - **Loading:** Hidden behind loading skeletons.
  - **Disabled:** Recovery buttons are deactivated.
  - **Empty:** Active state.
  - **Error:** Replaced by system error screens.
  - **Offline:** Operational.
* **Accessibility:** Screen readers announce: *"تراکنشی با این مشخصات یافت نشد، دکمه پاک کردن فیلترها"*.
* **RTL Behaviour:** Center-aligned.
* **Animation:** Scale-in illustration on entry.
* **Future Expansion:** Intelligent fuzzy search suggestions for similar terms.

### 6.12 Loading State
* **Purpose:** Communicates active search result compilation without causing interface stutter.
* **Visual Priority:** High. Keeps users oriented during local storage reads.
* **Placement:** Spans the entire Zone B workspace.
* **Spacing:** Matches the spacing layout of standard result lists.
* **Typography:** Unaltered; labels are grayed out.
* **Icons:** Spinning progress indicators and shimmering vectors.
* **Elevation:** Identical to standard result layouts.
* **States:**
  - **Loading:** Active state.
  - **Disabled:** Ignores touch interactions.
  - **Empty:** Replaced by empty views on completion.
  - **Error:** Toggles immediately to error views on failure.
  - **Offline:** Operational.
* **Accessibility:** Reads: *"در حال بارگذاری تراکنش‌ها..."*. Screen readers are updated when loading completes.
* **RTL Behaviour:** Shimmer overlays sweep from right to left natively.
* **Animation:** Continuous opacity shimmering.
* **Future Expansion:** Predictive pre-fetching of records based on user usage habits.

### 6.13 Offline State
* **Purpose:** Confirms 100% on-device secure operations.
* **Visual Priority:** Low-Medium. Built-in reassurance status.
* **Placement:** Pinned strictly to Zone C at the centered baseline coordinate.
* **Spacing:** Integrated seamlessly with system margins.
* **Typography:** Monospace characters in small font sizes.
* **Icons:** Small padlock encryption emblem.
* **Elevation:** Level zero elevation.
* **States:**
  - **Loading:** Unaltered.
  - **Disabled:** Unaffected.
  - **Empty:** Unaffected.
  - **Error:** Shifts colors to high-priority alert tones.
  - **Offline:** Active.
* **Accessibility:** Screen readers read: *"وضعیت امن آفلاین، ذخیره اطلاعات روی دستگاه"*.
* **RTL Behaviour:** Centered.
* **Animation:** Fades out when the app multitasking switcher is focused.
* **Future Expansion:** Real-time on-device security audit indicators.

---

## 7. The 12 Official Visual & Interaction Deliverables

### Deliverable 1: Complete Screen Layout
The complete layout utilizes a structured three-zone grid system matching Material Design 3 guidelines:
* **Zone A (Sticky App Bar & Filter Bar):** Pinned to the top viewport boundary. Spans a fixed height of `bankyar.space.xxl`, hosting the search field, back chevron, and quick-filter scrolling rows.
* **Zone B (Scrollable Content Workspace):** Dynamic scrolling area spanning the central screen space. It hosts empty illustrations, typing suggestion lists, or transaction cards.
* **Zone C (Sticky System Navigation & Diagnostics):** Pinned to the bottom viewport boundary. It houses system bottom bars and the persistent offline security badge.

### Deliverable 2: Information Hierarchy
Visual priority is structured into three logical vertical layers:
1. **Critical Focus Layer:** Main Search Field and active search string inputs.
2. **Operational Layer:** Horizontal quick filter chips and result sort triggers.
3. **Data Layer:** Chronological transaction list cards, cash amounts, and annotations.

### Deliverable 3: Search Flow
The step-by-step search interaction is managed completely on-device:
1. **Focus:** User taps the persistent search field. Zone B transitions from the default feed to the Empty Search View (Recent & Saved searches).
2. **Keystroke:** User types. Input is debounced by 200 milliseconds to avoid UI lag. Smart completion overlays appear in real-time.
3. **Execution:** Database indexes query the encrypted SQLCipher local vault instantly.
4. **Resolution:** Search Result summary updates, matching text is highlighted, and the matched transaction cards list is rendered in Zone B.

### Deliverable 4: Filter Flow
Deep filtering is simplified through progressive disclosures:
1. **Trigger:** User taps the Advanced Filter button next to the horizontal chip row.
2. **Disclosure:** Bottom Filter Sheet slides up from Zone C, covering up to 75% of the active viewport.
3. **Selection:** User adjusts parameters (banks, transaction type, amount range, custom dates).
4. **Validation:** Active counts update in real-time on the sticky apply button.
5. **Dismissal:** Tapping "Apply" closes the sheet and updates the result list instantly.

### Deliverable 5: Component Placement
Specific horizontal coordinate mappings are established:
* **Start Margin (Right):** Back buttons, bank avatars, group category titles, checkboxes, and input labels.
* **End Margin (Left):** Close/clear buttons, cash amounts, favorite stars, and dropdown triggers.
* **Symmetrical Grid:** Centered titles, empty state illustrations, and bottom offline security badges.

### Deliverable 6: Result Layout
Each matched transaction card follows a standard vertical grid layout:
* **Top Row:** Bank logo and bank name align right; matched transaction cash amount and currency label align left.
* **Divider:** Thin dashed line separating top metadata from lower indicators.
* **Bottom Row:** Padlock security emblem and note indicator align right; date/time stamps center; favorite star indicator aligns left.

### Deliverable 7: Interaction Flow
All gesture mappings utilize standard, comfortable physical reach zones:
* **Horizontal Scroll:** Sweeping across the quick filter chips row from right to left.
* **Vertical Scroll:** Infinite pagination down the matched transaction cards feed.
* **Swipe Left:** Swiping left on any list item card reveals quick inline actions (notebook edits, favorite toggles).
* **Swipe Down:** Dismisses the Advanced Bottom Filter Sheet dynamically.

### Deliverable 8: Empty States
Two distinct empty visual designs prevent system dead-ends:
* **Empty Search State:** Shows an onboarding illustration with text: "برای شروع، عبارت مورد نظر را وارد کنید" and a list of helpful search tips.
* **No Result State:** Displays an empty magnifying glass vector with text: "تراکنشی با این مشخصات یافت نشد" and a clear primary button: "پاک کردن همه فیلترها".

### Deliverable 9: Error States
When database access or query calculations encounter faults, the layout adapts instantly:
* **Visual Highlight:** Card borders flash with standard error accent lines.
* **Inline Warning:** A high-contrast warning banner displays: "خطایی در خواندن اطلاعات محلی رخ داده است".
* **Recovery Action:** A prominent button "تلاش مجدد" (Retry Query) is centered below the warning.

### Deliverable 10: Accessibility Review
A detailed checklist ensures compliance with WCAG 2.1 guidelines:
* **Focus Nodes:** Matched transaction cards are grouped into single semantic entities for TalkBack screen readers.
* **Touch Target Size:** Small elements (e.g. close buttons, advanced filter icons) expand their touch targets invisibly to meet the 48-unit physical minimum.
* **Dynamic Scaling:** Layout elements wrap vertically to prevent horizontal screen overflow when text is scaled up to 200%.
* **Clear Inputs:** Input controls utilize permanent visible labels outside text boxes rather than floating text placeholders.

### Deliverable 11: RTL Review
Native Persian flows are verified across all components:
* **Reading Path:** Visual layouts proceed logically from right (logical start) to left (logical end).
* **Gestures:** Swiping, carousel scrolling, and drawer dismissals mirror natively.
* **Directional Icons:** Arrows, back chevrons, and sort indicators mirror their alignment.

### Deliverable 12: UX Validation Checklist
The product architecture conforms to strict governance rules:
1. **Design Token Adherence:** Every color, layout gap, radius, and elevation level maps to an active design token. No hardcoded styles are used.
2. **No Network Access:** Operating with exactly zero bytes of network transmission. All assets and libraries function completely offline.
3. **Data Security Masking:** Sensitive numbers and transaction cash amounts are blurred with secure visual masks when the app transitions to the system multitasking switcher.

---
**End of Search & Advanced Filter Screen Specification**
