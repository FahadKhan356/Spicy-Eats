// ignore: file_names
class Dish {
  final String name;
  final String description;
  final double price;
  final String? image;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  factory Dish.fromjson(Map<String, dynamic> json) {
    return Dish(
        name: json["name"] ?? '',
        description: json["description"] ?? 'sddsd',
        price: json["price"] ?? 0.0,
        image: json['image'] ?? '');
  }
}

class Restaurant {
  final String id;
  final String name;
  final double deliveryFee;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final double rating;
  final String image;
  final List<Dish> dishes;

  Restaurant({
    required this.id,
    required this.name,
    required this.deliveryFee,
    required this.minDeliveryTime,
    required this.maxDeliveryTime,
    required this.rating,
    required this.image,
    required this.dishes,
  });
  factory Restaurant.fromjson(Map<String, dynamic> json) {
    final dishesJson = json['dishes'] as List?;
    final List<Dish> dishesList =
        dishesJson?.map((i) => Dish.fromjson(i)).toList() ?? [];
    // var list = json['dishes'] as List;
    // List<Dish> dishesList = list.map((i) => Dish.fromjson(i)).toList();

    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      deliveryFee: json['deliveryFee'].toDouble() ?? 0.0,
      minDeliveryTime: json['minDeliveryTime'] ?? '',
      maxDeliveryTime: json['maxDeliveryTime'] ?? '',
      rating: json['rating'].toDouble() ?? 0.0,
      image: json['image'] ?? '',
      dishes: dishesList,
    );
  }
}
