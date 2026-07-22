# 02_FlutterCodingStandards.md

- **Version:** 1.0.0
- **Status:** APPROVED & ENFORCED
- **Owner:** Flutter Tech Lead & Core Engineering Architect
- **Last Updated:** October 2023
- **Related Documents:**
  - `CODING_CONSTITUTION.md`
  - `01_AIDevelopmentGuide.md`
  - `03_FileEditingRules.md`
  - `05_ContextLoadingStrategy.md`
  - `06_DefinitionOfDone.md`

---

## 1. Executive Summary

This document defines the coding conventions, strict nomenclature rules, layout standards, and component structure guidelines for Flutter development inside the BankYar project. Adhering to these standards ensures that both humans and AI agents produce highly readable, modular, easily discoverable, and highly maintainable Dart and Flutter source files.

---

## 2. Purpose & Scope

### Purpose
To establish a uniform, predictable coding pattern that removes ambiguity during code generation, refactoring, and quality enforcement.

### Scope
Applies to all code written in the Dart language, Flutter framework components, and platform bindings of the BankYar repository.

---

## 3. Definitions

| Term | Definition |
| :--- | :--- |
| **DTO (Data Transfer Object)** | A data wrapper that facilitates mapping serialization schemas to pure business objects. |
| **Entity** | An immutable business domain representation containing primary properties and invariants. |
| **UseCase** | A stateless, single-purpose class representing an isolated business action. |
| **StateNotifier** | A Riverpod state holder that manages state transitions and exposes them immutably. |
| **Golden Test** | A screen or widget screenshot-based regression test that verifies pixel-perfect UI. |

---

## 4. Feature-First Folder Structure

To support Clean Architecture and ensure horizontal scalability, BankYar enforces a **Feature-First** structure. Each vertical feature under `lib/features/[feature_name]/` is organized as follows:

```
lib/features/[feature_name]/
├── data/
│   ├── datasources/     # SQLCipher tables/DAOs, secure platform interfaces
│   ├── models/          # DTOs, JSON mappers, database schemas
│   └── repositories/    # Concrete Repository implementations
├── domain/
│   ├── entities/        # Pure Dart immutable models (0 external packages)
│   ├── repository/      # Abstract Repository contract interfaces
│   └── usecases/        # Stateless, single-action business use cases
└── presentation/
    ├── screens/         # Full layout views (responsive, secured)
    ├── widgets/         # Private stateless visual elements
    └── state/           # Riverpod state providers & notifiers
```

---

## 5. Precise Naming Conventions

All source components must be strictly named using the conventions below to maintain instant readability and discoverability across the platform.

### Suffix Naming Matrix

| Component Type | File Case | Class Suffix | Example Path / File Pattern |
| :--- | :--- | :--- | :--- |
| **Pure Entity** | `snake_case` | `Entity` | `lib/features/transactions/domain/entities/transaction_entity.dart` |
| **Data Model (DTO)** | `snake_case` | `Dto` / `Model` | `lib/features/transactions/data/models/transaction_dto.dart` |
| **Abstract Repo** | `snake_case` | `Repository` | `lib/features/transactions/domain/repository/transaction_repository.dart` |
| **Concrete Repo** | `snake_case` | `RepositoryImpl` | `lib/features/transactions/data/repositories/transaction_repository_impl.dart` |
| **Use Case** | `snake_case` | `UseCase` | `lib/features/transactions/domain/usecases/add_transaction_use_case.dart` |
| **State Notifier** | `snake_case` | `Notifier` | `lib/features/transactions/presentation/state/transaction_notifier.dart` |
| **Screen (Page)** | `snake_case` | `Screen` | `lib/features/transactions/presentation/screens/transaction_list_screen.dart` |
| **Custom Widget** | `snake_case` | `Widget` | `lib/features/transactions/presentation/widgets/transaction_card_widget.dart` |
| **Exceptions** | `snake_case` | `Exception` | `lib/core/errors/database_exception.dart` |
| **Failures** | `snake_case` | `Failure` | `lib/core/errors/database_failure.dart` |

---

## 6. Widget & Screen Structure

### Layout Rules
- **Length Constraint:** No widget file may exceed **150 lines of code**.
- **Build Method Limit:** The `build` method of any widget must not exceed **40 lines**.
- **Nesting Guard:** If a layout tree is nested beyond **3 levels**, the subtree must be extracted into a separate private, stateless widget class in the same file or under the `widgets/` folder.
- **Visual Purity:** Build methods must remain 100% visual and declarative. No data transformations, local database queries, regular expression computations, or business validations may exist here.

### Structured Screen Template Example

```dart
// File: lib/features/transactions/presentation/screens/transaction_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/transaction_notifier.dart';
import '../widgets/transaction_card_widget.dart';

/// Screen exhibiting parsed mobile transactions.
/// Utilizes secure [FLAG_SECURE] to block snapshots.
class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    // Enable secure overlay protection natively
    _enableSecureOverlay();
  }

  void _enableSecureOverlay() {
    // Platform channel invocation or standard package to flag window secure
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parsed Transactions'),
      ),
      body: state.when(
        data: (transactions) => ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return TransactionCardWidget(transaction: tx);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
```

---

## 7. Riverpod State Management & DI Rules

1. **Unidirectional Flow:**
   Widgets *watch* providers -> widgets *dispatch actions* to StateNotifiers -> StateNotifiers *execute* UseCases -> UseCases *query* Repository interfaces -> Repositories *return* data.

```
       +--------------------------------------------------------+
       |             UNIDIRECTIONAL RIVERPOD LOOP               |
       +--------------------------------------------------------+
       |   Presentation UI     ->  Watches State Provider       |
       |   State Notifier      ->  Triggers stateless UseCase   |
       |   Stateless UseCase   ->  Executes Repos Interface     |
       |   Concrete Repo       ->  Returns safe Fail/Success    |
       +--------------------------------------------------------+
```

2. **No Global State Leak:** Always use `autoDispose` on Riverpod providers that represent screen-specific visual states to clean memory instantly upon screen disposal.
3. **No Service Locators:** `GetIt` or global singleton mutations are prohibited. All dependency injections must be declared as global final Riverpod providers.

---

## 8. Theme Rules

- **Strict Token Integration:** Developers must avoid hardcoded color values (e.g. `Color(0xFF00FF00)`) or raw pixel measurements. Use semantic tokens provided by the custom theme configuration (e.g., `Theme.of(context).colorScheme.primary`).
- **Dark Mode Design Rules:** All layout elements must dynamically adapt to dark mode based on the `DARK_THEME_SPECIFICATION.md` rules. Ensure proper accessibility contrast values (WCAG AA) are respected in both light and dark variants.

---

## 9. Performance & Memory Management Standards

- **Const Constructors:** Use the `const` keyword on widgets wherever possible to ensure the Flutter framework bypasses layout and paint calculations for unchanged nodes.
- **Isolates for Heavy Duty Tasks:** Heavy file parsing, regex compilation over large text strings, and complex diagnostic calculations must occur in a background Dart `Isolate` or computed asynchronously using standard streams.
- **Resource Disposals:** Sinks, StreamSubscriptions, animations, and controller adapters must be explicitly disposed of inside StateNotifier lifecycle callbacks or widget dispose methods.

---

## 10. Documentation & Code Comment Policy

- **100% Public Coverage:** Every public class, constructor, method, and variable must have a triple-slash (`///`) Dart documentation comment.
- **Explain Intent:** Focus comments on *why* the code was structured this way, what invariants are protected, or any specific hardware limitations, instead of restating the syntax.
- **Clean TODO Patterns:** Standard TODO syntax must include the developer's handle and target issue number: `// TODO(username, #issue): Description of action.`
- **No Commented-out Code:** Commented-out sections are considered technical debt and will block builds. Delete them completely.

---

## 11. Common Mistakes & Anti-patterns

- **The "Fat Notifier":** Writing core business calculations (e.g., parsing regex text, applying bank categories) inside the Riverpod StateNotifier instead of a Domain UseCase.
- **The "Dynamic Fallback":** Declaring method parameters or model lists with the `dynamic` type, causing runtime casting errors.
- **The "UI Db Call":** Passing an abstract database connection directly into a custom UI Widget.

---

## 12. Review Checklist

Verify the following before committing:
- [ ] No Dart file exceeds 300 lines of code.
- [ ] UI files import exactly zero database drivers.
- [ ] There is no hardcoded Farsi text; all localized strings reside in `l10n` templates.
- [ ] Visual widget nesting does not exceed 3 levels deep.

---
**End of Document**
