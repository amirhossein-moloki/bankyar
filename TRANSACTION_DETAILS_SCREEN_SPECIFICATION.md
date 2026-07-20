# BankYar Transaction Details Screen Specification (v1.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, Senior UX Architect, Flutter UI Architect, Material Design 3 Expert, Financial Dashboard Specialist, Enterprise Design System Consultant
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Transaction Details Screen is a specialized, deep-feature interface designed to provide comprehensive visual clarity, administrative control, and organization for a single financial transaction. Operating natively in **Persian (RTL)** under an uncompromising **offline-first, zero-network privacy constraint**, this screen transforms raw, fragmented SMS alerts into structured, high-fidelity financial ledger entries.

This screen is built strictly upon **Material Design 3 (MD3)** design systems and is engineered to reduce financial anxiety by providing immediate verification of transaction legitimacy, custom annotation inputs, localized status indicators, and intelligent security transparency.

---

## Screen Blueprint & Spatial Mapping

The Transaction Details Screen is constructed using the logical three-zone vertical layout model. Horizontal reading paths, vertical grids, and interactive touch triggers mirror natively to support Persian RTL workflows.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY HEADER & CONTEXT CONTROLS]                             |
|  +-------------------------------------------------------------------+  |
|  | [More Options]  [Export]  [Share]           [Favorite]   [Back chevron] |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE DETAILED WORKSPACE]                                 |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [1. Bank Identity Section]                                       |  |
|  |     [Bank Logo Avatar] Mellat Bank (Bank Name)                    |  |
|  |     Source: Parsed SMS                                            |  |
|  |                                                                   |  |
|  |  [2. Transaction Summary Card]                                    |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | Amount Highlight: -120,000 Tomans                     |     |  |
|  |     | Transaction Type Badge: Outflow / Expense             |     |  |
|  |     | Masked Account: Mellat Card **** 5678                 |     |  |
|  |     | Status: Successful Transaction                        |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [3. Date & Time Section]                                         |  |
|  |     Date: ۱۴۰۲/۱۰/۱۲   |   Time: ۱۴:۳۲                            |  |
|  |                                                                   |  |
|  |  [4. Reference & Merchant Section]                                |  |
|  |     Reference Number: 987654321012 [Copy Action]                  |  |
|  |     Merchant: Snapp Taxi [Category Icon]                          |  |
|  |                                                                   |  |
|  |  [5. Transaction Description]                                     |  |
|  |     "پرداخت قبوض و خدمات اسنپ"                                    |  |
|  |                                                                   |  |
|  |  [6. User Note Section]                                           |  |
|  |     Note: Taxi ride to office.                                    |  |
|  |     [Edit Note Action Button]                                     |  |
|  |                                                                   |  |
|  |  [7. Tags Section (Future-Ready)]                                 |  |
|  |     [Transport] [Business] [Daily Expense] [+ Add Tag]            |  |
|  |                                                                   |  |
|  |  [8. Attachments Section (Future-Ready)]                          |  |
|  |     [Receipt Image Preview Slot / OCR Extractions]                |  |
|  |                                                                   |  |
|  |  [9. Security Information Shield]                                 |  |
|  |     "Encrypted Locally on Device | No Network Access"             |  |
|  |                                                                   |  |
|  |  [10. Metadata Section]                                           |  |
|  |      Confidence Level: 100% | Matched Rule ID: Mellat-04          |  |
|  |                                                                   |  |
|  |  [11. Related Transactions Feed (Future-Ready)]                   |  |
|  |      - Prev Ride (Yesterday): -15,000 Tomans                      |  |
|  |      - Prev Ride (3 days ago): -15,000 Tomans                     |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: STICKY DESTRUCTIVE & CONFIRMATION ACTIONS]                     |
|  +-------------------------------------------------------------------+  |
|  |   [Delete Action Button]           [Confirm / Verify Transaction] |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

---

## Core Specification Deliverables

### 1. Screen Purpose
The Transaction Details Screen provides a dedicated, focused inspection environment for individual parsed transactions. Its primary objective is to decompose high-complexity banking text messages into organized, legible metadata fields, enabling users to verify, annotate, categorize, and archive their financial actions with absolute confidence.

### 2. Business Objectives
* **Increase Ledger Accuracy:** Facilitate easy correction and manual verification of parsed heuristic patterns, boosting overall database precision.
* **Cultivate Local Security Trust:** Reinforce the offline-first message directly through security shield components, showcasing the safety of the on-device vault.
* **Eliminate Information Loss:** Offer a permanent archive of transaction records, notes, and receipt structures, functioning as a robust personal audit trial.

### 3. User Goals
* **Inspect Key Metrics:** Instantly review exact transacted amounts, transacting entities (Sender/Receiver), and original bank cards.
* **Add Custom Annotations:** Write local text notes and associate searchable category tags for streamlined querying.
* **Verify Heuristics:** Confirm low-confidence automated SMS parses, converting warning-state entries into verified ledger items.
* **Perform Administrative Maintenance:** Safe export of specific receipts or the deletion of double-parsed or erroneous items.

### 4. Entry Points
* **Dashboard Ledger Row Tap:** Clicking any transaction card on the main chronological feed transitions directly to this detail screen.
* **System Notification Tap:** Clicking an incoming parsed banking SMS notification launches the application and opens this details card directly.
* **Analytics Category Feed Drilldown:** Clicking a transaction item within specialized statistics or category breakdown views segues to this screen.

### 5. Exit Points
* **Top App Bar Back Navigation:** Returns the user to their immediate previous view (Dashboard feed, search results, or analytics views).
* **System Back Gesture:** Standard device back motion returns user to the preceding visual context.
* **Transaction Deletion:** Completing a deletion flow removes the record from the local database and returns the user to the active chronological ledger.

### 6. Navigation Behaviour
* **Right-to-Left Slide Transitions:** Entering the screen triggers a smooth horizontal slide from the logical start edge (right) to the logical end edge (left).
* **Self-Contained Bottom Sheets:** Triggering editing or deletion tasks expands modal overlays upwards from Zone C, avoiding jarring fullscreen jumps.
* **Scroll-Preserving Dismissal:** Returning to the dashboard feed preserves the list's exact scroll offset, preventing visual disorientation.

### 7. Information Hierarchy
* **Primary Visual Tier:** Amount Highlight, transacted currency, and Transaction Type Badge, located inside the main summary card in Zone B.
* **Secondary Visual Tier:** Bank identity, merchant name, localized Solar Hijri timestamps, and masked card numbers.
* **Tertiary Visual Tier:** User notes, category chips, raw description strings, and attachment previews.
* **Contextual Meta Tier:** Security indicator text, parsing confidence percentages, and rule indexing identifiers.

### 8. Screen Layout Structure
* **Zone A (Sticky App Bar):** Contains the primary navigation back action, favorite toggle, action overrides (Share, Export), and a secondary more-options trigger.
* **Zone B (Workspace Grid):** A vertically scrollable, responsive layout hosting structured cards and details grids, bound strictly by the standard screen margin.
* **Zone C (Sticky Footer):** Houses the primary operational actions (Delete, Confirm/Verify) pinned to the bottom of the viewport for comfortable one-handed reach.

### 9. Component Composition
The Transaction Details Screen is constructed by composing these primary design elements:
* **Contextual Header App Bar**
* **Bank Identity & Source Badge**
* **Transaction Summary Card**
* **Metadata Detail Grid**
* **User Notes Component**
* **Tag & Categorization Group**
* **Receipt Attachment & OCR Section**
* **Security Shield Indicator**
* **Action Footer Row**

### 10. Primary Actions
* **Verify / Confirm Entry:** Converts an unverified, heuristic-parsed transaction into a verified record with a single tap.
* **Edit Note Trigger:** Opens an inline input box or bottom sheet text field to modify custom notes.

### 11. Secondary Actions
* **Export PDF / Image receipt:** Compiles the transaction metadata into a clean, sharing-ready local visual receipt.
* **Share Details:** Triggers the native system share sheet with a secure, formatted plaintext summary.

### 12. Contextual Actions
* **Favorite Toggle:** Flags the transaction as a starred item for rapid filtering in search views.
* **Delete Record:** Prompts a destructive confirmation drawer to permanently wipe the record from the encrypted local database.

### 13. Transaction Card Details (Inside Summary Container)
* **Visual Grouping:** Content is consolidated inside a flat, low-contrast container card using default corner curves.
* **Display Fields:** Houses the Bank Logo Avatar, Bank Name, Transaction Type Badge, Amount Highlight, Monospace Currency Label, Status Indicator, and Source Info.

### 14. Statistics Preview (Contextual Analytics Context)
* **Category Association:** Shows the transaction's visual weight compared to the overall monthly budget of its parent category (e.g., "This represents 15% of your Transport budget this month").

### 15. Search & Metadata Querying
* **Copy Indicators:** Reference numbers and raw transaction texts include quick-action copy buttons that trigger self-dismissing feedback messages.

### 16. Filter Behaviour (Related Transactions)
* **Chronological Association:** Tapping items in the Related Transactions row transitions to the respective details page of the matched historical record.

### 17. Notification & Parsing Source
* **Transparency Indicators:** The screen displays the original raw SMS body alongside a diagnostic label, ensuring full traceability of how the transaction was parsed.

### 18. FAB Behaviour
* **Absence of Main Screen FAB:** To prevent visual clutter and layout overlap on this deep-feature page, the primary Floating Action Button is excluded. All administrative tasks are handled via standard text buttons or app bar controls.

### 19. Empty State (Field Specific)
* **Annotation States:** When optional elements (such as notes or attachments) are empty, they render a clean, low-contrast dashed outline with supportive add-actions, inviting user customization.

### 20. Loading State
* **Geometric Skeletons:** Renders shimmering outlines matching the card structures, ensuring layout stability during slow local database retrievals.

### 21. Error State
* **Corrupt Data Handling:** Displays localized warning cards inside the workspace if the record contains damaged values or fails local decryption.

### 22. Offline State
* **Natural System State:** All screen components render instantly using local data, with an offline-secure marker reinforcing the zero-network operation.

### 23. Permission State
* **Attachment Storage Access:** Prompts system permission flows only when users attempt to attach physical files or camera receipts.

### 24. Refresh Behaviour
* **Auto-Sync Update:** Automatically refreshes displayed metrics if background rules update the transaction's category or details.

### 25. Animation Guidelines
* **Responsive Easing:** Interactive state changes (such as toggling favorites or adding notes) trigger under standard performance limits using smooth, decelerated easing curves.

### 26. Accessibility Behaviour
* **Dynamic Sizing Compatibility:** Layout grids wrap dynamically and text fields expand vertically to prevent overlaps when system text magnification scales up to 200%.
* **High-Contrast Focus:** All body text elements maintain a minimum contrast ratio of 4.5:1 against surfaces.

### 27. RTL Behaviour
* **Mirrored Navigation Flow:** Back arrows and chevrons point natively to the right (logical start edge), and horizontal text lists proceed from right to left.

### 28. Theme Behaviour
* **Consistent Semantic Mapping:** Automatically adapts visual properties across Light, Dark, or High-Contrast themes without modifying component placements or layout grids.

### 29. Security Behaviour
* **Sensitive Data Masking:** Balances, card numbers, and raw SMS text blocks are immediately masked with solid visual shapes when the application transitions to the background multitasking switcher.

### 30. Performance Expectations
* **Sub-One-Hundred-Unit Rendering:** Details transitions and database queries must resolve in under standard performance budgets on mid-range Android devices.

### 31. Future Expansion Hooks
* **AI Expense Classification:** Slot allocated below category tags to display machine-learning categorizations and model confidence levels.
* **OCR Receipt Extraction:** Visual container ready to display parsed physical receipt values (itemized subtotals, tax figures) matched against the transaction.

### 32. Validation Checklist
* **Strict Token Alignment:** Confirms that every visual property, margin, and curved edge maps directly to an active design token.

### 33. Governance Rules
* **No Platform Hacks:** The layout must remain platform-independent, relying strictly on relative spacing blocks and logical components.

---

## Screen Regions Definition

The Transaction Details Screen is split into six distinct, structured layout regions, managing vertical scrolling and touch interactions:

```
+------------------------------------------------------------+
|  Region 1: App Bar & Secondary Actions (Zone A - Pinned)   |
+------------------------------------------------------------+
|  Region 2: Identity & Primary Summary Card (Zone B - Scroll) |
+------------------------------------------------------------+
|  Region 3: Key Details & Reference Grid (Zone B - Scroll)  |
+------------------------------------------------------------+
|  Region 4: User Notes & Annotations Block (Zone B - Scroll)|
+------------------------------------------------------------+
|  Region 5: Attachments & Future Ready Hook (Zone B - Scroll)|
+------------------------------------------------------------+
|  Region 6: Destructive & Confirm Action Footer (Zone C - Pin)|
+------------------------------------------------------------+
```

### 1. App Bar & Secondary Actions Region (Zone A)
* **Visual Presentation:** Pinned to the top of the viewport. Features a transparent background that renders a subtle separation line when the details workspace scrolls beneath.
* **Layout Flow (RTL):** The back navigation chevron sits on the logical start edge (right), the favorite star toggle sits adjacent to the chevron, while Share, Export, and More-Options triggers align to the logical end edge (left).

### 2. Identity & Primary Summary Card Region (Zone B)
* **Visual Presentation:** The top card section of the scrollable workspace. It features the Bank Identity Row and the Transaction Summary Card.
* **Horizontal Flow (RTL):** The Bank Logo Avatar and Bank Name align to the right (start), with the "Source: SMS" indicator aligned to the left (end). Within the Summary Card, the large amount display and transaction type badge occupy prominent vertical space.

### 3. Key Details & Reference Grid Region (Zone B)
* **Visual Presentation:** A structured, double-column grid presenting key transaction metadata.
* **Layout Flow (RTL):** Section headings and labels align strictly to the right (start). Localized numbers and values (Dates, Times, and Reference numbers) are displayed in monospace typography, aligned to the left (end) with subtle touch triggers for quick copying.

### 4. User Notes & Annotations Block Region (Zone B)
* **Visual Presentation:** A flat container card dedicated to user notes, category tags, and heuristic confidence ratings.
* **Layout Flow (RTL):** Note texts flow RTL, and the "Edit Note" button sits on the logical start edge. Category chips are arranged in a horizontal wrap-list, starting from the right.

### 5. Attachments & Future Ready Hook Region (Zone B)
* **Visual Presentation:** Contains receipt attachment slots, OCR extractions, and the local encryption security badge.
* **Layout Flow (RTL):** Receipt preview thumbnails sit on the start edge. The security shield is centered horizontally, serving as a clean, trust-building anchor.

### 6. Destructive & Confirm Action Footer Region (Zone C)
* **Visual Presentation:** A sticky row pinned to the bottom of the screen, housing the primary administrative action buttons.
* **Layout Flow (RTL):** The primary "Verify / Confirm" action button is positioned at the logical start edge (right), and the "Delete" button is positioned at the logical end edge (left) to prevent accidental destructive taps.

---

## Detailed Component Specifications

### 1. Contextual Header App Bar
* **Purpose:** Manages page context, exits the details view, and provides secondary tools.
* **Position:** Zone A (Pinned).
* **Priority:** Primary.
* **Interactions:**
  * Tapping back chevron triggers screen pop transition.
  * Tapping favorite toggle stars the transaction in local database indexes.
  * Tapping share icon launches system share dialogue.
  * Tapping export icon triggers local receipt builder.
  * Tapping more-options displays dropdown with Delete option.
* **Accessibility:** Screen reader announces: *"Back, button. Favorite, button. Share, button. Export, button."*
* **RTL Mirroring:** Back chevron mirrors to point right (`bankyar.icon.back.rtl`).

### 2. Bank Identity Row
* **Purpose:** Establishes transaction origin and verified system source.
* **Position:** Zone B (Scrollable).
* **Priority:** High.
* **Visual Style:** Flat row with no borders, nested above the primary summary card.
* **Interactions:** None (Read-only status group).
* **Display Fields:**
  * **Bank Logo Avatar:** Circular container holding flat bank symbol (`bankyar.avatar.medium`).
  * **Bank Name:** Bold medium-weight Persian text (e.g. *"بانک ملت"*).
  * **Source Label:** Small category chip displaying *"پیامک خوانده‌شده"* (Parsed SMS).

### 3. Transaction Summary Card
* **Purpose:** Highlights the absolute most critical transaction metrics: transacted sum, cash direction, card index, and system status.
* **Position:** Zone B (Scrollable).
* **Priority:** Critical (Primary Focus).
* **Visual Style:** Flat surface container using `bankyar.radius.lg` curves and `bankyar.semantic.color.border.subtle` outline.
* **Interactions:** Single-tap masks amount totals in public environments, blurring the text.
* **Core Elements:**
  * **Amount Highlight:** Display-large typography with explicit math symbols (e.g., `-120,000` or `+2,500,000`).
  * **Currency Label:** Appended to amount in Persian script (e.g., *"تومان"*).
  * **Transaction Type Badge:** High-contrast rounded chip (e.g., *"هزینه"* / *"درآمد"*). Uses semantic success green for income, and semantic error crimson for expense.
  * **Masked Card Info:** Monospace text showing active bank card (e.g., *"ملت **** ۵۶۷۸"*).
  * **Status Badge:** Horizontal row icon with success indicator (e.g., *"تراکنش موفق"* / *"در انتظار تأیید"*).

### 4. Metadata Detail Grid
* **Purpose:** Groups chronological coordinates, tracking reference numbers, and transacting counterparties.
* **Position:** Zone B (Scrollable).
* **Priority:** High.
* **Visual Style:** Structured vertical stack of flat list tiles, separated by `bankyar.border.width.thin` dividers.
* **Core Elements:**
  * **Sender / Receiver Row:** Displays origin and destination entities in medium title font.
  * **Solar Hijri Date Tile:** Monospace localized date (e.g., *"۱۴۰۲/۱۰/۱۲"*).
  * **Time Tile:** Monospace localized time (e.g., *"۱۴:۳۲"*).
  * **Reference Number Tile:** Localized transaction tracking number with inline Copy icon.
  * **Merchant Info Tile:** Displays recognized merchant name (e.g. *"اسنپ تاکسی"*) with category-specific icon.

### 5. User Notes Component
* **Purpose:** Lets users add custom local descriptions to transactions.
* **Position:** Zone B (Scrollable).
* **Priority:** Medium.
* **Visual Style:** Flat surface container with a dashed outline when empty, and a solid subtle border when populated.
* **Interactions:**
  * Tapping the "Edit Note" icon opens the Bottom Sheet text editor.
* **Dynamic Content:** If no note is present, it displays: *"بدون یادداشت. برای افزودن کلیک کنید"* (No note. Tap to add).

### 6. Tag & Categorization Group (Future-Ready)
* **Purpose:** Supports adding secondary tags for advanced financial reporting.
* **Position:** Zone B (Scrollable).
* **Priority:** Medium (Future-Ready Hook).
* **Visual Style:** Wrapping row of small rounded chips.
* **Interactions:**
  * Tapping active tag filters the ledger list by that tag.
  * Tapping the "+ Add Tag" chip opens the tag selector bottom sheet.

### 7. Receipt Attachment & OCR Section (Future-Ready)
* **Purpose:** Supports physical verification by allowing users to attach paper receipt images.
* **Position:** Zone B (Scrollable).
* **Priority:** Low (Future-Ready Hook).
* **Visual Style:** Dashed rectangular surface container matching default card curves.
* **Core Elements:**
  * **Attach Receipt Trigger:** Center-aligned icon button.
  * **OCR Extraction Summary:** Reserved vertical slot to display parsed receipt line items, itemized VAT, and totals.

### 8. Security Shield Indicator
* **Purpose:** Reassures users of complete data privacy.
* **Position:** Zone B (Scrollable).
* **Priority:** High (Trust-Building Anchor).
* **Visual Style:** Horizontally centered, low-contrast banner featuring a flat security shield icon.
* **Microcopy:** *"این تراکنش به صورت کاملاً محلی در دستگاه شما رمزنگاری شده است و به هیچ شبکه خارج از گوشی دسترسی ندارد."* (This transaction is encrypted completely locally on your device and has zero network access).

### 9. Destructive & Confirm Action Footer
* **Purpose:** Handles transaction confirmation and deletion.
* **Position:** Zone C (Pinned Footer).
* **Priority:** Critical.
* **Visual Style:** Sticky bottom horizontal row, utilizing comfortable padding to prevent gesture navigation conflicts.
* **Core Elements:**
  * **Verify / Confirm Button (Start Edge):** Prominent filled primary button. Converts heuristic-parsed transaction into verified status, dismissing warning states.
  * **Delete Button (End Edge):** Outlined button styled with the semantic error crimson scale. Triggers confirmation drawer to wipe the record.

---

## Technical Integration & State Matrices

### Interaction Matrix

| UI Component | User Action | Target Component | State Mutation | Expected Transition |
| :--- | :--- | :--- | :--- | :--- |
| **Back Chevron** | Single Tap | Navigation Stack | Pop Screen State | Smooth right-to-left exit animation. |
| **Favorite Icon** | Single Tap | Favorite Indicator | Toggle Boolean (`IsFavorite`) | Star icon fills instantly with brand accent color. |
| **Amount Text** | Single Tap | Amount Display | Toggle Masking (`Active` <-> `Blurred`) | Instantly blurs/reveals financial amount. |
| **Copy Ref Button**| Single Tap | Reference Tile | Clipboard Write | Triggers success snackbar: *"شماره پیگیری کپی شد"*. |
| **Edit Note Button**| Single Tap | Notes Sheet | Launches Input Sheet | Notes sheet slides vertically up from Zone C. |
| **Delete Button** | Single Tap | Delete Drawer | Launches Confirmation Sheet| Confirmation drawer slides up with destructive option. |
| **Verify Button** | Single Tap | Status Badge | Converts state to `Verified` | Warning outline fades; success checkmark animates. |

### State Matrix

| System State | App Bar Header | Summary Card | Notes Block | Security Shield | Action Footer |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Normal (Verified)**| Standard Icons | Active Figure | Shows Custom Note | Visible | Shows "Delete" only |
| **Unverified (Heuristic)**| Standard Icons | Warning Border | Shows Empty State | Visible | Shows "Confirm" & "Delete" |
| **Loading** | Shimmer | Shimmer Card | Shimmer block | Hidden | Disabled |
| **Error (Decryption)**| Disabled Icons | Locked Card | Disabled Note | Hidden | Disabled |
| **Offline** | Secure Badge | Active Figure | Editable | Visible | Active |
| **Edit Mode** | Back Blocked | Blurred Amount | Active Input Textfield| Hidden | Shows "Save" & "Cancel" |
| **Delete Confirmed** | Scrim Covered | Scrim Covered | Scrim Covered | Scrim Covered | Shows Confirmation Sheet |
| **Backgrounded** | Mask Overlay | Mask Overlay | Mask Overlay | Mask Overlay | Mask Overlay |

### Accessibility Matrix

| UI Component | Accessibility Trait | Screen Reader Announcement | Touch Target Offset | Keyboard Focus Sequence |
| :--- | :--- | :--- | :--- | :--- |
| **Back Chevron** | Action Trigger | *"برگشت به صفحه قبل. دکمه."* | Standard Insets | Step 1 (Start-to-End) |
| **Favorite Button**| Toggle Action | *"افزودن به علاقه‌مندی‌ها. تغییر وضعیت."*| Standard Insets | Step 2 (Start-to-End) |
| **Amount Card** | Toggle Mask | *"مبلغ تراکنش: منفی ۱۲۰,۰۰۰ تومان. برای پنهان‌سازی ضربه بزنید."*| Card Boundary | Step 3 (Top-to-Bottom) |
| **Ref Copy Button**| Clipboard Action| *"کپی کردن شماره پیگیری. دکمه."* | Comfort Target | Step 4 (Top-to-Bottom) |
| **Edit Note Trigger**| Edit Action | *"ویرایش یادداشت تراکنش. دکمه."* | Comfort Target | Step 5 (Top-to-Bottom) |
| **Verify Button** | Action Trigger | *"تأیید صحت اطلاعات تراکنش. دکمه."* | Full Button | Step 6 (Bottom Footer) |
| **Delete Button** | Destructive Action| *"حذف دائمی تراکنش از دستگاه. دکمه هشدار."*| Full Button | Step 7 (Bottom Footer) |

---

## Design Token Matrix

The Transaction Details Screen resolves all visual properties using these global semantic design tokens:

```
+--------------------------------------------------------------------------+
|                       CORE DESIGN TOKENS MATRIX                          |
+---------------------+----------------------------------------------------+
| Visual Element      | Design Token Key                                   |
+---------------------+----------------------------------------------------+
| Screen Background   | `bankyar.semantic.color.background.default`        |
| Card Surface Base   | `bankyar.semantic.color.surface.default`           |
| High Contrast Text  | `bankyar.semantic.color.text.primary`              |
| Supporting Text     | `bankyar.semantic.color.text.secondary`            |
| Divider Lines       | `bankyar.semantic.color.border.subtle`             |
| Amount Display Font | `bankyar.semantic.typography.display.lg`           |
| Local Monospace Font| `bankyar.semantic.typography.monospace.standard`   |
| Outer Screen Margin | `bankyar.responsive.margin`                        |
| Container Curve     | `bankyar.radius.medium`                            |
| Bottom Sheet Curve  | `bankyar.radius.large`                             |
| Minimum Touch Area  | `bankyar.space.xl`                                 |
+---------------------+----------------------------------------------------+
```

---

## Responsive Design & Adaptive Viewports

The Transaction Details layout adjusts dynamically across standard responsive breakpoints:

* **Standard Phone:** Vertically stacked card regions. The details grid utilizes a single-column layout, and action buttons occupy the full horizontal width of Zone C.
* **Large Phone / Foldable (Folded):** Standard layout metrics, expanding the details card paddings to `bankyar.space.lg` for improved readability.
* **Tablet / Foldable (Unfolded):** Splits the screen into a dual-pane master-detail layout:
  * **Logical Start Pane (Right):** Primary transaction card, amount highlight, and bank metadata details.
  * **Logical End Pane (Left):** Interactive user notes, category tags, receipts, and related historical transactions.
* **Landscape Orientation:** Adjusts the workspace into a balanced double-column layout to prevent long, unreadable text lines.

---

## Validation Checklist

Before implementation, this specification must satisfy these quality checks:

- [ ] **No Hardcoded Hex Colors:** Every color maps directly to an active semantic design token.
- [ ] **No Physical Dimensions:** All Spacing, margins, and curved boundaries use abstract token keys.
- [ ] **No Flutter Code references:** The document remains platform-independent and free of Flutter-specific references.
- [ ] **RTL-First Compliance:** Layout alignments and transitions use logical start/end properties.
- [ ] **Data Security Compliance:** Sensitive data is masked and local security microcopy is clearly visible.

---

## Governance Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Deterministic Destructive Flow:** Transaction deletion must always trigger a confirmation bottom sheet, protecting users from accidental data loss.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.

---

## Future Expansion Hooks

* **AI Expense Classification:** Displays automated category predictions and model confidence ratings.
* **OCR Receipt Extraction:** Reserved vertical container to display parsed physical receipt line items, itemized VAT, and totals.
* **Recurring Transactions Group:** Space reserved below the Related Transactions feed to flag matched recurring intervals.
* **Budget Integration Progress Bar:** Displays the transacted amount's visual impact on the active monthly budget category.

---
**End of Document**
