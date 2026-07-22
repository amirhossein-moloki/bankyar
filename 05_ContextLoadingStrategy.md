# 05_ContextLoadingStrategy.md

- **Version:** 1.0.0
- **Status:** APPROVED & ENFORCED
- **Owner:** Principal Architect & Knowledge Management Director
- **Last Updated:** October 2023
- **Related Documents:**
  - `CODING_CONSTITUTION.md`
  - `AI_CONSTITUTION.md`
  - `01_AIDevelopmentGuide.md`
  - `04_PromptTemplates.md`

---

## 1. Executive Summary

Large Language Models (LLMs) suffer from context degradation, "needle-in-a-haystack" retrieval failure, and high token latencies when overloaded with massive context loads. This document designs the precise **Context Loading Strategy** for the BankYar ecosystem, establishing exact context priorities, token optimization gates, loading procedures, and memory management rules.

---

## 2. Purpose & Scope

### Purpose
To maximize the focus, deterministic execution, and token efficiency of AI agents by providing the minimum, highest-density context required for any specific development task.

### Scope
Applies to all workspace indexers, context providers, shell scripts, and conversational AI interfaces utilized during BankYar development.

---

## 3. Definitions

| Term | Definition |
| :--- | :--- |
| **Token Optimization** | Reducing unnecessary lines, comments, and redundant files in context windows to lower compute overhead. |
| **Least Context** | The architectural practice of only loading files strictly necessary for the active compilation unit. |

---

## 4. Context Classification Framework

To systematically assemble the context window, the codebase files are organized into five discrete context classes:

```
+-------------------------------------------------------------+
|                     CORE CONFIG CONTEXT                     |
| (pubspec.yaml, analysis_options.yaml, README.md)             |
+------------------------------+------------------------------+
                               |
                               | Refines
                               v
+-------------------------------------------------------------+
|                    ARCHITECTURE CONTEXT                     |
| (CODING_CONSTITUTION.md, AI_CONSTITUTION.md, ARCHITECTURE.md)|
+------------------------------+------------------------------+
                               |
                               | Targets
                               v
+-------------------------------------------------------------+
|                      FEATURE CONTEXT                        |
| (Entities, abstract repositories, use cases of target feat) |
+-------------------------------------------------------------+
                               |
                               | Renders
                               v
+-------------------------------------------------------------+
|                         UI CONTEXT                          |
| (Screens, widgets, state providers of target feature)       |
+-------------------------------------------------------------+
```

1. **Core Config Context:** System versions and compiler controls (`pubspec.yaml`, `analysis_options.yaml`).
2. **Architecture Context:** Core rules and conventions (`CODING_CONSTITUTION.md`, `AI_CONSTITUTION.md`).
3. **Feature Context:** The exact vertical slice files under target feature directories.
4. **UI Context:** Screens, widgets, and styles matching visual guidelines.
5. **Testing & Security Context:** Mock classes, test data configurations, and native manifests.

---

## 5. Context Loading Priorities

Context assembly is governed by the **Principle of Least Context**. Rather than dumping the entire repository, context injection is restricted by exact task profiles.

### Context Budgeting Profiles

| Task Type | Core Files | Read-Only Helper Files | Context Limit |
| :--- | :--- | :--- | :--- |
| **Scaffolding Feature** | `pubspec.yaml` | `CODING_CONSTITUTION.md`, `AI_CONSTITUTION.md` | ~20k tokens |
| **Bug Fixing** | Affected class + test file | Interface declarations, logs | ~30k tokens |
| **Refactoring Widget** | Target widget file | Visual specs, layout guidelines | ~15k tokens |
| **Writing Tests** | Target class file | Core mock helpers, fake models | ~25k tokens |

---

## 6. Best Practices & Examples

### Best Practices
- **Exclude Generated Files:** Never import `.g.dart` or synthetic build artifacts into the LLM context.
- **Reference Contracts over Implementations:** When the AI only needs to interact with another module, provide the abstract interface class instead of loading the full implementation file.

### Example Context Assembly for AddTransaction Feature
```
1. Inject: CODING_CONSTITUTION.md (Architecture Context)
2. Inject: lib/features/transactions/domain/repository/i_transaction_repository.dart (Domain Contract)
3. Inject: lib/features/transactions/domain/usecases/add_transaction_use_case.dart (Task Target)
```

---

## 7. Common Mistakes & Anti-patterns

- **The "Context Dump" (Anti-pattern):** Dragging the entire folder structure or running `cat **/*.dart` into the LLM session, causing immediate memory confusion and hallucinatory deviations.
- **The "Stale Cache":** Keeping an old conversation active after refactoring file names, causing the AI to reference deprecated files.

---

## 8. Recommendations & Implementation Notes

- Utilize specific prompt boundaries like `.cursorrules` or `.windsufrules` to hardcode core architecture constraints.
- Periodically prune unused dependencies in `pubspec.yaml` to ensure the core model references remain accurate.

---

## 9. Token Optimization & Large Project Strategy

As BankYar grows, the following protocols prevent token overhead:

- **Reference Anchoring Banner:** All files passed to the AI must begin with a clear file path comment banner:
  `// File: lib/features/transactions/domain/entities/transaction_entity.dart`
- **Dependency Ingestion Tree:** Only import interface declarations rather than actual implementations of surrounding modules to keep the context footprint small.
- **Incremental Loading:** Load files step-by-step. Let the AI inspect the abstract contracts first, provide the signature plan, and then load the target implementation files.

---

## 10. Conversational Memory & Refresh Rules

- **Short-Session Ephemerality:** Conversations with AI assistants must be completely flushed (e.g. starting a fresh chat session) every **20 interactions** or upon completing an atomic task to remove conversational noise.
- **Checkpointing:** Before starting a fresh session, the AI must write a brief, bulleted "Session Handover Card" containing:
  - Exact changes implemented.
  - Active feature and file targets.
  - Any pending refactoring or testing items.

---

## 11. Review Checklist

Ensure context compliance:
- [ ] Active context injected is under the 100,000-token limit.
- [ ] No unrelated feature folders are loaded in the window.
- [ ] The `analysis_options.yaml` is loaded whenever debugging compile issues.

---

## 12. Future Improvements

- **AI Context Optimizing CLI:** Build a simple Python script under `tools/` that parses a Dart target file, resolves its local import trees, and outputs a single minimized context markdown file containing only the active interfaces.

---
**End of Document**
