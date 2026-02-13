import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/equipment.dart';
import '../providers/equipment_notifier.dart';
import 'equipment_form_screen.dart';

class EquipmentListScreen extends ConsumerWidget {
  const EquipmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire Matériel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EquipmentFormScreen()),
            ),
          ),
        ],
      ),
      body: equipmentAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Aucun équipement enregistré'));
          }

          // Simple grouping by category
          final categories = EquipmentCategory.values;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, catIndex) {
              final cat = categories[catIndex];
              final categoryItems = list
                  .where((e) => e.category == cat)
                  .toList();

              if (categoryItems.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      _getCategoryLabel(cat),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.blue),
                    ),
                  ),
                  ...categoryItems.map((item) => _EquipmentTile(item: item)),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  String _getCategoryLabel(EquipmentCategory cat) {
    switch (cat) {
      case EquipmentCategory.kite:
        return 'Ailes (Kites)';
      case EquipmentCategory.board:
        return 'Planches (Boards)';
      case EquipmentCategory.bar:
        return 'Barres';
      case EquipmentCategory.harness:
        return 'Harnais';
      case EquipmentCategory.other:
        return 'Autres';
    }
  }
}

class _EquipmentTile extends ConsumerWidget {
  final Equipment item;
  const _EquipmentTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${item.brand} ${item.model}'),
      subtitle: Text('Taille: ${item.size}'),
      trailing: _StatusBadge(status: item.status),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EquipmentFormScreen(equipment: item)),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final EquipmentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case EquipmentStatus.available:
        color = Colors.green;
        label = 'Disponible';
        break;
      case EquipmentStatus.maintenance:
        color = Colors.orange;
        label = 'Entretien';
        break;
      case EquipmentStatus.retired:
        color = Colors.red;
        label = 'Retiré';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
