import 'package:flutter/material.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

double categoryHeight = 65;
double productHeight = 130;
double productsCardMargin = 10;

class RappiBloc with ChangeNotifier {
  List<RapitabCategory> tabs = [];
  List<RappiItem> items = [];
  bool _listen = true;

  ScrollController? scrollController;
  TabController? tabController;
  void init(TickerProvider ticker,
      {List<DishData>? dishes, List<Categories>? categories}) {
    // tabController = TabController(length: categories!.length, vsync: ticker);
    final Map<String, List<DishData>> categoryDishesMap = {};
    double offsetFrom = 0.0;
    double offsetTo = 0.0;
    scrollController = ScrollController();

    // Group dishes by category_id
    for (var category in categories!) {
      categoryDishesMap[category.category_id] = dishes!
          .where((dish) => dish.category_id == category.category_id)
          .toList();
    }

    // Calculate offsetFrom for each category
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final categoryDishes = categoryDishesMap[category.category_id] ?? [];

      if (i > 0) {
        // Calculate offsetFrom based on the previous category's dishes
        // final previousCategoryDishes =
        //     categoryDishesMap[categories[i - 1].category_id] ?? [];
        // offsetFrom +=
        //     categoryHeight + (previousCategoryDishes.length * productHeight);
        offsetFrom = tabs[i - 1].offsetTo;
      }
      if (i < categories.length - 1) {
        final value = categoryDishesMap[categories[i + 1].category_id] ?? [];

        offsetTo = offsetFrom +
            categoryHeight +
            productsCardMargin +
            (value.length * productHeight);
      } else {
        // offsetTo = double.infinity;
        offsetTo = offsetFrom +
            productsCardMargin +
            (categoryDishes.length * productHeight) +
            categoryHeight;
      }

      // Add the category to tabs and items
      tabs.add(RapitabCategory(
        category: category,
        selected: (i == 0),
        offsetFrom: offsetFrom, // Ensure this is set
        offsetTo: offsetTo,
      ));

      items.add(RappiItem(category: category));

      // Add dishes to items
      for (var dish in categoryDishes) {
        items.add(RappiItem(product: dish));
      }

      // Debug print
      print('Category: ${category.category_name}, offsetFrom: $offsetFrom');
      print(
          'Category: ${category.category_name}, offsetFrom: $offsetFrom, offsetTo: $offsetTo');
    }

    //notifyListeners();
    scrollController!.addListener((() {
      _onScrollingListener();
    }));
  }

  // void _onScrollingListener() {
  //   if (_listen) {
  //     for (int i = 0; i < tabs.length; i++) {
  //       final tab = tabs[i];
  //       if (scrollController!.offset >= tab.offsetFrom &&
  //           scrollController!.offset <= tab.offsetTo &&
  //           !tab.selected!) {
  //         onCategoryTab(i, animationRequired: false);
  //         tabController!.animateTo(i);
  //         break;
  //       }
  //     }
  //   }
  // }
  void _onScrollingListener() {
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];
        if (scrollController!.offset >= tab.offsetFrom &&
            scrollController!.offset < tab.offsetTo &&
            !tab.selected!) {
          print('Scrolled to category: ${tab.category.category_name}');
          print('Scroll position: ${scrollController!.offset}');
          print(
              'Category offsetFrom: ${tab.offsetFrom}, offsetTo: ${tab.offsetTo}');
          // print('Scroll offset: ${scrollController!.offset}');
          onCategoryTab(i, animationRequired: false);
          tabController!.animateTo(i);
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController?.dispose();
    tabController?.dispose(); // Use null-aware operator
    super.dispose();
  }

  void onCategoryTab(int index, {bool animationRequired = true}) async {
    print('${index}');
    if (scrollController == null) {
      print('ScrollController is not initialized');
      return;
    }

    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      tabs[i] = tabs[i].copywith(
          selected: selected.category.category_name ==
              tabs[i].category.category_name);
    }
    // if (selected.offsetFrom == null) {
    //   print(
    //       'offsetFrom is null for category: ${selected.category.category_name}');
    //   return;
    // }
    if (animationRequired) {
      _listen = false;
      await scrollController!.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceOut,
      );
      _listen = true;
    }

    notifyListeners();
  }
}

class RapitabCategory {
  RapitabCategory(
      {required this.category,
      this.selected,
      required this.offsetFrom,
      required this.offsetTo});
  final Categories category; // Make `category` non-nullable
  bool? selected;
  final double offsetFrom; // Make `offsetFrom` non-nullable
  final double offsetTo;
  RapitabCategory copywith({bool? selected}) => RapitabCategory(
        category: category,
        selected: selected ?? this.selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );
}

class RappiItem {
  RappiItem({this.category, this.product});
  final Categories? category;
  final DishData? product;

  bool get isCategory => category != null;
}
