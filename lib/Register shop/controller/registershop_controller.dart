import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/main.dart';

final registershopcontrollerProvider = Provider((ref) {
  final registershoprepo = ref.watch(registershoprepoProvider);
  return RegisterShopContoller(
      registerShopRepository: registershoprepo, ref: ref);
});

class RegisterShopContoller {
  RegisterShopRepository registerShopRepository;
  final ProviderRef ref;
  RegisterShopContoller({
    required this.registerShopRepository,
    required this.ref,
  });

  // void uploadrestaurantData() {
  //   registerShopRepository.uploadrestaurantData(
  //       restName: restaurantNameProvider,
  //       address: restaurantAddProvider,
  //       deliveryArea: restaurantDeliveryAreaProvider,
  //       postalCode: restaurantPostalCodeProvider,
  //       description: restaurantDescriptionProvider,
  //       businessEmail: restaurantEmailProvider,
  //       idFirstName: nicNumberFirstNameProvider,
  //       idLastname: nicNumberLastNameProvider,
  //       idPhotoUrl: '',
  //       restImgUrl: '',
  //       deliveryFee: restaurantDeliveryFeeProvider,
  //       long: restaurantLongProvider,
  //       lat: restaurantLatProvider,
  //       minTime: restaurantDeliveryMinTimeProvider,
  //       maxTime: restaurantDeliveryMaxTimeProvider,
  //       phoneNumber: restaurantPhoneNumberProvider,
  //       idNumber: nicNumberProvider,
  //       openingHours: openinghours);
  // }
  void uploadRestaurantData() {
    registerShopRepository.uploadrestaurantData(
      restName: ref.read(restaurantNameProvider) ?? '',
      address: ref.read(restaurantAddProvider) ?? '',
      deliveryArea: ref.read(restaurantDeliveryAreaProvider) ?? '',
      postalCode: ref.read(restaurantPostalCodeProvider) ?? '',
      description: ref.read(restaurantDescriptionProvider) ?? '',
      businessEmail: ref.read(restaurantEmailProvider) ?? '',
      idFirstName: ref.read(nicNumberFirstNameProvider) ?? '',
      idLastname: ref.read(nicNumberLastNameProvider) ?? '',
      idPhotoUrl: '',
      restImgUrl: '',
      deliveryFee: ref.read(restaurantDeliveryFeeProvider) ?? 0.0,
      long: ref.read(restaurantLongProvider) ?? 0.0,
      lat: ref.read(restaurantLatProvider) ?? 0.0,
      minTime: ref.read(restaurantDeliveryMinTimeProvider) ?? 0,
      maxTime: ref.read(restaurantDeliveryMaxTimeProvider) ?? 0,
      phoneNumber: ref.read(restaurantPhoneNumberProvider) ?? 0,
      idNumber: ref.read(nicNumberProvider) ?? 0,
      openingHours: openinghours,
    );
  }

  Future<void> uploadPaymentDetails({
    userid,
    accountholdername,
    bankname,
    accountnumber,
    iban,
    swiftbccode,
    paypalaccountemail,
    cardnumber,
    cvv,
    expirydate,
    businessname,
    businessaddress,
  }) async {
    try {
      await supabaseClient
          .from('payments')
          .insert({
            'user_id': userid,
            'accountHolderName': accountholdername,
            'bankName': bankname,
            'accountNumber': accountnumber,
            'iBan': iban,
            'swiftBcCode': swiftbccode,
            'paypalAccountEmail': paypalaccountemail,
            'cardNumber': cardnumber,
            'cvv': cvv,
            'expiryDate': expirydate,
            'businessName': businessname,
            'businessAddress': businessaddress,
          })
          .then((value) => print("Inserted successfully: $value"))
          .catchError((error) {
            print("Insert failed: $error");
          });
    } catch (e) {
      print('Exception during insert');
      print(e.toString());
    }
  }
}
