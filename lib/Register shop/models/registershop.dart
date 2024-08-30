class RestaurantData {
  String restaurantName;
  double deliveryFee;
  int minTime;
  int maxTime;
  double ratings;
  String address;
  int phoneNumber;
  String deliveryArea;
  String postalCode;
  String idNumber;
  String description;
  double lat;
  double long;
  String email;
  String idFirstName;
  String idLastName;

  RestaurantData({
    required this.phoneNumber,
    required this.address,
    required this.restaurantName,
    required this.ratings,
    required this.email,
    required this.lat,
    required this.long,
    required this.description,
    required this.deliveryFee,
    required this.minTime,
    required this.maxTime,
    required this.deliveryArea,
    required this.postalCode,
    required this.idNumber,
    required this.idFirstName,
    required this.idLastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurantName': restaurantName,
      'deliveryFee': deliveryFee,
      'minTime': minTime,
      'maxTime': maxTime,
      'ratings': ratings,
      'address': address,
      'phoneNumber': phoneNumber,
      'deliveryArea': deliveryArea,
      'postalCode': postalCode,
      'idNumber': idNumber,
      'description': description,
      'lat': lat,
      'long': long,
      'email': email,
      'idFirstName': idFirstName,
      'idLastName': idLastName,
    };
  }

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      restaurantName: json['restaurantName'],
      deliveryFee: json['deliveryFee'],
      minTime: json['minTime'],
      maxTime: json['maxTime'],
      ratings: json['ratings'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      deliveryArea: json['deliveryArea'],
      postalCode: json['postalCode'],
      idNumber: json['idNumber'],
      description: json['description'],
      lat: json['lat'],
      long: json['long'],
      email: json['email'],
      idFirstName: json['idFirstName'],
      idLastName: json['idLastName'],
    );
  }
}
