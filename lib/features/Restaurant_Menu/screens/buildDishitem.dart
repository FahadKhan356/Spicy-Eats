import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

class BuildDishItem extends ConsumerStatefulWidget {
  BuildDishItem({
    super.key,
    this.cardHeight,
    required this.elevation,
    required this.cardColor,
    required this.dish,
    required this.imageHeight,
    required this.imageWidth,
    required this.cartItem,
    required this.userId,
    required this.quantityIndex,
    this.addbuttonHeight,
    this.addbuttonWidth,
    this.buttonIncDecHeight,
    this.buttonIncDecWidth,
    required this.titleVariationList,
    required this.restaurantdata,
  });

  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final Cartmodel? cartItem;
  final String? userId;
  final RestaurantModel restaurantdata;

  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;
  final List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<BuildDishItem> createState() => _BuildDishItemState();
}

class _BuildDishItemState extends ConsumerState<BuildDishItem> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  bool isExpanded = false;
  Timer? _timerCollapse;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerCollapse?.cancel();
  }

  void expandbutton() {
    setState(() {
      isExpanded = true;
      startcollapseTimer();
    });
  }

  void startcollapseTimer() {
    _timerCollapse?.cancel();
    _timerCollapse = Timer(const Duration(seconds: 2), () {
      setState(() {
        isExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cartItem;
    final dish = widget.dish;
    final cartlistener = ref.watch(cartProvider);
    final index =
        cartlistener.indexWhere((element) => (element as Cartmodel).dish_id == dish!.dishid!);

    final quantity =
        ref.read(cartReopProvider).getTotalQuantityofdish(ref, dish!.dishid!);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Responsive.w16px, vertical: Responsive.w8px),
      padding:  EdgeInsets.all(Responsive.w12px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.w12px),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.dish?.isVeg != null
                        ? Icon(
                            widget.dish!.isVeg!
                                ? Icons.crop_square
                                : Icons.stop,
                            color:
                                widget.dish!.isVeg! ? Colors.green : Colors.red,
                            size: 16,
                          )
                        : const Icon(Icons.more_outlined),
                     SizedBox(width: Responsive.w8px),
                    Expanded(
                      child: Text(
                        widget.dish!.dish_name!,
                        style:  TextStyle(
                          fontSize: Responsive.w16px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.w4px),
                Text(
                  widget.dish!.dish_description!,
                  style: TextStyle(
                    fontSize: Responsive.w16px,
                    color: Colors.grey[600],
                  ),
                ),
                 SizedBox(height: Responsive.w8px),
                Text(
                  '\$${widget.dish!.dish_price!.toStringAsFixed(2)}',
                  style:  TextStyle(
                    fontSize: Responsive.w14px,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
               
              ],
            ),
          ),
           SizedBox(width: Responsive.w12px),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Responsive.w8px),
                child: Image.network(
                  widget.dish!.dish_imageurl!,
                  width: Responsive.w80px,
                  height: Responsive.w80px,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: Responsive.w80px,
                      height: Responsive.w80px,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    );
                  },
                ),
              ),
           Positioned(
            bottom: 0,
            right: 0,
            child:  Row(
              children: [
                Flexible(
                      flex: 0,
                      child: Container(
                          // color: Colors.amber,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            if (dish.isVariation == true) ...[
                              InkWell(
                                onTap: () async {
                                  _debouncer.run(() async {
                                    Navigator.pushNamed(
                                        context, DishMenuVariation.routename,
                                        arguments: {
                                          'dish': widget.dish,
                                          'iscart': false,
                                          'cartdish': widget.cartItem,
                                          'isbasket': false,
                                          'isdishscreen': true,
                                          'restaurantdata': widget.restaurantdata,
                                        });
                                    // }
                                  });
                                },
                                child: Container(
                                  height: widget.addbuttonHeight ?? 40,
                                  width: widget.addbuttonWidth ?? 40,
                                  decoration: const BoxDecoration(
                                
                                    color: Colors.black,
                                    // borderRadius: BorderRadius.circular(Responsive.w10px),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: cart!.dish_id == dish.dishid &&
                                            dish.isVariation
                                        ? Text(
                                            quantity.toString(),
                                            style:  TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: Responsive.w16px),
                                          )
                                        :  Icon(
                                            Icons.add,
                                            size: Responsive.w25px ,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox()
                            ],
                            if (dish.isVariation == false)
                              //&& cart!.dish_id != dish.dishid)
                              AnimatedContainer(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: isExpanded? BorderRadius.circular(Responsive.w80px/2):BorderRadius.circular(Responsive.w40px/2),
                                ),
                                width: isExpanded ? Responsive.w80px : Responsive.w40px,
                                height: Responsive.w40px,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 300),
                                child: isExpanded
                                    ? FittedBox(
                                        child: Row(
                                          children: [
                                            iconButton(Icons.add, () {
                                              // final currentcarmodel =
                                              //     cartlistener.firstWhere(
                                              //         (e) =>
                                              //             e.dish_id == dish.dishid,
                                              //         orElse: () => Cartmodel(
                                              //             created_at: '',
                                              //             quantity: 1));
                
                                       
                                         
                                              ref
                                                  .read(cartReopProvider)
                                                  .incQuantity(
                                                      ref: ref,
                                                      cartId: cart!.cart_id!,
                                                      price: dish.dish_price!);
                                            }),
                                            AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                transitionBuilder:
                                                    (child, animation) =>
                                                        ScaleTransition(
                                                          scale: animation,
                                                          child: child,
                                                        ),
                                                child: index != -1
                                                    ? Text(
                                                        quantity.toString(),
                                                        key:
                                                            ValueKey<int>(quantity),
                                                        style: TextStyle(
                                                            fontSize: Responsive.w16px,
                                                            color: Colors.white),
                                                      )
                                                    :  Text(
                                                        '0',
                                                        key: const ValueKey<int>(0),
                                                        style: TextStyle(
                                                            fontSize: Responsive.w16px,
                                                            color: Colors.white),
                                                      )),
                                            iconButton(Icons.remove, () {
                                            
                                              ref
                                                  .read(cartReopProvider)
                                                  .decQuantity(
                                                      ref: ref,
                                                      cartId: cart?.cart_id ?? 0,
                                                      price: dish.dish_price!);
                                            })
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          final isInCart = ref
                                              .read(cartProvider.notifier)
                                              .state
                                              .indexWhere((element) =>
                                                 ( element as Cartmodel).dish_id == dish.dishid);
                                          if (isInCart == -1) {
                                            ref.read(cartReopProvider).addCartItem(
                                              restaurantName: widget.restaurantdata.restaurantName,
                                              restaurantId: widget.restaurantdata.restuid!,
                                                itemprice: dish.dish_price!,
                                                name: dish.dish_name,
                                                description: dish.dish_description,
                                                ref: ref,
                                                userId: supabaseClient
                                                    .auth.currentUser!.id,
                                                dishId: dish.dishid!,
                                                discountprice: dish.dish_discount,
                                                price: dish.dish_price,
                                                image: dish.dish_imageurl!,
                                                variations: null,
                                                isdishScreen: false,
                                                quantity: 1,
                                                freqboughts: null);
                
                                            expandbutton();
                                           
                                          } else {
                                         
                                            setState(() {
                                              expandbutton();
                                            });
                                           
                                          }
                                        },
                                        child: cartlistener.any((element) =>
                                               ( element as Cartmodel).dish_id == dish.dishid)
                                            ? Container(
                                                height: Responsive.w40px,
                                                width:  Responsive.w40px,
                                                decoration: const BoxDecoration(
                                                   
                                                    
                                                      
                                                            shape: BoxShape.circle),
                                                child: Center(
                                                  child: Text(
                                                    quantity.toString(),
                                                    style:  TextStyle(
                                                        color: Colors.white,
                                                        fontSize: Responsive.w16px,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: Responsive.w40px,
                                                width: Responsive.w40px,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(Responsive.w10px),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              )),
                              ),
                          ])),
                    ),
              ],
            ),)
           
            ],
          ),
        ],
      ),
    );
  }
}

Widget iconButton(IconData icon, VoidCallback onpress) {
  return InkWell(
    onTap: onpress,
    child: Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle
  
      ),
      height: Responsive.w40px,
      width: Responsive.w40px,
      child: Icon(
        icon,
        color: Colors.white,
        size: Responsive.w20px,
      ),
    ),
  );
}
