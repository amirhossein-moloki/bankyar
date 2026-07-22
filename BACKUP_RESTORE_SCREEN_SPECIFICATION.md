# BankYar Backup & Restore Center Screen Specification (v2.0.0)
## Enterprise-Grade Screen Specification for Offline-First Secure Financial Applications

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification
**Document Version:** 2.0.0
**Authors:** Principal Product Designer, Disaster Recovery Specialist, Privacy-by-Design Consultant, Material Design 3 Expert, Flutter UI Architect, Enterprise FinTech UX Designer
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

The BankYar Backup & Restore Center is the primary data sovereign vault of an offline-first, private personal finance platform. Operating under strict on-device data sovereignty boundaries (zero network permissions, zero cloud trackers, and complete local SQLCipher encryption), users must have a foolproof, high-confidence way to manage, export, and restore their financial database.

This specification establishes the absolute visual, spatial, and interaction design of the **Backup & Restore Center** under native **Persian (RTL)** layouts. Built strictly on **Material Design 3 (MD3)** systems, the design features premium financial styling, comfortable vertical rhythms, zero hardcoded values (colors, measurements, animations), and complete inclusive accessibility.

---

## 1. Complete Screen Layout (Deliverable 1)

The Backup & Restore Center utilizes the logical three-zone vertical layout model, structured horizontally to align with BankYar's proportional grid system.

```
+-------------------------------------------------------------------------+
|                              DEVICE STATUS BAR                          |
+-------------------------------------------------------------------------+
|  [ZONE A: STICKY APP BAR]                                               |
|  +-------------------------------------------------------------------+  |
|  | [Info Trigger]           [Screen Title]              [Back Chevron] |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE B: SCROLLABLE WORKSPACE & BACKUP SECTIONS]                       |
|  +-------------------------------------------------------------------+  |
|  |                                                                   |  |
|  |  [Region 1: Data Protection & Sovereignty Alert]                  |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | Shield Icon | All backups are encrypted. No cloud sync|     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 2: Backup Status Overview Card]                          |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | [Health Indicator]  آخرین پشتیبان‌گیری موفق: دیروز      |     |  |
|  |     | اندازه: ۲.۴ مگابایت | نسخه دیتابیس: ۱ | سلامت: ۱۰۰٪   |     |  |
|  |     | فضا: ۷۲٪ خالی (نمودار میله‌ای مصرف حافظه گوشی)          |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  |  [Region 3: Quick Actions Grid]                                   |  |
|  |     [ایجاد فایل پشتیبان]                [بازیابی اطلاعات]           |  |
|  |     [خروجی رمزنگاری شده]                [بررسی سلامت فایل]          |  |
|  |     [اشتراک‌گذاری فایل]                  [حذف فایل پشتیبان]          |  |
|  |                                                                   |  |
|  |  [Region 4: Backup History List]                                  |  |
|  |     [عنوان بخش: تاریخچه پشتیبان‌گیری]                              |  |
|  |     - پشتیبان‌گیری دستی | ۱۴۰۲/۱۰/۱۲ - ۱۴:۳۲ | ۲.۴ مگابایت | سالم     |  |
|  |     - پشتیبان‌گیری دوره‌ای| ۱۴۰۲/۱۰/۰۵ - ۰۸:۰۰ | ۲.۲ مگابایت | سالم     |  |
|  |                                                                   |  |
|  |  [Region 5: Export / Import Operations]                           |  |
|  |     - صادرات امن دیتابیس به حافظه خارجی                             |  |
|  |     - بارگذاری دستی فایل پشتیبان (.bankyar)                       |  |
|  |                                                                   |  |
|  |  [Region 6: Recovery Information & Emergency Recovery]            |  |
|  |     +-------------------------------------------------------+     |  |
|  |     | وضعیت کلید امنیتی: فعال | الگوریتم: AES-GCM-256         |     |  |
|  |     | [دکمه: نمایش پین بازیابی اضطراری]                             |     |  |
|  |     +-------------------------------------------------------+     |  |
|  |                                                                   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|  [ZONE C: CONTROL & NAVIGATION]                                         |
|  +-------------------------------------------------------------------+  |
|  | [Persistent Bottom Navigation Bar]                                |  |
|  | [تراکنش‌ها]             [نمودارها]             [قوانین]   [تنظیمات]* |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
|                         SYSTEM GESTURE NAV BAR                          |
+-------------------------------------------------------------------------+
```

### Layout Grid Parameters
* **Compact Viewport (Smartphones):** 4 columns. Symmetrical outer margins are bound to `bankyar.responsive.margin` (mapping to `bankyar.space.lg` on mobile). Inter-column gutters are bound to `bankyar.responsive.gutter` (`bankyar.space.md`).
* **Medium Viewport (Tablets / Foldables):** 8 columns. Master-detail horizontal splitting. Symmetrical margins are bound to `bankyar.space.xl` and gutters to `bankyar.space.lg`.
* **Expanded Viewport (Landscape / Large Tablets):** 12 columns. Content columns are constrained to `bankyar.responsive.container.width.max` to prevent uncomfortably long reading lines.

---

## 2. Component Hierarchy (Deliverable 4)

```
BackupRestoreCenterScreen [Scaffold]
 ├── Zone A: Sticky Top App Bar [AppBar]
 │    ├── Logical Start (Right): Back Chevron Button [IconButton]
 │    ├── Center: Screen Title Label [Text]
 │    └── Logical End (Left): Info Modal Trigger [IconButton]
 ├── Zone B: Scrollable Workspace [SingleChildScrollView]
 │    ├── Region 1: Data Sovereignty Alert [Card]
 │    │    └── Linear Row: Shield Icon + Alert Title + Description Text
 │    ├── Region 2: Backup Status Overview Card [Card]
 │    │    ├── Column: Top Segment [Health Badge (Circular Indicator) + Status Copy Block]
 │    │    ├── Row: Metadata Grid [Last Successful Date, Database Version, Encryption Algorithm]
 │    │    └── Column: Memory Management Progress Indicator [ProgressBar + Text Labels]
 │    ├── Region 3: Quick Actions Grid [SliverGrid]
 │    │    ├── Action Tile 1: Create Manual Backup Button [Card/Button]
 │    │    ├── Action Tile 2: Restore Database Button [Card/Button]
 │    │    ├── Action Tile 3: Secure Password Export Button [Card/Button]
 │    │    ├── Action Tile 4: Verify Local Integrity Button [Card/Button]
 │    │    ├── Action Tile 5: Native Sharing Button [Card/Button]
 │    │    └── Action Tile 6: Purge Old Backups Button [Card/Button (Destructive)]
 │    ├── Region 4: Backup History List [SliverList]
 │    │    ├── Header Label: Title "تاریخچه فایل‌های پشتیبان" + Count Badge
 │    │    └── List Item Loop: History Tile [ListTile]
 │    │         ├── Logical Start (Right): Vector Icon (Manual/Automatic Indicator)
 │    │         ├── Center Column: Date Timestamp + Database Compatibility Text
 │    │         └── Logical End (Left): File Size Metric + Contextual Menu Button
 │    ├── Region 5: Advanced Options / Reminders [Card]
 │    │    └── Form Rows: Toggle Switch for Automated Prompts + Reminder Period Selector
 │    └── Region 6: Recovery Info & Disaster Tips [Card]
 │         ├── Text Block: Monospace Key Details + Security Standard Indicators
 │         └── Button: Access Master Recovery Phrase Key [ElevatedButton]
 └── Zone C: Sticky System Navigation [NavigationBar]
      └── Status Badge: Connection-Free Secured Diagnostic Strip [DiagnosticBadge]
```

---

## 3. Step-by-Step Interactive Flows (Deliverables 2 & 3)

### A. Step-by-Step Backup Flow
1. **Trigger:** User taps "ایجاد پشتیبان دستی" (Create Manual Backup).
2. **Context Overlay:** A modal dialog slides up (`bankyar.radius.large`) requesting file confirmation. If battery levels are below 15%, a soft warning is appended warning against termination.
3. **Write Isolation:** The database connection enters a transaction lock mode, redirecting new parsing updates to a memory buffer.
4. **Compression & Encryption:**
   - The system compiles the SQLCipher SQLite binary.
   - Encrypts the payload using AES-256-GCM.
   - Generates a 16-byte random salt and 12-byte initialization vector (IV) prepended to the backup header.
5. **Write Verification:** The encrypted `.bankyar` archive is written to the app's secure sandbox. The backup engine reads back the header tag to execute a local SHA-256 checksum check, verifying block write accuracy.
6. **Completion Event:** The transaction lock is released. A success screen slides into view reporting backup sizing and exact timestamping in Solar Hijri format.

### B. Step-by-Step Restore Flow
1. **Select Backup File:** User taps "بازیابی اطلاعات دیتابیس" (Restore Backup). The system launches the native Android document picker filtered strictly to display `.bankyar` files.
2. **Read & Check Header:** The system reads the selected file stream, parsing the 16-byte magic identifier header verifying database schema compatibility versions.
3. **Verify Integrity (Pre-Decrypt):** Evaluates file structural completion, verifying block layout alignment before invoking cryptography libraries.
4. **Enter Authentication PIN:** If the backup contains a custom security lock, the screen transitions to a secure scrambled PIN keypad overlay.
5. **Decrypt Archive:** Derives keys via PBKDF2 with 100,000 iterations. Decrypts database streams in chunks using AES-GCM-256, validating the 16-byte authentication tag.
6. **Restore Preview & Analytics Grid:** Before committing writes, a high-contrast comparison board presents a side-by-side transaction count:
   * *Local Database:* ۲۴۰ تراکنش (240 transactions) | ۳ کارت بانکی (3 bank cards)
   * *Backup Archive:* ۸۵۰ تراکنش (850 transactions) | ۵ کارت بانکی (5 bank cards)
7. **Conflict Detection & Resolution:** If duplicate SMS hashes are found, a choice menu prompts the user:
   * *Option A (Merge & Deduplicate):* "ادغام هوشمند و حذف موارد تکراری" (Resolves duplicates and merges files).
   * *Option B (Replace / Overwrite):* "جایگزینی کامل دیتابیس" (Overwrites local data completely).
8. **Progress Tracking:** Shows a full-screen, blocking progress checklist, locking the screen to prevent hardware interrupts.
9. **Atomic Commitment / Failure Rollback:**
   - *Success Path:* Writes commit atomically. Displays a full-screen checkmark overlay and forces an app reload.
   - *Failure Path:* If decryption or database writes fail mid-process, the active transaction rolls back completely to its pre-restore baseline. The user is redirected to the "Restore Failed" screen, preserving absolute database safety.

---

## 4. Comprehensive Component Specifications

This section defines the 18 specific properties for each of the core elements of the Backup & Restore Center.

---

### Component 1: Backup Status Overview Card
1. **Purpose:** Provides instantaneous verification of database protection and health.
2. **Business Value:** Instills digital trust; confirms the secure offline engine is functioning correctly.
3. **Visual Priority:** Critical (High contrast, positioned at the top of Zone B).
4. **Placement:** Region 2 (Zone B). Spans full grid width.
5. **Spacing:** External top gap: `bankyar.space.lg`. Internal padding: `bankyar.space.md` symmetrically.
6. **Typography:** Title: `bankyar.font.size.lg` (Bold). Descriptive labels: `bankyar.font.size.sm` (Regular).
7. **Icons:** Leading icon: `bankyar.icon.security_shield` (Success green tint).
8. **Elevation:** Flat card structure bound to `bankyar.elevation.level.one`.
9. **Interaction:** Tapping the card triggers an instant offline database health self-audit.
10. **Loading State:** Shimmering background lines swipe horizontally from right to left (RTL).
11. **Disabled State:** Opacity drops to 38%, deactivating click events.
12. **Error State:** Border stroke shifts to `bankyar.semantic.color.status.error` (Crimson).
13. **Warning State:** Border stroke shifts to amber, display text reads: "بیش از ۷ روز از آخرین پشتیبان‌گیری گذشته است".
14. **Success State:** Displays a steady green border, verifying 100% database health.
15. **Accessibility:** Grouped as a single reading block for TalkBack: *"وضعیت فایل‌های پشتیبان عالی است. ۱۰۰ درصد ایمن."*
16. **RTL Behaviour:** Shield icon aligns logical start (right), metadata fields align right.
17. **Animation:** Fades in vertically on load using `bankyar.motion.curve.decelerate` over 300ms.
18. **Future Expansion:** Prepared slot to display multi-device database synchronization states.

---

### Component 2: Last Successful Backup Timestamp Row
1. **Purpose:** Informs the user of the exact date of their latest successful backup.
2. **Business Value:** Keeps users aware of their backup currency, reducing the risk of data loss.
3. **Visual Priority:** High (Directly nested inside the status overview card).
4. **Placement:** Nested top row of Region 2.
5. **Spacing:** Vertical height bound to `bankyar.space.md`.
6. **Typography:** Monospace Solar Hijri characters `bankyar.font.size.md` (Medium weight).
7. **Icons:** Leading icon: `bankyar.icon.calendar_clock` (Muted gray tint).
8. **Elevation:** None (Flat nested text layout).
9. **Interaction:** Static text indicator; long-press copies raw timestamp.
10. **Loading State:** Gray skeleton box replaces text.
11. **Disabled State:** Text color shifts to disabled gray.
12. **Error State:** Replaced by text: "نامشخص - خطای خواندن تاریخچه".
13. **Warning State:** Text color shifts to amber if last backup is more than 7 days old.
14. **Success State:** Standard green-tinted baseline copy.
15. **Accessibility:** Semantic label reads: *"آخرین فایل پشتیبان موفق در تاریخ دوازدهم دی ماه، ساعت چهارده و سی و دو دقیقه تهیه گردید."*
16. **RTL Behaviour:** Right-aligned (logical start), icon sits right of the Persian text.
17. **Animation:** None.
18. **Future Expansion:** Add automated timezone localization logic.

---

### Component 3: Backup Health Indicator Badge
1. **Purpose:** Aggregates database encryption, backup frequency, and checksum integrity into a single percentage.
2. **Business Value:** Translates complex system states into a simple metric, reducing user anxiety.
3. **Visual Priority:** High (Visual circular badge).
4. **Placement:** Left edge of the Status Overview Card (logical end).
5. **Spacing:** Width and height set to `bankyar.space.xl` (48 dynamic units).
6. **Typography:** Centered text: `bankyar.font.size.sm` (Bold, monospace Persian numbers).
7. **Icons:** Circular progress vector ring.
8. **Elevation:** Level one.
9. **Interaction:** Tapping the badge launches a detailed audit progress modal.
10. **Loading State:** Spinning indeterminate ring sweeps continuously.
11. **Disabled State:** Muted opacity (38%).
12. **Error State:** Radial ring turns red (Score 0-59%).
13. **Warning State:** Radial ring turns yellow (Score 60-89%).
14. **Success State:** Radial ring turns green (Score 90-100%).
15. **Accessibility:** Screen readers announce: *"میزان سلامت پشتیبان‌گیری: صد در صد، عالی"*
16. **RTL Behaviour:** Anchored on the left edge (logical end) of the card container.
17. **Animation:** Ring fills clockwise using standard easing curves over 600ms.
18. **Future Expansion:** Interactive expanding radial details.

---

### Component 4: Encrypted Backup Status Card
1. **Purpose:** Explicitly confirms the cryptographic encryption of backup files.
2. **Business Value:** Reinforces privacy-first principles, assuring users their financial data is secure.
3. **Visual Priority:** High.
4. **Placement:** Region 2, nested below the overview card details.
5. **Spacing:** Vertical padding: `bankyar.space.sm`.
6. **Typography:** Label text: `bankyar.font.size.xs` (Medium weight).
7. **Icons:** Padlock key symbol `bankyar.icon.lock_secure`.
8. **Elevation:** Flat nested container.
9. **Interaction:** Static indicator; tapping triggers a cryptography security info popover.
10. **Loading State:** Replaced by loading shimmer.
11. **Disabled State:** Opacity drops, deactivating click events.
12. **Error State:** Replaced by: "خطا در بارگذاری کلید رمزنگاری".
13. **Warning State:** Unused.
14. **Success State:** Green checkmark overlay.
15. **Accessibility:** TalkBack reads: *"رمزگذاری فایل فعال است. الگوریتم رمزنگاری پیشرفته آ ای اس دویست و پنجاه و شش"*
16. **RTL Behaviour:** Padlock icon aligns right (start edge), status label aligns right.
17. **Animation:** None.
18. **Future Expansion:** Toggle to swap between AES-GCM-256 and custom hardware keys.

---

### Component 5: Backup Location Indicator Row
1. **Purpose:** Informs the user where backup files are saved (secure local app sandbox).
2. **Business Value:** Explicitly confirms offline storage, ensuring no data leaves the device.
3. **Visual Priority:** Medium.
4. **Placement:** Region 2, inside the status metadata grid.
5. **Spacing:** Horizontal spacing: `bankyar.space.xs`.
6. **Typography:** Label text: `bankyar.font.size.xs` (Regular). Monospace file path text.
7. **Icons:** Folder outline symbol `bankyar.icon.folder_local`.
8. **Elevation:** None.
9. **Interaction:** Static text. Tapping opens the file path details.
10. **Loading State:** Shimmering gray block.
11. **Disabled State:** Text color shifts to muted gray.
12. **Error State:** Replaced by: "خطا در دسترسی به پوشه ذخیره".
13. **Warning State:** Warning icon displays if directory storage limits are reached.
14. **Success State:** Standard display.
15. **Accessibility:** Announces: *"محل ذخیره فایل: حافظه محلی و پوشه امن برنامه"*
16. **RTL Behaviour:** Right-aligned (start edge).
17. **Animation:** None.
18. **Future Expansion:** External SD card target paths selection.

---

### Component 6: Database Size Metric Badge
1. **Purpose:** Displays the active size of the on-device financial database.
2. **Business Value:** Helps users manage their local storage footprint, building confidence in our lightweight architecture.
3. **Visual Priority:** Medium.
4. **Placement:** Region 2, metadata panel.
5. **Spacing:** Symmetrical padding: `bankyar.space.xxs`.
6. **Typography:** Monospace metrics: `bankyar.font.size.sm` (Bold Persian numbers).
7. **Icons:** Database cylinder symbol `bankyar.icon.database_size`.
8. **Elevation:** None.
9. **Interaction:** Static label. Tapping triggers database defragmentation (VACUUM).
10. **Loading State:** Skeleton text line.
11. **Disabled State:** Grayscale.
12. **Error State:** Replaced by: "حجم نامشخص".
13. **Warning State:** Shifts text color to yellow if database size exceeds 200MB.
14. **Success State:** Standard display.
15. **Accessibility:** Screen reader reads: *"اندازه پایگاه داده فعلی: چهار ممیز دو مگابایت"*
16. **RTL Behaviour:** Icon aligns right, size metrics align left.
17. **Animation:** Values roll dynamically on update.
18. **Future Expansion:** Add granular category sizing reports.

---

### Component 7: Backup File Size Metric Badge
1. **Purpose:** Displays the size of the backup file.
2. **Business Value:** Demonstrates compression efficiency (typically compressing files up to 10x).
3. **Visual Priority:** Medium.
4. **Placement:** Region 2, adjacent to Database Size.
5. **Spacing:** Symmetrical padding: `bankyar.space.xxs`.
6. **Typography:** Monospace metrics: `bankyar.font.size.sm` (Bold Persian numbers).
7. **Icons:** File compressed symbol `bankyar.icon.file_compressed`.
8. **Elevation:** None.
9. **Interaction:** Static text indicator.
10. **Loading State:** Skeleton text line.
11. **Disabled State:** Grayscale.
12. **Error State:** Replaced by: "حجم نامشخص".
13. **Warning State:** Unused.
14. **Success State:** Standard display.
15. **Accessibility:** Screen reader reads: *"اندازه فایل پشتیبانی فشرده شده: دو ممیز چهار مگابایت"*
16. **RTL Behaviour:** Icon aligns right, size metrics align left.
17. **Animation:** Values roll dynamically on update.
18. **Future Expansion:** Add historic sizing charts.

---

### Component 8: Backup History List Item
1. **Purpose:** Lists available on-device backups for easy retrieval and management.
2. **Business Value:** Empowers users to restore data from specific historical points.
3. **Visual Priority:** High (Dynamic, scrollable feed in Region 4).
4. **Placement:** Region 4 (Zone B).
5. **Spacing:** Margins between list rows: `bankyar.space.sm`. Internal tile padding: `bankyar.space.md`.
6. **Typography:** Title: `bankyar.font.size.md` (Medium weight). Date/Time: `bankyar.font.size.sm` (Regular).
7. **Icons:** Document symbol with color badges (Manual: Blue icon, Scheduled: Green icon).
8. **Elevation:** Flat card structure bound to `bankyar.elevation.level.one`.
9. **Interaction:** Swiping left reveals actions (Restore, Share, Delete). Tapping row opens a details sheet.
10. **Loading State:** Multi-line shimmering skeleton bars.
11. **Disabled State:** Opacity drops to 38%, deactivating click events.
12. **Error State:** Outlines turn red, displaying: "فایل پشتیبان نامعتبر یا آسیب‌دیده".
13. **Warning State:** Yellow alert outline displays if the file has not been verified.
14. **Success State:** Green check icon displays, confirming a healthy checksum.
15. **Accessibility:** Focus node reads metrics sequentially: *"فایل پشتیبان دستی، تاریخ دوازدهم دی ماه، اندازه دو ممیز چهار مگابایت، وضعیت سالم."*
16. **RTL Behaviour:** Date and time align right (start edge), actions align left (end edge).
17. **Animation:** Fades out with a leftward slide when deleted.
18. **Future Expansion:** Cloud archive tags indicator slots.

---

### Component 9: Manual Backup Primary Button
1. **Purpose:** Primary trigger to execute an immediate on-demand database backup.
2. **Business Value:** Provides instant data protection before critical device updates or resets.
3. **Visual Priority:** Critical (High contrast, filled button in Region 3).
4. **Placement:** Region 3 (Zone B). Spans full column grid.
5. **Spacing:** Vertical height bound to `bankyar.space.xl` (48 dynamic units).
6. **Typography:** Button label: `bankyar.font.size.md` (Bold weight).
7. **Icons:** Document creation symbol `bankyar.icon.document_create`.
8. **Elevation:** Level two.
9. **Interaction:** Single tap initiates backup flow. Long-press triggers backup options.
10. **Loading State:** Centered circular loading spinner spins, label is hidden.
11. **Disabled State:** Button shifts to disabled gray, deactivating click events.
12. **Error State:** Shifts to crimson error color if storage access permissions are missing.
13. **Warning State:** Shifts to amber if device battery is below 15%.
14. **Success State:** Turns success green with a checkmark for 2 seconds upon completion.
15. **Accessibility:** Screen reader announces: *"دکمه ایجاد فایل پشتیبان دستی. دو بار ضربه بزنید تا فایل جدید ساخته شود."*
16. **RTL Behaviour:** Icon aligns right (start edge), label is centered.
17. **Animation:** Tactile scale compression of 0.98x when pressed.
18. **Future Expansion:** Long-press opens quick backup rules.

---

### Component 10: Restore Backup Action Button
1. **Purpose:** Triggers the comprehensive database restoration process.
2. **Business Value:** Ensures a clear, safe recovery path to restore historical records.
3. **Visual Priority:** High (Filled button, paired with Manual Backup).
4. **Placement:** Region 3 (Zone B).
5. **Spacing:** Vertical height: `bankyar.space.xl`.
6. **Typography:** Button label: `bankyar.font.size.md` (Bold weight).
7. **Icons:** Database import symbol `bankyar.icon.database_import`.
8. **Elevation:** Level two.
9. **Interaction:** Single tap launches secure system file picker.
10. **Loading State:** Replaced by loading spinner.
11. **Disabled State:** Opacity drops, deactivating click events.
12. **Error State:** Red border outline if restoration fails.
13. **Warning State:** Soft amber border indicates data will be overwritten.
14. **Success State:** Muted success green.
15. **Accessibility:** TalkBack reads: *"دکمه بازیابی اطلاعات دیتابیس. دو بار ضربه بزنید تا فایل پشتیبان انتخاب شود."*
16. **RTL Behaviour:** Icon aligns right (start edge), label is centered.
17. **Animation:** Tactile scale compression of 0.98x when pressed.
18. **Future Expansion:** Selective category restore menu.

---

### Component 11: Export Encrypted Backup Card
1. **Purpose:** Initiates database encryption and prepares files for external sharing.
2. **Business Value:** Enables secure database portability, ensuring complete user ownership.
3. **Visual Priority:** Medium.
4. **Placement:** Region 5 (Zone B).
5. **Spacing:** Vertical padding: `bankyar.space.sm`.
6. **Typography:** Title: `bankyar.font.size.md` (Bold). Subtext: `bankyar.font.size.sm` (Regular).
7. **Icons:** Secure export symbol `bankyar.icon.encrypted_export`.
8. **Elevation:** Level one.
9. **Interaction:** Tapping launches the encrypted backup key generator.
10. **Loading State:** Shimmering progress block.
11. **Disabled State:** Grayscale.
12. **Error State:** Outlines turn red if encryption fails.
13. **Warning State:** Shifts to amber, displaying: "ابتدا پین ورود اختصاصی خود را تعریف کنید".
14. **Success State:** Displays checkmark, preparing files for native sharing.
15. **Accessibility:** Screen reader reads: *"دکمه صادرات فایل رمزنگاری شده دیتابیس. دو بار ضربه بزنید تا خروجی امن تولید شود."*
16. **RTL Behaviour:** Icon aligns right (start edge), chevron points left.
17. **Animation:** Vertical slide-down panel reveals the 12-word recovery passphrase.
18. **Future Expansion:** Automatic SD card scheduling slot.

---

### Component 12: Import Manual Backup Card
1. **Purpose:** Allows manual loading of external `.bankyar` backups.
2. **Business Value:** Provides a clear path to migrate data from old devices or external drives.
3. **Visual Priority:** Medium.
4. **Placement:** Region 5 (Zone B).
5. **Spacing:** Vertical padding: `bankyar.space.sm`.
6. **Typography:** Title: `bankyar.font.size.md` (Bold). Subtext: `bankyar.font.size.sm` (Regular).
8. **Icons:** Secure import symbol `bankyar.icon.encrypted_import`.
9. **Elevation:** Level one.
10. **Interaction:** Tapping launches the secure system file picker.
11. **Loading State:** Shimmering progress block.
12. **Disabled State:** Grayscale.
13. **Error State:** Replaced by: "قالب فایل نامعتبر است. فقط فایلهای با پسوند دات بانک یار مجاز هستند."
14. **Warning State:** Soft amber alert frame displays, warning of active data loss.
15. **Success State:** Successful decryption badge.
16. **Accessibility:** TalkBack reads: *"دکمه وارد کردن فایل پشتیبان از حافظه جانبی. دو بار ضربه بزنید تا فایل انتخاب شود."*
17. **RTL Behaviour:** Icon aligns right, chevron points left.
18. **Animation:** None.
19. **Future Expansion:** Support direct transfers via local Wi-Fi Direct.

---

### Component 13: Backup Verification Component
1. **Purpose:** Performs local checksum integrity checks to verify files are healthy and secure.
2. **Business Value:** Builds confidence by confirming backup files are complete and ready to restore.
3. **Visual Priority:** High (Inline action inside History Card or status overview).
4. **Placement:** Nested inside individual history rows in Region 4.
5. **Spacing:** Small horizontal tap region: `bankyar.space.sm`.
6. **Typography:** Status label: `bankyar.font.size.xs` (Medium weight).
7. **Icons:** Verification shield indicator `bankyar.icon.verification_shield`.
8. **Elevation:** None.
9. **Interaction:** Single tap initiates manual file verification and checks checksum integrity.
10. **Loading State:** Spinning indeterminate progress circle.
11. **Disabled State:** Opacity drops to 38%, deactivating click events.
12. **Error State:** Turns crimson red, displaying: "تأیید ناموفق - فایل آسیب دیده است".
13. **Warning State:** Shifts to yellow, displaying: "عدم تطابق نسخه پایگاه داده".
14. **Success State:** Turns green with text "سالم و تأیید شده" (Healthy and Verified).
15. **Accessibility:** Screen reader reads: *"وضعیت فایل پشتیبان: تایید شده و سالم"*
16. **RTL Behaviour:** Status text aligns right, verification badge aligns left.
17. **Animation:** Spinner transitions to a success checkmark with smooth vertical scale shifts.
18. **Future Expansion:** Custom cryptographical signature checks slot.

---

### Component 14: Backup Integrity Check Progress Row
1. **Purpose:** Displays progress feedback during long database integrity audits.
2. **Visual Priority:** High (Overlay component during verification operations).
3. **Placement:** Nested in Region 2 or active dialogs.
4. **Spacing:** Vertical separation: `bankyar.space.sm`.
5. **Typography:** Percent text: `bankyar.font.size.xs` (Monospace Persian numerals).
6. **Icons:** Diagnostic clock progress indicator `bankyar.icon.diagnostic_clock`.
7. **Elevation:** None.
8. **Interaction:** Read-only progress bar.
9. **Loading State:** Continuous shimmer sweep.
10. **Disabled State:** Grayed out.
11. **Error State:** Progress bar turns red if an integrity breach is detected.
12. **Warning State:** Progress bar turns yellow if bad blocks are detected.
13. **Success State:** Progress bar turns green upon completing checks.
14. **Accessibility:** Focus reads progress: *"در حال بررسی سلامت دیتابیس. چهل و پنج درصد کامل شده"*
15. **RTL Behaviour:** Progress bar fills from right to left (RTL).
16. **Animation:** Progress bar expands smoothly over standard easing curves.
17. **Future Expansion:** Add detailed diagnostic error logs.

---

### Component 15: Automatic Reminder Settings Toggle
1. **Purpose:** Prompts the user to back up their data at scheduled intervals (daily, weekly, monthly).
2. **Business Value:** Helps prevent data loss through automated prompts.
3. **Visual Priority:** Medium.
4. **Placement:** Region 5 (Zone B).
5. **Spacing:** Vertical height: `bankyar.space.xl`.
6. **Typography:** Label text: `bankyar.font.size.md` (Medium weight). Subtext: `bankyar.font.size.sm` (Regular).
7. **Icons:** Clock calendar outline `bankyar.icon.calendar_clock`.
8. **Elevation:** Level one.
9. **Interaction:** Toggling switch activates automated reminder prompts.
10. **Loading State:** Switch is grayed out and locked.
11. **Disabled State:** Opacity drops, deactivating click events.
12. **Error State:** Unused.
13. **Warning State:** Amber warning displays if notifications are disabled in system settings.
14. **Success State:** Reminder active indicator displays.
15. **Accessibility:** TalkBack reads: *"یادآور خودکار پشتیبان‌گیری، روشن. دو بار ضربه بزنید تا خاموش شود."*
16. **RTL Behaviour:** Icon aligns right (start edge), toggle switch aligns left (end edge).
17. **Animation:** Switch handle slides smoothly with subtle spring elastic effects.
18. **Future Expansion:** Link directly with local system calendar events.

---

### Component 16: Device Storage Usage Progress Bar
1. **Purpose:** Displays remaining device storage to ensure there is enough space for backup files.
2. **Business Value:** Prevents backup errors caused by full storage.
3. **Visual Priority:** Medium.
4. **Placement:** Region 2, nested bottom segment of Overview Card.
5. **Spacing:** Vertical padding: `bankyar.space.xs`.
6. **Typography:** Storage metrics: `bankyar.font.size.xs` (Monospace numbers).
7. **Icons:** Local storage disk outline `bankyar.icon.storage_disk`.
8. **Elevation:** None.
9. **Interaction:** Static indicator; tapping copy details.
10. **Loading State:** Skeleton progress bar displays.
11. **Disabled State:** Color shifts to disabled gray.
12. **Error State:** Progress bar turns red if device storage is full (below 5% free space).
13. **Warning State:** Progress bar turns yellow if free space drops below 15%.
14. **Success State:** Progress bar is green under normal operating conditions.
15. **Accessibility:** Screen reader reads: *"فضای ذخیره سازی گوشی: هفتاد و دو درصد خالی است. فضای آزاد کافی است"*
16. **RTL Behaviour:** Progress bar fills from right to left (RTL).
17. **Animation:** Linear progress expands horizontally on load.
18. **Future Expansion:** Prune diagnostic cache button integration.

---

### Component 17: Master Recovery Phrase Button
1. **Purpose:** Generates a 12-word recovery seed key as a fallback backup option.
2. **Business Value:** Provides a secure recovery key to restore access if PIN locks are lost, protecting user ownership.
3. **Visual Priority:** High (Highlighted with amber warning borders).
4. **Placement:** Region 6 (Zone B).
5. **Spacing:** Vertical padding: `bankyar.space.md`.
6. **Typography:** Title: `bankyar.font.size.md` (Bold). Subtext: `bankyar.font.size.sm` (Regular).
7. **Icons:** Padlock key outline `bankyar.icon.master_key`.
8. **Elevation:** Level one.
9. **Interaction:** Tapping prompts biometric authentication. Upon verification, displays 12-word seed key.
10. **Loading State:** Grayed out during checks.
11. **Disabled State:** Opacity drops to 38%, deactivating click events.
12. **Error State:** Replaced by: "خطا در دسترسی به کلید امنیتی".
13. **Warning State:** Highlighted with amber alert outlines.
14. **Success State:** Seed key is revealed.
15. **Accessibility:** Screen reader reads: *"دکمه دریافت اطلاعات بازیابی اضطراری دیتابیس. دو بار ضربه بزنید تا پین اضطراری تولید شود."*
16. **RTL Behaviour:** Symmetrical card; button aligns left, description aligns right.
17. **Animation:** Seed key container expands vertically with a sliding fade-in.
18. **Future Expansion:** Secure offline printing template generation.

---

### Component 18: Disaster Recovery Tips Panel
1. **Purpose:** Offers helpful offline disaster recovery tips to prevent data loss.
2. **Business Value:** Educates users on secure storage practices, reducing support requests and data loss.
3. **Visual Priority:** Low (Positioned at the bottom of the scrollable canvas).
4. **Placement:** Region 6 (Zone B).
5. **Spacing:** Vertical separation: `bankyar.space.lg`. Symmetrical internal padding: `bankyar.space.md`.
6. **Typography:** Title: `bankyar.font.size.md` (Bold). Paragraph body: `bankyar.font.size.sm` (Regular).
7. **Icons:** Tip bulb outline `bankyar.icon.recovery_tip`.
8. **Elevation:** Flat card structure bound to `bankyar.elevation.level.zero`.
9. **Interaction:** Expandable card; tapping expands detailed descriptions.
10. **Loading State:** Hidden during load states.
11. **Disabled State:** Grayscale.
12. **Error State:** Unused.
13. **Warning State:** Unused.
14. **Success State:** Standard display.
15. **Accessibility:** Grouped reading block reads tips sequentially: *"نکات بازیابی اضطراری: یک، همیشه فایل پشتیبان خود را خارج از گوشی ذخیره کنید..."*
16. **RTL Behaviour:** Align right (start edge), tip items use bullet indicators on the right.
17. **Animation:** Smooth expand-collapse transitions.
18. **Future Expansion:** Link with interactive backup troubleshooting guides.

---

## 5. Comprehensive Dialog Specifications (Deliverable 5)

All dialogs in the Backup & Restore Center are designed to ensure database safety and prevent accidental actions, strictly conforming to the Material Design 3 dialog system.

```
+-------------------------------------------------------------------------+
| Dialog Overlay Scrim: bankyar.opacity.translucent                       |
|  +-------------------------------------------------------------------+  |
|  | Container Curvature: bankyar.radius.large                         |  |
|  | Internal Padding: bankyar.space.md                                |  |
|  |                                                                   |  |
|  |  [Header Icon: semantic color alignment]                          |  |
|  |  { Title Label: high contrast body MD3 typography }               |  |
|  |  ( Descriptive explanation / warnings without technical jargon )  |  |
|  |  ---------------------------------------------------------------  |  |
|  |  [Optional Form / Scrambled PIN Keypad Input]                     |  |
|  |  ---------------------------------------------------------------  |  |
|  |  RTL Button Actions:                                              |  |
|  |  [ Confirm Action Button ]                [ Cancel Action Button ]|  |
|  |  (Logical Start - Right)                  (Logical End - Left)    |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
```

---

### Dialog 1: Create Backup Confirmation Dialog
* **Purpose:** Confirms before starting a manual backup.
* **Header Icon:** `bankyar.icon.document_create` (Blue tint).
* **Title:** "ایجاد فایل پشتیبان جدید"
* **Message:** "یک نسخه پشتیبان رمزگذاری‌شده از تمامی تراکنش‌ها و تنظیمات برنامه در حافظه گوشی ذخیره خواهد شد. این فرآیند چند ثانیه زمان می‌برد."
* **Form / Actions:**
  * Toggle Switch: "اشتراک‌گذاری خودکار پس از ساخت" (Share automatically upon completion).
  * **Logical Start Button (Right):** "تایید و ساخت فایل" (Confirm and Create) - Primary filled button.
  * **Logical End Button (Left):** "انصراف" (Cancel) - Text button.

---

### Dialog 2: Restore Backup Warning Dialog
* **Purpose:** High-priority confirmation prompt before starting a database restoration.
* **Header Icon:** `bankyar.icon.database_import` (Amber warning tint).
* **Title:** "بازیابی اطلاعات دیتابیس"
* **Message:** "شما در حال بارگذاری یک فایل پشتیبان هستید. این فرآیند دیتابیس فعلی شما را بازنویسی می‌کند. مطمئن هستید؟"
* **Form / Actions:**
  * Checkbox: "من متوجه عواقب جایگزینی اطلاعات هستم" (I understand this will overwrite current data).
  * **Logical Start Button (Right):** "تایید و شروع بازیابی" (Confirm and Restore) - Filled tonal button.
  * **Logical End Button (Left):** "انصراف" (Cancel) - Outlined button.

---

### Dialog 3: Overwrite Existing Data Critical Dialog
* **Purpose:** Prompted when a conflict is detected during restore.
* **Header Icon:** `bankyar.icon.warning_critical` (Crimson error tint).
* **Title:** "تداخل در فایل‌های دیتابیس"
* **Message:** "تراکنش‌های تداخل‌دار بین نسخه پشتیبان و دیتابیس فعلی پیدا شد. جهت حفظ اطلاعات، یکی از روش‌های زیر را انتخاب کنید:"
* **Form / Actions:**
  * Radio Group:
    * `○` "ادغام هوشمند و حذف موارد تکراری" (Merge & Deduplicate - Safe).
    * `○` "جایگزینی کامل دیتابیس فعلی" (Replace current database completely).
  * **Logical Start Button (Right):** "اعمال تصمیم" (Apply) - High-priority filled button.
  * **Logical End Button (Left):** "لغو بازیابی" (Cancel Restore) - Text button.

---

### Dialog 4: Delete Backup File Dialog
* **Purpose:** Destructive safety confirmation before deleting a historic backup.
* **Header Icon:** `bankyar.icon.trash_delete` (Crimson error tint).
* **Title:** "حذف فایل پشتیبان"
* **Message:** "شما در حال حذف دائمی این فایل پشتیبان از حافظه محلی گوشی هستید. این عمل غیر قابل بازگشت است."
* **Form / Actions:**
  * **Logical Start Button (Right):** "تایید و حذف دائم" (Confirm and Delete) - Crimson error color button.
  * **Logical End Button (Left):** "انصراف" (Cancel) - Text button.

---

### Dialog 5: Backup Verification Failed Dialog
* **Purpose:** Prompted when a backup checksum check fails.
* **Header Icon:** `bankyar.icon.shield_broken` (Crimson error tint).
* **Title:** "عدم تأیید سلامت فایل"
* **Message:** "بررسی سلامت دیتابیس ناموفق بود. امضای دیجیتال یا ساختار فایل خراب است. این فایل نباید برای بازیابی استفاده شود."
* **Form / Actions:**
  * **Logical Start Button (Right):** "بررسی مجدد فایل" (Verify Again) - Outlined button.
  * **Logical End Button (Left):** "فهمیدم" (Dismiss) - Text button.

---

### Dialog 6: Restore Failed Safety Alert
* **Purpose:** Informs the user when a restoration fails.
* **Header Icon:** `bankyar.icon.restore_error` (Crimson error tint).
* **Title:** "خطا در بازیابی اطلاعات"
* **Message:** "خطای غیرمنتظره‌ای هنگام مهاجرت پایگاه داده رخ داد. اطلاعات فعلی شما بدون هیچ تغییری حفظ شده است."
* **Form / Actions:**
  * **Logical Start Button (Right):** "مشاهده گزارش خطا" (View Diagnostic Logs) - Outlined button.
  * **Logical End Button (Left):** "تلاش مجدد" (Retry) - Filled button.

---

### Dialog 7: Corrupted Backup File Dialog
* **Purpose:** Alert displaying block corruption in a selected backup.
* **Header Icon:** `bankyar.icon.file_corrupted` (Crimson error tint).
* **Title:** "فایل پشتیبان آسیب دیده است"
* **Message:** "ساختار فایل پشتیبان (.bankyar) خوانا نیست. این فایل ناقص است یا دچار خرابی شده است."
* **Form / Actions:**
  * **Logical Start Button (Right):** "انتخاب فایل دیگر" (Select Another File) - Filled button.
  * **Logical End Button (Left):** "انصراف" (Cancel) - Text button.

---

### Dialog 8: Wrong Decryption PIN Dialog
* **Purpose:** Warns of an invalid decryption PIN.
* **Header Icon:** `bankyar.icon.key_wrong` (Crimson error tint).
* **Title:** "پین امنیتی اشتباه است"
* **Message:** "پین وارد شده با کلید رمزگذاری فایل تطابق ندارد. لطفا پس از بررسی مجدد تلاش کنید."
* **Form / Actions:**
  * Dynamic Indicator: "تعداد تلاش‌های باقی‌مانده: ۳ بار تلاش" (Attempts remaining: 3).
  * **Logical Start Button (Right):** "ورود مجدد پین" (Re-enter PIN) - Filled button.
  * **Logical End Button (Left):** "انصراف" (Cancel) - Text button.

---

### Dialog 9: Storage Space Full Alert Dialog
* **Purpose:** Warns that there is not enough free storage space to complete a backup.
* **Header Icon:** `bankyar.icon.storage_full` (Amber warning tint).
* **Title:** "حافظه گوشی پر است"
* **Message:** "فضای کافی جهت ایجاد فایل پشتیبان جدید در دسترس نیست. حداقل به ۱۰ مگابایت فضای خالی نیاز است."
* **Form / Actions:**
  * Action: "پاک‌سازی حافظه موقت" (Prune diagnostic cache).
  * **Logical Start Button (Right):** "تلاش مجدد" (Retry) - Outlined button.
  * **Logical End Button (Left):** "لغو فرآیند" (Cancel Process) - Text button.

---

## 6. Confirmation Patterns (Deliverable 6)

To prevent accidental data loss, critical actions follow strict, deliberate patterns that require focused user confirmation.

* **Dual-State Overwrite Confirmation:** Clicking "Confirm" inside a critical restore dialog keeps the button disabled until the user checks the safety checkbox, preventing accidental overwrites.
* **Biometric Verification Prompts:** Accessing master recovery keys or executing database restores requires biometric verification, preventing unauthorized local access.
* **Scrambled Keypad Verification:** PIN verification uses a randomized, scrambled keyboard layout, protecting PIN codes from grease-trail analysis or shoulder surfing.

---

## 7. App State Designs (Deliverables 7, 8 & 9)

---

### A. Empty State Layout
* **Visual Presentation:** Displayed when no local backup files are found in history.
* **Illustration:** Muted vector outline file with disconnected lines `bankyar.icon.search_empty` (Centered horizontally).
* **Title:** "هیچ فایل پشتیبان محلی یافت نشد" (No local backups found).
* **Subtitle:** "توصیه می‌شود جهت محافظت از تراکنش‌ها در برابر گم‌شدن یا خرابی گوشی، همین حالا اولین فایل پشتیبان خود را بسازید."
* **Primary Action Button:** "ایجاد اولین فایل پشتیبان" (Create First Backup) - Large filled button with leading icon.

---

### B. Error State Layout
* **Visual Presentation:** Displays when database access or restore validation fails.
* **Border Style:** Card borders flash with standard error accent lines.
* **Inline Warning Banner:** High-contrast warning banner displays: "خطایی در خواندن اطلاعات محلی رخ داده است".
* **Descriptive Copy:** "فایل پشتیبان انتخاب‌شده به علت خطای رمزگشایی یا تطابق نسخه پایگاه داده قابل بارگذاری نیست."
* **Primary Recovery Button:** "تلاش مجدد با کلید رمز عبور دیگر" (Retry with another password).
* **Secondary Action Button:** "مشاهده گزارش خطا" (View Diagnostic Logs).

---

### C. Success State Layout
* **Visual Presentation:** Full-screen success overlay displayed when a backup or restore completes.
* **Illustration:** Green checkmark inside a secure shield.
* **Title:** "اطلاعات با موفقیت بازیابی شد" (Data restored successfully).
* **Subtitle:** "۲۴۰ تراکنش جدید به تاریخچه شما اضافه شد. برنامه مجدداً بارگذاری خواهد شد."
* **Primary Action Button:** "ورود به دفترچه تراکنش‌ها" (Enter Ledger) - Large filled button.

---

## 8. Accessibility & Inclusive Design Review (Deliverable 10)

This interface is designed to comply with WCAG 2.1 AA accessibility standards:

* **Grouping Focus Nodes:** Matched backup history items are grouped into single semantic blocks, allowing screen readers to read timestamps, sizes, and states continuously without interrupting focus.
* **Touch Target Size:** Small buttons, chevrons, and checkboxes expand their touch targets invisibly to meet the 48-unit physical minimum, assisting users with motor impairments.
* **Large Text Wrapping:** Form layouts and progress bars use responsive heights and wrap vertically, preventing text clipping under 200% system font magnification.
* **Dynamic Contrast Mapping:** Text elements and status indicators use high-contrast color tokens (minimum 4.5:1 contrast ratio) in both light and dark themes.
* **Color-Independent Status Indicators:** Database health scores and verification states use clear text labels and icons, never relying on green/red color alone.

---

## 9. RTL Persian Native Layout Review (Deliverable 11)

* **Logical Direction Mapping:** Left/right properties are completely excluded from definitions. The layout uses logical start/end coordinates, ensuring alignments mirror automatically when switching locales.
* **Directional Icon Mirroring:** Navigation back chevrons (`bankyar.icon.back.rtl`), progress bar filling, and list layouts mirror dynamically based on active language direction.
* **RTL Baseline Alignment:** Icons paired with text are aligned logical-start (to the right of the text block), separated by an 8-unit spatial gap token.
* **Fuzzy Persian Numerals Compatibility:** Displays both localized Persian monospace digits ("۴۵٪") and standard Latin digits based on user preferences.

---

## 10. Operational Guidelines & Checklists (Deliverables 12, 13 & 14)

---

### A. Backup UX Checklist
- [ ] Confirms database write lock is active before starting compression.
- [ ] Confirms the encrypted backup file has been written completely before releasing the transaction lock.
- [ ] Verifies checksum signature before displaying the success state.
- [ ] Verifies the file path is accessible and readable under on-device isolation.
- [ ] Prompts biometric authentication before generating the 12-word master recovery phrase.

---

### B. Recovery UX Checklist
- [ ] Performs a checksum check on chosen files before starting decryption.
- [ ] Displays a side-by-side database comparison before overwriting data.
- [ ] Restricts PIN verification attempts to a maximum of 3, initiating lockouts if exceeded.
- [ ] Ensures active transactions are rolled back completely if restoration fails mid-process, preserving database safety.
- [ ] Forces an app reload on successful restoration to refresh database indexes.

---

### C. UI Validation Checklist
- [ ] **100% Token Compliance:** Color, margin, padding, border, and corner curve properties map directly to active design tokens, with zero hardcoded values.
- [ ] **No Forbidden Elements:** No HEX color codes, physical units (px, dp, sp), or platform-specific layouts exist in the file.
- [ ] **RTL Flow Compliance:** Reading lines, back chevrons, list flows, and swipe gestures mirror naturally from right to left (RTL).
- [ ] **Minimum Touch Targets Met:** Interactive buttons and lists maintain a minimum height of `bankyar.space.xl` (48-unit touch target).
- [ ] **Multi-Theme Stability:** Components adapt dynamically between light, dark, and high-contrast themes.

---

## 11. Governance & Platform Independence Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Platform Independence:** The layout must remain platform-independent, relying strictly on relative spacing blocks and logical components rather than framework-specific hacks.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.

---
**End of Specification Document**
