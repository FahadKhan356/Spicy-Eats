import 'dart:convert';

/// Status stored on an `orders` row. Older rows and the checkout both write
/// different capitalisations, so parsing is case insensitive.
enum OrderStatus {
  pending('pending', 'Pending'),
  delivered('delivered', 'Delivered'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled'),
  unknown('', 'Processing');

  const OrderStatus(this.raw, this.label);

  /// Value as stored in the database. Empty for [unknown].
  final String raw;

  /// What the user sees.
  final String label;

  static OrderStatus parse(Object? value) {
    final normalized = (value?.toString() ?? '').trim().toLowerCase();
    for (final status in OrderStatus.values) {
      if (status != OrderStatus.unknown && status.raw == normalized) {
        return status;
      }
    }
    // Rows written before the status column was filled in, or a status this
    // build does not know about, both land here rather than throwing.
    return OrderStatus.unknown;
  }
}

/// A selected variation on an ordered item. The `variation` column is stored
/// as a JSON string on `orders`, unlike the list shape it has in the cart.
class OrderedVariation {
  final int? id;
  final String name;
  final double price;

  const OrderedVariation({this.id, required this.name, required this.price});

  factory OrderedVariation.fromJson(Map<String, dynamic> json) {
    return OrderedVariation(
      id: (json['id'] as num?)?.toInt(),
      name: json['variation_name'] ?? json['variationName'] ?? '',
      price: (json['variation_price'] as num?)?.toDouble() ??
          (json['variationPrice'] as num?)?.toDouble() ??
          0,
    );
  }

  String get label => price == 0 ? name : '$name +\$${price.toStringAsFixed(2)}';

  /// Variations arrive as a JSON string, but be lenient about a list or a null
  /// rather than throwing on a malformed row.
  static List<OrderedVariation> parseAll(dynamic raw) {
    dynamic decoded = raw;
    if (raw is String) {
      if (raw.trim().isEmpty) return const [];
      try {
        decoded = jsonDecode(raw);
      } catch (_) {
        return const [];
      }
    }
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((item) => OrderedVariation.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

/// One line of an order, stored inside the `orderedItems` jsonb column.
class OrderedItem {
  final int? id;
  final int? dishId;
  final String name;
  final String description;
  final String image;
  final double itemPrice;
  final double lineTotal;
  final int quantity;
  final List<OrderedVariation> variations;

  const OrderedItem({
    this.id,
    this.dishId,
    required this.name,
    required this.description,
    required this.image,
    required this.itemPrice,
    required this.lineTotal,
    required this.quantity,
    this.variations = const [],
  });

  factory OrderedItem.fromJson(Map<String, dynamic> json) {
    return OrderedItem(
      id: (json['id'] as num?)?.toInt(),
      dishId: (json['dish_id'] as num?)?.toInt(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      itemPrice:
          (json['itemprice'] as num?)?.toDouble() ?? (json['tprice'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['tprice'] as num?)?.toDouble() ??
          (json['itemprice'] as num?)?.toDouble() ??
          0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      variations: OrderedVariation.parseAll(json['variation']),
    );
  }

  /// Line total, recomputed from the unit price and quantity.
  ///
  /// `tprice` is not trustworthy on its own: rows written before the checkout
  /// persisted totals stored the *unit* price in it while also carrying a
  /// quantity greater than one. `itemprice * quantity` is correct for both
  /// those rows and for properly written ones, where `tprice` already equals
  /// this product.
  double get payableTotal => itemPrice * quantity;
}

/// A row of the `orders` table.
class CustomerOrder {
  final int? id;
  final String userId;
  final String restaurantName;
  final String deliveredTo;
  final String payType;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final List<OrderedItem> items;

  const CustomerOrder({
    this.id,
    required this.userId,
    required this.restaurantName,
    required this.deliveredTo,
    required this.payType,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    final rawItems = json['orderedItems'];
    return CustomerOrder(
      id: (json['id'] as num?)?.toInt(),
      userId: json['user_id'] ?? '',
      restaurantName: json['orderedFrom'] ?? '',
      deliveredTo: (json['deliveredTo'] ?? '').toString().trim(),
      payType: json['payType'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.parse(json['status']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map((item) =>
                  OrderedItem.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get itemCountLabel =>
      '$itemCount item${itemCount == 1 ? '' : 's'}';

  /// Total to show: the stored total, or the sum of the lines when it is
  /// missing so a legacy row still shows a sensible amount.
  double get payableTotal {
    if (totalPrice > 0) return totalPrice;
    return items.fold(0, (sum, item) => sum + item.payableTotal);
  }

  bool get canReorder => items.isNotEmpty;

  /// "3 items" style summary built from the real lines.
  String get itemsSummary {
    if (items.isEmpty) return 'No items';
    if (items.length == 1) {
      final only = items.first;
      return only.quantity > 1
          ? '${only.quantity}x ${only.name}'
          : only.name;
    }
    return '${items.length} items';
  }
}
