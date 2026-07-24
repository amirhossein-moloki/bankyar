import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/entities/transaction_details.dart';
import '../state/transactions_notifier.dart';

/// Notes, category, and tags editing widget for transaction details.
class DetailsNotesTagsSection extends ConsumerWidget {
  /// Constructor.
  const DetailsNotesTagsSection({
    required this.details,
    required this.onSaveNote,
    required this.onAssignCategory,
    required this.onAssignTags,
    super.key,
  });

  /// Transact details entity.
  final TransactionDetails details;

  /// Callback to save a note text.
  final ValueChanged<String> onSaveNote;

  /// Callback to update category assignment.
  final ValueChanged<String?> onAssignCategory;

  /// Callback to update tag list assignment.
  final ValueChanged<List<String>> onAssignTags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final categoriesAsync = ref.watch(categoriesListProvider);

    final noteText = details.note ?? '';
    final tags = details.tags;
    final currentCategoryId = details.category?.id;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(theme, 'دسته‌بندی تراکنش'),
          categoriesAsync.when(
            data: (categories) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('بدون دسته‌بندی'),
                    selected: currentCategoryId == null,
                    onSelected: (_) => onAssignCategory(null),
                  ),
                  ...categories.map(
                    (cat) => Padding(
                      padding: EdgeInsets.only(right: spacing.xs),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: currentCategoryId == cat.id,
                        onSelected: (_) => onAssignCategory(cat.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          SizedBox(height: spacing.m),
          _buildSectionHeader(theme, 'یادداشت کاربر'),
          BaseCard(
            onTap: () => _showEditNoteDialog(context, noteText),
            child: Padding(
              padding: EdgeInsets.all(spacing.m),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      noteText.isEmpty
                          ? 'یادداشتی ثبت نشده است. برای افزودن کلیک کنید.'
                          : noteText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: noteText.isEmpty
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                        fontStyle: noteText.isEmpty ? FontStyle.italic : null,
                      ),
                    ),
                  ),
                  Icon(Icons.edit_note, color: theme.colorScheme.primary),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.m),
          _buildSectionHeader(theme, 'برچسب‌ها'),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              ...tags.map(
                (tag) => Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 12)),
                  onDeleted: () {
                    final updated = List<String>.from(tags)..remove(tag);
                    onAssignTags(updated);
                  },
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 16),
                label: const Text(
                  'افزودن برچسب',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () => _showAddTagDialog(context, tags),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, String currentNote) {
    final controller = TextEditingController(text: currentNote);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ویرایش یادداشت', textDirection: TextDirection.rtl),
        content: TextFormField(
          controller: controller,
          maxLines: 3,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            hintText: 'یادداشت خود را اینجا بنویسید...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              onSaveNote(controller.text);
              Navigator.pop(context);
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }

  void _showAddTagDialog(BuildContext context, List<String> currentTags) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'افزودن برچسب جدید',
          textDirection: TextDirection.rtl,
        ),
        content: TextFormField(
          controller: controller,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            hintText: 'برچسب (مثلاً خرید، سفر)...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty && !currentTags.contains(val)) {
                onAssignTags([...currentTags, val]);
              }
              Navigator.pop(context);
            },
            child: const Text('افزودن'),
          ),
        ],
      ),
    );
  }
}
