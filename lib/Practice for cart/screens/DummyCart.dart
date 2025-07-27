// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
// import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
// import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
// import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
// import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
// import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
// import 'package:spicy_eats/main.dart';

// class DummyCart extends ConsumerStatefulWidget {
//   static const String routename = "/dummy_cart";
//   final String restuid;
//   DummyCart({super.key, required this.restuid});

//   @override
//   ConsumerState<DummyCart> createState() => _DummyCartState();
// }

// class _DummyCartState extends ConsumerState<DummyCart> {
//   List<DishData> dishes = [];
//   List<Categories?> allcategory = [];

//   String userId = supabaseClient.auth.currentUser!.id;

//   Future retrieveDishesAndCart({String? restuid}) async {
//     await ref
//         .read(homeControllerProvider)
//         .fetchDishes(restuid: restuid)
//         .then((value) {
//       if (value != null) {
//         setState(() {
//           dishes = value;
//         });
//       }
//     });

//     await ref.read(DummyLogicProvider).fetchCart(ref, userId);
//   }

//   Future<void> retrieveCategories(String restuid) async {
//     ref
//         .read(homeControllerProvider)
//         .fetchCategories(restuid: restuid)
//         .then((value) {
//       if (value != null) {
//         setState(() {
//           allcategory = value;
//           print("${allcategory[1]!.category_name}");
//         });
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     retrieveDishesAndCart(restuid: widget.restuid);
//     retrieveCategories(widget.restuid);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cart = ref.watch(cartProvider);

//     return Scaffold(
//       floatingActionButton: Align(
//         alignment: Alignment.bottomCenter,
//         child: FloatingActionButton(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.shopping_cart),
//               Text(cart.length.toString()), // Dynamic cart count
//             ],
//           ),
//           onPressed: () =>
//               Navigator.popAndPushNamed(context, BasketScreen.routename),
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             title: Text('asdsa0'),
//             expandedHeight: 200,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(
//                 "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
//                 fit: BoxFit.cover,
//                 colorBlendMode: BlendMode.darken,
//                 color: Colors.black.withOpacity(0.2),
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               childCount: dishes.length,
//               (context, index) {
//                 final dish = dishes[index];

//                 // Find if the dish is in the cart
//                 final cartItem = cart.firstWhere(
//                   (item) => item.dish_id == dish.dishid,
//                   orElse: () => CartModelNew(dish_id: 0, quantity: 0),
//                 );
//                 final quantityIndex = ref
//                     .read(cartProvider.notifier)
//                     .state
//                     .indexWhere((element) => element.dish_id == dish.dishid);

//                 return Column(
//                   children: [
//                     SizedBox(
//                       height: 80,
//                       child: ListTile(
//                         leading: Image.network(dish.dish_imageurl!),
//                         title: Text(dish.dish_name!),
//                         subtitle: Text(dish.dish_price.toString()),
//                         trailing: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black, width: 2),
//                           ),
//                           child: cartItem.dish_id != dish.dishid
//                               ? SizedBox(
//                                   height: 50,
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       ref.read(DummyLogicProvider).addToCart(
//                                           dish.dish_price!,
//                                           dish.dish_name,
//                                           dish.dish_description,
//                                           ref,
//                                           supabaseClient.auth.currentUser!.id,
//                                           dish.dishid!,
//                                           dish.dish_price!.toDouble(),
//                                           dish.dish_discount,
//                                           dish.dish_imageurl!,
//                                           null,
//                                           false,
//                                           0,
//                                           null);
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.zero,
//                                         side: BorderSide(
//                                             width: 2, color: Colors.black),
//                                       ),
//                                     ),
//                                     child: const Icon(Icons.add),
//                                   ),
//                                 )
//                               : Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(
//                                       height: 50,
//                                       child: ElevatedButton(
//                                         onPressed: () {
//                                           ref
//                                               .read(DummyLogicProvider)
//                                               .increaseQuantity(
//                                                   ref,
//                                                   dish.dishid!,
//                                                   dish.dish_price!);
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           shape: const RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.zero,
//                                             side: BorderSide(
//                                                 width: 2, color: Colors.black),
//                                           ),
//                                         ),
//                                         child: const Icon(Icons.add),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 5),
//                                     Text(
//                                       //cartItem.quantity.toString(),
//                                       ref
//                                           .read(cartProvider.notifier)
//                                           .state[quantityIndex]
//                                           .quantity
//                                           .toString(),
//                                       style: const TextStyle(fontSize: 20),
//                                     ),
//                                     const SizedBox(width: 5),
//                                     SizedBox(
//                                       height: 50,
//                                       child: ElevatedButton(
//                                         onPressed: () {
//                                           ref
//                                               .read(DummyLogicProvider)
//                                               .decreaseQuantity(
//                                                   ref,
//                                                   dish.dishid!,
//                                                   dish.dish_price!);
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.zero,
//                                             side: const BorderSide(
//                                                 width: 2, color: Colors.black),
//                                           ),
//                                         ),
//                                         child: const Icon(Icons.remove),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ),
//                       ),
//                     ),
//                     const Divider(
//                       height: 5,
//                       color: Colors.black,
//                     )
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
