// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Cartmodel.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/commons/CartCard.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/buildDishitem.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';

class RestaurantProduct extends ConsumerStatefulWidget {
  const RestaurantProduct({
    super.key,
    required this.dishes,
    required this.dish,
    this.cartItem,
    this.qunatityindex,
    this.userId,
    this.titleVariationList,
    required this.restaurantData,
  });
  final List<DishData> dishes;
  final DishData dish;
  final Cartmodel? cartItem;
  final int? qunatityindex;
  final String? userId;
  final List<VariattionTitleModel>? titleVariationList;
  final RestaurantModel? restaurantData;
  // VariattionTitleModel? variattionTitle;

  @override
  ConsumerState<RestaurantProduct> createState() => _RappiProductState();
}

class _RappiProductState extends ConsumerState<RestaurantProduct> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        ref.read(isloaderProvider.notifier).state = true;
        widget.dish.isVariation
            ? Navigator.pushNamed(context, DishMenuVariation.routename,
                arguments: {
                    'dishes': widget.dishes,
                    'dish': widget.dish,
                    'iscart': false,
                    'cartdish': widget.cartItem,
                    'isbasket': false,
                    'restaurantdata': widget.restaurantData,
                    'isdishscreen': true,
                  })
            : Navigator.pushNamed(context, DishMenuScreen.routename,
                arguments: {
                    'restaurantdata': widget.restaurantData,
                    'dish': widget.dish,
                    'iscart': false,
                    'cartdish': widget.cartItem,
                    'isbasket': false,
                    'isdishscreen': true,
                  });
      },
      child: BuildDishItem(
        elevation: 0,
        cardColor: null,
        dish: widget.dish,
        imageHeight: 140,
        imageWidth: 120,
        cartItem: widget.cartItem!,
        userId: widget.userId,
        addbuttonHeight: 40,
        buttonIncDecHeight: 40,
        buttonIncDecWidth: 40,
        quantityIndex: widget.qunatityindex,
        titleVariationList: widget.titleVariationList,
        restaurantdata: widget.restaurantData!,
      ),
    );
    //    CartCard(
    //     elevation: 0,
    //     cardColor: null,
    //     dish: widget.dish,
    //     imageHeight: 140,
    //     imageWidth: 120,
    //     cartItem: widget.cartItem!,
    //     userId: widget.userId,
    //     addbuttonHeight: 40,
    //     buttonIncDecHeight: 40,
    //     buttonIncDecWidth: 40,
    //     quantityIndex: widget.qunatityindex,
    //     titleVariationList: widget.titleVariationList,
    //     restaurantdata: widget.restaurantData!,
    //   ),
    // );
  }
}
