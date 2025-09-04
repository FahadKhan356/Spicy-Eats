import 'package:flutter/material.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

double categoryHeight = 65;
double productHeight = 130;
double productMargin = 35;
double headerHeight = 60;
double additionalWidgetsHeight = 150.0;

class RappiBloc with ChangeNotifier {
  List<RapitabCategory> tabs = [];
  List<RappiItem> items = [];
  bool _listen = true;

  ScrollController? scrollController;
  TabController? tabController;

  void init(
    TickerProvider ticker, {
    required List<DishData> dishes,
    required List<Categories> categories,
  }) {
    final Map<String, List<DishData>> categoryDishesMap = {};
    double offsetFrom = 0.0;
    double offsetTo = 0.0;
    scrollController = ScrollController();

    // group dishes by category
    for (var category in categories) {
      categoryDishesMap[category.category_id] = dishes
          .where((dish) => dish.category_id == category.category_id)
          .toList();
    }

    // calculate ranges
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final categoryDishes = categoryDishesMap[category.category_id] ?? [];

      if (i > 0) {
        offsetFrom = tabs[i - 1].offsetTo;
      }

      offsetTo = offsetFrom +
          categoryHeight +
          productMargin +
          headerHeight +
          (categoryDishes.length * productHeight) +
          additionalWidgetsHeight;

      // reset extra height after first category
      additionalWidgetsHeight = 0;

      tabs.add(RapitabCategory(
        category: category,
        selected: (i == 0),
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      ));

      items.add(RappiItem(category: category));
      for (var dish in categoryDishes) {
        items.add(RappiItem(product: dish));
      }
    }

    scrollController!.addListener(_onScrollingListener);
  }

  void _onScrollingListener() {
    if (!_listen) return;

    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      if (scrollController!.offset >= tab.offsetFrom &&
          scrollController!.offset < tab.offsetTo &&
          !tab.selected!) {
        _listen = false;
        onCategoryTab(i, animationRequired: false);
        tabController?.animateTo(i);
        _listen = true;
        notifyListeners();
        break;
      }
    }
  }

  void onCategoryTab(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      tabs[i] = tabs[i].copywith(
        selected:
            tabs[i].category.category_name == selected.category.category_name,
      );
    }

    if (animationRequired) {
      _listen = false;
      await scrollController!.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      _listen = true;
    }

    tabController?.index = index;
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    tabController?.dispose();
    super.dispose();
  }
}

class RapitabCategory {
  RapitabCategory({
    required this.category,
    this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  final Categories category;
  bool? selected;
  final double offsetFrom;
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
