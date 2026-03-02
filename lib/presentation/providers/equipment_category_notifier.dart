import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart';
import '../../data/repositories/equipment_category_repository.dart';
import '../../data/sources/equipment_category_firestore_datasource.dart';
import '../../domain/models/equipment_category.dart';

final equipmentCategoryDataSourceProvider = Provider<EquipmentCategoryFirestoreDataSource>(
  (ref) => EquipmentCategoryFirestoreDataSource(),
);

final equipmentCategoryRepositoryProvider = Provider<EquipmentCategoryRepository>(
  (ref) => EquipmentCategoryRepository(
    dataSource: ref.watch(equipmentCategoryDataSourceProvider),
  ),
);

final equipmentCategoryNotifierProvider = StateNotifierProvider<EquipmentCategoryNotifier, AsyncValue<List<EquipmentCategory>>>(
  (ref) {
    final repository = ref.watch(equipmentCategoryRepositoryProvider);
    return EquipmentCategoryNotifier(repository, ref);
  },
);

class EquipmentCategoryNotifier extends StateNotifier<AsyncValue<List<EquipmentCategory>>> {
  final EquipmentCategoryRepository _repository;
  final Ref _ref;
  StreamSubscription<List<EquipmentCategory>>? _subscription;
  final bool _isReordering = false;

  EquipmentCategoryNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  bool get isReordering => _isReordering;

  /// Compte le nombre d'équipements pour une catégorie donnée
  Future<int> countEquipmentsForCategory(String categoryId) async {
    try {
      final equipmentRepo = _ref.read(equipmentRepositoryProvider);
      final allEquipments = await equipmentRepo.getAllEquipment();
      return allEquipments.where((e) => e.categoryId == categoryId).length;
    } catch (e) {
      print('❌ Error counting equipments: $e');
      return 0;
    }
  }

  void _init() {
    _subscription = _repository.watchAll().listen(
      (categories) {
        if (!mounted) return;
        // Pendant le reorder, on ignore les mises à jour du stream pour éviter les flickers
        if (_isReordering) return;
        state = AsyncValue.data(categories);
      },
      onError: (error, stackTrace) {
        if (!mounted) return;
        state = const AsyncValue.data([]);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> createCategory(String name) async {
    try {
      final categories = state.value ?? [];
      final maxOrder = categories.isEmpty ? 0 : categories.map((c) => c.order).reduce((a, b) => a > b ? a : b);

      final category = EquipmentCategory(
        id: FirebaseFirestore.instance.collection('equipment_categories').doc().id,
        name: name.trim(),
        order: maxOrder + 1,
        isActive: true,
        equipmentIds: [],
      );

      await _repository.create(category);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> updateCategory(EquipmentCategory category) async {
    try {
      await _repository.update(category);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _repository.delete(categoryId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> reorderCategory(String categoryId, int newOrder) async {
    try {
      print('🔔 [Notifier] reorderCategory called:');
      print('   - categoryId: $categoryId');
      print('   - newOrder: $newOrder');
      
      final categories = state.value ?? [];
      print('   - Categories count: ${categories.length}');
      
      final category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => throw Exception('Category not found'),
      );
      final oldOrder = category.order;
      print('   - Category found: ${category.name} (old order: $oldOrder)');
      
      // Si on déplace vers le bas (oldOrder < newOrder)
      if (oldOrder < newOrder) {
        for (final c in categories) {
          if (c.order > oldOrder && c.order <= newOrder && c.id != categoryId) {
            print('   - Décrémenter ${c.name}: ${c.order} → ${c.order - 1}');
            await _repository.reorder(c.id, c.order - 1);
          }
        }
      } 
      // Si on déplace vers le haut (oldOrder > newOrder)
      else if (oldOrder > newOrder) {
        for (final c in categories) {
          if (c.order >= newOrder && c.order < oldOrder && c.id != categoryId) {
            print('   - Incrémenter ${c.name}: ${c.order} → ${c.order + 1}');
            await _repository.reorder(c.id, c.order + 1);
          }
        }
      }
      
      // Finalement, mettre à jour la catégorie déplacée
      print('   - Update ${category.name}: $oldOrder → $newOrder');
      await _repository.reorder(categoryId, newOrder);
      print('✅ [Notifier] Reorder complete');
      
    } catch (e, s) {
      print('❌ [Notifier] ERREUR reorderCategory:');
      print('   Error: $e');
      print('   Stack: $s');
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  Future<void> reorderCategories(List<EquipmentCategory> categories) async {
    try {
      for (var i = 0; i < categories.length; i++) {
        if (categories[i].order != i + 1) {
          await _repository.reorder(categories[i].id, i + 1);
        }
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }
}
