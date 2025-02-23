class RestaurantData {
  String? restuid;
  String? restaurantName;
  int? deliveryFee;
  int? minTime;
  int? maxTime;
  double? averageRatings;
  // int? totalRatings;
  String? address;
  int? phoneNumber;
  String? deliveryArea;
  String? postalCode;
  int? idNumber;
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
  String? restaurantLogoImageUrl;

  RestaurantData copywith(
      {String? restaurantName,
      int? deliveryFee,
      int? minTime,
      int? maxTime,
      double? averageRatings,
      // int? totalRatings,
      String? address,
      int? phoneNumber,
      String? deliveryArea,
      String? postalCode,
      int? idNumber,
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
      averageRatings: averageRatings ?? this.averageRatings,
      // totalRatings: totalRatings ?? this.totalRatings,
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
    this.averageRatings,
    // this.totalRatings,
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
    this.restuid,
    this.restaurantLogoImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurantName': restaurantName,
      'deliveryFee': deliveryFee,
      'minTime': minTime,
      'maxTime': maxTime,
      'average_ratings': averageRatings,
      // 'total_ratngs': totalRatings,
      'address': address,
      'phoneNumber': phoneNumber,
      'deliveryArea': deliveryArea,
      'postalCode': postalCode,
      'idNumber': idNumber,
      'description': description,
      'lat': lat,
      'long': long,
      'businessEmail': email,
      'idFirstName': idFirstName,
      'idLastName': idLastName,
      //'userId': userId,
      'idPhotoUrl': idPhotoUrl,
      'paymentMethod': paymentMethod,
      'openingHours': openingHours,
      'restaurantImageUrl': restaurantImageUrl,
      'rest_uid': restuid,
      'restLogoUrl': restaurantLogoImageUrl,
    };
  }

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, dynamic>> openingHours = {};
    if (json['openingHours'] != null) {
      openingHours =
          Map<String, Map<String, dynamic>>.from(json['openingHours']);
    }

    return RestaurantData(
      restaurantName: json['restaurantName'] ?? '',
      deliveryFee: json['deliveryFee'] ?? 0.0,
      minTime: json['minTime'] ?? 0,
      maxTime: json['maxTime'] ?? 0,
      averageRatings: json['average_ratings'] ?? 0.0,
      // totalRatings: json['total_ratings'] ?? 0,
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      deliveryArea: json['deliveryArea'] ?? 0.0,
      postalCode: json['postalCode'] ?? '',
      idNumber: json['idNumber'] ?? 0,
      description: json['description'] ?? '',
      lat: json['lat'] ?? 0.0,
      long: json['long'] ?? 0.0,
      email: json['businessEmail'] ?? '',
      idFirstName: json['idFirstName'] ?? '',
      idLastName: json['idLastName'] ?? '',
      //userId: json['user_id'],
      idPhotoUrl: json['idPhotoUrl'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      openingHours: openingHours,
      restaurantImageUrl: json['restaurantImageUrl'] ?? '',
      //json['openinHours'],
      restuid: json['rest_uid'],
      restaurantLogoImageUrl: json['restLogoUrl'],
    );
  }
}
