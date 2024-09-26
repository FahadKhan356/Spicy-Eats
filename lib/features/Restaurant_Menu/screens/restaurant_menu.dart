import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spicy_eats/commons/dishes_card.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/menu_Item_detail_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

class RestaurantMenu extends StatelessWidget {
  static const String routename = "/restaurant-menu";
  final Restaurant? restaurant;
  final List<DishData>? dishData;
  const RestaurantMenu(
      {super.key, required this.restaurant, required this.dishData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.network(
                  restaurant!.image,
                  width: double.maxFinite,
                  height: 230,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    top: 20,
                    left: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.white,
                        child: Center(
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                    )),
              ]),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  restaurant!.name,
                  style: const TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Row(
                  children: [
                    Text(
                      "\$ ${restaurant?.rating}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.star,
                      size: 22,
                      color: Colors.amber,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: restaurant!.dishes.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 4,
                          thickness: 4,
                          color: Colors.black26,
                        ),

                        // leading: Image.network(
                        //   restaurant.dishes[index].image.toString(),
                        //   width: 100,
                        //   height: 100,
                        // ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, MenuItemDetailScreen.routename,
                              arguments: restaurant!.dishes[index]),
                          child: DishesCard(
                            dishname: restaurant!.dishes[index].name,
                            dishdescription:
                                restaurant!.dishes[index].description,
                            dishprice:
                                restaurant!.dishes[index].price.toString(),
                            image: restaurant!.dishes[index].image,
                            index: index,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  })),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: dishData!.length,
                itemBuilder: (context, index) => DishesCard(
                  dishname: dishData![index].dish_name!,
                  dishdescription: dishData![index].dish_description!,
                  dishprice: dishData![index].dish_price!.toString(),
                  image: dishData![index].dish_imageurl,
                  index: index,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
