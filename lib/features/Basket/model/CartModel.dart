class CartModel {
  final String itemName;
  final int itemId;
  int itemTotalQuantity;
  double? itemTotalPrice;
  String? cartItemImageUrl;

  CartModel({
    required this.itemName,
    required this.itemTotalPrice,
    required this.itemTotalQuantity,
    required this.itemId,
    required this.cartItemImageUrl,
  });
}
