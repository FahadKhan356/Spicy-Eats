import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

class DishMenuScreen extends StatefulWidget {
  static const String routename = '/DishMenuScreen';
  DishData dish;
  DishMenuScreen({super.key, required this.dish});

  @override
  State<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends State<DishMenuScreen> {
  @override
  Widget build(BuildContext context) {
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
            childCount: 4,
            (context, index) => Padding(
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
                            const Text(
                              '..Choose Your Crust',
                              style: TextStyle(fontSize: 22),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Colors.red,
                                child: const Text(
                                  'Required',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ]),
                      const Text(
                        'Select one',
                        style: TextStyle(fontSize: 14),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const ListTile(
                              title: Text(
                                'Deep Pan',
                                style: TextStyle(fontSize: 17),
                              ),
                              trailing: Text(
                                'Free',
                                style: TextStyle(fontSize: 17),
                              ),
                            );
                          }),
                    ],
                  )),
            ),
          )),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: 2, (context, index) => Text('sdd'))),
        ],
      ),
    );
  }
}
