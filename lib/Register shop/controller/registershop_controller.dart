import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';

class RegisterShopContoller {
  final RegisterShopRepository registerShopRepository =
      RegisterShopRepository();

  Future<void> setrestaurantdata() async {
    final restaurantData = RestaurantData(
      restaurantName: 'Pizza Place',
      deliveryFee: 2.5,
      minTime: 30,
      maxTime: 45,
      ratings: 4.8,
      address: '123 Pizza Lane',
      phoneNumber: 1234567890,
      deliveryArea: 'Downtown',
      postalCode: '12345',
      idNumber: 'ID123456',
      description: 'Best pizza in town!',
      lat: 40.7128,
      long: -74.0060,
      email: 'contact@pizzaplace.com',
      idFirstName: 'John',
      idLastName: 'Doe',
      // userId: '',
      idPhotoUrl: '',
      paymentMethod: '',
      openingHours: {},
    );

    try {
      await registerShopRepository.setrestaurantdata(restaurantData);
    } catch (e) {
      throw e.toString();
    }
  }
}
