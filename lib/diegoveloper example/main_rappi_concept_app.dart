import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/SyncTabBar/CategoryModel.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

class Mian_rappi_concept_app extends ConsumerStatefulWidget {
  const Mian_rappi_concept_app({super.key});

  @override
  ConsumerState<Mian_rappi_concept_app> createState() =>
      _Mian_rappi_concept_appState();
}

TabController? _tabController;

class _Mian_rappi_concept_appState extends ConsumerState<Mian_rappi_concept_app>
    with SingleTickerProviderStateMixin {
  final bloc = RappiBloc();
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';

  Future fetchcategoriesAnddishes(String restuid) async {
    await ref
        .read(homeControllerProvider)
        .fetchDishes(restuid: restuid)
        .then((value) {
      if (value != null) {
        setState(() {
          dishes = value;
        });
      }
    });
    await ref
        .read(homeControllerProvider)
        .fetchCategories(restuid: restuid)
        .then((value) {
      if (value != null) {
        setState(() {
          allcategories = value;
          print(allcategories[0].category_name);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchcategoriesAnddishes(restuid).then((value) {
      if (allcategories.isNotEmpty) {
        setState(() {
          _tabController =
              TabController(length: allcategories.length, vsync: this);
        });
      }
      bloc.init(this, dishes: dishes, categories: allcategories);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return allcategories.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
              child: AnimatedBuilder(
                  animation: bloc,
                  builder: (_, __) {
                    return Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: 100,
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Home Screen",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        color: Colors.black12, width: 2)),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black87,
                                  child: ClipOval(
                                    child: Image.network(
                                      "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: double.maxFinite,
                          color: Colors.white,
                          child: TabBar(
                            indicatorColor: Colors.white,
                            isScrollable: true,
                            controller: _tabController,
                            tabs: bloc.tabs.map((e) {
                              return Rappi_tab_widget(category: e);
                            }).toList(),
                            //bloc.tabs.map((e) => Rappi_tab_widget(category: e)).toList()
                            onTap: bloc.onCategoryTab,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: bloc.scrollController,
                            child: Container(
                                // width: double.maxFinite,
                                color: Colors.white,
                                child: Column(
                                  children:
                                      List.generate(bloc.items.length, (index) {
                                    if (bloc.items[index].isCategory) {
                                      return RappiCategory(
                                          category: bloc.items[index].category);
                                    } else {
                                      return RappiProduct(
                                          dish: bloc.items[index].product!);
                                    }
                                  }).toList(),
                                )),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
  }
}

Widget Rappi_tab_widget({RapitabCategory? category}) {
  return Card(
    margin: const EdgeInsets.all(5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
    borderOnForeground: false,
    color: Colors.white,
    elevation: category!.selected! ? 6 : 0,
    shadowColor: Colors.black12,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        //'sdadasd',
        category!.category!.category_name.toString(),
        style: TextStyle(
            fontSize: 15,
            color: category.selected! ? Colors.black : Colors.black38),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
class RappiCategory extends StatelessWidget {
  RappiCategory({required this.category});
  Categories? category;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: double.maxFinite,
        child: Card(color: Colors.blue, child: Text(category!.category_name)));
  }
}

// ignore: non_constant_identifier_names
class RappiProduct extends StatelessWidget {
  RappiProduct({required this.dish});
  DishData dish;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110,
        width: double.maxFinite,
        child: Card(
            color: Colors.cyanAccent,
            child: Row(
              children: [
                Image.network(
                  dish.dish_imageurl.toString(),
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    Text(
                      dish.dish_name.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                )
              ],
            )));
  }
}
