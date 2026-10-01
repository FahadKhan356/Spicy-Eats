import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

/// A dish the user has hearted, stored as a snapshot so the favorites list can
/// render (and be added back to the cart) without re-fetching the menu.
class FavoriteDish {
  final int? favoriteId;
  final String userId;
  final int dishId;
  final String name;
  final String description;
  final String image;
  final double price;
  final double? discountPrice;
  final String restaurantId;
  final String restaurantName;
  final bool isVariation;
  final bool? isVeg;
  final String createdAt;

  const FavoriteDish({
    this.favoriteId,
    required this.userId,
    required this.dishId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.discountPrice,
    required this.restaurantId,
    required this.restaurantName,
    required this.isVariation,
    this.isVeg,
    required this.createdAt,
  });

  /// Price actually charged when this dish is added to the cart.
  double get payablePrice => discountPrice ?? price;

  bool get hasDiscount =>
      discountPrice != null && discountPrice! > 0 && discountPrice! < price;

  int get discountPercent => hasDiscount
      ? (((price - discountPrice!) / price) * 100).round()
      : 0;

  /// Builds a favorite record from a menu dish, keeping only the fields the
  /// favorites list and cart need.
  factory FavoriteDish.fromDish({
    required DishData dish,
    required String userId,
    required String restaurantId,
    required String restaurantName,
  }) {
    return FavoriteDish(
      userId: userId,
      dishId: dish.dishid ?? 0,
      name: dish.dish_name ?? '',
      description: dish.dish_description ?? '',
      image: dish.dish_imageurl ?? '',
      price: (dish.dish_price ?? 0).toDouble(),
      discountPrice: dish.dish_discount?.toDouble(),
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      isVariation: dish.isVariation,
      isVeg: dish.isVeg,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  /// Rebuilds a [DishData] so a favorite can be handed to the dish/variation
  /// screens that already expect the menu model.
  DishData toDishData() {
    return DishData(
      dishid: dishId,
      id: dishId,
      dish_name: name,
      dish_description: description,
      dish_imageurl: image,
      dish_price: price,
      dish_discount: discountPrice,
      isVariation: isVariation,
      restuid: restaurantId,
      isVeg: isVeg,
      category_id: '',
      cusine: '',
      dish_schedule_meal: '',
      // Not stored on a favorite, so leave it null rather than inventing an id
      // the frequently-bought query would try to look up.
      frequentlyid: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': favoriteId,
      'user_id': userId,
      'dish_id': dishId,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'discount_price': discountPrice,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'is_variation': isVariation ? 1 : 0,
      'is_veg': isVeg == null ? null : (isVeg! ? 1 : 0),
      'created_at': createdAt,
    };
  }

  factory FavoriteDish.fromMap(Map<String, dynamic> map) {
    return FavoriteDish(
      favoriteId: map['id'] as int?,
      userId: map['user_id'] ?? '',
      dishId: (map['dish_id'] as num?)?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (map['discount_price'] as num?)?.toDouble(),
      restaurantId: map['restaurant_id'] ?? '',
      restaurantName: map['restaurant_name'] ?? '',
      isVariation: (map['is_variation'] as num?) == 1,
      isVeg: map['is_veg'] == null ? null : map['is_veg'] == 1,
      createdAt: map['created_at'] ?? '',
    );
  }
}
