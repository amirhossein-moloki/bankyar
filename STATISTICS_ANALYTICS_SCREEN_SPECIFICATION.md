# BankYar Statistics & Analytics Dashboard Screen Specification (v1.0.0)
## High-Fidelity UI Design Specification for Production-Ready Implementation

**Project Name:** BankYar
**Framework Target:** Flutter (Code-Agnostic Design Blueprint)
**Platform Target:** Android (RTL-Native Layout)
**Visual Style:** Material Design 3 (MD3)
**Primary Language & Locale:** Persian (RTL, Solar Hijri Calendar)
**Classification:** Product & Engineering UI Specification

---

## 1. Design Philosophy & Vision

The BankYar Statistics & Analytics Dashboard is an offline-first, private personal finance analytical command center. Its purpose is to transform raw, parsed on-device financial transaction data into high-precision visual insights. Operating with zero network permissions, the dashboard guarantees absolute security while presenting complex cash flow behaviors in a calm, stress-reducing, and highly intuitive format.

In strict compliance with BankYar's visual design standards:
- **Zero Framework Code:** All layouts, hierarchies, and components are defined without direct code structures or classes.
- **Zero Raw Styling Metrics:** Physical measurements (such as physical pixels, density-independent pixels, or scale-independent typography units) are strictly omitted. All spacing, rounded corners, borders, and typography scales map directly to abstract design tokens.
- **Zero Hardcoded Colors:** All color definitions reference semantic color tokens that adapt dynamically between themes.
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

## 3. Screen Layout & Structural Regions

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

---

## 4. Region 1: Top App Bar, Search, Export & Share (Logical Controls)

The Top App Bar remains pinned at the top of the viewport, serving as the screen's main control center.

### 4.1 Composition & RTL Flow
- **Logical Start Edge (Right):** Search toggle icon and circular search input expansion anchor.
- **Center:** Screen title "آموزش و آمار مالی" (Financial Analytics & Education) styled with the `bankyar.semantic.typography.heading.md` typography token.
- **Logical End Edge (Left):** Symmetrical horizontal grouping of action buttons:
  - **Share Action Button:** Localized share icon (export graph/summary) styled with `bankyar.semantic.color.icon.primary` token.
  - **Export Action Button:** Localized document export icon (generate offline CSV/PDF report) styled with `bankyar.semantic.color.icon.primary` token.

### 4.2 Visual Styles
- **Container Base:** Transparent base that blends with the canvas background. When content scrolls underneath, a subtle dividing hairline (`bankyar.semantic.color.border.subtle`) appears.
- **Height:** Scaled to the `bankyar.space.xxl` token.
- **Touch Target:** Minimum touch envelope is bound to the `bankyar.space.xl` token, guaranteeing an active tap height of at least forty-eight units.

### 4.3 Search Input Box Expansion
- **Interaction:** Tapping the search icon smoothly expands the search input field from the logical start corner (right) to overlay the app bar horizontally.
- **Style:** Outlined input box with standard rounded boundary mapped to `bankyar.radius.full` and filled with `bankyar.semantic.color.surface.default`.
- **Hint Guide Copy:** "جستجو در دسته‌بندی‌ها، بانک‌ها و یادداشت‌ها..." (Search categories, banks, and notes...) in Persian.
- **Logical End (Left) inside Search Bar:** A clear button (cross mark icon) appears to purge active query inputs instantly.

### 4.4 Export and Share Bottom Sheet Triggers
- **Export Trigger:** Tapping the Export button slides up a modal selection sheet from the bottom:
  - Header: "خروجی گرفتن از گزارش‌های مالی" (Export Financial Reports).
  - List items: "خروجی اکسل (CSV)" (Excel Export) and "خروجی گزارش تصویری (PDF)" (Visual PDF Report).
  - Note: "تمامی فرآیندهای فشرده‌سازی و ایجاد فایل خروجی، ۱۰۰٪ آفلاین و بر روی دستگاه شما انجام می‌شوند." (All report generation processes run 100% offline on your device).
- **Share Trigger:** Tapping the Share button prepares an encrypted PNG snapshot of the dashboard summaries (excluding PII) and invokes the native system sharing drawer.

---

## 5. Region 2: Date Range Selector & Custom Date Picker Overlay

The Date Range Selector allows users to modify the analytical time boundary of the displayed reports.

### 5.1 Physical Layout
- **Visual Composition:** Centered horizontal bar positioned below Region 1.
  - **Logical Start (Right Arrow):** Previous period chevron indicator `bankyar.icon.size.md` styled with secondary icon color. Tapping shifts the date range back.
  - **Center Text Trigger:** Active date string (e.g., "۱ آذر ۱۴۰۲ - ۳۰ آذر ۱۴۰۲") in display numeric style (`bankyar.semantic.typography.body.md` using monospace Persian digits).
  - **Logical End (Left Arrow):** Next period chevron indicator. Tapping shifts the date range forward.
- **Border:** Outlined card structure with curvature `bankyar.radius.medium` and boundary outline `bankyar.semantic.color.border.default`.

### 5.2 Date Picker Overlay (Bottom Sheet)
Tapping the center text trigger launches the Custom Date Picker Bottom Sheet:
- **Slide-up Animation:** Enforces the standard vertical motion curve sliding from the bottom.
- **Quick Shortcuts Grid:**
  - "امروز" (Today), "دیروز" (Yesterday)
  - "۷ روز اخیر" (Last 7 Days)
  - "۳۰ روز اخیر" (Last 30 Days)
  - "ماه جاری" (Current Month)
  - "سه ماه اخیر" (Last 3 Months)
- **Custom Calendar Range Selector:**
  - Displays a dual-month Solar Hijri grid starting from right to left.
  - Selected range is visually mapped with a continuous low-saturation primary background (`bankyar.semantic.color.selection.fill`).
  - Dates outside the range use secondary contrast text.

---

## 6. Region 3: Quick Filters Row (Bank & Transaction Type Filters)

A horizontally scrollable row of choice chips immediately below the date selector.

### 6.1 Layout & Reading Flow
- **Flow Direction:** Flows right-to-left. Excess chips overflow the inline margin boundary on the logical end (left).
- **Chip Padding:** Horizontal gap between chips matches the `bankyar.space.xs` token.

### 6.2 Filter Chips & Visual States
- **Filter Bank Selector:** Choice chips populated dynamically with registered on-device bank accounts:
  - "همه بانک‌ها" (All Banks)
  - "بانک ملی" (Melli Bank)
  - "بانک ملت" (Mellat Bank)
- **Filter Transaction Type Selector:**
  - "همه تراکنش‌ها" (All Transactions)
  - "درآمدها (ورودی)" (Incomes - Inflows)
  - "هزینه‌ها (خروجی)" (Expenses - Outflows)
- **Visual State Table:**

| Chip State | Background Fill | Border Outline | Text Typography | Leading Icon |
| :--- | :--- | :--- | :--- | :--- |
| **Selected** | `bankyar.semantic.color.action.primary` | `bankyar.semantic.color.border.active` | `bankyar.semantic.color.text.onaccent` (Bold) | Small checkmark symbol |
| **Unselected**| `bankyar.semantic.color.surface.default` | `bankyar.semantic.color.border.default` | `bankyar.semantic.color.text.secondary` (Regular) | None |
| **Pressed** | Element contrast shifts +2 steps | Highlight active focus | `bankyar.semantic.color.text.primary` | Symmetrical feedback indicator |
| **Disabled**| `bankyar.semantic.color.disabled.background`| `bankyar.semantic.color.border.default`| `bankyar.semantic.color.disabled.text` | None |

---

## 7. Region 4: Summary Cards Specification (6-Card Dashboard Core)

The dashboard presents six high-density summary metrics to summarize financial health over the selected timeframe.

```
+-------------------------------------------------------------------------+
| [Summary Card Container]                                                |
|                                                                         |
|  (Top-Start / Right)                               (Top-End / Left)     |
|  [Title Text]                                      [Trend Badge / Ind]  |
|  [bankyar.text.caption.medium]                     [Success/Error Tint] |
|                                                                         |
|  (Center / Display Metric)                                              |
|  [Primary Value / Monospace Digits]                                     |
|  [bankyar.text.display.large]                                           |
|                                                                         |
|  (Bottom-Start / Right)                            (Bottom-End / Left)  |
|  [Secondary Context Info]                          [Mini-Sparkline]     |
|  [Comparison with Previous Period]                 [Soft Vector Line]   |
+-------------------------------------------------------------------------+
```

### 7.1 Card 1: Net Balance Summary Card
- **Title:** "تراز خالص دریافتی" (Net Balance Received)
- **Primary Value:** `+۴,۱۵۰,۰۰۰ تومان` (Toman) with monospace Persian digits.
- **Secondary Info / Comparison:** "افزایش ۱۲٪ نسبت به ماه گذشته" (12% increase compared to last month).
- **Trend Indicator:** Upward arrow badge (`↑`) styled with green success text and success fill.
- **Mini Chart:** A flat 5-point mini sparkline showing the balance progression.
- **Status Color:** Bound to Success semantic token.
- **Accessibility Label:** "تراز خالص دریافتی شما مثبت چهار میلیون و صد و پنجاه هزار تومان است، دوازده درصد افزایش نسبت به ماه گذشته."

### 7.2 Card 2: Income Summary Card
- **Title:** "کل درآمدها (ورودی)" (Total Incomes - Inflow)
- **Primary Value:** `+۱۲,۴۰۰,۰۰۰ تومان`
- **Secondary Info / Comparison:** "۸ تراکنش ورودی ثبت شده" (8 registered inflow transactions).
- **Trend Indicator:** Symmetrical up-trending success indicator.
- **Mini Chart:** Mini bar-chart sparkline representing income deposits.
- **Status Color:** Success Semantic Token.
- **Accessibility Label:** "کل درآمدهای ورودی دوازده میلیون و چهارصد هزار تومان از هشت تراکنش."

### 7.3 Card 3: Expense Summary Card
- **Title:** "کل هزینه‌ها (خروجی)" (Total Expenses - Outflow)
- **Primary Value:** `-۸,۲۵۰,۰۰۰ تومان`
- **Secondary Info / Comparison:** "۴۲ تراکنش خروجی ثبت شده" (42 registered outflow transactions).
- **Trend Indicator:** Downward arrow badge (`↓`) styled with crimson error text and error fill.
- **Mini Chart:** Downward trend-line sparkline.
- **Status Color:** Error Semantic Token.
- **Accessibility Label:** "کل هزینه‌های خروجی منهای هشت میلیون و دویست و پنجاه هزار تومان از چهل و دو تراکنش."

### 7.4 Card 4: Transaction Count Card
- **Title:** "تعداد کل تراکنش‌ها" (Total Transaction Count)
- **Primary Value:** `۵۰ تراکنش`
- **Secondary Info / Comparison:** "۵٪ کاهش در فرکانس پیامک‌ها" (5% decrease in SMS frequency).
- **Trend Indicator:** Neutral gray horizontal dash badge.
- **Mini Chart:** Constant density histogram dots.
- **Status Color:** Neutral Mid Token.
- **Accessibility Label:** "تعداد کل تراکنش‌ها پنجاه عدد، پنج درصد کاهش در فرکانس پیامک‌ها."

### 7.5 Card 5: Average Daily Spending Card
- **Title:** "میانگین مخارج روزانه" (Average Daily Spending)
- **Primary Value:** `۲۷۵,۰۰۰ تومان`
- **Secondary Info / Comparison:** "کاهش ۱۵,۰۰۰ تومانی روزانه" (15,000 Toman decrease daily).
- **Trend Indicator:** Green downward arrow badge (meaning decreased daily spending, a positive indicator) with success semantic tone.
- **Mini Chart:** 7-day horizontal bar metric.
- **Status Color:** Success Semantic Token.
- **Accessibility Label:** "میانگین مخارج روزانه دویست و هفتاد و پنج هزار تومان، کاهش پانزده هزار تومانی در روز."

### 7.6 Card 6: Average Monthly Spending Card
- **Title:** "میانگین مخارج ماهیانه" (Average Monthly Spending)
- **Primary Value:** `۸,۲۵۰,۰۰۰ تومان`
- **Secondary Info / Comparison:** "ثبات نسبی در هزینه‌های ثابت" (Relative stability in fixed expenses).
- **Trend Indicator:** Neutral blue information badge.
- **Mini Chart:** 3-month flat baseline metric.
- **Status Color:** Info Semantic Token.
- **Accessibility Label:** "میانگین مخارج ماهیانه هشت میلیون و دویست و پنجاه هزار تومان با ثبات نسبی در هزینه‌های ثابت."

---

## 8. Region 5: Interactive Charts & Analytical Visualizations

The Interactive Charts area translates grouped financial metrics into responsive visualizations.

### 8.1 Chart Type Selection Row
A segmented control row allowing users to swap between the active visualization models:
- **Daily Activity** (Line/Area Chart)
- **Weekly Activity** (Bar Chart)
- **Monthly Activity** (Bar Chart)
- **Bank Distribution** (Pie Chart)
- **Expense Category** (Donut Chart - Future Ready)
- **Income vs Expense** (Area Chart Comparison)

---

### 8.2 Daily Activity Chart (Line & Area Chart)
- **Visual Structure:** Flat area line chart displaying daily cash outflow fluctuations.
- **Y-Axis Labels (Logical Start - Right):** Currency indicators scaled from zero to the maximum daily spending threshold in the period, displayed in monospace Persian digits.
- **X-Axis Labels (Bottom):** Sequential days of the month (e.g. "۱ دی", "۱۰ دی", "۲۰ دی", "۳۰ دی") aligned horizontally.
- **Visual Stroke Style:** Thin solid line (`bankyar.semantic.color.action.primary`) with a semi-transparent, flat, low-opacity fill beneath (`bankyar.semantic.color.selection.fill`). No glowing shadows.
- **Trend Indicators:** Upward green arrow or downward red arrow based on slope direction of the active period.

---

### 8.3 Weekly Activity Chart (Bar Chart)
- **Visual Structure:** 7-column vertical bar chart representing spending per weekday.
- **Bar Styling:** Outlined flat rectangular containers with curvature `bankyar.radius.small`.
- **Y-Axis Labels:** Aligned to the logical start edge (right).
- **X-Axis Labels:** Localized days of the week: "ش" (Saturday), "ی" (Sunday), "د" (Monday), "س" (Tuesday), "چ" (Wednesday), "پ" (Thursday), "ج" (Friday).
- **Interaction Feedback:** Tapping a bar shifts its contrast level by +2 steps, displaying an accessible tooltip floating above it.

---

### 8.4 Monthly Activity Chart (Bar Chart)
- **Visual Structure:** Multi-column vertical bar chart representing aggregations for the past six months.
- **Bar Styling:** Outlined rectangular pillars with relative height mapping.
- **Y-Axis Labels:** Symmetrically placed on the right (start) edge.
- **X-Axis Labels:** Localized Solar Hijri month abbreviations: "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند".
- **Interaction Feedback:** Slices update the ledger feed immediately to correspond to the clicked month.

---

### 8.5 Bank Distribution Chart (Pie Chart)
- **Visual Structure:** Multi-slice circular chart representing transaction density by bank.
- **Segment Separations:** Segment slices are separated by a high-contrast division ring (`bankyar.semantic.color.surface.default`), preventing adjacent color zones from merging.
- **Interactive Segment Touch:** Tapping any segment triggers a tactile micro-scale popout (1.02x scale expansion) and focuses the legend item.

---

### 8.6 Expense Category Chart (Donut Chart - Future Ready)
- **Visual Structure:** A flat, circular donut ring with a hollow center.
- **Legends (Logical End - Left):** Tabular list of categories stacked vertically:
  - "سوپرمارکت" (Supermarket) - 40%
  - "حمل و نقل" (Transport) - 30%
  - "پزشکی" (Medical) - 15%
  - "سایر" (Other) - 15%
- **Hollow Center Text:** Displays the total expense amount `۸,۲۵۰,۰۰۰ تومان` in monospace digits with a subtitle label "مخارج کل" (Total Expenses).

---

### 8.7 Income vs Expense Comparison (Area Chart Comparison)
- **Visual Structure:** Two overlapping line indicators.
  - **Income Area Line:** Green stroke with a very soft green opacity background fill.
  - **Expense Area Line:** Red/Primary stroke with a very soft grey/primary background fill.
- **Visual Cue:** Clear, flat circular markers highlight intersection points.

---

### 8.8 Chart State Visual Layouts

```
+-------------------------------------------------------------------------+
| [Chart Container Canvas]                                                |
|                                                                         |
|  (Default State)                (Empty State)            (Error State)  |
|  [Gridlines & Active Plot]     [Centered Vault Outline] [Crimson Border] |
|  [Touch Target Dot Highlights] [Empathetic Microcopy]   [Retry Trigger] |
+-------------------------------------------------------------------------+
```

- **Empty Chart State:**
  - **Visual:** Centered monochromatic line outline of a cash vault styled with `bankyar.icon.size.xl`.
  - **Headline:** "داده‌ای برای این نمودار وجود ندارد" (No data available for this chart).
  - **Supporting Text:** "با دریافت پیامک‌های جدید یا ثبت تراکنش دستی، نمودارها به صورت خودکار ترسیم می‌شوند." (As new SMS messages are received or manual entries are logged, charts will draw automatically).
- **Loading Chart State:**
  - **Visual:** Transparent skeleton graph layout. Symmetrical rectangular layout skeletons pulse smoothly from right to left using a semi-transparent shimmering pulse mask.
- **Error Chart State:**
  - **Visual:** Card boundaries painted with a thin error border (`bankyar.semantic.color.border.error`).
  - **Copy:** "خطا در بارگذاری نمودار. پایگاه داده امن دوره‌ای با مشکل موقت روبرو شد." (Error loading chart. The secure local database encountered a temporary issue).
  - **Action Button:** Center-aligned flat retry button labeled "بارگذاری مجدد نمودار" (Reload Chart).
- **Responsive Chart Rules:** Charts lock their aspect ratio (e.g., 16:9 for landscape, 4:3 for tablet, and dynamic vertical sizing for portrait phone screens) to prevent visual warping.

---

## 9. Region 6: Recent Financial Insights Feed

The insights panel provides automated, on-device analysis of transaction behaviors, displayed as high-density cards below the chart workspace.

### 9.1 Card 1: Top Spending Day
- **Icon:** Red arrow-down badge styled with error semantic tone.
- **Headline:** "پرخرج‌ترین روز هفته" (Highest Spending Day of the Week)
- **Content:** "پنج‌شنبه‌ها با میانگین ۱,۲۰۰,۰۰۰ تومان خرید روزمره." (Thursdays with an average of 1,200,000 Toman in daily spending).
- **Metadata:** "۵ تراکنش در هفته اخیر" (5 transactions in the past week).

### 9.2 Card 2: Top Receiving Day
- **Icon:** Green arrow-up badge styled with success semantic tone.
- **Headline:** "پردرآمدترین روز هفته" (Highest Receiving Day of the Week)
- **Content:** "شنبه‌ها با میانگین ۳,۵۰۰,۰۰۰ تومان واریز مستمر." (Saturdays with an average of 3,500,000 Toman in continuous deposits).
- **Metadata:** "واریز حقوق دوره جاری" (Current cycle salary deposit).

### 9.3 Card 3: Most Used Bank
- **Icon:** Bank vector logo avatar with `bankyar.icon.size.md`.
- **Headline:** "فعال‌ترین حساب بانکی شما" (Your Most Active Bank Account)
- **Content:** "بانک ملی ایران با ثبت ۳۲ تراکنش در این دوره." (Bank Melli Iran with 32 registered transactions this period).
- **Metadata:** "۶۴٪ از تراکنش‌های کل" (64% of total transactions).

### 9.4 Card 4: Highest Transaction
- **Icon:** Monochromatic crown icon.
- **Headline:** "بزرگترین تراکنش دوره" (Highest Transaction of the Period)
- **Content:** "برداشت مبلغ ۵,۴۰۰,۰۰۰ تومان بابت اجاره خانه." (Withdrawal of 5,400,000 Toman for rent payment).
- **Metadata:** "۲۵ آذر ۱۴۰۲ - بانک ملت" (Dec 16, 2023 - Mellat Bank).

### 9.5 Card 5: Lowest Transaction
- **Icon:** Monochromatic scale/balance icon.
- **Headline:** "کوچکترین تراکنش دوره" (Lowest Transaction of the Period)
- **Content:** "خرید مبلغ ۵,۰۰۰ تومان بابت کارمزد بانکی." (Purchase of 5,000 Toman for bank commission fee).
- **Metadata:** "۱۲ آذر ۱۴۰۲ - بانک ملی" (Dec 3, 2023 - Melli Bank).

---

## 10. Region 7: Persistent Navigation Shell

The shell navigation maintains standard layout positions at the bottom of the screen.

### 10.1 Tab Configuration (Right to Left / RTL Flow)
1. **دفترچه (Ledger Tab):** Mapped with standard flat ledger icon. Tapping navigates to chronological transaction feed.
2. **نمودارها (Analytics Tab - Active):** Highlighted with a filled analytical bar graph icon and a soft background indicator backdrop pill.
3. **تنظیمات (Settings Tab):** Mapped with a secure settings cog icon.

### 10.2 Navigation Rail (Tablet Adaptation)
- On wide viewports, the bottom navigation bar transitions smoothly to a lateral Navigation Rail positioned along the logical start edge (right), maintaining thumb reach.

---

## 11. Interactive State Visual Mapping

To provide instant visual and tactile confirmation, components modify their visual layers based on standard interaction states:

| Interactive State | UI Component Visual Representation | Transition Curve & Speed |
| :--- | :--- | :--- |
| **Default State** | Stable base visual representation using design tokens. | Baseline state |
| **Loading State** | semi-transparent shimmering pulse mask. Interactivity locked. | Linear opacity loop under `bankyar.motion.duration.medium` |
| **Refreshing** | Thin linear progress bar animated immediately below Top App Bar. | Smooth continuous loop |
| **Error State** | Boundaries repainted with `bankyar.semantic.color.border.error`. Inline alert. | Shake animation on horizontal axis on launch |
| **Offline State** | Green diagnostic status badge "کاملاً آفلاین" (Fully Offline) in app bar. | Continuous static badge |
| **Empty State** | Centered monochromatic graphic, headline, and primary manual trigger. | Fade-in on screen launch |
| **Filter Applied** | Active choice chip background fill, text color high contrast, check icon. | Smooth transition under `bankyar.motion.duration.fast` |
| **Chart Selected**| Slices highlighted, popout scale (1.02x), monospace legends focused. | Touch-down scale compression 0.98x |
| **Chart Hover (Tablet)**| Focused slice displays tooltip overlay with monospace data details. | Tooltip fade-in 150ms |
| **Date Range Changed**| Highlights the selected date range in bottom sheet. | Seamless container transition |

---

## 12. Responsive & Multi-Device Layout Matrix

The spatial grid adaptively rearranges based on system screen sizes to maintain a professional appearance.

### 12.1 Phone Viewport
- **Grid:** 4 Columns. Outer margins set to `bankyar.responsive.margin`.
- **Workspace Layout:** Single vertical scrolling feed. Summary cards are organized in a vertically scrollable 2-column grid. Interactive charts occupy the full inline width.

### 12.2 Large Phone Viewport
- **Grid:** 4 Columns.
- **Workspace Layout:** Summary cards are displayed in a horizontal carousel, saving vertical space for charts and insights.

### 12.3 Tablet Viewport
- **Grid:** 8 Columns.
- **Layout Split:**
  - **Logical Start (Right Pane - Spans 4 Columns):** Visual interactive charts and the chart legends.
  - **Logical End (Left Pane - Spans 4 Columns):** Six high-density Summary Cards and the Recent Financial Insights feed.
- **Navigation:** Navigation Rail pinned along the logical start margin (right edge).

### 12.4 Foldable Viewport
- **Dual-Pane Adaptation:** The physical hinge splits the viewport.
  - **Right Fold (Logical Start):** The interactive charts and category selectors.
  - **Left Fold (Logical End):** Summary Cards and the Recent Financial Insights panel.
  - Visual components adjust their margins to clear the crease fold.

### 12.5 Landscape Viewport
- **Layout Optimization:** Horizontal layouts reduce chart heights to 16:9 ratio to prevent pushing control headers off-screen. Summaries and filters stack side-by-side.

---

## 13. Accessibility & Inclusive Design Blueprint

The Statistics Dashboard enforces a comprehensive accessibility checklist to support users with diverse abilities:

### 13.1 RTL Native Layout Flow
- Text, horizontal carousels, lists, and form elements progress naturally from right to left (RTL).
- Chevrons and progress bars mirror dynamically to match the Persian reading flow.

### 13.2 Screen Reader Semantic Mapping
- Charts use accessible semantic descriptions: *"نمودار دایره‌ای هزینه‌ها: خرید روزمره با ۴۰ درصد بیشترین ميزان هزینه دوره جاری می‌باشد."* (Donut expense chart: Daily spending represents 40% of current period expenses).
- Icons use explicit helper attributes (e.g. `semanticsLabel: "تغییر دوره زمانی"` for date range controls).

### 13.3 Dynamic Font Scaling
- All text styles expand proportionally with system font sizes up to 200% magnification.
- Layout blocks use vertical auto-wrap and dynamic padding adjustments, preventing overlapping lines or text clipping.

### 13.4 Color Blind Safe Charts
- Meaning must never be conveyed solely by color.
- Slices in Pie and Donut charts are bounded by high-contrast border lines (`bankyar.semantic.color.surface.default`), preventing adjacent color zones from merging.
- Slices include explicit geometric texture overlays (e.g. diagonal stripes, stipple patterns, and dots) and direct tabular legends, ensuring data remains legible without color perception.

### 13.5 Minimum Touch Target Dimensions
- All interactive triggers (navigation bars, date select arrows, filter chips, action items) maintain a minimum vertical touch target height of forty-eight units, mapped to the `bankyar.space.xl` token.

### 13.6 Accessible Legends & Tooltips
- Legends are presented as high-density vertical lists using monospace digits to align percentages.
- Interactive chart tooltips fade in centrally, showing high-contrast contrast text against a solid neutral background, and are announced clearly by system screen readers.

---

## 14. Future-Ready Architecture & Expansion Zones

The dashboard includes spatial hooks and token maps to support upcoming personal finance features:

- **AI Spending Analysis Hook:** Reserved spatial slot in Region 6 to display on-device financial coaching recommendations (e.g., "تخمین هوشمند مخارج ماه آینده بر اساس روند تراکنش‌های اخیر") without altering the screen grid.
- **Budget Tracking Progress Indicator:** Pre-allocated space directly below summary cards to display visual progress bars representing category budgets.
- **Savings Goals Integration:** Standard container bounds designed to support savings progress donuts.
- **Recurring Payments & Subscription Detection:** Symmetrical columns prepared to list automated subscription bills.
- **Predictive Analytics Workspace:** Area chart structures designed to render future spending predictions.
- **Financial Health Score Radial:** A circular metric gauge reserved in Region 4 to show the user's score.
- **Investment Tracking Support:** Tabular layouts ready to display on-device portfolio balances.
- **Multi-Currency Toggle:** Space allocated in Region 2 to support currency selectors (e.g., USD, EUR, IRR) in future versions.

---

## 15. Design Token Mapping Reference

Every visual property specified in this document maps directly to an active design token, preserving long-term visual consistency:

| Screen Element | Visual Attribute | Design Token Path |
| :--- | :--- | :--- |
| Canvas Background | Base Background Fill | `bankyar.semantic.color.background.canvas` |
| Primary Container Card | Card Background Fill | `bankyar.semantic.color.surface.default` |
| Active Focus Outlines | Outline Highlight | `bankyar.semantic.color.border.active` |
| Text: Primary Metric | Large Display Typography | `bankyar.semantic.typography.display.lg` |
| Text: Section Title | Bold Subtitle Typography | `bankyar.semantic.typography.title.sm` |
| Text: Monospace Digits | Monospace Body Typography | `bankyar.semantic.typography.body.md` |
| Spacing: Gaps & Margins | Layout Spacing Factor | `bankyar.space.md` |
| Card Corner Curvatures | Rounded Corners | `bankyar.radius.medium` |
| Chip Corner Curvatures | Full Rounded Corners | `bankyar.radius.full` |
| Divider Widths | Subtle Line Thickness | `bankyar.border.width.thin` |
| Touch Target Envelopes | Active Tap Height | `bankyar.space.xl` |

---
**End of Specification Document**
