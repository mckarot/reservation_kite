import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/equipment_category_notifier.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
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
    
    // Récupérer la couleur secondaire du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final secondaryColor = themeSettings?.secondary ?? AppThemeSettings.defaultSecondary;

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
                  selectedColor: secondaryColor.withOpacity(0.3),
                  checkmarkColor: secondaryColor,
                  labelStyle: TextStyle(
                    color: selectedCategoryId == null ? secondaryColor : Colors.black,
                    fontWeight: selectedCategoryId == null ? FontWeight.bold : FontWeight.normal,
                  ),
                  showCheckmark: true,
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
                    selectedColor: secondaryColor.withOpacity(0.3),
                    checkmarkColor: secondaryColor,
                    labelStyle: TextStyle(
                      color: selectedCategoryId == category.id ? secondaryColor : Colors.black,
                      fontWeight: selectedCategoryId == category.id ? FontWeight.bold : FontWeight.normal,
                    ),
                    showCheckmark: true,
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
