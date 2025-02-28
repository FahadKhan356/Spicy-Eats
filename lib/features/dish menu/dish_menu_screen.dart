import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData dish;
  List<VariattionTitleModel> VariationList = [];
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
          widget.VariationList = value;

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.VariationList[0].variationTitle)));
          print('${widget.VariationList[0].variationTitle}');
        });
        print('not fetch dishmenuList${value}');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVariations(widget.dish.dishid!);
  }

  @override
  Widget build(BuildContext context) {
    final selectedVariations = ref.watch(variationProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.dish.dish_imageurl!,
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
                        widget.dish.dish_name!,
                        style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ' from Rs ${widget.dish.dish_price}',
                        style: const TextStyle(
                            // color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.dish.dish_description!,
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
                  childCount: widget.VariationList.length,
                  (context, titleVariationindex) {
            final titleVariation = widget.VariationList[titleVariationindex];
            if (widget.isCart && widget.cartDish?.variation != null) {
              ref.read(variationProvider.notifier).state = {
                ...ref.read(variationProvider),
                widget.cartDish!.variationId!: widget.cartDish!.variation!,
              };
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
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
                                color: titleVariation.isRequired
                                    ? Colors.red
                                    : Colors.green,
                                child: titleVariation.isRequired
                                    ? const Text(
                                        'Required',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
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
                      ...titleVariation.variations.map((variation) {
                        final isSelected =
                            selectedVariations[titleVariation.id]?.id ==
                                variation.id;

                        return CheckboxListTile(
                          title: Text(
                              "${variation.variationName} (\$${variation.variationPrice})"),
                          value: isSelected,
                          onChanged: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(variation.variationPrice.toString())));
                            ref.read(variationProvider.notifier).state = {
                              ...selectedVariations,
                              titleVariation.id:
                                  value == true ? variation : null,
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
        ],
      ),
    );
  }
}
