# 07_TestingStandards.md

- **Version:** 1.0.0
- **Status:** APPROVED & ENFORCED
- **Owner:** QA Automation Lead & DevOps Engineer
- **Last Updated:** October 2023
- **Related Documents:**
  - `CODING_CONSTITUTION.md`
  - `TESTING_ARCHITECTURE.md`
  - `01_AIDevelopmentGuide.md`
  - `02_FlutterCodingStandards.md`
  - `06_DefinitionOfDone.md`

---

## 1. Executive Summary

Testing is the primary mechanism to guarantee software reliability, platform performance, and privacy enforcement inside the BankYar project. This document defines the testing pyramid guidelines, target coverage gates, folder and naming structures, mocking/faking strategies, and CI/CD rules required to maintain a regression-free local system.

---

## 2. Purpose & Scope

### Purpose
To establish clear, actionable standards for writing deterministic, robust automated tests inside BankYar.

### Scope
Applies to all Unit, Widget, Integration, and Golden tests written in the BankYar project workspace.

---

## 3. Definitions

| Term | Definition |
| :--- | :--- |
| **Deterministic Test** | A test that produces identical results regardless of execution count, system clocks, or local environments. |
| **Flaky Test** | A test that passes or fails unpredictably without any modifications to source code, typically due to race conditions or sleep delays. |

---

## 4. The BankYar Testing Pyramid

To optimize verification execution speeds and maintenance costs, automated tests must conform to this architectural breakdown:

```
                  /\
                 /  \      10% Golden / Visual Layout Tests
                /    \
               /------\
              /        \   20% Widget & Dynamic State Integration Tests
             /          \
            /------------\
           /              \  70% Unit Tests (Pure Regex Parsers & Domain logic)
          /________________\
```

1. **Unit Tests (70%):** Validates pure Dart business models, regular expression parsing formulas, data DTO mapping mappers, and domain usecases. Incredibly fast and 100% deterministic.
2. **Widget Tests (20%):** Asserts rendering behaviors, responsive layout reflows, Persian RTL flipping, screen reader semantic declarations, and interactive StateNotifier transitions.
3. **Golden Tests & Integration (10%):** Performs pixel-perfect screenshot verification of screen layouts across varied device form factors, and executes complete database transaction integration tests inside in-memory SQLite instances.

---

## 5. Minimum Coverage Targets & Quality Gates

The system enforces strict coverage thresholds before code merges:

| Component Category | Minimum Coverage Target | Primary Verification Focus |
| :--- | :--- | :--- |
| **Financial SMS Parser Rules** | **100% Coverage** | Validates all possible bank formats and Persian digits. |
| **Domain UseCases & Logic** | **85% Coverage** | Asserts correct failure propagation and result mapping. |
| **Data Mappers & Models** | **85% Coverage** | Verifies JSON serialization and encryption adapters. |
| **UI Widgets & State Holders**| **75% Coverage** | Verifies screen rendering and reactive transitions. |

---

## 6. Naming & Folder Structural Rules

- **Mirroring Paths:** Test source files must exist inside the `test/` directory, mirroring the exact folder paths and naming schemes used in the `lib/` directory, followed by the `_test` suffix.
  - Production code path: `lib/features/transactions/domain/usecases/add_transaction_use_case.dart`
  - Test file path: `test/features/transactions/domain/usecases/add_transaction_use_case_test.dart`

---

## 7. Deterministic Mocking & Faking Strategy

To maintain execution speed and eliminate test flakiness:

- **No Live File System / Database Access:** Never run tests against real storage files on disk or live native SQLCipher databases. Always inject in-memory database adapters or mock data sources.
- **Clock Mocking:** Time-sensitive tests must use the `fake_async` package or custom mock clocks rather than active system delays or `sleep` calls.
- **Example Mocking Pattern (Mockito / Mocktail):**

```dart
// File: test/features/transactions/domain/usecases/add_transaction_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/domain/usecases/add_transaction_use_case.dart';
import 'package:bankyar/features/transactions/domain/entities/transaction_entity.dart';
import 'package:bankyar/core/utils/result.dart';

class MockTransactionRepository extends Mock implements ITransactionRepository {}

void main() {
  late MockTransactionRepository mockRepository;
  late AddTransactionUseCase useCase;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = AddTransactionUseCase(mockRepository);
  });

  test('should successfully add transaction to local repository', () async {
    // Arrange
    final testTx = TransactionEntity(
      id: 'tx_123',
      amount: 150000.0,
      timestamp: DateTime.now(),
    );
    when(() => mockRepository.addTransaction(testTx))
        .thenAnswer((_) async => const Result.success(null));

    // Act
    final result = await useCase.execute(testTx);

    // Assert
    expect(result, isA<Success<void>>());
    verify(() => mockRepository.addTransaction(testTx)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
```

---

## 8. Best Practices & Examples

### Best Practices
- **Arrange, Act, Assert (AAA):** Organize test steps clearly into Setup/Mocking, Invocation, and Expectation assertions.
- **Exhaustive Edge Cases:** Test with empty fields, maximum amounts, and invalid inputs to check safety bounds.

### Example UI Widget Test
```dart
testWidgets('should render transaction amount in Persian digits when locale is Farsi', (tester) async {
  // Setup visual widget with Farsi locale configuration...
  // Assert text component renders expected Persian characters.
});
```

---

## 9. Common Mistakes & Anti-patterns

- **The "Flaky Sleep" (Anti-pattern):** Utilizing `await Future.delayed(Duration(seconds: 1))` inside tests to wait for async resources.
- **Mocking Pure Models:** Writing mock definitions for immutable entities or DTO data objects. Use real instances of models for test data.

---

## 10. Recommendations & Implementation Notes

- Run tests locally inside pre-commit hooks before requesting human review.
- Integrate automated code coverage generators (like `lcov`) to monitor target trends.

---

## 11. Continuous Integration (CI) Rules

The CI pipeline runs automated checks on every Pull Request. A commit is rejected if:
1. Static analysis returns any compile-time errors or linter warnings (`dart analyze`).
2. Any test fails during the full automated suite execution (`flutter test`).
3. Total test coverage falls below the required **85%** threshold.

---

## 12. Review Checklist

Before finishing any test implementation:
- [ ] Ensure all mock classes inherit from Mock and register correct types.
- [ ] Confirm no real file paths or actual platforms are invoked during the test.
- [ ] Verify there are no flaky test cases or thread locks.

---

## 13. Future Improvements

- **Golden Layout Automated Pipeline:** Set up automated visual snapshot test pipelines that run screenshots on headless browsers to capture any minor visual deviation automatically.

---
**End of Document**
