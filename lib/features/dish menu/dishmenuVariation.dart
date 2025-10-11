import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/commons/Cartmodel.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Basket/screens/BasketScreen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/features/dish%20menu/widget/customBottomBar.dart';
import 'package:spicy_eats/features/dish%20menu/widget/freqDishesList.dart';

final variationListProvider = StateProvider<List<Variation>?>((ref) => null);
final freqDishesProvider = StateProvider<List<DishData>?>((ref) => []);

// // ignore: must_be_immutable
// class DishMenuVariation extends ConsumerStatefulWidget {
//   static const String routename = '/DishMenuVariation';
//   final DishData? dish;
//   RestaurantModel? restaurantData;
//   List<DishData>? dishes = [];
//   List<VariattionTitleModel>? variationList = [];
//   bool? isCart;
//   bool isdishscreen = false;
//   List<DishData>? freqList;
//   Cartmodel? cartDish;
//   bool isbasket = false;
//   List<int> dishesids = [];

//   // int updateQuantity = 0;
//   List<Cartmodel>? carts = [];

//   DishMenuVariation({
//     super.key,
//     this.carts,
//     required this.dish,
//     this.cartDish,
//     required this.isCart,
//     required this.dishes,
//     required this.restaurantData,
//     required this.isdishscreen,
//   });

//   @override
//   ConsumerState<DishMenuVariation> createState() => _DishMenuScreenState();
// }

// class _DishMenuScreenState extends ConsumerState<DishMenuVariation>
//     with SingleTickerProviderStateMixin {
//   AnimationController? animationController;
//   Animation<double>? _opacityanimation;
//   Animation<Offset>? _offsetanimation;
//   ScrollController? scrollController;
//   bool? withvariation;
//   bool isloader = false;

//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();
//   final Debouncer _debouncer = Debouncer(milliseconds: 500);

//   Future<void> initialDataLoad(int dishId) async {
//     if (mounted) {
//       await fetchVariations(dishId);
//       await fetchfrequentlybought();
//     }
//     if (widget.isCart!) {
//       for (int i = 0; i < ref.watch(cartProvider).length; i++) {
//         widget.freqList!.removeWhere(
//             (element) => element.dishid == ref.read(cartProvider)[i].dish_id);
//       }
//     }
//   }

//   Future<void> fetchfrequentlybought() async {
//     final list = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
//           freqid: widget.dish?.frequentlyid,
//           ref: ref,
//         );

//     setState(() {
//       widget.freqList = list;
//     });
//   }

//   Future<void> fetchVariations(int dishId) async {
//     await ref
//         .read(dishMenuRepoProvider)
//         .fetchVariations(dishid: dishId, context: context)
//         .then((value) {
//       if (value != null) {
//         setState(() {
//           widget.variationList = value;
//           if (widget.isCart!) {
//             withvariation = true;
//           } else {
//             withvariation = false;
//           }
//         });
//         print('with variation : $withvariation!');
//       }
//     });

//     widget.freqList = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
//           freqid: widget.dish?.frequentlyid,
//           ref: ref,
//         );
//     debugPrint(
//         ' outside cartdish variation length${widget.cartDish?.variation?.length} and is cart ${widget.isCart}');
//     if (widget.isCart == true) {
//       debugPrint(
//           'inside if cartdish variation length${widget.cartDish?.variation?.length}');
//       ref.read(variationListProvider.notifier).state =
//           widget.cartDish!.variation;

//       // ref.read(freqDishesProvider.notifier).state =
//       //     widget.cartDish?.freqboughts;
//       // print(' freqboughts length${widget.cartDish!.freqboughts!.length}');
//       // print(
//       //     ' freqboughts provider${ref.read(freqDishesProvider.notifier).state?[1].dish_name}');
//       for (int i = 0; i < widget.carts!.length; i++) {
//         widget.freqList!.removeWhere(
//             (element) => element.dishid == widget.carts![i].dish_id);
//       }

//       ref.read(updatedQuantityProvider.notifier).state =
//           widget.cartDish!.quantity;
//     } else {
//       ref.read(variationListProvider.notifier).state = null;
//     }
//     //   ref.read(variationListProvider.notifier).state =
//     //       widget.cartDish!.variation;
//     //   print(widget.cartDish!.variation?.length);

//     // }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     scrollController!.dispose();
//     animationController?.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     scrollController = ScrollController();
//     animationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _offsetanimation =
//         Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
//             CurvedAnimation(
//                 parent: animationController!, curve: Curves.easeOut));
//     _opacityanimation = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: animationController!, curve: Curves.easeOut));

//     scrollController!.addListener(() {
//       // if (_scrollController!.hasClients && _scrollController!.offset > 50) {
//       if (!mounted) return;
//       final offset =
//           scrollController!.hasClients ? scrollController!.offset : 0.0;

//       if (offset > 50) {
//         animationController!.forward();
//       } else {
//         animationController!.reverse();
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await initialDataLoad(widget.dish!.dishid!);
//       ref.read(isloaderProvider.notifier).state = false;
//       // fetchfrequentlybought;
//       ref.read(quantityPrvider.notifier).state = 1;

//       // fetchVariations(widget.dish!.dishid!);
//       // ref.read(variationListProvider.notifier).state = null;

//       // setState(() {
//       //   isloader = false;
//       // });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isloader = ref.watch(isloaderProvider);
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final totalquantity = ref
//         .read(cartReopProvider)
//         .getTotalQuantityofdish(ref, widget.dish!.dishid!);
//     var quantity = ref.watch(quantityPrvider);
//     final updatedQuantity = ref.watch(updatedQuantityProvider);

//     return SafeArea(
//       child: ScaffoldMessenger(
//         key: scaffoldMessengerKey,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: Skeletonizer(
//             ignorePointers: true,
//             ignoreContainers: true,
//             enabled: isloader,
//             enableSwitchAnimation: true,
//             child: Stack(
//               children: [
//                 CustomScrollView(
//                   controller: !isloader ? scrollController : null,
//                   slivers: [
//                     SliverAppBar(
//                       title: AnimatedBuilder(
//                           animation: animationController!,
//                           builder: (context, child) {
//                             return Transform.translate(
//                                 offset: _offsetanimation!.value,
//                                 child: Opacity(
//                                     opacity: _opacityanimation!.value,
//                                     child: const Text(
//                                       'Variation',
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold),
//                                     )));
//                           }),
//                       expandedHeight: height * 0.4,
//                       pinned: true,
//                       flexibleSpace: FlexibleSpaceBar(
//                         background: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 20),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: Image.network(
//                               widget.dish!.dish_imageurl!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(Icons.broken_image);
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.dish!.dish_name!,
//                                   style: TextStyle(
//                                       fontSize: width * 0.05,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     widget.dish!.dish_discount == null
//                                         ? Text(
//                                             'from Rs \$${widget.dish!.dish_price}',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: width * 0.04,
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : const SizedBox(),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     widget.dish!.dish_discount != null
//                                         ? Row(
//                                             children: [
//                                               Text(
//                                                 'from Rs  \$${widget.dish!.dish_discount}/-',
//                                                 style: TextStyle(
//                                                     fontSize: width * 0.04,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Text(
//                                                 '  \$${widget.dish!.dish_price}',
//                                                 style: TextStyle(
//                                                     color: Colors.redAccent,
//                                                     decoration: TextDecoration
//                                                         .lineThrough,
//                                                     decorationThickness: 2,
//                                                     decorationStyle:
//                                                         TextDecorationStyle
//                                                             .solid,
//                                                     decorationColor:
//                                                         Colors.redAccent,
//                                                     fontSize: width * 0.04,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ],
//                                           )
//                                         : const SizedBox(),
//                                     !widget.isCart!
//                                         ? Text(
//                                             ' - Already in your cart',
//                                             style: TextStyle(
//                                                 color: Colors.orange[900],
//                                                 fontSize: width * 0.04,
//                                                 fontWeight: FontWeight.bold),
//                                           )
//                                         : const SizedBox(),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   widget.dish!.dish_description!,
//                                   style: TextStyle(
//                                       fontSize: width * 0.035,
//                                       fontWeight: FontWeight.w300),
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 widget.isdishscreen &&
//                                         widget.cartDish!.name != null
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text('Already in your cart'),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Container(
//                                                 height: 50,
//                                                 width: double.maxFinite,
//                                                 padding:
//                                                     const EdgeInsets.all(10),
//                                                 decoration: BoxDecoration(
//                                                   boxShadow: const [
//                                                     BoxShadow(
//                                                         spreadRadius: 2,
//                                                         color: Color.fromRGBO(
//                                                             230, 81, 0, 1),
//                                                         blurRadius: 2)
//                                                   ],
//                                                   color: Colors.orange[100],
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           width * 0.14),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 10),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Text(
//                                                             '${totalquantity}x',
//                                                             style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         0.032,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                           const SizedBox(
//                                                             width: 20,
//                                                           ),
//                                                           Text(
//                                                             '${widget.cartDish!.name}',
//                                                             style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         0.032,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       InkWell(
//                                                           onTap: () =>
//                                                               Navigator.pushNamed(
//                                                                   context,
//                                                                   BasketScreen
//                                                                       .routename,
//                                                                   arguments: {
//                                                                     'dishes': widget
//                                                                         .dishes,
//                                                                     'restdata': ref
//                                                                         .read(restaurantProvider
//                                                                             .notifier)
//                                                                         .state
//                                                                   }),
//                                                           child: Text(
//                                                             'Edit in cart',
//                                                             style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         0.032,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           )),
//                                                     ],
//                                                   ),
//                                                 )),
//                                           ),
//                                         ],
//                                       )
//                                     : const SizedBox(),
//                               ]),
//                         ),
//                       ),
//                     ),
//                     SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                             childCount: widget.variationList!.length,
//                             (context, titleVariationindex) {
//                       final titleVariation =
//                           widget.variationList![titleVariationindex];

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 20, horizontal: 10),
//                         child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.orange[100],
//                               // gradient: Gradient.linear(0, 9,  colors: [
//                               //       Color.fromRGBO(255, 224, 178, 1),
//                               //       Colors.black26
//                               //     ]) ,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: const [
//                                 BoxShadow(
//                                     spreadRadius: 2,
//                                     color: Color.fromRGBO(230, 81, 0, 1),
//                                     blurRadius: 2)
//                               ],
//                               // border:
//                               // Border.all(width: 1, color: Colors.black38),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         titleVariation.variationTitle
//                                             .toString(),
//                                         style: const TextStyle(fontSize: 22),
//                                       ),
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(5),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(5),
//                                           color: titleVariation.isRequired!
//                                               ? Colors.red
//                                               : Colors.green,
//                                           child: titleVariation.isRequired!
//                                               ? const Text(
//                                                   'Required',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.white),
//                                                 )
//                                               : const Text(
//                                                   'optional',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black87),
//                                                 ),
//                                         ),
//                                       ),
//                                     ]),
//                                 Text(
//                                   titleVariation.subtitle.toString(),
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                                 ...titleVariation.variations!.map((variation) {
//                                   final variationlist =
//                                       ref.watch(variationListProvider) ?? [];
//                                   final isselected = variationlist
//                                       .any((v) => v.id == variation.id);

//                                   return CheckboxListTile(
//                                     checkColor: Colors.white,
//                                     activeColor: Colors.black,
//                                     title: variation.variationPrice! > 0
//                                         ? Row(
//                                             children: [
//                                               Text(
//                                                   ("${variation.variationName})")),
//                                               Text(
//                                                   " (\$${variation.variationPrice})"),
//                                             ],
//                                           )
//                                         : Row(
//                                             children: [
//                                               Text(
//                                                   ("${variation.variationName}")),
//                                               const Text(" Free")
//                                             ],
//                                           ),
//                                     value: isselected, //isSelected,
//                                     onChanged: (value) {
//                                       final updatedList =
//                                           List<Variation>.from(variationlist);
//                                       if (value == true) {
//                                         if (titleVariation.maxSeleted == null ||
//                                             updatedList
//                                                     .where((v) =>
//                                                         v.variation_id ==
//                                                         titleVariation.id)
//                                                     .length <
//                                                 titleVariation.maxSeleted!) {
//                                           updatedList.add(
//                                             Variation(
//                                               totalvariation: 5,
//                                               id: variation.id,
//                                               variationName:
//                                                   variation.variationName,
//                                               variationPrice:
//                                                   variation.variationPrice,
//                                               variation_id:
//                                                   variation.variation_id,
//                                               selected: true,
//                                             ),
//                                           );
//                                           if (titleVariation.isRequired!) {
//                                             withvariation = true;
//                                           }
//                                         } else {
//                                           if (scaffoldMessengerKey
//                                                   .currentState !=
//                                               null) {
//                                             scaffoldMessengerKey.currentState!
//                                                 .showSnackBar(SnackBar(
//                                               content: Text(
//                                                 'you can only select upto ${titleVariation.maxSeleted} options',
//                                                 style: const TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               margin: const EdgeInsets.only(
//                                                 bottom:
//                                                     100, // Adjust this value to keep the SnackBar above the bottom UI
//                                                 left: 20,
//                                                 right: 20,
//                                               ),
//                                               behavior:
//                                                   SnackBarBehavior.floating,
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10)),
//                                               backgroundColor: Colors.black,
//                                             ));
//                                           }
//                                         }
//                                       } else if (titleVariation.isRequired!) {
//                                         updatedList.removeWhere(
//                                             (v) => v.id == variation.id);
//                                         withvariation = false;
//                                       } else {
//                                         updatedList.removeWhere(
//                                             (v) => v.id == variation.id);
//                                       }

//                                       ref
//                                           .read(variationListProvider.notifier)
//                                           .state = updatedList;

//                                       debugPrint(
//                                           "new Variation list :      ${ref.read(variationListProvider.notifier).state}  ");
//                                     },
//                                   );
//                                 }),
//                               ],
//                             )),
//                       );
//                     })),
//                     const SliverToBoxAdapter(
//                         child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                       child: Text(
//                         'Frequently Bought Together',
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold),
//                       ),
//                     )),
//                     SliverToBoxAdapter(
//                       child: SizedBox(
//                         height: height * 0.03,
//                       ),
//                     ),
//                     widget.freqList != null
//                         ? SliverToBoxAdapter(
//                             child: Freqdisheslist(
//                                 screenSize: width, freqList: widget.freqList!))
//                         : const SliverToBoxAdapter(
//                             child: SizedBox(),
//                           ),
//                     const SliverToBoxAdapter(
//                       child: SizedBox(
//                         height: 100,
//                       ),
//                     ),
//                   ],
//                 ),
//                 (isloader == false &&
//                         widget.variationList != null &&
//                         widget.variationList!.isNotEmpty &&
//                         widget.variationList!.indexWhere((element) =>
//                                 element.dishid == widget.dish!.dishid!) !=
//                             -1)
//                     ? Positioned(
//                         bottom: 20,
//                         left: 20,
//                         right: 20,
//                         child: customBottomBar(
//                             false,
//                             mounted,
//                             scaffoldMessengerKey,
//                             true,
//                             withvariation!,
//                             ref,
//                             width,
//                             widget.isCart!,
//                             updatedQuantity,
//                             context,
//                             widget.dish!,
//                             quantity,
//                             widget.restaurantData!,
//                             height,
//                             _debouncer, onAction: () {
//                           debugPrint(
//                               ' variation check  ${ref.read(variationListProvider.notifier).state}');
//                           ref.read(isloaderProvider.notifier).state = true;

//                           ref.read(dishMenuRepoProvider).dishMenuCrud(
//                               cart: widget.cartDish!,
//                               // totalVaritionPrice: totalvariation,
//                               variations: ref
//                                   .read(variationListProvider.notifier)
//                                   .state,
//                               newFreqList:
//                                   ref.read(freqnewListProvider.notifier).state,
//                               ref: ref,
//                               withvariation: withvariation!,
//                               debouncer: _debouncer,
//                               isCart: widget.isCart!,
//                               updatedQuantity: updatedQuantity,
//                               dish: widget.dish!,
//                               quantity: quantity,
//                               context: context);

//                           ref
//                               .read(dishMenuRepoProvider)
//                               .addAllFreqBoughtItems(ref: ref);
//                           debugPrint(
//                               ' freq list check  ${ref.read(freqnewListProvider.notifier).state}');

//                           Navigator.pushNamed(
//                             context,
//                             RestaurantMenuScreen.routename,
//                             arguments: widget.restaurantData,
//                           );
//                         }))
//                     : const SizedBox(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Enhanced DishMenuVariation with professional UI
class DishMenuVariation extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuVariation';
  final DishData? dish;
  RestaurantModel? restaurantData;
  List<DishData>? dishes = [];
  List<VariattionTitleModel>? variationList = [];
  bool? isCart;
  bool isdishscreen = false;
  List<DishData>? freqList;
  Cartmodel? cartDish;
  bool isbasket = false;
  List<int> dishesids = [];
  List<Cartmodel>? carts = [];

  DishMenuVariation({
    super.key,
    this.carts,
    required this.dish,
    this.cartDish,
    required this.isCart,
    required this.dishes,
    required this.restaurantData,
    required this.isdishscreen,
  });

  @override
  ConsumerState<DishMenuVariation> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuVariation>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? _opacityanimation;
  Animation<Offset>? _offsetanimation;
  ScrollController? scrollController;
  bool? withvariation;
  bool isloader = false;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future<void> initialDataLoad(int dishId) async {
    if (mounted) {
      await fetchVariations(dishId);
      await fetchfrequentlybought();
    }
    if (widget.isCart!) {
      for (int i = 0; i < ref.watch(cartProvider).length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == ref.read(cartProvider)[i].dish_id);
      }
    }
  }

  Future<void> fetchfrequentlybought() async {
    final list = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
          freqid: widget.dish?.frequentlyid,
          ref: ref,
        );
    setState(() {
      widget.freqList = list;
    });
  }

  Future<void> fetchVariations(int dishId) async {
    await ref
        .read(dishMenuRepoProvider)
        .fetchVariations(dishid: dishId, context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          widget.variationList = value;
          if (widget.isCart!) {
            withvariation = true;
          } else {
            withvariation = false;
          }
        });
      }
    });

    widget.freqList = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
          freqid: widget.dish?.frequentlyid,
          ref: ref,
        );

    if (widget.isCart == true) {
      ref.read(variationListProvider.notifier).state =
          widget.cartDish!.variation;
      for (int i = 0; i < widget.carts!.length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == widget.carts![i].dish_id);
      }
      ref.read(updatedQuantityProvider.notifier).state =
          widget.cartDish!.quantity;
    } else {
      ref.read(variationListProvider.notifier).state = null;
    }
  }

  @override
  void dispose() {
    scrollController!.dispose();
    animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: animationController!, curve: Curves.easeOut));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut));

    scrollController!.addListener(() {
      if (!mounted) return;
      final offset =
          scrollController!.hasClients ? scrollController!.offset : 0.0;
      if (offset > 50) {
        animationController!.forward();
      } else {
        animationController!.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialDataLoad(widget.dish!.dishid!);
      ref.read(isloaderProvider.notifier).state = false;
      ref.read(quantityPrvider.notifier).state = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isloader = ref.watch(isloaderProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final totalquantity = ref
        .read(cartReopProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid!);
    var quantity = ref.watch(quantityPrvider);
    final updatedQuantity = ref.watch(updatedQuantityProvider);

    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: Skeletonizer(
            ignorePointers: true,
            ignoreContainers: true,
            enabled: isloader,
            enableSwitchAnimation: true,
            child: Stack(
              children: [
                CustomScrollView(
                  controller: !isloader ? scrollController : null,
                  slivers: [
                    // Enhanced SliverAppBar
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 0,
                      leading: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      title: AnimatedBuilder(
                        animation: animationController!,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: _offsetanimation!.value,
                            child: Opacity(
                              opacity: _opacityanimation!.value,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          widget.dish!.dish_name ?? 'Customize',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      expandedHeight: height * 0.4,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                widget.dish!.dish_imageurl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported,
                                      size: 64, color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dish Details Section
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.grey[50],
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dish!.dish_name!,
                                    style: TextStyle(
                                      fontSize: width * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      if (widget.dish!.dish_discount != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Rs \$${widget.dish!.dish_discount}',
                                            style: TextStyle(
                                              fontSize: width * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '\$${widget.dish!.dish_price}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor: Colors.red,
                                            decorationThickness: 2,
                                            fontSize: width * 0.04,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${(((widget.dish!.dish_price! - widget.dish!.dish_discount!) / widget.dish!.dish_price!) * 100).toStringAsFixed(0)}% OFF',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ] else
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Rs \$${widget.dish!.dish_price}',
                                            style: TextStyle(
                                              fontSize: width * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (!widget.isCart!) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.orange[200]!,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart,
                                            color: Colors.orange[900],
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Already in your cart',
                                            style: TextStyle(
                                              color: Colors.orange[900],
                                              fontSize: width * 0.035,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.dish!.dish_description!,
                                    style: TextStyle(
                                      fontSize: width * 0.038,
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Cart Info Card (if applicable)
                            if (widget.isdishscreen &&
                                widget.cartDish!.name != null)
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange[100]!,
                                      Colors.orange[50]!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.orange[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${totalquantity}x',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[900],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${widget.cartDish!.name}',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        BasketScreen.routename,
                                        arguments: {
                                          'dishes': widget.dishes,
                                          'restdata': ref
                                              .read(restaurantProvider.notifier)
                                              .state
                                        },
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[900],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                fontSize: width * 0.035,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Variations Section Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.tune,
                                color: Colors.purple[700],
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Customize Your Order',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Variations List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: widget.variationList!.length,
                        (context, titleVariationindex) {
                          final titleVariation =
                              widget.variationList![titleVariationindex];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: titleVariation.isRequired!
                                    ? Colors.red[100]!
                                    : Colors.grey[200]!,
                                width: 2,
                              ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        titleVariation.variationTitle.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: titleVariation.isRequired!
                                            ? Colors.red[50]
                                            : Colors.green[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        titleVariation.isRequired!
                                            ? 'Required'
                                            : 'Optional',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: titleVariation.isRequired!
                                              ? Colors.red[700]
                                              : Colors.green[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  titleVariation.subtitle.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                ...titleVariation.variations!.map((variation) {
                                  final variationlist =
                                      ref.watch(variationListProvider) ?? [];
                                  final isselected = variationlist
                                      .any((v) => v.id == variation.id);

                                  return Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      color: isselected
                                          ? Colors.orange[50]
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isselected
                                            ? Colors.orange[300]!
                                            : Colors.grey[200]!,
                                      ),
                                    ),
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor: Colors.orange[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              variation.variationName!,
                                              style: TextStyle(
                                                fontWeight: isselected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: variation.variationPrice! > 0
                                                  ? Colors.green[50]
                                                  : Colors.blue[50],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              variation.variationPrice! > 0
                                                  ? '+\$${variation.variationPrice}'
                                                  : 'Free',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: variation.variationPrice! >
                                                        0
                                                    ? Colors.green[700]
                                                    : Colors.blue[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: isselected,
                                      onChanged: (value) {
                                        final updatedList =
                                            List<Variation>.from(variationlist);
                                        if (value == true) {
                                          if (titleVariation.maxSeleted == null ||
                                              updatedList
                                                      .where((v) =>
                                                          v.variation_id ==
                                                          titleVariation.id)
                                                      .length <
                                                  titleVariation.maxSeleted!) {
                                            updatedList.add(
                                              Variation(
                                                totalvariation: 5,
                                                id: variation.id,
                                                variationName:
                                                    variation.variationName,
                                                variationPrice:
                                                    variation.variationPrice,
                                                variation_id:
                                                    variation.variation_id,
                                                selected: true,
                                              ),
                                            );
                                            if (titleVariation.isRequired!) {
                                              withvariation = true;
                                            }
                                          } else {
                                            if (scaffoldMessengerKey
                                                    .currentState !=
                                                null) {
                                              scaffoldMessengerKey.currentState!
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  'You can only select up to ${titleVariation.maxSeleted} options',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                margin: const EdgeInsets.only(
                                                  bottom: 100,
                                                  left: 20,
                                                  right: 20,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                backgroundColor: Colors.red[700],
                                              ));
                                            }
                                          }
                                        } else {
                                          updatedList.removeWhere(
                                              (v) => v.id == variation.id);
                                          if (titleVariation.isRequired!) {
                                            withvariation = false;
                                          }
                                        }

                                        ref
                                            .read(variationListProvider.notifier)
                                            .state = updatedList;
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Frequently Bought Section
                    if (widget.freqList != null && widget.freqList!.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.shopping_basket,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Frequently Bought Together',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Freqdisheslist(
                            screenSize: width,
                            freqList: widget.freqList!,
                          ),
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 120),
                    ),
                  ],
                ),

                // Bottom Action Bar
                if (isloader == false &&
                    widget.variationList != null &&
                    widget.variationList!.isNotEmpty &&
                    widget.variationList!.indexWhere(
                            (element) => element.dishid == widget.dish!.dishid!) !=
                        -1)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: customBottomBar(
                        false,
                        mounted,
                        scaffoldMessengerKey,
                        true,
                        withvariation!,
                        ref,
                        width,
                        widget.isCart!,
                        updatedQuantity,
                        context,
                        widget.dish!,
                        quantity,
                        widget.restaurantData!,
                        height,
                        _debouncer,
                        onAction: () {
                          ref.read(isloaderProvider.notifier).state = true;
                          ref.read(dishMenuRepoProvider).dishMenuCrud(
                              cart: widget.cartDish!,
                              variations: ref
                                  .read(variationListProvider.notifier)
                                  .state,
                              newFreqList:
                                  ref.read(freqnewListProvider.notifier).state,
                              ref: ref,
                              withvariation: withvariation!,
                              debouncer: _debouncer,
                              isCart: widget.isCart!,
                              updatedQuantity: updatedQuantity,
                              dish: widget.dish!,
                              quantity: quantity,
                              context: context);
                          ref
                              .read(dishMenuRepoProvider)
                              .addAllFreqBoughtItems(ref: ref);
                          Navigator.pushNamed(
                            context,
                            RestaurantMenuScreen.routename,
                            arguments: widget.restaurantData,
                          );
                        },
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
}