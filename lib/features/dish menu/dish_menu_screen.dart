import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

var quantityPrvider = StateProvider<int>((ref) => 1);
final variationListProvider = StateProvider<List<Variation>?>((ref) => null);

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  List<VariattionTitleModel>? variationList = [];
  bool isCart = false;
  CartModelNew? cartDish;
  bool isbasket = false;

  DishMenuScreen(
      {super.key, required this.dish, this.cartDish, required this.isCart});

  @override
  ConsumerState<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuScreen>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  AnimationController? _animationController;
  Animation<double>? _opacityanimation;
  Animation<Offset>? _offsetanimation;

  bool isExpanded = false;

  bool? withvariation;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  Future<void> fetchVariations(int dishId) async {
    ref
        .read(dishMenuRepoProvider)
        .fetchVariations(dishid: dishId, context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          // withvariation = false;
          widget.variationList = value;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(widget.variationList![0].variationTitle!)));
          print('${widget.variationList![0].variationTitle}');
        });
        print('not fetch dishmenuList${value}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.bounceOut));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController!, curve: Curves.bounceOut));
    _scrollController!.addListener(() {
      if (_scrollController!.offset > 150) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        withvariation = false;
      });
      fetchVariations(widget.dish!.dishid!);
      ref.read(quantityPrvider.notifier).state = 1;
    });
  }

  Timer? _colapsetimer;
  void startTimer() {
    _colapsetimer!.cancel();
    _colapsetimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isExpanded = false;
      });
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
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                title: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) =>
                      Transform.translate(offset: _offsetanimation!.value),
                  child: Opacity(
                    opacity: _opacityanimation!.value,
                    child: Text(
                      "Dish screen",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                _debouncer.run(() {
                                  ref.read(quantityPrvider.notifier).state++;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.add,
                                    size: 20, color: Colors.white),
                              )),
                          const SizedBox(width: 5),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              _debouncer.run(() {
                                if (quantity > 0) {
                                  ref.read(quantityPrvider.notifier).state--;
                                }
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.minimize_outlined,
                                size: 20,
                                color: Colors.white,
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
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _debouncer.run(() {
                              // final cartlistner =
                              //     ref.read(cartProvider.notifier).state;

                              ref.read(DummyLogicProvider).addToCart(
                                  widget.dish!.dish_price!,
                                  widget.dish!.dish_name,
                                  widget.dish!.dish_description,
                                  ref,
                                  supabaseClient.auth.currentUser!.id,
                                  widget.dish!.dishid!,
                                  widget.dish!.dish_price!.toDouble(),
                                  widget.dish!.dish_imageurl!,
                                  null,
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
        ],
      ),
    );
  }
}
