import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/orders/model/orderModel.dart';
import 'package:spicy_eats/features/orders/repo/orderRepo.dart';
import 'package:spicy_eats/main.dart';

/// Where the repo reads from. A seam so the screen can be tested without a
/// network round trip.
abstract class OrderStore {
  Future<List<CustomerOrder>> fetchOrders({required String userId});
}

class OrdersState {
  final List<CustomerOrder> orders;
  final bool isLoading;
  final String? error;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  bool get hasLoaded => !isLoading && error == null;

  OrdersState copyWith({
    List<CustomerOrder>? orders,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final orderListProvider =
    StateNotifierProvider<OrderListNotifier, OrdersState>((ref) {
  return OrderListNotifier(ref.read(orderRepoProvider));
});

class OrderListNotifier extends StateNotifier<OrdersState> {
  OrderListNotifier(this._store) : super(const OrdersState());

  final OrderStore _store;
  String? _loadedUserId;

  /// Reads the signed in user's orders. Safe to call on every visit; the
  /// first call for a given user is the one that hits the network.
  Future<void> load({bool force = false, String? userId}) async {
    final resolved = userId ?? supabaseClient.auth.currentUser?.id;
    if (resolved == null || resolved.isEmpty) {
      // Nobody signed in, so there is nothing to read. Stop the spinner but
      // leave the list alone: clobbering it would throw away state that is
      // still on screen.
      if (state.isLoading) state = state.copyWith(isLoading: false);
      return;
    }
    if (!force && _loadedUserId == resolved && state.hasLoaded) return;

    _loadedUserId = resolved;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final orders = await _store.fetchOrders(userId: resolved);
      state = OrdersState(orders: orders);
    } catch (e) {
      state =
          const OrdersState(orders: [], error: 'Could not load orders');
    }
  }
}
