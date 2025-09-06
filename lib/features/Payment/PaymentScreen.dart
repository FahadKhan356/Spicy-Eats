import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Payment/repo/paymentRepo.dart';
import 'package:spicy_eats/features/Payment/utils/optionsModel.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';
import 'package:spicy_eats/features/orders/repo/orderRepo.dart';

var selectedmethodProvider = StateProvider<String?>((ref) => '');
var onclickprovier = StateProvider<bool>((ref) => false);

class PaymentScreen extends ConsumerStatefulWidget {
  static const String routename = '/Payment-screen';
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool isloading = false;

  void paymentModelbottomsheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => Wrap(children: [
                // AppBar(
                //   centerTitle: true,
                //   title: const Text('Select Payment Methods'),
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      color: Colors.white,
                      child: Column(
                        children: ref
                            .read(paymentRepProvider)
                            .paymentoption
                            .map((option) {
                          return RadioListTile<String>(
                              selectedTileColor: Colors.black,
                              activeColor: Colors.black,
                              title: Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.network(
                                      option.imagurl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error_sharp),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(option.option),
                                ],
                              ),
                              value: option.option,
                              groupValue: ref.watch(selectedmethodProvider),
                              onChanged: (value) {
                                ref
                                    .read(selectedmethodProvider.notifier)
                                    .state = value!;
                                print(ref
                                    .read(selectedmethodProvider.notifier)
                                    .state);
                                Navigator.pop(context);
                                // if (ref
                                //         .read(selectedmethodProvider.notifier)
                                //         .state ==
                                //     'Credit or Debit Card') {
                                //   ref
                                //       .read(paymentRepProvider)
                                //       .paymentSheetInitializtion(
                                //           ref: ref,
                                //           cart: ref.watch(cartProvider),
                                //           amount: cartTotal,
                                //           currency: 'USD',
                                //           context: context);

                                //   Navigator.pushNamed(
                                //     context,
                                //     Home.routename,
                                //   );
                                // } else if (ref
                                //         .read(selectedmethodProvider.notifier)
                                //         .state ==
                                //     'Cash on Delivery') {
                                //   ref.read(paymentRepProvider).clearingcart(
                                //       ref: ref,
                                //       cart:
                                //           ref.read(cartProvider.notifier).state,
                                //       context: context);
                                // }
                              });
                        }).toList(),
                      )),
                ),
                const SizedBox(
                  height: 50,
                ),
              ]),
            ));
  }

  double cartTotal = 0.0;
  bool onclick = false;
  @override
  Widget build(BuildContext context) {
    final selectedmethod = ref.watch(selectedmethodProvider);
    final restaurant = ref.watch(restaurantProvider);
        final address = ref.watch(pickedAddressProvider);

    final subTotal = ref.read(cartReopProvider).getTotalPrice(ref);
    cartTotal = subTotal + restaurant!.deliveryFee! + restaurant.platformfee!;

    final cart = ref.watch(cartProvider);
    GlobalKey<ScaffoldMessengerState> scaffoldmessengerkey =
        GlobalKey<ScaffoldMessengerState>();
    //final restaurant = ref.watch(restaurantProvider);
    return Skeletonizer(
      enabled: isloading,
      child: SafeArea(
          child: ScaffoldMessenger(
        key: scaffoldmessengerkey,
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
                                      '${address?.address}',
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
                                      Text(
                                          '${ref.read(userProvider)!.firstname!} ${ref.read(userProvider)!.lastname}',
                                          style: const TextStyle(fontSize: 15)),
                                      const SizedBox(width: 20),
                                      Text(
                                          ref
                                              .read(userDataProvider)![0]
                                              .contactno
                                              .toString(),
                                          style: const TextStyle(fontSize: 15)),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              Text('${cart[index].cart_id}x'),
                                              Text('${cart[index].quantity}x'),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('${cart[index].name}'),
                                                  if (cart[index].variation !=
                                                      null)
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
                                                                .variation![
                                                                    item]
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
                                                                : const Text(
                                                                    'Free')
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
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {},
                                                child: const Text('X'),
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
                              height:
                                  350), // Extra space to prevent content hiding
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
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Fees and Total Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Delivery Fee"),
                          Text("\$${restaurant.deliveryFee}"),
                        ],
                      ),
                      const Row(
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
                          const Text("Subtotal",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("\$$cartTotal ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),

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
                                  side: const BorderSide(
                                      width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              paymentModelbottomsheet(context);
                              ref.read(onclickprovier.notifier).state = true;
                            },
                            child: const Text("Payment Method",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
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
                          onPressed: () {
                            if (ref
                                    .read(selectedmethodProvider.notifier)
                                    .state ==
                                'Credit or Debit Card') {
                              setState(() {
                                isloading = true;
                              });

                              ref.read(orderRepoProvider).storeOrder(
                                    orders: cart,
                                    orderedFrom: restaurant.restaurantName!,
                                    deliveredTo:
                                        '${ref.read(userProvider)!.firstname!} ${ref.read(userProvider)!.lastname}',
                                    paytype: ref
                                        .read(selectedmethodProvider.notifier)
                                        .state!,
                                  );

                              ref
                                  .read(paymentRepProvider)
                                  .paymentSheetInitializtion(
                                      ref: ref,
                                      cart: ref.watch(cartProvider),
                                      amount: cartTotal,
                                      currency: 'USD',
                                      context: context);

                              setState(() {
                                isloading = false;
                              });
                            } else {
                              setState(() {
                                isloading = true;
                              });
                              if (scaffoldmessengerkey.currentState != null) {
                                scaffoldmessengerkey.currentState!
                                    .showSnackBar(const SnackBar(
                                  content: Text('Order Placed Successfully'),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                      bottom: 100, left: 20, right: 20),
                                ));
                              }
                              ref.read(orderRepoProvider).storeOrder(
                                    orders: cart,
                                    orderedFrom: restaurant.restaurantName!,
                                    deliveredTo:
                                        '${ref.read(userProvider)!.firstname!} ${ref.read(userProvider)!.lastname}',
                                    paytype: ref
                                        .read(selectedmethodProvider.notifier)
                                        .state!,
                                  );
                              ref.read(paymentRepProvider).clearingcart(
                                  ref: ref, cart: cart, context: context);
                              Navigator.pushNamed(
                                context,
                                Home.routename,
                              );
                            }
                            setState(() {
                              isloading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                          ),
                          child: selectedmethod == 'Cash on Delivery'
                              ? const Text("Confirm Payment via Cash",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white))
                              : const Text("Add Card Details & Confirm",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
