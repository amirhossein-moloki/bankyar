# Product Requirements Document (PRD) - BankYar

## Document Metadata
* **Project Name:** BankYar
* **Document Version:** 1.0.0
* **Date:** October 2023
* **Status:** Approved / Production Ready
* **Authors:** Principal Product Manager & Product Architect

---

## 0. PRD Review Findings Log & Decisions

This log documents the decisions and rationales for integrating feedback from the comprehensive Product and Architecture Review.

| Finding ID | Finding Type | Details | Decision | Rationale | Action Taken |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **RF-01** | Missing Requirement | Lack of functional requirements for secure app access / local biometric & PIN-based authentication. | **Accepted** | Essential for financial privacy; users expect secure app access. Biometrics were in-scope (16.1) but lacked detailed specifications. | Added `FR-2.5: Secure Access Control (App Lock)` in Section 10.2 with complete priority, dependencies, and acceptance criteria. |
| **RF-02** | Conflicting Requirement | Inconsistent performance latency targets (300ms in metrics, 500ms in NFR-2.1, 1s in AC 1.1). | **Accepted** | Conflicting performance targets cause ambiguity for developers and QA engineers. | Standardized end-to-end latency to < 300ms on average (with 1000ms worst-case limit) across Section 11, Section 15, and Section 19. |
| **RF-03** | Conflicting Requirement | Cryptographic terminology inconsistency (AES-256 in PRD vs AES-GCM in ARCHITECTURE.md). | **Modified** | Clarified distinct layers of encryption to maintain standard SQLCipher configurations while maximizing file-level security. | Configured SQLCipher to use standard AES-256 (CBC with PBKDF2), while using AES-256-GCM for exported backup files and secure preferences. |
| **RF-04** | Missing Requirement | Absence of functional requirements for parser template updates due to zero-network restriction. | **Accepted** | Since the app is offline-only, a secure local mechanism to import and update parsing rules must be formally defined. | Added `FR-1.5: Parser Template Management` in Section 10.1, specifying local text/JSON template imports and offline secure QR scanning. |
| **RF-05** | Security & Tech Risk | No remote crash/telemetry tracking is possible, making bug diagnostics extremely hard. | **Accepted** | Maintain the strict zero-network promise while providing a mechanism for offline debugging. | Added `FR-2.6: Local Diagnostic Logs` in Section 10.2, letting users view, manage, and manually export local encrypted error logs. |
| **RF-06** | UX & Business Risk | iOS platform limits block background SMS monitoring, threatening cross-platform feature parity. | **Accepted** | Formally specify the iOS graceful degradation mechanism to maintain high usability and clean platform-independent domain logic. | Added `FR-1.6: Platform-Specific Graceful Fallback` in Section 10.1, specifying clipboard auto-detection, share extensions, and CSV uploads. |
| **RF-07** | Technical Risk | Aggressive background task killers on custom Android skins terminate SMS monitoring. | **Accepted** | Must provide users with interactive debugging tools to maximize background reliability. | Added `FR-1.7: Background Service Diagnostics and User Guidance` in Section 10.1, defining in-app service health checks and whitelisting guides. |
| **RF-08** | Suggested Improvement | Non-functional requirements missing quantifiable and testable metrics. | **Accepted** | All NFRs must have measurable targets to support QA test plans. | Upgraded all NFRs (NFR-1.1 to NFR-3.2) with clear, testable, and quantifiable metrics in Section 11. |
| **RF-09** | Missing Requirement | Absence of concrete, explicit backup and disaster recovery requirements. | **Accepted** | Because data is 100% offline, any device loss leads to total data loss unless a strict user-managed backup mechanism exists. | Integrated dedicated sections for Backup Strategy and Data Recovery Strategy, and detailed them in functional requirements. |

---

## 1. Product Vision
BankYar aims to be the world's most trusted, intelligent, and private personal finance management companion. By bringing advanced natural language processing and financial intelligence completely on-device, BankYar envisions a world where users have absolute control over their financial data, transforming passive banking SMS notifications into actionable financial power without compromising an ounce of privacy.

---

## 2. Mission
To empower individuals to effortlessly track, analyze, and manage their finances through automated, offline-only parsing of banking SMS messages, maintaining an ironclad guarantee of 100% data privacy and zero cloud dependency.

---

## 3. Problem Statement
In today's digital economy, managing personal finance requires tracking transactions across multiple bank accounts, credit cards, and digital wallets. While various financial management apps exist, they suffer from critical flaws:
1. **Severe Privacy & Security Risks:** Existing financial apps require linking sensitive bank accounts via APIs, uploading transaction SMS logs to remote cloud servers, or exposing credentials to third-party scrapers. This leaves users highly vulnerable to data breaches, identity theft, and corporate surveillance.
2. **Friction of Manual Entry:** Users who refuse to share their financial data with cloud services must resort to tedious, manual transaction tracking in spreadsheets or note apps, which is highly prone to human error and frequently abandoned.
3. **Connectivity Dependency:** Many apps require a persistent internet connection to parse, process, and display financial insights, rendering them useless in dead zones, while traveling, or under poor network conditions.
4. **Scattered Banking Communications:** Financial notifications arrive as a chaotic stream of SMS messages across different banks and institutions. There is no centralized, standardized, and intelligent view to query or gain insights from this data.

---

## 4. Solution
BankYar is an intelligent, AI-first, offline-only banking SMS management mobile application. It sits locally on the user's device and automatically intercepts incoming banking SMS messages. Using high-performance, on-device parsing algorithms (combining deterministic logic and localized heuristic processing), it instantly extracts structured financial metadata (amounts, merchant, transaction type, account identifiers) and stores them in a heavily-encrypted local-only database.

BankYar organizes this scattered data into a clean, unified dashboard with automated and manual categorization, rich offline analytical reports, and interactive search and filter capabilities—operating completely disconnected from the internet, with zero network permissions.

---

## 5. Value Proposition
* **Absolute Privacy-First & Secure-by-Design:** Operating with zero network access and direct hardware-bound local database encryption, BankYar provides an ironclad guarantee that no financial data, banking logs, or personal details ever leave the device.
* **Frictionless Automation:** Automatically parses and structures transaction details instantly as SMS alerts arrive, saving hours of manual data entry.
* **On-Device Financial Intelligence:** Local analytical insights, spending trends, and category aggregations are generated on the fly, directly on the device.
* **Centralized Multi-Bank Dashboard:** Standardizes notifications from multiple banks and payment systems into a single, cohesive, and searchable financial ledger.
* **Consistent Offline Reliability:** Zero dependency on internet connectivity; fully functional in airplane mode, remote locations, or areas with poor cellular service.

---

## 6. Target Audience
The target audience consists of privacy-conscious mobile device users who manage multiple financial accounts and seek automated financial tracking without exposing their private data to cloud servers.

### 6.1 Target Segments
1. **Privacy Purists:** Individuals highly sensitive to data collection, financial surveillance, and cloud vulnerabilities. They distrust mainstream fintech platforms.
2. **Multi-Account Holders:** Users with multiple bank accounts, credit cards, or digital wallets who struggle to maintain a unified view of their cash flow.
3. **Frequent Travelers & Remote Professionals:** Users who frequently operate in offline or low-connectivity environments but need consistent access to financial records and budget tracking.
4. **Aspirant Budgeters:** Everyday consumers looking to manage spending and understand their budget without the friction of manually entering every cup of coffee or grocery trip.

---

## 7. Personas

### Persona A: "Privacy-Conscious Sarah" (The Security Advocate)
* **Demographics:** 34 years old, Cybersecurity Analyst, lives in a metropolitan area.
* **Behavior & Needs:** Sarah has three credit cards and two bank accounts. She refuses to link her bank accounts to cloud-based budget apps like Mint or Copilot due to API vulnerabilities and data privacy concerns. She currently tracks her transactions in an Excel sheet, which she manually updates every Sunday.
* **Pain Points:** Updates are time-consuming; she often forgets cash flow details or misplaces physical receipts. She is frustrated by the lack of immediate, automated insights.
* **How BankYar Helps:** BankYar automates the parsing of her transactions the moment they occur, securely storing the structured data locally on her phone with zero network permissions, completely satisfying her need for high security and convenience.

### Persona B: "Digital Nomad David" (The Globetrotter)
* **Demographics:** 28 years old, Freelance UX Designer, travels internationally.
* **Behavior & Needs:** David moves between countries frequently, using physical SIMs and e-SIMs. He receives bank SMS messages from his home country's banks. He operates under unstable internet conditions while traveling on trains, in remote cafes, or during flights.
* **Pain Points:** He cannot access standard fintech apps that require high bandwidth or strict regional IP addresses. He loses track of exchange rates, transaction histories, and local cash withdrawals.
* **How BankYar Helps:** BankYar functions flawlessly offline. Even in airplane mode, it securely processes his incoming SMS alerts and organizes his transactions, providing consistent, local budget analytics wherever he goes.

---

## 8. Stakeholders
* **End Users:** The primary consumers who interact with the interface, input manual notes, and leverage financial insights.
* **Product Management:** Responsible for defining product vision, features, roadmap, and user experience.
* **Engineering Team (Mobile/AI):** Responsible for building high-performance local parsers, establishing secure database architectures, and engineering responsive offline interfaces.
* **Design Team (UX/UI):** Tasked with making complex multi-bank data simple, intuitive, and highly readable on mobile screens.
* **Security & Compliance Auditors:** Independent or internal experts verifying that the application adheres to zero-network boundaries, contains no data leaks, and securely implements local encryption.

---

## 9. Business Goals
* **User Acquisition & Trust:** Establish BankYar as the gold standard for secure, private financial management, aiming to acquire 100,000 active users within the first 12 months post-release.
* **Brand Differentiation:** Position the app distinctively against mainstream cloud fintech apps by highlighting the "Zero Network Permission / Absolute Privacy" certification.
* **Future Cross-Platform Readiness:** Establish a robust architectural and product foundation on Android to ensure a seamless future migration/porting to iOS and cross-platform frameworks (e.g., Flutter) without breaking functional paradigms.
* **Organic Virality:** Drive high user referral rates through developer and privacy-focused communities (e.g., Reddit, Hacker News, privacy forums) by maintaining a transparent, verifiable privacy footprint.

---

## 10. Functional Requirements

### 10.1 SMS Detection, Processing & Integration (FR-1.x)

#### FR-1.1: Automatic SMS Interception
* **Unique ID:** FR-1.1
* **Title:** Real-Time Automatic SMS Interception
* **Description:** The system must listen for and intercept incoming SMS notifications in real time from verified financial institutions and payment gateways.
* **Priority:** High
* **Dependencies:** None
* **Acceptance Criteria:**
  - Upon receiving an SMS from a registered banking sender ID, the background listener captures the message payload (sender, body, timestamp).
  - Interception occurs dynamically while the app is in the background or closed.
  - No prompt or UI interruption is visible to the user during background interception.
* **Notes:** Limited to Android platforms due to OS permission boundaries.

#### FR-1.2: Metadata Extraction
* **Unique ID:** FR-1.2
* **Title:** Multi-Field Financial Metadata Extraction
* **Description:** The system must process raw SMS body text to extract structured financial details.
* **Priority:** High
* **Dependencies:** FR-1.1
* **Acceptance Criteria:**
  - Extracts transaction amount as a precise decimal.
  - Extracts the currency code (e.g., USD, EUR, IRR).
  - Identifies the transaction type (Credit vs. Debit).
  - Extracts the bank account or card identifier (ending digits, card indexes).
  - Identifies the merchant name or counterparty.
  - Captures the exact transaction timestamp.
  - Identifies the associated financial institution.
  - Captures the resulting account balance, if present in the text.

#### FR-1.3: Background Processing
* **Unique ID:** FR-1.3
* **Title:** Asynchronous Background Task Processing
* **Description:** Intercepted SMS parsing, classification, and database saving must execute off the main thread in a secure background process.
* **Priority:** High
* **Dependencies:** FR-1.1, FR-1.2, FR-2.1
* **Acceptance Criteria:**
  - background worker (e.g., Android WorkManager) handles incoming SMS packets.
  - SMS parsing finishes and updates the database within the strict latency targets (< 300ms on average, 1000ms maximum).
  - The process recovers and resumes safely if interrupted by OS memory management.

#### FR-1.4: Manual Import & Fallback Interface
* **Unique ID:** FR-1.4
* **Title:** Manual Statement Upload & Clip Clipboard Parsing
* **Description:** A fallback interface must be provided to allow users to manually log transactions, parse copied SMS text from their clipboard, or batch-import CSV statements from local files.
* **Priority:** High
* **Dependencies:** FR-1.2, FR-2.1
* **Acceptance Criteria:**
  - User can create a transaction using a comprehensive form (amount, currency, type, merchant, date, account).
  - User can paste raw SMS text; the parser extracts and pre-fills the manual entry fields for confirmation.
  - User can import a standard local CSV statement; the system maps and imports records offline.

#### FR-1.5: Parser Template Management
* **Unique ID:** FR-1.5
* **Title:** Local Parser Template Customization & QR Sync
* **Description:** Users must be able to create, edit, or delete custom regular expression parsing templates to support local or unrecognized financial institutions. Templates can be imported offline via JSON or safe QR codes.
* **Priority:** High
* **Dependencies:** FR-1.2, FR-2.1
* **Acceptance Criteria:**
  - The UI provides an interactive builder to define matching regex keywords for Amount, Merchant, and Card ID.
  - Testing the custom template against a sample SMS verifies extraction accuracy in-app.
  - Custom templates can be exported or imported as a local configuration file or offline QR code.

#### FR-1.6: Platform-Specific Graceful Fallback (iOS)
* **Unique ID:** FR-1.6
* **Title:** Graceful Fallback UI for Restricted Environments (iOS)
* **Description:** On iOS or sandboxed environments where background SMS interception is blocked, the app must transition gracefully, emphasizing clipboard parsing, manual entry, and CSV statements imports.
* **Priority:** High
* **Dependencies:** FR-1.4, FR-1.5
* **Acceptance Criteria:**
  - If background SMS features are unavailable, the app hides permission prompts and displays the clipboard import button prominently on the dashboard.
  - App checks the clipboard on resume; if a banking SMS pattern is matched, it triggers a non-intrusive modal prompting the user to auto-import it.
  - CSV statement template configuration matches standard banks.

#### FR-1.7: Background Service Diagnostics and Guidance
* **Unique ID:** FR-1.7
* **Title:** Background Service Health Monitor & Whitelist Guide
* **Description:** The system must actively monitor the background SMS listener's active status and guide the user on whitelisting the app from aggressive device-specific battery restrictions.
* **Priority:** Medium
* **Dependencies:** FR-1.1
* **Acceptance Criteria:**
  - A diagnostic indicator shows "Active", "Disabled", or "Restricted" status on the settings panel.
  - If restricted, the app displays a step-by-step interactive manual with device-specific guides (e.g. for MIUI, EMUI, Samsung) to disable aggressive battery optimization.

---

### 10.2 Database, Security & Access Management (FR-2.x)

#### FR-2.1: Enforced Local Storage
* **Unique ID:** FR-2.1
* **Title:** 100% Offline Local Storage
* **Description:** All user data, extracted transaction histories, custom notes, local categories, parser rules, and diagnostic files must be stored solely on the device's physical storage.
* **Priority:** High
* **Dependencies:** None
* **Acceptance Criteria:**
  - No network requests are initialized under any operational scenario.
  - Core app functionality operates perfectly under airplane mode.

#### FR-2.2: Hardened Database Encryption
* **Unique ID:** FR-2.2
* **Title:** Enterprise-Grade Offline Database Encryption
* **Description:** The local SQLite database must be encrypted at rest using standard AES-256 (via SQLCipher) with a master key derived from the secure, hardware-backed Keystore.
* **Priority:** High
* **Dependencies:** FR-2.1
* **Acceptance Criteria:**
  - Accessing the database file without the keystore key results in a decryption failure.
  - Cryptographic keys are never stored in plaintext on disk.

#### FR-2.3: Password-Protected Offline Backup (Export)
* **Unique ID:** FR-2.3
* **Title:** Password-Protected Local Data Export
* **Description:** The user must be able to export their full database, transaction histories, custom categories, and templates to a local encrypted file (JSON/CSV) protected by a custom password.
* **Priority:** High
* **Dependencies:** FR-2.1
* **Acceptance Criteria:**
  - Prompt asks the user for a strong custom password.
  - Key derivation (e.g., PBKDF2) converts the password into an AES-256 key.
  - App exports the file to local documents. The exported file is fully encrypted via AES-256-GCM.

#### FR-2.4: Permanent Local Purge
* **Unique ID:** FR-2.4
* **Title:** Complete Data Destruction (Self-Destruct)
* **Description:** The app must provide a secure trigger to immediately and permanently delete all local databases, files, key associations, and cached assets.
* **Priority:** High
* **Dependencies:** FR-2.1
* **Acceptance Criteria:**
  - Prompt requires a secondary confirmation.
  - Core data files, encrypted database files, and SharedPreferences are completely erased from disk.
  - App process terminates instantly post-deletion.

#### FR-2.5: Secure Access Control (App Lock)
* **Unique ID:** FR-2.5
* **Title:** Biometric and PIN-Based Local Access Security
* **Description:** Protect the app from unauthorized local inspection by requiring biometric authentication (Fingerprint / Face Unlock) or a fallback PIN code on launch and app-resume.
* **Priority:** High
* **Dependencies:** FR-2.1
* **Acceptance Criteria:**
  - If active, launching or resuming the app presents a blocking screen requiring biometric or PIN verification.
  - Sensitive UI screens are hidden or blurred in the task switcher preview card.
  - Three failed PIN attempts lock the app for 1 minute.

#### FR-2.6: Local Diagnostic Logs
* **Unique ID:** FR-2.6
* **Title:** Encrypted Local Error Logging & Manual Export
* **Description:** Software errors, unparsed SMS warnings, and background process crashes must be recorded locally in an encrypted file to facilitate developer diagnostics without a network connection.
* **Priority:** Medium
* **Dependencies:** FR-2.1, FR-2.2
* **Acceptance Criteria:**
  - Diagnostics system catches and appends unhandled exceptions or parser failures to the local log file.
  - Log contents must not contain plaintext financial or personal information (e.g., transaction amounts or full SMS bodies).
  - User can view logs in-app and choose to manually export them as a plaintext JSON file to share with developers.

---

### 10.3 Transaction Ledger & Annotation (FR-3.x)

#### FR-3.1: Centralized Financial Ledger
* **Unique ID:** FR-3.1
* **Title:** Unified Chronological Transaction Ledger
* **Description:** A unified, searchable, and responsive feed of all manual and automatically parsed transactions, sorted in reverse-chronological order.
* **Priority:** High
* **Dependencies:** FR-2.1
* **Acceptance Criteria:**
  - Displays list items with transaction type, merchant/bank name, amount, date, and category.
  - Supports rapid vertical scrolling (60fps+) with infinite pagination.
  - Refreshes automatically as background processing saves new incoming records.

#### FR-3.2: Detailed Transaction Inspector
* **Unique ID:** FR-3.2
* **Title:** Full Transaction Detail Viewer
* **Description:** Selecting any record loads an inspector displaying all extracted metadata fields, the full raw SMS text, the assigned category, and notes.
* **Priority:** High
* **Dependencies:** FR-3.1
* **Acceptance Criteria:**
  - Displays raw SMS text alongside structured fields for easy audit.
  - Displays "Manual Entry" badge if manually added.
  - Provides edit triggers for notes and categories.

#### FR-3.3: Manual Categories
* **Unique ID:** FR-3.3
* **Title:** Custom Spending Category Editor
* **Description:** Users must be able to create custom categories (e.g., Coffee, Business) and assign them to any transaction record in the ledger.
* **Priority:** High
* **Dependencies:** FR-3.1
* **Acceptance Criteria:**
  - Users can add, edit, or delete categories.
  - Changing a category on a transaction updates the record in the encrypted database instantly.
  - Deleting a category updates all matching transactions back to "Uncategorized".

#### FR-3.4: Rule-Based Categorization
* **Unique ID:** FR-3.4
* **Title:** Automated Local Text-Matching Categorization
* **Description:** Implement a local rule manager that automatically categorizes incoming transactions based on simple text matching (e.g., if merchant contains "Shell" -> "Fuel").
* **Priority:** High
* **Dependencies:** FR-1.2, FR-3.3
* **Acceptance Criteria:**
  - Users can create text rules matching specific merchants or banks to categories.
  - The parsing pipeline runs text rules during metadata persistence.
  - Applying rules can optionally re-categorize existing ledger items.

#### FR-3.5: Custom Notes & Tags
* **Unique ID:** FR-3.5
* **Title:** Custom Transaction Annotations and Tags
* **Description:** Users must be able to add a custom notes string and multiple search tags (e.g., `#reimbursable`, `#vacation`) to any transaction.
* **Priority:** High
* **Dependencies:** FR-3.2
* **Acceptance Criteria:**
  - Notes edit panel saves user entry instantly.
  - Custom tags are stored in a relational mapping and are fully queryable.

---

### 10.4 Offline Analytics & Insights (FR-4.x)

#### FR-4.1: Cash Flow Visualizations
* **Unique ID:** FR-4.1
* **Title:** Monthly Cash Flow Dashboard Charts
* **Description:** Display visual bar graphs comparing cash inflow (income) and outflow (expenses) across customizable monthly/weekly bounds.
* **Priority:** High
* **Dependencies:** FR-2.1, FR-3.1
* **Acceptance Criteria:**
  - Renders highly responsive charts built completely offline.
  - Recalculates dynamically when user toggles date bounds or toggles specific bank accounts.

#### FR-4.2: Category Allocation Charts
* **Unique ID:** FR-4.2
* **Title:** Expense Allocation Pie & Donut Charts
* **Description:** Display expenses grouped by spending categories as an interactive donut or pie chart, detailing exact percentages and raw monetary totals.
* **Priority:** High
* **Dependencies:** FR-3.3, FR-4.1
* **Acceptance Criteria:**
  - Donut chart partitions represent category totals.
  - Clicking on a partition filters the ledger view to show matching transactions.

#### FR-4.3: Spending Behavior Trend Alerts
* **Unique ID:** FR-4.3
* **Title:** Spending Trend Insights & Highlights
* **Description:** A smart engine that highlights variations in category expenditure and cash flow trends over time (e.g., "Spent 10% less on Groceries this month compared to the previous month").
* **Priority:** Medium
* **Dependencies:** FR-4.1
* **Acceptance Criteria:**
  - Statistical insights appear directly on the analytical screen.
  - Evaluates changes over weekly/monthly intervals using historical local database entries.

#### FR-4.4: Advanced Ledger Search & Filtering
* **Unique ID:** FR-4.4
* **Title:** Multi-Parameter Search Engine
* **Description:** Allow users to instantly filter the chronological transaction ledger using multiple search parameters.
* **Priority:** High
* **Dependencies:** FR-3.1
* **Acceptance Criteria:**
  - Supports filtering by date range, specific bank, transaction type (debit/credit), and specific category.
  - Text bar searches match against merchant name, notes, raw text, and tags.
  - Resolves queries locally in < 200ms.

---

## 11. Non-functional Requirements

### 11.1 Security & Privacy

* **NFR-1.1: Zero Network Access:** The application Manifest must NOT include `android.permission.INTERNET` or any other networking permission. Verified by compiling and confirming that exactly 0 bytes of external network transmission occur.
* **NFR-1.2: Hardware-Backed Cryptography:** Cryptographic keys must utilize secure hardware storage providers (e.g., Android Keystore, iOS Secure Enclave) using modern key encryption standards. If keys are deleted or hardware becomes locked, the database must remain unreadable (0% plaintext leakage).
* **NFR-1.3: No Cloud Sync or Telemetry:** There must be zero inclusion of remote crash monitoring (e.g., Crashlytics) or user behavioral tracking (e.g., Firebase Analytics). Total telemetry transmission must equal exactly 0 bytes.
* **NFR-1.4: Screen Security:** The application must utilize OS flags (e.g., `WindowManager.LayoutParams.FLAG_SECURE` on Android) to completely block local screenshot captures, screen recording, and display blank screen previews on the recent tasks switcher list.

### 11.2 Usability & Performance

* **NFR-2.1: Low-Latency SMS Processing:**
  - The local on-device parsing engine must execute and extract financial metadata in less than **200 milliseconds** from raw text reception.
  - The database insertion write pipeline must complete in less than **100 milliseconds**.
  - Total end-to-end background latency (from receipt of SMS system broadcast to final ledger update and reactive UI push) must be less than **300 milliseconds** on average, and must never exceed **1000 milliseconds** (1 second) in worst-case OS background worker thread wakeups.
* **NFR-2.2: Highly Responsive UI Thread:** Main thread database operations are strictly prohibited. Scrolling on the main ledger must remain steady at **60fps+** (and up to **120fps** on supporting mobile displays) with 0% interface freeze frames. Total local UI response latency to user interactions (e.g., tap-to-expand) must be under **100ms**.
* **NFR-2.3: Battery Consumption Efficiency:** Background monitoring and parsing must consume less than **0.5%** of the total daily mobile battery usage.
* **NFR-2.4: Storage Footprint Minimization:** The basic application installer bundle size must be under **50 megabytes** (50MB) on both platforms. Database record storage must consume less than **1 kilobyte** (1KB) per transaction.

### 11.3 Reliability & Extensibility

* **NFR-3.1: Graceful Parser Degradation:** If an incoming banking SMS format is unrecognized, the app must not crash (0% parser-induced crash rate). The app must create an "Unparsed Transaction" and securely save the raw text for manual input.
* **NFR-3.2: Decoupled Parsing Architecture:** Core parsing and metadata isolation logic must remain decoupled from the framework UI to support independent unit test execution. Core parsing modules must achieve **100% unit test coverage** of known banking rules.

---

## 12. Constraints
* **Platform SMS API Limitations:** The app can only automatically detect SMS on operating systems that permit background SMS monitoring (such as Android). On platforms with restrictive sandbox permissions (such as iOS), the app is strictly constrained from reading SMS in the background.
* **Zero Network Database Updates:** Since there is no internet access, the application cannot fetch updated parsing templates from a remote server. The template/rule updates must be handled via safe local imports (e.g., scanning a localized secure QR code, importing a text config file, or bundling rules inside app updates).
* **On-Device Computing Power:** AI-first parsing must rely on lightweight, highly optimized heuristic classifiers (e.g., regex mapping or extremely small TFLite tokenizers) to avoid high memory and CPU usage on older mobile devices.

---

## 13. Assumptions & Dependencies
* **A-1:** The target mobile operating system supports standard SMS broadcast delivery mechanisms and provides APIs for reading SMS metadata with proper user permissions.
* **A-2:** Banks in the target market continue to send transaction receipts via SMS and have not transitioned fully to proprietary in-app push notifications.
* **A-3:** Users have secure hardware-backed key storage capabilities on their devices to facilitate strong, modern local encryption.
* **A-4:** Users are willing to grant SMS permission to BankYar because of the verifiable, compiled zero-network design.
* **A-5:** Users keep their devices secure (e.g., lock screen enabled) to safeguard hardware keys.

---

## 14. Product Risks & Mitigation Matrix

| Risk ID | Risk Title | Severity | Likelihood | Impact Details | Mitigation Strategy |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **R-1** | OS SMS Permission Changes | High | Medium | Android security policy changes may restrict background SMS read access (`READ_SMS` / `RECEIVE_SMS`). | Build polished manual statements fallback: clipboard fast-parsing modal, CSV statements upload form, and clear tutorial screens. |
| **R-2** | SMS Alert Format Drifts | Medium | High | Banks change text templates dynamically, breaking existing regex parsers. | Build dynamic local custom template builder (FR-1.5) and enable safe community-driven JSON templates import via offline QR scan. |
| **R-3** | Aggressive OS Background Killers | Medium | High | Background services killed by custom ROM task managers (MIUI/EMUI), causing missed SMS. | Integrate WorkManager, foreground service triggers, and display custom in-app whitelisting manuals (FR-1.7). |
| **R-4** | Hardware Key Erasure / Loss | High | Low | System lock screen modifications or hardware reset erases keystore master key, corrupting database access. | Require password-protected local backup export (FR-2.3) frequently, enabling recovery across different environments/devices. |
| **R-5** | Transition to Push Notifications | High | Medium | Banks deprecate SMS alerts in favor of proprietary app push alerts. | Architect parser input as generic strings, preparing for future local Notification Listener integrations, manual clips, and CSV exports. |

---

## 15. Success Metrics
* **Monthly Active Users (MAU):** Grow to 100,000 active privacy-conscious users within the first 12 months post-release.
* **Zero Security Violations:** 100% compliance with privacy-first standards, verifying that 0 bytes of user data are transmitted externally during independent application audits.
* **Parser Accuracy:** Maintain a parsing accuracy rate of 98% or higher for transactions received from verified, standard bank templates.
* **SMS-to-Ledger Latency:** Achieve average backend processing and ledger insertion times of less than 300 milliseconds from the exact moment the SMS broadcast is received.
* **User Retention Rate:** Aim for a 60-day user retention rate of 45% or higher, showcasing the utility of automated tracking.

---

## 16. Product Scope

### 16.1 In-Scope Features (Phase 1)
* Real-time automated intercept and parsing of banking/payment SMS alerts.
* Core transaction ledger detailing amount, currency, timestamp, merchant, bank, type, raw text, and categories.
* Complete offline operations with zero network connectivity requirements or permissions.
* Automated dynamic categorization based on merchant name and simple local rules.
* Custom manual text notes and category tags per transaction.
* Local analytical reports (monthly cash flow, category breakdowns via pie/bar charts, spending trends).
* Export and import capability via encrypted files (JSON/CSV) for manual backup and recovery.
* Secure local biometric authentication (fingerprint/face unlock) and PIN entry to open the app.
* Fallback UI for manual entry, copy-paste parsing, and bulk statement uploads.
* Local Diagnostic Log panel for networkless error reporting.
* Health monitor and background diagnostics panel.

---

## 17. Out of Scope (Strictly Excluded)
* **Cloud Syncing or Remote Backups:** No native integrations with Google Drive, iCloud, Dropbox, or proprietary servers.
* **Direct Bank API Integrations (Plaid, Open Banking):** No internet-facing credentials, online banking logins, or live bank scraping protocols.
* **Social Sharing Features:** No sharing of financial statistics, split bills, or peer-to-peer social finance structures.
* **Investment/Stock Portfolio Tracking:** The app will focus strictly on cash flow (incomes, expenses, account balances) and will not track real-time stock markets or crypto assets.
* **Automatic SMS Deletion:** The app will only read and parse banking SMS; it will not have permission to delete, modify, or send SMS messages.

---

## 18. Future Roadmap

### Phase 1: Native Android Core (Current Target)
* Establish Kotlin-based offline engine.
* Achieve perfect background SMS interception and high-accuracy parsing of primary domestic banks.
* Implement the encrypted SQLCipher local database.
* Deliver core budget ledger, category tags, notes, and local visualizations.
* Deliver diagnostic log exports and battery diagnostic manuals.

### Phase 2: Cross-Platform Migration & Universal Architecture
* Port the application to Flutter, retaining the same feature-first structure.
* Standardize the core parsing and data layer across platform-independent modules.
* Introduce the "Graceful Degradation UX" on iOS: Because iOS blocks background SMS interception, build a highly polished manual import workflow (leveraging iOS Share Sheet extensions, clipboard fast-parsing, and standard CSV statement importing).

### Phase 3: Advanced Local Heuristics & Personalization
* Implement a highly optimized on-device heuristic classifier (e.g., Naive Bayes or localized BERT-mini via TensorFlow Lite) to handle parsing of complex, non-standard, or previously unseen foreign transaction formats.
* Create localized peer-to-peer secure sync (e.g., backup directly to a home NAS or personal computer via local Wi-Fi without passing through any public cloud).
* Enable user-to-user localized sharing of custom bank templates (via offline QR code scanning).

---

## 19. Acceptance Criteria

### 19.1 SMS Parsing & Detection Engine
* **AC 1.1:** Given an incoming SMS from a recognized banking format (e.g., debit alert of $45.50 at Merchant X), the app must intercept it in the background, extract the amount, merchant, timestamp, and card/account reference correctly, and append it to the ledger within an average end-to-end background processing latency of < 300ms (and max 1 second).
* **AC 1.2:** If an unrecognized SMS arrives, the app must safely log it as an "unparsed transaction" without crashing and allow the user to manually correct the parsed metadata fields.
* **AC 1.3:** The parsing engine must successfully operate with airplane mode active, generating identical extraction results compared to normal cellular operation.

### 19.2 Privacy & Security
* **AC 2.1:** The app must compile and install successfully without requesting the `android.permission.INTERNET` permission in the Manifest.
* **AC 2.2:** The SQLCipher local database must be fully encrypted. Attempting to open the database file without the hardware-backed master key must result in a read failure.
* **AC 2.3:** Disabling biometric lock or PIN from the settings must require secondary confirmation to prevent unauthorized access to local financial files.

### 19.3 User Ledger & Annotation
* **AC 3.1:** The user must be able to view a reverse-chronological list of transactions, load transaction details instantly upon clicking, and apply custom note strings and category labels.
* **AC 3.2:** Changes made to a transaction (notes, category, manual amount corrections) must persist immediately in the local encrypted database.

### 19.4 Offline Analytics
* **AC 4.1:** The analytics dashboard must correctly aggregate total monthly expenses and income and display them as visual charts.
* **AC 4.2:** Filtering the ledger by date range or specific category must instantly update the list view and recalculate analytics totals within 200 milliseconds.

### 19.5 Backup & Portability
* **AC 5.1:** The app must generate a password-protected encrypted file when a user triggers a backup export.
* **AC 5.2:** Importing a valid encrypted backup on a fresh install of the app must restore the entire transaction history, notes, and categories perfectly, without needing network access.

---

## 20. Additional Architectural Alignment & Integration

To bridge the high-level business goals and the physical developer layout defined in `ARCHITECTURE.md`, this section outlines clear parameters for offline financial systems.

### 20.1 Security Considerations & Key Lifecycle
1. **Master Key Generation:**
   - On initial app startup, a strong master key (AES-256) is generated using the hardware-backed cryptographic provider (e.g. AndroidKeyStore).
   - The master key is stored in the device's Secure hardware (TEE/StrongBox) under alias `bankyar_db_key`.
2. **Access Control Bindings:**
   - If User Lock (FR-2.5) is active, the master key is bound to the biometric prompt, requiring local hardware verification to unlock and decrypt the SQLite database connection.
3. **Key Lifecycle & Expiry:**
   - Keys remain cached only during the active application process memory life.
   - If the app is sent to the background, keys are memory-purged after 5 minutes of inactivity, forcing re-authentication on the next resume.

### 20.2 Privacy Requirements & Data Minimization
1. **Zero-Trace Principle:**
   - No text payload or transaction detail is ever stored in plaintext anywhere in standard system temporary files, cache, or external storage.
2. **Telemetry Exclusion:**
   - Any software diagnostic logging (FR-2.6) runs strictly localized. Plaintext numbers, account indexes, or financial merchants are scrubbed from local logs.
3. **No Automatic Backups:**
   - To prevent unencrypted storage sync to cloud providers, the app declares `android:allowBackup="false"` in its Android Manifest.

### 20.3 Parser Reliability Requirements (Deterministic vs Heuristic)
The parsing layer employs a hybrid pipeline to maximize processing reliability and minimize resource overhead:
1. **Deterministic Rule Layer (Primary):**
   - Uses pre-compiled regex templates representing standard bank notifications.
   - Resolves matches in < 100ms.
2. **Heuristic/Classifiers Fallback (Secondary):**
   - If deterministic parsing fails, a lightweight on-device heuristic classifier parses key figures (numbers matching monetary patterns, timestamp patterns).
   - If successful, records transaction as "Parsed - Low Confidence" and highlights fields in the UI.
   - If unsuccessful, falls back to "Unparsed Transaction" (NFR-3.1).

### 20.4 SMS Processing Requirements
1. **Deduplication:**
   - The ingestion pipeline must perform a hash check based on `Hash(raw_body + timestamp + sender)` to reject duplicate SMS events triggered by cellular retransmissions.
2. **Filtering Boundaries:**
   - Messages are ignored immediately if they do not match a pre-registered banking sender ID or contains none of the registered financial keywords (e.g., "debit", "credit", "balance", "transaction", "withdrawn").

### 20.5 Backup Strategy
1. **User Ownership:** Backups are entirely controlled by the user. No automatic backup processes run in the background.
2. **Export Encryption:** Exports use the secure `AES-256-GCM` algorithm. The encryption key is derived using `PBKDF2WithHmacSHA256` with a custom password and a random salt value appended to the file.
3. **Backup Completeness:** The exported file must contain the complete structured JSON representation of:
   - All transactions
   - Custom notes and annotations
   - Custom tags and relational mappings
   - Custom parser templates defined by the user

### 20.6 Data Recovery Strategy
1. **Cross-Platform Compatibility:** The backup JSON structure must follow a standard, platform-independent schema. Backups exported from Android can be imported directly into the iOS/Flutter version in the future.
2. **Validation Safeguard:** Prior to overwrite during restore, the importing system must run a sanity check on the schema version. If validation fails, the recovery process is aborted, protecting the existing local database from corruption.

### 20.7 Version Compatibility
1. **Schema Migration Path:** When database structural changes are introduced in app updates, SQLCipher migration scripts must execute locally.
2. **Backward Compatibility:** Future application builds must support importing older schema backup files, mapping deprecated fields gracefully without losing transactional history.

### 20.8 Future Extensibility
1. **Notification Listener Integration:** The ingestion abstraction must prepare interfaces to support monitoring of Android Notification Listeners, preparing the app to capture transaction notifications from digital banks that use push alerts instead of SMS.
2. **Offline Community QR Rules Sync:** Pre-designed templates for new banks can be distributed by community members as encrypted text configurations displayed as QR codes. Users can extend parser rules by scanning these QR codes without updating the application code.
