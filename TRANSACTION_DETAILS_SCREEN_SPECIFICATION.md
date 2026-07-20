# BankYar Transaction Details Screen Specification (v1.1.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 1.1.0
**Authors:** Principal Product Designer, Senior UX Architect, Flutter UI Architect, Material Design 3 Expert, Financial Dashboard Specialist, Enterprise Design System Consultant
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Transaction Details Screen is a specialized, deep-feature interface designed to provide comprehensive visual clarity, administrative control, and organization for a single financial transaction. Operating natively in **Persian (RTL)** under an uncompromising **offline-first, zero-network privacy constraint**, this screen transforms raw, fragmented SMS alerts into structured, high-fidelity financial ledger entries.

This screen is built strictly upon **Material Design 3 (MD3)** design systems and is engineered to reduce financial anxiety by providing immediate verification of transaction legitimacy, custom annotation inputs, localized status indicators, and intelligent security transparency.

---

## 1. Screen Structure

The Transaction Details Screen is constructed using the logical three-zone vertical layout model. Horizontal reading paths, vertical grids, and interactive touch triggers mirror natively to support Persian RTL workflows.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY HEADER & CONTEXT CONTROLS]                             |
|  +-------------------------------------------------------------------+  |
|  | [More Options] [Export] [Archive] [Share] [Favorite] [Back chevron] |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE DETAILED WORKSPACE]                                 |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [1. Bank Identity Section]                                       |  |
|  |     [Bank Logo Avatar] Mellat Bank (Bank Name)                    |  |
|  |     SMS Sender: +982000001                                        |  |
|  |                                                                   |  |
|  |  [2. Transaction Summary Card]                                    |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | Amount Highlight: -120,000 Tomans                     |     |  |
|  |     | Transaction Type Badge: Outflow / Expense             |     |  |
|  |     | Masked Account: Mellat Card **** 5678                 |     |  |
|  |     | Status: Successful Transaction                        |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [3. Date, Time & Balance Section]                                |  |
|  |     Date: ۱۴۰۲/۱۰/۱۲   |   Time: ۱۴:۳۲                            |  |
|  |     Balance After Transaction: ۲,۴۵۰,۰۰۰ Tomans             |  |
|  |                                                                   |  |
|  |  [4. Reference & Merchant Section]                                |  |
|  |     Reference Number: 987654321012 [Copy Action]                  |  |
|  |     Merchant / Category: Snapp Taxi [Category Icon]               |  |
|  |                                                                   |  |
|  |  [5. Raw SMS Content Block]                                       |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | [Search Inside SMS Trigger]                           |     |  |
|  |     | "بانک ملت - برداشت ۱۲۰,۰۰۰ تومان از کارت ۵۶۷۸"        |     |  |
|  |     | [Copy SMS Text Button]                                |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [6. User Note Component]                                         |  |
|  |     Note: Taxi ride to office.                                    |  |
|  |     [Add/Edit Note Action Button]                                 |  |
|  |                                                                   |  |
|  |  [7. Tags Section]                                                |  |
|  |     [Transport] [Business] [Daily Expense] [+ Add Tag]            |  |
|  |                                                                   |  |
|  |  [8. Attachments Section (Future-Ready)]                          |  |
|  |     [Receipt Image Preview Slot / OCR Extractions]                |  |
|  |                                                                   |  |
|  |  [9. Security Information Shield]                                 |  |
|  |     "Encrypted Locally on Device | No Network Access"             |  |
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

## 2. Visual Layout

The visual layout consists of an elegant, low-saturation neutral canvas with semantic colors indicating transaction status and direct cash flow. The structure relies on horizontal alignment, spatial cards, and clear typography lines.

* **Layout Scaffold:** The design uses a clean vertical card-stack layout inside the scrollable Zone B workspace.
* **Symmetrical Insets:** Content margins align strictly to `bankyar.responsive.margin` to prevent information from crowding the screen edges.
* **Separation Lines:** Elements are grouped with flat containers (`bankyar.radius.medium` corner curves) and subtle boundary lines (`bankyar.semantic.color.border.subtle`), omitting all physical pixel specifications and physical unit properties.

---

## 3. Information Hierarchy

The screen establishes high-fidelity visual scanning from top to bottom:

* **Primary Visual Tier (High Salience):** Large readable amount and cash direction indicator (Income green vs Expense crimson math signs).
* **Secondary Visual Tier (Medium Salience):** Bank Name, Card Identity, Date and Time, Balance After Transaction, and Category Badge.
* **Tertiary Visual Tier (Low Salience):** SMS Sender address, Full SMS content block, Reference numbers, custom notes, and tag chips.
* **Trust & Security Tier:** The local on-device encryption shield banner.

---

## 4. Interaction Flow

A seamless, predictable flow governs all actions on the screen:

1. **Screen Entry:** The screen is launched from a ledger feed tap or notification click, sliding in from the right logical start edge (RTL) or displaying with a soft scale-and-fade transition.
2. **Favorite Star Toggling:** A single tap on the star button fills the shape with brand accent, indexing the transaction as starred instantly in the local database.
3. **Copy Tracking Action:** Tapping the copy button on the reference number or raw SMS text copies content to the clipboard and triggers a self-dismissing feedback banner at the bottom of the viewport.
4. **Note Management Flow:** Tapping the Note Editor button slides up a bottom sheet for writing, validating, and saving custom annotations inline.
5. **Accidental Loss Mitigation:** Permanent deletion triggers a confirmation overlay, separating destructive and confirm actions to prevent user errors.

---

## 5. Component Placement

* **Zone A (Sticky App Bar):** Standard back action on the logical start edge (right), favorite indicator adjacent to the back chevron. Operational tools (Share, Archive, Export, and More Options) are aligned at the logical end edge (left).
* **Zone B (Detailed Scroll Workspace):** Houses components chronologically starting with the Bank Identity, moving through the Financial Summary Card, Details Grid, the search-enabled Raw SMS container, User Notes, Categories and Tags, Attachments, and concluding with the trust-building Security Shield.
* **Zone C (Sticky Footer):** Houses the primary actions aligned comfortably within the thumb-reach zone. Destructive delete button is placed at the logical end (left), and the verify/confirm action is positioned at the logical start (right).

---

## 6. Typography Usage

The typography scale enforces absolute readable contrast ratios:

* **Display Font (`bankyar.semantic.typography.display.lg`):** Large readable amount with mathematical sign and monospace formatting for numerical figures.
* **Heading Font (`bankyar.semantic.typography.title.sm`):** Bank Name, Section Headers, and Title labels.
* **Body Font (`bankyar.semantic.typography.body.md`):** Raw SMS Content blocks and User Notes.
* **Monospace Font (`bankyar.semantic.typography.monospace.standard`):** Solar Hijri timestamps, card indices, balance figures, and reference tracking digits to maintain flawless column alignment.

---

## 7. Icon Usage

Linear, thin-stroke icons are mapped to functional actions, mirroring dynamically in RTL locales:

* **Back Chevron (`bankyar.icon.back.rtl`):** Mirrored to point right.
* **Favorite Toggle (`bankyar.icon.star.empty`/`bankyar.icon.star.filled`):** Standard star symbol representing saved entries.
* **Clipboard Copy (`bankyar.icon.copy`):** Visual indicator of copy actions.
* **Search Icon (`bankyar.icon.search`):** Interactive magnifying glass inside raw SMS.
* **Security Shield (`bankyar.icon.security`):** Trusted local vault visual marker.
* **Delete Trash Bin (`bankyar.icon.delete`):** Semantic warning/destructive action indicator.

---

## 8. Elevation Strategy

Elevation is mapped through distinct layer hierarchies to avoid visual noise:

* **Layer 0 (Canvas - Background):** Lowest logical level (`bankyar.semantic.color.background.default`).
* **Layer 1 (Cards - Flat):** Transaction Summary Card and Detail Containers (`bankyar.semantic.color.surface.default`), styled with a subtle border.
* **Layer 2 (Actions - Raised):** Form controls and interactive chips.
* **Layer 3 (Overlays - Sheets):** Modal Sheets and deletion dialogs (`bankyar.semantic.color.surface.overlay`), using high-contrast scrim backdrops.

---

## 9. Animation Notes

* **Screen Transition:** Decelerated horizontal slide from the right logical start edge, matching the RTL reading path.
* **Interactive Toggles:** Star-fill and checkmark scale transitions occur instantly (`bankyar.motion.duration.instant`).
* **Sheet Expansion:** Notes Editor bottom sheet slides up with standard easing curves, settling into position within standard performance timelines.

---

## 10. Accessibility Review

* **Contrast Standards:** Contrast ratios of all critical typography elements are verified to meet or exceed WCAG AA 4.5:1 parameters.
* **No Color-Only Signifiers:** Outflows are distinguished by a preceding minus sign (`-`) next to crimson accents, while inflows are preceded by a plus sign (`+`) next to emerald success tones.
* **Screen Reader Semantic Mapping:** Image components use meaningful alternative text. Custom interactive buttons are declared with explicit semantic trait markers.

---

## 11. RTL Review

* **Reading Path Mirrored:** Text alignments, list entries, and headings flow natively from right to left.
* **Logical Spacing Property Mapping:** Left and right coordinates are prohibited, using logical start and end spacing tokens to adjust layouts automatically.
* **Vertical Space Buffers:** Standard spacing multipliers account for tall Persian text loops, preventing layout line overlapping.

---

## 12. Component Specifications (In-Depth Core Fields)

For every component on the Transaction Details Screen, the following 16 properties define their exact presentation, state behavior, and boundaries:

### 12.1 Contextual Header App Bar
1. **Purpose:** Coordinates navigation exits, toggles saved entries, and houses administrative utilities.
2. **Hierarchy:** Secondary context tier, pinned at the top of the viewport.
3. **Placement:** Zone A (Sticky).
4. **Visual Weight:** Medium. Uses transparent backdrop, rendering a subtle separation border when text scrolls underneath.
5. **Spacing:** Bound vertically to standard app bar height. Margins adhere to `bankyar.responsive.margin`.
6. **Elevation:** Layer 0 by default, Layer 1 when content scrolls beneath.
7. **Typography:** Action titles set to `bankyar.font.size.medium` and bold.
8. **Icons:** Back chevron (`bankyar.icon.back.rtl`), Star outline, Share, Archive, Export, and More-Options triggers.
9. **States:** Default, Pressed, Selected, and Disabled.
10. **Loading:** Renders shimmer on individual icon bounds.
11. **Error:** Outlines with subtle warning color if state fails to mutate.
12. **Offline:** Operates normally with zero network access.
13. **Accessibility:** Screen readers announce: *"برگشت به صفحه قبل. دکمه"* and *"علاقه‌مندی. تغییر وضعیت"*. Minimum touch targets map to `bankyar.space.xl`.
14. **RTL Behaviour:** Back chevron is mirrored to point to the right logical start edge.
15. **Animation:** Soft fade transitions on icon presses.
16. **Future Expansion:** Dedicated slot to add custom user bookmarks and folder organization.

### 12.2 Bank Identity & Source Row
1. **Purpose:** Confirms the origin bank and verified carrier SMS source.
2. **Hierarchy:** Primary contextual metadata tier.
3. **Placement:** Zone B, positioned above the main Transaction Summary Card.
4. **Visual Weight:** Medium.
5. **Spacing:** Separated by `bankyar.space.md` from Zone A, and `bankyar.space.sm` from components below.
6. **Elevation:** Layer 0 (Flat on background).
7. **Typography:** Bank name uses `bankyar.semantic.typography.title.sm`. Sender and parse source use Caption small.
8. **Icons:** Bank logo avatar, message parser icon.
9. **States:** Read-only (Static state).
10. **Loading:** Replaced by shimmering circular avatar and text-line bounds.
11. **Error:** Renders localized warning text if decryption or card identification fails.
12. **Offline:** Instant local evaluation.
13. **Accessibility:** Alternate text for bank logo avatar provided.
14. **RTL Behaviour:** Bank avatar aligns right (start edge), source labels align left (end edge).
15. **Animation:** None.
16. **Future Expansion:** Dynamic expansion to support multiple linked credit/debit profiles under the same bank.

### 12.3 Transaction Summary Card
1. **Purpose:** Highlights transacted sum, cash flow direction, card metadata, and system status.
2. **Hierarchy:** Critical (Screen focus point).
3. **Placement:** Zone B, topmost card container.
4. **Visual Weight:** Extreme. High typography contrast.
5. **Spacing:** Internal padding matches `bankyar.space.md`. Spaced from adjacent components by `bankyar.space.lg`.
6. **Elevation:** Layer 1 (`bankyar.semantic.color.surface.default`).
7. **Typography:** Numeric display uses `bankyar.semantic.typography.display.lg` (Monospace). Status indicator and card details use Caption small.
8. **Icons:** Upward/Downward cashflow arrows, security lock indicator.
9. **States:** Default (Visible figures), Masked (Blurred balances for privacy), Pressed.
10. **Loading:** Replaced by a unified shimmering card skeleton.
11. **Error:** Renders with a soft crimson outline if transaction data is corrupted.
12. **Offline:** Operates fully offline.
13. **Accessibility:** Text reader parses: *"مبلغ تراکنش: منفی صد و بیست هزار تومان. موفق."* Screen readers do not read masked text blocks.
14. **RTL Behaviour:** Value and symbol align right, category tags and transaction indicators align left.
15. **Animation:** Smooth opacity blur transition during balance masking.
16. **Future Expansion:** Ability to display cash conversion rates if international currencies are parsed.

### 12.4 Details Grid Section (Date, Time, Balance & Ref)
1. **Purpose:** Lists timestamps, running balances, and bank tracking reference IDs.
2. **Hierarchy:** Secondary analytical tier.
3. **Placement:** Zone B, grouped in a container below the Summary Card.
4. **Visual Weight:** Medium.
5. **Spacing:** Margin padding is set to standard spacing factors, separated internally by hairline dividers.
6. **Elevation:** Layer 1.
7. **Typography:** Captions use Caption small, numeric values use standard Monospace text size.
8. **Icons:** Solar Calendar symbol, Clock outline, Scale indicator, Copy tracker badge.
9. **States:** Default, Pressed (Copy button trigger).
10. **Loading:** Shimmering lines match grid divisions.
11. **Error:** Local warning banner displays if numerical data is missing.
12. **Offline:** Displays verified local ledger logs.
13. **Accessibility:** Accessible touch targets around copy elements. Monospace font prevents overlap on large text configurations.
14. **RTL Behaviour:** Grid columns and titles align right (start), values and copy triggers align left (end).
15. **Animation:** Success checkmark animation inside the copy button on tap.
16. **Future Expansion:** Direct export hooks for individual invoice components.

### 12.5 Raw SMS Content Inspector
1. **Purpose:** Displays full, unmodified carrier SMS text with search and copy capabilities.
2. **Hierarchy:** Secondary validation tier.
3. **Placement:** Zone B, centered within the scroll workspace.
4. **Visual Weight:** Medium. Low-contrast surface wrapper.
5. **Spacing:** Outer margins match responsive rules. Internal vertical padding is set to standard spacing.
6. **Elevation:** Layer 1.
7. **Typography:** Raw SMS text block is rendered in `bankyar.semantic.typography.body.md` with loose leading line heights.
8. **Icons:** Magnifying glass (Search inside SMS), Clipboard Copy, Close search.
9. **States:** Default, Searching (Highlights matching characters), Pressed.
10. **Loading:** Standard shimmering block layout.
11. **Error:** Displays parsing alert label if text file is unreadable.
12. **Offline:** Fully operational locally.
13. **Accessibility:** Search text is fully navigable by screen reader focus orders. Focus outlines are distinct.
14. **RTL Behaviour:** Raw text preserves original SMS alignment (RTL for Persian banks). Search input and magnifying icons align to the start edge.
15. **Animation:** Search input scales horizontally when search is activated.
16. **Future Expansion:** Regex rule customizer launch button linked directly from the SMS inspector view.

### 12.6 Note Display Component
1. **Purpose:** Renders the user's custom text notes or invites additions if empty.
2. **Hierarchy:** Tertiary customization tier.
3. **Placement:** Zone B.
4. **Visual Weight:** Medium. Solid subtle borders if notes exist, dashed borders if empty.
5. **Spacing:** Internal space factor `bankyar.space.md`, outer spacing `bankyar.space.lg`.
6. **Elevation:** Layer 1.
7. **Typography:** Body copy set to `bankyar.semantic.typography.body.md`.
8. **Icons:** Edit note pencil, Trash bin, Add note icon.
9. **States:** Empty (dashed outline), Populated (solid border), Pressed.
10. **Loading:** Shimmer lines match layout depth.
11. **Error:** None.
12. **Offline:** Completely supported (local DB storage only).
13. **Accessibility:** Screen reader parses notes or announces empty slot actions.
14. **RTL Behaviour:** Persian text flows RTL naturally.
15. **Animation:** Smooth transition between empty state bounds and text blocks.
16. **Future Expansion:** Rich text formatting (Bold, list bullets, etc.) for note fields.

### 12.7 Tag & Categorization Group
1. **Purpose:** Enables adding and filtering metadata categories and tags.
2. **Hierarchy:** Tertiary organization tier.
3. **Placement:** Zone B.
4. **Visual Weight:** Medium.
5. **Spacing:** Wrapped chips are spaced by standard horizontal and vertical margin tokens.
6. **Elevation:** Layer 2 (Raised chip surfaces).
7. **Typography:** Chip text uses standard caption scales.
8. **Icons:** Tag category icon, Add tag plus sign, Remove tag close icon.
9. **States:** Default, Selected, Pressed, Disabled.
10. **Loading:** Replaced by shimmering chip outlines.
11. **Error:** Standard error boundary if database fails to associate metadata.
12. **Offline:** Instant on-device tagging.
13. **Accessibility:** Active chips read: *"برچسب حمل و نقل. انتخاب شده"* or *"دکمه افزودن برچسب جدید"*.
14. **RTL Behaviour:** Chip row flows from right to left, wrapping downward.
15. **Animation:** Soft scaling on tap.
16. **Future Expansion:** Machine-learning suggested category badges showing confidence scores.

### 12.8 Attachment Section (Future-Ready)
1. **Purpose:** Visual slot ready to display paper receipts and OCR extracted items.
2. **Hierarchy:** Tertiary data tier.
3. **Placement:** Zone B, lower section of the scroll area.
4. **Visual Weight:** Low. Light neutral boundaries.
5. **Spacing:** Spaced by standard macro tokens.
6. **Elevation:** Layer 1 (Flat outline).
7. **Typography:** Captions and labels use micro and caption fonts.
8. **Icons:** Paperclip symbol, camera outline.
9. **States:** Empty/Slot, Loaded (thumbnail previews), Disabled.
10. **Loading:** Unified image skeleton shimmers.
11. **Error:** Renders red outline if attachment type is unsupported.
12. **Offline:** All attachments stored on secure local system directories.
13. **Accessibility:** Descriptive alt text for thumbnail previews.
14. **RTL Behaviour:** Grid layout mirrors starting from right to left.
15. **Animation:** Thumbnail fade-in when selected.
16. **Future Expansion:** OCR extraction cards listing parsed subtotal items and tax percentages.

### 12.9 Security Shield Indicator
1. **Purpose:** Reassures users of strict on-device encryption and zero network connectivity.
2. **Hierarchy:** Primary trust tier.
3. **Placement:** Zone B, centering above the sticky footer.
4. **Visual Weight:** Medium. Soft grounding grey palette.
5. **Spacing:** Vertical margins match standard spacing multipliers.
6. **Elevation:** Layer 0 (Flat on background).
7. **Typography:** Description text uses Caption small, bold headers.
8. **Icons:** Security shield outline.
9. **States:** Read-only (Static).
10. **Loading:** Disabled.
11. **Error:** None.
12. **Offline:** Normal system state.
13. **Accessibility:** Read: *"پیام امنیتی: اطلاعات تراکنش رمزنگاری شده محلی بدون دسترسی اینترنت"*.
14. **RTL Behaviour:** Shield icon is centered with RTL text blocks flowing naturally below it.
15. **Animation:** None.
16. **Future Expansion:** Vault configuration quick-link button.

### 12.10 Destructive & Confirm Action Footer
1. **Purpose:** Triggers transaction validation (heuristic to verified state) or permanently deletes records.
2. **Hierarchy:** Critical operational tier.
3. **Placement:** Zone C (Sticky bottom).
4. **Visual Weight:** Extreme. Filled container actions.
5. **Spacing:** Aligns to viewport margins. Bottom padding shields against native gesture bars.
6. **Elevation:** Layer 2 (Raised footer background overlay).
7. **Typography:** Button text uses Button medium typography tokens.
8. **Icons:** Checkmark (Confirm), Trash outline (Delete).
9. **States:** Default, Pressed, Disabled, Scrim Overlay Active.
10. **Loading:** Buttons show inline activity shimmers, blocking inputs.
11. **Error:** High-contrast crimson validation highlights on database failure.
12. **Offline:** Zero network actions required.
13. **Accessibility:** Prominent touch target zones, strict contrast limits.
14. **RTL Behaviour:** Confirm/Verify button is placed on the logical start (right) and the destructive delete button is mapped to the logical end (left).
15. **Animation:** Soft elevation translation on button hover/press.
16. **Future Expansion:** Archive/Restore toggles inside the more options drawer.

---

## 13. Note Editor Specification

The Note Editor is a core interactive component engineered to handle custom annotations with zero friction, providing absolute data safety and complete predictability.

### 13.1 Editor Layout
* **Visual Container:** The Editor is structured as an interactive Modal Bottom Sheet sliding up from Zone C. It occupies 60% of the viewport height.
* **Header Area:** Draggable indicator handle centered at the top boundary, followed by a bold title: *"یادداشت تراکنش"* (Transaction Note) and a close trigger on the logical end edge.
* **Input Box:** Large outlined text field (`bankyar.radius.medium` corner curve) filling the central container area, optimized for fingers.
* **RTL Text Flow:** The cursor and characters align right by default, with text wrapping vertically.

### 13.2 Character Counter
* **Placement:** Positioned at the bottom-left corner of the input box container.
* **Format:** Monospace numerical indicator (e.g., `120 / 250`).
* **Limit:** Capped at 250 characters.
* **Visual Transitions:** Stays in neutral secondary text color during normal typing. If characters exceed 240, the counter turns to the warning orange scale, and locks input with an error crimson color if the limit is breached.

### 13.3 Autosave Behaviour
* **Strategy:** Every character stroke is stored in a temporary on-disk memory block.
* **Recovery Shield:** If the app transitions to the background or if the user accidentally closes the sheet, the written string is cached locally. When the editor is reopened, it prompts a recovery banner: *"یادداشت ذخیره نشده بازیابی شد"*.

### 13.4 Validation
* **Constraints:** Special injection strings, script tags, and database symbols are blocked and sanitized instantly.
* **Feedback Rules:** Invalid characters trigger a soft inline error banner at the bottom of the input container, disabling the save action.

### 13.5 Keyboard Behaviour
* **Activation:** Tapping the text area slides up the system keyboard.
* **Dynamic Viewport Adjustment:** The bottom sheet adjusts its height dynamically based on the active keyboard layout inset, preventing input boxes from being obscured.
* **Dismissal:** Swiping downward on the draggable handle dismisses both the keyboard and the bottom sheet.

### 13.6 Focus Behaviour
* **Outline:** On active focus, the input border is colored with the high-contrast `bankyar.semantic.color.border.active` token.
* **Cursor State:** Focused cursor uses the primary brand accent, blinking steadily.

### 13.7 Undo Strategy
* **Keyboard Triggers:** Deleting text preserves a state history queue of 15 steps.
* **Visual Action:** Undo and redo icon triggers are positioned in the input accessory bar above the keyboard for quick retrieval.

### 13.8 Cancel Behaviour
* **Action:** Tapping the Close button or swiping downward prompts an immediate transition to dismiss.
* **Unsaved Data Protection:** If changes exist, a prompt sheet appears: *"آیا می‌خواهید تغییرات لغو شوند؟"* (Do you want to discard changes?), offering discard and resume controls.

### 13.9 Save Behaviour
* **Action:** Tapping the "Save Note" primary action button writes the validated string permanently into the local encrypted database.
* **Success Feedback:** The bottom sheet slides down, updating the Note Display Component instantly, and triggers a self-dismissing feedback snackbar: *"یادداشت ذخیره شد"*.

---

## 14. Validation Checklist

Before releasing any layout or implementing code, verify compliance against this checklist:

- [x] **No Hardcoded Hex Colors:** Every visual color maps directly to a semantic design token.
- [x] **No Physical Dimensions:** Margins, paddings, and curves use abstract token keys with no physical units (px, dp, sp).
- [x] **No Flutter Code References:** Visual layouts are specified independently of code constructs.
- [x] **RTL-First Compliance:** Screen structures align right-to-left, utilizing logical start and end properties.
- [x] **Note Editor Defined:** Completed specifications for editor layouts, counters, autosave, and keyboard interactions.
- [x] **Display Fields Met:** Includes Bank logo, transaction totals, reference numbers, full raw SMS, notes, and attachments.
- [x] **User Actions Met:** Outlines copy, share, edit notes, favorite status, search inside SMS, and destructive actions.
- [x] **Accessibility Matrix Completed:** Meets minimum WCAG AA contrast rules and defines screen reader flows.

---
**End of Specification Document**
