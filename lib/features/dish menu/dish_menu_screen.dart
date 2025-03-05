import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

var addbuttonprovider = StateProvider<bool?>((ref) => null);
var quantityPrvider = StateProvider<int>((ref) => 1);
final variationListProvider = StateProvider<List<Variation>?>((ref) => null);

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  List<VariattionTitleModel> variationList = [];
  bool isCart = false;
  CartModelNew? cartDish;
  bool isbasket = false;
  DishMenuScreen(
      {super.key, required this.dish, this.cartDish, required this.isCart});

  @override
  ConsumerState<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
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
    final quantity = ref.watch(quantityPrvider);
    final selectedVariations = ref.watch(variationProvider);
    final variationlist1 = ref.read(variationListProvider);
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black12,
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
                            final variationlist =
                                ref.watch(variationListProvider) ?? [];
                            final isselected =
                                variationlist.any((v) => v.id == variation.id);

                            // final selectedlist =
                            //     selectedVariations[titleVariation.id] ?? [];
                            // final isSelected =
                            // selectedlist.any((v) => v.id == variation.id);
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
                              value: isselected, //isSelected,
                              onChanged: (value) {
                                final updatedList =
                                    List<Variation>.from(variationlist);
                                if (value == true) {
                                  if (titleVariation.maxSeleted == null ||
                                      // updatedList.length <
                                      //     titleVariation.maxSeleted!
                                      updatedList
                                              .where((v) =>
                                                  v.variation_id ==
                                                  titleVariation.id)
                                              .length <
                                          titleVariation.maxSeleted!) {
                                    updatedList.add(
                                      Variation(
                                        id: variation.id,
                                        variationName: variation.variationName,
                                        variationPrice:
                                            variation.variationPrice,
                                        variation_id: variation.variation_id,
                                        selected: true,
                                      ),
                                    );
                                  } else {
                                    // ref.read(addbuttonprovider.notifier).state =
                                    //     false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'you can only select upto ${titleVariation.maxSeleted} options')));
                                  }
                                } else {
                                  updatedList
                                      .removeWhere((v) => v.id == variation.id);
                                }

                                // ref.read(variationProvider.notifier).state = {
                                //   ...selectedVariations,
                                //   titleVariation.id!: updatedList,
                                // };

                                ref.read(variationListProvider.notifier).state =
                                    updatedList;

                                if (titleVariation.isRequired == true &&
                                    updatedList
                                            .where((element) =>
                                                element.id == variation.id)
                                            .length ==
                                        titleVariation.maxSeleted!) {
                                  ref.read(addbuttonprovider.notifier).state =
                                      true;
                                } else if (titleVariation.isRequired == true &&
                                    updatedList
                                            .where((element) =>
                                                element.id == variation.id)
                                            .length <
                                        titleVariation.maxSeleted!) {
                                  ref.read(addbuttonprovider.notifier).state =
                                      false;
                                }
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
                  // border: Border(
                  //     top: BorderSide(
                  //   color: Colors.black26,
                  // ),
                  // ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, spreadRadius: 2, blurRadius: 3)
                  ],
                ),
                height: 80,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _debouncer.run(() {
                                // ref.read(DummyLogicProvider).increaseQuantity(
                                //       ref,
                                //       widget.dish!.dishid!,
                                //       widget.dish!.dish_price!,
                                //     );

                                ref.read(quantityPrvider.notifier).state++;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: ref.watch(addbuttonprovider) == true
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                                  // BorderRadius.only(
                                  //     topRight: Radius.circular(10),
                                  //     bottomLeft: Radius.circular(10)
                                  //     )

                                  ),
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: ref.watch(addbuttonprovider) == true
                                    ? Colors.white
                                    : Colors.black12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: ref.watch(addbuttonprovider) == true
                                  ? Colors.black
                                  : Colors.black12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              _debouncer.run(() {
                                // ref.read(DummyLogicProvider).decreaseQuantity(
                                //       ref,
                                //       widget.dish!.dishid!,
                                //       widget.dish!.dish_price!,
                                //     );
                                if (quantity > 0) {
                                  ref.read(quantityPrvider.notifier).state--;
                                }
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: ref.watch(addbuttonprovider) == true
                                    ? Colors.black
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                // BorderRadius.only(
                                //     topLeft: Radius.circular(10),
                                //     bottomRight: Radius.circular(10),
                                //     )
                              ),
                              child: Center(
                                  child:
                                      // widget.isCartScreen ==
                                      // false &&
                                      //     widget.cartItem!
                                      //             .quantity ==
                                      //         1
                                      // ? const Icon(
                                      //     Icons.delete_rounded,
                                      //     size: 20,
                                      //     color: Colors.white,
                                      //   )
                                      // :
                                      Icon(
                                Icons.minimize_outlined,
                                size: 20,
                                color: ref.watch(addbuttonprovider) == true
                                    ? Colors.white
                                    : Colors.black12,
                              )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ref.watch(addbuttonprovider) == true
                                      ? Colors.black
                                      : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                                color: ref.watch(addbuttonprovider) == true
                                    ? Colors.white
                                    : Colors.black12),
                          ),
                          onPressed: () {
                            _debouncer.run(() {
                              ref.read(DummyLogicProvider).addToCart(
                                  widget.dish!.dish_price,
                                  widget.dish!.dish_name,
                                  widget.dish!.dish_description,
                                  ref,
                                  supabaseClient.auth.currentUser!.id,
                                  widget.dish!.dishid!,
                                  widget.dish!.dish_price!.toDouble(),
                                  widget.dish!.dish_imageurl!,
                                  ref
                                      .read(variationListProvider.notifier)
                                      .state,
                                  true,
                                  quantity);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
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
