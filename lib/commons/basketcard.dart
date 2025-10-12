import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Cartmodel.dart';

import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';


class BasketCard extends ConsumerStatefulWidget {
  BasketCard({
    super.key,
    this.cardHeight,
    required this.elevation,
    required this.cardColor,
    required this.dish,
    required this.imageHeight,
    required this.imageWidth,
    required this.cartItem,
    required this.userId,
    required this.isCartScreen,
    required this.quantityIndex,
    this.addbuttonHeight,
    this.addbuttonWidth,
    this.buttonIncDecHeight,
    this.buttonIncDecWidth,
    required this.titleVariationList,
  });
  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final Cartmodel? cartItem;
  final String? userId;
  bool? isCartScreen;
  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;
  List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<BasketCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<BasketCard> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  build(BuildContext context) {
    final cartRepo = ref.read(cartReopProvider);
    final cart = widget.cartItem;
    final dish = widget.dish;
    final cartlistener = ref.watch(cartProvider);
    // final quantityindex=cartlistener.indexWhere((element) => element.cart_id=,)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
          height: widget.cardHeight ?? 130,
          width: double.maxFinite,
          child: Card(
              surfaceTintColor: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: widget.elevation ?? 5,
              color: widget.cardColor ?? Colors.white,
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.grey[100],
                                height: widget.imageHeight,
                                width: widget.imageWidth,
                                child: Image.network(
                                  widget.cartItem!.image.toString(),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              // color: Colors.blue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.cartItem!.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                               
                                  Text(
                                    '\$${widget.cartItem?.tprice?.toStringAsFixed(1) ?? ''}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  widget.cartItem!.variation != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: widget.cartItem!.variation!
                                              .map((e) => Row(
                                                    children: [
                                                      Text(e.variationName!),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Text('-',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      e.variationPrice == 0
                                                          ? const Text(
                                                              'Free',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                color: Colors
                                                                    .black,
                                                                child: Text(
                                                                  '\$${e.variationPrice} x ${widget.cartItem!.quantity}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ))
                                              .toList(),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: SizedBox(
                        // color: Colors.amber,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _debouncer.run(() {
                                          cartRepo.incQuantity(
                                              ref: ref,
                                              cartId: widget.cartItem!.cart_id!,
                                              price: widget.cartItem!.itemprice!);

                                        });
                                      },
                                      child: Container(
                                        height: widget.buttonIncDecHeight ?? 50,
                                        width: widget.buttonIncDecHeight ?? 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        child: const Icon(
                                          Icons.add,
                                          size: 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    ref
                                        .read(cartProvider.notifier)
                                        .state[widget.quantityIndex!]
                                        .quantity
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                               
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _debouncer.run(() async {
                                          cartRepo.decQuantity(
                                              ref: ref,
                                              cartId: widget.cartItem!.cart_id!,
                                              price: widget.cartItem!.itemprice!);

                                         
                                        });
                                      },
                                      child: Container(
                                        height: widget.buttonIncDecHeight ?? 50,
                                        width: widget.buttonIncDecWidth ?? 50,
                                        decoration:  BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))),
                                        child: Center(
                                            child:
                                                widget.cartItem!.quantity == 1
                                                    ? const Icon(
                                                        Icons.delete_outlined,
                                                        size: 24,
                                                        color: Colors.black,
                                                      )
                                                    : const Icon(
                                                        Icons.minimize_outlined,
                                                        size: 24,
                                                        color: Colors.black,
                                                      )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]))),
    );
  }
}


// // Enhanced BasketCard - More compact and beautiful
// class BasketCard extends ConsumerStatefulWidget {
//   BasketCard({
//     super.key,
//     this.cardHeight,
//     required this.elevation,
//     required this.cardColor,
//     required this.dish,
//     required this.imageHeight,
//     required this.imageWidth,
//     required this.cartItem,
//     required this.userId,
//     required this.isCartScreen,
//     required this.quantityIndex,
//     this.addbuttonHeight,
//     this.addbuttonWidth,
//     this.buttonIncDecHeight,
//     this.buttonIncDecWidth,
//     required this.titleVariationList,
//   });

//   final double? cardHeight;
//   final double? elevation;
//   final Color? cardColor;
//   final DishData? dish;
//   final double? imageHeight;
//   final double? imageWidth;
//   final Cartmodel? cartItem;
//   final String? userId;
//   bool? isCartScreen;
//   int? quantityIndex;
//   double? addbuttonHeight;
//   double? addbuttonWidth;
//   double? buttonIncDecHeight;
//   double? buttonIncDecWidth;
//   List<VariattionTitleModel>? titleVariationList;

//   @override
//   ConsumerState<BasketCard> createState() => _CartCardState();
// }

// class _CartCardState extends ConsumerState<BasketCard> {
//   final Debouncer _debouncer = Debouncer(milliseconds: 500);

//   @override
//   Widget build(BuildContext context) {
//     final cartRepo = ref.read(cartReopProvider);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Dish Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 color: Colors.grey[100],
//                 height: widget.imageHeight,
//                 width: widget.imageWidth,
//                 child: Image.network(
//                   widget.cartItem!.image.toString(),
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Icon(
//                     Icons.restaurant,
//                     size: 32,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Dish Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.cartItem!.name.toString(),
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                  //for testing 
//                   Text(
//                     widget.cartItem!.restaurant_name!,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),

//                   // Price Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 5,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green[50],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       '\$${widget.cartItem?.tprice?.toStringAsFixed(2) ?? ''}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[700],
//                       ),
//                     ),
//                   ),

//                   // Variations (if any)
//                   if (widget.cartItem!.variation != null &&
//                       widget.cartItem!.variation!.isNotEmpty) ...[
//                     const SizedBox(height: 8),
//                     ...widget.cartItem!.variation!.take(2).map((e) => Padding(
//                           padding: const EdgeInsets.only(bottom: 3),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 4,
//                                 height: 4,
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange[400],
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               const SizedBox(width: 6),
//                               Expanded(
//                                 child: Text(
//                                   '${e.variationName}${e.variationPrice! > 0 ? ' (+\$${e.variationPrice})' : ' (Free)'}',
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.grey[600],
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )),
//                     if (widget.cartItem!.variation!.length > 2)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 2),
//                         child: Text(
//                           '+${widget.cartItem!.variation!.length - 2} more',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey[500],
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),

//             // Quantity Controls
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Column(
//                 children: [
//                   // Increment
//                   InkWell(
//                     onTap: () {
//                       _debouncer.run(() {
//                         cartRepo.incQuantity(
//                           ref: ref,
//                           cartId: widget.cartItem!.cart_id!,
//                           price: widget.dish!.dish_price!,
//                         );
//                       });
//                     },
//                     child: Container(
//                       width: 34,
//                       height: 34,
//                       decoration: BoxDecoration(
//                         color: Colors.orange[50],
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(12),
//                           topRight: Radius.circular(12),
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.add,
//                         size: 18,
//                         color: Colors.orange[700],
//                       ),
//                     ),
//                   ),

//                   // Quantity Display
//                   Container(
//                     width: 34,
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Text(
//                       ref
//                           .read(cartProvider.notifier)
//                           .state[widget.quantityIndex!]
//                           .quantity
//                           .toString(),
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),

//                   // Decrement/Delete
//                   InkWell(
//                     onTap: () {
//                       _debouncer.run(() async {
//                         cartRepo.decQuantity(
//                           ref: ref,
//                           cartId: widget.cartItem!.cart_id!,
//                           price: widget.dish!.dish_price ?? 0,
//                         );
//                       });
//                     },
//                     child: Container(
//                       width: 34,
//                       height: 34,
//                       decoration: BoxDecoration(
//                         color: widget.cartItem!.quantity == 1
//                             ? Colors.red[50]
//                             : Colors.grey[100],
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(12),
//                           bottomRight: Radius.circular(12),
//                         ),
//                       ),
//                       child: Icon(
//                         widget.cartItem!.quantity == 1
//                             ? Icons.delete_outline
//                             : Icons.remove,
//                         size: 18,
//                         color: widget.cartItem!.quantity == 1
//                             ? Colors.red[700]
//                             : Colors.grey[700],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }