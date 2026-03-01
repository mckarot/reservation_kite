import '../sources/equipment_category_firestore_datasource.dart';
import '../../domain/models/equipment_category.dart';

class EquipmentCategoryRepository {
  final EquipmentCategoryFirestoreDataSource _dataSource;

  EquipmentCategoryRepository({
    required EquipmentCategoryFirestoreDataSource dataSource,
  }) : _dataSource = dataSource;

  Stream<List<EquipmentCategory>> watchAll() {
    return _dataSource.watchAll();
  }

  Future<List<EquipmentCategory>> getAll() async {
    return _dataSource.getAll();
  }

  Future<void> create(EquipmentCategory category) async {
    await _validateName(category.name);
    await _dataSource.create(category);
  }

  Future<void> update(EquipmentCategory category) async {
    await _validateName(category.name, excludeId: category.id);
    await _dataSource.update(category);
  }

  Future<void> delete(String categoryId) async {
    final category = await _getCategory(categoryId);
    if (category.equipmentIds.isNotEmpty) {
      throw Exception(
        'Cannot delete category with ${category.equipmentIds.length} equipment(s) attached',
      );
    }
    await _dataSource.delete(categoryId);
  }

  Future<void> reorder(String categoryId, int newOrder) async {
    print('📦 [Repository] reorder called:');
    print('   - categoryId: $categoryId');
    print('   - newOrder: $newOrder');
    
    if (newOrder < 1) {
      print('❌ [Repository] Order must be at least 1');
      throw Exception('Order must be at least 1');
    }
    
    try {
      await _dataSource.reorder(categoryId, newOrder);
      print('✅ [Repository] DataSource reorder successful');
    } catch (e) {
      print('❌ [Repository] DataSource error: $e');
      rethrow;
    }
  }

  Future<EquipmentCategory> _getCategory(String categoryId) async {
    final categories = await getAll();
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (_) {
      throw Exception('Category not found');
    }
  }

  Future<void> _validateName(String name, {String? excludeId}) async {
    if (name.trim().isEmpty) {
      throw Exception('Category name cannot be empty');
    }

    final categories = await getAll();
    final exists = categories.any(
      (c) => c.name.toLowerCase() == name.trim().toLowerCase() && c.id != excludeId,
    );

    if (exists) {
      throw Exception('A category with this name already exists');
    }
  }
}
