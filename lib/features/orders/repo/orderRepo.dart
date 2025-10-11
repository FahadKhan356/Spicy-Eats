import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Cartmodel.dart';
import 'package:spicy_eats/main.dart';

var orderRepoProvider = Provider((ref) => OrderRepo());

class OrderRepo {
  Future<void> storeOrder(
      {required List<Cartmodel> orders,
      required String orderedFrom,
      required String deliveredTo,
      required String paytype}) async {
    try {
      final List<Map<String, dynamic>> orderitems =
          orders.map((e) => e.tojson()).toList();

      await supabaseClient.from('orders').insert({
        'orderedFrom': orderedFrom,
        'deliveredTo': deliveredTo,
        'orderedItems': orderitems,
        'payType': paytype,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
