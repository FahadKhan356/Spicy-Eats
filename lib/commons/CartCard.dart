import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

class CartCard extends ConsumerStatefulWidget {
  CartCard({
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
    this.titleVariationList,
  });
  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final CartModelNew? cartItem;
  final String? userId;
  bool? isCartScreen;
  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;
  List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<CartCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<CartCard> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  // Future<void> fetchtitlevariation() async {
  //   ref.read(dishMenuRepoProvider).fetchTitleVariation(context, dishid: null).then((value) {
  //     if (value != null) {
  //       setState(() {
  //         widget.titleVariationList = value;

  //       });
  //       print("dsddasdadad");
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  build(
    BuildContext context,
  ) {
    List<VariattionTitleModel>? variationLis;
    VariattionTitleModel? variattionTitle;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, DishMenuScreen.routename,
          arguments: {'dish': widget.dish, 'iscart': false}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            height: widget.cardHeight ?? 130,
            width: double.maxFinite,
            child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: widget.elevation ?? 5,
                color: widget.cardColor ?? Colors.white,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            // color: Colors.red,
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                            child: Image.network(
                              widget.isCartScreen!
                                  ? widget.dish!.dish_imageurl.toString()
                                  : widget.cartItem!.image.toString(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              // color: Colors.blue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.isCartScreen!
                                        ? widget.dish!.dish_name.toString()
                                        : widget.cartItem!.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.isCartScreen!
                                        ? widget.dish!.dish_description
                                            .toString()
                                        : widget.cartItem!.description
                                            .toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  widget.isCartScreen!
                                      ? Text(
                                          '\$${widget.dish!.dish_price!.toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        )
                                      : Text(
                                          '\$${widget.cartItem!.tprice!.toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Container(
                        // color: Colors.amber,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.cartItem!.dish_id != widget.dish!.dishid &&
                                    widget.isCartScreen == true
                                ? InkWell(
                                    onTap: () async {
                                      _debouncer.run(() async {
                                        final variationList = await ref
                                            .read(dishMenuRepoProvider)
                                            .fetchVariations(
                                                dishid: widget.dish!.dishid!,
                                                context: context);
                                        if (variationList != null) {
                                          variattionTitle =
                                              variationList.firstWhere(
                                                  (v) =>
                                                      v.dishid ==
                                                      widget.dish!.dishid,
                                                  orElse: () =>
                                                      VariattionTitleModel(
                                                          id: null,
                                                          variationTitle: '',
                                                          isRequired: null,
                                                          variations: [],
                                                          maxSeleted: null,
                                                          dishid: null));
                                          print(
                                              ' title variation id :  ${variattionTitle!.dishid}');
                                          print(
                                              '  dish id :  ${widget.dish!.dishid}');
                                        }
                                        if (variattionTitle != null) {
                                          Navigator.pushNamed(
                                              context, DishMenuScreen.routename,
                                              arguments: {
                                                'dish': widget.dish,
                                                'iscart': false
                                              });
                                        } else {
                                          ref
                                              .read(DummyLogicProvider)
                                              .addToCart(
                                                  widget.dish!.dish_price,
                                                  widget.dish!.dish_name,
                                                  widget.dish!.dish_description,
                                                  ref,
                                                  supabaseClient
                                                      .auth.currentUser!.id,
                                                  widget.dish!.dishid
                                                      .toString(),
                                                  widget.dish!.dish_price!
                                                      .toDouble(),
                                                  widget.dish!.dish_imageurl!);
                                        }
                                      });

                                      // _debouncer.run(() {
                                      //   if (variattionTitle!.dishid ==
                                      //       widget.dish!.dishid) {
                                      //     Navigator.pushNamed(
                                      //         context, DishMenuScreen.routename,
                                      //         arguments: {
                                      //           'dish': widget.dish,
                                      //           'iscart': false
                                      //         });
                                      //   } else {
                                      //     ref
                                      //         .read(DummyLogicProvider)
                                      //         .addToCart(
                                      //             widget.dish!.dish_price,
                                      //             widget.dish!.dish_name,
                                      //             widget.dish!.dish_description,
                                      //             ref,
                                      //             supabaseClient
                                      //                 .auth.currentUser!.id,
                                      //             widget.dish!.dishid
                                      //                 .toString(),
                                      //             widget.dish!.dish_price!
                                      //                 .toDouble(),
                                      //             widget.dish!.dish_imageurl!);
                                      //   }
                                      // });
                                    },
                                    child: Container(
                                      height: widget.addbuttonHeight ?? 50,
                                      width: widget.addbuttonWidth ?? 50,
                                      decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 6,
                                                offset: Offset(-1, -1),
                                                spreadRadius: 1)
                                          ],
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _debouncer.run(() {
                                                ref
                                                    .read(DummyLogicProvider)
                                                    .increaseQuantity(
                                                      ref,
                                                      widget.dish!.dishid!,
                                                      widget.dish!.dish_price!,
                                                    );
                                              });
                                            },
                                            child: Container(
                                              height:
                                                  widget.buttonIncDecHeight ??
                                                      50,
                                              width:
                                                  widget.buttonIncDecHeight ??
                                                      50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))),
                                              child: const Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          //cartItem.quantity.toString(),
                                          ref
                                              .read(cartProvider.notifier)
                                              .state[widget.quantityIndex!]
                                              .quantity
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _debouncer.run(() {
                                                ref
                                                    .read(DummyLogicProvider)
                                                    .decreaseQuantity(
                                                      ref,
                                                      widget.dish!.dishid!,
                                                      widget.dish!.dish_price!,
                                                    );
                                              });
                                            },
                                            child: Container(
                                              height:
                                                  widget.buttonIncDecHeight ??
                                                      50,
                                              width: widget.buttonIncDecWidth ??
                                                  50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Center(
                                                  child: widget.isCartScreen ==
                                                              false &&
                                                          widget.cartItem!
                                                                  .quantity ==
                                                              1
                                                      ? const Icon(
                                                          Icons.delete_rounded,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .minimize_outlined,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
