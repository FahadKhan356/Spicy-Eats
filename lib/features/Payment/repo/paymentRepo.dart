import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

var paymentRepProvider = Provider((ref) => PaymentRepo());

class PaymentRepo {
  Map<String, dynamic>? paymentintenddata = {};

  showpaymentsheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        paymentintenddata = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error.toString() + stackTrace.toString());
        }
      });
    } on StripeException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text('Cancel'),
              ));
    } catch (e) {
      print(e);
    }
  }

  createintentpayment(double amount, String currency) async {
    try {
      Map<String, dynamic>? paymentinfo = {
        'amount': (amount * 100).toInt().toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print("Sending Payment Intent Request: $paymentinfo");
      var res = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: paymentinfo,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
            'Content-Type': 'application/x-www-form-urlencoded',
          });

      print("Stripe API Response: ${res.body}");
      if (res.statusCode != 200) {
        print("Error: Payment Intent API call failed");
        return null; // Ensure it doesn't proceed with invalid data
      }
      return jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> paymentSheetInitializtion(
      {required double amount,
      required String currency,
      required BuildContext context}) async {
    try {
      print(
          "Initializing payment sheet with amount: $amount, currency: $currency");
      paymentintenddata = await createintentpayment(amount, currency);

      if (paymentintenddata == null ||
          !paymentintenddata!.containsKey('client_secret')) {
        print("Error: Payment Intent data is null or invalid");
        return;
      }

      print("Received Payment Intent Data: $paymentintenddata");
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: paymentintenddata!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: 'any company',
      ))
          .then((value) {
        print(value);
      });

      showpaymentsheet(context);
    } catch (e) {
      print(e);
    }
  }
}
