import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
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

  void uploadRestaurantData({
    required File? restImage,
    required String restLogoImagePath,
    required String folderName,
    required String restImagePath,
    String? restownerIDImageFolderName,
    File? restIdImage,
    String? idImagePath,
    required File? restLogoimage,
    required String? restLogoFolder,
  }) {
    registerShopRepository.uploadrestaurantData(
      restLogoFolder: restLogoFolder,
      restownerIDImageFolderName: restownerIDImageFolderName,
      restIdImage: restIdImage ?? null,
      folderName: folderName,
      imagePath: restImagePath,
      restImage: restImage!,
      idimagePath: idImagePath,
      restName: ref.read(restaurantNameProvider) ?? '',
      address: ref.read(restaurantAddProvider) ?? '',
      deliveryArea: ref.read(restaurantDeliveryAreaProvider) ?? '',
      postalCode: ref.read(restaurantPostalCodeProvider) ?? '',
      description: ref.read(restaurantDescriptionProvider) ?? '',
      businessEmail: ref.read(restaurantEmailProvider) ?? '',
      idFirstName: ref.read(nicNumberFirstNameProvider) ?? '',
      idLastname: ref.read(nicNumberLastNameProvider) ?? '',
      idPhotoUrl: '',
      deliveryFee: ref.read(restaurantDeliveryFeeProvider) ?? 0.0,
      long: ref.read(restaurantLongProvider) ?? 0.0,
      lat: ref.read(restaurantLatProvider) ?? 0.0,
      minTime: ref.read(restaurantDeliveryMinTimeProvider) ?? 0,
      maxTime: ref.read(restaurantDeliveryMaxTimeProvider) ?? 0,
      phoneNumber: ref.read(restaurantPhoneNumberProvider) ?? 0,
      idNumber: ref.read(nicNumberProvider) ?? 0,
      openingHours: openinghours,
      restLogo: restLogoimage,
      restLogoImagePath: restLogoImagePath,
    );
  }

  Future<void> uploadPaymentDetails({
    String? userid,
    String? accountholdername,
    String? bankname,
    String? accountnumber,
    String? iban,
    String? swiftbccode,
    String? paypalemail,
    String? cardnumber,
    String? cvv,
    String? expirydate,
    String? businessname,
    String? businessaddress,
  }) async {
    try {
      await supabaseClient
          .from('payments')
          .insert({
            'user_id': userid ?? '',
            'accountHolderName': accountholdername ?? '',
            'bankName': bankname ?? '',
            'accountNumber': accountnumber ?? '',
            'iBan': iban ?? '',
            'swiftBcCode': swiftbccode ?? '',
            'paypalEmail': ref.read(paypalEmailProvider),
            'cardNumber': cardnumber ?? '',
            'cvv': cvv ?? '',
            'expiryDate': expirydate ?? '',
            'businessName': businessname ?? '',
            'businessAddress': businessaddress ?? '',
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

  Future<List<RestaurantData>?> fetchrestaurants(String? currentUserId) async {
    return await registerShopRepository.fetchRestaurant(currentUserId);
  }

  Future<List<String>?> fetchRestUid(String currentUserId) async {
    return await registerShopRepository.fetchRestUid(currentUserId);
  }
}
