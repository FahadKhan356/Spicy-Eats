import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/utils/RestaurantDataSingleton.dart';

class RegisterShopContoller {
  final RegisterShopRepository registerShopRepository =
      RegisterShopRepository();

  // Future<void> setrestaurantdata() async {
  //   final restaurantData = RestaurantData(
  //     restaurantName: 'Pizza Place',
  //     deliveryFee: 2.5,
  //     minTime: 30,
  //     maxTime: 45,
  //     ratings: 4.8,
  //     address: '123 Pizza Lane',
  //     phoneNumber: 1234567890,
  //     deliveryArea: 'Downtown',
  //     postalCode: '12345',
  //     idNumber: 'ID123456',
  //     description: 'Best pizza in town!',
  //     lat: 40.7128,
  //     long: -74.0060,
  //     email: 'contact@pizzaplace.com',
  //     idFirstName: 'John',
  //     idLastName: 'Doe',
  //     // userId: '',
  //     idPhotoUrl: '',
  //     paymentMethod: '',
  //     openingHours: {},
  //   );

  //   try {
  //     await registerShopRepository.setrestaurantdata(restaurantData);
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  void updatePage1(
      {String? email, name, address, int? phoneno, double? lat, long}) {
    RestaurantDataSingleton().email = email;
    RestaurantDataSingleton().restaurantName = name;
    RestaurantDataSingleton().address = address;
    RestaurantDataSingleton().phoneNumber = phoneno;
    RestaurantDataSingleton().lat = lat;
    RestaurantDataSingleton().long = long;
  }

  void updatePage2({
    String? description,
    deliveryarea,
    postalcode,
    double? deliveryfee,
    int? mintime,
    maxtime,
    Map<String, Map<String, dynamic>>? openhours,
  }) {
    RestaurantDataSingleton().description = description;
    RestaurantDataSingleton().deliveryArea = deliveryarea;
    RestaurantDataSingleton().postalCode = postalcode;
    RestaurantDataSingleton().deliveryFee = deliveryfee;
    RestaurantDataSingleton().minTime = mintime;
    RestaurantDataSingleton().maxTime = maxtime;
    RestaurantDataSingleton().openingHours = openhours;
  }

  void updatePage3({
    String? idfirstname,
    idlastname,
    imgurl,
    idcardno,
  }) {
    RestaurantDataSingleton().idNumber = idcardno;
    RestaurantDataSingleton().idFirstName = idfirstname;
    RestaurantDataSingleton().idLastName = idlastname;
    RestaurantDataSingleton().restaurantImageUrl = imgurl;
  }
}
