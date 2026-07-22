# 04_PromptTemplates.md

- **Version:** 1.0.0
- **Status:** APPROVED & ENFORCED
- **Owner:** Principal Prompt Architect & AI Systems Engineer
- **Last Updated:** October 2023
- **Related Documents:**
  - `CODING_CONSTITUTION.md`
  - `AI_CONSTITUTION.md`
  - `01_AIDevelopmentGuide.md`
  - `05_ContextLoadingStrategy.md`

---

## 1. Executive Summary

This document acts as the master catalog of structured, high-density prompt templates engineered for the BankYar project. These templates provide unambiguous constraints, precise file targets, and verification checklists. They must be utilized verbatim by developers and AI agents during feature development, refactoring, bug fixing, test suite creation, and UI adjustments.

---

## 2. Purpose & Scope

### Purpose
To standardize the inputs sent to AI models, maximizing code accuracy, minimizing token usage, and eliminating architectural drift or hallucinations.

### Scope
Applies to all interactions with AI systems (e.g., ChatGPT, Claude, Gemini, Cursor, Devin, etc.) in the BankYar ecosystem.

---

## 3. Definitions

| Term | Definition |
| :--- | :--- |
| **Prompt Template** | A pre-structured markdown format that optimizes the quality and deterministic output of LLMs. |
| **High-Density Context** | A curated set of highly relevant source files and standards loaded within a token limit. |

---

## 4. Comprehensive Prompt Catalog

### 4.1 Feature Development Scaffold Template
```markdown
You are a Lead Flutter Feature Architect for BankYar. Your task is to scaffold the directories and abstract contracts for a new vertical feature.

SCAFFOLD CONSTRAINTS:
1. Follow Clean Architecture and Feature-First layout strictly.
2. Maintain strict inward layer isolation: Presentation -> Domain <- Data.
3. Domain must be 100% written in pure Dart. Do not import any Flutter visual packages, Riverpod, SQLCipher, or platform integrations.
4. All classes and directories must follow the exact suffixes specified in 02_FlutterCodingStandards.md.

FEATURE DETAILS:
- Feature Module Name: [Insert Feature Name, e.g., Notes]
- Component Purpose: [Insert Detailed Purpose]
- Key Domain Actions / Usecases: [List Actions]

FILES TO CREATE:
- `lib/features/[feature_name]/domain/entities/[feature_name]_entity.dart`
- `lib/features/[feature_name]/domain/repository/i_[feature_name]_repository.dart`
- `lib/features/[feature_name]/domain/usecases/[feature_name]_use_case.dart`

EXPECTED OUTPUT:
Generate the fully structured directories, the immutable entities, the abstract repository interface, and the pure Dart use cases with complete triple-slash (///) comments.
```

---

### 4.2 Bug Fix Prompt Template
```markdown
You are an Elite Debugging Engineer for BankYar. You must isolate and fix the reported bug following a deterministic root-cause analysis cycle.

ROOT CAUSE CYCLE:
1. Define precise failure with log stack trace.
2. Isolate the target architectural layer and class boundary.
3. Write a mock unit test simulating the failing state before altering production code.
4. Implement the fix and verify the mock test passes cleanly.
5. Execute regression static analysis across the feature boundary.

BUG DETAILS:
- Reported Error / Crash Log: [Log details]
- Related Files to Read: [List exact paths]
- Related Files to Edit: [List exact paths]
- Steps to Reproduce: [List steps]

EXPECTED OUTPUT:
Provide the step-by-step root cause analysis, the mock unit test reproducing the issue, and the exact lines to modify inside the production source code.
```

---

### 4.3 Refactoring & Complexity Reduction Template
```markdown
You are a Senior Refactoring Specialist. Your task is to optimize the provided code for maintainability, readability, and performance.

RULES OF REFACTORING:
1. Do not break or alter existing unit test assertions.
2. Respect the Boy Scout Rule: fix minor compiler warnings and format issues in the same scope.
3. Reduce function cyclomatic complexity to strictly below 8.
4. Extract widgets nested beyond 3 levels into private stateless components.
5. Keep file size under 300 lines of code.

TARGET TO REFACTOR:
- Target File Path: [Path]
- Core Objective: [e.g., split large build method, break down fat notifier class]

EXPECTED OUTPUT:
Provide the clean refactored Dart code, highlighting extracted helper methods or widgets.
```

---

### 4.4 Automated Test Suite Generation Template
```markdown
You are a QA Automation Lead. Your task is to generate deterministic, robust tests for the specified feature.

TESTING BOUNDARIES:
1. Do not invoke actual platform channels, hardware Keystores, or remote network sockets. Use mocks or fakes.
2. Avoid using arbitrary time delays (e.g., `sleep`). Use mock clocks or fake timers to ensure fast, predictable test execution.
3. Unit tests must cover edge cases, boundary parameters, and failure states.
4. Target coverage: 100% for parsing regular expressions, 85% for other domain components.

SPECIFICATION:
- Target Production File: [File Path]
- Dependencies to Mock: [List dependencies]
- Scenarios to Test: [List scenarios, e.g., parsed numbers with Persian digits, zero amounts, empty strings]

EXPECTED OUTPUT:
Generate a complete, compilable test file under `test/` following the correct feature folder hierarchy.
```

---

### 4.5 UI Responsive & Mirroring Implementation Template
```markdown
You are a Senior UI/UX Frontend specialist for BankYar. Your task is to implement/refine a highly accessible, responsive widget.

UI CONSTRAINTS:
1. Support full Farsi Right-to-Left (RTL) mirroring dynamically. Double-check layouts, gesture directions, and alignment points.
2. Dynamic text scaling must be supported up to 200% without clipping or layout overflows.
3. Use semantic design tokens exclusively from `Theme.of(context)`. Hardcoded colors or physical measurements are strictly forbidden.
4. Build methods must be strictly under 40 lines.

UI SPECIFICATION:
- Widget / Screen Name: [Name]
- Interactive States Required: [e.g., loading, active, error, empty]
- Layout Targets: [Phone, Tablet, Landscape]

EXPECTED OUTPUT:
Provide the high-fidelity declarative Flutter widget following all responsive rules.
```

---

## 5. Best Practices & Examples

### Best Practices
- **Fill all placeholders:** Always ensure the details between `[brackets]` are exhaustively completed before pasting prompts.
- **Reference active spec documents:** Explicitly mention specifications like `SEMANTIC_COLOR_SYSTEM.md` within prompts targeting UI design.

### Example of Complete Prompt Integration
```markdown
Feature Module Name: Notes
Component Purpose: Local quick notes attached to transactions
Key Domain Actions: CreateNote, GetNotesForTransaction
```

---

## 6. Common Mistakes & Anti-patterns

- **The "Vague Request":** Asking the AI to "refactor the code and make it look clean" without establishing specific criteria (like cyclomatic complexity limits).
- **The "Full-File Overwrite":** Instructing the model to generate full-file outputs for tiny modifications, resulting in truncated files or missing comments.

---

## 7. Recommendations & Implementation Notes

- Maintain this prompt template catalog synchronously with updates made to `CODING_CONSTITUTION.md`.
- Train developers to use these exact prompts within IDE plugins like Cursor or Windsurf for perfect compliance.

---

## 8. Quality & Compliance Checklist

AI agents must verify the following items before returning any completed prompt output:
- [ ] No generated Dart file exceeds 300 lines.
- [ ] No generated class exceeds 250 lines.
- [ ] All public classes, constructors, methods, and variables contain triple-slash (`///`) documentation comments.
- [ ] No hardcoded colors or raw dimensions exist in the UI code.
- [ ] The Dart formatter (`dart format`) rules are perfectly respected.

---

## 9. Future Improvements

- **Interactive Scripted Prompt Generator:** Create a localized shell script or CLI tool under `tools/` that generates customized compliance prompts dynamically based on feature specifications.

---
**End of Document**
