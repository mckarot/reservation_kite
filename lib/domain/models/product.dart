import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required int price,
    required String category, // 'wing', 'kite', 'board', etc.
    required String condition, // 'new', 'used'
    required int stockQuantity,
    @Default([]) List<String> imageUrls,
    required DateTime createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
