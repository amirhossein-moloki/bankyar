# BankYar Empty, Loading, Error & Recovery Experience System

**Project Name:** BankYar
**Classification:** Enterprise Design System Specification (Restricted)
**Document Version:** 1.0.0
**Authors:** Principal UX Architect, Product Resilience Specialist, & Enterprise Design System Architect
**Status:** Approved / Production-Ready Baseline

---

## Executive Summary

BankYar is a privacy-first, offline-only mobile application that automatically parses incoming banking SMS notifications directly on a user's device, maintaining strict data sovereignty (zero network access, zero external telemetry). In an offline-first environment, system failures, permissions blocks, database locks, and state voids cannot be resolved by an external server or remote helpdesk.

Therefore, BankYar's resilience, wait states, and failure recovery must be entirely self-contained, completely transparent, and deeply supportive. This document establishes the absolute visual, interaction, and messaging authority for how BankYar handles waiting, processing, interruption, unavailability, or errors. It covers all 40 core deliverables of the BankYar Empty, Loading, Error & Recovery Experience System.

---

# 1. Recovery Philosophy

In a high-security, zero-network financial environment, the traditional error model of "something went wrong, try again later" is a complete failure of design. Because user trust is the primary asset of a banking management tool, the Recovery Philosophy is anchored in the following tenets:

* **Trust is Hard-Won and Easily Lost:** A single unexplained error, frozen loading state, or catastrophic data corruption can cause immediate user anxiety, leading to app uninstallation. Every system event must be accounted for and explained in human terms.
* **The System is Supportive, Never Punitive:** Errors are seen as opportunities for guidance. When the user makes an error (such as entering an incorrect backup decryption password), the system must never blame or criticize, but rather illuminate the path back to a successful state.
* **No Dead Ends:** Every state in the application must offer an escape route, a fallback mechanism, or a manual option. Under no circumstances should the user be left staring at a static screen with no interactive recovery options.
* **Preserve and Defend Local Data:** Because the application operates offline, there are no remote database backups unless the user manually creates them. Our absolute physical priority is data preservation. Even during serious database corruption, the system must prioritize saving raw records over simple app resets.

---

# 2. UX Resilience Principles

The design of wait and failure experiences is guided by five foundational UX Resilience Principles:

| Principle | Core Objective | Visual/Interaction Requirement |
| :--- | :--- | :--- |
| **Complete Transparency** | Provide constant visibility of system status. | Transition clearly between idle, processing, and error states; always provide a clear, understandable time estimate or progression state. |
| **Cognitive Simplicity** | Reduce anxiety during friction points. | Avoid technical stack traces, internal system codes, and scary terminology in user-facing views; represent errors with calming semantic icons and supportive text. |
| **Self-Service Agency** | Empower users to self-correct failures. | Offer immediate, accessible actions (e.g., "Grant Permission", "Verify Password", "Paste Clipboard Text") directly inside the context of the issue. |
| **Graceful Degradation** | Maintain core utility when sub-features fail. | If background capture fails due to OS power limits, immediately highlight manual entry or clipboard import options, keeping the ledger accessible. |
| **Predictability** | Ensure identical responses to similar failures. | Maintain consistent placement, colors, and layout structures for error warnings and loading screens across all features. |

---

# 3. Empty State Strategy

Empty states in BankYar are never treated as inactive blank pages. Instead, they serve as onboarding opportunities, interactive guides, and comforting introductions. Every empty state must satisfy three criteria:
1. Explain **exactly** why the view is empty without jargon.
2. Provide a comforting message that lowers cognitive load.
3. Feature a prominent, primary action button that suggests the logical next step.

### Empty State Scenarios:

#### First Launch
* **Situation:** The application has been installed, initialized, and secured with a PIN, but has no data.
* **Objective:** Introduce the value of BankYar, reassure the user of 100% offline privacy, and trigger the initial SMS scan.
* **Visual Presentation:** A welcoming layout utilizing an illustrative empty-state graphic, a brief security reassurance, and a primary action button.
* **Primary Action:** `Import SMS Messages` (triggers the system permission request and initiates the first ingest).

#### No SMS Imported
* **Situation:** The SMS permission was granted, but the system returned zero banking SMS messages.
* **Objective:** Explain that the app found no supported banking messages in the system inbox, and guide the user on how to resolve this.
* **Visual Presentation:** An informational illustration depicting an inbox, explanatory text explaining that standard bank names must be matched, and a dual action layout.
* **Primary Action:** `Configure Custom Templates` (navigates the user to setup custom banking regex patterns).
* **Secondary Action:** `Import Ledger Statement` (opens the CSV statement importer).

#### No Transactions
* **Situation:** The inbox contains SMS records, but none matched the configured transaction parsers, resulting in an empty ledger.
* **Objective:** Prevent anxiety about missing records; guide the user to check parser template configurations or enter a record manually.
* **Visual Presentation:** Ledger outline showing clear, friendly text with illustrative icons.
* **Primary Action:** `Add Manual Transaction`
* **Secondary Action:** `Review Parser Rules`

#### No Search Results
* **Situation:** A user query in the ledger returned zero matches.
* **Objective:** Reassure the user that no data has been deleted, clarify that the query yielded no matches, and suggest broader keywords.
* **Visual Presentation:** Detailed in Section 21 of this document.

#### No Notes
* **Situation:** The user opens the transaction notes list, but has not yet written any annotations.
* **Objective:** Explain that notes are a secure way to add private annotations to cash flows.
* **Visual Presentation:** A speech bubble illustration showing note cards.
* **Primary Action:** `Write First Note` (directs the user to select a transaction to annotate).

#### No Statistics
* **Situation:** The analytics dashboard is opened, but there are no transaction records to compile charts from.
* **Objective:** Detailed in Section 22 of this document.

#### No Backup
* **Situation:** The backup and recovery settings view is opened, and no local `.bankyar` files are detected.
* **Objective:** Alert the user of the critical risk of hardware damage or device loss in an offline-only application.
* **Visual Presentation:** High-priority warning outline, emphasizing data sovereignty, accompanied by an explanatory layout.
* **Primary Action:** `Create Encrypted Backup`

#### No Notifications
* **Situation:** The in-app notification center is empty.
* **Objective:** Inform the user that system alerts, backup reminders, and parsing warnings will appear here.
* **Visual Presentation:** A quiet bell graphic accompanied by calming text.
* **Primary Action:** `Go to Ledger`

#### No Favorites
* **Situation:** The user filters the ledger by "Favorites", but has not pinned any transactions.
* **Objective:** Explain that pinning transactions makes frequent transfers easily accessible.
* **Visual Presentation:** A star outline graphic with clear explanatory text.
* **Primary Action:** `View All Transactions`

#### Future Features
* **Situation:** A future-ready layout (such as P2P local Wi-Fi sync) is opened but not yet configured.
* **Objective:** Build excitement and explain upcoming offline-first features without cluttering active views.
* **Visual Presentation:** An elegant blueprint illustration explaining how the feature functions without any network access.
* **Primary Action:** `Join Local Beta` or `Read Guide`

---

# 4. Loading Experience

Waiting is inevitable during heavy operations like parsing thousands of database records, importing files, or compiling financial reports. BankYar prevents perceived latency by utilizing three standard loading archetypes, selected based on operation length and screen context.

```
       WAIT DURATION                       WAIT ARCHETYPE
┌──────────────────────────┐        ┌──────────────────────────┐
│  Sub-100ms (Immediate)   │───────►│  Zero Visual Transition  │
└──────────────────────────┘        └──────────────────────────┘
┌──────────────────────────┐        ┌──────────────────────────┐
│  100ms - 1000ms (Short)  │───────►│  Skeleton Content Mask   │
└──────────────────────────┘        └──────────────────────────┘
┌──────────────────────────┐        ┌──────────────────────────┐
│  1000ms - 5000ms (Medium)│───────►│  Progress Bar + Message  │
└──────────────────────────┘        └──────────────────────────┘
┌──────────────────────────┐        ┌──────────────────────────┐
│  5000ms+ (Long-running)  │───────►│  Full-screen Stepped UI  │
└──────────────────────────┘        └──────────────────────────┘
```

### Loading Archetype Decision Matrix:

| Screen Context | Expected Duration | Primary Archetype | Interaction Blocking |
| :--- | :--- | :--- | :--- |
| **Application Startup** | Short to Medium | Stepped Progress Screen | Blocking |
| **Transaction Loading** | Short | Skeleton Content Mask | Non-blocking |
| **Search Queries** | Sub-100ms (Immediate) | Inline Progress Ring | Non-blocking |
| **Ledger Filtering** | Sub-100ms (Immediate) | Shimmer List overlay | Non-blocking |
| **Backup Generation** | Medium | Progress Bar with status | Blocking |
| **Restore Processing** | Medium to Long | Full-Screen Stepped UI | Blocking |
| **SMS Ingest / Import** | Long-running | Non-blocking Background | Background / System Tray |
| **Statistics Compilation**| Short to Medium | Shimmering Chart Layout | Non-blocking |
| **Charts Redrawing** | Sub-100ms (Immediate) | Shimmering Chart Layout | Non-blocking |
| **Settings Navigation** | Short | Instantaneous Transition | Non-blocking |
| **Background Sync** | Long-running | System Tray Notification | Background |
| **Future AI Features** | Medium | Pulse Glow Shimmer | Blocking |

---

# 5. Skeleton Loading Strategy

To improve perceived performance and keep the interface stable, BankYar uses **Skeleton Content Masks** (also known as shimmers) for all content-heavy screen transitions under 1000ms. Skeletons simulate the final screen layout using neutral, non-distracting shapes.

### Visual and Behavioral Standards:
* **Structural Replication:** Skeletons must mimic the exact layout of the target components. A transaction card skeleton must feature a circular card profile, a block representing the title, a block representing the amount, and a small block for the category tag.
* **Shimmer Motion:** The shimmer effect must sweep in a smooth horizontal direction, aligned with the reading flow (right-to-left for Persian layouts).
* **Color Stability:** Skeletons must utilize neutral tokens mapping to semantic surfaces (e.g., `bankyar.color.semantic.surface.variant`). They must never utilize distinct HEX colors or create sharp, flashing contrasts.
* **No Sudden Jumps:** When loading completes, the transition from the skeleton to the actual content must use a subtle fade-in animation to avoid layout shifting.
* **Touch Disabling:** While skeletons are visible, all interactive gestures (such as tapping or swiping) on the shimmering components are blocked, preventing errors.

---

# 6. Progress Indicators

When an operation takes longer than 1000ms, a static skeleton is insufficient because the user cannot determine if the application is processing data or frozen. BankYar utilizes two categories of Progress Indicators:

### Linear Progress Indicators (Determinate)
* **Usage:** Used when the total workload is known (e.g., importing 500 SMS records, decrypting a backup file of a known size, or verifying a ZIP structure).
* **Visual Requirements:** A continuous horizontal bar filled in proportion to completed progress.
* **Progress Percentage:** Always accompanied by a clear percentage indicator (e.g., `۴۵٪` in Persian numerals).
* **Labeling:** Complemented by a clear, localized status label explaining the current task (e.g., "فرآیند رمزگشایی فایل پشتیبان...").

### Circular Progress Rings (Indeterminate)
* **Usage:** Used when the duration of an operation is unknown or highly variable (e.g., establishing an initial database connection, running a localized search query, or checking cryptographic keys).
* **Visual Requirements:** A smooth, looping circular animation.
* **Sizing Rules:** Sized appropriately for the context. Small rings are used inline inside buttons or cards; larger rings are centered in content blocks.
* **Labeling:** Must include adjacent status text to reduce user anxiety during longer operations.

---

# 7. Long-running Operations

Operations that block standard interactions for more than 5000ms (such as full database restorations, deep historical SMS migrations, or exporting encrypted files) require a dedicated, full-screen **Stepped Progress Layout**.

### Requirements for Stepped Progress Layouts:
1. **Interactive Lockout:** The main UI is blocked with a modal barrier to prevent data corruption.
2. **Cancellation Escape Hatch:** If safe, provide a clear, secondary "Cancel" option to let users abort the operation without data loss.
3. **Step-by-Step Transparency:** Break the complex task into a clear checklist of smaller, understandable steps, updating the status of each:
   - `✓` خواندن فایل پشتیبان (Completed)
   - `✓` تأیید صحت رمزگذاری (Completed)
   - `↻` بازسازی جداول پایگاه داده (Active, with progress indicator)
   - `○` بازسازی نمایه‌ها و فیلترها (Pending)
4. **No Premature Timeouts:** The layout must remain active until the system confirms success or throws an explicit recovery failure.

---

# 8. Background Operations

Offline-first applications must perform heavy tasks in the background (such as background SMS monitoring, transaction deduplication, or database optimization) to keep the main UI responsive.

### Background Operation Guidelines:
* **System Tray Notifications:** Use clean system notifications to keep the user informed when important background tasks are running (such as a database backup).
* **No Direct UI Interruption:** Background tasks must never display intrusive modals or interrupt active user input.
* **Power & Resource Efficiency:** Background processes must operate within strict resource budgets, respecting the device's battery saver configurations.
* **Background Failures:** If a background process fails (such as automated backup failing due to lack of storage space), save the failure to the database and notify the user with a non-intrusive alert banner next time they open the application.

---

# 9. Success Experience

A successful operation is a trust-building moment, especially in financial applications where users need confirmation that their actions succeeded. Success states in BankYar must feel reassuring and clear.

### Success State Guidelines:
* **Immediate Feedback:** Provide instant, clear confirmation when a transaction is saved, a backup is created, or settings are updated.
* **Reassuring Visuals:** Utilize calming green semantic checkmarks and clear, friendly typography.
* **Actionable Next Steps:** Where appropriate, present relevant next steps (such as "View Ledger" after importing transactions).
* **Auto-Dismissible Alerts:** Use non-intrusive, auto-dismissing banners (snackbars) for minor successes, ensuring they do not interrupt the user's flow.
* **Accessibility Confirmation:** Always announce successes to screen readers using clear, localized semantic labels.

---

# 10. Warning Experience

Warning states communicate that an operation succeeded but requires user attention, or that a non-critical issue occurred. They are designed to prevent escalation into critical errors.

### Warning State Guidelines:
* **Visual Distinction:** Warn the user with distinct yellow semantic warning icons and borders, keeping them separate from critical error states.
* **Clear Explanations:** Explain exactly what occurred (e.g., "SMS imported successfully, but 3 transactions could not be parsed automatically").
* **Actionable Recovery:** Provide a clear, direct path to resolve the warning (e.g., "Review Unparsed Transactions").
* **Non-Blocking Layouts:** Display warnings in inline banners or card overlays, ensuring they do not block standard user interactions.

---

# 11. Informational States

Informational states provide helpful context, helpful guides, or system status updates without indicating failure or success.

### Informational State Guidelines:
* **Contextual Help:** Provide inline informational cards to explain complex financial features or explain privacy policies.
* **Calming Colors:** Design informational elements using neutral, calming blue or grey tokens, avoiding alarming colors like red or yellow.
* **Optional Dismissibility:** Allow users to dismiss informational cards once read, keeping active screens clean and focused.
* **Simple Copy:** Keep descriptions short, clear, and highly focused on user benefits.

---

# 12. Error Categories

To ensure predictable handling and clean logging, BankYar organizes all system errors into five functional scopes. Every error across these categories must define:

1. **Cause:** The underlying physical or system event that triggered the error.
2. **User Impact:** How the error affects the user's immediate experience and data access.
3. **Recovery Action:** The explicit, self-service action the user can take to resolve the issue.
4. **Fallback Behavior:** How the application degrades gracefully if recovery fails.
5. **Logging Strategy:** How the error is recorded in local, privacy-first diagnostic logs.
6. **Escalation Path:** The backup plan if the standard recovery action fails.

---

# 13. Recoverable Errors

Recoverable errors are transient issues that do not threaten data integrity and can be resolved within the app flow.

* **Cause:** Temporary database file locks, minor form validation mismatches, or format drifts in banking SMS structures.
* **User Impact:** Brief interruption in a specific feature (e.g., a transaction notes input failing to save).
* **Recovery Action:** Tap a "Retry" button to re-run the transaction, or correct the input.
* **Fallback Behavior:** Keep the active view responsive and cache the input in temporary RAM to prevent data loss.
* **Logging Strategy:** Write a warning level log entry in the local database with a distinct taxonomy code, scrubbing any PII.
* **Escalation Path:** If retry fails 3 times, save the input to a local draft table and prompt the user to try again later.

---

# 14. Non-recoverable Errors

Non-recoverable errors represent major system failures that prevent normal application operations.

* **Cause:** SQLite database file corruption, critical filesystem read/write failures, or keystore cryptographic key erasure.
* **User Impact:** Full lockout from standard application screens and ledger views.
* **Recovery Action:** Present the full-screen Disaster Recovery Screen, guiding the user to restore their data from their latest encrypted `.bankyar` backup file.
* **Fallback Behavior:** Automatically open a clean, isolated sandbox database to keep the app functional while blocking access to the corrupted ledger.
* **Logging Strategy:** Write a high-priority critical error entry to the local log database, capturing system diagnostic codes while strictly redacting PII.
* **Escalation Path:** If backup restoration fails, provide instructions on how to export diagnostic logs manually and initialize a fresh, clean database.

---

# 15. Permission Errors

Permission errors occur when the operating system denies BankYar access to necessary hardware or system APIs.

* **Cause:** The user denying system permissions for SMS access or local storage.
* **User Impact:** Automated features (such as background SMS capturing) are blocked.
* **Recovery Action:** Provide a clear, prominent button that navigates the user directly to the system settings page to grant permissions.
* **Fallback Behavior:** Disable background listeners and present clear, interactive fallback tutorials for manual transaction entry and clipboard parsing.
* **Logging Strategy:** Log a warning level entry noting the permission denial state.
* **Escalation Path:** If permission is repeatedly denied, simplify active dashboards to focus entirely on manual entry options, hiding empty automated configurations.

---

# 16. SMS Permission States

This section defines the UX transitions for SMS permission acquisition and denials, ensuring the user understands **why** permission is required.

```
       USER STATUS                            UX RESPONSE
┌──────────────────────────┐        ┌──────────────────────────┐
│  First Ingestion Request │───────►│  Contextual Explanation  │
└──────────────────────────┘        └──────────────────────────┘
┌──────────────────────────┐        ┌──────────────────────────┐
│  Permission Granted      │───────►│  Success Toast + Ingest  │
└──────────────────────────┘        └──────────────────────────┘
┌──────────────────────────┐        ┌──────────────────────────┐
│  Permission Denied Once  │───────►│  Educational Banner      │
└──────────────────────────┘        └──────────────────────────┘
┌──────────────────────────┐        ┌──────────────────────────┐
│  Permission Denied Twice │───────►│  Manual Fallback Onboard │
└──────────────────────────┘        └──────────────────────────┘
```

* **Contextual Explanation:** Before displaying the system permission prompt, present a clean, high-contrast dialog explaining that BankYar runs completely offline, meaning SMS messages are parsed purely on-device and never shared.
* **Success Toast:** Upon approval, display a success toast and start the first automated scan immediately.
* **Educational Banner:** If denied once, display a prominent banner on the empty ledger screen, explaining that automated tracking is disabled and providing an easy retry button.
* **Manual Fallback Onboard:** If denied twice, transition the ledger view to focus entirely on manual imports and clipboard parsing guides, keeping automated configuration options hidden.

---

# 17. Storage Errors

Storage errors occur when the device is out of physical disk space or prevents writing files.

* **Cause:** Physical storage full, or the operating system blocking file writes to sandboxed directories.
* **User Impact:** Database transactions cannot be saved, backups cannot be generated, and diagnostic logs are halted.
* **Recovery Action:** Present a clear, high-priority warning modal suggesting the user clear space on their device.
* **Fallback Behavior:** Pause non-essential background processes and temporarily store new transactions in volatile RAM to protect active inputs from loss.
* **Logging Strategy:** Write a warning to local memory logs if disk access is completely blocked.
* **Escalation Path:** If storage remains full for more than 5 minutes, safely close active SQLite connection pools to prevent file corruption.

---

# 18. Database Errors

Database errors represent issues within the SQLCipher encrypted engine.

* **Cause:** Database file locks, page integrity mismatches, or schema migration failures.
* **User Impact:** Intermittent ledger failures or complete access blocks.
* **Recovery Action:** Run automated schema repair procedures; if corruption is confirmed, redirect the user to the Disaster Recovery Screen.
* **Fallback Behavior:** Degrade to a read-only view of cached data if database writes are locked.
* **Logging Strategy:** Write detailed SQLite error codes to the diagnostic log file, ensuring sensitive data is redacted.
* **Escalation Path:** If migration fails, revert to the previous database schema version to keep user data intact and safe.

---

# 19. Backup Errors

Backup errors occur during the generation of password-encrypted backup files.

* **Cause:** The user entering an insecure encryption password, file system writes failing, or password derivation timing out on low-spec hardware.
* **User Impact:** No backup file is generated, leaving user data unprotected against device loss.
* **Recovery Action:** Guide the user to enter a strong, compliant password, or select a different target directory for export.
* **Fallback Behavior:** Keep the backup settings view open with clear instructions, preserving inputs.
* **Logging Strategy:** Log a warning detailing the export failure reason.
* **Escalation Path:** If file system writes fail repeatedly, offer to export the encrypted database payload directly via the system share sheet.

---

# 20. Restore Errors

Restore errors occur when the application attempts to import and verify an external backup file.

* **Cause:** Decryption password mismatches, AES-GCM verification failures, or schema incompatibilities.
* **User Impact:** The restore process is aborted, protecting the active database from being overwritten with invalid data.
* **Recovery Action:** Prompt the user to re-enter their decryption password, or verify that they are using a valid `.bankyar` backup file.
* **Fallback Behavior:** Abort the restore immediately, keep the active database intact, and zeroize any temporary decryption keys in RAM.
* **Logging Strategy:** Log a high-priority warning detailing the verification failure.
* **Escalation Path:** If the backup file is corrupted, prompt the user to select an alternative backup file or contact developers.

---

# 21. Search Empty Results

A query on the financial ledger yielding zero results requires careful handling to prevent anxiety about missing records.

* **Situation:** The user searches for a term (e.g., "ملی") that matches zero transactions.
* **Behavior:** Clear the active ledger list and present a clean, high-contrast layout.
* **Visual Representation:** An illustrative magnifying glass icon pointing to an empty line, with friendly typography.
* **Messaging Principles:**
  - Reassure the user that no data was deleted (e.g., "هیچ تراکنشی حذف نشده است").
  - Explicitly explain the search terms were evaluated (e.g., "نتیجه‌ای برای جستجوی شما یافت نشد").
* **Actionable Next Steps:**
  - Suggest alternative search terms (e.g., "کلمات کلیدی خود را کوتاهتر کنید یا فیلترها را بردارید").
  - Provide a clear, primary action button to `Clear Search Filters`.

---

# 22. Statistics Empty States

When analytics dashboards are opened without data, they must provide encouragement rather than displaying blank charts.

* **Situation:** The cash flow report page has zero data because no transactions are saved.
* **Behavior:** Hide blank chart boxes and display a clean, reassuring educational layout.
* **Visual Representation:** A series of dotted chart outlines representing upcoming cash flows.
* **Messaging Principles:**
  - Build expectation and value (e.g., "نمودارهای تحلیل مالی شما در این بخش نمایش داده می‌شوند").
  - Reassure the user of on-device calculations (e.g., "تمام تحلیل‌ها به صورت کاملاً آفلاین محاسبه می‌شوند").
* **Actionable Next Steps:**
  - Provide a primary action button to `Import First SMS`.
  - Provide a secondary action button to `Add Manual Transaction`.

---

# 23. Notification Failures

Notification failures occur when BankYar is blocked from scheduling or displaying notifications.

* **Cause:** System notifications being disabled by the user or battery-optimization restrictions.
* **User Impact:** Missing automated alerts about imported transactions or backup reminders.
* **Recovery Action:** Provide an inline settings card with a button to toggle notification permissions.
* **Fallback Behavior:** Display missed notifications in a clean, in-app notification list on next launch.
* **Logging Strategy:** Log a minor warning detailing the notification block.
* **Escalation Path:** If notifications are completely disabled, show an optional, non-intrusive alert banner on the main dashboard for critical updates.

---

# 24. Security Errors

Security errors occur when BankYar detects potential tampering, brute-force attempts, or environment compromises.

* **Cause:** Root modifications detected on the device, debuggers being attached to production builds, or maximum authentication attempts being exceeded.
* **User Impact:** Immediate lockout from the application to defend local database pages.
* **Recovery Action:** For brute-force lockouts, start a strict countdown timer; for environment compromises, display safety instructions.
* **Fallback Behavior:** Evict master encryption keys from RAM, close all active database connections, and block user inputs.
* **Logging Strategy:** Write an encrypted security warning, redacting all passwords, PINs, and personal details.
* **Escalation Path:** If security threats persist, keep the application in a hardened lockout state, requiring a full system reboot or secure restore.

---

# 25. PIN Failures

PIN failures handle incorrect security inputs when opening BankYar.

* **Cause:** The user entering an incorrect 4-digit security PIN.
* **User Impact:** Delayed access to application views, with a strict limit on attempts.
* **Recovery Action:** Display red warning text below the input field showing remaining attempts (e.g., "۲ تلاش دیگر باقی مانده است").
* **Fallback Behavior:** Increment the failed attempt counter; if 3 consecutive failures occur, start a strict 1-minute lockout timer.
* **Logging Strategy:** Log an info-level failed verification entry, scrubbing the entered PIN.
* **Escalation Path:** If consecutive lockouts occur, double the timer duration with each subsequent failure up to a maximum of 15 minutes.

---

# 26. Encryption Failures

Encryption failures occur within SQLCipher's cryptographic layer.

* **Cause:** Hardware keystore timeouts, key derivation failures, or signature mismatches.
* **User Impact:** Inability to decrypt the local database, blocking access to all financial records.
* **Recovery Action:** Trigger the automated key derivation recovery process; if failure persists, direct the user to the Disaster Recovery Screen.
* **Fallback Behavior:** Safely close all active database connections and zeroize any partial key buffers in RAM.
* **Logging Strategy:** Write detailed cryptographic system codes to local logs, ensuring sensitive keys are redacted.
* **Escalation Path:** If decryption fails repeatedly, prompt the user to restore their data from their latest password-encrypted `.bankyar` backup file.

---

# 27. Offline Recovery

Operating 100% offline means all recovery flows must function without external network coordination.

* **Contextual Safety:** Because BankYar never accesses the internet, there is no "Forgot PIN" or "Reset Database" option via a remote server.
* **Decentralized Verification:** All validation (including PIN checks and backup decryption) is processed entirely on the local device using PBKDF2 key derivation.
* **Self-Contained Repair Procedures:** If database files are locked or corrupted, run localized integrity checks and vacuum operations using internal SQLCipher utilities.
* **Local Recovery Guides:** Store all educational material and user guides directly in-app, ensuring help is always accessible offline.

---

# 28. Retry Strategy

When an operation fails, BankYar implements a standardized Retry Strategy to prevent data loss.

* **Exponential Backoff:** Space retries using exponential delays with randomized jitter to reduce disk write contention:
  $$\text{Delay} = \min(\text{BaseDelay} \times 2^{\text{attempt}}, \text{MaxDelay}) + \text{Jitter}$$
* **Maximum Bounds:** Retries are strictly capped at a maximum of 3 attempts.
* **Anti-patterns / Prohibited Operations:** Running automated retries is strictly prohibited during the following sensitive flows:
  - Cryptographic PIN checks or biometric authentication scans.
  - Database writes failing due to unique constraints or page corruption.
  - File-level data restorations.

---

# 29. Undo Strategy

Financial transactions are sensitive, making accidental deletions or edits highly stressful. BankYar provides a frictionless **Undo Strategy** to restore confidence.

```
       USER ACTION                            UX RESPONSE
┌──────────────────────────┐        ┌──────────────────────────┐
│  Deletes Transaction     │───────►│  Instant Local Database  │
│  or Note Card            │        │  Write To Safe Sandbox   │
└──────────────────────────┘        └──────────────────────────┘
                                                 │
                                                 ▼
                                    ┌──────────────────────────┐
                                    │  Display Undo Banner     │
                                    │  With 5-Second Timer     │
                                    └──────────────────────────┘
                                                 │
                                     ┌───────────┴───────────┐
                                     ▼                       ▼
                            ┌────────────────┐      ┌────────────────┐
                            │  Taps Undo     │      │  Timer Expires │
                            └────────┬───────┘      └────────┬───────┘
                                     │                       │
                                     ▼                       ▼
                            ┌────────────────┐      ┌────────────────┐
                            │  Revert Write  │      │  Finalize DB   │
                            │  Immediately   │      │  Transaction   │
                            └────────────────┘      └────────────────┘
```

* **Immediate Feedback:** When a transaction is deleted, display an immediate banner at the bottom of the screen with a clear progress bar indicating time remaining (e.g., 5 seconds).
* **Frictionless Undo:** Provide a prominent "Undo" button on the banner, allowing the user to instantly restore the record.
* **Delayed Finalization:** Keep the record in a temporary deletion table; if the timer expires without user action, finalize the deletion in the database.
* **Anxiety Reduction:** Always confirm restoration with a brief success toast (e.g., "تراکنش با موفقیت بازیابی شد").

---

# 30. Cancellation UX

Canceling an active operation must be clean, safe, and entirely predictable.

* **Safe Cancel:** If an active task (such as a database export) is canceled, immediately abort the process, delete any partial export files, and revert active views to their pre-export state.
* **Interaction Warnings:** If canceling an active task could lead to data loss (such as a database import), present a clear warning dialog before aborting.
* **Immediate Responsiveness:** Ensure the cancellation action responds instantly to user input, avoiding frozen UI states.
* **Clean State Cleanup:** Zeroize any temporary password buffers or key bytes in RAM immediately upon cancellation.

---

# 31. Data Loss Prevention

BankYar prioritizes data preservation above all else, ensuring user inputs are protected at every stage.

* **Draft Caching:** If a form submission fails due to a database lock, cache the input parameters in temporary RAM, ensuring the user's input is not lost when they return to the form.
* **Validation Guards:** Run client-side validation checks before attempting database writes, catching formatting errors early.
* **Atomic Transactions:** Wrap multi-step database writes in explicit SQLite transaction blocks, ensuring that if any step fails, the entire transaction is safely rolled back to prevent corruption.
* **Automatic Temp-file Cleanup:** Delete partial or corrupted backup files automatically if a backup generation is canceled or fails, preventing storage bloat.

---

# 32. User Guidance Strategy

Offline-first financial apps require clear, supportive user guidance to help users resolve issues independently.

* **Contextual Helpers:** Provide clear, high-contrast helper text next to complex configurations, explaining features simply without technical jargon.
* **Interactive Troubleshooting:** If a background capture fails, present an interactive step-by-step troubleshooting guide to help the user configure system settings.
* **Rich Offline Documentation:** Store complete feature guides and security policies directly inside the application package, keeping documentation accessible without internet.
* **Self-Service Diagnostics:** Allow users to view sanitized diagnostic logs in settings, providing clear explanations of system health.

---

# 33. Accessibility Rules

Wait, loading, and error states must be fully accessible to all users, adhering to high inclusive design standards.

* **Screen Readers:** All progress rings, skeleton content masks, error banners, and success checkmarks must include clear, localized semantic labels (e.g., "در حال بارگذاری تراکنش‌ها..." for loading rings).
* **Large Text & Reflow:** Text blocks inside error banners and empty states must support dynamic text scaling up to 200% without clipping or layout shifting.
* **High Contrast:** Ensure all error text and recovery buttons meet WCAG AAA contrast ratio standards against semantic background surfaces.
* **Reduced Motion:** If reduced motion is enabled in system settings, disable looping shimmer sweeps on skeletons and replace progress transitions with simple fade-ins.
* **Voice Access:** Ensure all recovery and cancel buttons have clear, pronounceable semantic labels that can be activated via standard voice controls.
* **Switch Access:** Confirm focus order flows logically (from right-to-left in Persian) through error modals, ensuring the primary recovery button is highlighted first.
* **Keyboard Navigation:** All resilience views must support standard keyboard navigation, focusing on primary action buttons automatically when modals open.
* **Cognitive Accessibility:** Avoid complex codes, alarming language, and technical jargon in user-facing views; represent states with clear semantic icons and simple copy.

---

# 34. Error Severity Mapping

BankYar categorizes errors into four severity levels to ensure appropriate UI responses and logging priority.

### Severity Matrix:

| Severity Level | System Impact | UI Representation | Logging Priority | Example Scenario |
| :--- | :--- | :--- | :--- | :--- |
| **Low** | None; minor feature warning. | Inline alert banner or text warning below fields. | INFO | Form validation failure, minor input format drift. |
| **Medium** | Specific feature disabled; core app remains responsive. | Non-blocking modal dialog or prominent inline alert card. | WARNING | SMS permissions denied, automated sync failures. |
| **High** | Critical flow blocked; risk of data corruption. | Blocking modal dialog with clear recovery paths. | ERROR | Secure storage timeout, database writes locked. |
| **Critical** | Database unreadable; application unusable. | Full-screen blocking Disaster Recovery Screen. | CRITICAL | SQLCipher page corruption, master key loss. |

---

# 35. Recovery Flow Mapping

This section defines the system's behavioral transitions during recovery flows, tracing the path from failure to resolution.

```
       STATE TRANSITION DURING DATABASE CORRUPTION
┌──────────────────────────┐        ┌──────────────────────────┐
│  SQLCipher DB Corrupted  │───────►│  Sandbox DB Initialized   │
└──────────────────────────┘        └──────────────────────────┘
                                                 │
                                                 ▼
                                    ┌──────────────────────────┐
                                    │  Show Disaster Recovery  │
                                    │  Screen Layout           │
                                    └──────────────────────────┘
                                                 │
                                                 ▼
                                    ┌──────────────────────────┐
                                    │  Prompt Encrypted Backup │
                                    │  File Selection          │
                                    └──────────────────────────┘
                                                 │
                                     ┌───────────┴───────────┐
                                     ▼                       ▼
                            ┌────────────────┐      ┌────────────────┐
                            │  Valid Pass    │      │  Invalid Pass  │
                            └────────┬───────┘      └────────┬───────┘
                                     │                       │
                                     ▼                       ▼
                            ┌────────────────┐      ┌────────────────┐
                            │  Restore Data  │      │  Show Warning  │
                            │  & App Reboot  │      │  Keep Sandbox  │
                            └────────────────┘      └────────────────┘
```

* **Immediate Sandbox Initialization:** If SQLCipher database corruption is detected, safely isolate the corrupted file, initialize a fresh sandbox database, and present the user with the Disaster Recovery Screen.
* **Backup Verification:** Guide the user to select their latest encrypted `.bankyar` backup file and enter their decryption password.
* **Safe Overwrite:** Once verified, replace the corrupted database tables with the restored data and reboot the application safely.

---

# 36. UX Copy Principles

BankYar's messaging guidelines prioritize clarity, empathy, and constructive guidance, ensuring users never feel blamed for system failures.

### Message Copy Comparisons:

| Context | Avoid (Punitive / Technical) | Use (Supportive / Constructive) |
| :--- | :--- | :--- |
| **PIN Input** | PIN نادرست است. ۳ تلاش دیگر باقی مانده است. | کد ملی وارد شده مطابقت ندارد. لطفاً مجدداً تلاش کنید (۲ تلاش باقی مانده). |
| **Database Corruption**| خطای پایگاه داده: SQLite Error 11. فایل خراب است. | مشکلی در خواندن اطلاعات رخ داده است. لطفاً آخرین فایل پشتیبان را بازیابی کنید. |
| **SMS Ingestion** | خطا در خواندن پیامک‌ها. دسترسی داده نشد. | برای ثبت خودکار تراکنش‌ها، نیاز به دسترسی به پیامک‌های بانکی داریم. |
| **Backup Export** | خروجی ناموفق بود. خطای ذخیره‌سازی. | فضای ذخیره‌سازی دستگاه پر است. لطفاً مقداری فضا خالی کرده و مجدداً تلاش کنید. |
| **Restore Validation** | خطا در رمزگشایی. گذرواژه اشتباه است. | رمز عبور وارد شده صحیح نیست. لطفاً رمز عبور فایل پشتیبان را مجدداً وارد کنید. |

---

# 37. Governance Rules

The Empty, Loading, Error & Recovery Experience System is governed by seven strict architectural rules:

1. **No Dead Ends:** Every wait state, empty screen, and error modal must provide a clear, logical next step or recovery action button.
2. **Preserve Data First:** Under no circumstances should a recovery flow risk deleting or overwriting user data without explicit verification and confirmation.
3. **No Direct Stack Traces:** Technical stack traces, SQL error codes, and cryptic compiler output must never be displayed in user-facing views.
4. **Zeroize Memory Securely:** Cryptographic key bytes, passwords, and decrypted PIN hashes cached in volatile RAM must be zeroized immediately upon transaction rollback or cancellation.
5. **Always Announce Status:** All loading animations, skeletons, progress bars, and alerts must include descriptive semantic labels for screen readers.
6. **Supportive Language Only:** Never use blame-oriented language or criticize user inputs; keep error copy focused entirely on self-service solutions.
7. **Semantic Token Mapping:** Every resilience view, background banner, and error card must use design tokens mapping to standard semantic surfaces.

---

# 38. Validation Checklist

This checklist is used during design reviews to confirm compliance with BankYar's resilience standards:

- [ ] Does every error state feature a prominent primary recovery action button?
- [ ] Are all user-facing error messages written in clear, supportive Persian without technical jargon?
- [ ] Do all skeleton content masks replicate the structural layouts of their target cards?
- [ ] Are all progress percentages represented in Persian numerals (`۴۵٪`)?
- [ ] Does the application initialize a secure sandbox database if the main file is corrupted?
- [ ] Are temporary cryptographic keys in RAM zeroized immediately upon cancellation or rollback?
- [ ] Have all visual elements been verified against WCAG AAA contrast ratio standards?
- [ ] Are there zero instances of hardcoded HEX colors or physical measurements (`px`, `dp`, `sp`) in the designs?

---

# 39. Anti-pattern Catalog

To maintain high visual and behavioral standards, avoid these common design mistakes:

* **The Silent Freeze:** Running a long-running database operation without displaying a progress bar or status label, causing the user to assume the app has crashed.
* **The Blame Game:** Writing error messages that blame the user (e.g., "خطای کاربر: ورودی نامعتبر") instead of providing helpful guidance.
* **The Stack Trace Exposure:** Displaying raw database error logs or cryptic exception traces directly in the UI, increasing cognitive load and security risks.
* **The Empty Ledger Void:** Presenting a blank screen when there are no transactions, leaving the user confused and unsure of how to proceed.
* **The Insecure Auto-Retry:** Automatically retrying sensitive cryptographic actions (such as PIN checks) after a failure, risking security compromises.

---

# 40. Future Evolution Strategy

As BankYar grows to support future platforms, the resilience system will scale gracefully:

* **P2P Conflict Resolution Screens:** Future versions will introduce side-by-side transaction comparison cards, letting users manually resolve offline sync conflicts.
* **Local Machine-Learning Tokenizers:** In-app regex parsers will be enhanced with local Naive Bayes classifiers, helping the system auto-categorize unrecognized SMS layouts.
* **Hardware Cryptographic Keys:** Future iOS and Android builds will leverage secure enclave hardware keys, reducing keystore timeout exceptions.
* **Dynamic Diagnostic Level Controls:** Settings views will allow users to adjust local logging details, helping developers diagnose background issues without compromising privacy.

---
**End of Empty, Loading, Error & Recovery Experience System Specification**
