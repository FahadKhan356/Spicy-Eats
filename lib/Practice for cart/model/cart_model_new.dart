class CartModelNew {
  final int? cart_id;
  int quantity;
  double? tprice;
  final String? user_id;
  final int? dish_id;
  final String? created_at;
  final String? image;

  CartModelNew({
    this.cart_id,
    required this.quantity,
    this.dish_id,
    this.user_id,
    this.tprice,
    this.created_at,
    this.image,
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
    };
  }
//copywith

  CartModelNew copyWith({
    int? cart_id,
    int? quantity,
    double? tprice,
    String? user_id,
    int? dish_id,
    String? created_at,
    String? image,
  }) {
    return CartModelNew(
      cart_id: cart_id ?? this.cart_id,
      tprice: tprice ?? this.tprice,
      user_id: user_id ?? this.user_id,
      dish_id: dish_id ?? this.dish_id,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }

//from json
  factory CartModelNew.fromjson(Map<String, dynamic> json) {
    return CartModelNew(
      cart_id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      dish_id: json['dish_id'] ?? 0,
      tprice:
          json['tprice'] != null ? (json['tprice'] as num).toDouble() : null,
      //json['tprice'] != null ? (json['tprice'] as num).toDouble() : null,
      user_id: json['user_id'] ?? '',
      created_at: json['created_at'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
