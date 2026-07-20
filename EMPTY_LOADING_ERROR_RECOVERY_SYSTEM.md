# BankYar Empty, Loading, Error, Offline, Permission & Recovery Experience System Specification

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification (Restricted)
**Document Version:** 2.0.0
**Design Language:** Material Design 3
**Target Language:** Persian (RTL)
**Status:** Approved / Production-Ready Baseline

---

## 1. Executive Summary & Core Philosophy

BankYar is an offline-first, privacy-by-design financial personal ledger that captures, normalizes, and manages transactions on-device from SMS message streams. Because the application possesses zero internet access, its resilience, error-recovery mechanisms, wait-states, and empty configurations cannot rely on server intervention. They must be entirely self-sufficient, predictable, accessible, and designed to inspire trust in Persian-speaking users managing sensitive financial ledgers.

This specification serves as the absolute visual, operational, and interaction design authority for every non-ideal state within BankYar. No presentation details are hardcoded. Visual elements, animations, and typography rely entirely on semantic tokens.

---

## 2. Writing Tone Guidelines

To establish professional financial credibility and reduce user cognitive friction, all copy must follow these strict tone guidelines:

### Success Messages
* **Tone:** Celebratory but stoic, objective, and reassuring.
* **Guideline:** Clearly state the outcome and confirm the safety of local data. Avoid overly dramatic animations or casual speech.
* **Example:** `پشتیبان‌گیری امن با موفقیت روی حافظه دستگاه ذخیره شد.`

### Error Messages
* **Tone:** Supportive, transparent, informative, and completely non-punitive.
* **Guideline:** Never blame the user. Avoid technical logs, system trace stack outputs, or SQLite/SQLCipher codes in user-facing views. Always explain *why* the failure occurred and present an immediate path to correction.
* **Example:** `امکان ذخیره‌سازی فایل پشتیبان به دلیل کمبود فضای ذخیره وجود ندارد. لطفاً مقداری فضا آزاد کنید و دوباره تلاش کنید.`

### Warning Messages
* **Tone:** Preventative, transparent, and direct.
* **Guideline:** Inform the user of immediate trade-offs or risks (e.g., potential data loss in hardware failure if backups are missing) without inducing panic.
* **Example:** `بدون ایجاد فایل پشتیبان، در صورت مفقود شدن دستگاه، دسترسی به تراکنش‌ها غیرقابل بازگشت خواهد بود.`

### Permission Requests
* **Tone:** Grounded in privacy and user benefit.
* **Guideline:** Explicitly state the direct user benefit and emphasize that data remains isolated on the local device with zero external telemetry.
* **Example:** `برای ثبت و دسته‌بندی خودکار تراکنش‌ها، دسترسی به پیامک‌های بانکی روی دستگاه شما ضروری است. اطلاعات شما از روی گوشی خارج نمی‌شوند.`

### Recovery Instructions
* **Tone:** Step-by-step, actionable, and clear.
* **Guideline:** Use precise verbs and order operations sequentially.
* **Example:**
  1. `فایل پشتیبان با پسوند ویژه را انتخاب کنید.`
  2. `گذرواژه اصلی رمزگذاری را وارد نمایید.`
  3. `تکمه بازیابی داده‌ها را فشار دهید.`

### Offline Messages
* **Tone:** Calming and proactive.
* **Guideline:** Remind the user that the app operates fully offline by design, ensuring complete ledger availability and absolute security without internet connectivity.
* **Example:** `داده‌های مالی شما در صندوقچه امن آفلاین نگهداری می‌شوند و همیشه در دسترس شما قرار دارند.`

---

## 3. Universal Accessibility Mandates

All wait, empty, offline, and error experiences must conform to strict inclusive design requirements, programmatically validated by system testing frameworks:

### Screen Reader Support
* All illustrations, progress indicators, shimmer skeletons, and interactive state triggers must carry highly localized semantic descriptions via native platform accessibility structures.
* Screen readers must announce current percentages (e.g., progress updates) and immediate status changes dynamically.

### Large Font Support
* Text blocks within empty and error screens must adapt dynamically to larger text sizes up to two hundred percent scale.
* Components must use flexible wrapping structures and multi-line text blocks to prevent truncation or visual clipping on high-density viewports.

### Color Blind Safe Indicators
* Do not rely solely on red, green, or yellow indicators to communicate state.
* System changes, warning boxes, and error alerts must combine distinct typographic states, visual shapes, outline boundaries, and custom iconography to guarantee clarity.

### Reduced Motion Alternatives
* If the user enables reduced motion in system configurations, all sweeping skeleton animations, pulsating glows, and interactive card transitions must deactivate.
* Animated components must revert to instantaneous visual state swaps or simple alpha transitions.

### Minimum Touch Target Footprint
* All interactive recovery triggers, buttons, cards, and input fields must support a minimum physical interaction boundary of forty-eight density-independent units.
* Ensure generous margins around interactive elements to prevent accidental input drift.

---

## 4. Empty State Master Specifications

Every empty state within BankYar represents an opportunity to guide, onboard, and reassure the user. They are designed to prevent the feeling of a broken UI and encourage the next logical interaction.

### 4.1 No Transactions Yet
* **Purpose:** Instruct the user on how to populate the database upon first launch or database reset.
* **User Emotion:** Optimism, curiosity, combined with high security expectation.
* **Primary Message:** `تراکنشی ثبت نشده است`
* **Secondary Message:** `پیامک‌های بانکی دریافتی شما به صورت خودکار و آفلاین در این بخش دسته‌بندی می‌شوند. همچنین می‌توانید تراکنش‌ها را دستی اضافه کنید.`
* **Illustration Guidance:** Metaphorical graphic representing an empty, secured safe box, styled with clean, minimal outline strokes using the color token `bankyar.semantic.color.illustration.primary`.
* **Icon Guidance:** `bankyar.icon.system.ledger.empty` (Mirrored in RTL).
* **Primary Action:** `فعال‌سازی دریافت خودکار`
* **Secondary Action:** `ثبت تراکنش دستی`
* **Recovery Path:** Trigger SMS permissions flow or open manual transaction sheet.
* **Accessibility Notes:** Semantic label: "صفحه تراکنش‌ها خالی است. راهنمای دریافت خودکار یا ثبت دستی در دسترس است."
* **RTL Notes:** Symmetrical horizontal centering, Persian baseline spacing applied.
* **Animation Guidance:** Fade-in transition using `bankyar.motion.curve.standard_easing` with `bankyar.motion.duration.medium`.
* **Future Expansion:** Smart onboarding helper based on detected regional banking patterns.

### 4.2 No Search Results
* **Purpose:** Inform the user that their current ledger search criteria returned zero matching rows.
* **User Emotion:** Focus, mild confusion, reassurance needed that data is not lost.
* **Primary Message:** `تراکنشی یافت نشد`
* **Secondary Message:** `هیچ تراکنشی منطبق با عبارت جستجو شده پیدا نشد. لطفاً املاء کلمات را بررسی کنید یا عبارت ساده‌تری وارد کنید.`
* **Illustration Guidance:** Minimalist magnifying glass pointing toward an empty document outline.
* **Icon Guidance:** `bankyar.icon.system.search.empty`.
* **Primary Action:** `پاک کردن جستجو`
* **Secondary Action:** `تغییر معیارهای فیلتر`
* **Recovery Path:** Reset query field to empty, returning the user to the default ledger list.
* **Accessibility Notes:** Announced via accessibility live region: "نتیجه‌ای برای جستجو یافت نشد."
* **RTL Notes:** Text alignment right-to-left. Magnifying glass icon flipped symmetrically.
* **Animation Guidance:** Subtle scale-in of the informational banner.
* **Future Expansion:** Suggesting related synonyms or close matches from the local database.

### 4.3 No Filter Results
* **Purpose:** Handle scenario where active category, date-range, or bank-card filters isolate zero records.
* **User Emotion:** Practical, analytical, needing easy reset.
* **Primary Message:** `فیلتر انتخابی بدون نتیجه`
* **Secondary Message:** `هیچ تراکنشی در محدوده فیلترهای اعمال شده یافت نشد. می‌توانید با حذف فیلترها به لیست کامل بازگردید.`
* **Illustration Guidance:** Funnel illustration with dashed lines representing unfiltered entries.
* **Icon Guidance:** `bankyar.icon.system.filter.empty`.
* **Primary Action:** `حذف تمامی فیلترها`
* **Secondary Action:** `ویرایش فیلترها`
* **Recovery Path:** Instantly clear active filter providers, returning the view to the full ledger.
* **Accessibility Notes:** Accessibility label: "فیلتر فعال نتیجه‌ای ندارد. تکمه حذف فیلترها آماده کلیک است."
* **RTL Notes:** Filter tags horizontal scroll layout flows from right to left.
* **Animation Guidance:** Horizontal sliding transition on tag removal.
* **Future Expansion:** Quick-save search filters for fast access.

### 4.4 No Statistics Available
* **Purpose:** Inform the user that charts and financial summaries cannot render without transaction data.
* **User Emotion:** Eager to see insights, needs direction on how to populate charts.
* **Primary Message:** `گزارش‌های تحلیلی آماده نیستند`
* **Secondary Message:** `نمودارهای مدیریت مالی پس از ثبت حداقل چند تراکنش به صورت کاملاً آفلاین فعال می‌شوند. اولین تراکنش خود را ثبت کنید.`
* **Illustration Guidance:** Ghost-charts containing dashed bar profiles and subtle dotted circular graphs.
* **Icon Guidance:** `bankyar.icon.system.analytics.empty`.
* **Primary Action:** `ثبت اولین تراکنش`
* **Secondary Action:** `وارد کردن فایل پشتیبان`
* **Recovery Path:** Route user to SMS scan configuration or transaction creation view.
* **Accessibility Notes:** Announcement: "بخش آمار فاقد اطلاعات است. پس از ورود تراکنش‌ها فعال می‌شود."
* **RTL Notes:** Dynamic chart layouts flow chronologically from right to left (past to present).
* **Animation Guidance:** Shimmer skeleton pulse on background card areas.
* **Future Expansion:** Interactive simulation mode demonstrating analytics features to new users.

### 4.5 No Notifications
* **Purpose:** Show that the system notification log is clean and up to date.
* **User Emotion:** Calm, organized, peaceful.
* **Primary Message:** `صندوق پیام‌ها خالی است`
* **Secondary Message:** `اطلاعیه‌های سیستم، هشدار پشتیبان‌گیری و اعلانات مربوط به تراکنش‌های جدید در این بخش به شما اطلاع داده می‌شوند.`
* **Illustration Guidance:** Closed envelope with a gentle check badge overlay.
* **Icon Guidance:** `bankyar.icon.system.notifications.empty`.
* **Primary Action:** `بازگشت به پیشخوان`
* **Secondary Action:** `تنظیمات اعلانات`
* **Recovery Path:** Navigate the user back to the primary dashboard view.
* **Accessibility Notes:** Announced as "هیچ پیام جدیدی در صندوق اعلانات وجود ندارد."
* **RTL Notes:** Navigation icon located on the right edge.
* **Animation Guidance:** Fade transition on card exit.
* **Future Expansion:** Priority-sorted notification grouping.

### 4.6 No Backup Found
* **Purpose:** Warn the user when entering the restore section with no locally stored `.bankyar` files.
* **User Emotion:** Safety-conscious, potentially concerned about data security.
* **Primary Message:** `هیچ فایل پشتیبانی پیدا نشد`
* **Secondary Message:** `هیچ فایل پشتیبان پیش‌فرضی روی حافظه داخلی دستگاه پیدا نشد. می‌توانید یک فایل پشتیبان جدید ایجاد کنید یا فایلی را دستی وارد کنید.`
* **Illustration Guidance:** Dotted folder outline indicating missing backup archives.
* **Icon Guidance:** `bankyar.icon.system.backup.missing`.
* **Primary Action:** `ایجاد فایل پشتیبان جدید`
* **Secondary Action:** `انتخاب دستی فایل از دستگاه`
* **Recovery Path:** Trigger the secure backup generation workflow or open the system file picker.
* **Accessibility Notes:** Semantic read-out prioritizing the absolute importance of local backups.
* **RTL Notes:** Text alignment matching standard Persian typography standards.
* **Animation Guidance:** Slow, ambient breathing transition on backup icon.
* **Future Expansion:** Automatic localized directory scanning.

### 4.7 No Notes
* **Purpose:** State when a transaction detail sheet is loaded but contains zero user notes.
* **User Emotion:** Focused, analytical.
* **Primary Message:** `یادداشتی ثبت نشده است`
* **Secondary Message:** `می‌توانید برای طبقه‌بندی دقیق‌تر امور مالی خود، توضیحات و یادداشت‌های خصوصی به این تراکنش اضافه کنید.`
* **Illustration Guidance:** Document page outline with horizontal pencil sketch lines.
* **Icon Guidance:** `bankyar.icon.system.notes.empty`.
* **Primary Action:** `افزودن اولین یادداشت`
* **Secondary Action:** `بستن صفحه جزئیات`
* **Recovery Path:** Focus input cursor directly onto the note entry field.
* **Accessibility Notes:** Focus transition immediately shifts to the action button on screen load.
* **RTL Notes:** Pencil icon oriented from left to right to align with standard handwriting motion.
* **Animation Guidance:** Elastic input expand curve.
* **Future Expansion:** Local speech-to-text note conversion.

### 4.8 No Favorite Transactions
* **Purpose:** Display state when ledger is filtered to show only starred/pinned entries, but none are active.
* **User Emotion:** Mild disappointment, desire for quick adjustment.
* **Primary Message:** `تراکنش برگزیده‌ای یافت نشد`
* **Secondary Message:** `با ستاره‌دار کردن تراکنش‌های مهم یا تکراری در صفحه جزئیات، می‌توانید در این بخش دسترسی سریع به آن‌ها داشته باشید.`
* **Illustration Guidance:** Star outline with a dashed path pattern looping around it.
* **Icon Guidance:** `bankyar.icon.system.favorites.empty`.
* **Primary Action:** `مشاهده لیست کل تراکنش‌ها`
* **Secondary Action:** `راهنمای افزودن برگزیده‌ها`
* **Recovery Path:** Clear favorite filter, resetting ledger views.
* **Accessibility Notes:** Semantic description: "لیست علاقه‌مندی‌ها خالی است. تراکنش برگزیده‌ای اضافه نشده است."
* **RTL Notes:** Star layout centered symmetrically.
* **Animation Guidance:** Scale transition using standard spring curves.
* **Future Expansion:** Automatically pinning frequent transactions based on recurring local patterns.

### 4.9 No Supported Banks Detected
* **Purpose:** Warn the user when imported SMS content does not contain recognized bank messaging patterns.
* **User Emotion:** Concern, frustration, desire for immediate tool validation.
* **Primary Message:** `بانک معتبری شناسایی نشد`
* **Secondary Message:** `پیامک‌های دریافتی با الگوهای پیش‌فرض همخوانی ندارند. می‌توانید قالب‌های اختصاصی بانک خود را تعریف کنید.`
* **Illustration Guidance:** Generic credit card shape with a dashed question mark.
* **Icon Guidance:** `bankyar.icon.system.bank.missing`.
* **Primary Action:** `تعریف قالب پیامک اختصاصی`
* **Secondary Action:** `وارد کردن دستی اطلاعات بانک`
* **Recovery Path:** Route to Bank Management and custom SMS regex configuration panels.
* **Accessibility Notes:** Focus assigned directly to the custom templates wizard.
* **RTL Notes:** Dynamic text flow displaying local banks on custom scroll widgets.
* **Animation Guidance:** Shake animation indicating validation warning.
* **Future Expansion:** Automated offline heuristic mapping for unrecognized regional SMS configurations.

---

## 5. Loading State Master Specifications

Loading states must communicate process progression to eliminate anxiety regarding device freeze-ups and performance degradation.

### 5.1 Initial App Launch
* **Purpose:** System initialization, configuration check, secure key verification, and UI boot.
* **User Emotion:** Anticipation, high security expectation.
* **Primary Message:** `در حال راه‌اندازی امن`
* **Secondary Message:** `امنیت صندوقچه مالی شما در حال بررسی و تایید است. این فرآیند به صورت کاملاً آفلاین روی دستگاه شما انجام می‌شود.`
* **Illustration Guidance:** High-fidelity geometric shield icon animating smoothly.
* **Icon Guidance:** `bankyar.icon.system.security.active`.
* **Primary Action:** None (interaction is locked during app boot).
* **Secondary Action:** None.
* **Recovery Path:** Automated timeout redirecting to emergency diagnostics console if load halts.
* **Accessibility Notes:** Semantic read-out: "برنامه در حال بررسی امنیت و آماده‌سازی داده‌ها است. لطفاً منتظر بمانید."
* **RTL Notes:** Circular ring rotates clockwise to maintain universal visual expectations.
* **Animation Guidance:** Seamless infinite pulsing shield glow.
* **Future Expansion:** Pre-compiling layout indices to reduce launch times.

### 5.2 Dashboard Loading
* **Purpose:** Compile local balance numbers, recent categories, and active alerts.
* **User Emotion:** Focused, desires immediate data presentation.
* **Primary Message:** `به‌روزرسانی پیشخوان`
* **Secondary Message:** `در حال محاسبه وضعیت کلی مالی شما...`
* **Illustration Guidance:** Shimmering grid block structures representing top dashboard card segments.
* **Icon Guidance:** `bankyar.icon.system.dashboard.loading`.
* **Primary Action:** None.
* **Secondary Action:** None.
* **Recovery Path:** If load exceeds threshold, fallback to rendering last cached local database state.
* **Accessibility Notes:** Screen readers read: "پیشخوان در حال به‌روزرسانی است."
* **RTL Notes:** Shimmer sweep animation flows from right to left to align with Persian layout.
* **Animation Guidance:** Seamless horizontal shimmer sweep.
* **Future Expansion:** Lazy-loading deep statistics after top-level summaries render.

### 5.3 Transaction List Loading
* **Purpose:** Render list rows for transaction ledger view.
* **User Emotion:** Impatient, practical.
* **Primary Message:** `بارگذاری تراکنش‌ها`
* **Secondary Message:** `در حال بازیابی آخرین وقایع ثبت شده...`
* **Illustration Guidance:** List item skeleton mock masks with circular profile areas and rounded block text rows.
* **Icon Guidance:** `bankyar.icon.system.ledger.loading`.
* **Primary Action:** None.
* **Secondary Action:** `توقف عملیات بارگذاری`
* **Recovery Path:** Safe stream interrupt, showing already-loaded local items.
* **Accessibility Notes:** Accessible progress feedback: "لیست تراکنش‌ها در حال دریافت است."
* **RTL Notes:** Text skeletons aligned right. Circular profiles positioned on the right edge of list elements.
* **Animation Guidance:** Linear gradient sweep, fading out when complete.
* **Future Expansion:** Infinite scroll with memory recycling to prevent layout overhead.

### 5.4 Statistics Loading
* **Purpose:** Aggregate values and compile coordinates for financial charts.
* **User Emotion:** Analytical, curious.
* **Primary Message:** `تحلیل آماری تراکنش‌ها`
* **Secondary Message:** `در حال محاسبه توزیع هزینه‌ها و درآمدهای شما...`
* **Illustration Guidance:** Dynamic fading bars and pie segments shimmering.
* **Icon Guidance:** `bankyar.icon.system.statistics.loading`.
* **Primary Action:** None.
* **Secondary Action:** None.
* **Recovery Path:** Fallback to simple tabulated tabular representation if chart rendering engine fails.
* **Accessibility Notes:** Accessibility readout: "نمودارهای تحلیلی در حال ترسیم هستند."
* **RTL Notes:** Trend graph calculations start from the right-hand origin coordinate.
* **Animation Guidance:** Ease-in-out chart coordinate draw lines.
* **Future Expansion:** Aggressive background calculation caches.

### 5.5 Search Loading
* **Purpose:** Real-time on-device query parsing across tables.
* **User Emotion:** Focused, expects immediate visual feedback.
* **Primary Message:** `جستجوی امن داده‌ها`
* **Secondary Message:** `در حال بازرسی پایگاه داده محلی...`
* **Illustration Guidance:** Inline circular spinner on standard search field.
* **Icon Guidance:** `bankyar.icon.system.search.loading`.
* **Primary Action:** None.
* **Secondary Action:** `لغو جستجو`
* **Recovery Path:** Instantly clear active search text provider, restoring default ledger view.
* **Accessibility Notes:** "در حال جستجوی عبارت..." announced to live regional listeners.
* **RTL Notes:** Left-aligned loading ring in search bars to avoid overlap with right-aligned Persian search text.
* **Animation Guidance:** Constant angular velocity spin.
* **Future Expansion:** Pre-indexing transaction tags for faster response.

### 5.6 Backup Creation
* **Purpose:** Encrypt and compress SQLite file using user password.
* **User Emotion:** Security-focused, responsible.
* **Primary Message:** `ساخت فایل پشتیبان امن`
* **Secondary Message:** `داده‌های شما با الگوریتم‌های پیشرفته در حال رمزگذاری و تبدیل به فایل هستند...`
* **Illustration Guidance:** Shield icon merging into a structured folder outline.
* **Icon Guidance:** `bankyar.icon.system.backup.creating`.
* **Primary Action:** None (blocking operation).
* **Secondary Action:** None.
* **Recovery Path:** Revert file creation steps, wipe incomplete export caches, unlock interface.
* **Accessibility Notes:** Linear progress updates read out loud at periodic intervals.
* **RTL Notes:** Progress indicator flows from right to left.
* **Animation Guidance:** Circular looping keyhole indicator with soft progress sweeps.
* **Future Expansion:** Automatic background scheduling of encrypted local backups.

### 5.7 Backup Restore
* **Purpose:** Extract, decrypt, and verify external database file.
* **User Emotion:** High anxiety, hope for data recovery.
* **Primary Message:** `بازیابی پایگاه داده`
* **Secondary Message:** `در حال بررسی صحت ساختار و رمزگشایی فایل پشتیبان...`
* **Illustration Guidance:** Stepped checklist showing verified items.
* **Icon Guidance:** `bankyar.icon.system.backup.restoring`.
* **Primary Action:** None (interaction is locked to prevent data corruption).
* **Secondary Action:** None.
* **Recovery Path:** On failure, abort import steps, rollback database transactions, keep existing database untouched.
* **Accessibility Notes:** Announces each checklist phase step as it is processed by the decrypter.
* **RTL Notes:** Right-aligned lists with Persian step markers.
* **Animation Guidance:** Fade in checkmarks on step completion.
* **Future Expansion:** Automated schema migration during backup imports.

### 5.8 Permission Verification
* **Purpose:** Inspect system database parameters to verify active Android permissions.
* **User Emotion:** Practical, safety-conscious.
* **Primary Message:** `بررسی دسترسی‌های سیستم`
* **Secondary Message:** `در حال تایید دسترسی‌های امنیتی دستگاه...`
* **Illustration Guidance:** Key and lock aligning smoothly.
* **Icon Guidance:** `bankyar.icon.system.permission.checking`.
* **Primary Action:** None.
* **Secondary Action:** None.
* **Recovery Path:** Fallback to educational manual permission guides.
* **Accessibility Notes:** Accessible announcement: "در حال بررسی دسترسی به پیامک‌ها."
* **RTL Notes:** Standard visual layout alignment.
* **Animation Guidance:** Simple rotation of security token icon.
* **Future Expansion:** Quick permission diagnostics dialog.

### 5.9 Security Check
* **Purpose:** Execute local cryptographic verification, jailbreak detection, and tamper validation.
* **User Emotion:** Peace of mind, financial safety reassurance.
* **Primary Message:** `تایید یکپارچگی برنامه`
* **Secondary Message:** `بررسی امنیت محیط اجرای برنامه برای حفاظت از دارایی‌های اطلاعاتی شما...`
* **Illustration Guidance:** Circular radar scanning an abstract hardware microchip layout.
* **Icon Guidance:** `bankyar.icon.system.security.checking`.
* **Primary Action:** None.
* **Secondary Action:** None.
* **Recovery Path:** Lock app execution if malicious root environment modifications are detected.
* **Accessibility Notes:** "برنامه در حال بررسی امنیت فیزیکی دستگاه است" read clearly.
* **RTL Notes:** Radar sweep lines match right-to-left layout symmetry.
* **Animation Guidance:** Soft radial sweep transition.
* **Future Expansion:** Automated sandboxed cryptographic hardware checks.

### 5.10 Database Migration
* **Purpose:** Restructure SQLite tables to support new application updates without data loss.
* **User Emotion:** Patient, expecting system to self-maintain successfully.
* **Primary Message:** `به‌روزرسانی ساختار داده‌ها`
* **Secondary Message:** `در حال انتقال ایمن جدول تراکنش‌ها به ساختار جدید. اطلاعات شما حذف نخواهند شد.`
* **Illustration Guidance:** Database cylinders transitionally connecting via clean flow lines.
* **Icon Guidance:** `bankyar.icon.system.database.migrating`.
* **Primary Action:** None (blocking operation).
* **Secondary Action:** None.
* **Recovery Path:** Transaction rollback to previous schema version if migration fails.
* **Accessibility Notes:** Priority message: "جداول اطلاعات در حال به‌روزرسانی هستند. لطفاً تلفن همراه را خاموش نکنید."
* **RTL Notes:** Horizontal flow arrows point from right to left.
* **Animation Guidance:** Synchronized cyclic loading indicator.
* **Future Expansion:** Multi-version backward migration paths.

---

## 6. Error State Master Specifications

Errors are visual maps designed to help users resolve issues independently. They must not contain confusing stack traces, system crash dumps, or blame.

### 6.1 Database Error
* **Purpose:** Handle general SQLite database failures or locked file access.
* **User Emotion:** Concern, fear of data loss.
* **Primary Message:** `اختلال در دسترسی به صندوق اطلاعات`
* **Secondary Message:** `بانک اطلاعات محلی موقتاً در دسترس نیست. ممکن است فایل پایگاه داده توسط سیستم قفل شده باشد. لطفاً برنامه را مجدداً راه‌اندازی کنید.`
* **Illustration Guidance:** Database cylinder with an adjacent diagnostic warning badge.
* **Icon Guidance:** `bankyar.icon.system.database.error`.
* **Primary Action:** `راه‌اندازی مجدد برنامه`
* **Secondary Action:** `نمایش جزئیات عیب‌یابی`
* **Recovery Path:** Clear connection pools, vacuum database, flush cached memory.
* **Accessibility Notes:** "خطای دسترسی به داده‌ها رخ داده است. تکمه راه‌اندازی مجدد آماده است."
* **RTL Notes:** Symmetrical center alignment for diagnostic tables.
* **Animation Guidance:** Soft double-pulse shake effect on database icon.
* **Future Expansion:** Automated database file repair tools.

### 6.2 Backup Failure
* **Purpose:** Handle errors when saving encrypted `.bankyar` backups (e.g., storage full).
* **User Emotion:** Annoyance, concern about data protection.
* **Primary Message:** `ذخیره‌سازی پشتیبان ناموفق بود`
* **Secondary Message:** `ایجاد فایل پشتیبان متوقف شد. فضای کافی روی دستگاه وجود ندارد یا فایل‌های سیستمی مسدود شده‌اند.`
* **Illustration Guidance:** Backup archive folder marked with a warning line.
* **Icon Guidance:** `bankyar.icon.system.backup.failed`.
* **Primary Action:** `تلاش مجدد`
* **Secondary Action:** `انتخاب مسیر ذخیره جایگزین`
* **Recovery Path:** Free space audit, choose alternative partition via standard storage framework.
* **Accessibility Notes:** Warning alert sound triggered, screen reader reads error details.
* **RTL Notes:** Status icons and descriptions align to standard RTL hierarchy.
* **Animation Guidance:** Slide-in alert dialog.
* **Future Expansion:** Selective transaction backup filtering to reduce archive size.

### 6.3 Restore Failure
* **Purpose:** Backup import interrupted due to parsing corruption or incorrect password.
* **User Emotion:** Disappointment, concern about data loss.
* **Primary Message:** `بازیابی اطلاعات انجام نشد`
* **Secondary Message:** `ساختار فایل پشتیبان معتبر نیست یا رمز عبور وارد شده اشتباه است. لطفاً فایل را بررسی و دوباره تلاش کنید.`
* **Illustration Guidance:** Fragmented database cylinder with a key icon showing error status.
* **Icon Guidance:** `bankyar.icon.system.restore.failed`.
* **Primary Action:** `ورود مجدد رمز عبور`
* **Secondary Action:** `انتخاب فایل پشتیبان دیگر`
* **Recovery Path:** Flush decryption keys from memory, return to backup import dashboard.
* **Accessibility Notes:** "خطای بازیابی داده‌ها. تایید گذرواژه با مشکل مواجه شد" announced clearly.
* **RTL Notes:** Right-to-left list of verification steps with status markers.
* **Animation Guidance:** Shake animation on PIN/password field.
* **Future Expansion:** Interactive backup integrity validation reports.

### 6.4 Permission Denied
* **Purpose:** User rejected SMS or local storage permission checks.
* **User Emotion:** Protective, cautious, needs reassurance of benefits.
* **Primary Message:** `عدم دسترسی به پیامک‌های بانکی`
* **Secondary Message:** `برای ردیابی خودکار تراکنش‌ها نیاز به دسترسی پیامک داریم. بدون این دسترسی، برنامه فقط به صورت ثبت دستی کار خواهد کرد.`
* **Illustration Guidance:** Hand icon in front of SMS speech bubbles.
* **Icon Guidance:** `bankyar.icon.system.permission.denied`.
* **Primary Action:** `اعطای دسترسی در تنظیمات دستگاه`
* **Secondary Action:** `ادامه به صورت ثبت دستی`
* **Recovery Path:** Redirect directly to BankYar OS system settings page.
* **Accessibility Notes:** Priority explanation: "دسترسی پیامک غیرفعال است. می‌توانید از بخش تنظیمات آن را فعال نمایید."
* **RTL Notes:** Right-aligned permission steps list.
* **Animation Guidance:** Alert bar slide-down.
* **Future Expansion:** Inline mini-video demonstration explaining why permissions are secure.

### 6.5 SMS Access Failed
* **Purpose:** Hardware interface block preventing SMS reading.
* **User Emotion:** Annoyed, confused.
* **Primary Message:** `خطا در برقراری ارتباط با سیستم پیامک`
* **Secondary Message:** `سیستم‌عامل اندروید امکان خواندن پیامک‌ها را موقتاً مسدود کرده است. ممکن است برنامه‌های امنیتی مانع شده باشند.`
* **Illustration Guidance:** Message bubble with a jagged crack pattern.
* **Icon Guidance:** `bankyar.icon.system.sms.failed`.
* **Primary Action:** `بررسی دسترسی‌های سیستم`
* **Secondary Action:** `راهنمای رفع مشکل امنیتی`
* **Recovery Path:** Run diagnostic permission verification sweeps, prompt user to reboot device.
* **Accessibility Notes:** Text labels adapt to dynamic font scaling settings up to two hundred percent.
* **RTL Notes:** Text layouts flow naturally from right to left.
* **Animation Guidance:** Quick fade-in alert modal.
* **Future Expansion:** Clipboard scanning fallback guides.

### 6.6 Storage Access Failed
* **Purpose:** Storage API is unreadable due to system locks or directory changes.
* **User Emotion:** Annoyed.
* **Primary Message:** `دسترسی به حافظه دستگاه مسدود است`
* **Secondary Message:** `برنامه اجازه نوشتن فایل روی دستگاه را ندارد. این مسئله مانع از ایجاد فایل‌های پشتیبان می‌شود.`
* **Illustration Guidance:** SD memory card symbol showing visual error lines.
* **Icon Guidance:** `bankyar.icon.system.storage.failed`.
* **Primary Action:** `بررسی دسترسی به حافظه`
* **Secondary Action:** `ذخیره‌سازی در پوشه موقت`
* **Recovery Path:** Prompt Android Storage Access Framework authorization dialog.
* **Accessibility Notes:** Announced as: "خطای سیستم: فایل‌های محلی مسدود هستند."
* **RTL Notes:** Right-to-left layout alignments.
* **Animation Guidance:** Modal pop transition.
* **Future Expansion:** Temporary sandbox write directories.

### 6.7 Corrupted Backup
* **Purpose:** The file selected for restore is unreadable or cryptographically invalid.
* **User Emotion:** Fear, anxiety, frustration.
* **Primary Message:** `فایل پشتیبان خراب است`
* **Secondary Message:** `ساختار داخلی این فایل پشتیبان آسیب دیده است و قابل خواندن نیست. لطفاً از فایل پشتیبان دیگری استفاده کنید.`
* **Illustration Guidance:** Archive folder with broken elements.
* **Icon Guidance:** `bankyar.icon.system.backup.corrupted`.
* **Primary Action:** `انتخاب فایل پشتیبان سالم`
* **Secondary Action:** `بررسی سلامت فایل‌های دیگر`
* **Recovery Path:** Clean temporary decryption areas, reset folder path selections.
* **Accessibility Notes:** Focus drops immediately onto the primary selection action button.
* **RTL Notes:** Symmetrical card positioning on tablet viewports.
* **Animation Guidance:** Visual shake transition on file details block.
* **Future Expansion:** Automated recovery tool for partially corrupted backup files.

### 6.8 Unsupported Backup Version
* **Purpose:** Selected backup was generated by an incompatible, outdated, or newer app version.
* **User Emotion:** Confused.
* **Primary Message:** `نسخه فایل پشتیبان ناسازگار است`
* **Secondary Message:** `این فایل پشتیبان با نسخه فعلی برنامه همخوانی ندارد. ممکن است نیاز به به‌روزرسانی برنامه یا تغییر قالب داده‌ها داشته باشید.`
* **Illustration Guidance:** Upward and downward arrows pointing to different version lines.
* **Icon Guidance:** `bankyar.icon.system.version.unsupported`.
* **Primary Action:** `به‌روزرسانی نرم‌افزار`
* **Secondary Action:** `راهنمای تبدیل نسخه فایل`
* **Recovery Path:** Keep local database protected, direct user to update download path.
* **Accessibility Notes:** Announced clearly to assistive listeners.
* **RTL Notes:** Arabic numerals inside Persian text align seamlessly.
* **Animation Guidance:** Standard slide-up screen sheet transition.
* **Future Expansion:** Automatic schema backward-compatibility adapters.

### 6.9 Security Verification Failed
* **Purpose:** Authentication PIN or fingerprint checks fail repeatedly.
* **User Emotion:** Stress, concern, caution.
* **Primary Message:** `تایید هویت ناموفق`
* **Secondary Message:** `رمز عبور یا اثر انگشت وارد شده مطابقت ندارد. برای حفظ امنیت داده‌ها، دسترسی موقتاً محدود شده است.`
* **Illustration Guidance:** Shield with an alert circle overlay.
* **Icon Guidance:** `bankyar.icon.system.security.failed`.
* **Primary Action:** `ورود مجدد رمز عبور`
* **Secondary Action:** `انتظار برای باز شدن قفل`
* **Recovery Path:** Lock input for configured timeout lengths (e.g., exponential delay counters).
* **Accessibility Notes:** Announced via immediate semantic warnings.
* **RTL Notes:** Numbers in PIN entry pad match standard regional standards.
* **Animation Guidance:** Shaking input block transition.
* **Future Expansion:** Multi-factor on-device local master recovery.

### 6.10 Unexpected Application Error
* **Purpose:** Generic catch-all error handling unexpected system exceptions.
* **User Emotion:** Surprise, mild disappointment.
* **Primary Message:** `خطای غیرمنتظره در برنامه`
* **Secondary Message:** `سیستم با یک خطای غیرمنتظره روبه‌رو شده است. اطلاعات تراکنش‌های شما محفوظ هستند. لطفاً برنامه را ببندید و دوباره باز کنید.`
* **Illustration Guidance:** Gear wheel with missing teeth or an exclamation mark badge.
* **Icon Guidance:** `bankyar.icon.system.generic.error`.
* **Primary Action:** `بستن و باز کردن مجدد برنامه`
* **Secondary Action:** `ارسال گزارش خطا به بخش عیب‌یابی`
* **Recovery Path:** Perform full memory cache flush and restart database connection pools safely.
* **Accessibility Notes:** Non-alarming, supportive copy read to assistive technology users.
* **RTL Notes:** Standard RTL alignment rules apply.
* **Animation Guidance:** Bounce-in modal box.
* **Future Expansion:** Offline diagnostic logs database package exports.

---

## 7. Offline State Master Specifications

These states manage situations where features are restricted because of the zero-network application configuration.

### 7.1 Offline Mode Active
* **Purpose:** Inform users that the application functions fully offline by design, ensuring absolute data security.
* **User Emotion:** Peace of mind, financial safety reassurance.
* **Primary Message:** `صندوقچه کاملاً آفلاین فعال است`
* **Secondary Message:** `اطلاعات مالی شما منحصراً روی این دستگاه ذخیره می‌شوند و هیچ اتصالی به اینترنت وجود ندارد. امنیت داده‌های شما تضمین شده است.`
* **Illustration Guidance:** Secured chest box inside a protective cloud layout.
* **Icon Guidance:** `bankyar.icon.system.offline.active`.
* **Primary Action:** `تایید و ادامه`
* **Secondary Action:** `مطالعه مرام‌نامه حریم خصوصی`
* **Recovery Path:** Standard dismiss behavior.
* **Accessibility Notes:** "برنامه به صورت کاملاً آفلاین کار می‌کند" read clearly.
* **RTL Notes:** Mirrored layout elements matching standard Persian visual flows.
* **Animation Guidance:** Subtle fade-in of the information dialog.
* **Future Expansion:** Detailed localized security center audits.

### 7.2 Backup Requires External Access
* **Purpose:** User triggered export, but target storage location points to external storage directory.
* **User Emotion:** Practical.
* **Primary Message:** `نیاز به مجوز ذخیره فایل`
* **Secondary Message:** `برای ذخیره‌سازی فایل پشتیبان در خارج از محیط ایزوله برنامه، تایید مجوز دسترسی به فایل‌ها توسط شما الزامی است.`
* **Illustration Guidance:** Arrow pointing outwards from a secure safe box.
* **Icon Guidance:** `bankyar.icon.system.external.needed`.
* **Primary Action:** `اعطای مجوز دسترسی`
* **Secondary Action:** `انصراف و لغو عملیات`
* **Recovery Path:** OS external storage file picker configuration validation.
* **Accessibility Notes:** Focus switches to the primary confirmation button immediately on load.
* **RTL Notes:** Standard RTL alignments.
* **Animation Guidance:** Pop visual transition.
* **Future Expansion:** Automatic cloud-free local shared directory paths.

### 7.3 Future Cloud Features Unavailable
* **Purpose:** User clicked on a future placeholder feature (such as cloud synchronization backups) while offline.
* **User Emotion:** Curiosity, anticipation.
* **Primary Message:** `ویژگی همگام‌سازی ابری غیرفعال است`
* **Secondary Message:** `در این نسخه از برنامه، برای حفظ حداکثری حریم خصوصی، قابلیت‌های ابری وجود ندارد. این ویژگی‌ها در نسخه‌های اختیاری آینده عرضه خواهند شد.`
* **Illustration Guidance:** Cloud with an overlay lock icon.
* **Icon Guidance:** `bankyar.icon.system.cloud.unavailable`.
* **Primary Action:** `متوجه شدم`
* **Secondary Action:** `عضویت در خبرنامه آفلاین`
* **Recovery Path:** Safely return user to settings screen.
* **Accessibility Notes:** Reassuring information announced: "قابلیت‌های ابری در این نسخه غیرفعال هستند."
* **RTL Notes:** Text alignment flowing right-to-left.
* **Animation Guidance:** Standard sheet transition.
* **Future Expansion:** Encrypted, zero-knowledge local Wi-Fi sync architectures.

### 7.4 Network Feature Disabled
* **Purpose:** Attempt to configure external resources (e.g., currency price monitors) while offline.
* **User Emotion:** Disappointed, practical.
* **Primary Message:** `اتصال شبکه غیرمجاز است`
* **Secondary Message:** `برای حفاظت از اطلاعات مالی شما، دسترسی به اینترنت در کد منبع برنامه به صورت فیزیکی مسدود شده است.`
* **Illustration Guidance:** Server tower with a diagonal line showing no internet access.
* **Icon Guidance:** `bankyar.icon.system.network.disabled`.
* **Primary Action:** `تایید حریم خصوصی`
* **Secondary Action:** `بستن پنجره`
* **Recovery Path:** Close dialog and revert feature toggle to disabled state.
* **Accessibility Notes:** Priority safety message read aloud.
* **RTL Notes:** Right-to-left structural flow.
* **Animation Guidance:** Alert pop-up.
* **Future Expansion:** Static price-index local database imports via offline files.

---

## 8. Permission State Master Specifications

These states manage native Android permissions flows with clear guidance.

### 8.1 SMS Access Permission Request
* **Purpose:** Educate users on why BankYar requires SMS access before launching Android's system dialogue.
* **User Emotion:** Protective, cautious, analytical.
* **Primary Message:** `چرا به پیامک‌ها نیاز داریم؟`
* **Secondary Message:** `برای ثبت خودکار تراکنش‌ها و استخراج مبالغ واریز و برداشت، دسترسی به پیامک‌ها ضروری است. تمام پردازش‌ها به صورت ۱۰۰٪ آفلاین انجام می‌شوند.`
* **Illustration Guidance:** Secure envelope shielded by a padlock.
* **Icon Guidance:** `bankyar.icon.system.sms.request`.
* **Primary Action:** `تایید و درخواست دسترسی`
* **Secondary Action:** `رد کردن و ثبت دستی`
* **Recovery Path:** Launch OS request permissions system interface.
* **Accessibility Notes:** Detailed description explaining data isolation and on-device processing.
* **RTL Notes:** Persian text alignment right-to-left.
* **Animation Guidance:** Bounce-in panel.
* **Future Expansion:** Selective bank sender number white-list configuration.

### 8.2 Storage Access Permission Request
* **Purpose:** Prompt permissions access for external local backups.
* **User Emotion:** Practical.
* **Primary Message:** `اجازه دسترسی به فایل‌ها`
* **Secondary Message:** `برای ایجاد فایل پشتیبان یا بازیابی تراکنش‌های قدیمی، برنامه نیاز به خواندن و نوشتن فایل در حافظه دستگاه دارد.`
* **Illustration Guidance:** Folder marked with double file icons.
* **Icon Guidance:** `bankyar.icon.system.storage.request`.
* **Primary Action:** `اعطای دسترسی به حافظه`
* **Secondary Action:** `فعلاً نه`
* **Recovery Path:** Trigger Android Storage Access permission request flow.
* **Accessibility Notes:** Announced clearly to assistive screens.
* **RTL Notes:** Right-aligned text flow.
* **Animation Guidance:** Slide-up panel.
* **Future Expansion:** App-specific sandboxed path utilization to bypass global file permissions completely.

### 8.3 Notification Permission Request
* **Purpose:** Prompt notifications access to inform users of processed transactions or backup schedules.
* **User Emotion:** Reassured, focused.
* **Primary Message:** `فعال‌سازی اعلانات سریع`
* **Secondary Message:** `با فعال‌سازی اعلانات، بلافاصله پس از دریافت پیامک بانکی، جزئیات تراکنش ثبت‌شده را به صورت محلی به شما گزارش می‌دهیم.`
* **Illustration Guidance:** Notification bell displaying tiny check stars.
* **Icon Guidance:** `bankyar.icon.system.notification.request`.
* **Primary Action:** `فعال کردن اعلانات`
* **Secondary Action:** `غیرفعال بماند`
* **Recovery Path:** Execute Android system notification authorization pipeline.
* **Accessibility Notes:** Focus targeted immediately to primary confirmation button.
* **RTL Notes:** Centered layout.
* **Animation Guidance:** Ringing bell icon animation.
* **Future Expansion:** Custom vibration pattern configurations for different transaction types.

---

## 9. Partial Data State Master Specifications

These states handle situations where some data is unavailable, ensuring the interface remains stable and clear.

### 9.1 SMS Partially Parsed
* **Purpose:** Warn the user when some banking messages in an import batch could not be parsed successfully.
* **User Emotion:** Focus, analytical.
* **Primary Message:** `تراکنش‌های نامشخص یافت شد`
* **Secondary Message:** `تعداد مشخصی پیامک مالی دریافت شد ولی به دلیل قالب نامشخص، امکان دسته‌بندی خودکار وجود نداشت. می‌توانید آن‌ها را بررسی کنید.`
* **Illustration Guidance:** List containing some highlighted warnings.
* **Icon Guidance:** `bankyar.icon.system.ledger.partial`.
* **Primary Action:** `بررسی پیامک‌های نامشخص`
* **Secondary Action:** `تایید بقیه موارد`
* **Recovery Path:** Route user to unparsed inbox review panel.
* **Accessibility Notes:** Screen readers read: "تراکنش‌های نامشخص موجود است. کلید بررسی در دسترس است."
* **RTL Notes:** Mirror layouts aligned with Persian numbering formats.
* **Animation Guidance:** Horizontal sliding elements.
* **Future Expansion:** Heuristic suggestions to match unknown patterns to active ledger accounts.

### 9.2 Mixed Currency / Partial Database Load
* **Purpose:** Handled when transactions from multiple currency formats (e.g., Rials vs. Tomans) load simultaneously.
* **User Emotion:** Careful, focus on accuracy.
* **Primary Message:** `تغییر در واحد مبالغ`
* **Secondary Message:** `برخی تراکنش‌ها با واحدهای پولی متفاوتی ثبت شده‌اند. برای یکپارچگی گزارش‌ها، همه مبالغ بر پایه واحد پولی مرجع نمایش داده می‌شوند.`
* **Illustration Guidance:** Multi-currency balance card with conversion visual indicators.
* **Icon Guidance:** `bankyar.icon.system.currency.mixed`.
* **Primary Action:** `بررسی واحد پولی مرجع`
* **Secondary Action:** `ادامه بدون تغییر`
* **Recovery Path:** Route to settings currency selection manager.
* **Accessibility Notes:** Dynamic text values read as "مبالغ مخلوط معادل‌سازی شدند."
* **RTL Notes:** Standard RTL layout rules.
* **Animation Guidance:** Smooth currency tag transition.
* **Future Expansion:** Automatic offline Rial-to-Toman converter configurations.

### 9.3 Historical Import with Missing Margins
* **Purpose:** Inform the user that imported historical data does not contain complete category mappings or ledger parameters.
* **User Emotion:** Analytical, patient.
* **Primary Message:** `نیاز به تکمیل دسته‌بندی قدیمی`
* **Secondary Message:** `تراکنش‌های وارد شده با موفقیت ثبت شدند، اما اطلاعات مربوط به دسته‌بندی برخی اقلام قدیمی مفقود است. مایلید آن‌ها را دستی تکمیل کنید؟`
* **Illustration Guidance:** Checklist containing highlighted warning markers on historical items.
* **Icon Guidance:** `bankyar.icon.system.history.partial`.
* **Primary Action:** `دسته‌بندی دسته جمعی تراکنش‌ها`
* **Secondary Action:** `بعداً انجام می‌دهم`
* **Recovery Path:** Open multi-select ledger editor view.
* **Accessibility Notes:** Focus switches automatically to categories editor.
* **RTL Notes:** Horizontal flow arrows flow right-to-left.
* **Animation Guidance:** Accordion expand animation.
* **Future Expansion:** Machine-learning automated local categorizations.

---

## 10. Sync State Master Specifications (Future Ready)

These states provide predictable layouts for future offline-sync additions (such as local Wi-Fi mesh databases).

### 10.1 Local Mesh/P2P Sync Pending
* **Purpose:** Display sync progress between two devices in proximity using Wi-Fi local networks.
* **User Emotion:** Expectation, analytical.
* **Primary Message:** `در حال همگام‌سازی محلی`
* **Secondary Message:** `در حال شناسایی و یکپارچه‌سازی تراکنش‌های موجود با دستگاه دوم بدون نیاز به اینترنت...`
* **Illustration Guidance:** Parallel devices sharing visual coordinate loops.
* **Icon Guidance:** `bankyar.icon.system.sync.pending`.
* **Primary Action:** `تایید و شروع همگام‌سازی`
* **Secondary Action:** `لغو عملیات`
* **Recovery Path:** Close local Wi-Fi port connections safely and rollback.
* **Accessibility Notes:** Announces connection progress updates dynamically.
* **RTL Notes:** Balanced left/right symmetrical layout cards.
* **Animation Guidance:** Soft double pulse animations.
* **Future Expansion:** Secure offline multi-signature database synchronization.

### 10.2 Multi-Device Local Database Reconciliation
* **Purpose:** Resolve conflicts when matching transactions exist on both sync targets.
* **User Emotion:** Focused, desires absolute accuracy.
* **Primary Message:** `حل اختلاف داده‌های همگام‌سازی`
* **Secondary Message:** `تعداد مشخصی تراکنش دارای اطلاعات متناقض روی دو دستگاه هستند. لطفاً نسخه معتبر را انتخاب کنید.`
* **Illustration Guidance:** Visual transaction cards side-by-side with comparison highlights.
* **Icon Guidance:** `bankyar.icon.system.sync.conflict`.
* **Primary Action:** `انتخاب نسخه جدیدتر`
* **Secondary Action:** `بررسی دستی تک تک موارد`
* **Recovery Path:** Route to side-by-side ledger visual conflict editor.
* **Accessibility Notes:** High contrast text fields displaying comparison highlights clearly.
* **RTL Notes:** Left-and-right cards aligned with RTL sequence.
* **Animation Guidance:** Ease-out slide transition.
* **Future Expansion:** Smart automated conflict resolver based on historical modification times.

---

## 11. Processing State Master Specifications

These states manage active, complex system calculations occurring on the local processor.

### 11.1 Active SMS Ledger Import In-Progress
* **Purpose:** Display status during mass historical parsing of device inbox.
* **User Emotion:** Patient, expecting system safety.
* **Primary Message:** `در حال استخراج تراکنش‌ها`
* **Secondary Message:** `پیامک‌های مالی شما در حال اسکن، تحلیل و تبدیل به تراکنش‌های تفکیک‌شده هستند. لطفاً برنامه را نبندید...`
* **Illustration Guidance:** Database ledger with animated progress indicators running down lines.
* **Icon Guidance:** `bankyar.icon.system.import.active`.
* **Primary Action:** None (blocking interface operation).
* **Secondary Action:** `توقف عملیات اسکن`
* **Recovery Path:** Stop parsing queue, preserve imported records, unlock interface.
* **Accessibility Notes:** Live percentage updates read to screen readers at intervals.
* **RTL Notes:** Symmetrical circular ring rotation.
* **Animation Guidance:** Sequential list row slide-downs.
* **Future Expansion:** Background processor thread priority optimizations.

### 11.2 Backup Archiving and Compression In-Progress
* **Purpose:** Display state during ZIP archiving, hashing, and encryption of backup files.
* **User Emotion:** Focused.
* **Primary Message:** `فشرده‌سازی و رمزگذاری پشتیبان`
* **Secondary Message:** `ساختار فایل‌های محلی در حال ایمن‌سازی و بسته‌بندی نهایی است...`
* **Illustration Guidance:** Folder being compressed into a single shield archive.
* **Icon Guidance:** `bankyar.icon.system.backup.compressing`.
* **Primary Action:** None.
* **Secondary Action:** `لغو عملیات ساخت`
* **Recovery Path:** Wipe incomplete files, close active file descriptors, return to settings.
* **Accessibility Notes:** Announced as "در حال فشرده‌سازی اطلاعات."
* **RTL Notes:** Progress bars match RTL flow.
* **Animation Guidance:** Seamless infinite horizontal slider.
* **Future Expansion:** Selective high-compression ratios.

### 11.3 Database Optimization & Vacuuming
* **Purpose:** Reorganize SQLite database indices to reclaim unused storage blocks (vacuuming).
* **User Emotion:** Reassured, expecting seamless application maintenance.
* **Primary Message:** `بهینه‌سازی فضای ذخیره اطلاعات`
* **Secondary Message:** `در حال افزایش سرعت و پاک‌سازی شاخص‌های پایگاه داده برای کارایی بهتر برنامه...`
* **Illustration Guidance:** Gears rotating inside a clean database silhouette.
* **Icon Guidance:** `bankyar.icon.system.database.vacuum`.
* **Primary Action:** None.
* **Secondary Action:** None.
* **Recovery Path:** Automated execution cleanup upon routine maintenance.
* **Accessibility Notes:** Accessible announcement reads out task description cleanly.
* **RTL Notes:** Standard centered design.
* **Animation Guidance:** Constant velocity rotating gears.
* **Future Expansion:** Automatically scheduling vacuum tasks during device idle/sleep periods.

---

## 12. State Mapping Design Tokens Matrix

To ensure visual consistency across all screens without hardcoded parameters, visual states must map directly to the active semantic design token architecture:

| State Context | Color Token Path | Icon Token | Motion Token | Accessibility Target |
| :--- | :--- | :--- | :--- | :--- |
| **Empty State Core** | `bankyar.semantic.color.text.muted` | `bankyar.icon.system.empty` | `bankyar.motion.curve.standard_easing` | Screen Reader Announcement |
| **Active Loading** | `bankyar.semantic.color.primary` | `bankyar.icon.system.loading` | `bankyar.motion.curve.linear_velocity` | Dynamic Progress Updates |
| **Critical Error** | `bankyar.semantic.color.error` | `bankyar.icon.system.error` | `bankyar.motion.curve.shake_wave` | Immediate Voice Notification |
| **Warning Banner** | `bankyar.semantic.color.warning` | `bankyar.icon.system.warning` | `bankyar.motion.curve.decelerate` | Color Independence Shape Pair |
| **Offline Focus** | `bankyar.semantic.color.success` | `bankyar.icon.system.offline` | `bankyar.motion.curve.standard_easing` | High Contrast Text Scaling |

---

## 13. Governance, Validation & Quality Assurance Rules

The Empty, Loading, Error & Offline States Specification is governed by seven strict architectural rules:

1. **No Dead Ends:** Every wait state, empty screen, and error dialog must provide a clear, logical next step or recovery action button.
2. **Preserve Data First:** Under no circumstances should a recovery flow risk deleting or overwriting user data without explicit verification and confirmation.
3. **No Direct Stack Traces:** Technical stack traces, SQL error codes, and cryptic compiler output must never be displayed in user-facing views.
4. **Zeroize Memory Securely:** Cryptographic key bytes, passwords, and decrypted PIN hashes cached in volatile RAM must be zeroized immediately upon transaction rollback or cancellation.
5. **Always Announce Status:** All loading animations, skeletons, progress bars, and alerts must include descriptive semantic labels for screen readers.
6. **Supportive Language Only:** Never use blame-oriented language or criticize user inputs; keep error copy focused entirely on self-service solutions.
7. **Semantic Token Mapping:** Every resilience view, background banner, and error card must use design tokens mapping to standard semantic surfaces.

---
**End of Empty, Loading, Error & Recovery Experience System Specification**
