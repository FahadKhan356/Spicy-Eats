import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/dishmenu_model.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData dish;
  List<DishMenuModel> dishMenuList = [];
  DishMenuScreen({super.key, required this.dish});

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
          setState(() {
            widget.dishMenuList = value;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.dishMenuList[0].variationTitle)));
          print('${widget.dishMenuList[0].variationTitle}');
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
                      // ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemCount: 5,
                      //     itemBuilder: (context, index) {
                      //       return const ListTile(
                      //         title: Text(
                      //           'Deep Pan',
                      //           style: TextStyle(fontSize: 17),
                      //         ),
                      //         trailing: Text(
                      //           'Free',
                      //           style: TextStyle(fontSize: 17),
                      //         ),
                      //       );
                      //     }),

                      // ...widget.dishMenuList.map((e) =>

                      //     CheckboxListTile(
                      //       title: Text(e.variationName),
                      //       subtitle:  e.variationPrice>0? Text('\$${e.variationPrice}') :  null,

                      //       value:
                      //      onChanged: (value) {}))
                    ],
                  )),
            ),
          )),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: widget.dishMenuList.length,
                  (context, index) => Text('sdd'))),
        ],
      ),
    );
  }
}
