import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/features/Payment/repo/ProfileRepo.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  static const String routename = '/Payment-screen';
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  var cartTotal = 0.0;

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantProvider);

    final subTotal = ref.read(DummyLogicProvider).getTotalPrice(ref);
    cartTotal = subTotal + restaurant!.deliveryFee! + restaurant.platformfee!;

    final cart = ref.watch(cartProvider);
    //final restaurant = ref.watch(restaurantProvider);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Check Out'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Your Scrollable Content Here
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Delivery to',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                children: [
                                  Text(ref.read(userDataProvider)![0].name!,
                                      style: TextStyle(fontSize: 15)),
                                  SizedBox(width: 20),
                                  Text(
                                      ref
                                          .read(userDataProvider)![0]
                                          .contactno
                                          .toString(),
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5),
                              child: Text(
                                '86 pulen down street, jeddah district ',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black38),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.black12, thickness: 2),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Your order'),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(cart.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('${cart[index].quantity}x'),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${cart[index].name}'),
                                              if (cart[index].variation != null)
                                                ...List.generate(
                                                    cart[index]
                                                        .variation!
                                                        .length, (item) {
                                                  return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(cart[index]
                                                            .variation![item]
                                                            .variationName
                                                            .toString()),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        cart[index]
                                                                    .variation![
                                                                        item]
                                                                    .variationPrice !=
                                                                0
                                                            ? Text(
                                                                '\$${cart[index].variation![item].variationPrice}')
                                                            : const Text('Free')
                                                      ]);
                                                }),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('\$${cart[index].tprice}'),
                                          SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {},
                                            child: Text('X'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black12,
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                          height: 350), // Extra space to prevent content hiding
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Sticky Bottom Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  /// Fees and Total Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery Fee"),
                      Text("\$${restaurant.deliveryFee}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Platform Fee"),
                      Text("\$2.00"),
                    ],
                  ),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("\$${cartTotal} ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// Payment Buttons
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text("Payment Methode",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Cart Summary & Checkout Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Shopping Cart (${cart.length} items)",
                          style: const TextStyle(fontSize: 16)),
                      Text("\$$cartTotal",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text("Checkout",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
