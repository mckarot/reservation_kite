import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/equipment_item.dart';
import '../providers/equipment_notifier.dart';
import '../widgets/equipment_card.dart';

/// Écran d'administration pour la gestion du parc matériel.
///
/// Permet de :
/// - Ajouter/modifier/supprimer des équipements
/// - Consulter l'état du parc
/// - Gérer les maintenances
class EquipmentAdminScreen extends ConsumerWidget {
  const EquipmentAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final equipmentAsync = ref.watch(equipmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du parc matériel'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEquipmentDialog(context, ref),
            tooltip: 'Ajouter un équipement',
          ),
        ],
      ),
      body: equipmentAsync.when(
        data: (equipmentList) {
          if (equipmentList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun équipement',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez votre premier équipement',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Regrouper par statut
          final available = equipmentList
              .where((e) => e.isActive &&
                  e.currentStatus == EquipmentCurrentStatus.available)
              .toList();
          final rented = equipmentList
              .where((e) => e.isActive &&
                  e.currentStatus == EquipmentCurrentStatus.rented)
              .toList();
          final maintenance = equipmentList
              .where((e) => e.currentStatus == EquipmentCurrentStatus.maintenance)
              .toList();
          final inactive =
              equipmentList.where((e) => !e.isActive).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (available.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'Disponibles',
                  available.length,
                  colorScheme.primary,
                ),
                ...available.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EquipmentCard(
                        equipment: e,
                        isAvailable: true,
                        showPrice: true,
                        onTap: () => _showEditEquipmentDialog(context, ref, e),
                        onStatusTap: () => _showChangeStatusDialog(context, ref, e),
                      ),
                    )),
              ],
              if (rented.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'En location',
                  rented.length,
                  colorScheme.tertiary,
                ),
                ...rented.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EquipmentCard(
                        equipment: e,
                        isAvailable: false,
                        showPrice: true,
                        onTap: () => _showEditEquipmentDialog(context, ref, e),
                        onStatusTap: () => _showChangeStatusDialog(context, ref, e),
                      ),
                    )),
              ],
              if (maintenance.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'En maintenance',
                  maintenance.length,
                  colorScheme.error,
                ),
                ...maintenance.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EquipmentCard(
                        equipment: e,
                        isAvailable: false,
                        showPrice: true,
                        onTap: () => _showEditEquipmentDialog(context, ref, e),
                        onStatusTap: () => _showChangeStatusDialog(context, ref, e),
                      ),
                    )),
              ],
              if (inactive.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'Inactifs',
                  inactive.length,
                  colorScheme.onSurfaceVariant,
                ),
                ...inactive.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EquipmentCard(
                        equipment: e,
                        isAvailable: false,
                        showPrice: true,
                        onTap: () => _showEditEquipmentDialog(context, ref, e),
                      ),
                    )),
              ],
            ],
          );
        },
        loading: () {
          print('⏳ [EQUIPMENT] Chargement des équipements...');
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          print('❌ [EQUIPMENT] ERREUR DE CHARGEMENT:');
          print('   Message: $error');
          print('   Stack: $stack');
          
          // Afficher le lien pour créer l'index si c'est une erreur d'index
          final errorString = error.toString();
          if (errorString.contains('failed-precondition') && 
              errorString.contains('index')) {
            print('⚠️ [EQUIPMENT] Index Firestore manquant détecté !');
            print('🔗 Le lien pour créer l\'index devrait être dans le message d\'erreur ci-dessus');
          }
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur de chargement',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    error.toString(),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int count,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  void _showAddEquipmentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _EquipmentFormDialog(
        onSave: (equipment) async {
          await ref
              .read(equipmentNotifierProvider.notifier)
              .saveEquipment(equipment);
        },
      ),
    );
  }

  void _showEditEquipmentDialog(
      BuildContext context, WidgetRef ref, EquipmentItem equipment) {
    showDialog(
      context: context,
      builder: (context) => _EquipmentFormDialog(
        equipment: equipment,
        onSave: (equipment) async {
          await ref
              .read(equipmentNotifierProvider.notifier)
              .saveEquipment(equipment);
        },
        onDelete: () async {
          await ref
              .read(equipmentNotifierProvider.notifier)
              .deactivateEquipment(equipment.id);
        },
      ),
    );
  }

  /// Affiche un dialog pour changer le statut de l'équipement
  Future<void> _showChangeStatusDialog(
      BuildContext context, WidgetRef ref, EquipmentItem equipment) async {
    final newStatus = await showDialog<EquipmentCurrentStatus>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Changer le statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Statut actuel : ${_getStatusText(equipment.currentStatus)}'),
            const SizedBox(height: 16),
            const Text('Nouveau statut :'),
            const SizedBox(height: 8),
            ...EquipmentCurrentStatus.values.map((status) {
              if (status == equipment.currentStatus) return const SizedBox();
              return ListTile(
                leading: Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status, Theme.of(context).colorScheme),
                ),
                title: Text(_getStatusText(status)),
                onTap: () => Navigator.pop(dialogContext, status),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );

    if (newStatus != null && newStatus != equipment.currentStatus) {
      // Mettre à jour le statut via le provider (rafraîchit la liste)
      await ref
          .read(equipmentNotifierProvider.notifier)
          .updateEquipmentStatus(equipment.id, newStatus);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Statut mis à jour : ${_getStatusText(newStatus)}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  IconData _getStatusIcon(EquipmentCurrentStatus status) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return Icons.check_circle;
      case EquipmentCurrentStatus.rented:
        return Icons.inventory_2;
      case EquipmentCurrentStatus.maintenance:
        return Icons.build;
    }
  }

  Color _getStatusColor(EquipmentCurrentStatus status, ColorScheme colorScheme) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return colorScheme.primary;
      case EquipmentCurrentStatus.rented:
        return colorScheme.tertiary;
      case EquipmentCurrentStatus.maintenance:
        return colorScheme.error;
    }
  }

  String _getStatusText(EquipmentCurrentStatus status) {
    switch (status) {
      case EquipmentCurrentStatus.available:
        return 'Disponible';
      case EquipmentCurrentStatus.rented:
        return 'En location';
      case EquipmentCurrentStatus.maintenance:
        return 'En maintenance';
    }
  }
}

class _EquipmentFormDialog extends StatefulWidget {
  const _EquipmentFormDialog({
    this.equipment,
    required this.onSave,
    this.onDelete,
  });

  final EquipmentItem? equipment;
  final Future<void> Function(EquipmentItem) onSave;
  final Future<void> Function()? onDelete;

  @override
  State<_EquipmentFormDialog> createState() => _EquipmentFormDialogState();
}

class _EquipmentFormDialogState extends State<_EquipmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _sizeController;
  late TextEditingController _colorController;
  late TextEditingController _serialNumberController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _rentalPriceMorningController;
  late TextEditingController _rentalPriceAfternoonController;
  late TextEditingController _rentalPriceFullDayController;
  late TextEditingController _notesController;

  EquipmentCategoryType _category = EquipmentCategoryType.kite;
  EquipmentCondition _condition = EquipmentCondition.good;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final e = widget.equipment;
    _nameController = TextEditingController(text: e?.name ?? '');
    _brandController = TextEditingController(text: e?.brand ?? '');
    _modelController = TextEditingController(text: e?.model ?? '');
    _sizeController = TextEditingController(
        text: e != null ? e.size.toString() : '');
    _colorController = TextEditingController(text: e?.color ?? '');
    _serialNumberController =
        TextEditingController(text: e?.serialNumber ?? '');
    _purchasePriceController = TextEditingController(
        text: e != null ? e.purchasePrice.toString() : '');
    _rentalPriceMorningController = TextEditingController(
        text: e != null ? e.rentalPriceMorning.toString() : '0');
    _rentalPriceAfternoonController = TextEditingController(
        text: e != null ? e.rentalPriceAfternoon.toString() : '0');
    _rentalPriceFullDayController = TextEditingController(
        text: e != null ? e.rentalPriceFullDay.toString() : '0');
    _notesController = TextEditingController(text: e?.notes ?? '');
    _category = e?.category ?? EquipmentCategoryType.kite;
    _condition = e?.condition ?? EquipmentCondition.good;
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    _serialNumberController.dispose();
    _purchasePriceController.dispose();
    _rentalPriceMorningController.dispose();
    _rentalPriceAfternoonController.dispose();
    _rentalPriceFullDayController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(widget.equipment == null
          ? 'Ajouter un équipement'
          : 'Modifier l\'équipement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              // Catégorie
              DropdownButtonFormField<EquipmentCategoryType>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Catégorie *',
                  border: OutlineInputBorder(),
                ),
                items: EquipmentCategoryType.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(_getCategoryLabel(c)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              // Marque et modèle
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Marque *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Modèle *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Requis' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Taille
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Taille *',
                  suffixText: _category == EquipmentCategoryType.board
                      ? 'cm'
                      : 'm²',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              // Couleur et N° série
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(
                        labelText: 'Couleur',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _serialNumberController,
                      decoration: const InputDecoration(
                        labelText: 'N° série',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Prix d'achat
              TextFormField(
                controller: _purchasePriceController,
                decoration: const InputDecoration(
                  labelText: 'Prix d\'achat (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Prix de location
              const Text('Prix de location (crédits)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rentalPriceMorningController,
                      decoration: const InputDecoration(
                        labelText: 'Matin',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _rentalPriceAfternoonController,
                      decoration: const InputDecoration(
                        labelText: 'Après-midi',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _rentalPriceFullDayController,
                      decoration: const InputDecoration(
                        labelText: 'Journée',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // État
              DropdownButtonFormField<EquipmentCondition>(
                value: _condition,
                decoration: const InputDecoration(
                  labelText: 'État',
                  border: OutlineInputBorder(),
                ),
                items: EquipmentCondition.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(_getConditionLabel(c)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _condition = v!),
              ),
              const SizedBox(height: 16),
              // Actif
              SwitchListTile(
                title: const Text('Équipement actif'),
                subtitle: const Text('Affiché dans les locations'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 16),
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete!();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: const Text('Désactiver'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _save();
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _save() {
    final now = DateTime.now();
    
    // Générer un ID unique si c'est un nouvel équipement
    final String id = widget.equipment?.id ?? 
        'equip_${DateTime.now().millisecondsSinceEpoch}_${_nameController.text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
    
    print('💾 [EQUIPMENT] Sauvegarde équipement: id=$id, name=${_nameController.text}');
    
    final equipment = EquipmentItem(
      id: id,
      name: _nameController.text,
      category: _category,
      brand: _brandController.text,
      model: _modelController.text,
      size: double.parse(_sizeController.text),
      color: _colorController.text.isEmpty ? null : _colorController.text,
      serialNumber:
          _serialNumberController.text.isEmpty ? null : _serialNumberController.text,
      purchaseDate: widget.equipment?.purchaseDate,
      purchasePrice: int.tryParse(_purchasePriceController.text) ?? 0,
      rentalPriceMorning:
          int.tryParse(_rentalPriceMorningController.text) ?? 0,
      rentalPriceAfternoon:
          int.tryParse(_rentalPriceAfternoonController.text) ?? 0,
      rentalPriceFullDay:
          int.tryParse(_rentalPriceFullDayController.text) ?? 0,
      isActive: _isActive,
      currentStatus: widget.equipment?.currentStatus ??
          EquipmentCurrentStatus.available,
      condition: _condition,
      totalRentals: widget.equipment?.totalRentals ?? 0,
      lastMaintenanceDate: widget.equipment?.lastMaintenanceDate,
      nextMaintenanceDate: widget.equipment?.nextMaintenanceDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      createdAt: widget.equipment?.createdAt ?? now,
      updatedAt: now,
    );

    print('✅ [EQUIPMENT] Objet Equipment créé, appel du repository...');
    
    Navigator.pop(context);
    widget.onSave(equipment);
    
    print('🎉 [EQUIPMENT] Sauvegarde terminée');
  }

  String _getCategoryLabel(EquipmentCategoryType category) {
    switch (category) {
      case EquipmentCategoryType.kite:
        return 'Kite';
      case EquipmentCategoryType.board:
        return 'Planche';
      case EquipmentCategoryType.foil:
        return 'Foil';
      case EquipmentCategoryType.harness:
        return 'Harnais';
      case EquipmentCategoryType.wing:
        return 'Wing';
      case EquipmentCategoryType.other:
        return 'Autre';
    }
  }

  String _getConditionLabel(EquipmentCondition condition) {
    switch (condition) {
      case EquipmentCondition.newCondition:
        return 'Neuf';
      case EquipmentCondition.good:
        return 'Bon état';
      case EquipmentCondition.fair:
        return 'État moyen';
      case EquipmentCondition.poor:
        return 'Usé';
    }
  }
}
