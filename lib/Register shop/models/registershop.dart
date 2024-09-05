class RestaurantData {
  String? restaurantName;
  double? deliveryFee;
  int? minTime;
  int? maxTime;
  double? ratings;
  String? address;
  int? phoneNumber;
  String? deliveryArea;
  String? postalCode;
  String? idNumber;
  String? description;
  double? lat;
  double? long;
  String? email;
  String? idFirstName;
  String? idLastName;
  String? idPhotoUrl;
  String? userId;
  String? paymentMethod;
  Map<String, Map<String, dynamic>>? openingHours;
  String? restaurantImageUrl;

  RestaurantData copywith(
      {String? restaurantName,
      double? deliveryFee,
      int? minTime,
      int? maxTime,
      double? ratings,
      String? address,
      int? phoneNumber,
      String? deliveryArea,
      String? postalCode,
      String? idNumber,
      String? description,
      double? lat,
      double? long,
      String? email,
      String? idFirstName,
      String? idLastName,
      String? idPhotoUrl,
      String? userId,
      String? paymentMethod,
      Map<String, Map<String, dynamic>>? openingHours,
      String? restaurantImageUrl}) {
    return RestaurantData(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      restaurantName: restaurantName ?? this.restaurantName,
      ratings: ratings ?? this.ratings,
      email: email ?? this.email,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      description: description ?? this.description,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minTime: minTime ?? this.minTime,
      maxTime: maxTime ?? this.maxTime,
      deliveryArea: deliveryArea ?? this.deliveryArea,
      postalCode: postalCode ?? this.postalCode,
      idNumber: idNumber ?? this.idNumber,
      idFirstName: idFirstName ?? this.idFirstName,
      idLastName: idLastName ?? this.idLastName,
      //userId: userId ?? this.userId,
      idPhotoUrl: idPhotoUrl ?? this.idPhotoUrl,
      openingHours: openingHours ?? this.openingHours,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
    );
  }

  RestaurantData({
    this.phoneNumber,
    this.address,
    this.restaurantName,
    this.ratings,
    this.email,
    this.lat,
    this.long,
    this.description,
    this.deliveryFee,
    this.minTime,
    this.maxTime,
    this.deliveryArea,
    this.postalCode,
    this.idNumber,
    this.idFirstName,
    this.idLastName,
    //this.userId,
    this.idPhotoUrl,
    this.openingHours,
    this.paymentMethod,
    this.restaurantImageUrl,
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
      //'userId': userId,
      'idPhotoUrl': idPhotoUrl,
      'paymentMethod': paymentMethod,
      'openingHours': openingHours,
      'restaurantImageUrl': restaurantImageUrl,
    };
  }

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, dynamic>> openingHours = {};
    if (json['openingHours'] != null) {
      openingHours =
          Map<String, Map<String, dynamic>>.from(json['openingHours']);
    }

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
      //userId: json['user_id'],
      idPhotoUrl: json['idPhotoUrl'],
      paymentMethod: json['paymentMethod'],
      openingHours: openingHours,
      restaurantImageUrl: json['restaurantImageUrl'],
      //json['openinHours'],
    );
  }
}
