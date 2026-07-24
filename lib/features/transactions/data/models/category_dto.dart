import '../../domain/entities/transaction_category.dart';

/// Data Transfer Object with serialization mappings for [TransactionCategory].
class CategoryDto {
  const CategoryDto._();

  /// Converts a [TransactionCategory] into a standard database map.
  static Map<String, dynamic> toMap(TransactionCategory category) {
    return {
      'id': category.id,
      'name': category.name,
      'color_hex': category.colorHex,
      'is_system_defined': category.isSystemDefined ? 1 : 0,
    };
  }

  /// Restores a [TransactionCategory] from a database map.
  static TransactionCategory fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      colorHex: map['color_hex'] as String,
      isSystemDefined: (map['is_system_defined'] as int) == 1,
    );
  }
}
