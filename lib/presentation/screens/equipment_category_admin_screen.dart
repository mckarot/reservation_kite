import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/equipment_category.dart';
import '../providers/equipment_category_notifier.dart';
import '../../../l10n/app_localizations.dart';

class EquipmentCategoryAdminScreen extends ConsumerStatefulWidget {
  const EquipmentCategoryAdminScreen({super.key});

  @override
  ConsumerState<EquipmentCategoryAdminScreen> createState() =>
      _EquipmentCategoryAdminScreenState();
}

class _EquipmentCategoryAdminScreenState
    extends ConsumerState<EquipmentCategoryAdminScreen> {
  bool _isReordering = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(equipmentCategoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.equipmentCategories),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addCategory,
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          // Afficher le loading pendant le réordonnancement
          if (_isReordering) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Réorganisation en cours...'),
                ],
              ),
            );
          }
          
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noEquipmentCategories),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addCategory),
                    onPressed: () => _showAddCategoryDialog(context),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            onReorder: (oldIndex, newIndex) async {
              print('🔄 Reorder: $oldIndex → $newIndex');
              setState(() => _isReordering = true);
              
              final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
              final newOrder = adjustedIndex + 1;
              final category = categories[oldIndex];
              try {
                await ref
                    .read(equipmentCategoryNotifierProvider.notifier)
                    .reorderCategory(category.id, newOrder);
                // Attendre un peu avant de cacher le loading
                await Future.delayed(const Duration(milliseconds: 500));
              } catch (e) {
                print('❌ Erreur: $e');
              } finally {
                if (mounted) setState(() => _isReordering = false);
              }
            },
            itemBuilder: (context, index) {
              final category = categories[index];
              return Material(
                key: ValueKey(category.id),
                color: Colors.transparent,
                child: _CategoryCard(
                  category: category,
                  onEdit: () => _showEditCategoryDialog(context, category),
                  onDelete: () => _confirmDelete(context, category),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Rafraîchir'),
                onPressed: () => ref.invalidate(equipmentCategoryNotifierProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.categoryName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(equipmentCategoryNotifierProvider.notifier)
                    .createCategory(controller.text);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(
    BuildContext context,
    EquipmentCategory category,
  ) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.categoryName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updated = category.copyWith(name: controller.text.trim());
                await ref
                    .read(equipmentCategoryNotifierProvider.notifier)
                    .updateCategory(updated);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, EquipmentCategory category) {
    final l10n = AppLocalizations.of(context);

    if (category.equipmentIds.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.cannotDeleteCategory(category.equipmentIds.length),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCategory),
        content: Text(l10n.confirmDeleteCategory),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(equipmentCategoryNotifierProvider.notifier)
                    .deleteCategory(category.id);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final EquipmentCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Compter les équipements pour cette catégorie
    final equipmentCountFuture = ref.watch(equipmentCategoryNotifierProvider.notifier)
        .countEquipmentsForCategory(category.id);

    return FutureBuilder<int>(
      future: equipmentCountFuture,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        
        return Card(
          elevation: 2,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue.withOpacity(0.2), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.drag_handle, color: Colors.grey, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count équipement(s)',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
