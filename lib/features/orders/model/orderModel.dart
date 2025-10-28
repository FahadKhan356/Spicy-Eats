class Restaurant {
  final String id;
  final String name;
  final String image;
  final double deliveryfee;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final double rating;
  final String address;
  final double lat;
  final double lng;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant(
      {required this.id,
      required this.name,
      required this.image,
      required this.deliveryfee,
      required this.minDeliveryTime,
      required this.maxDeliveryTime,
      required this.rating,
      required this.address,
      required this.lat,
      required this.lng,
      required this.createdAt,
      required this.updatedAt});

//fromjson
  factory Restaurant.fromjson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      deliveryfee: json['deliveryFee'],
      minDeliveryTime: json['minDeliveryTime'] ?? 0,
      maxDeliveryTime: json['maxDeliveryTime'] ?? 0,
      rating: json['rating'].toDouble() ?? 0.0,
      address: json['address'] ?? '',
      lat: json['lat'].toDouble() ?? 0.0,
      lng: json['lng'].toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class User {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  User({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

//fromjson
  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      lat: json['lat'].toDouble() ?? 0.0,
      lng: json['lng'].toDouble() ?? 0.0,
    );
  }
}

class Orders {
  final String id;
  final String userID;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String orderRestaurantId;
  final Restaurant restaurant;
  final User user;

  Orders(
      {required this.user,
      required this.restaurant,
      required this.id,
      required this.userID,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.orderRestaurantId});

//fromjson
  factory Orders.fromjson(Map<String, dynamic> json) {
    return Orders(
      user: User.fromjson(json['User']),
      restaurant: Restaurant.fromjson(json['Restaurant']),
      id: json['id'] ?? '',
      userID: json['userID'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      orderRestaurantId: json['orderRestaurantId'] ?? '',
    );
  }
}
