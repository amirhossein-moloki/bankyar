# BankYar Statistics & Analytics Dashboard Screen Specification (v1.1.0)
## High-Fidelity UI Design Specification for Production-Ready Implementation

**Project Name:** BankYar
**Framework Target:** Flutter (Code-Agnostic Design Blueprint)
**Platform Target:** Android (RTL-Native Layout)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Classification:** Product & Engineering UI Specification

---

## 1. Executive Summary & Design Vision

The BankYar Statistics & Analytics Dashboard is an offline-first, private personal finance analytical command center. Its purpose is to transform raw, parsed on-device financial transaction data into high-precision visual insights. Operating with zero network permissions, the dashboard guarantees absolute security while presenting complex cash flow behaviors in a calm, stress-reducing, and highly intuitive format.

In strict compliance with BankYar's visual design standards:
- **Zero Framework Code:** All layouts, hierarchies, and components are defined without direct code structures or classes.
- **Zero Raw Styling Metrics:** Physical measurements (such as physical pixels, density-independent pixels, or scale-independent typography units) are strictly omitted. All spacing, rounded corners, borders, and typography scales map directly to abstract design tokens.
- **Zero Hardcoded Colors:** All color definitions reference semantic color tokens that adapt dynamically between themes. No raw HEX codes are used.
- **RTL-First Structure:** Layouts, reading flows, and component alignments progress naturally from the logical start edge (right) to the logical end edge (left).

---

## 2. Grid Architecture & Spatial Principles

The dashboard layout utilizes a strict relative grid system to establish spatial stability and alignment across varying device screen sizes.

### Grid System Layout
- **Column Scaffolding:** Adaptively scales from compact phone screens to multi-column tablet layouts.
  - **Phone Viewport:** 4 columns
  - **Large Phone Viewport:** 4 columns
  - **Tablet Viewport:** 8 columns (double-column master-detail split)
  - **Foldable Viewport:** 8 columns (adaptive layout folding split)
- **Outer Margin Inset:** Aligns strictly to the `bankyar.responsive.margin` token.
- **Gutter Spacing:** Horizontal gaps between elements are bound to the `bankyar.responsive.gutter` token.
- **Rhythm Multipliers:** Spacing and containment pads are multiples of the base spacing unit (`bankyar.global.space.base`):
  - `bankyar.space.xxs` (0.25x base unit)
  - `bankyar.space.xs` (0.5x base unit)
  - `bankyar.space.sm` (1x base unit, 8-unit proportional step)
  - `bankyar.space.md` (2x base unit)
  - `bankyar.space.lg` (3x base unit)
  - `bankyar.space.xl` (4x base unit)
  - `bankyar.space.xxl` (6x base unit)

---

## 3. Complete Screen Layout (Deliverable 1)

The complete screen layout provides the visual framework of the dashboard, dividing the system viewport into distinct, responsive regions.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [REGION 1: TOP APP BAR & ACTIONS]                                      |
|  +-------------------------------------------------------------------+  |
|  | [Export] [Share]        [Dashboard Title]           [Search Trigger] |  |
|  | (Logical End / Left)     (Center-Aligned)           (Logical Start)  |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 2: DATE RANGE SELECTOR]                                        |
|  +-------------------------------------------------------------------+  |
|  | [Chevron Right]        [Selected Date Range]         [Chevron Left]  |  |
|  |                        "امروز، ۱۲ دی ۱۴۰۲"                           |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 3: QUICK FILTERS ROW]                                          |
|  +-------------------------------------------------------------------+  |
|  | [All Type]   [Melli Bank]   [Mellat Bank]  [Income Only]  [Custom]   |  |
|  | (Horizontally scrollable from right to left)                      |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 4: SUMMARY CARDS WORKSPACE]                                    |
|  +-------------------------------------------------------------------+  |
|  |  [Summary Cards Grid / Scroll Row]                                |  |
|  |  +-------------------------------+  +--------------------------+  |  |
|  |  | Net Balance Card              |  | Income Summary Card      |  |  |
|  |  +-------------------------------+  +--------------------------+  |  |
|  |  +-------------------------------+  +--------------------------+  |  |
|  |  | Expense Summary Card          |  | Transaction Count Card   |  |  |
|  |  +-------------------------------+  +--------------------------+  |  |
|  |  +-------------------------------+  +--------------------------+  |  |
|  |  | Avg Daily Spending Card       |  | Avg Monthly Spending Card|  |  |
|  |  +-------------------------------+  +--------------------------+  |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 5: INTERACTIVE CHARTS & VISUAL ANALYTICS]                      |
|  +-------------------------------------------------------------------+  |
|  | [Chart Type Selection Row]                                        |  |
|  | [Daily]  [Weekly]  [Monthly]  [Bank Dist]  [Expense Cat]  [Comp]   |  |
|  |                                                                   |  |
|  | [Interactive Chart Container]                                     |  |
|  | - Line, Bar, Pie, Donut, Area Graphs with Legends & Tooltips     |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 6: RECENT FINANCIAL INSIGHTS FEED]                             |
|  +-------------------------------------------------------------------+  |
|  | - Top Spending Days, Top Receiving Days, Most Used Bank, etc.     |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [REGION 7: PERSISTENT NAVIGATION SHELL]                                |
|  +-------------------------------------------------------------------+  |
|  | [Ledger]              [Analytics (Active)]              [Settings]  |  |
|  | (Logical Start / Right)                               (Logical End) |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

### Complete Screen Layout Parameters:
- **Canvas Base Color:** Mapped to the `bankyar.semantic.color.background.canvas` design token.
- **Outer Margins:** Symmetrically aligned on logical start (right) and logical end (left) using `bankyar.responsive.margin`.
- **Vertical Flow:** Single-axis continuous scrolling canvas with a pinned Top App Bar (Region 1) and a pinned Persistent Navigation Shell (Region 7).
- **Physical Transitions:** Visual cards animate using standard Material Design 3 elevation transitions, shifting states on active vertical scrolls.

---

## 4. Dashboard Structure (Deliverable 2)

The dashboard structure controls the global layout block placement, ordering content components from the most critical global summaries down to historical analytical details.

### Content Structural Order (RTL Flow):
1. **Region 1 (Top App Bar):** System identifier, title, global search toggle, manual export, and secure share action triggers.
2. **Region 2 (Time Horizon Control):** Relative date selector bar for quick chronological shifting.
3. **Region 3 (Dynamic Filter Dock):** Interactive chips to refine statistics by bank accounts, amount ranges, and transaction types.
4. **Region 4 (Financial Scorecard Grid):** A six-card workspace presenting immediate financial KPIs (Balance, Income, Expenses, Count, Daily Avg, Monthly Avg).
5. **Region 5 (Visual Analytics Canvas):** Segmented charts with interactive toggle controls to swap visualizations (Daily Line Chart, Weekly Bar Chart, Monthly Column Chart, Bank Pie Chart, Category Donut Chart, Area Comparison Chart).
6. **Region 6 (Insights Feed):** Automated local highlights (Top Spending Days, Top Income Days, Most Active Banks, Largest Transaction, Lowest Transaction).
7. **Region 7 (Persistent System Navigation):** Bottom navigation bar (for phones) transitioning to a Navigation Rail (for tablets).

---

## 5. Widget / Component Block Hierarchy (Deliverable 3)

The following block-nested hierarchy outlines the structure of the dashboard UI. It references abstract, platform-agnostic design elements.

```
DashboardScaffoldContainer
 ├── StatusbarSafeOverlay
 ├── StickyTopAppBarRegion
 │    └── HorizontalLogicalRow
 │         ├── SearchTriggerIconButton (Logical Start / Right)
 │         ├── ScreenTitleText ("آموزش و آمار مالی")
 │         └── SymmetricalActionGroup (Logical End / Left)
 │              ├── ShareSnapshotButton
 │              └── ExportReportButton
 ├── SearchBarExpansionOverlay [Conditional Overlay]
 │    └── RoundedInputContainer
 │         ├── LeadingCloseButton
 │         ├── PersianTextFieldInput
 │         └── TrailingTextClearButton
 ├── ScrollableCanvasWorkspace
 │    ├── VerticalListSpacer (bankyar.space.sm)
 │    ├── DateHorizonControlBlock (Region 2)
 │    │    └── OutlinedCardContainer
 │    │         ├── DateShiftForwardButton (Right Chevron)
 │    │         ├── ActiveDateRangeTextTrigger
 │    │         └── DateShiftBackwardButton (Left Chevron)
 │    ├── FilterChipHorizontalScrollRow (Region 3)
 │    │    └── ScrollableChipRowContainer (RTL Flow)
 │    │         ├── BankSelectionChoiceChips
 │    │         ├── TransactionTypeChoiceChips
 │    │         └── AmountRangeSelectionChips
 │    ├── ScorecardGridRegion (Region 4)
 │    │    └── ResponsiveGridLayout
 │    │         ├── SummaryCardBlock (Net Balance)
 │    │         ├── SummaryCardBlock (Income Overview)
 │    │         ├── SummaryCardBlock (Expense Overview)
 │    │         ├── SummaryCardBlock (Transaction Count)
 │    │         ├── SummaryCardBlock (Average Daily Spending)
 │    │         └── SummaryCardBlock (Average Monthly Spending)
 │    ├── AnalyticalVisualizerBlock (Region 5)
 │    │    └── HighContrastChartCard
 │    │         ├── SegmentedChartNavigationTabs
 │    │         ├── InteractiveViewportCanvas
 │    │         │    └── [Active Rendered Chart Canvas]
 │    │         └── TabularChartLegendBlock
 │    ├── SmartInsightsSection (Region 6)
 │    │    ├── SectionHeaderTitle ("بینش‌های مالی اخیر")
 │    │    └── VerticalInsightsFeedStack
 │    │         ├── InsightFeedCard (Top Spending Day)
 │    │         ├── InsightFeedCard (Top Income Day)
 │    │         ├── InsightFeedCard (Most Active Bank)
 │    │         ├── InsightFeedCard (Largest Transaction)
 │    │         └── InsightFeedCard (Lowest Transaction)
 │    └── BottomNavigationPadding (bankyar.space.xxl)
 └── PinnedNavigationShell (Region 7)
      └── BottomNavigationBarContainer (Phone Viewport) OR NavigationRailContainer (Tablet Viewport)
```

---

## 6. Card Layout (Deliverable 4)

Cards serve as the physical containers for summaries, charts, and financial insights across the dashboard workspace.

### Core Card Configuration:
- **Card Background:** Mapped to the `bankyar.semantic.color.surface.default` design token.
- **Card Boundary Outline:** Solid line with thickness `bankyar.border.width.thin` and colored with `bankyar.semantic.color.border.default`. No drop shadows under standard state to maintain a flat, minimal aesthetic.
- **Card Curvature:** Rounded corner radius bound to the `bankyar.radius.medium` token.
- **Card Padding:** Symmetrical internal inset spacing bound to the `bankyar.space.md` token on all four sides.
- **Interactive State Representation:**
  - **Selected / Hover State:** Canvas background shifts to `bankyar.semantic.color.surface.variant` (low contrast shift) with border outline updated to `bankyar.semantic.color.border.active`.
  - **Pressed State:** Micro-scale physical compression (0.98x scaling transformation) accompanied by an immediate tactile haptic impulse.
  - **Disabled State:** Opacity attenuated to 40% with background filled with `bankyar.semantic.color.disabled.background`.

---

## 7. Chart Placement (Deliverable 5)

Charts are placed within the Analytical Visualizer Block (Region 5) to ensure fast information scanning.

### Placement and Geometry Rules:
- **Aspect Ratio Boundaries:**
  - **Portrait Viewport:** Aspect ratio locked to 4:3.
  - **Landscape Viewport:** Aspect ratio locked to 16:9.
- **Gridline Setup:** Thin horizontal dashed gridlines aligned to primary monetary divisions on the Y-axis. Secondary gridlines on the X-axis are omitted to reduce visual noise.
- **Axis Alignments:**
  - **Y-Axis (Logical Start):** Positioned on the right-hand edge (RTL Native) displaying currency labels.
  - **X-Axis (Bottom):** Positioned horizontally along the lower boundary displaying time steps.
- **Legend Grids:** Positioned underneath the visual graph canvas, organized as a vertical tabular list to align percentage metrics using monospace numerals.
- **Touch Target Hotzones:** Data nodes on Line, Area, and Bar charts are highlighted with flat circular dot targets that expand to `bankyar.space.lg` touch envelopes on hover or press.

---

## 8. Typography Usage (Deliverable 6)

The dashboard utilizes the corporate Persian typography system to guarantee maximum numeric readability and hierarchical scanning.

### Typography Allocations:
- **Primary Metric Displays:** Mapped to the `bankyar.semantic.typography.display.lg` token, utilizing monospace Persian numerals (e.g., `+۴,۱۵۰,۰۰۰ تومان`) for quick digit scanning.
- **Section Headers & Card Titles:** Mapped to the `bankyar.semantic.typography.title.sm` token (bold weight, high reading contrast).
- **Secondary Details & Metadata:** Mapped to the `bankyar.semantic.typography.body.md` token (regular weight, neutral gray color).
- **System Actions & Filter Chip Text:** Mapped to the `bankyar.semantic.typography.label.md` token (medium weight, high contrast on active states).
- **Annotations & Inline Descriptions:** Mapped to the `bankyar.semantic.typography.caption.medium` token (regular weight, subtle gray tone).

---

## 9. Information Hierarchy (Deliverable 7)

To minimize cognitive load, the visual weight of elements follows a strict descending order from high-level totals to detailed analytics.

```
Visual Hierarchy Scan Path (RTL Flow):

[Top Right: Dashboard Title & Search] ---> [Top Left: Share & Export Actions]
                  |
                  v
[Interactive Time Horizon Selector & Quick Filters]
                  |
                  v
[High-density Financial Scorecards (Primary Focus: Net Balance Metric)]
                  |
                  v
[Visual Interactive Chart Canvas (Selected Trend / Distribution Visualization)]
                  |
                  v
[Automated Financial Insights Feed (Secondary Metadata Details)]
```

### Visual Weight Assignment Rules:
- **Primary Contrast:** Used exclusively for active numbers, cash flow balances, and primary interactive titles.
- **Secondary Contrast:** Used for descriptions, past-period comparisons, dates, and unselected filter chips.
- **Accent Tints:** Red (`bankyar.semantic.color.error`) and Green (`bankyar.semantic.color.success`) are applied sparingly, limited to transaction indicators (credit vs debit) and active positive/negative performance percentages.

---

## 10. User Interaction Flow (Deliverable 8)

The dashboard allows seamless exploration of local financial data through logical, zero-latency touch paths.

```
+--------------------------------------------------------------------------+
|                       USER INTERACTION FLOW MAP                          |
+--------------------------------------------------------------------------+
|                                                                          |
| 1. Tap Top Search Icon --------> Expands inline Search Input Bar        |
|                                                                          |
| 2. Tap Date Selector Field ----> Slides up Custom Calendar Bottom Sheet  |
|                                                                          |
| 3. Tap Bank / Type Filter -----> Refilters Ledger & Recalculates Charts  |
|                                                                          |
| 4. Swipe Chart Tab Bar --------> Swaps Chart view (Line -> Bar -> Pie)   |
|                                                                          |
| 5. Touch Graph Data Node ------> Displays Floating High-Contrast Tooltip |
|                                                                          |
| 6. Press Card / Insight -------> Navigates to Detailed Filtered Ledger   |
|                                                                          |
+--------------------------------------------------------------------------+
```

### Flow Path Detail:
- **Search Interaction:** Smooth horizontal sliding expansion of the search input field from the logical start corner.
- **Date Range Interaction:** Launches an animated bottom sheet containing quick shortcuts and a dual-month Persian calendar grid.
- **Chart Tab Interaction:** Horizontal swipe or tap transitions the active visualization canvas, with data points recalculating on the fly.

---

## 11. Empty State Design (Deliverable 9)

Empty states prevent visual confusion by guiding the user with actionable instructions when local data is absent.

### 11.1 Empty State: No Transactions
- **Visual Illustration:** A centered outline representation of a locked filing cabinet styled with design token `bankyar.icon.size.xl`.
- **Primary Headline:** "هنوز هیچ تراکنشی ثبت نشده است" (No transactions registered yet).
- **Supporting Text:** "بانک‌یار به صورت خودکار پیامک‌های بانکی ورودی شما را تحلیل و سازماندهی می‌کند. همچنین می‌توانید تراکنش‌ها را به صورت دستی ثبت کنید." (BankYar automatically analyzes and organizes your incoming banking SMS. You can also log transactions manually).
- **Primary Action Button:** Centered elevated button labeled "ثبت تراکنش دستی اولین مورد" (Register first transaction manually) bound to `bankyar.radius.full` and filled with `bankyar.semantic.color.action.primary`.

### 11.2 Empty State: No Statistics
- **Visual Illustration:** Monochromatic outline icon representing a flat bar chart with a diagonal slash.
- **Primary Headline:** "آماری برای نمایش وجود ندارد" (No statistics available to display).
- **Supporting Text:** "جهت محاسبه نمودارها و آمار، حداقل یک تراکنش مالی در محدوده زمانی انتخاب شده مورد نیاز است." (To calculate charts and statistics, at least one financial transaction is required within the selected time range).
- **Primary Action Button:** Flat icon button labeled "تغییر محدوده زمانی گزارش" (Change report date range).

### 11.3 Empty State: No Matching Filters
- **Visual Illustration:** Centered vector symbol of a funnel with a cross icon.
- **Primary Headline:** "تراکنشی با فیلترهای انتخابی یافت نشد" (No transactions found matching active filters).
- **Supporting Text:** "هیچ‌کدام از پیامک‌های بانکی با ترکیب فیلترهای حساب بانکی، محدوده مبلغ یا نوع تراکنش مطابقت ندارند." (None of the banking SMS messages match the active combination of bank account, amount range, or transaction type).
- **Primary Action Button:** Outlined button labeled "پاک کردن تمامی فیلترها" (Clear all active filters).

### 11.4 Empty State: No Selected Date
- **Visual Illustration:** Outlined calendar icon with a warning dot.
- **Primary Headline:** "محدوده زمانی انتخاب نشده است" (No date range selected).
- **Supporting Text:** "لطفاً یک بازه زمانی معتبر را جهت بارگذاری و تحلیل آمار مالی انتخاب نمایید." (Please select a valid time horizon to load and analyze financial statistics).
- **Primary Action Button:** Elevated button labeled "انتخاب بازه زمانی گزارش" (Select report date range).

---

## 12. Error State Design (Deliverable 10)

Error states handle technical disruptions gracefully, preventing app crashes and guiding users to recovery.

### 12.1 Error State: Chart Error
- **Visual Container:** Visual canvas boundaries outlined with a thin crimson border (`bankyar.semantic.color.border.error`).
- **Primary Headline:** "خطا در ترسیم نمودار مالی" (Error drawing financial chart).
- **Supporting Text:** "هنگام خواندن نقاط آماری محلی خطایی رخ داد. اطلاعات تراکنش‌های شما امن هستند." (An error occurred while reading local statistical points. Your transaction data remains safe).
- **Action Button:** Centered flat button labeled "تلاش مجدد برای ترسیم" (Retry drawing chart).

### 12.2 Error State: Data Loading Error
- **Visual Container:** Full-screen dialog container overlay.
- **Primary Headline:** "بارگذاری اطلاعات مالی متوقف شد" (Financial data loading halted).
- **Supporting Text:** "سیستم در بازیابی اطلاعات آماری ذخیره شده با مشکل موقت روبرو گردید." (The system encountered a temporary problem retrieving stored statistical details).
- **Action Button:** Outlined recovery button labeled "بارگذاری مجدد صفحه" (Reload dashboard).

### 12.3 Error State: Database Error
- **Visual Container:** Solid alert block spanning the visual canvas width.
- **Primary Headline:** "خطای دسترسی به پایگاه داده امن" (Secure database access error).
- **Supporting Text:** "اتصال به بانک اطلاعاتی رمزگذاری شده محلی برقرار نشد. احتمالاً کلید سخت‌افزاری دستگاه موقتاً در دسترس نیست." (Could not establish connection to the encrypted local database. The device hardware key may be temporarily unavailable).
- **Action Button:** System retry button labeled "اتصال مجدد به پایگاه داده" (Reconnect to database).

### 12.4 Error State: Permission Error
- **Visual Container:** Full-viewport dark overlay.
- **Primary Headline:** "عدم دسترسی به پیامک‌های بانکی" (Missing permission to access banking SMS).
- **Supporting Text:** "برای تحلیل خودکار تراکنش‌ها، دسترسی به پیامک‌های دستگاه الزامی است. بانک‌یار کاملاً آفلاین است و هیچ اطلاعاتی از دستگاه خارج نمی‌شود." (To analyze transactions automatically, access to device SMS is required. BankYar is fully offline and no data ever leaves your device).
- **Action Button:** Prominent elevated button labeled "اعطای مجوز دسترسی پیامک" (Grant SMS permission).

---

## 13. Comprehensive Section Specifications (The 21 Dashboard Modules)

Every content module on the Statistics & Analytics Dashboard is defined across fifteen parameters to ensure production-ready clarity.

---

### 13.1 Overview Header (Top App Bar & Actions)
- **1. Purpose:** Serves as the screen's main identity control, holding titles and global system actions.
- **2. Business Value:** Increases user trust by clearly identifying the screen as a secure offline personal space.
- **3. Visual Priority:** Level 1 (Top of layout, high horizontal anchor).
- **4. Placement:** Pinned to Region 1 at the top of the viewport.
- **5. Spacing:** Height matches the `bankyar.space.xxl` design token.
- **6. Typography:** Title styled with `bankyar.semantic.typography.heading.md`.
- **7. Icons:** Search, share, and document-export vector icons.
- **8. Interaction:** Tapping search expands an inline input bar. Tapping share or export opens modal bottom sheets.
- **9. Loading:** Skeleton shapes replace action buttons during background startup processes.
- **10. Error:** No direct error state (system structural bar).
- **11. Offline:** Always active (offline-native, no cloud status indicators).
- **12. Accessibility:** Explicit semantics labels for screen readers on all icon buttons.
- **13. RTL Behaviour:** Layout progresses from right (Search icon) to left (Share and Export buttons).
- **14. Animation:** Top bar slides down on screen load and fades out on background transitions.
- **15. Future Expansion:** Prepared to host a multi-currency toggle switch.

---

### 13.2 Selected Date Range Selector
- **1. Purpose:** Displays the active report time frame and allows shifting periods.
- **2. Business Value:** Allows users to focus their analysis on specific financial cycles (e.g., monthly salary cycles).
- **3. Visual Priority:** Level 2 (Directly below Region 1).
- **4. Placement:** Positioned in Region 2, spanning the full container width.
- **5. Spacing:** Top margin set to `bankyar.space.sm`, bottom margin set to `bankyar.space.md`.
- **6. Typography:** Center text styled with `bankyar.semantic.typography.body.md` using monospace digits.
- **7. Icons:** Left and right arrow chevrons for chronological shifting.
- **8. Interaction:** Tapping arrow buttons shifts the time window. Tapping the center text opens the calendar bottom sheet.
- **9. Loading:** The date range remains static while the underlying dashboard data recalculates.
- **10. Error:** Displays an exclamation indicator inside the card if calendar calculations fail.
- **11. Offline:** Full calendar logic is handled completely offline.
- **12. Accessibility:** Chevron touch targets maintain a minimum vertical height of forty-eight units.
- **13. RTL Behaviour:** Logical start (right arrow) shifts the range back in time. Logical end (left arrow) shifts it forward.
- **14. Animation:** Text fades and slides horizontally when dates are shifted.
- **15. Future Expansion:** Prepared to support custom fiscal year boundaries.

---

### 13.3 Applied Filters & Quick Filters Row
- **1. Purpose:** Provides a horizontal row of choice chips to quickly filter statistics.
- **2. Business Value:** Helps users isolate specific accounts (e.g., Melli Bank vs Mellat Bank) to analyze separate spending channels.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Positioned in Region 3, below Region 2.
- **5. Spacing:** Vertical margin matches `bankyar.space.sm`. Inner gap between chips matches `bankyar.space.xs`.
- **6. Typography:** Chip labels styled with `bankyar.semantic.typography.label.md`.
- **7. Icons:** Active checkmark icon visible on selected chips.
- **8. Interaction:** Tapping a chip toggles its selection state, refiltering statistics in under 200ms.
- **9. Loading:** Shimmering skeleton chips pulse from right to left during loading.
- **10. Error:** If filter configuration fails, chips transition to their disabled visual state.
- **11. Offline:** Filter calculations are processed locally.
- **12. Accessibility:** Text contrast ratio is maintained above 4.5:1 across all active and inactive states.
- **13. RTL Behaviour:** Horizontal scroll progresses from right to left, overflowing on the left edge.
- **14. Animation:** Selected chips expand horizontally with a smooth transition.
- **15. Future Expansion:** Prepared to support multi-select tagging filters.

---

### 13.4 Search Statistics Input Box
- **1. Purpose:** Allows users to type search queries to filter transactions and statistics.
- **2. Business Value:** Enables rapid lookup of specific financial transactions without manual scroll searching.
- **3. Visual Priority:** Level 1.
- **4. Placement:** Overlays Region 1 dynamically when expanded.
- **5. Spacing:** Inside padding set to `bankyar.space.sm` on all sides.
- **6. Typography:** Hint text styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Search vector icon and a clear-all (cross) icon.
- **8. Interaction:** Expands on tap. Typing triggers real-time filtering. Tapping clear purges the query.
- **9. Loading:** A small circular loader replaces the clear icon during local database searches.
- **10. Error:** Border transitions to crimson (`bankyar.semantic.color.border.error`) if the query crashes.
- **11. Offline:** Queries run against the encrypted SQLite database locally.
- **12. Accessibility:** Clear labels are announced to screen readers.
- **13. RTL Behaviour:** Text is aligned to the right, and the clear button is placed on the logical left.
- **14. Animation:** Horizontal slider expansion from the right corner.
- **15. Future Expansion:** Prepared to store search history locally.

---

### 13.5 Net Balance Summary Card
- **1. Purpose:** Displays the net cash flow balance (Income minus Expenses) for the active period.
- **2. Business Value:** Gives the user an immediate assessment of their financial health for the month.
- **3. Visual Priority:** Level 1 (Primary visual focus in Region 4).
- **4. Placement:** First position in Region 4's scorecard workspace.
- **5. Spacing:** Top margin set to `bankyar.space.md`, bottom margin set to `bankyar.space.sm`.
- **6. Typography:** Value styled with `bankyar.semantic.typography.display.lg` (large, monospace numerals).
- **7. Icons:** Success trend arrow icon.
- **8. Interaction:** Tapping the card opens the filtered ledger showing the net transaction list.
- **9. Loading:** Shimmering placeholder pulse masks mask the value during calculation.
- **10. Error:** Displays a dash indicator in place of the monetary value.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Screen readers announce: "تراز خالص دریافتی شما مثبت چهار میلیون و صد و پنجاه هزار تومان است" (Your net balance is positive 4,150,000 Toman).
- **13. RTL Behaviour:** Text aligns to the right, trend arrow badge is placed on the logical left (logical end).
- **14. Animation:** Number increments smoothly from zero to the target value on screen load.
- **15. Future Expansion:** Prepared to support budget progress bar integrations.

---

### 13.6 Income Summary Card
- **1. Purpose:** Displays total cash inflows for the selected period.
- **2. Business Value:** Helps users track their earnings and recurring salary deposits.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Second position in Region 4's scorecard workspace.
- **5. Spacing:** Spaced using `bankyar.responsive.gutter` within the horizontal grid.
- **6. Typography:** Value styled with `bankyar.semantic.typography.display.lg` (green tint, monospace numerals).
- **7. Icons:** Green up-trending arrow icon.
- **8. Interaction:** Tapping navigates to the income-only filtered ledger view.
- **9. Loading:** Standard shimmering pulse.
- **10. Error:** Displays a dash indicator.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Uses colorblind-safe patterns and explicit text labels.
- **13. RTL Behaviour:** Layout is mirrored, with text aligned to the right.
- **14. Animation:** Standard value counter.
- **15. Future Expansion:** Prepared to support future salary date predictions.

---

### 13.7 Expense Summary Card
- **1. Purpose:** Displays total cash outflows for the selected period.
- **2. Business Value:** Highlights total spending, aiding in budget control.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Third position in Region 4's scorecard workspace.
- **5. Spacing:** Spaced using `bankyar.responsive.gutter`.
- **6. Typography:** Value styled with `bankyar.semantic.typography.display.lg` (primary red tint, monospace numerals).
- **7. Icons:** Crimson down-trending arrow icon.
- **8. Interaction:** Tapping navigates to the expense-only filtered ledger view.
- **9. Loading:** Standard shimmering pulse.
- **10. Error:** Displays a dash indicator.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Utilizes high-contrast colors and descriptive semantic tags.
- **13. RTL Behaviour:** Text aligns to the right, with the trend arrow on the left.
- **14. Animation:** Standard value counter.
- **15. Future Expansion:** Prepared to support budget threshold alerts.

---

### 13.8 Transaction Count Card
- **1. Purpose:** Displays the total number of transactions processed within the period.
- **2. Business Value:** Tracks financial activity levels.
- **3. Visual Priority:** Level 3.
- **4. Placement:** Fourth position in Region 4's scorecard workspace.
- **5. Spacing:** Spaced using `bankyar.responsive.gutter`.
- **6. Typography:** Value styled with `bankyar.semantic.typography.display.lg` (neutral, monospace numerals).
- **7. Icons:** Flat transaction receipt outline icon.
- **8. Interaction:** Tapping navigates to the complete chronological ledger.
- **9. Loading:** Standard shimmering pulse.
- **10. Error:** Displays a dash indicator.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Accessible label: "تعداد کل تراکنش‌ها پنجاه عدد است" (Total transaction count is 50).
- **13. RTL Behaviour:** Mirrored layout.
- **14. Animation:** Standard value counter.
- **15. Future Expansion:** Prepared to support automated SMS classification counters.

---

### 13.9 Average Transaction Value Card
- **1. Purpose:** Displays the average monetary value per transaction in the selected period.
- **2. Business Value:** Helps the user understand their typical purchase size.
- **3. Visual Priority:** Level 3.
- **4. Placement:** Fifth position in Region 4's scorecard workspace.
- **5. Spacing:** Spaced using `bankyar.responsive.gutter`.
- **6. Typography:** Value styled with `bankyar.semantic.typography.display.lg` (monospace numerals).
- **7. Icons:** Monochromatic math division symbol or scale icon.
- **8. Interaction:** Tapping navigates to a ledger filtered for average-range purchases.
- **9. Loading:** Standard shimmering pulse.
- **10. Error:** Displays a dash indicator.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Text scaling ensures no truncation occurs up to 200% magnification.
- **13. RTL Behaviour:** Mirrored layout.
- **14. Animation:** Standard value counter.
- **15. Future Expansion:** Prepared to support average spending by category.

---

### 13.10 Largest Transaction Card
- **1. Purpose:** Displays the single largest transaction amount recorded during the active period.
- **2. Business Value:** Instantly highlights major expenses or incomes.
- **3. Visual Priority:** Level 3.
- **4. Placement:** Sixth position in Region 4's scorecard workspace.
- **5. Spacing:** Spaced using `bankyar.responsive.gutter`.
- **6. Typography:** Value styled with `bankyar.semantic.typography.display.lg` (monospace numerals).
- **7. Icons:** Crown outline icon.
- **8. Interaction:** Tapping navigates to the detailed transaction inspector for this specific record.
- **9. Loading:** Standard shimmering pulse.
- **10. Error:** Displays a dash indicator.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Accessible label: "بزرگترین تراکنش دوره پنج میلیون و چهارصد هزار تومان است" (The largest transaction is 5,400,000 Toman).
- **13. RTL Behaviour:** Mirrored layout.
- **14. Animation:** Standard value counter.
- **15. Future Expansion:** Prepared to support predictive alerts for large recurring charges.

---

### 13.11 Daily Activity Chart
- **1. Purpose:** Visualizes daily cash outflow trends across the month using a Line/Area Chart.
- **2. Business Value:** Helps the user identify spending peaks and valleys over the month.
- **3. Visual Priority:** Level 1 (Primary visualization in Region 5).
- **4. Placement:** Interactive Viewport Canvas when "Daily Activity" is active.
- **5. Spacing:** Card padding is bound to `bankyar.space.md`.
- **6. Typography:** Axis labels styled with `bankyar.semantic.typography.body.md` using monospace digits.
- **7. Icons:** Segmented navigation tab icons.
- **8. Interaction:** Hovering over a node displays a floating tooltip with transaction details.
- **9. Loading:** A shimmering line graph skeleton pulses during calculation.
- **10. Error:** Renders the "Chart Error" state within the canvas.
- **11. Offline:** Chart data is computed locally.
- **12. Accessibility:** Features a colorblind-safe visual style. Slices and lines use high-contrast outlines and texture indicators.
- **13. RTL Behaviour:** Y-axis aligns to the logical start (right) and the line flows right-to-left.
- **14. Animation:** Line path draws smoothly from right to left on render.
- **15. Future Expansion:** Prepared to render predictive spending paths.

---

### 13.12 Weekly Activity Chart
- **1. Purpose:** Aggregates weekly spending habits using a Bar Chart.
- **2. Business Value:** Highlights specific days of the week (e.g., weekends) with higher spending.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Interactive Viewport Canvas when "Weekly Activity" is active.
- **5. Spacing:** Card padding matches `bankyar.space.md`.
- **6. Typography:** Weekday abbreviations styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Segmented tab icons.
- **8. Interaction:** Tapping a bar increases its contrast and displays a tooltip overlay.
- **9. Loading:** Shimmering bar indicators pulse during calculation.
- **10. Error:** Renders the "Chart Error" state.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Interactive touch envelopes exceed forty-eight units.
- **13. RTL Behaviour:** The bars are arranged from right to left (Saturday on the right, Friday on the left).
- **14. Animation:** Bars expand vertically upwards on load.
- **15. Future Expansion:** Prepared to compare current week data with past week baselines.

---

### 13.13 Monthly Activity Chart
- **1. Purpose:** Aggregates monthly income and expenses over the past six months using a Bar Chart.
- **2. Business Value:** Shows the user their long-term financial trajectory.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Interactive Viewport Canvas when "Monthly Activity" is active.
- **5. Spacing:** Card padding matches `bankyar.space.md`.
- **6. Typography:** Month names styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Segmented tab icons.
- **8. Interaction:** Tapping a monthly bar filters the dashboard date range to that month.
- **9. Loading:** Shimmering column indicators pulse during calculation.
- **10. Error:** Renders the "Chart Error" state.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Each bar has high-contrast separation.
- **13. RTL Behaviour:** Months progress from right to left.
- **14. Animation:** Bars expand vertically upwards.
- **15. Future Expansion:** Prepared to render budget compliance status per month.

---

### 13.14 Expense Distribution Chart
- **1. Purpose:** Visualizes expense percentages grouped by spending category using a Donut Chart.
- **2. Business Value:** Identifies where the majority of funds are allocated.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Interactive Viewport Canvas when "Expense Distribution" is active.
- **5. Spacing:** Card padding matches `bankyar.space.md`.
- **6. Typography:** Hollow center text styled with `bankyar.semantic.typography.title.sm` using monospace digits.
- **7. Icons:** Segmented tab icons.
- **8. Interaction:** Tapping a segment highlights it and focuses the associated legend item.
- **9. Loading:** A shimmering circular arc skeleton pulses during calculation.
- **10. Error:** Renders the "Chart Error" state.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Slices are separated by high-contrast division lines to prevent color bleeding.
- **13. RTL Behaviour:** Legends align to the left of the pie, flowing from right to left.
- **14. Animation:** Segment slices sweep clockwise on load.
- **15. Future Expansion:** Prepared to support sub-category drill-downs.

---

### 13.15 Income Distribution Chart
- **1. Purpose:** Visualizes income sources (e.g., salary, investment, transfer) using a Pie Chart.
- **2. Business Value:** Identifies primary cash inflow channels.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Interactive Viewport Canvas when "Income Distribution" is active.
- **5. Spacing:** Card padding matches `bankyar.space.md`.
- **6. Typography:** Text labels styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Segmented tab icons.
- **8. Interaction:** Tapping segment slices updates the underlying transaction ledger feed.
- **9. Loading:** Standard shimmering arc pulse.
- **10. Error:** Renders the "Chart Error" state.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Slices feature distinct texture patterns.
- **13. RTL Behaviour:** Legends are aligned on the right.
- **14. Animation:** Standard clockwise sweep.
- **15. Future Expansion:** Prepared to support tax allocation tracking.

---

### 13.16 Transaction Categories Chart
- **1. Purpose:** Renders active transaction counts by category using a Bar Chart.
- **2. Business Value:** Shows the frequency of purchases across categories.
- **3. Visual Priority:** Level 3.
- **4. Placement:** Interactive Viewport Canvas when "Categories" is active.
- **5. Spacing:** Card padding matches `bankyar.space.md`.
- **6. Typography:** Category titles styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Category-specific vector icons (e.g., shopping cart, taxi).
- **8. Interaction:** Tapping a bar filters the ledger view to show transactions in that category.
- **9. Loading:** Standard column shimmer.
- **10. Error:** Renders the "Chart Error" state.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Contrast ratio meets standard guidelines.
- **13. RTL Behaviour:** Mirrored layout.
- **14. Animation:** Columns expand horizontally from right to left.
- **15. Future Expansion:** Prepared to integrate automated category rule suggestions.

---

### 13.17 Most Active Banks List / Chart
- **1. Purpose:** Renders transaction density by bank account using a Pie Chart.
- **2. Business Value:** Identifies which bank accounts handle the highest volume of transactions.
- **3. Visual Priority:** Level 3.
- **4. Placement:** Interactive Viewport Canvas when "Bank Dist" is active.
- **5. Spacing:** Card padding matches `bankyar.space.md`.
- **6. Typography:** Bank names styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Bank logo vector icons.
- **8. Interaction:** Tapping a bank segment displays bank account statistics and details.
- **9. Loading:** Standard shimmering arc.
- **10. Error:** Renders the "Chart Error" state.
- **11. Offline:** Calculations run locally.
- **12. Accessibility:** Each bank segment uses unique color and texture pairings.
- **13. RTL Behaviour:** Mirrored layout.
- **14. Animation:** Slices sweep clockwise.
- **15. Future Expansion:** Prepared to track card expiration dates.

---

### 13.18 Top Spending Days Insight
- **1. Purpose:** Highlights the highest-spending days of the week in Region 6.
- **2. Business Value:** Identifies weekly spending peaks, helping users plan their budgets.
- **3. Visual Priority:** Level 2 (High visibility inside Region 6).
- **4. Placement:** First position in Region 6's insights feed.
- **5. Spacing:** Top and bottom margins match `bankyar.space.sm`.
- **6. Typography:** Content styled with `bankyar.semantic.typography.body.md` using monospace digits.
- **7. Icons:** Red down-trending arrow icon.
- **8. Interaction:** Tapping the insight card filters the transaction ledger by the highlighted weekday.
- **9. Loading:** Shimmering skeleton cards pulse during calculation.
- **10. Error:** Hides the card from the feed.
- **11. Offline:** Insights are calculated locally.
- **12. Accessibility:** Accessible label: "پرخرج‌ترین روز هفته پنج‌شنبه‌ها با میانگین یک میلیون و دویست هزار تومان خرید روزمره است" (Highest spending day is Thursday with an average of 1,200,000 Toman in daily spending).
- **13. RTL Behaviour:** Text aligns to the right, icon is placed on the logical right edge.
- **14. Animation:** Insight cards fade and slide upwards sequentially on screen load.
- **15. Future Expansion:** Prepared to support AI-driven budgeting advice.

---

### 13.19 Top Income Days Insight
- **1. Purpose:** Highlights the days of the week with the highest incomes in Region 6.
- **2. Business Value:** Identifies when liquidity is highest, helping users time their bills.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Second position in Region 6's insights feed.
- **5. Spacing:** Top and bottom margins match `bankyar.space.sm`.
- **6. Typography:** Content styled with `bankyar.semantic.typography.body.md` using monospace digits.
- **7. Icons:** Green up-trending arrow icon.
- **8. Interaction:** Tapping the card filters the ledger by the highlighted weekday.
- **9. Loading:** Shimmering skeleton cards pulse during calculation.
- **10. Error:** Hides the card from the feed.
- **11. Offline:** Insights are calculated locally.
- **12. Accessibility:** Fully colorblind-safe styling.
- **13. RTL Behaviour:** Text aligns to the right, icon is on the logical right.
- **14. Animation:** Sequenced fade-in transition.
- **15. Future Expansion:** Prepared to track recurring invoice payments.

---

### 13.20 Recent Financial Insights Feed
- **1. Purpose:** Displays automated, on-device behavioral highlights below the charts.
- **2. Business Value:** Provides users with insights into their spending habits without manual analysis.
- **3. Visual Priority:** Level 2.
- **4. Placement:** Region 6 of the scrolling workspace.
- **5. Spacing:** Spaced using `bankyar.space.md` below Region 5.
- **6. Typography:** Section header styled with `bankyar.semantic.typography.title.sm`.
- **7. Icons:** Compass or bulb outline icon for the section header.
- **8. Interaction:** Vertical scroll allows users to scan available insights.
- **9. Loading:** Transparent skeleton blocks pulse from right to left.
- **10. Error:** Displays a localized inline error card.
- **11. Offline:** Insights are processed locally.
- **12. Accessibility:** Contrast ratio is maintained above 4.5:1 across all elements.
- **13. RTL Behaviour:** Layout and text flow from right to left.
- **14. Animation:** Feed elements slide up smoothly on screen load.
- **15. Future Expansion:** Prepared to integrate on-device personal financial coaching alerts.

---

### 13.21 Export Entry (Future)
- **1. Purpose:** Triggers a bottom sheet to export financial reports locally.
- **2. Business Value:** Allows users to back up their data securely or analyze it on other devices.
- **3. Visual Priority:** Level 1.
- **4. Placement:** Top App Bar (Region 1, logical left end).
- **5. Spacing:** Touch envelope matches `bankyar.space.xl`.
- **6. Typography:** Bottom sheet text styled with `bankyar.semantic.typography.body.md`.
- **7. Icons:** Document export vector icon.
- **8. Interaction:** Tapping opens a bottom sheet offering local CSV or PDF export.
- **9. Loading:** A circular progress indicator replaces the icon during file generation.
- **10. Error:** Outlines the bottom sheet container with a red border if generation fails.
- **11. Offline:** File generation runs completely on-device.
- **12. Accessibility:** Fully compatible with screen readers.
- **13. RTL Behaviour:** Bottom sheet text flows from right to left.
- **14. Animation:** Bottom sheet slides up vertically on tap.
- **15. Future Expansion:** Prepared to support encrypted cloud backups.

---

## 14. Accessibility & Inclusive Design Blueprint (Deliverable 11)

### Accessibility Philosophy
We believe that personal finance tools should be accessible to everyone, regardless of physical or cognitive abilities. BankYar's dashboard design removes visual barriers, reduces cognitive load, and supports system accessibility features natively.

### Inclusive Design Principles
1. **Multi-Sensory Feedback:** Financial states must never be conveyed by color alone. Every visual cue is paired with a text label, icon, or unique tactile haptic buzz.
2. **Flexible Interaction:** Tap targets are generously sized to assist users with fine motor control issues or visual impairments.
3. **Cognitive Calmness:** Layout structures are clean and logical, avoiding rapid shifts or high-contrast pulsing elements that cause anxiety.

### Accessibility Goals
- Full compliance with WCAG 2.1 AA and AAA standards.
- 100% compatibility with screen readers (TalkBack on Android).
- Seamless readability at 200% system font magnification.

### User Personas with Disabilities
- **Aria (Visual Impairment - Red-Green Colorblindness):** Aria cannot distinguish between green income lines and red expense lines. The dashboard supports her by using distinct dashed line styles and explicit text indicators (`+` / `-`).
- **Behnam (Motor Impairment - Fine Motor Control):** Behnam has difficulty tapping small screen controls. Generous touch envelopes (minimum 48 units) help him navigate the dashboard without accidental taps.
- **Soraya (Cognitive Impairment - High Stress):** Complex, cluttered financial reports cause Soraya anxiety. The dashboard's minimal design, clear spacing, and clean hierarchy allow her to focus on key metrics without feeling overwhelmed.

---

### Vision Accessibility
- **Low Vision Strategy:** The dashboard maintains high-contrast typography, with a minimum contrast ratio of 7:1 for body text and 4.5:1 for headings and metrics.
- **Color Blind Strategy:** Slices in Pie and Donut charts are bounded by high-contrast border lines (`bankyar.semantic.color.surface.default`), preventing adjacent color zones from merging. Distinct text patterns, stippling, or geometric dots are used on chart segments.
- **High Contrast Strategy:** Dynamic high-contrast theme adjustments map to deep black backdrops and bright white outlines for users with severe vision loss.
- **Large Text Strategy:** All text containers utilize vertical auto-wrapping and dynamic paddings, preventing overlapping lines or text clipping at high font sizes.
- **Dynamic Text Scaling:** Typography scales proportionally with system font sizes up to 200% magnification.

---

### Screen Reader Support
- **Semantic Labels Strategy:** Symmetrical analytical components declare explicit helper descriptors. Screen reader reads: *"نمودار دایره‌ای هزینه‌ها: خرید روزمره با ۴۰ درصد بیشترین ميزان هزینه دوره جاری می‌باشد."* (Donut expense chart: Daily spending represents 40% of current period expenses).
- **Reading Order Rules:** Interactive items are read in logical sequence, progressing from top-right to bottom-left (RTL).
- **Focus Order Rules:** Interactive focuses follow the natural reading flow, starting at the search bar and moving sequentially through the date selector, filters, cards, and charts.

---

### Keyboard Navigation & Access Support
- **Keyboard Navigation:** The dashboard supports system-wide keyboard controls, allowing users to navigate and interact with elements using standard directional keys.
- **Switch Access Support:** Interactive controls map to native system switch access interfaces, allowing users with motor impairments to navigate using external switches.
- **Voice Access Support:** Active touch controls declare explicit spoken identifiers (e.g., "دکمه تغییر تاریخ" for the date selector) to assist users of hands-free voice control software.

---

### Touch & Motion Accessibility
- **Touch Target Guidelines:** Every interactive trigger (navigation bars, date select arrows, filter chips, action items) maintains a minimum vertical touch target height of forty-eight units, mapped to the `bankyar.space.xl` token.
- **Gesture Alternatives:** Multi-touch gestures (such as swiping to change chart tabs) are paired with simple tap alternatives (Segmented Navigation tabs).
- **Motion Sensitivity:** Users can disable non-essential animations, ensuring a comfortable experience for individuals prone to motion sickness.
- **Reduced Motion Rules:** When the system's "Reduced Motion" flag is active, transitions and expansions are simplified to immediate opacity fades.

---

### Cognitive Accessibility
- **Memory Load Reduction:** Complex data points are grouped into six simple scorecard metrics, reducing the need for users to remember historical transaction details.
- **Error Prevention:** Interactive sliders, calendar select sheets, and dropdown choices are used instead of manual text inputs to prevent data-entry mistakes.
- **Error Recovery:** When issues occur, inline alert components offer clear recovery paths and retry buttons to guide the user back.

---

### Financial Data Readability
- **Number Accessibility:** The dashboard uses monospace Persian numerals for financial figures, keeping decimal points aligned and making values easy to read.
- **Chart Accessibility:** Interactive data points are supported by tabular list legends below, ensuring the data is readable in text format.
- **Form Accessibility:** Text inputs utilize floating, persistent label indicators, maintaining context even after characters are entered.
- **Search Accessibility:** Active searches provide a clear, high-contrast button to quickly purge queries and return to the default dashboard view.
- **Notification Accessibility:** In-app status banners use high-contrast text and are announced to screen readers on launch.
- **Dialog Accessibility:** Modal sheets and dialog blocks capture accessibility focus on launch, preventing screen readers from reading background content.
- **Navigation Accessibility:** The persistent navigation shell highlights active tabs with both a text label and a background pill backdrop, ensuring clarity.

---

### RTL & Localization Accessibility
- **RTL Accessibility:** Chevrons, arrows, progress bars, and scrolling lists mirror dynamically to match the Persian reading flow.
- **Localization Accessibility:** Date formats, currencies, and numbers are localized, aligning with cultural standards in Persian-speaking regions.

---

### Accessibility Token Mapping
Every accessibility-related visual property is bound to a specific design token to ensure long-term consistency:

| Accessible Property | Spacing Metric | Design Token Path |
| :--- | :--- | :--- |
| Minimum Tap Target | 48 Units Height | `bankyar.space.xl` |
| Text Contrast Ratio | 4.5:1 Minimum | `bankyar.semantic.color.contrast.medium` |
| Text Contrast Ratio | 7:1 High | `bankyar.semantic.color.contrast.high` |
| Line Separation | Thin Gaps | `bankyar.border.width.thin` |
| Corner Bounds | Curvature | `bankyar.radius.medium` |

---

### Accessibility Testing Strategy
- **Manual Testing Checklist:** Perform testing using native screen readers (TalkBack on Android) to verify reading order, semantics labels, and focus targets.
- **Automated Testing Strategy:** Integrate automated accessibility analyzers into the pre-commit pipeline to verify text contrast ratios, touch target sizes, and focus parameters.
- **Accessibility Governance:** No design update may proceed to implementation without a passing review from the accessibility compliance board.
- **Accessibility Review Process:** Design changes must be verified against WCAG standards using real-world testing on physical devices with native screen readers active.

---

### Anti-pattern Catalog
- **Color-Only Statuses:** Avoid using green or red colors without accompanying text labels or icon markers.
- **Small Targets:** Avoid using touch targets smaller than 48 units vertically.
- **Truncated Text:** Avoid using static text container bounds that clip long Persian labels when system font scaling is active.

---

### Compliance Matrix
The dashboard's design elements map directly to WCAG success criteria to ensure compliance:

| Dashboard Element | WCAG Criteria | Compliance Status |
| :--- | :--- | :--- |
| Metric Contrast | 1.4.3 Contrast (Minimum) | Fully Compliant (>= 7:1) |
| Monospace Metrics | 1.4.4 Resize Text | Fully Compliant (wraps up to 200%) |
| Screen Readers | 1.1.1 Non-text Content | Fully Compliant (explicit labels) |
| Symmetrical Layout | 1.3.2 Meaningful Sequence | Fully Compliant (RTL native) |

---

### Future Evolution Strategy
The accessibility architecture is designed to support upcoming features, such as personalized high-contrast modes, dynamic voice commands, and compatibility with external braille displays.

---

## 15. RTL Native Design Review (Deliverable 12)

The dashboard is designed RTL-first to ensure a natural reading experience for Persian-speaking users.

### RTL Parameters:
- **Visual Progression:** Elements are organized from top-right (logical start) to bottom-left (logical end).
- **Navigation Mirroring:** Date-navigation arrows are mirrored (right arrow shifts back, left arrow shifts forward), matching the timeline of the Persian solar calendar.
- **Horizontal Carousels:** Scrolling lists and filter rows start on the right margin and scroll left.
- **Chart Layouts:** Chart axes are mirrored, placing Y-axis monetary scales on the right and flowing chronological trends from right to left.
- **Punctuation Alignment:** Decimals, percentages, and currencies are localized to align correctly with Persian text strings.

---

## 16. Visual Consistency Checklist (Deliverable 13)

- [ ] All colors reference semantic tokens (`bankyar.semantic.color.background.canvas`, `bankyar.semantic.color.surface.default`, etc.). No hardcoded HEX codes are used.
- [ ] Spacing values match multiples of the base spacing unit (`bankyar.global.space.base`).
- [ ] Interactive touch targets maintain a minimum vertical height of forty-eight units, mapped to the `bankyar.space.xl` token.
- [ ] Card corners are bound to the `bankyar.radius.medium` token, and filter chips use `bankyar.radius.full`.
- [ ] Financial metrics use monospace Persian numerals to ensure readable digit alignments.
- [ ] Text styles use defined typography tokens (`bankyar.semantic.typography.heading.md`, `bankyar.semantic.typography.body.md`, etc.).
- [ ] Slices in Pie and Donut charts are bounded by high-contrast border lines (`bankyar.semantic.color.surface.default`).
- [ ] Active and inactive component states match the designs specified in the visual state tables.

---

## 17. UX Validation Checklist (Deliverable 14)

- [ ] The dashboard operates completely offline, requiring zero network permissions.
- [ ] Key financial metrics are organized logically, allowing users to scan their status in under 5 seconds.
- [ ] Interactive charts are supported by text legends below, ensuring they remain readable without color perception.
- [ ] High-contrast, colorblind-safe color pairings are used for charts and trend badges.
- [ ] Empty and error states provide clear, actionable instructions and retry buttons.
- [ ] Screen readers can navigate the layout in a logical sequence (RTL).
- [ ] Responsive layouts adapt smoothly across Phone, Large Phone, Tablet, and Foldable viewports.
- [ ] The design contains no placeholders, TODOs, or empty sections.

---
**End of Specification Document**
