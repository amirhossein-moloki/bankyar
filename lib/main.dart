import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  // Ensure native and platform bindings are successfully booted
  WidgetsFlutterBinding.ensureInitialized();

  // Run the application wrapped inside Riverpod's ProviderScope container.
  runApp(const ProviderScope(child: BankYarApp()));
}
