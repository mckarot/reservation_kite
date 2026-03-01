import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/equipment_category_notifier.dart';
import '../../../l10n/app_localizations.dart';

class EquipmentCategoryFilter extends ConsumerWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const EquipmentCategoryFilter({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(equipmentCategoryNotifierProvider);

    return SizedBox(
      height: 60,
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(child: Text(l10n.noEquipmentCategories));
          }

          final activeCategories = categories.where((c) => c.isActive).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.all),
                  selected: selectedCategoryId == null,
                  onSelected: (selected) => onCategorySelected(null),
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: Colors.blue.shade100,
                  showCheckmark: false,
                ),
                const SizedBox(width: 8),
                ...activeCategories.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category.name),
                    selected: selectedCategoryId == category.id,
                    onSelected: (selected) => onCategorySelected(
                      selected ? category.id : null,
                    ),
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.blue.shade100,
                    showCheckmark: false,
                  ),
                )),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('')),
      ),
    );
  }
}
