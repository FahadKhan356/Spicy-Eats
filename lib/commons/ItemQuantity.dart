class ItemQuantity {
  int id;
  int quantity;

  ItemQuantity({required this.id, this.quantity = 0});

  ItemQuantity copyWith({
    int? id,
    int? quantity,
  }) {
    return ItemQuantity(id: id ?? this.id, quantity: quantity ?? this.quantity);
  }
}
