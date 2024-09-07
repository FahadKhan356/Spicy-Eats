import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/Register%20shop/widgets/paymenttextfields.dart';

var paymentMethodProvider = StateProvider<String?>((ref) => null);

class PaymentMethodScreen extends ConsumerStatefulWidget {
  // final File? image;
  static const String routename = '/payment-methods';

  const PaymentMethodScreen({super.key});
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
    final height = MediaQuery.of(context).size.height;
    final registerShopContoller = ref.watch(registershopcontrollerProvider);

    //Bank fields
    var accountHoldername;
    var bankname;
    var accountNumber;
    var iBan;
    var swiftBcCode;

    //paypal fields
    var paypalAccountEmail;

    //Credit Card fields
    var cardNumber;
    var expiryDate;
    var cvv;

    //common fields
    var businessName;
    var businessAddress;
    //final taxIdVat;

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
                        accountHoldername = value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'Bank Name',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bank name';
                        }
                        bankname = value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'Account Number',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        accountNumber = value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'IBAN',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter IBAN';
                        }
                        iBan = value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'SWIFT/BIC Code',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter SWIFT/BIC Code';
                        }
                        swiftBcCode = value;
                        return null;
                      }),
                  const SizedBox(height: 20),
                ] else if (_selectedPaymentMethod == 'PayPal') ...[
                  paymentTextfields(
                      label: 'PayPal Account Email',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter PayPal email';
                        }
                        paypalAccountEmail = value;
                        return null;
                      }),
                  const SizedBox(height: 20),
                ] else if (_selectedPaymentMethod == 'Credit/Debit Card') ...[
                  paymentTextfields(
                      label: 'Card Number',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        cardNumber = value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'Expiry Date (MM/YY)',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        expiryDate = value;
                        return null;
                      }),
                  paymentTextfields(
                      label: 'CVV',
                      onvalidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        cvv = value;
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
                      businessName = value;
                      return null;
                    }),

                TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Business Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter business address';
                      }
                      businessAddress = value;
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
                            accountholdername: accountHoldername,
                            bankname: bankname,
                            accountnumber: accountNumber,
                            iban: iBan,
                            swiftbccode: swiftBcCode,
                            businessname: businessName,
                            businessaddress: businessAddress,
                          );
                        } else if (_selectedPaymentMethod == 'Paypal') {
                          registerShopContoller.uploadPaymentDetails(
                            paypalaccountemail: paypalAccountEmail,
                            businessname: businessName,
                            businessaddress: businessAddress,
                          );
                        } else {
                          registerShopContoller.uploadPaymentDetails(
                            cardnumber: cardNumber,
                            expirydate: expiryDate,
                            cvv: cvv,
                            businessname: businessName,
                            businessaddress: businessAddress,
                          );
                        }
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
