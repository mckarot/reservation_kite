import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/equipment.dart';
import '../providers/equipment_notifier.dart';

class EquipmentAdminScreen extends ConsumerStatefulWidget {
  const EquipmentAdminScreen({super.key});

  @override
  ConsumerState<EquipmentAdminScreen> createState() =>
      _EquipmentAdminScreenState();
}

class _EquipmentAdminScreenState extends ConsumerState<EquipmentAdminScreen> {
  EquipmentType _selectedType = EquipmentType.kite;

  @override
  Widget build(BuildContext context) {
    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du Matériel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEquipmentDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: equipmentAsync.when(
              data: (items) {
                final filtered = items
                    .where((e) => e.type == _selectedType)
                    .toList();
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Aucun équipement dans cette catégorie.'),
                  );
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
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: EquipmentType.values.map((type) {
          final isSelected = _selectedType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(type.name.toUpperCase()),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _selectedType = type);
              },
              selectedColor: Colors.blue.shade100,
              checkmarkColor: Colors.blue,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAddEquipmentDialog(BuildContext context, WidgetRef ref) {
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final sizeController = TextEditingController();
    EquipmentType dialogType = _selectedType;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Ajouter du matériel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<EquipmentType>(
                  initialValue: dialogType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: EquipmentType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setDialogState(() => dialogType = val!),
                ),
                TextField(
                  controller: brandController,
                  decoration: const InputDecoration(
                    labelText: 'Marque (ex: F-One, North)',
                  ),
                ),
                TextField(
                  controller: modelController,
                  decoration: const InputDecoration(
                    labelText: 'Modèle (ex: Bandit, Rebel)',
                  ),
                ),
                TextField(
                  controller: sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Taille (ex: 9m, 138cm)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (brandController.text.isNotEmpty &&
                    sizeController.text.isNotEmpty) {
                  final newEquip = Equipment(
                    id: const Uuid().v4(),
                    type: dialogType,
                    brand: brandController.text,
                    model: modelController.text,
                    size: sizeController.text,
                    updatedAt: DateTime.now(),
                  );
                  ref
                      .read(equipmentNotifierProvider.notifier)
                      .addEquipment(newEquip);
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
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
    Color statusColor;
    String statusLabel;

    switch (equipment.status) {
      case EquipmentStatus.available:
        statusColor = Colors.green;
        statusLabel = 'DISPO';
        break;
      case EquipmentStatus.maintenance:
        statusColor = Colors.orange;
        statusLabel = 'MAINTENANCE';
        break;
      case EquipmentStatus.damaged:
        statusColor = Colors.red;
        statusLabel = 'HORS SERVICE';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const PopupMenuItem(
              value: EquipmentStatus.available,
              child: Text('Rendre Disponible'),
            ),
            const PopupMenuItem(
              value: EquipmentStatus.maintenance,
              child: Text('Mettre en Maintenance'),
            ),
            const PopupMenuItem(
              value: EquipmentStatus.damaged,
              child: Text('Déclarer Hors Service'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              onTap: () => ref
                  .read(equipmentNotifierProvider.notifier)
                  .deleteEquipment(equipment.id),
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
