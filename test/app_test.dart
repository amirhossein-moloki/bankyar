import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/app.dart';

void main() {
  group('BankYarApp Bootstrapping Smoke Tests', () {
    testWidgets('App renders placeholder elements successfully', (
      tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: BankYarApp()));

      // Verify that the router's initial security lock route starts loaded
      await tester.pumpAndSettle();

      expect(
        find.text('Unlock BankYar (Security Locked Placeholder)'),
        findsOneWidget,
      );
    });
  });
}
