# BankYar Domain Model Specification Document

**Project Name:** BankYar
**Product Version:** 1.0.0
**Document Version:** 1.0.0
**Authors:** Principal Domain-Driven Design (DDD) Architect & Enterprise Solution Architect
**Status:** Approved / Domain Baseline

---

## Executive Summary

BankYar is a privacy-first, secure personal finance management mobile application designed to operate 100% offline with zero network capabilities. This document outlines the complete **Business Domain Model** for BankYar, structured strictly under the principles of **Domain-Driven Design (DDD)**.

To ensure complete independence from technology stacks (such as Flutter, SQLCipher, or Android APIs), this model focuses exclusively on business concepts, domain boundaries, business rules, invariants, and entity lifecycles. It serves as the single source of truth for the domain layer of the application, designed to support clean architectural boundaries and facilitate seamless future AI-assisted implementation.

---

## Table of Contents
1. [Ubiquitous Language](#1-ubiquitous-language)
2. [Core Domain](#2-core-domain)
3. [Supporting Domains](#3-supporting-domains)
4. [Generic Domains](#4-generic-domains)
5. [Bounded Contexts](#5-bounded-contexts)
6. [Domain Entities](#6-domain-entities)
7. [Value Objects](#7-value-objects)
8. [Aggregates](#8-aggregates)
9. [Aggregate Roots](#9-aggregate-roots)
10. [Domain Services](#10-domain-services)
11. [Domain Events](#11-domain-events)
12. [Domain Rules](#12-domain-rules)
13. [Domain Invariants](#13-domain-invariants)
14. [Entity Relationships](#14-entity-relationships)
15. [Lifecycle of each Entity](#15-lifecycle-of-each-entity)
16. [Ownership Rules](#16-ownership-rules)
17. [Validation Rules](#17-validation-rules)
18. [Identity Rules](#18-identity-rules)
19. [Future Extension Points](#19-future-extension-points)
20. [Domain Risks](#20-domain-risks)
21. [Domain Assumptions](#21-domain-assumptions)
22. [Business Constraints](#22-business-constraints)
23. [Domain Glossary](#23-domain-glossary)

---

## 1. Ubiquitous Language

The Ubiquitous Language is established to ensure absolute alignment between business experts, product managers, and software engineers. The following terms represent domain concepts that must be used consistently across all specifications, documentation, and source code.

| Term | Context | Business Definition |
| :--- | :--- | :--- |
| **SMS Ingestion** | Ingestion & Parsing | The technical-business process of intercepting a raw cellular Short Message Service (SMS) broadcast and feeding it into the application pipeline. |
| **Deterministic Matching** | Parsing | The parsing of raw text using pre-defined, rigid regex templates to extract exact structured financial figures with 100% confidence. |
| **Heuristic Processing** | Parsing | A statistical pattern-matching algorithm used as a fallback to isolate currency, amount, and transaction verbs when no deterministic templates match. |
| **Parser Template** | Parsing | A structured schema containing regular expressions and token indices that guide the deterministic matching engine for specific bank sender IDs. |
| **Confidence Score** | Parsing | A value representing the statistical certainty of a parsed transaction's metadata (e.g., 1.0 for deterministic, < 1.0 for heuristic fallback). |
| **Transaction Ledger** | Ledger & Annotation | A unified, chronologically ordered record of all financial transactions (debit and credit) detected or manually created. |
| **Custom Category** | Ledger & Annotation | A user-defined classification tag (e.g., "Food", "Business") used to organize transactions for cash flow reporting. |
| **Auto-Rule** | Ledger & Annotation | A localized user-defined trigger that automatically assigns a specific Category to an incoming transaction if the merchant or bank name matches designated keywords. |
| **Annotation** | Ledger & Annotation | User-supplied context consisting of textual Notes and searchable custom Hashtags appended directly to a Transaction record. |
| **Deduplication Hash** | Ingestion & Parsing | A unique signature calculated from raw SMS text, timestamp, and sender ID to prevent double-logging of retransmitted messages. |
| **Backup Export** | Backup & Recovery | The process of exporting the entire user database, templates, categories, and logs into a single password-encrypted flat file. |
| **Restore Overwrite** | Backup & Recovery | The process of verifying, decrypting, and completely replacing the current active database with a verified imported backup file. |
| **Self-Destruct** | Security & Session | A security procedure that immediately purges all local databases, files, caches, and encryption keys from the device storage. |
| **App Lock** | Security & Session | A blocking access screen that prevents UI interaction until the user passes biometric or PIN verification. |
| **Key Eviction** | Security & Session | The automatic removal of cryptographic database keys from volatile system memory (RAM) after a period of app inactivity. |
| **PII Scrubbing** | Logging | The automated filtering of personal identifiable information (numerical digits, exact card indexes, unparsed messages) from local diagnostic logs. |

---

## 2. Core Domain

The **Core Domain** represents the primary competitive advantage and the heart of the BankYar application. It contains the business intelligence required to transform unstructured, noisy banking text messages into highly structured financial datasets completely offline.

### Focus Areas:
* **Automated Data Capture & Extraction:** Real-time background capture and isolation of financial transactions.
* **On-Device Financial Metadata Extraction:** Parsing raw text to identify Amount, Currency, Merchant, Transaction Type (Debit/Credit), and Account/Card identifiers.
* **Hybrid Parser Engine:** Orchestration of the high-speed deterministic regex router and the statistical heuristic fallback classifier.

---

## 3. Supporting Domains

**Supporting Domains** are necessary for the product's completeness but do not represent the core intellectual property. They support the Core Domain by providing organization, visualization, and user enrichment.

### Focus Areas:
* **Ledger & Personalization (Ledger & Annotation):** Storing structured transaction entries, allowing manual entries, applying custom Notes, creating searchable custom Hashtags, and defining custom categories.
* **Automated Text-Matching Rule Engine (Auto-Categorization):** Applying user-defined keyword triggers to assign categories automatically during transaction persistence.
* **Offline Financial Analytics (Analytics & Reports):** Compiling chronological data to generate monthly cash flow allocations, category expenses, and spending trend notifications completely locally.

---

## 4. Generic Domains

**Generic Domains** represent standard enterprise software functionalities that can be found in many applications. They are essential for security and operational integrity but are not unique to personal finance tracking.

### Focus Areas:
* **Security & Session Management:** Password-PIN authorization, OS biometric authentication hooks, application locking, and cryptographic key lifecycle management (creation, storage, and eviction).
* **Backup, Portability & Disaster Recovery:** Password-derived key derivation (PBKDF2), file-level encryption (AES-256-GCM), and schema version compatibility checks.
* **Local Diagnostic Logging:** Capturing system crashes, parser exceptions, and unrecognized SMS structures in a size-capped, local-only, PII-scrubbed log file.

---

## 5. Bounded Contexts

To isolate domain rules and prevent structural model pollution, BankYar is divided into five distinct **Bounded Contexts**. Each context contains its own domain models, definitions, and rules, and interacts with other contexts only through defined domain interfaces (such as Domain Events or injected Use Cases).

```
+-----------------------------------------------------------------------------------------+
|                                  BANKYAR BOUNDED CONTEXTS                               |
|                                                                                         |
|  +-------------------------------------+                 +----------------------------+  |
|  |     INGESTION & PARSING CONTEXT     |                 |  SECURITY & SESSION CONTEXT|  |
|  |                                     |                 |                            |  |
|  |  Entities: SMS, ParserTemplate      |                 |  Entities: SecurityConfig  |  |
|  |  Value Objects: ConfidenceScore,    |                 |  Value Objects: SecurePin  |  |
|  |                 CardIdentifier      |                 |                            |  |
|  +------------------+------------------+                 +-------------+--------------+  |
|                     |                                                  |                 |
|                     | Publishes SMSReceived /                          | Unlocks DB      |
|                     | TransactionParsed Events                         |                 |
|                     v                                                  v                 |
|  +------------------+------------------+                 +-------------+--------------+  |
|  |     LEDGER & ANNOTATION CONTEXT     |                 |  BACKUP & PORTABILITY CON- |  |
|  |                                     |                 |  TEXT                      |  |
|  |  Entities: Transaction, Category,   |                 |                            |  |
|  |            Note, Tag                |---------------->|  Value Objects:            |  |
|  |  Value Objects: MonetaryAmount,     |  Serializes     |  BackupMetadata            |  |
|  |                 Merchant            |  Data           |                            |  |
|  +------------------+------------------+                 +----------------------------+  |
|                     |                                                                    |
|                     | Streams Live Ledger Data                                           |
|                     v                                                                    |
|  +------------------+------------------+                                                 |
|  |          ANALYTICS CONTEXT          |                                                 |
|  |                                     |                                                 |
|  |  Analyzes cash flow records and    |                                                 |
|  |  monthly spending allocations       |                                                 |
|  +-------------------------------------+                                                 |
+-----------------------------------------------------------------------------------------+
```

### Context Integration Specifications:

1. **Ingestion & Parsing Context $\rightarrow$ Ledger & Annotation Context:**
   - **Integration Vector:** Domain Events (`TransactionParsed`).
   - **Mechanism:** When a raw SMS is captured and parsed successfully, the `Ingestion & Parsing Context` publishes a `TransactionParsed` event containing the extracted metadata. The `Ledger & Annotation Context` listens for this event, instantiates a new `Transaction` entity, runs local categorization rules, and persists it to the encrypted database.
2. **Security & Session Context $\rightarrow$ Database Core (Infrastructure):**
   - **Integration Vector:** Direct key delegation.
   - **Mechanism:** The database cannot open without a valid key. The `Security & Session Context` decrypts the master database key from secure hardware storage (KeyStore/Enclave) upon successful user login and injects it into the DB connection pool. It clears this key from RAM upon timeout.
3. **Ledger & Annotation Context $\rightarrow$ Backup & Portability Context:**
   - **Integration Vector:** Data Serialization contracts.
   - **Mechanism:** The `Backup & Portability Context` queries the transaction registry interface, maps the structured ledger to a standardized schema, and writes it to an encrypted JSON/CSV file.
4. **Ledger & Annotation Context $\rightarrow$ Analytics Context:**
   - **Integration Vector:** Unidirectional query streams.
   - **Mechanism:** The `Analytics Context` listens to chronological transaction lists to calculate trends, spending behavior charts, and statistics.

---

## 6. Domain Entities

Domain Entities are objects defined by a unique identity that persists across state changes and time.

```
       +-------------------------------------------------------------------+
       |                       CORE DOMAIN ENTITIES                        |
       +-------------------------------------------------------------------+
       |                                                                   |
       |  +---------------------------+       +-------------------------+  |
       |  |            SMS            |       |     ParserTemplate      |  |
       |  |  - ID (UUID)              |       |  - ID (UUID)            |  |
       |  |  - RawText                |       |  - SenderId             |  |
       |  |  - ReceivedAt             |       |  - MatchingRegex        |  |
       |  |  - SenderId               |       |  - MappingConfig        |  |
       |  +---------------------------+       +-------------------------+  |
       |                                                                   |
       |  +-------------------------------------------------------------+  |
       |  |                        Transaction                          |  |
       |  |  - ID (UUID)                                                |  |
       |  |  - Amount (MonetaryAmount)                                  |  |
       |  |  - Merchant (Merchant)                                      |  |
       |  |  - Timestamp                                                |  |
       |  |  - Type (TransactionType)                                   |  |
       |  |  - SourceSmsId (Nullable Reference)                         |  |
       |  +-------------+-----------------------------+-----------------+  |
       |                |                             |                    |
       |                v Owled                       v Owned              v Reference
       |  +-------------+-------------+       +-------+-------+    +-------+-------+
       |  |           Note            |       |      Tag      |    |   Category    |
       |  |  - ID (UUID)              |       |  - ID (UUID)  |    |  - ID (UUID)  |
       |  |  - NoteText               |       |  - LabelText  |    |  - Name       |
       |  |  - EditedAt               |       |  - CreatedAt  |    |  - ColorHex   |
       |  +---------------------------+       +---------------+    +---------------+
```

---

### 1. SMS Entity
* **Purpose:** Represents a raw text message captured from the telephony network or imported from manual fallback clipboard interfaces.
* **Responsibilities:**
  - Holds raw textual content, timestamp, and carrier sender metadata.
  - Generates a unique deduplication hash.
  - Maintains ingestion status (Raw, Parsed, Ignored, Unparsed).
* **Attributes:**
  - `id`: `SmsId` (UUID v4) — Immutable.
  - `rawText`: `String` — Raw text of the incoming SMS message.
  - `senderId`: `String` — Carrier identification of the sender (e.g., "BANK_OF_AMERICA").
  - `receivedAt`: `DateTime` — Chronological time recorded by the operating system.
  - `deduplicationHash`: `String` — SHA-256 digest of `senderId + rawText + receivedAt`.
  - `ingestionStatus`: `SmsIngestionStatus` (Enum: `RAW`, `PARSED`, `UNPARSED`, `IGNORED`).
* **Identity:** Unique `id` (UUID v4). Secondary natural identity is the `deduplicationHash`.
* **Lifecycle:** Captured $\rightarrow$ Deduplicated $\rightarrow$ Pattern Matched $\rightarrow$ (Parsed $\lor$ Unparsed $\lor$ Ignored).
* **Relationships:**
  - Associated with exactly zero or one `Transaction` (A parsed transaction references its source SMS).
* **Constraints:**
  - `rawText` cannot be empty.
  - `receivedAt` cannot represent a future datetime.
* **Business Rules:**
  - If the deduplication hash matches an existing record in the registry, the SMS is classified as `IGNORED` and immediately dropped.
  - SMS records must never be deleted cascade-wise when a user deletes a parsed `Transaction` record.
* **Validation Rules:**
  - `deduplicationHash` must be exactly 64 hexadecimal characters.
* **Possible Future Extensions:**
  - Platform notification payloads (for banks transitioning away from SMS to application push alerts).

---

### 2. ParserTemplate Entity
* **Purpose:** Defines the deterministic extraction rules for a specific financial institution.
* **Responsibilities:**
  - Stores regular expressions mapped to structured monetary figures, merchant names, and card indexes.
  - Validates extraction expressions against test inputs.
* **Attributes:**
  - `id`: `TemplateId` (UUID v4) — Immutable.
  - `senderId`: `String` — Expected carrier Sender ID (case-insensitive matching).
  - `matchingRegex`: `String` — Standard regular expression with capture groups.
  - `amountGroupIndex`: `Int` — Regex group capture index for the transaction amount.
  - `currencyGroupIndex`: `Int` — Regex group capture index for the currency symbol/code.
  - `merchantGroupIndex`: `Int` — Regex group capture index for the merchant/counterparty.
  - `cardGroupIndex`: `Int` — Regex group capture index for the card or account index.
  - `typeGroupIndex`: `Int` — Regex group capture index for debit/credit indicator keywords.
  - `createdAt`: `DateTime` — Date of template creation.
  - `updatedAt`: `DateTime` — Date of last configuration revision.
* **Identity:** Unique `id` (UUID v4).
* **Lifecycle:** Draft $\rightarrow$ Active $\rightarrow$ Suspended.
* **Relationships:**
  - One-to-Many association with incoming `SMS` captures (one template can parse millions of SMS alerts).
* **Constraints:**
  - `matchingRegex` must compile cleanly under the standard engine.
  - All group indices must point to valid captures defined inside the regex.
* **Business Rules:**
  - Deleting a `ParserTemplate` must never delete already-created `Transaction` records.
  - A custom user-defined template overrides standard pre-packaged vendor templates for the same `senderId`.
* **Validation Rules:**
  - `senderId` length must be between 3 and 20 characters, containing alphanumeric characters or standard underscores.
* **Possible Future Extensions:**
  - Cryptographic signatures appended to community-generated templates scanned via QR codes.

---

### 3. Transaction Entity
* **Purpose:** Represents a structured financial record of money moving in (Credit) or out (Debit) of the user's accounts.
* **Responsibilities:**
  - Standardizes financial details from SMS or manual entries.
  - Maintains associations to categories, custom tags, and user notes.
* **Attributes:**
  - `id`: `TransactionId` (UUID v4) — Immutable.
  - `amount`: `MonetaryAmount` (Value Object) — Value and currency.
  - `type`: `TransactionType` (Value Object) — `DEBIT` or `CREDIT`.
  - `merchant`: `Merchant` (Value Object) — Raw and normalized merchant name.
  - `cardIdentifier`: `CardIdentifier` (Value Object) — Account or card ending index.
  - `timestamp`: `DateTime` — Chronological execution time of the transaction.
  - `categoryId`: `CategoryId` (UUID v4, Nullable) — Reference to the associated category.
  - `sourceSmsId`: `SmsId` (UUID v4, Nullable) — Reference to the source SMS entity.
  - `confidenceScore`: `ConfidenceScore` (Value Object) — Parsing score (1.0 for manual/deterministic, < 1.0 for heuristic fallback).
  - `createdAt`: `DateTime` — Timestamp of database record insertion.
* **Identity:** Unique `id` (UUID v4).
* **Lifecycle:** Parsed/Created $\rightarrow$ Categorized $\rightarrow$ Annotated $\rightarrow$ (Deleted $\lor$ Exported).
* **Relationships:**
  - One-to-One ownership of `Note` (if annotated).
  - Many-to-Many relationship with `Tag` entities.
  - Many-to-One relationship with `Category` (belongs to exactly one category, defaults to "Uncategorized").
  - Many-to-One relationship with source `SMS` (if auto-generated).
* **Constraints:**
  - Transaction amount must be positive and non-zero.
  - The transaction timestamp must not be in the future.
* **Business Rules:**
  - Every transaction belongs to exactly one Bank/Institution (resolved via `senderId` of source SMS or manual selection).
  - Deleting a transaction permanently purges its associated custom notes and tag links, but does not affect the Category entity or the source SMS.
* **Validation Rules:**
  - `amount` must be represented as a decimal with up to four decimal places.
* **Possible Future Extensions:**
  - Multi-currency conversions on-device using a locally defined exchange table.

---

### 4. Category Entity
* **Purpose:** Provides custom organizational structures to group user expenses and incomes.
* **Responsibilities:**
  - Holds category details (Name, Color Token).
  - Guides offline financial analytics queries.
* **Attributes:**
  - `id`: `CategoryId` (UUID v4) — Immutable.
  - `name`: `String` — Clean name (e.g., "Groceries", "Fuel").
  - `colorHex`: `String` — Color representation for dashboard visualization (e.g., "#FF5733").
  - `isSystemDefined`: `Boolean` — Flag specifying if the category is pre-packaged (e.g., "Uncategorized").
* **Identity:** Unique `id` (UUID v4). Unique natural index on `name`.
* **Lifecycle:** Active $\rightarrow$ Modified $\rightarrow$ (Deleted $\lor$ Retained).
* **Relationships:**
  - One-to-Many association with `Transaction` (one category groups multiple transaction records).
* **Constraints:**
  - `name` cannot be blank. Must be unique across active categories.
  - `colorHex` must represent a valid 6-character hexadecimal color string.
* **Business Rules:**
  - Deleting a Category updates all related `Transaction` entities back to the system-default "Uncategorized" category.
  - System-defined categories are immutable and cannot be deleted or renamed.
* **Validation Rules:**
  - `name` length must be between 1 and 30 characters.
* **Possible Future Extensions:**
  - Parent-Child hierarchical relationships (Subcategories, e.g., "Food" $\rightarrow$ "Restaurants").

---

### 5. Note Entity
* **Purpose:** User-supplied textual annotations appended to a specific transaction to explain or detail its context.
* **Responsibilities:**
  - Stores custom user text and tracks the last revision timestamp.
* **Attributes:**
  - `id`: `NoteId` (UUID v4) — Immutable.
  - `transactionId`: `TransactionId` (UUID v4) — Back-reference to the parent transaction.
  - `noteText`: `String` — Detailed annotation string.
  - `editedAt`: `DateTime` — Chronological date of the last modification.
* **Identity:** Unique `id` (UUID v4).
* **Lifecycle:** Created $\rightarrow$ Edited $\rightarrow$ Deleted.
* **Relationships:**
  - One-to-One relationship with `Transaction`. Owned entirely by the `TransactionAggregate`.
* **Constraints:**
  - `transactionId` must map to an active, existing `Transaction` entity.
* **Business Rules:**
  - A note cannot exist without a parent transaction.
  - Modifying the text of a note updates the `editedAt` timestamp.
* **Validation Rules:**
  - `noteText` size is capped at 1000 characters to prevent database bloating.
* **Possible Future Extensions:**
  - Automatic keyword parsing from notes to suggest tag creation.

---

### 6. Tag Entity
* **Purpose:** Represents custom hashtag labels used to create cross-category search clusters (e.g., `#vacation2023`, `#reimbursable`).
* **Responsibilities:**
  - Stores label text.
* **Attributes:**
  - `id`: `TagId` (UUID v4) — Immutable.
  - `labelText`: `String` — Hashtag text (without spaces, e.g., "reimbursable").
  - `createdAt`: `DateTime` — Creation timestamp.
* **Identity:** Unique `id` (UUID v4). Unique index on `labelText`.
* **Lifecycle:** Created $\rightarrow$ Associated $\rightarrow$ Disassociated $\rightarrow$ Purged.
* **Relationships:**
  - Many-to-Many relationship with `Transaction` records.
* **Constraints:**
  - `labelText` must not contain whitespace, special characters, or uppercase letters.
* **Business Rules:**
  - Deleting a Tag removes all associative links to transactions, but does not modify the transaction records.
  - If a Tag has zero associated transactions left, it remains in the user's tag dictionary until explicitly cleared.
* **Validation Rules:**
  - `labelText` must be between 1 and 20 characters, matching `^[a-z0-9_-]+$`.
* **Possible Future Extensions:**
  - Tag grouping under global campaigns or projects.

---

### 7. DiagnosticLog Entity
* **Purpose:** Captures background software exceptions, unrecognized SMS formats, or parsing failures to support offline debugging.
* **Responsibilities:**
  - Records error logs.
  - Enforces size-limiting policies (log rotation and truncation).
* **Attributes:**
  - `id`: `LogId` (UUID v4) — Immutable.
  - `level`: `LogLevel` (Enum: `INFO`, `WARNING`, `ERROR`, `CRITICAL`).
  - `timestamp`: `DateTime` — Precise execution time of the event.
  - `message`: `String` — PII-scrubbed descriptive log statement.
  - `stackTrace`: `String` (Nullable) — Diagnostic stack traces with stripped numeric identifiers.
* **Identity:** Unique `id` (UUID v4).
* **Lifecycle:** Created $\rightarrow$ Append $\rightarrow$ Rotated/Truncated.
* **Relationships:**
  - Independent system utility, has no direct associations with financial entities.
* **Constraints:**
  - Messages must undergo strict regex scrubbing to remove transaction amounts or card index numbers before persistence.
* **Business Rules:**
  - The diagnostic log table is capped at 10,000 records. New logs automatically trigger the deletion of the oldest logs (FIFO queue logic).
  - Diagnostic logs are stored locally inside the encrypted SQLCipher DB page and decrypted only during direct user export actions.
* **Validation Rules:**
  - Plaintext credit card formats or bank account formats must not exist in `message` or `stackTrace`.
* **Possible Future Extensions:**
  - Local diagnostic analysis panel suggesting fixes for background battery optimizations.

---

### 8. SecurityConfig Entity
* **Purpose:** Encapsulates the user's local access control rules, biometric preferences, and PIN configs.
* **Responsibilities:**
  - Tracks PIN and app lock preferences.
* **Attributes:**
  - `id`: `SecurityConfigId` (UUID v4) — Immutable.
  - `isBiometricEnabled`: `Boolean` — Flag to enable fingerprint/face unlock.
  - `isAppLockEnabled`: `Boolean` — Flag to toggle PIN protection.
  - `appLockTimeoutSeconds`: `Int` — Period of inactivity before key eviction occurs.
  - `failedAttemptsCount`: `Int` — Current count of consecutive incorrect PIN entries.
  - `lockedUntil`: `DateTime` (Nullable) — Timestamp representing PIN lockout duration.
* **Identity:** Singleton entity instance inside the system.
* **Lifecycle:** Created $\rightarrow$ Modified $\rightarrow$ Reset.
* **Relationships:**
  - Direct association with local session states.
* **Constraints:**
  - PIN timeout must be within bounds (30 seconds to 1 hour).
  - Max failed attempts count is 3.
* **Business Rules:**
  - If `failedAttemptsCount` reaches 3, `lockedUntil` is set to exactly 1 minute from the current system time, blocking biometric and PIN input.
  - Changing the PIN configuration requires the current valid PIN.
* **Validation Rules:**
  - Lockout time must reflect UTC standard timezone.
* **Possible Future Extensions:**
  - Safe duress PIN that wipes the database when entered.

---

## 7. Value Objects

Value Objects are immutable domain concepts defined solely by their attributes. They have no identity and are compared based on structural equality.

### Why Value Objects are Immutable:
* **Threading & Safety:** Since BankYar operates off the main UI thread (using background tasks for SMS processing), immutability ensures that values cannot be mutated concurrently, eliminating side effects and race conditions.
* **Representational Completeness:** A monetary amount of "$50" is always "$50". You do not "modify" the "$50" to become "$60"; instead, you instantiate a new, distinct value object representing "$60".

### Why Value Objects are Not Entities:
* They have no persistent life-history or identity that needs tracking.
* If two Value Objects share identical attributes, they are completely interchangeable.

---

### 1. MonetaryAmount
* **Concept:** Combines a numeric value with its specific currency type to enforce mathematical safety.
* **Attributes:**
  - `value`: `BigDecimal` — Absolute value.
  - `currency`: `String` — Standard ISO 4217 Currency Code (e.g., "USD", "EUR").
* **Structural Equality:** Two `MonetaryAmount` instances are equal if and only if:
  $$\text{Amount}_{1}.\text{value} = \text{Amount}_{2}.\text{value} \quad \land \quad \text{Amount}_{1}.\text{currency} = \text{Amount}_{2}.\text{currency}$$
* **Domain Validation Rules:**
  - `value` must be greater than or equal to zero.
  - `currency` must consist of exactly three uppercase alphabetic characters matching standard ISO lists.

---

### 2. TransactionType
* **Concept:** Clarifies the direction of cash flow (incoming vs. outgoing).
* **Attributes:**
  - `code`: `String` (Restricted to `"DEBIT"` or `"CREDIT"`).
* **Structural Equality:** Equality is evaluated against the code string representation.
* **Domain Validation Rules:**
  - Must reject any values outside the defined set.

---

### 3. ConfidenceScore
* **Concept:** Represents the statistical reliability of the parser output.
* **Attributes:**
  - `score`: `Double` — Numeric metric between 0.0 and 1.0.
  - `classificationMethod`: `String` (e.g., `"DETERMINISTIC"`, `"HEURISTIC"`, `"MANUAL"`).
* **Structural Equality:** Evaluated on score matching and matching methodology.
* **Domain Validation Rules:**
  - `score` must satisfy: $0.0 \le \text{score} \le 1.0$.
  - If `classificationMethod` is `"DETERMINISTIC"` or `"MANUAL"`, `score` must equal `1.0`.

---

### 4. CardIdentifier
* **Concept:** Identifies the bank account or credit card associated with a transaction without capturing full credentials.
* **Attributes:**
  - `value`: `String` — Obfuscated masking string (e.g., `"Ending in 1234"`, `"Card **** 9876"`).
* **Structural Equality:** Direct case-sensitive string matching.
* **Domain Validation Rules:**
  - String size must not exceed 20 characters to prevent credential storage risks.

---

### 5. Merchant
* **Concept:** Standardizes and cleans commercial counterparty names extracted from raw text.
* **Attributes:**
  - `rawName`: `String` — Unmodified string extracted from SMS (e.g., `"MERCH-X-INC-S-CO"`).
  - `normalizedName`: `String` — Cleaned, human-readable name resolved via local lookup patterns (e.g., `"Merchant X"`).
* **Structural Equality:** Checked against both raw and normalized values.
* **Domain Validation Rules:**
  - `rawName` must not be empty.

---

### 6. SecurePin
* **Concept:** Represents a password-derived key or secure access PIN.
* **Attributes:**
  - `hashedValue`: `String` — Salted PBKDF2 hash of the PIN.
  - `salt`: `String` — Unique random salt value.
* **Structural Equality:** Evaluated via cryptographic equivalence.
* **Domain Validation Rules:**
  - Hash must match the designated SHA-256 string output size.

---

### 7. BackupMetadata
* **Concept:** Standardizes verification headers for local backup files.
* **Attributes:**
  - `schemaVersion`: `Int` — Database schema version at export.
  - `fileHash`: `String` — SHA-256 hash of the payload to verify integrity.
  - `exportedAt`: `DateTime` — Timestamp of export execution.
  - `pbkdf2Salt`: `String` — Salt used for backup decryption.
* **Structural Equality:** Checked on hash alignment.
* **Domain Validation Rules:**
  - `schemaVersion` must be a positive integer matching active or legacy migrations.

---

## 8. Aggregates

An **Aggregate** is a cluster of associated Domain Entities and Value Objects that are treated as a single transactional unit. It enforces consistency and business rules across all contained items.

```
       +-------------------------------------------------------------------+
       |                       AGGREGATE BOUNDARIES                        |
       +-------------------------------------------------------------------+
       |                                                                   |
       |  [ SMSAggregate ]                                                 |
       |    SmsEntity (Root)                                               |
       |                                                                   |
       |  [ ParserTemplateAggregate ]                                      |
       |    ParserTemplateEntity (Root)                                    |
       |                                                                   |
       |  [ TransactionAggregate ]                                         |
       |    TransactionEntity (Root)                                       |
       |      < NoteEntity > (Contained)                                   |
       |      < MonetaryAmount > (Value Object)                            |
       |      < Merchant > (Value Object)                                  |
       |                                                                   |
       |  [ CategoryAggregate ]                                            |
       |    CategoryEntity (Root)                                          |
       |                                                                   |
       |  [ DiagnosticLogAggregate ]                                       |
       |    DiagnosticLogEntity (Root)                                     |
       |                                                                   |
       +-------------------------------------------------------------------+
```

### 1. SMSAggregate
* **Root Entity:** `SMS`
* **Contents:** `SMS` Entity, `SmsIngestionStatus` (Enum).
* **Consistency Boundaries:** Evaluated during ingestion. Once hashed and verified, the SMS content and status remain immutable inside this aggregate boundary.
* **Transactional Boundaries:** Every received SMS broadcast corresponds to a single, isolated database transaction to persist the `SMSAggregate`.

### 2. ParserTemplateAggregate
* **Root Entity:** `ParserTemplate`
* **Contents:** `ParserTemplate` Entity, `Regex` configurations.
* **Consistency Boundaries:** Ensures that any regex updates compile successfully before saving.
* **Transactional Boundaries:** Updates to a template are fully committed before being used to parse incoming SMS queues.

### 3. TransactionAggregate
* **Root Entity:** `Transaction`
* **Contents:** `Transaction` Entity, `Note` Entity, `MonetaryAmount` Value Object, `Merchant` Value Object, `ConfidenceScore` Value Object, `CardIdentifier` Value Object.
* **Consistency Boundaries:**
  - A `Note` cannot exist without its parent `Transaction`.
  - Adding, modifying, or deleting annotations must be orchestrated through the parent `Transaction` aggregate root.
* **Transactional Boundaries:** Creating a transaction, saving its note, and updating its category reference occur inside a single ACID database transaction.

### 4. CategoryAggregate
* **Root Entity:** `Category`
* **Contents:** `Category` Entity.
* **Consistency Boundaries:** Ensures Category names remain unique across the user's workspace.
* **Transactional Boundaries:** Creating or deleting a category is performed as an isolated database transaction.

### 5. DiagnosticLogAggregate
* **Root Entity:** `DiagnosticLog`
* **Contents:** `DiagnosticLog` Entity, `LogLevel` Enum.
* **Consistency Boundaries:** Imposes strict length limit checks and PII scrubbing before saving to disk.
* **Transactional Boundaries:** Log insertions execute off-thread to avoid blocking main application operations.

---

## 9. Aggregate Roots

All external access to entities inside an Aggregate is restricted strictly to the **Aggregate Root**. Outer layers must never reference contained entities directly; instead, they must interact with the Aggregate Root.

| Aggregate Root | Responsibilities | Access Control Interface |
| :--- | :--- | :--- |
| **`SMS`** | Validates ingestion payload, computes hash, handles state transitions. | `SmsRegistryRepository` |
| **`ParserTemplate`** | Validates matching regex, maps token indices. | `TemplateRepository` |
| **`Transaction`** | Instantiates note entities, binds custom tags, sets category references, validates amounts. | `TransactionRepository` |
| **`Category`** | Prevents deletion of system default categories. | `CategoryRepository` |
| **`DiagnosticLog`** | Enforces FIFO size cap, performs PII scrubbing. | `LogRepository` |

### Ownership Rules:
* Outside objects can only hold a reference to the ID of the Aggregate Root, not to contained entities.
* For example, the `Note` entity's lifecycle is managed entirely by the `Transaction` Aggregate Root. You cannot query or instantiate a `Note` without going through its parent `Transaction`.

---

## 10. Domain Services

**Domain Services** implement business logic that involves multiple aggregates or does not naturally belong inside a single entity or value object.

### 1. SMSRoutingService
* **Business Purpose:** Coordinates the multi-step parsing pipeline for incoming SMS messages.
* **Responsibilities:**
  - Receives incoming SMS events from the system gateway.
  - Queries active templates to find matching regex rules.
  - Matches SMS text using deterministic logic; if unmatched, routes the text to the heuristic fallback engine.
  - Computes the final `ConfidenceScore`.
  - Publishes `TransactionParsed` or `ParserFailed` events.

### 2. DeduplicationService
* **Business Purpose:** Guarantees that duplicate cellular broadcasts do not create duplicate transactions.
* **Responsibilities:**
  - Computes the SHA-256 deduplication hash from SMS parameters.
  - Queries the SMS registry to check for existing hashes.
  - Rejects duplicates, logging them as `IGNORED` to prevent duplicate transaction entries.

### 3. BackupCryptographyService
* **Business Purpose:** Securely encrypts and decrypts exported financial backups completely offline.
* **Responsibilities:**
  - Derives an AES-256 key from a user-supplied password using PBKDF2 with HMAC-SHA256 and a random salt.
  - Encrypts the serialized JSON transaction payload using AES-256-GCM.
  - Decrypts and verifies the integrity of imported backup files before starting the restore database override process.

### 4. AnonymizationService
* **Business Purpose:** Scrubs personally identifiable information (PII) from software diagnostics to maintain strict privacy.
* **Responsibilities:**
  - Evaluates stack traces and error messages.
  - Replaces numeric sequences with `[REDACTED_NUM]` and scrubs merchant names or card ending indexes.

---

## 11. Domain Events

Domain Events represent important business occurrences within the domain. They are immutable, include a precise timestamp, and are used to decouple bounded contexts.

| Event Name | Triggering Source | Domain Payload | Business Value |
| :--- | :--- | :--- | :--- |
| **`SMSReceived`** | OS SMS Interceptor | `SmsId`, `rawText`, `senderId`, `receivedAt` | Signals that a raw SMS has entered the ingestion pipeline. |
| **`BankDetected`** | Ingestion Matcher | `SmsId`, `senderId`, `bankName` | Confirms that an SMS sender ID matches a known financial institution. |
| **`TransactionParsed`** | `SMSRoutingService` | `TransactionId`, `amount`, `type`, `merchant`, `timestamp`, `sourceSmsId` | Signals that financial metadata has been successfully extracted. |
| **`TransactionStored`** | Ledger Registry | `TransactionId`, `timestamp`, `amount` | Confirms that a transaction has been saved to the encrypted ledger. |
| **`NoteCreated`** | `TransactionAggregate` | `NoteId`, `transactionId`, `timestamp` | Confirms that a note has been added to a transaction. |
| **`NoteUpdated`** | `TransactionAggregate` | `NoteId`, `transactionId`, `timestamp` | Confirms that a note has been modified. |
| **`BackupCreated`** | Backup Service | `exportedAt`, `fileSize`, `fileHash` | Confirms that an encrypted backup file has been successfully generated. |
| **`ParserFailed`** | `SMSRoutingService` | `SmsId`, `senderId`, `rawText` | Signals that deterministic and heuristic parsing failed, triggering an unparsed transaction. |
| **`DuplicateDetected`** | `DeduplicationService` | `SmsId`, `duplicateHash` | Confirms that a duplicate SMS was detected and dropped. |
| **`PermissionGranted`** | OS Permission Handler | `permissionType`, `timestamp` | Records that background SMS permissions have been granted by the user. |
| **`PermissionDenied`** | OS Permission Handler | `permissionType`, `timestamp` | Records that background SMS permissions have been denied, prompting fallback UI guides. |

---

## 12. Domain Rules

Domain Rules govern the core business logic of the application and must remain consistent across all implementations.

1. **Duplicate SMS Prevention:**
   - *Duplicate SMS must never create duplicate transactions.* A SHA-256 hash must be computed and verified before parsing occurs.
2. **Deterministic Bank Association:**
   - *Every transaction belongs to exactly one bank or financial institution.* Transactions generated from SMS inherit the bank reference from the sender ID template.
3. **Strict Note Ownership:**
   - *Every note belongs to exactly one transaction.* Notes have a strict One-to-One lifetime mapping bound to their parent transaction.
4. **Decoupled SMS Deletion:**
   - *Deleting a transaction must never delete the original source SMS.* The raw SMS record is preserved in the database to maintain audit records.
5. **Enforced Parsing Confidence:**
   - *Every parser result must have a confidence score.* The confidence score must be stored as a Value Object alongside the transaction.
6. **Safe Backup Restoration:**
   - *Every imported backup must be verified before restore.* The import service must verify the schema version, metadata hash, and decryption password before replacing the local database.

---

## 13. Domain Invariants

Domain Invariants are business assertions that must remain true at all times to maintain data integrity.

* **Non-Negative Amounts:**
  - **Invariant:** A transaction's amount must always be a positive value greater than zero.
  - **Formula:** $\forall \, t \in \text{Transactions}, \quad t.\text{amount}.\text{value} > 0.0$
* **Valid Transaction Timestamp:**
  - **Invariant:** The transaction's timestamp must not be in the future.
  - **Formula:** $t.\text{timestamp} \le \text{CurrentTime}()$
* **Unique Active Category Names:**
  - **Invariant:** Custom category names must be unique (case-insensitive) across the user's workspace.
  - **Formula:** $C_{i}.\text{name} \neq C_{j}.\text{name} \quad \forall \quad i \neq j$
* **No Uncapped Logs:**
  - **Invariant:** The total size of local diagnostic logs must never exceed 10,000 records.
  - **Formula:** $\text{Count}(\text{DiagnosticLogs}) \le 10,000$
* **Locked-Out Grace Period:**
  - **Invariant:** A user locked out due to failed PIN attempts cannot authorize biometric scans or PIN inputs until the lockout period has expired.
  - **Formula:** $\text{CurrentTime}() < \text{SecurityConfig}.\text{lockedUntil} \implies \text{SessionState} = \text{LOCKED}$

---

## 14. Entity Relationships

This table specifies the relationships and multiplicity rules between core domain entities, including how cascades and changes are handled.

| Entity A | Entity B | Multiplicity | Relationship Description | Cascade Rule |
| :--- | :--- | :--- | :--- | :--- |
| **`Transaction`** | `Note` | `1 : 0..1` | A Transaction can optionally contain a single note. | **Cascade Delete:** Deleting the Transaction deletes the note. |
| **`Transaction`** | `Category` | `* : 1` | Multiple Transactions can map to a Category. | **Nullify / Default:** Deleting a Category updates Transactions to "Uncategorized". |
| **`Transaction`** | `SMS` | `0..1 : 1` | A Transaction can be generated from an SMS. | **No Action:** Deleting a Transaction does not delete the original SMS. |
| **`Transaction`** | `Tag` | `* : *` | Transactions and Tags share a Many-to-Many relationship. | **Dissociate:** Deleting a Transaction removes the relationship link, leaving the Tag intact. |
| **`SMS`** | `ParserTemplate` | `* : 0..1` | An SMS is parsed using a ParserTemplate matching its Sender ID. | **No Action:** Deleting a Template does not affect already-parsed SMS records. |

---

## 15. Lifecycle of each Entity

### 1. SMS Lifecycle
```
[ Telephony Broadcast ]
         │
         ▼
     ( RAW ) ──────► Deduplication Check
         │                      │
         │ Unique               │ Duplicate Match
         ▼                      ▼
  ( UNPARSED )             ( IGNORED ) ──► [ Erased / Dropped ]
         │
         ├──────────────────────────────┐
         ▼ Deterministic Match          ▼ Fallback Heuristics
     ( PARSED )                    ( UNPARSED ) ──► User manual entry fallback
```

### 2. Transaction Lifecycle
```
[ SMS Parsed ] ───┐
                  ├─► ( CREATED )
[ Manual Entry ] ─┘        │
                           ▼
                     ( CATEGORIZED ) ──► Matches Category rules
                           │
                           ▼
                     ( ANNOTATED ) ───► Optional User notes/tags
                           │
                           ▼
                     ( DELETED ) ─────► Purges Notes/Tags; preserves SMS audit
```

### 3. ParserTemplate Lifecycle
```
[ User Input / QR Code ] ──► ( DRAFT )
                                │
                                ▼ Compiled & verified
                             ( ACTIVE ) ◄──► [ Modifying regex rules ]
                                │
                                ▼ Explicit deprecation
                            ( INACTIVE )
```

---

## 16. Ownership Rules

Ownership rules define which aggregates control the lifecycle and data modifications of related entities.

* **Transaction Owns Annotations:**
  - The `Transaction` aggregate root owns the `Note` entity and the relational links to `Tag` entities.
  - Direct modifications to a note must go through the parent `Transaction` aggregate root (e.g., `transaction.updateNoteText("Groceries at Store X")`).
* **Category Autonomy:**
  - `Category` entities are independent aggregates and are not owned by Transactions.
  - Deleting a category updates all associated transactions back to "Uncategorized" but does not affect the transaction's other attributes or notes.
* **SMS Independence:**
  - The `SMS` aggregate is an immutable audit log of incoming text notifications.
  - It exists independently of the transaction ledger. If a user deletes a transaction, its source SMS is preserved, ensuring raw logs are kept intact.

---

## 17. Validation Rules

To prevent data corruption, validation rules are enforced at the domain boundary before any state change occurs.

### 1. Monetary Figures
* The transaction amount must be positive and non-zero:
  $$\text{Amount} > 0.00$$
* High precision must be preserved up to 4 decimal places.

### 2. ISO Currency Compliance
* The currency string must consist of exactly three uppercase alphabetic characters matching standard ISO 4217 Currency Codes:
  $$\text{Currency} \in \{ \text{"USD"}, \text{"EUR"}, \text{"IRR"}, \text{"CAD"}, \dots \}$$

### 3. Hexadecimal Color Representation
* Custom category colors must be represented as valid 6-character hexadecimal hex color values:
  $$\text{ColorHex} \text{ matches } \text{`^#[0-9A-F]{6}$`}$$

### 4. Template Compilation Verification
* The regular expression of a `ParserTemplate` must compile successfully.
* The matching capture indices (`amountGroupIndex`, `merchantGroupIndex`, etc.) must not exceed the number of capture groups defined in the regular expression.

---

## 18. Identity Rules

Every entity in the domain must have a clear identity rule defining how it is uniquely identified and how equality is determined.

* **UUID v4 (Globally Unique Domain IDs):**
  - All domain aggregates (`Transaction`, `ParserTemplate`, `Category`, `Note`, `Tag`) generate a cryptographically secure, random **UUID v4** identifier on instantiation.
  - Entity equality is determined strictly by comparing this UUID, regardless of other attributes:
    $$\text{Entity}_{1} = \text{Entity}_{2} \iff \text{Entity}_{1}.\text{id} = \text{Entity}_{2}.\text{id}$$
* **Natural Deduplication Hash (SMS Identity):**
  - The `SMS` entity generates a SHA-256 hash derived from its natural unique attributes:
    $$\text{Hash} = \text{SHA-256}(\text{senderId} + \text{rawText} + \text{receivedAt})$$
  - This hash acts as the natural key used to identify and drop duplicate messages before parsing occurs.

---

## 19. Future Extension Points

The BankYar domain model is architected to support future capabilities without requiring a redesign of core components.

1. **Notification Listener Integration:**
   - The ingestion boundary is abstracted as an input string stream. This allows the application to capture financial notifications from digital banking apps (using push notifications instead of SMS) by feeding notification titles and body texts into the existing parsing engine.
2. **On-Device Machine Learning (Heuristics Upgrade):**
   - The statistical heuristic parsing fallback can be upgraded to use a lightweight on-device tokenizer (e.g., Naive Bayes or TensorFlow Lite BERT-mini) to extract transaction attributes from complex, unstructured messages with higher accuracy.
3. **P2P Local Synchronization:**
   - Users can sync their local transactions with a home NAS or private computer over a local Wi-Fi connection. The `Backup & Portability Context` is designed with platform-independent JSON/CSV schemas to facilitate seamless synchronization without a central cloud server.
4. **Community QR Code Matching Rules:**
   - Users can share custom regex templates for unrecognized banks by generating a signed QR code. Scanning the QR code decodes the template JSON and adds it directly to the local rules table, bypassing the need for app updates.

---

## 20. Domain Risks

Operating 100% offline with zero network access introduces specific domain-level risks that must be addressed:

* **Background Service Termination (TR-01):**
  - *Risk:* Aggressive operating system power management (such as customized Android battery optimization) may terminate background SMS listeners.
  - *Mitigation:* The domain includes background diagnostic status tracking and in-app guides to help users whitelist the app from battery restrictions.
* **Keystore Key Loss (TR-02):**
  - *Risk:* Operating system resets or security updates may erase hardware-backed keys, making the local database unreadable.
  - *Mitigation:* The domain includes a password-protected local backup strategy using `AES-256-GCM` with keys derived via `PBKDF2`, allowing users to restore their data even if hardware-backed keys are lost.
* **SMS Deprecation (TR-03):**
  - *Risk:* Financial institutions transitioning away from SMS alerts to proprietary in-app push notifications.
  - *Mitigation:* The parsing engine is designed to process abstract text inputs, preparing the system to support notification interception in future releases.

---

## 21. Domain Assumptions

The domain model is built on several key assumptions:

1. **Availability of Local Cryptographic Providers:**
   - It is assumed that the host device provides a secure, hardware-backed cryptographic key storage system (e.g., Android Keystore, iOS Secure Enclave) to secure the master database key.
2. **Consistency of Carrier SMS Metadata:**
   - It is assumed that banking SMS messages contain consistent carrier metadata (such as reliable sender IDs like "CHASE" or "BOFA") to support template routing.
3. **Persistence of Local Filesystem Storage:**
   - It is assumed that the local operating system provides persistent, sandboxed filesystem storage that is not cleared during routine system maintenance.

---

## 22. Business Constraints

The domain model operates under several strict business constraints to protect user privacy and ensure reliability:

* **Strict Zero-Network Rule (NFR-1.1):**
  - The application must not declare or utilize any network permissions. All operations, parsing, analysis, and backups must run completely offline on the user's device.
* **No External Telemetry or Crash Reporting (NFR-1.3):**
  - The app must not include third-party crash reporting or analytics SDKs (e.g., Firebase Analytics, Crashlytics). All diagnostic logs must be kept locally on the device.
* **On-Device Security Guard (NFR-1.4):**
  - The app must utilize operating system flags to blur sensitive transaction lists in the task switcher preview and prevent local screen captures or recordings.
* **Minimum Performance Latency (NFR-2.1):**
  - Background SMS parsing must complete in less than 200 milliseconds, and the entire database write pipeline must complete in less than 100 milliseconds, keeping total end-to-end processing latency under 300 milliseconds.

---

## 23. Domain Glossary

An alphabetical list of key business terms used within the BankYar domain:

* **Aggregate:** A cluster of associated domain objects that are treated as a single transactional unit to enforce consistency.
* **Aggregate Root:** The gateway entity of an aggregate that controls all external access and modifications to contained objects.
* **Annotation:** User-supplied metadata consisting of custom notes and searchable tags appended to a transaction record.
* **App Lock:** A local security screen that requires biometric or PIN authentication before granting access to the application UI.
* **Auto-Rule:** A user-defined trigger that automatically categorizes incoming transactions based on text-matching patterns.
* **Bounded Context:** A distinct boundary within which a specific domain model applies and remains consistent.
* **Category:** A custom organization label used to group expenses and incomes for cash flow reporting.
* **Confidence Score:** A value representing the statistical certainty of a parsed transaction's metadata.
* **Core Domain:** The primary business focus and intellectual property of the application (e.g., offline banking SMS parsing).
* **Deduplication Hash:** A SHA-256 signature calculated from raw SMS text and metadata to prevent duplicate transaction entries.
* **Deterministic Matching:** Using compiled regular expression templates to extract transaction details with high certainty.
* **Diagnostic Log:** A size-capped, local-only record of system events, errors, and unparsed SMS patterns.
* **Domain Event:** An immutable, timestamped record of an important business occurrence within the domain.
* **Domain Invariant:** A business rule or assertion that must remain true at all times.
* **Entity:** A domain object defined by its unique identity that persists across state changes and time.
* **Generic Domain:** Standard software features common to many applications, such as local security and backups.
* **Heuristic Processing:** A statistical pattern-matching fallback used to extract transaction details when no deterministic templates match.
* **Key Eviction:** Automatically purging cryptographic database keys from RAM after a period of user inactivity to protect data.
* **Note:** A custom text annotation appended to a transaction.
* **Parser Template:** A structured configuration containing regular expressions used to parse messages from specific banks.
* **PII Scrubbing:** Automatically removing personal identifiable information (such as amounts or card numbers) from diagnostic logs.
* **Secure PIN:** A salted, hashed PIN code used to control access to the application lock screen.
* **Supporting Domain:** Secondary business features that support the core domain, such as transaction categorization and analytics.
* **Tag:** A custom keyword tag used to filter and search across different transaction categories.
* **Transaction:** A structured record representing a debit or credit event.
* **Ubiquitous Language:** A shared, consistent vocabulary used by all team members to describe domain concepts.
* **Value Object:** An immutable domain object defined solely by its attributes, possessing no identity.
