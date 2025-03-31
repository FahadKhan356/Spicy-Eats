import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Payment/utils/optionsModel.dart';
import 'package:spicy_eats/main.dart';

var paymentRepProvider = Provider((ref) => PaymentRepo());

class PaymentRepo {
  List<PaymentOptions> paymentoption = [
    PaymentOptions(
        option: 'Cash on Delivery',
        imagurl:
            'https://toppng.com/uploads/preview/see-the-source-image-cash-on-delivery-now-available-11563353301vi2pno7jfy.png'),
    PaymentOptions(
      option: 'Credit or Debit Card',
      imagurl:
          'https://cdn2.iconfinder.com/data/icons/business-finance-material-flat-design/24/Pay-With_Master_Card-512.png',
    ),
  ];

  Map<String, dynamic>? paymentintenddata = {};

  showpaymentsheet(
      BuildContext context, WidgetRef ref, List<CartModelNew> cart) async {
    try {
      final paymentResult =
          await Stripe.instance.presentPaymentSheet().then((value) {
        paymentintenddata = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error.toString() + stackTrace.toString());
        }
      });
      if (paymentResult.status == PaymentIntentsStatus.Succeeded) {
        clearingcart(ref: ref, cart: cart, context: context);
        Navigator.pushNamed(context, Home.routename);

        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text('order placed Successfully'),
        //   behavior: SnackBarBehavior.floating,
        //   margin: EdgeInsets.only(bottom: 150),
        // ));
      }
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
      required BuildContext context,
      required WidgetRef ref,
      required List<CartModelNew> cart}) async {
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
        style: ThemeMode.light,
        merchantDisplayName: 'any company',
      ))
          .then((value) {
        print(value);
      });

      showpaymentsheet(context, ref, cart);
    } catch (e) {
      print(e);
    }
  }

// for clearing cart adding order data and navigate to main screen
  Future<void> clearingcart({
    required WidgetRef ref,
    required List<CartModelNew> cart,
    required BuildContext context,
  }) async {
    try {
      if (cart.isEmpty) return;

      final cartids = cart.map((e) => e.cart_id).toList();

      await supabaseClient.from('cart').delete().inFilter('id', cartids);

      ref.read(cartProvider.notifier).update((state) {
        return state
            .where((element) => !cartids.contains(element.cart_id))
            .toList();
      });

      // Navigator.pushNamed(
      //   context,
      //   Home.routename,
      // );
    } catch (e) {
      throw Exception(e);
    }
  }
}
