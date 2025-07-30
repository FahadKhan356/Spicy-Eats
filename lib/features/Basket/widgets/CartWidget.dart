import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/commons/quantity_button.dart';
import 'package:spicy_eats/features/Basket/model/basketModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';

class CartWidget extends ConsumerWidget {
  const CartWidget({
    super.key,
    required this.cartItemName,
    required this.cartItemQuantity,
    required this.cartItemTotalprice,
    required this.cartItemimageUrl,
    required this.cartitem,
  });
  final String cartItemName;
  final int cartItemQuantity;
  final String cartItemimageUrl;
  final double cartItemTotalprice;
  final BasketModel cartitem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      final itemQuantity = ref
          .read(quantityProvider)
          .firstWhere((element) => element.id == cartitem.itemId);
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                  cartItemimageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                cartItemTotalprice.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          ),
          Row(
            children: [
              Container(
                // width:
                //     size.width *
                //         0.09,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]),
                child: Row(
                  children: [
                    QuantityButton(
                      radiustopleft: 10,
                      radiustopright: 10,
                      radiusbottomleft: 10,
                      radiusbottomright: 10,
                      // buttonradius:
                      //     10,
                      buttonheight: size.width * 0.09,
                      buttonwidth: size.width * 0.09,
                      icon: Icons.remove,
                      iconColor: Colors.white,
                      iconSize: size.width * 0.055,
                      bgcolor: Colors.black,
                      onpress: () {
                        int dishindex = ref
                            .read(quantityProvider.notifier)
                            .state
                            .indexWhere(
                                (element) => element.id == cartitem.itemId);

                        if (dishindex != -1) {
                          ref.read(quantityProvider.notifier).update((state) {
                            if (state[dishindex].quantity > 0) {
                              state[dishindex].quantity--;
                            }
                            return [...state];
                          });
                        }

                        int cartindex = ref.read(cartList).indexWhere(
                            (item) => item.itemId == cartitem.itemId);
                        print('item at cartlist cartindex..$cartindex');

                        if (cartindex != -1 &&
                            ref.read(cartList)[cartindex].itemTotalQuantity >
                                1) {
                          ref
                              .read(cartList.notifier)
                              .state[cartindex]
                              .itemTotalQuantity--;
                        } else {
                          ref.read(cartList).removeAt(cartindex);
                          print('not removing..');
                        }

                        print(
                            ' cart list length : ${ref.read(cartList).length}');
                        if (ref.read(cartList).isEmpty) {
                          ref.read(showCartButton.notifier).state = false;
                        }

                        print('this is item ${itemQuantity.quantity}');
                        ('this is bool value ${ref.read(showCartButton.notifier).state}');
                        final cartlength =
                            ref.watch(cartList.notifier).state.length;
                        ref
                            .read(cartLength.notifier)
                            .update((state) => state = cartlength);
                        print('cart length : $cartlength');
                      },
                    ),
                    Center(
                      child: Text(
                        " ${itemQuantity.quantity}",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    QuantityButton(
                      radiusbottomleft: 10,
                      radiusbottomright: 10,
                      radiustopleft: 10,
                      radiustopright: 10,
                      // radiustopleft:
                      //     10,
                      // radiustopright:
                      //     10,
                      // buttonradius:
                      //     10,
                      icon: Icons.add,
                      iconColor: Colors.white,
                      iconSize: size.width * 0.055,
                      bgcolor: Colors.black,
                      buttonheight: size.width * 0.08,
                      buttonwidth: size.width * 0.09,
                      onpress: () {
                        double itemTotalprice = 0.0;

                        final dishIndex = ref
                            .read(quantityProvider.notifier)
                            .state
                            .indexWhere((item) => item.id == cartitem.itemId);
                        if (dishIndex != -1) {
                          ref.read(quantityProvider.notifier).update((state) {
                            state[dishIndex].quantity++;

                            print('this is item ${itemQuantity.quantity}');
                            ('this is bool value ${ref.read(showCartButton.notifier).state}');
                            final totalquantity = ref
                                .read(quantityProvider.notifier)
                                .state[dishIndex]
                                .quantity;
                            itemTotalprice = (totalquantity *
                                (cartitem.itemTotalPrice!.toDouble()));

                            print('itemtotalprice : $itemTotalprice');

                            int cartItemIndex = ref
                                .read(cartList.notifier)
                                .state
                                .indexWhere((item) =>
                                    item.itemId ==
                                    ref
                                        .read(quantityProvider.notifier)
                                        .state[dishIndex]
                                        .id);

                            if (cartItemIndex != -1) {
                              // If the item exists in the cartList, update its quantity and total price
                              ref
                                  .read(cartList)[cartItemIndex]
                                  .itemTotalQuantity = totalquantity;
                              ref.read(cartList)[cartItemIndex].itemTotalPrice =
                                  itemTotalprice;
                              print(
                                  "Cart List after addition: ${ref.read(cartList.notifier).state.length}");
                            } else {
                              // If the item is not in the cartList, add it as a new entry
                              print(
                                  'item id in cart list ${ref.read(cartList)[0].itemId}');
                              print(' ${cartitem.itemId}');

                              // Item does not exist, add as new item to cart
                              ref.read(cartList.notifier).update((state) {
                                return [
                                  ...state,
                                  BasketModel(
                                    itemId: cartitem.itemId,
                                    itemName: cartitem.itemName.toString(),
                                    itemTotalPrice: itemTotalprice,
                                    itemTotalQuantity: 1,
                                    cartItemImageUrl: cartitem.cartItemImageUrl,
                                  ),
                                ];
                              });
                              print(
                                  "Cart List after addition: ${ref.read(cartList.notifier).state.length}");
                              final cartlength =
                                  ref.watch(cartList.notifier).state.length;
                              ref
                                  .read(cartLength.notifier)
                                  .update((state) => state = cartlength);
                              print('cart length : $cartlength');
                            }

                            // Print for debugging

                            if (ref.read(cartList).isNotEmpty) {
                              ref.read(showCartButton.notifier).state = true;
                            }

                            print('itemtotalprice : $itemTotalprice');

                            return [...state]; // return a new state
                          });
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          )
        ],
      );
    });
  }
}
