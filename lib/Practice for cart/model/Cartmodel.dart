import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';

class CartModel {
  final int? cart_id;
  int quantity;
  double? tprice;
  final String? user_id;
  final int? dish_id;
  final String? created_at;
  final String? image;
  double? itemprice;
  final String? name;
  final String? description;
  final List<Variation>? variation;
  int? variationId;
  final List<DishData>? freqboughts;

  CartModel({
    this.name,
    this.description,
    this.itemprice,
    this.cart_id,
    required this.quantity,
    this.dish_id,
    this.user_id,
    this.tprice,
    this.created_at,
    this.image,
    this.variation,
    this.variationId,
    this.freqboughts,
  });

//tomap / tojson

  Map<String, dynamic> tojson() {
    return {
      'id': cart_id,
      'dish_id': dish_id,
      'user_id': user_id,
      'quantity': quantity,
      'tprice': tprice,
      'created_at': created_at,
      'image': image,
      'itemprice': itemprice,
      'name': name,
      'description': description,
      'variation': variation,
      'variationId': variationId,
      'frequently_boughtList': freqboughts,
    };
  }

//copywith
  CartModel copyWith({
    int? cart_id,
    int? quantity,
    double? tprice,
    String? user_id,
    int? dish_id,
    String? created_at,
    String? image,
    double?
        itemprice, // If you know the type, replace `var` with the actual type.
    String? name,
    String? description,
    List<Variation>? variation,
    int? variationId,
    List<DishData>? freqboughts,
  }) {
    return CartModel(
      cart_id: cart_id ?? this.cart_id,
      quantity: quantity ?? this.quantity,
      tprice: tprice ?? this.tprice,
      user_id: user_id ?? this.user_id,
      dish_id: dish_id ?? this.dish_id,
      created_at: created_at ?? this.created_at,
      image: image ?? this.image,
      itemprice: itemprice ?? this.itemprice,
      name: name ?? this.name,
      description: description ?? this.description,
      variation: variation ?? this.variation,
      variationId: variationId ?? this.variationId,
      freqboughts: freqboughts ?? this.freqboughts,
    );
  }

  // CartModel copyWith({
  //   int? cart_id,
  //   int? quantity,
  //   double? tprice,
  //   String? user_id,
  //   int? dish_id,
  //   String? created_at,
  //   String? image,
  //   int? itemprice,
  //   String? name,
  //   String? description,
  // }) {
  //   return CartModel(
  //     variation: variation ?? this.variation,
  //     cart_id: cart_id ?? this.cart_id,
  //     tprice: tprice ?? this.tprice,
  //     user_id: user_id ?? this.user_id,
  //     dish_id: dish_id ?? this.dish_id,
  //     quantity: quantity ?? this.quantity,
  //     image: image ?? this.image,
  //     itemprice: itemprice ?? this.itemprice,
  //     name: name ?? this.name,
  //     description: description ?? this.description,
  //   );
  // }

//from json
  factory CartModel.fromjson(Map<String, dynamic> json) {
    final freqboughts = json['frequently_boughtList'] as List? ?? [];
    List<DishData> freqboughtslist =
        freqboughts.map((e) => DishData.fromJson(e)).toList();
    final variation = json['variations'] as List? ?? [];
    List<Variation> variationList =
        variation.map((e) => Variation.fromjson(e)).toList();
    return CartModel(
        cart_id: json['id'] ?? 0,
        quantity: json['quantity'] ?? 0,
        dish_id: json['dish_id'] ?? 0,
        tprice:
            json['tprice'] != null ? (json['tprice'] as num).toDouble() : null,
        //json['tprice'] != null ? (json['tprice'] as num).toDouble() : null,
        user_id: json['user_id'] ?? '',
        created_at: json['created_at'] ?? '',
        image: json['image'] ?? '',
        itemprice: json['itemprice'] ?? 0.0,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        variation: variationList ?? [],
        //  (json['variation'] as List<dynamic>)
        //     .map((e) => Variation.fromjson(e))
        //     .toList(),
        variationId: json['variationId'] ?? 0,
        freqboughts: freqboughtslist ?? []);
  }
}
