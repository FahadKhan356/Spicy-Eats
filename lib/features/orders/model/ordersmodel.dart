import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';

class OrdersModel {
  int? id;
  DateTime? created_at;
  String? ordersId;
  String? orderedFrom;
  String? deliveredTo;
  List<CartModelNew>? orderedItems;
  String? payType;

  OrdersModel(
      {this.id,
      this.created_at,
      this.ordersId,
      this.orderedFrom,
      this.deliveredTo,
      this.orderedItems,
      this.payType});

//tojson

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'ordersId': ordersId,
      'deliveredTo': deliveredTo,
      'orderedItems': orderedItems,
      'payType': payType,
    };
  }

//fromjson
  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> orderslist = json['orderedItems'] as List ?? [];
    List<CartModelNew> finalList =
        orderslist.map((e) => CartModelNew.fromjson(e)).toList();
    return OrdersModel(
      id: json['id'] ?? '',
      created_at: DateTime.parse(json['created_at']),
      ordersId: json['ordersId'] ?? '',
      deliveredTo: json['deliveredTo'] ?? '',
      orderedItems: finalList,
      payType: json['payType'] ?? '',
    );
  }
}
