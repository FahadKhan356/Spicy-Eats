import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  List<VariattionTitleModel> variationList = [];
  bool isCart = false;
  CartModelNew? cartDish;
  DishMenuScreen(
      {super.key, required this.dish, this.cartDish, required this.isCart});

  @override
  ConsumerState<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuScreen> {
  Future<void> fetchVariations(int dishId) async {
    ref
        .read(dishMenuRepoProvider)
        .fetchVariations(dishid: dishId, context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          widget.variationList = value;

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.variationList[0].variationTitle!)));
          print('${widget.variationList[0].variationTitle}');
        });
        print('not fetch dishmenuList${value}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVariations(widget.dish!.dishid!);
  }

  @override
  Widget build(BuildContext context) {
    final selectedVariations = ref.watch(variationProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                // title: Text('data'),
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    widget.dish!.dish_imageurl!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.dish!.dish_name!,
                            style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            ' from Rs ${widget.dish!.dish_price}',
                            style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.dish!.dish_description!,
                            style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300),
                          ),
                        ]),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.variationList.length,
                      (context, titleVariationindex) {
                final titleVariation =
                    widget.variationList[titleVariationindex];
                if (widget.isCart && widget.cartDish?.variation != null) {
                  ref.read(variationProvider.notifier).state = {
                    ...ref.read(variationProvider),
                    widget.cartDish!.variationId!: widget.cartDish!.variation!,
                  };
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  titleVariation.variationTitle.toString(),
                                  style: const TextStyle(fontSize: 22),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    color: titleVariation.isRequired!
                                        ? Colors.red
                                        : Colors.green,
                                    child: titleVariation.isRequired!
                                        ? const Text(
                                            'Required',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                        : const Text(
                                            'optional',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87),
                                          ),
                                  ),
                                ),
                              ]),
                          Text(
                            titleVariation.subtitle.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          ...titleVariation.variations!.map((variation) {
                            final selectedlist =
                                selectedVariations[titleVariation.id] ?? [];
                            final isSelected =
                                selectedlist.any((v) => v.id == variation.id);
                            // selectedVariations[titleVariation.id]?.id ==
                            //     variation.id;

                            return CheckboxListTile(
                              title: variation.variationPrice! > 0
                                  ? Row(
                                      children: [
                                        Text(("${variation.variationName})")),
                                        Text(
                                            " (\$${variation.variationPrice})"),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(("${variation.variationName}")),
                                        const Text(" Free")
                                      ],
                                    ),
                              value: isSelected,
                              onChanged: (value) {
                                final updatedList =
                                    List<Variation>.from(selectedlist);
                                if (value == true) {
                                  if (titleVariation.maxSeleted == null ||
                                      updatedList.length <
                                          titleVariation.maxSeleted!) {
                                    updatedList.add(
                                      Variation(
                                          id: variation.id,
                                          variationName:
                                              variation.variationName,
                                          variationPrice:
                                              variation.variationPrice,
                                          variation_id: variation.variation_id),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'you can only select upto ${titleVariation.maxSeleted} options')));
                                  }
                                } else {
                                  updatedList
                                      .removeWhere((v) => v.id == variation.id);
                                }

                                ref.read(variationProvider.notifier).state = {
                                  ...selectedVariations,
                                  titleVariation.id!: updatedList,
                                };
                              },
                            );
                          }),
                        ],
                      )),
                );
              })),
              //   SliverList(
              //       delegate: SliverChildBuilderDelegate(
              //           childCount: widget.VariationList.length,
              //           (context, index) => Text('sdd'))),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                ),
              )
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                      color: Colors.black26,
                    ))),
                height: 80,
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //  Flexible(
                    //     flex: 0,
                    //     child: Container(
                    //       // color: Colors.amber,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           widget.cartItem!.dish_id != widget.dish!.dishid &&
                    //                   widget.isCartScreen == true
                    //               ? InkWell(
                    //                   onTap: () async {
                    //                     _debouncer.run(() async {
                    //                       final variationList = await ref
                    //                           .read(dishMenuRepoProvider)
                    //                           .fetchVariations(
                    //                               dishid: widget.dish!.dishid!,
                    //                               context: context);
                    //                       if (variationList != null) {
                    //                         variattionTitle =
                    //                             variationList.firstWhere(
                    //                                 (v) =>
                    //                                     v.dishid ==
                    //                                     widget.dish!.dishid,
                    //                                 orElse: () =>
                    //                                     VariattionTitleModel(
                    //                                         id: null,
                    //                                         variationTitle: '',
                    //                                         isRequired: null,
                    //                                         variations: [],
                    //                                         maxSeleted: null,
                    //                                         dishid: null));
                    //                         print(
                    //                             ' title variation id :  ${variattionTitle!.dishid}');
                    //                         print(
                    //                             '  dish id :  ${widget.dish!.dishid}');
                    //                       }
                    //                       if (variattionTitle != null) {
                    //                         Navigator.pushNamed(
                    //                             context, DishMenuScreen.routename,
                    //                             arguments: {
                    //                               'dish': widget.dish,
                    //                               'iscart': false
                    //                             });
                    //                       } else {
                    //                         ref
                    //                             .read(DummyLogicProvider)
                    //                             .addToCart(
                    //                                 widget.dish!.dish_price,
                    //                                 widget.dish!.dish_name,
                    //                                 widget.dish!.dish_description,
                    //                                 ref,
                    //                                 supabaseClient
                    //                                     .auth.currentUser!.id,
                    //                                 widget.dish!.dishid
                    //                                     .toString(),
                    //                                 widget.dish!.dish_price!
                    //                                     .toDouble(),
                    //                                 widget.dish!.dish_imageurl!);
                    //                       }
                    //                     });

                    //                     // _debouncer.run(() {
                    //                     //   if (variattionTitle!.dishid ==
                    //                     //       widget.dish!.dishid) {
                    //                     //     Navigator.pushNamed(
                    //                     //         context, DishMenuScreen.routename,
                    //                     //         arguments: {
                    //                     //           'dish': widget.dish,
                    //                     //           'iscart': false
                    //                     //         });
                    //                     //   } else {
                    //                     //     ref
                    //                     //         .read(DummyLogicProvider)
                    //                     //         .addToCart(
                    //                     //             widget.dish!.dish_price,
                    //                     //             widget.dish!.dish_name,
                    //                     //             widget.dish!.dish_description,
                    //                     //             ref,
                    //                     //             supabaseClient
                    //                     //                 .auth.currentUser!.id,
                    //                     //             widget.dish!.dishid
                    //                     //                 .toString(),
                    //                     //             widget.dish!.dish_price!
                    //                     //                 .toDouble(),
                    //                     //             widget.dish!.dish_imageurl!);
                    //                     //   }
                    //                     // });
                    //                   },
                    //                   child: Container(
                    //                     height: widget.addbuttonHeight ?? 50,
                    //                     width: widget.addbuttonWidth ?? 50,
                    //                     decoration: const BoxDecoration(
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                               color: Colors.black54,
                    //                               blurRadius: 6,
                    //                               offset: Offset(-1, -1),
                    //                               spreadRadius: 1)
                    //                         ],
                    //                         color: Colors.black,
                    //                         borderRadius: BorderRadius.only(
                    //                             topLeft: Radius.circular(10),
                    //                             bottomRight:
                    //                                 Radius.circular(10))),
                    //                     child: const Align(
                    //                       alignment: Alignment.center,
                    //                       child: Icon(
                    //                         Icons.add,
                    //                         size: 20,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               : Expanded(
                    //                   child: Column(
                    //                     // mainAxisSize: MainAxisSize.min,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Expanded(
                    //                         child: InkWell(
                    //                           onTap: () {
                    //                             _debouncer.run(() {
                    //                               ref
                    //                                   .read(DummyLogicProvider)
                    //                                   .increaseQuantity(
                    //                                     ref,
                    //                                     widget.dish!.dishid!,
                    //                                     widget.dish!.dish_price!,
                    //                                   );
                    //                             });
                    //                           },
                    //                           child: Container(
                    //                             height:
                    //                                 widget.buttonIncDecHeight ??
                    //                                     50,
                    //                             width:
                    //                                 widget.buttonIncDecHeight ??
                    //                                     50,
                    //                             decoration: const BoxDecoration(
                    //                                 color: Colors.black,
                    //                                 borderRadius:
                    //                                     BorderRadius.only(
                    //                                         topRight:
                    //                                             Radius.circular(
                    //                                                 10),
                    //                                         bottomLeft:
                    //                                             Radius.circular(
                    //                                                 10))),
                    //                             child: const Icon(
                    //                               Icons.add,
                    //                               size: 20,
                    //                               color: Colors.white,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       const SizedBox(width: 5),
                    //                       Text(
                    //                         //cartItem.quantity.toString(),
                    //                         ref
                    //                             .read(cartProvider.notifier)
                    //                             .state[widget.quantityIndex!]
                    //                             .quantity
                    //                             .toString(),
                    //                         style: const TextStyle(fontSize: 20),
                    //                       ),
                    //                       const SizedBox(width: 5),
                    //                       Expanded(
                    //                         child: InkWell(
                    //                           onTap: () {
                    //                             _debouncer.run(() {
                    //                               ref
                    //                                   .read(DummyLogicProvider)
                    //                                   .decreaseQuantity(
                    //                                     ref,
                    //                                     widget.dish!.dishid!,
                    //                                     widget.dish!.dish_price!,
                    //                                   );
                    //                             });
                    //                           },
                    //                           child: Container(
                    //                             height:
                    //                                 widget.buttonIncDecHeight ??
                    //                                     50,
                    //                             width: widget.buttonIncDecWidth ??
                    //                                 50,
                    //                             decoration: const BoxDecoration(
                    //                                 color: Colors.black,
                    //                                 borderRadius:
                    //                                     BorderRadius.only(
                    //                                         topLeft:
                    //                                             Radius.circular(
                    //                                                 10),
                    //                                         bottomRight:
                    //                                             Radius.circular(
                    //                                                 10))),
                    //                             child: Center(
                    //                                 child: widget.isCartScreen ==
                    //                                             false &&
                    //                                         widget.cartItem!
                    //                                                 .quantity ==
                    //                                             1
                    //                                     ? const Icon(
                    //                                         Icons.delete_rounded,
                    //                                         size: 20,
                    //                                         color: Colors.white,
                    //                                       )
                    //                                     : const Icon(
                    //                                         Icons
                    //                                             .minimize_outlined,
                    //                                         size: 20,
                    //                                         color: Colors.white,
                    //                                       )),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
              // SizedBox(
              //   height: 100,
              //   width: double.maxFinite,
              //   child: ElevatedButton(
              //     child: const Text('dsdsd'),
              //     onPressed: () {},
              //   ),
              )
        ],
      ),
    );
  }
}
