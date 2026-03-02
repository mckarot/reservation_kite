import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/equipment.dart';
import '../providers/equipment_notifier.dart';
import '../providers/equipment_category_notifier.dart';
import '../widgets/equipment_category_filter.dart';
import 'equipment_category_admin_screen.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

class EquipmentAdminScreen extends ConsumerStatefulWidget {
  const EquipmentAdminScreen({super.key});

  @override
  ConsumerState<EquipmentAdminScreen> createState() =>
      _EquipmentAdminScreenState();
}

class _EquipmentAdminScreenState extends ConsumerState<EquipmentAdminScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.equipmentManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: l10n.equipmentCategories,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EquipmentCategoryAdminScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEquipmentDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          EquipmentCategoryFilter(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) =>
                setState(() => _selectedCategoryId = categoryId),
          ),
          Expanded(
            child: equipmentAsync.when(
              data: (items) {
                print('📋 Équipements chargés: ${items.length}');
                print('🔍 Catégorie sélectionnée: $_selectedCategoryId');
                
                final filtered = _selectedCategoryId == null
                    ? items
                    : items
                        .where((e) {
                          print('   - ${e.brand}: categoryId=${e.categoryId}, match=${e.categoryId == _selectedCategoryId}');
                          return e.categoryId == _selectedCategoryId;
                        })
                        .toList();
                print('✅ Équipements filtrés: ${filtered.length}');
                
                if (filtered.isEmpty) {
                  return Center(child: Text(l10n.noEquipmentInCategory));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _EquipmentTile(equipment: item);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${l10n.errorLabel}: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEquipmentDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final sizeController = TextEditingController();
    String? selectedCategoryId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.addEquipment),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final categoriesAsync =
                        ref.watch(equipmentCategoryNotifierProvider);
                    return categoriesAsync.when(
                      data: (categories) {
                        if (categories.isEmpty) {
                          return Text(l10n.noEquipmentCategories);
                        }
                        return DropdownButtonFormField<String>(
                          initialValue: selectedCategoryId,
                          decoration: InputDecoration(
                            labelText: l10n.categoryName,
                          ),
                          hint: Text(l10n.selectCategory),
                          items: categories
                              .where((c) => c.isActive)
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setDialogState(() => selectedCategoryId = val!),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, s) => Text(l10n.errorLabel),
                    );
                  },
                ),
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(labelText: l10n.brandLabel),
                ),
                TextField(
                  controller: modelController,
                  decoration: InputDecoration(labelText: l10n.modelLabel),
                ),
                TextField(
                  controller: sizeController,
                  decoration: InputDecoration(labelText: l10n.sizeLabel),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                if (brandController.text.isNotEmpty &&
                    sizeController.text.isNotEmpty &&
                    selectedCategoryId != null) {
                  final newEquip = Equipment(
                    id: const Uuid().v4(),
                    categoryId: selectedCategoryId!,
                    brand: brandController.text,
                    model: modelController.text,
                    size: sizeController.text,
                    updatedAt: DateTime.now(),
                  );
                  await ref
                      .read(equipmentNotifierProvider.notifier)
                      .addEquipment(newEquip);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(l10n.addButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _EquipmentTile extends ConsumerWidget {
  final Equipment equipment;
  const _EquipmentTile({required this.equipment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    
    Color statusColor;
    String statusLabel;

    switch (equipment.status) {
      case EquipmentStatus.available:
        statusColor = Colors.green;
        statusLabel = l10n.statusAvailable;
        break;
      case EquipmentStatus.maintenance:
        statusColor = Colors.orange;
        statusLabel = l10n.statusMaintenance;
        break;
      case EquipmentStatus.damaged:
        statusColor = Colors.red;
        statusLabel = l10n.statusDamaged;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
      ),
      child: ListTile(
        title: Text(
          '${equipment.brand} ${equipment.model} - ${equipment.size}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<EquipmentStatus>(
          icon: const Icon(Icons.more_vert),
          onSelected: (status) {
            ref
                .read(equipmentNotifierProvider.notifier)
                .updateStatus(equipment.id, status);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: EquipmentStatus.available,
              child: Text(l10n.makeAvailable),
            ),
            PopupMenuItem(
              value: EquipmentStatus.maintenance,
              child: Text(l10n.setMaintenance),
            ),
            PopupMenuItem(
              value: EquipmentStatus.damaged,
              child: Text(l10n.setDamaged),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              onTap: () => ref
                  .read(equipmentNotifierProvider.notifier)
                  .deleteEquipment(equipment.id),
              child: Text(
                l10n.deleteButton,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
