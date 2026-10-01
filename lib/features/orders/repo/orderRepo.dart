import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/orders/model/orderModel.dart';
import 'package:spicy_eats/features/orders/repository/OrderListRepository.dart';
import 'package:spicy_eats/main.dart';

var orderRepoProvider = Provider((ref) => OrderRepo());

class OrderRepo implements OrderStore {
  /// Every order the signed in user has placed, newest first. Rows with no
  /// `user_id` are legacy writes that cannot be attributed to anybody, so they
  /// are deliberately left out rather than shown to whoever happens to open the
  /// screen.
  @override
  Future<List<CustomerOrder>> fetchOrders({required String userId}) async {
    try {
      final response = await supabaseClient
          .from('orders')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (response.isEmpty) return [];
      return response
          .map((json) => CustomerOrder.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      debugPrint('Failed To Fetch Orders $e');
      rethrow;
    }
  }

  Future<void> storeOrder(
      {required List<Cartmodel> orders,
      required String orderedFrom,
      required String deliveredTo,
      required String paytype,
      required String customerId,
      required OrderStatus orderStatus,
      required double totalPrice,
      }) async {
    try {
      final List<Map<String, dynamic>> orderitems =
          orders.map((e) => e.tojson()).toList();

      await supabaseClient.from('orders').insert({
        // These three used to be dropped on the floor, so every order the app
        // placed landed with a null user and no status or total - which is why
        // the orders screen had nothing real to show.
        'user_id': customerId,
        'status': orderStatus.raw,
        'total_price': totalPrice,
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
