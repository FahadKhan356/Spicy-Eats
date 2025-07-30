import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/Register%20shop/widgets/paymenttextfields.dart';
import 'package:spicy_eats/main.dart';

var paymentMethodProvider = StateProvider<String?>((ref) => null);
final accountHolderNameProvider = StateProvider<String>((ref) => '');
final bankNameProvider = StateProvider<String>((ref) => '');
final accountNumberProvider = StateProvider<String>((ref) => '');
final ibanProvider = StateProvider<String>((ref) => '');
final swiftBcCodeProvider = StateProvider<String>((ref) => '');

final paypalEmailProvider = StateProvider<String?>((ref) => null);

final cardNumberProvider = StateProvider<String>((ref) => '');
final expiryDateProvider = StateProvider<String>((ref) => '');
final cvvProvider = StateProvider<String>((ref) => '');

final businessNameProvider = StateProvider<String>((ref) => '');
final businessAddressProvider = StateProvider<String>((ref) => '');

class PaymentMethodScreen extends ConsumerStatefulWidget {
  static const String routename = '/payment-methods';
  final List<RestaurantModel>? restaurants;

  const PaymentMethodScreen({
    required this.restaurants,
    super.key,
  });
  // PaymentMethodScreen({
  //   //required this.image
  //   });
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Bank Transfer';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final restImg = ref.read(restImageFileProvider);
    final restLogo = ref.read(restLogoFileProvider);
    final height = MediaQuery.of(context).size.height;
    final registerShopContoller = ref.watch(registershopcontrollerProvider);

    // //Bank fields
    // String accountHoldername = '';
    // String bankname = '';
    // String accountNumber = '';
    // String iBan = '';
    // String swiftBcCode = '';

    // //paypal fields
    final paypalEmail = TextEditingController();

    // //Credit Card fields
    // String cardNumber = '';
    // String expiryDate = '';
    // String cvv = '';

    // //common fields
    // String businessName = '';
    // String businessAddress = '';
    // //final taxIdVat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Method Selection
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue!;
                    });

                    ref.read(paymentMethodProvider.notifier).state =
                        _selectedPaymentMethod;
                  },
                  items: <String>[
                    'Bank Transfer',
                    'PayPal',
                    'Credit/Debit Card'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                  ),
                ),
                const SizedBox(height: 20),

                // Conditional Fields based on Payment Method
                if (_selectedPaymentMethod == 'Bank Transfer') ...[
                  paymentTextfields(
                      label: 'Account Holder’s Name',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account holder’s name';
                        }
                        ref.watch(accountHolderNameProvider.notifier).state =
                            value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'Bank Name',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bank name';
                        }
                        ref.watch(bankNameProvider.notifier).state = value;

                        return null;
                      }),
                  paymentTextfields(
                      label: 'Account Number',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        ref.watch(accountNumberProvider.notifier).state = value;

                        return null;
                      }),
                  paymentTextfields(
                      label: 'IBAN',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter IBAN';
                        }
                        ref.watch(ibanProvider.notifier).state = value;

                        return null;
                      }),
                  paymentTextfields(
                      label: 'SWIFT/BIC Code',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter SWIFT/BIC Code';
                        }
                        ref.watch(swiftBcCodeProvider.notifier).state = value;

                        return null;
                      }),
                  const SizedBox(height: 20),
                ] else if (_selectedPaymentMethod == 'PayPal') ...[
                  TextFormField(
                    controller: paypalEmail,
                    validator: (value) {
                      // if (paypalEmail.text.isEmpty) {
                      //   return 'Please enter PayPal email';
                      // }
                      ref.watch(paypalEmailProvider.notifier).state =
                          paypalEmail.text;

                      return null;
                    },
                    // label: 'PayPal Account Email',
                    // onvalidator: (value) {

                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter PayPal email';
                    //   }
                    //ref.watch(paypalEmailProvider.notifier).state = value;

                    //return null;
                    //}
                  ),
                  const SizedBox(height: 20),
                ] else if (_selectedPaymentMethod == 'Credit/Debit Card') ...[
                  paymentTextfields(
                      label: 'Card Number',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        ref.watch(cardNumberProvider.notifier).state = value;

                        return null;
                      }),
                  paymentTextfields(
                      label: 'Expiry Date (MM/YY)',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        ref.watch(expiryDateProvider.notifier).state = value;

                        return null;
                      }),
                  paymentTextfields(
                      label: 'CVV',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        ref.watch(cvvProvider.notifier).state = value;
                        return null;
                      }),
                  const SizedBox(height: 20),
                ],

                // Business Information
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Business Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter business name';
                      }
                      ref.watch(businessNameProvider.notifier).state = value;
                      return null;
                    }),

                TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Business Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter business address';
                      }
                      ref.watch(businessAddressProvider.notifier).state = value;
                      return null;
                    }),

                // TextFormField(
                //   decoration:
                //       const InputDecoration(labelText: 'Tax ID/VAT Number'),
                //   validator: (value) => value == null || value.isEmpty
                //       ? 'Please enter tax ID'
                //       : null,
                // ),
                const SizedBox(height: 20),

                // Upload Verification Documents
                // ElevatedButton(
                //   onPressed: () {
                //     // Handle file upload
                //     Navigator.pushNamed(context, ShopHome.routename);
                //   },
                //   child: const Text('Upload Verification Documents'),
                // ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission
                        if (_selectedPaymentMethod == 'Bank Transfer') {
                          registerShopContoller.uploadPaymentDetails(
                            userid: supabaseClient.auth.currentUser!.id,
                            accountholdername:
                                ref.read(accountHolderNameProvider),
                            bankname: ref.read(bankNameProvider),
                            accountnumber: ref.read(accountNumberProvider),
                            iban: ref.read(ibanProvider),
                            swiftbccode: ref.read(swiftBcCodeProvider),
                            businessname: ref.read(businessNameProvider),
                            businessaddress: ref.read(businessAddressProvider),
                          );
                        } else if (_selectedPaymentMethod == 'Paypal') {
                          registerShopContoller.uploadPaymentDetails(
                            userid: supabaseClient.auth.currentUser!.id,
                            paypalemail:
                                'paypal@aghasdgjasd', //ref.read(paypalEmailProvider),
                            businessname: ref.read(businessNameProvider),
                            businessaddress: ref.read(businessAddressProvider),
                          );
                        } else {
                          registerShopContoller.uploadPaymentDetails(
                            userid: supabaseClient.auth.currentUser!.id,
                            cardnumber: ref.read(cardNumberProvider),
                            expirydate: ref.read(expiryDateProvider),
                            cvv: ref.read(cvvProvider),
                            businessname: ref.read(businessNameProvider),
                            businessaddress: ref.read(businessAddressProvider),
                          );
                        }
                        /*checking if there is alread restaurant exist for user 
                      if ues then we upload bussnessinformation screen data from here
                      because we have to skip legalinformationscreen as id of owner is already exist
                      in the record of supabase*/
                        if (widget.restaurants != null) {
                          final timestamp =
                              DateTime.now().millisecondsSinceEpoch;
                          String userId = supabaseClient.auth.currentUser!.id;
                          registerShopContoller.uploadRestaurantData(
                            restLogoimage: restLogo,
                            restLogoFolder: 'Restaurant_Registeration',
                            restLogoImagePath:
                                '/$userId/$timestamp/Restaurant_Logo',
                            restImage: restImg,
                            folderName: 'Restaurant_Registeration',
                            restImagePath:
                                '/$userId/$timestamp/Restaurant_covers',
                            // restownerIDImageFolderName:
                            //     'Restaurant_Registeration',
                            //restIdImage: ,
                            //idImagePath: '/$userId/Restaurant_ownerIds',
                          );
                        }

                        print(
                            'this is paypal email ${ref.read(paypalEmailProvider)}');
                        Navigator.pushNamed(context, ShopHome.routename);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        backgroundColor: Colors.black),
                    child: Text(
                      'Save Payment Information',
                      style: TextStyle(
                          fontSize: height * 0.02, color: Colors.white),
                    ),
                  ),
                ),
                // Submit Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
