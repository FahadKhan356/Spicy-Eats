import 'package:flutter/material.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

double categoryHeight = 55;
double productHeight = 110;

class RappiBloc with ChangeNotifier {
  List<List<int>> productlength = [];
  List<RapitabCategory> tabs = [];
  List<RappiItem> items = [];

  ScrollController? scrollController;

  void init(TickerProvider ticker,
      {List<DishData>? dishes, List<Categories>? categories}) {
    final Map<String, List<DishData>> categoryDishesMap = {};
    double offsetFrom = 0.0;
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
        final previousCategoryDishes =
            categoryDishesMap[categories[i - 1].category_id] ?? [];
        offsetFrom +=
            (previousCategoryDishes.length * productHeight) + categoryHeight;
      }

      // Add the category to tabs and items
      tabs.add(RapitabCategory(
        category: category,
        selected: (i == 0),
        offsetFrom: offsetFrom, // Ensure this is set
      ));

      items.add(RappiItem(category: category));

      // Add dishes to items
      for (var dish in categoryDishes) {
        items.add(RappiItem(product: dish));
      }

      // Debug print
      print('Category: ${category.category_name}, offsetFrom: $offsetFrom');
    }

    notifyListeners();
  }

  @override
  void dispose() {
    scrollController?.dispose(); // Use null-aware operator
    super.dispose();
  }

  void onCategoryTab(int index) {
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
    if (selected.offsetFrom == null) {
      print(
          'offsetFrom is null for category: ${selected.category.category_name}');
      return;
    }

    scrollController!.animateTo(
      selected.offsetFrom,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }
}

class RapitabCategory {
  RapitabCategory(
      {required this.category, this.selected, required this.offsetFrom});
  final Categories category; // Make `category` non-nullable
  bool? selected;
  final double offsetFrom; // Make `offsetFrom` non-nullable

  RapitabCategory copywith({bool? selected}) => RapitabCategory(
        category: category,
        selected: selected ?? this.selected,
        offsetFrom: offsetFrom,
      );
}

class RappiItem {
  RappiItem({this.category, this.product});
  final Categories? category;
  final DishData? product;

  bool get isCategory => category != null;
}
