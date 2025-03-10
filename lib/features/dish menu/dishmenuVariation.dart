import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

final variationListProvider = StateProvider<List<Variation>?>((ref) => null);

// ignore: must_be_immutable
class DishMenuVariation extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuVariation';
  final DishData? dish;
  List<VariattionTitleModel>? variationList = [];
  bool isCart = false;
  CartModelNew? cartDish;
  bool isbasket = false;

  DishMenuVariation(
      {super.key, required this.dish, this.cartDish, required this.isCart});

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
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  Future<void> fetchVariations(int dishId) async {
    ref
        .read(dishMenuRepoProvider)
        .fetchVariations(dishid: dishId, context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          widget.variationList = value;
          withvariation = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController!.dispose();
    animationController!.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: animationController!, curve: Curves.easeOut));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut));

    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    scrollController!.addListener(() {
      if (scrollController!.hasClients && scrollController!.offset > 150) {
        animationController!.forward();
      } else {
        animationController!.reverse();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchVariations(widget.dish!.dishid!);
      ref.read(variationListProvider.notifier).state = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quantity = ref.watch(quantityPrvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                title: AnimatedBuilder(
                    animation: animationController!,
                    builder: (context, child) {
                      return Transform.translate(
                          offset: _offsetanimation!.value,
                          child: Opacity(
                              opacity: _opacityanimation!.value,
                              child: Text(
                                'Dish menu variation',
                                style: TextStyle(color: Colors.black),
                              )));
                    }),
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
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            ' from Rs ${widget.dish!.dish_price}',
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.dish!.dish_description!,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w300),
                          ),
                        ]),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.variationList!.length,
                      (context, titleVariationindex) {
                final titleVariation =
                    widget.variationList![titleVariationindex];

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
                                    if (titleVariation.isRequired!) {
                                      withvariation = true;
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'you can only select upto ${titleVariation.maxSeleted} options')));
                                  }
                                } else {
                                  updatedList
                                      .removeWhere((v) => v.id == variation.id);
                                  withvariation = false;
                                }

                                ref.read(variationListProvider.notifier).state =
                                    updatedList;
                              },
                            );
                          }),
                        ],
                      )),
                );
              })),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                ),
              )
            ],
          ),
          (widget.variationList != null &&
                  widget.variationList!.isNotEmpty &&
                  widget.variationList!.indexWhere((element) =>
                          element.dishid == widget.dish!.dishid!) !=
                      -1)
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 3)
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    _debouncer.run(() {
                                      ref
                                          .read(quantityPrvider.notifier)
                                          .state++;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: withvariation!
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: withvariation!
                                          ? Colors.white
                                          : Colors.black12,
                                    ),
                                  )),
                              const SizedBox(width: 5),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: withvariation!
                                      ? Colors.black
                                      : Colors.black12,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  _debouncer.run(() {
                                    if (quantity > 0) {
                                      ref
                                          .read(quantityPrvider.notifier)
                                          .state--;
                                    }
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: withvariation!
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.minimize_outlined,
                                    size: 20,
                                    color: withvariation!
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
                                  backgroundColor: withvariation!
                                      ? Colors.black
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                    color: withvariation!
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
                  ))
              : SizedBox(),
        ],
      ),
    );
  }
}
