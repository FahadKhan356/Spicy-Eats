import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';

class Cartmodel {
  final int? cart_id;
  int quantity;
  double? tprice;
  final String? user_id;
  final int? dish_id;
  final String created_at;
  final String? image;
  final itemprice;
  final String? name;
  final String? description;
  final List<Variation>? variation;
  // int? variationId;
  final List<DishData>? freqboughts;

  Cartmodel({
    this.name,
    this.description,
    this.itemprice,
    this.cart_id,
    required this.quantity,
    this.dish_id,
    this.user_id,
    this.tprice,
    required this.created_at,
    this.image,
    this.variation,
    // this.variationId,
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
      'variation': jsonEncode(variation?.map((e) => e.tojson()).toList()),
      // 'variationId': variationId,
      'frequently_boughtList':
          jsonEncode(freqboughts?.map((v) => v.tojson()).toList()),
    };
  }
//copywith

  Cartmodel copyWith({
    int? cart_id,
    int? quantity,
    double? tprice,
    String? user_id,
    int? dish_id,
    String? created_at,
    String? image,
    int? itemprice,
    String? name,
    String? description,
    List<Variation>? variation,
  }) {
    return Cartmodel(
      variation: variation ?? this.variation,
      cart_id: cart_id ?? this.cart_id,
      tprice: tprice ?? this.tprice,
      user_id: user_id ?? this.user_id,
      dish_id: dish_id ?? this.dish_id,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      itemprice: itemprice ?? this.itemprice,
      name: name ?? this.name,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
    );
  }

//from json
  factory Cartmodel.fromjson(Map<String, dynamic> json) {
    List<Variation> variationList = [];
    if (json['variation'] != null) {
      try {
        final variationData = json['variation'] is Uint8List
            ? utf8.decode(json['variation']) // Convert binary to String
            : json['variation'].toString();

        if (variationData.isNotEmpty) {
          final decoded = jsonDecode(variationData);
          if (decoded is List) {
            variationList = decoded.map((e) => Variation.fromjson(e)).toList();
          }
        }
      } catch (e, stack) {
        debugPrint('Error decoding variation: $e');
        debugPrint(stack.toString());
      }
    }

    List<DishData> freqboughtsList = [];
    if (json['frequently_boughtList'] != null) {
      try {
        final freqData = json['frequently_boughtList'] is Uint8List
            ? utf8.decode(json['frequently_boughtList'])
            : json['frequently_boughtList'].toString();

        if (freqData.isNotEmpty) {
          final decoded = jsonDecode(freqData);
          if (decoded is List) {
            freqboughtsList = decoded.map((e) => DishData.fromJson(e)).toList();
          }
        }
      } catch (e, stack) {
        debugPrint('Error decoding frequently_boughtList: $e');
        debugPrint(stack.toString());
      }
    }
    // List<Variation> variationList = [];
    // if (json['variation'] != null && json['variation'].toString().isNotEmpty) {
    //   try {
    //     final decoded = jsonDecode(json['variation']);
    //     if (decoded is List) {
    //       variationList = decoded.map((e) => Variation.fromjson(e)).toList();
    //     }
    //   } catch (e) {
    //     debugPrint('Error decoding variation: $e');
    //   }
    // }

    // List<DishData> freqboughtsList = [];
    // if (json['frequently_boughtList'] != null &&
    //     json['frequently_boughtList'].toString().isNotEmpty) {
    //   try {
    //     final decoded = jsonDecode(json['frequently_boughtList']);
    //     if (decoded is List) {
    //       freqboughtsList = decoded.map((e) => DishData.fromJson(e)).toList();
    //     }
    //   } catch (e) {
    //     debugPrint('Error decoding frequently_boughtList: $e');
    //   }
    // }
    // final freqboughts = json['frequently_boughtList'] as List? ?? [];
    // List<DishData> freqboughtslist =
    //     freqboughts.map((e) => DishData.fromJson(e)).toList();
    // final variation = json['variations'] as List? ?? [];
    // List<Variation> variationList =
    //     variation.map((e) => Variation.fromjson(e)).toList();
    return Cartmodel(
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
        variation: variationList,
        //  (json['variation'] as List<dynamic>)
        //     .map((e) => Variation.fromjson(e))
        //     .toList(),
        // variationId: json['variationId'] ?? 0,
        freqboughts: freqboughtsList);
  }
}
