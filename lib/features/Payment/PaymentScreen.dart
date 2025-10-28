import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Payment/repo/paymentRepo.dart';
import 'package:spicy_eats/features/Payment/utils/optionsModel.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';
import 'package:spicy_eats/features/orders/repo/orderRepo.dart';
import 'package:spicy_eats/main.dart';

var selectedmethodProvider = StateProvider<String?>((ref) => '');
var onclickprovier = StateProvider<bool>((ref) => false);

// class PaymentScreen extends ConsumerStatefulWidget {
//   static const String routename = '/Payment-screen';
//   const PaymentScreen({super.key});

//   @override
//   ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends ConsumerState<PaymentScreen> {
//   bool isloading = false;

//   void paymentModelbottomsheet(
//     BuildContext context,
//   ) {
//     showModalBottomSheet(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         context: context,
//         builder: (context) => StatefulBuilder(
//               builder: (context, setState) => Wrap(children: [
//                 // AppBar(
//                 //   centerTitle: true,
//                 //   title: const Text('Select Payment Methods'),
//                 // ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Container(
//                       color: Colors.white,
//                       child: Column(
//                         children: ref
//                             .read(paymentRepProvider)
//                             .paymentoption
//                             .map((option) {
//                           return RadioListTile<String>(
//                               selectedTileColor: Colors.black,
//                               activeColor: Colors.black,
//                               title: Row(
//                                 children: [
//                                   SizedBox(
//                                     height: 30,
//                                     width: 30,
//                                     child: Image.network(
//                                       option.imagurl,
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               const Icon(Icons.error_sharp),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(option.option),
//                                 ],
//                               ),
//                               value: option.option,
//                               groupValue: ref.watch(selectedmethodProvider),
//                               onChanged: (value) {
//                                 ref
//                                     .read(selectedmethodProvider.notifier)
//                                     .state = value!;
//                                 print(ref
//                                     .read(selectedmethodProvider.notifier)
//                                     .state);
//                                 Navigator.pop(context);
//                                 // if (ref
//                                 //         .read(selectedmethodProvider.notifier)
//                                 //         .state ==
//                                 //     'Credit or Debit Card') {
//                                 //   ref
//                                 //       .read(paymentRepProvider)
//                                 //       .paymentSheetInitializtion(
//                                 //           ref: ref,
//                                 //           cart: ref.watch(cartProvider),
//                                 //           amount: cartTotal,
//                                 //           currency: 'USD',
//                                 //           context: context);

//                                 //   Navigator.pushNamed(
//                                 //     context,
//                                 //     Home.routename,
//                                 //   );
//                                 // } else if (ref
//                                 //         .read(selectedmethodProvider.notifier)
//                                 //         .state ==
//                                 //     'Cash on Delivery') {
//                                 //   ref.read(paymentRepProvider).clearingcart(
//                                 //       ref: ref,
//                                 //       cart:
//                                 //           ref.read(cartProvider.notifier).state,
//                                 //       context: context);
//                                 // }
//                               });
//                         }).toList(),
//                       )),
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//               ]),
//             ));
//   }

//   double cartTotal = 0.0;
//   bool onclick = false;
//   @override
//   Widget build(BuildContext context) {
//     final selectedmethod = ref.watch(selectedmethodProvider);
//     final restaurant = ref.watch(restaurantProvider);
//         final address = ref.watch(pickedAddressProvider);

//     final subTotal = ref.read(cartReopProvider).getTotalPrice(ref);
//     cartTotal = subTotal + restaurant!.deliveryFee! + restaurant.platformfee!;

//     final cart = ref.watch(cartProvider);
//     GlobalKey<ScaffoldMessengerState> scaffoldmessengerkey =
//         GlobalKey<ScaffoldMessengerState>();
//     //final restaurant = ref.watch(restaurantProvider);
//     return Skeletonizer(
//       enabled: isloading,
//       child: SafeArea(
//           child: ScaffoldMessenger(
//         key: scaffoldmessengerkey,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             centerTitle: true,
//             title: const Text('Check Out'),
//           ),
//           body: Stack(
//             children: [
//               Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Your Scrollable Content Here
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10.0, horizontal: 10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                Row(
//                                   children: [
//                                     Icon(
//                                       Icons.location_on_sharp,
//                                       color: Colors.black,
//                                     ),
//                                     SizedBox(width: 10),
//                                     Text(
//                                       '${address?.address}',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w400),
//                                     )
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 5, vertical: 10),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                           '${ref.read(userProvider)!.firstname!} ${ref.read(userProvider)!.lastname}',
//                                           style: const TextStyle(fontSize: 15)),
//                                       const SizedBox(width: 20),
//                                       Text(
//                                           ref
//                                               .read(userDataProvider)![0]
//                                               .contactno
//                                               .toString(),
//                                           style: const TextStyle(fontSize: 15)),
//                                     ],
//                                   ),
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 5.0, vertical: 5),
//                                   child: Text(
//                                     '86 pulen down street, jeddah district ',
//                                     style: TextStyle(
//                                         fontSize: 15, color: Colors.black38),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(color: Colors.black12, thickness: 2),
//                           const SizedBox(height: 20),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: Text('Your order'),
//                           ),
//                           const SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: List.generate(cart.length, (index) {
//                                 return Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 10),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               Text('${cart[index].cart_id}x'),
//                                               Text('${cart[index].quantity}x'),
//                                               const SizedBox(width: 20),
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text('${cart[index].name}'),
//                                                   if (cart[index].variation !=
//                                                       null)
//                                                     ...List.generate(
//                                                         cart[index]
//                                                             .variation!
//                                                             .length, (item) {
//                                                       return Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Text(cart[index]
//                                                                 .variation![
//                                                                     item]
//                                                                 .variationName
//                                                                 .toString()),
//                                                             const SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             cart[index]
//                                                                         .variation![
//                                                                             item]
//                                                                         .variationPrice !=
//                                                                     0
//                                                                 ? Text(
//                                                                     '\$${cart[index].variation![item].variationPrice}')
//                                                                 : const Text(
//                                                                     'Free')
//                                                           ]);
//                                                     }),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text('\$${cart[index].tprice}'),
//                                               const SizedBox(width: 10),
//                                               InkWell(
//                                                 onTap: () {},
//                                                 child: const Text('X'),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                       const Divider(
//                                         color: Colors.black12,
//                                         thickness: 2,
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//                           const SizedBox(
//                               height:
//                                   350), // Extra space to prevent content hiding
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               /// Sticky Bottom Container
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(15),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 5,
//                           spreadRadius: 2),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       /// Fees and Total Section
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text("Delivery Fee"),
//                           Text("\$${restaurant.deliveryFee}"),
//                         ],
//                       ),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Platform Fee"),
//                           Text("\$2.00"),
//                         ],
//                       ),

//                       const Divider(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text("Subtotal",
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           Text("\$$cartTotal ",
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       const SizedBox(height: 10),

//                       /// Payment Buttons
//                       SizedBox(
//                         width: double.maxFinite,
//                         height: 50,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               surfaceTintColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   side: const BorderSide(
//                                       width: 2, color: Colors.black),
//                                   borderRadius: BorderRadius.circular(10)),
//                               backgroundColor: Colors.white,
//                             ),
//                             onPressed: () {
//                               paymentModelbottomsheet(context);
//                               ref.read(onclickprovier.notifier).state = true;
//                             },
//                             child: const Text("Payment Method",
//                                 style: TextStyle(
//                                     fontSize: 15, color: Colors.black)),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       /// Cart Summary & Checkout Button
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Shopping Cart (${cart.length} items)",
//                               style: const TextStyle(fontSize: 16)),
//                           Text("\$$cartTotal",
//                               style: const TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                           onPressed: () {
//                             if (ref
//                                     .read(selectedmethodProvider.notifier)
//                                     .state ==
//                                 'Credit or Debit Card') {
//                               setState(() {
//                                 isloading = true;
//                               });

//                               ref.read(orderRepoProvider).storeOrder(
//                                     orders: cart,
//                                     orderedFrom: restaurant.restaurantName!,
//                                     deliveredTo:
//                                         '${ref.read(userProvider)!.firstname!} ${ref.read(userProvider)!.lastname}',
//                                     paytype: ref
//                                         .read(selectedmethodProvider.notifier)
//                                         .state!,
//                                   );

//                               ref
//                                   .read(paymentRepProvider)
//                                   .paymentSheetInitializtion(
//                                       ref: ref,
//                                       cart: ref.watch(cartProvider),
//                                       amount: cartTotal,
//                                       currency: 'USD',
//                                       context: context);

//                               setState(() {
//                                 isloading = false;
//                               });
//                             } else {
//                               setState(() {
//                                 isloading = true;
//                               });
//                               if (scaffoldmessengerkey.currentState != null) {
//                                 scaffoldmessengerkey.currentState!
//                                     .showSnackBar(const SnackBar(
//                                   content: Text('Order Placed Successfully'),
//                                   behavior: SnackBarBehavior.floating,
//                                   margin: EdgeInsets.only(
//                                       bottom: 100, left: 20, right: 20),
//                                 ));
//                               }
//                               ref.read(orderRepoProvider).storeOrder(
//                                     orders: cart,
//                                     orderedFrom: restaurant.restaurantName!,
//                                     deliveredTo:
//                                         '${ref.read(userProvider)!.firstname!} ${ref.read(userProvider)!.lastname}',
//                                     paytype: ref
//                                         .read(selectedmethodProvider.notifier)
//                                         .state!,
//                                   );
//                               ref.read(paymentRepProvider).clearingcart(
//                                   ref: ref, cart: cart, context: context);
//                               Navigator.pushNamed(
//                                 context,
//                                 Home.routename,
//                               );
//                             }
//                             setState(() {
//                               isloading = false;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             minimumSize: const Size(double.infinity, 50),
//                             backgroundColor: Colors.black,
//                           ),
//                           child: selectedmethod == 'Cash on Delivery'
//                               ? const Text("Confirm Payment via Cash",
//                                   style: TextStyle(
//                                       fontSize: 18, color: Colors.white))
//                               : const Text("Add Card Details & Confirm",
//                                   style: TextStyle(
//                                       fontSize: 15, color: Colors.white))),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }
// Enhanced PaymentScreen with stunning UI
class PaymentScreen extends ConsumerStatefulWidget {
  static const String routename = '/Payment-screen';
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool isloading = false;

  void paymentModelbottomsheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.payment,
                    color: Colors.orange[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...ref.read(paymentRepProvider).paymentoption.map((option) {
              final isSelected = ref.watch(selectedmethodProvider) == option.option;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.orange[300]! : Colors.grey[200]!,
                    width: 2,
                  ),
                ),
                child: RadioListTile<String>(
                  activeColor: Colors.orange[700],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.network(
                          option.imagurl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.payment, color: Colors.grey[400]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option.option,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: option.option,
                  groupValue: ref.watch(selectedmethodProvider),
                  onChanged: (value) {
                    ref.read(selectedmethodProvider.notifier).state = value!;
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  double cartTotal = 0.0;

  @override
  Widget build(BuildContext context) {
    final selectedmethod = ref.watch(selectedmethodProvider);
    final restaurant = ref.watch(restaurantProvider);
    final address = ref.watch(pickedAddressProvider);
    final subTotal = ref.read(cartReopProvider).getTotalPrice(ref);
    cartTotal = subTotal + restaurant!.deliveryFee! + restaurant.platformfee!;
    final cart = ref.watch(cartProvider);
    final user = ref.read(userProvider);
    final userData = ref.read(userDataProvider);

    GlobalKey<ScaffoldMessengerState> scaffoldmessengerkey =
        GlobalKey<ScaffoldMessengerState>();

    return Skeletonizer(
      enabled: isloading,
      child: SafeArea(
        child: ScaffoldMessenger(
          key: scaffoldmessengerkey,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: const Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 350),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Delivery Address Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.green[700],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Delivery Address',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${user?.firstname} ${user?.lastname}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userData?[0].contactno.toString() ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address?.address ?? 'No address selected',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Order Items Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.purple[700],
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Your Order',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Order Items List
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: List.generate(cart.length, (index) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: index < cart.length - 1
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[50],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${cart[index].quantity}x',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cart[index].name ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (cart[index].variation != null &&
                                                cart[index].variation!.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              ...cart[index].variation!.map((v) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 3),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 4,
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[400],
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        v.variationName ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        v.variationPrice != 0
                                                            ? '+\$${v.variationPrice}'
                                                            : 'Free',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: v.variationPrice !=
                                                                  0
                                                              ? Colors.green[700]
                                                              : Colors.blue[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '\$${cart[index].tprice?.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Sticky Bottom Section
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          // Bill Details
                          _buildBillRow('Subtotal', '\$${subTotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 8),
                          _buildBillRow('Delivery Fee', '\$${restaurant.deliveryFee}'),
                          const SizedBox(height: 8),
                          _buildBillRow('Platform Fee', '\$${restaurant.platformfee}'),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '\$${cartTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Payment Method Button
                          OutlinedButton(
                            onPressed: () {
                              paymentModelbottomsheet(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey[300]!, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.payment, color: Colors.grey[700], size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  selectedmethod!.isEmpty 
                                      ? 'Select Payment Method'
                                      : selectedmethod,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.grey[600]),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirm Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: selectedmethod == null || selectedmethod.isEmpty
                                  ? null
                                  : () {
                                      setState(() => isloading = true);
                                      
                                      if (selectedmethod == 'Credit or Debit Card') {
                                        ref.read(orderRepoProvider).storeOrder(
                                           customerId: supabaseClient.auth.currentUser!.id,
                                              orderStatus: 'Pending',
                                              orders: cart,
                                              orderedFrom: restaurant.restaurantName!,
                                              deliveredTo:
                                                  '${user?.firstname} ${user?.lastname}',
                                              paytype: selectedmethod,
                                            );
                                        ref
                                            .read(paymentRepProvider)
                                            .paymentSheetInitializtion(
                                              ref: ref,
                                              cart: cart,
                                              amount: cartTotal,
                                              currency: 'USD',
                                              context: context,
                                            );
                                      } else {
                                        scaffoldmessengerkey.currentState
                                            ?.showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'Order Placed Successfully'),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        ref.read(orderRepoProvider).storeOrder(
                                              customerId: supabaseClient.auth.currentUser!.id,
                                              orderStatus: 'Pending',
                                              orders: cart,
                                              orderedFrom: restaurant.restaurantName!,
                                              deliveredTo:
                                                  '${user?.firstname} ${user?.lastname}',
                                              paytype: selectedmethod,
                                            );
                                        ref
                                            .read(paymentRepProvider)
                                            .clearingcart(
                                                ref: ref, cart: cart, context: context);
                                        Navigator.pushNamed(context, Home.routename);
                                      }
                                      setState(() => isloading = false);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedmethod == null ||
                                        selectedmethod.isEmpty
                                    ? Colors.grey[300]
                                    : Colors.orange[700],
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedmethod == 'Cash on Delivery'
                                        ? 'Place Order'
                                        : 'Add Card & Pay',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}