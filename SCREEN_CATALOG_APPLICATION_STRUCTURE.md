# BankYar Screen Catalog & Application Structure Specification

**Project Name:** BankYar
**Classification:** Enterprise-Grade Screen Catalog & Application Structure
**Document Version:** 1.0.0
**Authors:** Principal Product Designer, Senior UX Architect, Information Architect, Flutter Solution Architect, Enterprise Mobile Application Consultant
**Status:** Approved / Core Specification Blueprint

---

## Executive Summary

BankYar is an offline-first, secure mobile personal finance platform designed for native Persian (RTL) locales and running with zero-network permissions. To guarantee structural clarity, navigation predictability, data sovereignty, and developmental alignment, this document serves as the absolute single source of truth defining the entire screen inventory and application structure for BankYar Version 1 and future extensions.

By mapping every user viewport, state, modal sheet, and dialog across vertical feature modules, this blueprint bridges product expectations from the Product Requirements Document (PRD) with high-performance Flutter implementations. All visual representations, layouts, interactive states, and responsive patterns conform strictly to Material Design 3 and the dot-separated token namespace system (`bankyar.*`), with exactly zero lines of physical platform code, mockups, or hardcoded visual styles.

---

## 1. Application Module Hierarchy

BankYar's application architecture is organized around independent, decoupled, and highly cohesive vertical feature modules. This architecture prevents compile-time dependency leaks, maintains clean separation of concerns, and simplifies multi-team development.

### ASCII Module Relationship Diagram

```
                              [ Root System Shell ]
                                        |
           +----------------------------+----------------------------+
           |                                                         |
           v                                                         v
   [ Public Module ]                                        [ Protected Module ]
   - Splash Screen                                          - Dashboard Stateful Shell (/home)
   - Lock Security Gate                                         - Chronological Ledger Feed
   - Disaster Recovery Screen                                   - Transaction details Inspector
           |                                                    - Annotation Editor View
           v                                                    - Statistics & Analytics Dashboard
   [ Onboarding & Setup ]                                       - Search & Advanced Filters
   - Education & Privacy Pledge                                 - Unified Preferences Hub
   - System Permissions Setup                                   - Backup & Restore Manager
   - Init DB & Local SMS Scan                                   - Diagnostic & Developer Tools
```

### Route Path Mapping Registry

```
/
├── splash (Unauthenticated - Keystore diagnostics and environment validation)
├── lock (Security Gate - Biometrics / PIN verification)
├── error (Disaster Recovery - File system corruption/decryption failures)
├── onboarding
│   ├── welcome (Brand entry and setup launcher)
│   ├── value_intro (Educational 3-pillars overview)
│   ├── privacy_policy (Offline commitment and consent gate)
│   ├── offline_sync_edu (Mechanism explanation)
│   ├── permission_intro (Required vs Optional dashboard)
│   ├── permission_sms (SMS capture request)
│   ├── permission_notification (System alerts request)
│   ├── permission_biometrics (Biometrics linkage)
│   ├── permission_storage (Local file directories setup)
│   ├── permission_battery (Battery whitelist guide)
│   ├── init_bank_detect (Local history scan and card discovery)
│   ├── init_sms_scan (Batch historical processing progress)
│   ├── init_db_prep (SQLCipher encryption setup)
│   ├── onboarding_complete (Onboarding success and statistics overview)
├── home (Authenticated Dashboard Shell)
│   ├── ledger (Tab 1: reverse-chronological transaction list)
│   │   ├── search (Full-text FTS5 query panel with dynamic filters)
│   │   ├── manual (Manual transaction builder)
│   │   ├── detail
│   │   │   ├── :id (Structured metadata viewer and raw text audit)
│   │   │   └── :id/edit (Categories and note annotation editor)
│   ├── analytics (Tab 2: Spend distributions and monthly cash flows)
│   ├── settings (Tab 3: Application preferences panel)
│   │   ├── banks (Active bank profiles and template filters)
│   │   ├── parser (Interactive custom regex rule builder)
│   │   ├── backup (Encrypted export, backup key generator, and imports)
│   │   ├── diagnostics (Service status and battery optimization guides)
│   │   ├── developer (Mock parser simulator, database explorer, console logs)
│   │   └── about (App specifications, open-source licenses, and roadmap)
```

---

## 2. Complete Screen Inventory

Every screen in BankYar Version 1 is cataloged below, detailing its architectural parameters, user/business goals, dependencies, security level, offline availability, and complexity.

### 2.1 Public / Setup Module Screens

#### Screen 01: Splash Screen (صفحه آغازین)
* **Screen Path:** `/splash`
* **Purpose:** Verify system integrity, authenticate hardware Keystore signatures, and determine if an encrypted database exists.
* **Business Goal:** Reassure users with quick, immediate app readiness, and check security flags before displaying financial details.
* **User Goal:** Open the application smoothly and access records securely.
* **Entry Points:** OS Launcher Tap, Device Reboot.
* **Exit Points:** `/lock` (if local DB exists), `/onboarding/welcome` (if first-run context detected).
* **Navigation Dependencies:** Global Route Shell.
* **Related Components:** Brand vault logo, Indeterminate loading spinner, Version label.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline (100% functional).
* **Security Level:** Public.
* **Priority:** Critical.
* **Complexity:** Low.
* **Future Expansion:** Remote-free diagnostic self-repair hooks.

#### Screen 02: Welcome Screen (صفحه خوش‌آمدگویی)
* **Screen Path:** `/onboarding/welcome`
* **Purpose:** Welcome the user and introduce BankYar as a premium offline-first personal finance application.
* **Business Goal:** Highlight BankYar’s unique privacy value proposition to drive user conversion.
* **User Goal:** Understand the value of automated SMS management without cloud risks.
* **Entry Points:** `/splash` (first-run).
* **Exit Points:** `/onboarding/value_intro` (via Primary CTA), `/onboarding/init_db_prep` (via "Restore Backup" bypass).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Abstract vault illustrations, Outlined backup restore trigger, Privacy footnote.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline (100% functional).
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** Low.
* **Future Expansion:** Multi-device database peer-to-peer linking guides.

#### Screen 03: Core Value Introduction (معرفی ارزش‌های محوری)
* **Screen Path:** `/onboarding/value_intro`
* **Purpose:** Present the three core pillars of BankYar: "The Stoic Vault", "The High-Precision Analyst", and "The Calm Companion".
* **Business Goal:** Educate the user on the product's philosophy and build long-term user retention.
* **User Goal:** Understand how the application simplifies financial planning.
* **Entry Points:** `/onboarding/welcome`.
* **Exit Points:** `/onboarding/privacy_policy` (Next), `/onboarding/welcome` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Three-column responsive horizontal card deck, Adaptive linear icons.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** Medium.
* **Complexity:** Low.
* **Future Expansion:** Add small custom animations illustrating local workflows.

#### Screen 04: Privacy Commitment (تعهدنامه حریم خصوصی)
* **Screen Path:** `/onboarding/privacy_policy`
* **Purpose:** Present BankYar's strict offline, zero-network, zero-tracking policy.
* **Business Goal:** Build absolute user trust before requesting sensitive system permissions.
* **User Goal:** Verify that no financial data, banking logs, or personal details can ever leave the device.
* **Entry Points:** `/onboarding/value_intro`.
* **Exit Points:** `/onboarding/offline_sync_edu` (Next - enabled only when checkbox is checked), `/onboarding/value_intro` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Secure shield icon, Interlocking padlock graphics, Interactive consent checkbox.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** Low.
* **Future Expansion:** Local digital audit certificate display.

#### Screen 05: Offline-First Explanation (مفهوم همگام‌سازی آفلاین)
* **Screen Path:** `/onboarding/offline_sync_edu`
* **Purpose:** Explain the technical mechanics of on-device SMS parsing and local storage.
* **Business Goal:** Reduce confusion regarding the app's zero-internet design.
* **User Goal:** Learn how the application registers transactions in real time without cellular signals or cloud logins.
* **Entry Points:** `/onboarding/privacy_policy`.
* **Exit Points:** `/onboarding/permission_intro` (Next), `/onboarding/privacy_policy` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Interactive local parsing flow diagram.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** Medium.
* **Complexity:** Low.
* **Future Expansion:** Live simulator showcasing real-time text-to-database writing.

---

### 2.2 Permissions Module Screens

#### Screen 06: Permission Introduction (مقدمه مجوزها)
* **Screen Path:** `/onboarding/permission_intro`
* **Purpose:** Outline the required and optional permissions needed for BankYar to operate.
* **Business Goal:** Improve onboarding conversion by explaining why permissions are needed before prompting users.
* **User Goal:** Understand exactly what permissions the app needs and why.
* **Entry Points:** `/onboarding/offline_sync_edu`.
* **Exit Points:** `/onboarding/permission_sms` (Next), `/onboarding/offline_sync_edu` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Permission summary cards, Status indicator chips.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** Low.
* **Future Expansion:** Adaptive permission checklist adjusting based on the platform.

#### Screen 07: SMS Permission Screen (مجوز خواندن پیامک)
* **Screen Path:** `/onboarding/permission_sms`
* **Purpose:** Request access to system SMS messages to enable automated transaction tracking.
* **Business Goal:** Acquire critical SMS access to enable the app's automated tracking features.
* **User Goal:** Enable automated, hands-free transaction logging.
* **Entry Points:** `/onboarding/permission_intro`.
* **Exit Points:** `/onboarding/permission_notification` (Next), `/onboarding/permission_intro` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Prominent SMS explanation card, Native system permission trigger, Fallback manual-entry button.
* **Required Permissions:** `READ_SMS`, `RECEIVE_SMS`.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** Critical.
* **Complexity:** Medium (requires handling native permission prompts and denials).
* **Future Expansion:** Detailed guides on granting SMS permissions inside custom Android ROMs.

#### Screen 08: Notification Permission Screen (مجوز اعلان‌ها)
* **Screen Path:** `/onboarding/permission_notification`
* **Purpose:** Request permission to post local notifications for transaction alerts and security warnings.
* **Business Goal:** Establish a reliable user engagement loop via on-device notifications.
* **User Goal:** Get instant, real-time spending notifications and background status alerts.
* **Entry Points:** `/onboarding/permission_sms`.
* **Exit Points:** `/onboarding/permission_biometrics` (Next), `/onboarding/permission_sms` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Local notifications graphic, Silent-mode explanation toggle.
* **Required Permissions:** `POST_NOTIFICATIONS` (Android 13+).
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** Low.
* **Future Expansion:** Interactive visual picker for notification categories and sounds.

#### Screen 09: Biometrics Setup Screen (احراز هویت زیست‌سنجی)
* **Screen Path:** `/onboarding/permission_biometrics`
* **Purpose:** Link system biometric APIs to the hardware-bound database encryption key.
* **Business Goal:** Secure local financial data with convenient biometric authentication.
* **User Goal:** Access the transaction ledger securely in under 100 milliseconds without typing a PIN code every time.
* **Entry Points:** `/onboarding/permission_notification`.
* **Exit Points:** `/onboarding/permission_storage` (Next), `/onboarding/permission_notification` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Interactive biometric prompt, PIN passcode backup editor.
* **Required Permissions:** `USE_BIOMETRIC`.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** Critical.
* **Complexity:** High (requires integrating Android KeyStore biometrics).
* **Future Expansion:** Automatic hardware-key rotation policies.

#### Screen 10: Storage Access Screen (دسترسی به فایل‌ها)
* **Screen Path:** `/onboarding/permission_storage`
* **Purpose:** Obtain permission to read/write backups to local external storage directories.
* **Business Goal:** Allow users to export and restore encrypted backup files locally.
* **User Goal:** Safely backup their financial history to local directories, ensuring long-term data portability.
* **Entry Points:** `/onboarding/permission_biometrics`.
* **Exit Points:** `/onboarding/permission_battery` (Next), `/onboarding/permission_biometrics` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** OS Storage access triggers, Backup directories card.
* **Required Permissions:** `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE` (applicable Android versions).
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** Medium.
* **Complexity:** Medium (requires handling Android SAF - Storage Access Framework).
* **Future Expansion:** Encrypted micro-SD card backup directory mapping.

#### Screen 11: Battery Optimization Screen (راهنمای بهینه‌سازی باتری)
* **Screen Path:** `/onboarding/permission_battery`
* **Purpose:** Guide the user to exempt BankYar from aggressive system battery restrictions, preventing background task termination.
* **Business Goal:** Ensure 100% reliable background SMS interception across all devices.
* **User Goal:** Prevent the OS from silently stopping transaction tracking in the background.
* **Entry Points:** `/onboarding/permission_storage`.
* **Exit Points:** `/onboarding/init_bank_detect` (Next), `/onboarding/permission_storage` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Device-specific instruction panels (MIUI, EMUI, Samsung guides), Native settings shortcut.
* **Required Permissions:** `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** Medium (requires handling device-specific instruction mapping).
* **Future Expansion:** In-app status validator testing if background background service is running.

---

### 2.3 Initialization & Scan Engine Screens

#### Screen 12: Initial Bank Detection Screen (شناسایی اولیه بانک‌ها)
* **Screen Path:** `/onboarding/init_bank_detect`
* **Purpose:** Scan existing system SMS threads to discover financial institutions and active credit/debit cards.
* **Business Goal:** Automate bank configurations based on the user's actual SMS history.
* **User Goal:** Get up and running instantly without manually adding their banks and card details.
* **Entry Points:** `/onboarding/permission_battery`.
* **Exit Points:** `/onboarding/init_sms_scan` (Next), `/onboarding/permission_battery` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Scanning progress card, Dynamic bank logo badges, Linear progress bar.
* **Required Permissions:** `READ_SMS` (granted in Screen 07).
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** Medium.
* **Future Expansion:** AI-assisted detection of custom card nickname profiles.

#### Screen 13: Initial SMS Scan Screen (اسکن اولیه پیامک‌ها)
* **Screen Path:** `/onboarding/init_sms_scan`
* **Purpose:** Parse historical banking SMS alerts, extracting amounts, counterparties, types, and timestamps.
* **Business Goal:** Pre-populate the user's transaction history with real data on first-launch.
* **User Goal:** See their past spending habits immediately, without starting from a blank page.
* **Entry Points:** `/onboarding/init_bank_detect`.
* **Exit Points:** `/onboarding/init_db_prep` (Next), `/onboarding/init_bank_detect` (Back).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Real-time scrolling transaction skeleton loaders, Monospace scan progress monitor, Cancel button.
* **Required Permissions:** `READ_SMS` (granted).
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** High.
* **Complexity:** High (requires processing large volumes of text on background threads).
* **Future Expansion:** Custom date-range selectors for historical processing.

#### Screen 14: Initial Database Preparation (آماده‌سازی پایگاه داده اولیه)
* **Screen Path:** `/onboarding/init_db_prep`
* **Purpose:** Create database structures, compile search indexes, and calculate initial analytics.
* **Business Goal:** Securely write processed data to SQLCipher on-disk storage.
* **User Goal:** Set up the secure database structures correctly to prevent data corruption.
* **Entry Points:** `/onboarding/init_sms_scan`.
* **Exit Points:** `/onboarding/onboarding_complete` (Next). Interactivity is blocked during active database writes.
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Checklist showing status indicators, Indeterminate database progress bar.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Protected (accesses hardware encryption keys).
* **Priority:** High.
* **Complexity:** Medium (requires handling atomic transactions and index compilation).
* **Future Expansion:** Automatic database performance tuning depending on hardware.

#### Screen 15: Onboarding Completion Screen (پایان پیکربندی اولیه)
* **Screen Path:** `/onboarding/onboarding_complete`
* **Purpose:** Highlight onboarding completion, display a summary of imported data, and transition the user to the ledger.
* **Business Goal:** Reward and reassure the user with a clean, secure financial summary on first launch.
* **User Goal:** Verify that their database is encrypted, view their initial transaction count, and open their ledger.
* **Entry Points:** `/onboarding/init_db_prep`.
* **Exit Points:** `/home/ledger` (Primary CTA - routes to ledger, clearing the onboarding history stack).
* **Navigation Dependencies:** `/onboarding` nested router stack.
* **Related Components:** Green success shield graphic, Numeric cards showing detected transactions, Next-steps instruction panel.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Protected.
* **Priority:** High.
* **Complexity:** Low.
* **Future Expansion:** Interactive onboarding feedback questionnaire.

---

### 2.4 Core Dashboard Shell & Ledger Screens

#### Screen 16: Authenticated Dashboard Stateful Shell (پوسته اصلی داشبورد)
* **Screen Path:** `/home`
* **Purpose:** Provide a persistent bottom navigation bar shell mapping to the three primary feature tabs: Ledger, Analytics, and Settings.
* **Business Goal:** Provide a unified, responsive navigation system that keeps the user oriented.
* **User Goal:** Switch between chronological ledgers, spend dashboards, and app preferences.
* **Entry Points:** `/lock` (on successful challenge), `/onboarding_complete` (on onboarding completion).
* **Exit Points:** `/lock` (on background lock timeout), System Process Exit.
* **Navigation Dependencies:** Main stateful navigation wrapper.
* **Related Components:** Bottom Navigation Bar (MD3-compliant), Active pill indicators, Back-swipe gesture blocker.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Sensitive (requires active biometric/PIN session).
* **Priority:** Critical.
* **Complexity:** Medium.
* **Future Expansion:** Dynamic layout adaptation when switching to multi-column tablet modes.

#### Screen 17: Chronological Ledger Feed (دفترچه تراکنش‌ها)
* **Screen Path:** `/home/ledger`
* **Purpose:** Display a chronological, paginated list of all automatically parsed and manual transaction records.
* **Business Goal:** Serve as the application's central screen, displaying clear, readable financial details.
* **User Goal:** Search, filter, and review their financial history.
* **Entry Points:** Dashboard shell launch, `/home/ledger/detail/:id` (via back button).
* **Exit Points:** `/home/ledger/search` (Search trigger), `/home/ledger/manual` (Add trigger), `/home/ledger/detail/:id` (Select row).
* **Navigation Dependencies:** `/home` nested shell tab stack.
* **Related Components:** Scrollable ledger feed, Quick-action floating action button (FAB), Sticky app bar.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline (reverse-chronological index FTS5-driven query).
* **Security Level:** Sensitive.
* **Priority:** Critical.
* **Complexity:** High (requires managing high-performance lists at 60fps+ with live updates).
* **Future Expansion:** Drag-and-drop categorization gestures.

#### Screen 18: Transaction Details Inspector (جزئیات تراکنش)
* **Screen Path:** `/home/ledger/detail/:id`
* **Purpose:** Present structured metadata fields, raw carrier SMS text, categories, and annotations for a single transaction.
* **Business Goal:** Provide high-precision financial transparency.
* **User Goal:** Review the raw SMS context, check the parsed category, and add notes.
* **Entry Points:** `/home/ledger`, System tray notifications, deep link intents (`bankyar://transactions/:id`).
* **Exit Points:** `/home/ledger` (Up/Back chevron), `/home/ledger/detail/:id/edit` (Edit button).
* **Navigation Dependencies:** `/home/ledger` sub-stack routing.
* **Related Components:** High-contrast amount display, Segmented metadata tabs, Delete record dialog trigger.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Highly Sensitive (displays sensitive transaction amounts and raw bank SMS payloads).
* **Priority:** Critical.
* **Complexity:** Medium.
* **Future Expansion:** Direct matching of transaction rows to physical receipts using local cameras.

#### Screen 19: Annotation Editor View (ویرایش یادداشت و دسته‌بندی)
* **Screen Path:** `/home/ledger/detail/:id/edit`
* **Purpose:** Allow users to edit transaction categories, add text notes, and manage search tags.
* **Business Goal:** Empower users to enrich their transaction records locally.
* **User Goal:** Categorize transactions, add contextual notes, and attach tag keywords.
* **Entry Points:** `/home/ledger/detail/:id`.
* **Exit Points:** `/home/ledger/detail/:id` (Save/Cancel).
* **Navigation Dependencies:** `/home/ledger` sub-stack.
* **Related Components:** Category choice chips, Dynamic tag builder input, Notes text-area.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Highly Sensitive.
* **Priority:** High.
* **Complexity:** Medium (requires handling form validations and database commits).
* **Future Expansion:** AI-assisted smart note completions.

#### Screen 20: Manual Transaction Builder (ثبت دستی تراکنش)
* **Screen Path:** `/home/ledger/manual`
* **Purpose:** Provide a fallback form to manually record transactions, paste raw SMS text, or process clipboard content.
* **Business Goal:** Provide a robust backup interface on platforms that restrict background SMS read access.
* **User Goal:** Add cash transactions, paste SMS alerts from unmonitored bank accounts, or manage their budget manually.
* **Entry Points:** `/home/ledger` FAB click, clipboard auto-detection overlays.
* **Exit Points:** `/home/ledger` (Save/Cancel).
* **Navigation Dependencies:** Modal route from `/home/ledger`.
* **Related Components:** Material Design 3 input text-fields, Currency selector, Clipboard paste detector card.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Sensitive.
* **Priority:** High.
* **Complexity:** Medium.
* **Future Expansion:** Multi-asset transfer templates for compound ledger book entries.

---

### 2.5 Local Search, Analytics & Settings Screens

#### Screen 21: Full-Text Search Panel (جستجوی پیشرفته)
* **Screen Path:** `/home/ledger/search`
* **Purpose:** Provide an advanced local search bar to search the transaction ledger using text and filter parameters.
* **Business Goal:** Support rapid, seamless access to historical transaction records.
* **User Goal:** Find a specific transaction instantly using keywords, bank names, dates, or tags.
* **Entry Points:** `/home/ledger` search header icon.
* **Exit Points:** `/home/ledger` (Up/Dismiss chevron).
* **Navigation Dependencies:** Overlaid sub-route on `/home/ledger`.
* **Related Components:** Search query input field, Horizontal scrolling filter chips, FTS5-driven results list.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline (FTS5 query index).
* **Security Level:** Sensitive.
* **Priority:** High.
* **Complexity:** Medium.
* **Future Expansion:** Multi-term semantic search support.

#### Screen 22: Statistics & Analytics Dashboard (گزارش‌ها و تحلیل مالی)
* **Screen Path:** `/home/analytics`
* **Purpose:** Render visual cash flow graphs, expense breakdowns, and spending trends.
* **Business Goal:** Deliver on-device financial insights that help users track budgets.
* **User Goal:** Analyze their spending habits, view cash flow histories, and track monthly trends.
* **Entry Points:** Bottom navigation shell tab tap.
* **Exit Points:** Bottom navigation shell tab tap.
* **Navigation Dependencies:** `/home` nested shell stack.
* **Related Components:** Spend donut chart partitions, Cash-flow bar charts, Date-range selector chips.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline (instant database aggregation queries).
* **Security Level:** Sensitive.
* **Priority:** High.
* **Complexity:** High (requires handling canvas drawing, animations, and responsive layouts).
* **Future Expansion:** Automated financial forecast indicators.

#### Screen 23: Settings Preferences Hub (تنظیمات برنامه)
* **Screen Path:** `/home/settings`
* **Purpose:** Present setting options grouped into cards (Security, Privacy, Backup, Theme, About).
* **Business Goal:** Let users manage system options and verify security parameters from a single dashboard.
* **User Goal:** Customize display settings, toggle security features, and configure backups.
* **Entry Points:** Bottom navigation shell tab tap, home dashboard profile shortcut.
* **Exit Points:** Bottom navigation shell tab tap, or nested settings routes.
* **Navigation Dependencies:** `/home` nested shell stack.
* **Related Components:** Categorized preference list rows, Search setting input, Local encryption status card.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Sensitive.
* **Priority:** High.
* **Complexity:** Medium.
* **Future Expansion:** Export settings configuration files to back up app preferences.

#### Screen 24: Bank Profiles Manager (مدیریت بانک‌ها)
* **Screen Path:** `/home/settings/banks`
* **Purpose:** Manage active bank profiles, select monitored accounts, and configure card parameters.
* **Business Goal:** Give users granular control over which bank SMS alerts are monitored.
* **User Goal:** Enable/disable specific banks, nickname cards, and customize monitored keywords.
* **Entry Points:** `/home/settings`.
* **Exit Points:** `/home/settings` (Back).
* **Navigation Dependencies:** `/home/settings` sub-stack.
* **Related Components:** Bank profile row elements with active switch controls, Card nicknames editor.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Sensitive.
* **Priority:** High.
* **Complexity:** Medium.
* **Future Expansion:** Dynamic, peer-to-peer bank profile rule imports.

#### Screen 25: Custom Regex Builder (الگوساز پیامکی)
* **Screen Path:** `/home/settings/parser`
* **Purpose:** Create and test custom regular expression templates to support unsupported bank SMS formats.
* **Business Goal:** Guarantee 100% parser reliability by letting users define their own parsing rules.
* **User Goal:** Add rules for regional credit unions or custom business SMS templates easily.
* **Entry Points:** `/home/settings`.
* **Exit Points:** `/home/settings` (Back).
* **Navigation Dependencies:** `/home/settings` sub-stack.
* **Related Components:** Regex input builders, Live test-parser cards, Output token monitors.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Sensitive.
* **Priority:** Medium.
* **Complexity:** High.
* **Future Expansion:** Share custom templates with friends using offline QR codes.

#### Screen 26: Backup & Restore Manager (مدیریت پشتیبان‌گیری)
* **Screen Path:** `/home/settings/backup`
* **Purpose:** Manage manual exports, generate secure recovery keys, and restore database files.
* **Business Goal:** Ensure robust data backup and recovery mechanisms on an offline-first app.
* **User Goal:** Export their financial ledger securely, generate 12-word recovery passphrases, and restore database states.
* **Entry Points:** `/home/settings`, `/error` disaster recovery screens.
* **Exit Points:** `/home/settings` (Back), `/lock` (if restore finishes successfully).
* **Navigation Dependencies:** `/home/settings` sub-stack.
* **Related Components:** Encrypted backup generator card, 12-word recovery display, File import trigger.
* **Required Permissions:** None (uses native OS file sharing sheets to prevent permission issues).
* **Offline Availability:** Works Offline.
* **Security Level:** Highly Sensitive.
* **Priority:** Critical.
* **Complexity:** High.
* **Future Expansion:** Periodic auto-reminders to backup database files locally.

#### Screen 27: Background Diagnostics Panel (عیب‌یابی پس‌زمینه)
* **Screen Path:** `/home/settings/diagnostics`
* **Purpose:** Monitor background service health, verify battery whitelist status, and view monitor logs.
* **Business Goal:** Help users troubleshoot background SMS interception issues.
* **User Goal:** Verify that the background task listener is active and running correctly.
* **Entry Points:** `/home/settings`.
* **Exit Points:** `/home/settings` (Back).
* **Navigation Dependencies:** `/home/settings` sub-stack.
* **Related Components:** Service health badges, Battery optimization checks, Activity heartbeat lists.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Sensitive.
* **Priority:** Medium.
* **Complexity:** Medium.
* **Future Expansion:** Run simulated checks to verify SMS reception.

#### Screen 28: Hidden Developer Console (تنظیمات توسعه‌دهندگان)
* **Screen Path:** `/home/settings/developer`
* **Purpose:** Reveal hidden tools: test-SMS parsing simulator, direct database inspector, and system error log monitors.
* **Business Goal:** Provide developers with on-device debugging tools on an offline app.
* **User Goal:** Test parsing templates, audit database schemas, and view diagnostic error logs.
* **Entry Points:** Seven consecutive taps on the app version label on `/home/settings`.
* **Exit Points:** `/home/settings` (Back).
* **Navigation Dependencies:** `/home/settings` sub-stack.
* **Related Components:** Mock SMS text fields, Read-only SQLCipher table viewer, Redacted console logs console.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Highly Sensitive.
* **Priority:** Low.
* **Complexity:** High.
* **Future Expansion:** Secure, encrypted local diagnostics exporter.

#### Screen 29: System About & Licenses Panel (درباره بانک‌یار)
* **Screen Path:** `/home/settings/about`
* **Purpose:** Outline application specifications, open-source licenses, and development roadmaps.
* **Business Goal:** Deliver compliance documentation transparently.
* **User Goal:** Review open-source licenses, app roadmaps, and contact support.
* **Entry Points:** `/home/settings`.
* **Exit Points:** `/home/settings` (Back).
* **Navigation Dependencies:** `/home/settings` sub-stack.
* **Related Components:** Interactive roadmap charts, License text boxes, Offline contact-support menus.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Public.
* **Priority:** Low.
* **Complexity:** Low.
* **Future Expansion:** Inline, self-contained documentation manual.

---

### 2.6 Security & Disaster Recovery Screens

#### Screen 30: Security Lock Gate (صفحه قفل امنیتی)
* **Screen Path:** `/lock`
* **Purpose:** Gate access to sensitive financial screens, requesting biometric verification or PIN entries.
* **Business Goal:** Secure local database contents and prevent local inspection of financial ledgers.
* **User Goal:** Unlock the application quickly while keeping their data safe from unauthorized physical access.
* **Entry Points:** App launch, app resumption from background, `/splash` redirects.
* **Exit Points:** `/home/ledger` (upon successful authentication), system exit.
* **Navigation Dependencies:** Global Route Shell.
* **Related Components:** Biometric prompt modal, 4-digit PIN grid input panel, Error attempt counters.
* **Required Permissions:** `USE_BIOMETRIC`.
* **Offline Availability:** Works Offline.
* **Security Level:** Biometric Protected / PIN Protected (Authentication checkpoint).
* **Priority:** Critical.
* **Complexity:** Medium.
* **Future Expansion:** Face-unlock triggers.

#### Screen 31: Disaster Recovery Error View (صفحه عیب‌یابی و بازیابی بحران)
* **Screen Path:** `/error`
* **Purpose:** Display a recovery console when database decryption fails or filesystem corruption occurs.
* **Business Goal:** Provide users with self-recovery tools to restore their data if hardware Keystore resets occur.
* **User Goal:** Recover their database using encrypted `.bankyar` backups and custom passwords.
* **Entry Points:** `/splash` (on critical database startup failures), system diagnostic exceptions.
* **Exit Points:** `/lock` (if recovery/restore is successful), system exit.
* **Navigation Dependencies:** Global Route Shell.
* **Related Components:** Redalert status icon, Technical error descriptions, Fresh database builder action, Import backup CTA.
* **Required Permissions:** None.
* **Offline Availability:** Works Offline.
* **Security Level:** Highly Sensitive.
* **Priority:** Critical.
* **Complexity:** High (manages raw database recovery pipelines).
* **Future Expansion:** Direct data recovery tools for partial database corruption.

---

## 3. Screen Classification Matrix

This matrix categorizes all screens into distinct functional classifications to guide design layouts and structural definitions.

| Classification | Screen Name | Layout Zone Blueprint | Visual Weight | Focus Order Map |
| :--- | :--- | :--- | :--- | :--- |
| **Core Screen** | Chronological Ledger Feed | 3-Zone Stack (Sticky search + Feed scroll + Bottom bar) | High (`bankyar.*`) | Search -> Ledger List -> Add FAB -> Navigation |
| **Core Screen** | Statistics & Analytics | 3-Zone Stack (App Bar + Scroll charts + Bottom bar) | High | Date Filters -> Donut Chart -> Details -> Navigation |
| **Core Screen** | Settings Preferences Hub | 3-Zone Stack (Header search + Preference scroll + Bottom bar) | Medium | Search settings -> Security Overview -> Settings Rows |
| **Secondary Screen**| Transaction Details | Sub-stack (Up header + Inspector scroll + Bottom Actions) | High | Back arrow -> Metadata tabs -> Edit buttons -> Delete |
| **Secondary Screen**| Onboarding Flow (Welcome) | Stack (Fixed Progress Header + Workspace + CTAs footer) | High | Welcome copy -> Primary CTA -> Restore bypass |
| **Secondary Screen**| Onboarding Flow (Values) | Stack (Fixed Progress Header + Workspace + CTAs footer) | Medium | Cards list -> Next -> Back |
| **Secondary Screen**| Onboarding Flow (Privacy) | Stack (Fixed Progress Header + Workspace + CTAs footer) | Critical | Privacy Card -> Consent Checkbox -> Next -> Back |
| **Secondary Screen**| Onboarding Flow (Sync Edu)| Stack (Fixed Progress Header + Workspace + CTAs footer) | Medium | Diagram visual -> Next -> Back |
| **Secondary Screen**| Permission Panel (Intro) | Stack (Fixed Progress Header + Workspace + CTAs footer) | High | Checklist -> Next -> Back |
| **Secondary Screen**| Permission Panel (SMS) | Stack (Fixed Progress Header + Workspace + CTAs footer) | High | Grant access -> Skip fallback -> Back |
| **Secondary Screen**| Permission Panel (Alerts)| Stack (Fixed Progress Header + Workspace + CTAs footer) | Medium | Enable notification -> Skip -> Back |
| **Secondary Screen**| Permission Panel (Bio) | Stack (Fixed Progress Header + Workspace + CTAs footer) | Critical | Link biometrics -> Backup PIN setup -> Back |
| **Secondary Screen**| Permission Panel (Files)| Stack (Fixed Progress Header + Workspace + CTAs footer) | Medium | Grant Storage -> Skip -> Back |
| **Secondary Screen**| Permission Panel (Batt) | Stack (Fixed Progress Header + Workspace + CTAs footer) | High | Disable restriction -> Continue default -> Back |
| **Secondary Screen**| Init Progress (Banks) | Stack (Checking header + Progress display) | High | Progress bar -> Cancel |
| **Secondary Screen**| Init Progress (SMS Scan)| Stack (Checking header + Scrolling skeletons) | High | Progress bar -> Cancel |
| **Secondary Screen**| Init Progress (DB Prep) | Stack (Checking header + Indeterminate loop) | High | Progress checklist (Interactions Blocked) |
| **Secondary Screen**| Onboarding Complete | Stack (Congratulations header + Summary details + CTA) | High | Success shield -> Summary cards -> Enter Ledger CTA |
| **Secondary Screen**| Bank Profiles Manager | Sub-stack (Up header + List of switches) | Medium | Back -> Bank row switches -> Nickname fields |
| **Secondary Screen**| Custom Regex Builder | Sub-stack (Up header + Inputs scroll + Test area) | Medium | Back -> Regex inputs -> Sample field -> Run |
| **Secondary Screen**| Backup & Restore Manager | Sub-stack (Up header + Action cards) | Critical | Back -> Export button -> Backup key -> Import button |
| **Secondary Screen**| Background Diagnostics | Sub-stack (Up header + Info boxes) | Medium | Back -> Battery check -> System status -> Logs |
| **Secondary Screen**| System About & Licenses | Sub-stack (Up header + Lists) | Low | Back -> Licenses -> Terms -> Support |
| **Utility Screen** | Splash Screen | Single Central Stack | Low | Version label (No user focus) |
| **Security Screen** | Security Lock Gate | Absolute overlay stack | Critical | Biometric trigger -> PIN inputs -> Emergency recovery |
| **Security Screen** | Disaster Recovery | Error stack (Warning graphic + Actions) | Critical | Fresh database -> Import backup |
| **Modal Screen** | Annotation Editor View | Slide-up modal (Title bar + Inputs scroll + Bottom CTAs) | High | Category chips -> Notes text -> Tags -> Save |
| **Modal Screen** | Manual Entry Builder | Slide-up modal (Title bar + Inputs scroll + Bottom CTAs) | High | Amount input -> Merchant text -> Save |
| **Developer Screen**| Hidden Developer Console | Sub-stack (Up header + Tester fields + Logs box) | Low | Back -> Parser tester -> DB explorer -> Redacted logs |

---

## 4. Navigation Relationships

Every navigation path, modal overlay, and entry point in BankYar follows declarative routing rules. Unprotected routes bypass key requirements, while protected routes are secured behind `SecuritySessionGuard` to protect financial data privacy.

### ASCII State Navigation Relationships Diagram

```
                 [ Splash Screen ]
                         |
           +-------------+-------------+
           | (First Run)               | (Has Local DB)
           v                           v
  [ Onboarding Flow ] ----------> [ Lock Screen ] <======== Deep Link Intent
                                       |
                                       | (Successful Authentication)
                                       v
                     +===================================+
                     | Authenticated Dashboard Shell     |
                     |   - Tab A: Ledger Feed            |
                     |   - Tab B: Statistics             |
                     |   - Tab C: Settings preferences   |
                     +===================================+
                                       |
                     +-----------------+-----------------+
                     |                                   |
                     v (Tap Row)                         v (Tap Sub-settings)
          [ Detail Inspector ]                    [ Sub-settings Pages ]
                     |                                   |
                     v (Edit annotation)                 v
           [ Annotations Editor ]               [ Custom Rule / Backup ]
```

### Parent & Child Routing Trees

1. **Dashboard Shell Parent (`/home`)**
   - *Tab Child 1:* Chronological Ledger Feed (`/home/ledger`)
     - *Sub-route:* FTS5 Search Panel (`/home/ledger/search`)
     - *Modal route:* Manual Entry Builder (`/home/ledger/manual`)
     - *Sub-route:* Detail Inspector (`/home/ledger/detail/:id`)
       - *Modal route:* Annotations Editor (`/home/ledger/detail/:id/edit`)
   - *Tab Child 2:* Statistics & Analytics Dashboard (`/home/analytics`)
   - *Tab Child 3:* Settings Preferences Hub (`/home/settings`)
     - *Sub-route:* Bank Profiles Manager (`/home/settings/banks`)
     - *Sub-route:* Custom Regex Builder (`/home/settings/parser`)
     - *Sub-route:* Backup & Restore Manager (`/home/settings/backup`)
     - *Sub-route:* Background Diagnostics Panel (`/home/settings/diagnostics`)
     - *Sub-route:* Hidden Developer Console (`/home/settings/developer`)
     - *Sub-route:* System About Panel (`/home/settings/about`)

### Dialog, Bottom Sheet & Shortcut Mappings

* **Unsaved Changes Dialog:**
  - *Trigger:* Attempting to exit an active `/edit` or `/manual` form with uncommitted changes.
  - *Actions:* "Discard" (pops route), "Keep Editing" (cancels dialog).
* **PIN Access Limit Lockout Dialog:**
  - *Trigger:* Reaching three consecutive PIN entry failures on `/lock`.
  - *Actions:* Blocks screen interface with a 60-second countdown timer.
* **Destructive Wipe Database Sheet:**
  - *Trigger:* Initiating "Permanent Local Purge" on `/home/settings`.
  - *Actions:* Crimson button confirms file deletion; Cancel dismisses sheet.
* **Currency Display Sheet:**
  - *Trigger:* Selecting "Currency Display" option on `/home/settings`.
  - *Actions:* Switches display currency between Tomans ("تومان") and Rials ("ریال").
* **Shortcut: "Manual Entry":** Launches manual entry modal `/home/ledger/manual` directly from the OS launcher icon. Passes through `/lock` first if locked.
* **Shortcut: "Search Ledger":** Launches search view `/home/ledger/search` directly, triggering PIN/biometric authentication if the app is locked.
* **Deep Link: `bankyar://transactions/:id`:** Routes directly to the transaction details page. If the app is locked, the redirect target is stored in memory, launching the details page immediately after the user successfully unlocks the app.

---

## 5. Screen Lifecycle Matrix

The operational lifecycles of BankYar viewports are designed to prevent memory leaks and protect transaction histories.

| Screen Name | Initialization Hook | Data Loading Strategy | Refresh Strategy | State Preservation | Background Behavior | Memory Strategy | Dispose Rules |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Splash Screen** | Run Keystore verification on-mount | Read file existence metrics from local disk | N/A (Static checking) | None | Suspend checks | Memory-free | Auto-disposed on route exit |
| **Security Lock Gate**| Read lock configuration parameters | Read active session timer metrics | Force verification on session recovery | Keep attempt counts | Keep lock state active | Keeps biometric handlers | Clear inputs |
| **Chronological Ledger**| Mount stream listeners | Paginate reverse-chronological items from SQLCipher | Auto-update list via StreamProvider | Keep scroll position and filters | Suspend streams | Keeps page lists | Dispose observers |
| **Detail Inspector** | Parse ID from path parameter | Query specific SQLCipher record by ID | Re-query record if background writes occur | Keep active tab | Keep record loaded | Cache single record | Clear record cache |
| **Manual Entry Builder**| Fetch clipboard contents on-mount | Pre-fill form if banking text matched | Reset fields if form is cleared | Keep draft text | Keep drafts | Cache active entries | Clear drafts |
| **Statistics Dashboard**| Parse date-range bounds | Query local aggregations on background thread | Recalculate totals on bound shifts | Keep selected dates | Suspend drawing | Clear canvas instances | Dispose charts |
| **Settings Preferences**| Read configurations on-mount | Load values from SecurePreferences | Apply modifications instantly | Keep scroll coordinates | Keep options | Cache settings maps | Clear mappings |
| **Backup & Restore** | Verify storage directory paths | Check last backup file metadata | Re-evaluate backup history on-resume | None | Suspend operations | Release file threads | Close file descriptors |
| **Disaster Recovery** | Fetch recovery logs | Check database signature status | N/A | None | Keep recovery options active | Keep error messages | Clear error logs |

---

## 6. Security & Encryption Matrix

This matrix outlines the security classifications, encryption parameters, and session protection rules for each screen.

| Screen Path | Security Classification | Protection Rules | Keystore Cryptographic Binding | Window Flag Status |
| :--- | :--- | :--- | :--- | :--- |
| `/splash` | Public | Bypasses PIN lock | None | Standard (`FLAG_SECURE` inactive) |
| `/lock` | Protected | Biometric prompt checkpoint | Authenticates Keystore alias | Standard |
| `/error` | Public | Offline disaster console | None | Standard |
| `/onboarding/*` | Public | Setup flow bypasses PIN | None | Standard |
| `/home/ledger` | Sensitive | Requires active session | Unlocks SQLCipher connection key | Secure (`FLAG_SECURE` active) |
| `/home/ledger/detail/:id` | Highly Sensitive | Requires active session | SQLCipher decryption key | Secure |
| `/home/ledger/detail/:id/edit` | Highly Sensitive | Requires active session | SQLCipher encryption key | Secure |
| `/home/ledger/manual` | Sensitive | Requires active session | SQLCipher database access | Secure |
| `/home/ledger/search` | Sensitive | Requires active session | FTS5 index access | Secure |
| `/home/analytics` | Sensitive | Requires active session | SQLCipher aggregation key | Secure |
| `/home/settings` | Sensitive | Requires active session | SecurePreferences key | Secure |
| `/home/settings/banks` | Sensitive | Requires active session | SecurePreferences key | Secure |
| `/home/settings/parser` | Sensitive | Requires active session | SQLCipher database key | Secure |
| `/home/settings/backup` | Highly Sensitive | Requires active session | AES-256 backup key derivation | Secure |
| `/home/settings/diagnostics` | Sensitive | Requires active session | Diagnostic logs key | Secure |
| `/home/settings/developer` | Highly Sensitive | Requires active session | Developer sandbox key | Secure |
| `/home/settings/about` | Public | General information | None | Standard |

---

## 7. Offline & Synchronization Strategy

Every interface operates completely offline under a strict zero-network architecture constraint.

| Screen Name | Offline Capability | Storage Synchronization Type | Failure Recovery Strategy |
| :--- | :--- | :--- | :--- |
| **Splash Screen** | Works Offline (100%) | Local file system check | Redirect to Disaster Recovery (`/error`) |
| **Security Lock Gate** | Works Offline (100%) | Local biometric verification | Fallback to secure 4-digit PIN |
| **Chronological Ledger**| Works Offline (100%) | Streamed local SQLite/SQLCipher updates | Retry FTS5 query rebuilds |
| **Detail Inspector** | Works Offline (100%) | Local SQLCipher query | Return to ledger feed with inline warning toast |
| **Manual Entry Builder**| Works Offline (100%) | Atomic SQLCipher database write | Rollback active transaction and display errors |
| **Statistics Dashboard**| Works Offline (100%) | Local aggregation database query | Recalculate totals on-disk |
| **Settings Preferences**| Works Offline (100%) | Local SecurePreferences file write | Re-apply default settings profiles |
| **Backup & Restore** | Works Offline (100%) | Native OS share sheet export | Abort file read and display recovery key prompts |
| **Disaster Recovery** | Works Offline (100%) | Direct SQLCipher recovery pipeline | Guide user to build fresh database |

---

## 8. Feature-to-Screen Mapping Matrix

Every functional requirement from the PRD is mapped to its owning screen in the table below, ensuring no features are left unmapped.

| Feature ID | PRD Feature Title | Primary Owning Screen Path | Secondary Screen Context | Support Components |
| :--- | :--- | :--- | :--- | :--- |
| **FR-1.1** | Automatic SMS Interception | `/home/settings/diagnostics` | `/splash` | Background WorkManager interceptors |
| **FR-1.2** | Metadata Extraction | `/home/ledger/detail/:id` | `/home/settings/developer` | Heuristic and deterministic parsing layers |
| **FR-1.3** | Background Processing | `/home/settings/diagnostics` | `/home/ledger` | Background transaction processors |
| **FR-1.4** | Manual Import Fallback | `/home/ledger/manual` | `/home/ledger` | Paste clipboard card, Manual input fields |
| **FR-1.5** | Parser Template Management| `/home/settings/parser` | `/home/settings/developer` | Regex builders, JSON/QR rule importers |
| **FR-1.6** | Graceful Fallback (iOS) | `/home/ledger/manual` | `/home/ledger` | Clipboard checks, CSV statement forms |
| **FR-1.7** | Background Service Diagnostics| `/home/settings/diagnostics` | `/onboarding/permission_battery` | Battery optimization whitelisting manuals |
| **FR-2.1** | Enforced Local Storage | `/splash` | All screens | SQLCipher database file bindings |
| **FR-2.2** | Hardened Database Encryption| `/lock` | `/splash` | Android Keystore cryptographic providers |
| **FR-2.3** | Password-Protected Backup | `/home/settings/backup` | `/error` | Key derivation generators |
| **FR-2.4** | Permanent Local Purge | `/home/settings` | `/lock` | File-wipe controllers |
| **FR-2.5** | Secure Access Control | `/lock` | All screens | Biometric prompts, PIN input grids |
| **FR-2.6** | Local Diagnostic Logs | `/home/settings/developer` | `/home/settings/diagnostics` | Redacted console log lists |
| **FR-3.1** | Centralized Ledger | `/home/ledger` | `/home` | Reverse-chronological lists, Scroll viewports |
| **FR-3.2** | Detailed Transaction Inspector| `/home/ledger/detail/:id` | `/home/ledger` | Multi-tab structured text panels |
| **FR-3.3** | Manual Categories | `/home/ledger/detail/:id/edit` | `/home/settings/banks` | Category selection lists, custom chips |
| **FR-3.4** | Rule-Based Categorization | `/home/settings/parser` | `/home/ledger` | Text-matching triggers |
| **FR-3.5** | Custom Notes & Tags | `/home/ledger/detail/:id/edit` | `/home/ledger/detail/:id` | Tag generators, Notes inputs |
| **FR-4.1** | Cash Flow Visualizations | `/home/analytics` | `/home` | Bar charts, Date selector panels |
| **FR-4.2** | Category Allocation Charts | `/home/analytics` | `/home` | Expense donut charts |
| **FR-4.3** | Spending Behavior Trends | `/home/analytics` | `/home` | Highlight text widgets, Trend banners |
| **FR-4.4** | Advanced search & Filtering| `/home/ledger/search` | `/home/ledger` | Query fields, Scrolling filter chips |

---

## 9. Future Expansion Roadmap

The screen and navigation architecture of BankYar is designed to scale, with reserved slots and hooks prepared for upcoming features.

### 9.1 Reserved Slots for Future Features

1. **AI Insights & Personalization Engine**
   - *Target Screen Slot:* `/home/analytics` (Insights Tab)
   - *Architecture Hook:* Local heuristic pipelines can hook into the statistics stream to display personal budget tips without changing the dashboard's design.
2. **Interactive Budget Planning Tools**
   - *Target Screen Slot:* `/home/ledger/budget` (Proposed new tab sub-route `/home/budget`)
   - *Architecture Hook:* Pinned monthly budget limits can be integrated directly into the transaction feed.
3. **Recurring Payments Monitor**
   - *Target Screen Slot:* `/home/ledger/recurring` (Sub-route)
   - *Architecture Hook:* Recurrent payment predictors can analyze previous transactions to display upcoming bills.
4. **Investment & Asset Tracking**
   - *Target Screen Slot:* `/home/analytics/assets` (Sub-route)
   - *Architecture Hook:* Expand the statistics panel to support tracking stock values and currency assets.
5. **Universal Notification Listener**
   - *Target Screen Slot:* `/home/settings/diagnostics`
   - *Architecture Hook:* Extend background monitoring tools to support capturing digital bank notification push alerts directly from the system tray.
6. **Encrypted Cloud Backup Integrations**
   - *Target Screen Slot:* `/home/settings/backup/cloud` (Opt-in)
   - *Architecture Hook:* Create encrypted backup slots linking directly to secure, user-owned cloud services (e.g. ProtonDrive, NextCloud) with detailed warnings about backup security tradeoffs.
7. **Secure Peer-to-Peer Cross-Device Sync**
   - *Target Screen Slot:* `/home/settings/backup/sync`
   - *Architecture Hook:* Bluetooth sync engines can run locally to synchronize databases across nearby devices safely.
8. **Wearables Companion (Smartwatches)**
   - *Architecture Hook:* Hook into local database notifications to mirror transaction alerts on wearable screens.
9. **Desktop Companion Client**
   - *Architecture Hook:* Re-compile the parsing library to run on secure desktop clients, allowing users to import backups locally.

---

## 10. Quality Validation Checklist

To maintain structural integrity and security, any updates to the Screen Catalog or route registries must pass this validation checklist:

- [x] **No Duplicate Screens:** Verify that no two routes map to the same screen context.
- [x] **No Missing Screens:** Confirm that every user journey step maps to an active screen in the catalog.
- [x] **No Orphan Routes:** Confirm that every screen features a prominent, primary exit path.
- [x] **No Circular Routes:** Verify that page transitions do not result in infinite routing loops.
- [x] **Consistent Naming:** Verify that all paths and route aliases are declared in lowercase `snake_case`.
- [x] **Scalable Architecture:** Verify that feature changes only modify components within their respective vertical feature modules.
- [x] **Material Design 3 Compliance:** Confirm that all layouts utilize Material Design 3 design tokens and responsive gutters.
- [x] **RTL Layout Mirroring:** Verify that all page structures, back chevrons, progress indicators, and text elements mirror natively for Persian RTL locales.
- [x] **100% Offline-Ready:** Confirm that no screen features make internet requests or rely on remote database schemas.
- [x] **Zero-Network Policy:** Confirm that the app is built without internet permission blocks.
- [x] **Hardware-Bound Encryption:** Verify that database encryption parameters rely on hardware-bound keys.

---

## 11. Governance Rules

1. **Strict Design Token Adherence:** Custom style adjustments inside components are prohibited. Every visual attribute must reference an active design token.
2. **Platform Independence:** The layout must remain platform-independent, relying strictly on relative spacing blocks and logical components rather than framework-specific hacks.
3. **No Network Operations:** All elements must function offline. Incorporating external assets or third-party web dependencies is strictly prohibited.

---
**End of Screen Catalog & Application Structure Document**
