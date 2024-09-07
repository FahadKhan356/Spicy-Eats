class RestaurantDataSingleton {
  static final RestaurantDataSingleton _instance =
      RestaurantDataSingleton._internal();

  factory RestaurantDataSingleton() {
    return _instance;
  }

  RestaurantDataSingleton._internal();

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

  void reset() {
    restaurantName = null;
    deliveryFee = null;
    minTime = null;
    maxTime = null;
    ratings = null;
    address = null;
    phoneNumber = null;
    deliveryArea = null;
    postalCode = null;
    idNumber = null;
    description = null;
    lat = null;
    long = null;
    email = null;
    idFirstName = null;
    idLastName = null;
    idPhotoUrl = null;
    userId = null;
    paymentMethod = null;
    openingHours = null;
    restaurantImageUrl = null;
  }
}
