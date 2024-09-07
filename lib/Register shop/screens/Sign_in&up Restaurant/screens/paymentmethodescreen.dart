import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/Register%20shop/widgets/paymenttextfields.dart';

class PaymentMethodScreen extends StatefulWidget {
  // final File? image;
  static const String routename = '/payment-methods';

  const PaymentMethodScreen({super.key});
  // PaymentMethodScreen({
  //   //required this.image
  //   });
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'Bank Transfer';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter account holder’s name'
                        : null,
                  ),
                  paymentTextfields(
                    label: 'Bank Name',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter bank name'
                        : null,
                  ),
                  paymentTextfields(
                    label: 'Account Number',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter account number'
                        : null,
                  ),
                  paymentTextfields(
                    label: 'IBAN',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter IBAN'
                        : null,
                  ),
                  paymentTextfields(
                    label: 'SWIFT/BIC Code',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter SWIFT/BIC Code'
                        : null,
                  ),
                  const SizedBox(height: 20),
                ] else if (_selectedPaymentMethod == 'PayPal') ...[
                  paymentTextfields(
                    label: 'PayPal Account Email',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter PayPal email'
                        : null,
                  ),
                  const SizedBox(height: 20),
                ] else if (_selectedPaymentMethod == 'Credit/Debit Card') ...[
                  paymentTextfields(
                    label: 'Card Number',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter card number'
                        : null,
                  ),
                  paymentTextfields(
                    label: 'Expiry Date (MM/YY)',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter expiry date'
                        : null,
                  ),
                  paymentTextfields(
                    label: 'CVV',
                    onvalidator: (value) => value == null || value.isEmpty
                        ? 'Please enter CVV'
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],

                // Business Information
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Business Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter business name'
                      : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Business Address'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter business address'
                      : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Tax ID/VAT Number'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter tax ID'
                      : null,
                ),
                const SizedBox(height: 20),

                // Upload Verification Documents
                ElevatedButton(
                  onPressed: () {
                    // Handle file upload
                    Navigator.pushNamed(context, ShopHome.routename);
                  },
                  child: const Text('Upload Verification Documents'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle form submission
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
