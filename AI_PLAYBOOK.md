# BankYar Enterprise AI Development Playbook & Prompt Engineering Standard

**Document Status:** Official & Enforced
**Governance Authority:** Level 0 (Highest Operational Authority)
**Applicability:** Product Architects, Engineering Leaders, Prompt Engineers, Quality Assurance Specialists, and Autonomous AI Agents.
**Core Target:** Governance of AI-assisted Software Engineering in BankYar

---

## Executive Summary
This document establishes the official operational framework, prompt engineering standards, quality assurance gates, and risk management systems governing all Artificial Intelligence-assisted development across the entire BankYar software development lifecycle.

BankYar is an offline-first, privacy-first, and security-first personal finance application natively built with Flutter, targeting mobile platforms with a primary focus on Android. Under strict zero-network constraints, all data must be retained locally on the device with zero cloud dependency. Due to these uncompromising quality, security, and privacy boundaries, the engineering lifecycle uses AI models not as passive text-generation tools, but as active, governed, and highly structured execution agents.

This Playbook ensures that all stochastic AI outputs are subject to deterministic verification. It establishes a multi-tier collaborative engineering matrix, standardizes the construction and lifecycle of prompt templates, defines sixteen quality gates for code and documentation generation, and details strict protocols to detect and eliminate AI-generated hallucinations. This document serves as the authoritative, implementation-independent, and future-proof operational mandate for human-AI interaction within BankYar.

---

## Section I: AI Governance Architecture & Philosophy

```
  +-----------------------------------------------------------------+
  |                BANKYAR AI GOVERNANCE SYSTEM                     |
  +-----------------------------------------------------------------+
  |  Stochastic AI Models <---> Deterministic Quality Checkpoints   |
  +---------------------------------+-------------------------------+
                                    |
            +-----------------------v-----------------------+
            |  1. Philosophy & Human-in-the-Loop Governance |
            |  2. Multi-Model Collaboration Pipeline       |
            |  3. Zero-Trust Output Verification            |
            +-----------------------------------------------+
```

### 1. AI Development Philosophy
The AI Development Philosophy of BankYar rejects both unguided AI autonomy and passive, unstructured AI assistance. Instead, it positions Artificial Intelligence as a first-class engineer that operates under continuous human-in-the-loop governance. Stochastic large language models possess unprecedented capability for structural composition, reasoning, and synthesis, but are prone to drift, regression, and hallucination. To capture their velocity while maintaining absolute correctness, BankYar treats all AI interactions as mathematically bounded transactions where outputs must be validated through deterministic quality gates prior to integration.

### 2. AI-First Engineering Principles
The engineering lifecycle is designed from the ground up to optimize human-AI synergy through six foundational principles:
* **The Single Source of Context Principle:** AI models must always be provided with minimal, highly curated, and precise file sets rather than the entire codebase. This keeps token density high and prevents context degradation.
* **Separation of Architectural Layers:** All generations must preserve the rigid isolation of Presentation, Domain, and Data layers. Domain logic must remain written in pure, platform-independent Dart without framework or UI package dependencies.
* **Declarative and Token-Driven UI:** User interfaces generated with AI assistance must remain completely visual and layout-focused, utilizing design tokens exclusively instead of hardcoded colors, typography, or spatial spacing units.
* **Inherent Testability:** AI-generated components must be isolated and mockable. If a component cannot be thoroughly verified with a unit test, its architecture must be rejected and refactored.
* **Absolute Offline-First Constraint:** No AI output can suggest, introduce, or configure remote network dependencies, external API hooks, or cloud-based telemetry.
* **Deterministic Verification:** Every code modification or text asset must pass automated syntax, static analysis, formatting, and unit tests before human code review.

### 3. Human-AI Collaboration Model
The collaboration model utilizes a balanced "Pilot-Navigator" relationship. The AI acts as the "Pilot" responsible for localized implementation, scaffolding, formatting, and drafting tests based on clear, high-density prompts. The human engineer acts as the "Navigator" and "Governor" responsible for high-level system architectural planning, verifying input context, reviewing and validating generated outputs, and enforcing security and design rules. No AI-generated code or architecture is permitted to bypass human validation.

### 4. AI Responsibility Matrix
Different cognitive models and specialized agents are routed to specific tasks within the development lifecycle based on their natural strengths:

| Model Persona / Agent Role | Core Strength | Dedicated Task Responsibility |
| :--- | :--- | :--- |
| **Architect Agent** | Abstract synthesis, cross-module relationships, database schema layout. | High-level architectural planning, story decomposition, data flow diagrams. |
| **Context Analyst** | High-density context ingestion, long-context tracing, cross-file change analysis. | Codebase auditing, refactoring large modules, multi-file bug investigation. |
| **Code Executor** | Low-latency syntax completion, precise search-and-replace, style rules. | Localized code writing, formatting compliance, DTO and serialization helpers. |
| **Auditor Agent** | Static code analysis, test generation, compliance auditing. | Unit and integration test drafting, validation checklist verification, security reviews. |

### 5. AI Capability Boundaries
AI models are subject to hard operational limits to prevent system degeneration:
* **No Unilateral Architecture Decisions:** The AI has zero authority to alter base architectural paradigms, change database engines, or alter the State Management architecture.
* **Maximum Output Volumes:** Code generation outputs are limited to a maximum of 300 lines of code per interaction to maintain readability and simplify verification.
* **Strict Library Bounds:** The AI must only use packages and dependencies explicitly defined within the current project configuration. It cannot introduce new third-party packages.

### 6. AI Usage Policy
All developers and automated systems must comply with the following usage policies:
* **Approved Context Transmission:** Developers must never upload or pass sensitive user financial data, decrypted keys, or plain-text database credentials to external LLMs.
* **Versioned Interaction:** All structural prompts, validators, and templates must be saved in the repository version control system.
* **Audit Trail Preservation:** Complete records of high-level AI-assisted code generations and reviews must be traceable through git commit tags.

---

## Section II: Prompt Engineering Standards

```
  +-----------------------------------------------------------------+
  |                  PROMPT ENGINEERING SYSTEM                      |
  +-----------------------------------------------------------------+
  |  7. Prompt Engineering Principles                                |
  |  8. Prompt Structure Standard                                   |
  |  9. Prompt Naming Convention                                    |
  | 10. Prompt Versioning Strategy                                  |
  | 11. Prompt Documentation Standard                               |
  | 12. Prompt Review Process & 13. Prompt Approval Workflow        |
  | 14. Prompt Lifecycle & 15. Prompt Repository Organization       |
  | 16. Prompt Metadata Standard & 17. Prompt Quality Metrics       |
  | 18. Prompt Validation Rules & 19. Prompt Testing Strategy       |
  | 20. Prompt Regression Testing                                   |
  +-----------------------------------------------------------------+
```

### 7. Prompt Engineering Principles
To ensure stochastic models yield deterministic outputs, prompt construction must adhere to the following principles:
* **High-Density Domain Specification:** Prompts must explicitly specify the domain constraints, the exact files under test, and reference the active coding standards.
* **Deterministic Constraints:** Every prompt must include a "Do Not" section stating clear boundaries (e.g., no hardcoded values, no direct database calls from UI).
* **Self-Contained Executability:** A prompt must contain all necessary context, types, and expected inputs to allow the AI to generate the complete artifact without requiring iterative questions.
* **Separation of Instructions and Context:** System roles, task instructions, and project context must remain isolated inside designated sections of the prompt block.

### 8. Prompt Structure Standard
Every prompt template within the BankYar ecosystem must adhere to the following mandatory layout:

```markdown
# 1. ROLE & DOMAIN SPECIFICATION
Define the precise technical role, expertise level, and specialized system knowledge.

# 2. MISSION
The high-level intent, ultimate purpose, and overall value of the generation.

# 3. PROJECT CONTEXT
A high-density description of the BankYar application, architecture, and current modules.

# 4. CURRENT PHASE
The active development milestone (e.g., Core Storage Implementation, Offline Analytical Modeling).

# 5. OBJECTIVES
Numbered, highly actionable goals to be achieved by the generation.

# 6. CONSTRAINTS
Strict technological, architectural, security, and performance constraints.

# 7. INPUTS
Explicit parameters, input data, schema mappings, or configuration values.

# 8. DEPENDENCIES
Required classes, components, repositories, or packages that must be imported or used.

# 9. DELIVERABLES
The exact set of assets, documentation, or classes expected from the output.

# 10. ACCEPTANCE CRITERIA
Measurable, binary tests that the generated output must satisfy to be accepted.

# 11. OUTPUT FORMAT
The precise structure of the output (e.g., pure Dart code wrapped in single codeblocks).

# 12. VALIDATION CHECKLIST
A self-review checklist the AI must run and output along with the code to verify compliance.

# 13. SUCCESS CRITERIA
High-level quality indicators (e.g., zero linter warnings, zero compiler warnings).

# 14. DO NOT
Explicitly forbidden behaviors, imports, libraries, visual units, or patterns.

# 15. ASSUMPTIONS
Key architectural and execution-environment assumptions.

# 16. REFERENCES
Links or file paths to relevant documentation, system files, or architectural specifications.

# 17. VERSION METADATA
Prompt schema version, unique identifier, and date of last review.
```

### 9. Prompt Naming Convention
Prompt template files must follow a strict dot-separated, hierarchical lowercase naming convention:

`[domain].[layer].[target_artifact].[type].md`

* **Domain:** e.g., `core`, `features`, `security`, `analytics`, `database`, `testing`
* **Layer:** e.g., `data`, `domain`, `presentation`, `architecture`, `config`
* **Target Artifact:** e.g., `entity`, `dto`, `usecase`, `repository`, `widget`, `screen`, `test`, `mapper`, `migration`, `regex`
* **Type:** e.g., `scaffold`, `implementation`, `review`, `audit`, `refactor`

*Example:* `features.data.dto.scaffold.md`

### 10. Prompt Versioning Strategy
Prompts are treated as code assets and must implement SemVer 2.0.0.
* **Major Version Increments:** Triggered when the underlying architectural patterns change, when mandatory prompt blocks are added/removed, or when breaking API dependencies are introduced.
* **Minor Version Increments:** Triggered when additional instructions or non-breaking constraints are added to refine model accuracy.
* **Patch Version Increments:** Triggered when typos, documentation strings, or contextual references are updated.

### 11. Prompt Documentation Standard
Every prompt template must contain front-matter documentation containing:
* **Title:** Concise descriptive name.
* **Scope:** The exact scenario or task where this prompt is applicable.
* **Target Models:** List of verified LLMs that achieve optimal pass-rates with this prompt.
* **Changelog:** Detailed history of version updates and reasoning.

### 12. Prompt Review Process
All prompt modifications must undergo a formal peer review process similar to codebase pull requests. Prompt changes must be audited for:
* **Adherence to Structure:** Confirms all mandatory prompt blocks are present.
* **Constraint Correctness:** Verifies that no forbidden patterns are introduced or bypassed.
* **Model Portability:** Confirms the instructions remain clear and effective across multiple foundation models without vendor lock-in.

### 13. Prompt Approval Workflow
* **Submission:** A contributor submits a Prompt Pull Request modifying a template in the `tools/prompts/` directory.
* **CI Validation:** Automated scripts verify prompt files for forbidden markers and structural headings.
* **Guild Approval:** Merging requires explicit approval from the Prompt Engineering Lead and the Lead QA Engineer.

### 14. Prompt Lifecycle
The life cycle of a prompt consists of six distinct operational phases:
1. **Drafting:** Initial compilation of prompt instructions and objectives.
2. **Testing:** Execution against target models in isolated sandbox files.
3. **Approved:** Merged into the active repository branch and ready for production use.
4. **Active:** Currently utilized by the engineering pipeline to generate production code.
5. **Deprecated:** Marked for future removal due to library upgrades or pattern updates.
6. **Archived:** Safely removed from active directories and stored in history logs.

### 15. Prompt Repository Organization
Prompt templates must reside in a structured hierarchy under the project root:

```
tools/prompts/
  ├── architecture/
  │   └── architecture.definition.blueprint.md
  ├── data/
  │   ├── data.model.scaffold.md
  │   └── data.repository.implementation.md
  ├── domain/
  │   ├── domain.entity.scaffold.md
  │   └── domain.usecase.implementation.md
  ├── presentation/
  │   ├── presentation.widget.scaffold.md
  │   └── presentation.screen.implementation.md
  ├── qa/
  │   ├── qa.unit_test.generation.md
  │   └── qa.security.audit.md
  └── prompt_registry.json
```

### 16. Prompt Metadata Standard
Every prompt must register its parameters, model compatibility indices, and ownership in `tools/prompts/prompt_registry.json` to enable searchability and automation parsing:

```json
{
  "prompt_id": "features.domain.usecase.implementation",
  "version": "1.2.0",
  "owner": "Prompt Engineering Lead",
  "target_layer": "Domain",
  "compatible_models": ["model-agnostic", "tier-1-reasoner", "tier-2-executor"],
  "last_reviewed": "2026-10-30"
}
```

### 17. Prompt Quality Metrics
Prompt performance is continuously evaluated across three key operational metrics:
* **First-Turn Compile Rate:** The percentage of generated code files that compile on the first turn without human editing.
* **Quality Gate Pass Rate:** The percentage of generated code files that pass all sixteen active Quality Gates on the initial test run.
* **Hallucination Frequency:** The rate at which the model inserts unregistered library methods or speculative feature extensions.

### 18. Prompt Validation Rules
A prompt template is invalid if any of the following occur:
* **Unresolved Markers:** Presence of raw custom markers or brackets.
* **Code Contradiction:** Instructions that prompt the model to bypass architectural layers or ignore dependency injection rules.
* **Platform Leakage:** Prompting the model to write platform-specific code (e.g., Kotlin, Swift) inside Dart shared directories.

### 19. Prompt Testing Strategy
Before a prompt version is marked as "Approved", it must be tested against a set of synthetic scenarios:
* **The Scaffold Test:** Generates standard structures to verify path alignment and namespace integrity.
* **The Boundary Test:** Exercises the constraints block by deliberately passing invalid or out-of-scope requests to verify if the model correctly halts execution.
* **The Stress Test:** Requests complex logic to verify that output length does not trigger truncation or context decay.

### 20. Prompt Regression Testing
Whenever a foundation model is updated or swapped, a prompt regression run is executed. The entire prompt catalog is ran against a standardized mock environment. The generated outputs are compared via automated lint and unit-test runners to ensure that model behavioral changes have not degraded the execution accuracy of the prompt definitions.

---

## Section III: AI Output Validation & Quality Gates

```
  +-----------------------------------------------------------------+
  |                AI ARTIFACT VALIDATION PIPELINE                  |
  +-----------------------------------------------------------------+
  |  21. AI Output Validation ---> 22. Artifact Review Workflow     |
  +--------------------------------+--------------------------------+
                                   |
            +----------------------v----------------------+
            |  Quality Gates & Specific Generation Rules   |
            |  - Code, Architecture, Docs, Tests, Refactor|
            |  - Security, Privacy, Accessibility Rules   |
            |  - Design System & Coding Standards         |
            +---------------------------------------------+
```

### 21. AI Output Validation
AI output validation is a multi-layered verification framework. No raw output from an AI model is directly merged into the source repository. Every generation must progress through a systematic three-stage pipeline:
1. **Automated Static Validation:** The file is saved in a local scratch workspace where static analyzers, code-linter engines, and validator scripts verify basic compliance.
2. **Behavioral Test Suite Execution:** The scratch workspace executes a custom unit-test environment to ensure the logic passes all functional expectations.
3. **Human Peer Review:** The code, along with self-audit comments from the AI, is presented to a human reviewer for visual layout and architectural verification.

### 22. Artifact Review Workflow
The official workflow for reviewing any generated artifact follows a strict state-machine transition:

```
+-----------+     +---------------+     +---------------+     +---------------+     +-------------+
|  Draft    | --> | Auto-Lint     | --> | Test Run      | --> | Human Auditing| --> | Approved    |
| (Pending) |     | (Static Gate) |     | (Dynamic Gate)|     | (Visual Gate) |     | (Merged)    |
+-----------+     +---------------+     +---------------+     +---------------+     +-------------+
```

If a failure occurs at any point in the workflow, the artifact is rejected, the failure log is passed back to the AI model context, and a correction prompt is executed.

---

### AI Quality Gates
Every generated artifact must satisfy sixteen rigorous checkpoints before being merged into the master branch:

* **Gate 1: Architecture Compliance:** 100% adherence to layer boundaries. The domain layer must be completely free of presentation, database, and system platform imports.
* **Gate 2: Circular Dependency Check:** 0 circular relationships between modules, classes, or files.
* **Gate 3: Naming Standards Compliance:** Perfect matching of prefixes, suffixes, and capitalizations as defined in coding standards.
* **Gate 4: Layer Isolation Check:** Data repositories must implement abstract interfaces declared in the domain layer and must translate raw data models into immutable entities.
* **Gate 5: UI Purity Check:** Zero business calculation, text parsing, or direct state mutation inside widget build methods.
* **Gate 6: Dependency Injection Compliance:** 100% of dependency resolution must go through Riverpod. No service locators or manual instantiation are allowed.
* **Gate 7: Error Safe-Guard Check:** Methods returning domain results must return safe `Result` or `Either` types. Throwing uncaught raw exceptions is strictly forbidden.
* **Gate 8: Logging Privacy Check:** 100% PII scrubbed from logs. No clear-text passwords, card numbers, transaction amounts, or SMS content is allowed in console outputs.
* **Gate 9: Local Security Check:** Absolute reliance on encrypted database instances (e.g., SQLCipher) with secure, hardware-bound master key recovery.
* **Gate 10: Performance Integrity:** Frame rates must remain stable. Build methods must be short and free of layout calculations.
* **Gate 11: Testability Check:** 100% of external adapters, databases, and platform integrations must use mockable contracts.
* **Gate 12: Documentation Completeness:** 100% public API coverage with triple-slash documentation explaining technical invariants and failure modes.
* **Gate 13: DRY (No Duplication) Audit:** Zero duplicated business logic across different vertical feature slices.
* **Gate 14: Dead Code Check:** 0 unused imports, deprecated parameters, or commented-out developer markers.
* **Gate 15: Magic Numbers & Hardcoded Strings Check:** 0 raw coordinates, direct numeric offsets, or hardcoded UI strings. All values must reference design tokens.
* **Gate 16: Constructor-Only DI:** Classes must declare all dependencies within their constructor interface to preserve traceability.

---

### AI Artifact Types & Specific Generation Rules

#### 23. Code Generation Rules
When generating executable code, the AI must strictly produce clean, functional Dart structures:
* **No Inline Mocking:** Actual logic files must not contain testing configurations, fakes, or local mocked values.
* **Immutability by Default:** All properties within data structures, states, and domain models must be declared as `final`.
* **Private Implementations:** Classes must hide internal state and helper functions behind private properties (`_`) unless explicitly required by the public interface contract.

*Specific Artifact Types:*
* **Flutter Code:** Ensure zero direct material design widgets are hardcoded. Instead, compose UI components using the BankYar design system tokens.
* **Dart Models:** DTO structures must exist inside the data layer, handle serialization/deserialization safely, and provide clean mapping functions to pure Domain Entities.
* **Repositories:** Concrete implementations of repositories must exist in the data layer, encapsulate error catching, and translate failures into domain-specific error structures.
* **State Management:** Riverpod notifier classes must handle state transitions deterministically, emitting immutable state models in response to distinct user actions.
* **UI Components:** Interactive visual widgets must have custom constant constructors, stay under 150 lines, and rely entirely on external state and callbacks.

#### 24. Architecture Generation Rules
Architectural blueprints and documents generated by the AI must remain at the high-level system level:
* **Data Flow Trajectories:** Describe how incoming SMS patterns traverse platform channels, data sources, repositories, and use cases, mapping each state transition using text-based ASCII flow diagrams.
* **Dependency Diagrams:** Map clean relationship graphs of feature modules, highlighting dependency boundaries to prevent layer pollution.
* **Database Relational Models:** Detail localized table structures, indices, and encryption zones without hardcoding SQL implementation scripts.

#### 25. Documentation Generation Rules
Documentation generated by AI must follow professional, structured standards:
* **Triple-Slash Format:** Public Dart interfaces must use triple-slash comment structures natively supported by DartDoc.
* **Focus on the "Why":** Document the underlying design decisions, structural invariants, and failure boundaries rather than explaining simple language features.
* **Markdown Formatting:** Support clear, structured files utilizing standard headers and table alignments.

*Specific Artifact Types:*
* **PRDs & Specifications:** Formulate high-density requirement specifications outlining functional bounds, offline interactions, and security requirements.
* **Migration Guides:** Draft step-by-step documentation detailing old-to-new schema mapping and safe data-transfer procedures.
* **Release Notes:** Compile clean changelogs detailing user-facing changes, internal improvements, and resolved risk points.
* **Refactoring Reports:** Summarize complex architectural modifications, outlining dependency impacts and coverage preservation.

#### 26. Test Generation Rules
Automated tests drafted by AI must follow clean, strict verification conventions:
* **Isolate Platform Hooks:** Mock all native platform channels, secure storage elements, and database resources.
* **Deterministic Execution:** Avoid utilizing timers or thread delays. Use mock clock environments to verify time-sensitive logic.
* **Exhaustive Edge Cases:** Include boundary tests, negative verification paths, and bad-input parsing tests.

#### 27. Refactoring Rules
Refactoring operations performed by AI must follow an incremental, safe sequence:
* **Analyze Behavioral Baseline:** Verify that existing tests are executed and pass before any code is modified.
* **Decompose Monolithic Blocks:** Break down classes that exceed 250 lines and methods that exceed 30 lines into small, single-purpose components.
* **Run Regression Suites:** Execute compilation checks and unit tests immediately after every localized modification.

---

### Security, Privacy, and Accessibility Compliance

#### 28. Security Validation Rules
* **No Plaintext Storage:** Verify that no credentials, tokens, passwords, or raw cryptographic keys are written to unencrypted storage caches.
* **Hardware-Bound Cryptography:** All local master keys must utilize platform keystores wrapped inside secure hardware bindings.
* **Secure Memory Lifecycles:** Financial balances and decrypted SMS buffers must be scrubbed from active memory as soon as processing completes.

#### 29. Privacy Validation Rules
* **PII Scrubbing:** All raw SMS alerts and financial numbers must be scrubbed of personally identifiable information before entering console logs.
* **Secure UI Task Overlays:** Implement native task overlays to automatically blur, mask, or obscure sensitive financial screens when the app transitions to multitasking task switchers.
* **Zero Network Permissions:** Confirm the absolute absence of the `android.permission.INTERNET` manifest directive.

#### 30. Accessibility Validation Rules
* **Semantic Target Sizing:** Ensure interactive UI buttons and input fields have sufficient tap targets to guarantee physical usability.
* **Logical Screen Reader Order:** Screen reader announcements must progress in a predictable right-to-left and top-to-bottom pattern matching Persian typography rules.
* **Visual Color Independence:** Convey meaning, validation, and alerts using textual labels, badges, or shapes, rather than relying exclusively on color shifts.

#### 31. Design System Compliance
* **Zero Hardcoded Design Values:** The AI must not use hex color codes, raw coordinate margins, or manual typography sizes.
* **Token Suffix Enforcements:** All colors, spacing parameters, and animation curves must be mapped to active design system tokens.
* **RTL Mirroring by Default:** Layout compositions must natively mirror spatial flows, margins, and directional chevron behaviors based on RTL standards.

#### 32. Coding Standard Compliance
* **Static Linter Compliance:** Code must comply with standard analytical rule suites, showing zero errors and zero developer-scoped warnings.
* **Constructor-Driven DI:** Ensure dependency injection is completed through explicit constructors to facilitate dependency tracing and unit testing.
* **Strict Immutability:** Data transfer objects and entity classes must enforce strict immutability rules.

---

## Section IV: Risk Management, Hallucinations, and Context Governance

```
  +-----------------------------------------------------------------+
  |                  RISK & CONTEXT MANAGEMENT                      |
  +-----------------------------------------------------------------+
  |  33. Risk Management & Risk Register                             |
  |  34. Hallucination Detection Strategy                           |
  |  35. Fact Verification Workflow                                 |
  |  36. Traceability Model & 37. Context Management Strategy      |
  |  38. Knowledge Preservation & 39. Decision Logging              |
  |  40. AI Failure Recovery Strategy                               |
  +-----------------------------------------------------------------+
```

### 33. Risk Management
The utilization of stochastic AI models in a security-first financial ecosystem introduces critical operational risks. BankYar proactively identifies and manages these items through a dedicated risk register:

| Risk Identifier | Risk Event | Severity | Probability | Impact | Mitigation Strategy |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **RISK-01** | **Architectural Drift:** AI suggests bypassing domain layers to speed up widget state rendering. | Critical | Medium | High | Automated static analysis gate rejecting UI files that import database or data-layer repositories. |
| **RISK-02** | **Stochastic Hallucination:** Model references non-existent libraries or deprecated framework methods. | High | High | Medium | Verify library APIs by checking local documentation and configurations prior to execution. |
| **RISK-03** | **Security Leakage:** AI suggests cloud-based analytical logging or telemetry to monitor errors. | Critical | Low | High | Mandatory static analysis gate scanning for network keywords and blocking internet permission. |
| **RISK-04** | **Regressive Logic:** Refactored logic fails to handle existing SMS patterns correctly. | High | Medium | High | Exhaustive regex parsing test suite execution for every localized modification. |

### 34. Hallucination Detection Strategy
To identify and intercept false information generated by AI models, we implement a four-part strategy:
* **The API Verification Protocol:** The AI must check library definitions in active configuration files to confirm valid class signatures instead of guessing.
* **Unresolved Marker Audit:** Scans all files before commits to block bracketed terms or incomplete template structures.
* **Compilation Integrity Gates:** Run the compiler immediately after code generation to catch invalid methods and incorrect syntax.
* **Negative Logic Verification:** Unit tests must include negative scenarios to verify that logical boundaries are explicitly and correctly defined.

### 35. Fact Verification Workflow
Whenever the AI references system parameters, cryptographic protocols, or architectural decisions, it must execute a Fact Verification Workflow:

```
           +---------------------------------------------+
           |          1. IDENTIFY DECLARED FACT          |
           |  (e.g., SQLite cipher decryption method)     |
           +----------------------+----------------------+
                                  |
                                  v
           +---------------------------------------------+
           |         2. CROSS-REFERENCE SOURCE           |
           |  (Verify file config and local source docs)  |
           +----------------------+----------------------+
                                  |
                                  v
           +---------------------------------------------+
           |           3. MATCH SYSTEM TRUTH             |
           |  (Validate parameters inside local setup)   |
           +----------------------+----------------------+
                                  |
                                  v
           +---------------------------------------------+
           |          4. MERGE CONFIRMED ARTIFACT        |
           |   (Incorporate into final verified asset)   |
           +---------------------------------------------+
```

### 36. Traceability Model
To maintain an auditing trail, all AI generations must be traceable:
* **Commit Suffix Metadata:** Every code commit generated or audited with AI assistance must include the affected architectural layer tag in its suffix: `[Layer: Presentation|Domain|Data]`.
* **Prompt Registry Linking:** Generated source files must document their core prompt template ID and version inside their primary header block.

### 37. Context Management Strategy
To avoid context degradation within AI sessions, we enforce strict budgeting guidelines:
* **The 100K Token Constraint:** Individual session context windows must not exceed 100,000 tokens to ensure high retrieval accuracy.
* **The 5-File Scope Limit:** Prompts can ingest a maximum of 5 active target files for editing and a maximum of 5 auxiliary files for read-only reference.
* **Frequent Session Flushes:** Developers must refresh the AI assistant workspace every 20 interactions or upon completing an atomic task to clear conversational noise.

### 38. Knowledge Preservation
As the application grows, developer knowledge must be preserved. The AI is required to generate a localized markdown memory file detailing completed changes, API transformations, and remaining structural constraints at the end of each major feature task. This allows subsequent sessions to initialize with a clean, low-token context outline.

### 39. Decision Logging
All high-level engineering decisions made with AI assistance must be logged in a standardized Architectural Decision Record (ADR) file inside the project repository. These ADR files are used as mandatory system-truth references in prompt context windows.

### 40. AI Failure Recovery Strategy
If an AI generation fails compilation or validation checks, developers must execute a recovery protocol:
* **Do Not Re-Prompt Blindly:** Avoid re-submitting the exact same prompt block expecting a different result.
* **Isolate the Failure Log:** Capture the compiler error, test trace, or static analysis warning.
* **Inject the Failure Context:** Append the detailed failure log directly into the prompt correction block, requesting specific root-cause resolution.
* **Execute Human Intervention:** If the AI fails to resolve a compilation or logical error within three iterations, a human engineer must intervene, fix the code block, and document the resolution.

---

## Section V: Operational Governance, KPIs, and Continuous Improvement

```
  +-----------------------------------------------------------------+
  |                  OPERATIONAL GOVERNANCE                         |
  +-----------------------------------------------------------------+
  |  41. Governance Rules                                           |
  |  42. KPIs & Metrics Dashboard                                   |
  |  43. Continuous Improvement Process                             |
  |  44. Anti-pattern Catalog                                       |
  |  45. Future AI Evolution Strategy                               |
  +-----------------------------------------------------------------+
```

### 41. Governance Rules
* **Rule 1: Absolute Auditability:** Every AI-generated file must remain readable and audit-friendly. Code generation that obscures implementation or relies on complex code-generation macros is rejected.
* **Rule 2: Version Control Compliance:** No prompt template can be used in active tasks unless it is logged and versioned in the version control repository.
* **Rule 3: Measurable Objectives:** Every technical prompt must define clear, measurable objectives and binary success conditions.
* **Rule 4: Zero Speculative Requirements:** The AI is strictly forbidden from writing code for speculative future extensions unless a formal interface is requested.

### 42. KPIs & Metrics
The health and efficiency of the BankYar AI-first development process are monitored through eight Key Performance Indicators:

| KPI Indicator | Target Metric | Collection Frequency | Source |
| :--- | :--- | :--- | :--- |
| **First-Turn Compile Success** | Above 90% | Weekly | Prompt run outputs |
| **Quality Gate Rejection Rate** | Below 5% | Bi-weekly | Automated CI reports |
| **Test Coverage Maintainability** | Over 85% coverage | Continuous | Test execution suites |
| **Hallucination Occurrence** | Zero occurrences | Monthly | Code review logs |
| **Context Retrieval Accuracy** | 100% compliance | Bi-weekly | Token usage metrics |
| **Linter Compliance Index** | Zero warnings on main branch | Continuous | Static analysis runner |
| **Visual Regression Variance** | Perfect match | Continuous | Golden UI comparison |
| **Developer Satisfaction Rating**| Over 85% satisfaction | Quarterly | Developer feedback surveys |

### 43. Continuous Improvement Process
* **Bi-Weekly Retrospectives:** Human and AI operational metrics are reviewed bi-weekly to identify linter warning patterns and update prompt templates.
* **Technical Debt Cycles:** 20% of every development sprint is allocated to resolving static warnings, updating prompt constraints, and updating package dependencies.
* **Feedback Loop Updates:** Errors discovered in production or QA testing are analyzed to update validation rules and prevent similar failures in future generations.

### 44. Anti-pattern Catalog
We identify and strictly prohibit the following AI-assistance anti-patterns:
* **The "Blind Merge" (Process Violation):** Merging code generated by AI directly into code branches without executing compiling, static analysis, and testing checks.
* **The "Inline Override" (Visual Debt):** Creating custom style adjustments inside screens instead of utilizing semantic design tokens.
* **The "Silent Breaking Change" (Contract Violation):** Modifying underlying database schemas or API variables without updating the relevant documentation and migration files.
* **The "Over-Saturated Prompt" (Context Decay):** Passing unrelated source code files into the prompt session, triggering model confusion and degradation.

### 45. Future AI Evolution Strategy
The BankYar AI-first operational framework is designed to evolve alongside foundation model advances:
* **Phase 1: Deterministic Optimization (Current):** Perfecting native Android offline operations, maintaining strict Persian typography baselines, and implementing absolute database encryption.
* **Phase 2: Intelligent Local Execution (12-24 Months):** Integrating lightweight on-device AI classifiers (e.g., TensorFlow Lite) within the sandboxed parsing layer without altering Domain or Presentation architectures.
* **Phase 3: Multi-Language & Multi-Platform Adaptation (24+ Months):** Expanding design tokens to support iOS native aesthetics, dual-screen foldables, and landscape tablet split-views with automated layout reflowing and full RTL/LTR language support.

---
**End of Document**
