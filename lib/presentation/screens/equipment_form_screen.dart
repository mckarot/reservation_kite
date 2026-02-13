import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/equipment.dart';
import '../providers/equipment_notifier.dart';

class EquipmentFormScreen extends ConsumerStatefulWidget {
  final Equipment? equipment;
  const EquipmentFormScreen({super.key, this.equipment});

  @override
  ConsumerState<EquipmentFormScreen> createState() =>
      _EquipmentFormScreenState();
}

class _EquipmentFormScreenState extends ConsumerState<EquipmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _sizeController;
  late TextEditingController _notesController;
  late EquipmentCategory _category;
  late EquipmentStatus _status;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(
      text: widget.equipment?.brand ?? '',
    );
    _modelController = TextEditingController(
      text: widget.equipment?.model ?? '',
    );
    _sizeController = TextEditingController(text: widget.equipment?.size ?? '');
    _notesController = TextEditingController(
      text: widget.equipment?.notes ?? '',
    );
    _category = widget.equipment?.category ?? EquipmentCategory.kite;
    _status = widget.equipment?.status ?? EquipmentStatus.available;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.equipment != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier' : 'Ajouter du Matériel'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<EquipmentCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Catégorie'),
              items: EquipmentCategory.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marque'),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Champ requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Modèle'),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Champ requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sizeController,
              decoration: const InputDecoration(
                labelText: 'Taille (ex: 12m, 138cm)',
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Champ requis' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<EquipmentStatus>(
              value: _status,
              decoration: const InputDecoration(labelText: 'État'),
              items: EquipmentStatus.values
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _status = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (Optionnel)'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: Text(isEditing ? 'Mettre à jour' : 'Enregistrer'),
            ),
            if (isEditing) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: _delete,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Supprimer du matériel'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final equipment = Equipment(
        id: widget.equipment?.id ?? const Uuid().v4(),
        brand: _brandController.text,
        model: _modelController.text,
        size: _sizeController.text,
        category: _category,
        status: _status,
        notes: _notesController.text,
        createdAt: widget.equipment?.createdAt ?? DateTime.now(),
        lastMaintenance: _status == EquipmentStatus.maintenance
            ? DateTime.now()
            : widget.equipment?.lastMaintenance,
      );

      ref.read(equipmentNotifierProvider.notifier).saveEquipment(equipment);
      Navigator.pop(context);
    }
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(equipmentNotifierProvider.notifier)
                  .deleteEquipment(widget.equipment!.id);
              Navigator.pop(context); // Dialog
              Navigator.pop(context); // Screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
