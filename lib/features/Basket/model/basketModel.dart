class BasketModel {
  final String itemName;
  final int itemId;
  int itemTotalQuantity;
  double? itemTotalPrice;
  String? cartItemImageUrl;

  BasketModel({
    required this.itemName,
    required this.itemTotalPrice,
    required this.itemTotalQuantity,
    required this.itemId,
    required this.cartItemImageUrl,
  });
}
