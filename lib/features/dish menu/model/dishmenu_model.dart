import 'package:flutter/foundation.dart';

class DishMenuModel {
  String id;
  String variationTitle;
  int dishId;
  double variationPrice;
  String variationName;
  bool isRequired;

  DishMenuModel(
      {required this.id,
      required this.dishId,
      required this.variationTitle,
      required this.variationName,
      required this.isRequired,
      required this.variationPrice});

//tojson
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'variation_title': variationTitle,
      'variation_name': variationName,
      'is_required': isRequired,
      'dish_id': dishId,
      'variation_price': variationPrice,
    };
  }

//fromjson
  factory DishMenuModel.fromjson(Map<String, dynamic> json) {
    return DishMenuModel(
        id: json['id'] ?? '',
        dishId: json['dish_id'] ?? 0,
        variationTitle: json['variation_title'] ?? '',
        variationName: json['variation_name'] ?? '',
        isRequired: json['is_required'] ?? false,
        variationPrice: json['variation_price'] ?? 0.0);
  }
}
