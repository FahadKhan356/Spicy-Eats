import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/commons/quantity_button.dart';
import 'package:spicy_eats/features/Basket/model/CartModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';

final totalQuantityprovider = StateProvider<int?>((ref) => null);

class SliverBodyItems extends ConsumerStatefulWidget {
  SliverBodyItems({super.key, required this.listItems});

  //List<Product> listItems;
  final List<DishData> listItems;

  @override
  ConsumerState<SliverBodyItems> createState() => _SliverBodyItemsState();
}

class _SliverBodyItemsState extends ConsumerState<SliverBodyItems> {
  //List<CartModel> cartlist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // addDishestoItemQuantity();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   addDishestoItemQuantity();
    // });
  }

  // void addDishestoItemQuantity() {
  //   List<ItemQuantity> tempItemQuantityList = [];
  //   for (int i = 0; i < widget.listItems.length; i++) {
  //     tempItemQuantityList.add(ItemQuantity(id: widget.listItems[i].dishid!));
  //     // final item = ref.read(quantityProvider);
  //     print('${ref.read(quantityProvider.notifier).state}');
  //   }

  //   ref.read(quantityProvider.notifier).update((state) => tempItemQuantityList);
  // }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.listItems.length,
        (context, index) {
          final product = widget.listItems[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                const Divider(
                  color: Colors.black38,
                  thickness: 2,
                ),
                Consumer(builder: (context, ref, child) {
                  final itemQuantity = ref.watch(quantityProvider).firstWhere(
                        (item) => item.id == product.dishid,
                        orElse: () => ItemQuantity(
                          id: widget.listItems[index].dishid!,
                          quantity: 0,
                        ),
                      );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38, // Adjust shadow opacity
                                offset: Offset(1, 1),
                                // spreadRadius: ,
                                blurRadius: 6,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.listItems[index].dish_imageurl!,
                              fit: BoxFit.contain,
                              width: size.width * 0.20,
                              height: size.width * 0.20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.dish_name!,
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.dish_description!,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: size.width * 0.04,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$ ${product.dish_price}",
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceInOut,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity:
                                        itemQuantity.quantity > 0 ? 1.0 : 1.0,
                                    child: itemQuantity.quantity > 0
                                        ? Container(
                                            // width:
                                            //     size.width *
                                            //         0.09,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey[200]),
                                            child: Column(
                                              children: [
                                                QuantityButton(
                                                  radiustopleft: 10,
                                                  radiustopright: 10,
                                                  // buttonradius:
                                                  //     10,
                                                  buttonheight:
                                                      size.width * 0.09,
                                                  buttonwidth:
                                                      size.width * 0.09,
                                                  icon: Icons.remove,
                                                  iconColor: Colors.white,
                                                  iconSize: size.width * 0.055,
                                                  bgcolor: Colors.black,
                                                  onpress: () {
                                                    int dishindex = ref
                                                        .read(quantityProvider
                                                            .notifier)
                                                        .state
                                                        .indexWhere((element) =>
                                                            element.id ==
                                                            product.dishid);

                                                    if (dishindex != -1) {
                                                      ref
                                                          .read(quantityProvider
                                                              .notifier)
                                                          .update((state) {
                                                        if (state[dishindex]
                                                                .quantity >
                                                            0) {
                                                          state[dishindex]
                                                              .quantity--;
                                                        }
                                                        return [...state];
                                                      });
                                                    }

                                                    int cartindex = ref
                                                        .read(cartList)
                                                        .indexWhere((item) =>
                                                            item.itemId ==
                                                            product.dishid);

                                                    if (cartindex != -1) {
                                                      if (ref
                                                              .read(cartList)[
                                                                  cartindex]
                                                              .itemTotalQuantity >
                                                          1) {
                                                        ref
                                                            .read(cartList
                                                                .notifier)
                                                            .state[cartindex]
                                                            .itemTotalQuantity--;
                                                      } else {
                                                        ref
                                                            .read(cartList)
                                                            .removeAt(
                                                                cartindex);
                                                        print('not removing..');
                                                      }
                                                    }

                                                    if (ref
                                                        .read(cartList)
                                                        .isEmpty) {
                                                      ref
                                                          .read(showCartButton
                                                              .notifier)
                                                          .state = false;
                                                    }

                                                    final cartlength = ref
                                                        .watch(
                                                            cartList.notifier)
                                                        .state
                                                        .length;
                                                    ref
                                                        .read(
                                                            cartLength.notifier)
                                                        .update((state) =>
                                                            state = cartlength);
                                                    print(
                                                        'cart length : $cartlength');
                                                  },
                                                ),
                                                Center(
                                                  child: Text(
                                                    " ${itemQuantity.quantity}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.05,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                QuantityButton(
                                                  radiusbottomleft: 10,
                                                  radiusbottomright: 10,
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
                                                  buttonheight:
                                                      size.width * 0.08,
                                                  buttonwidth:
                                                      size.width * 0.09,
                                                  onpress: () {
                                                    double itemTotalprice = 0.0;

                                                    final dishIndex = ref
                                                        .read(quantityProvider
                                                            .notifier)
                                                        .state
                                                        .indexWhere((item) =>
                                                            item.id ==
                                                            product.dishid);
                                                    if (dishIndex != -1) {
                                                      ref
                                                          .read(quantityProvider
                                                              .notifier)
                                                          .update((state) {
                                                        state[dishIndex]
                                                            .quantity++;

                                                        final totalquantity = ref
                                                            .read(
                                                                quantityProvider
                                                                    .notifier)
                                                            .state[dishIndex]
                                                            .quantity;
                                                        itemTotalprice += (1 *
                                                            (product.dish_price!
                                                                .toDouble()));

                                                        int cartItemIndex = ref
                                                            .read(cartList
                                                                .notifier)
                                                            .state
                                                            .indexWhere((item) =>
                                                                item.itemId ==
                                                                ref
                                                                    .read(quantityProvider
                                                                        .notifier)
                                                                    .state[
                                                                        dishIndex]
                                                                    .id);

                                                        if (cartItemIndex !=
                                                            -1) {
                                                          // If the item exists in the cartList, update its quantity and total price
                                                          ref
                                                                  .read(cartList)[
                                                                      cartItemIndex]
                                                                  .itemTotalQuantity =
                                                              totalquantity;
                                                          ref
                                                                  .read(cartList)[
                                                                      cartItemIndex]
                                                                  .itemTotalPrice =
                                                              itemTotalprice;
                                                        } else {
                                                          // If the item is not in the cartList, add it as a new entry

                                                          // Item does not exist, add as new item to cart
                                                          ref
                                                              .read(cartList
                                                                  .notifier)
                                                              .update((state) {
                                                            return [
                                                              ...state,
                                                              CartModel(
                                                                itemId: product
                                                                    .dishid!,
                                                                itemName: product
                                                                    .dish_name
                                                                    .toString(),
                                                                itemTotalPrice:
                                                                    itemTotalprice,
                                                                itemTotalQuantity:
                                                                    1,
                                                                cartItemImageUrl:
                                                                    product
                                                                        .dish_imageurl,
                                                              ),
                                                            ];
                                                          });
                                                          print(
                                                              "Cart List after addition: ${ref.read(cartList.notifier).state.length}");
                                                          final cartlength = ref
                                                              .watch(cartList
                                                                  .notifier)
                                                              .state
                                                              .length;
                                                          ref
                                                              .read(cartLength
                                                                  .notifier)
                                                              .update((state) =>
                                                                  state =
                                                                      cartlength);
                                                          print(
                                                              'cart length : $cartlength');
                                                        }

                                                        // Print for debugging

                                                        if (ref
                                                            .read(cartList)
                                                            .isNotEmpty) {
                                                          ref
                                                              .read(
                                                                  showCartButton
                                                                      .notifier)
                                                              .state = true;
                                                        }

                                                        print(
                                                            'itemtotalprice : $itemTotalprice');

                                                        return [
                                                          ...state
                                                        ]; // return a new state
                                                      });
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        : QuantityButton(
                                            bgcolor: Colors.black,
                                            buttonheight: size.width * 0.08,
                                            buttonwidth: size.width * 0.09,
                                            // buttonradius:
                                            //     10,
                                            radiustopleft: 10,
                                            radiustopright: 10,
                                            radiusbottomleft: 10,
                                            radiusbottomright: 10,
                                            icon: Icons.add,
                                            iconColor: Colors.white,
                                            iconSize: size.width * 0.055,
                                            onpress: () {
                                              double itemTotalprice = 0.0;
                                              var dish = ref
                                                  .read(
                                                      quantityProvider.notifier)
                                                  .state
                                                  .indexWhere((item) =>
                                                      item.id ==
                                                      product.dishid);
                                              if (dish != -1) {
                                                ref
                                                    .read(quantityProvider
                                                        .notifier)
                                                    .update((state) {
                                                  state[dish].quantity++;

                                                  return [...state];
                                                });
                                              }

                                              ref
                                                      .read(
                                                          totalQuantityprovider
                                                              .notifier)
                                                      .state =
                                                  ref
                                                      .read(quantityProvider
                                                          .notifier)
                                                      .state[dish]
                                                      .quantity;
                                              itemTotalprice = (ref
                                                      .read(quantityProvider
                                                          .notifier)
                                                      .state[dish]
                                                      .quantity *
                                                  (product.dish_price!
                                                      .toDouble()));

                                              print(
                                                  'itemtotalprice : $itemTotalprice');

                                              var newcart = CartModel(
                                                  cartItemImageUrl:
                                                      product.dish_imageurl,
                                                  itemId: product.dishid!,
                                                  itemName: product.dish_name
                                                      .toString(),
                                                  itemTotalPrice:
                                                      itemTotalprice,
                                                  itemTotalQuantity: ref
                                                      .read(quantityProvider
                                                          .notifier)
                                                      .state[dish]
                                                      .quantity);

                                              // ref
                                              //     .read(cartList.notifier)
                                              //     .state
                                              //     .add(newcart);

                                              // final cartlistLength =
                                              //     ref.read(cartList.notifier);

                                              // ref
                                              //         .read(showCartButton.notifier)
                                              //         .state =
                                              //     cartlistLength.state.isEmpty;
                                              ref
                                                  .read(cartList.notifier)
                                                  .state
                                                  .add(newcart);
                                              print(
                                                  "Cart List after addition: ${ref.read(cartList.notifier).state.length}");
                                              final cartlength =
                                                  ref.watch(cartList).length;
                                              ref
                                                  .read(cartLength.notifier)
                                                  .update((state) =>
                                                      state = cartlength);
                                              print(
                                                  'cart length : $cartlength');

                                              if (ref
                                                  .read(cartList)
                                                  .isNotEmpty) {
                                                ref
                                                    .read(
                                                        showCartButton.notifier)
                                                    .state = true;
                                              }

                                              print(
                                                  'this is item ${itemQuantity.quantity}');
                                              ('this is bool value ${ref.read(showCartButton.notifier).state}');
                                            },
                                          )),
                              ]),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
