import '../../../../core/architecture/entity.dart';

/// Pure domain entity representing a transaction category.
class TransactionCategory extends Entity<String> {
  /// Constructor defining category name, hex color, and system defined boolean.
  const TransactionCategory({
    required String id,
    required this.name,
    required this.colorHex,
    required this.isSystemDefined,
  }) : super(id);

  /// Category name (localized).
  final String name;

  /// Hex color token mapping.
  final String colorHex;

  /// Indicates if the category is predefined or custom-defined.
  final bool isSystemDefined;
}
