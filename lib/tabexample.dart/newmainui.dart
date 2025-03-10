import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';

import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

class NewMainUI extends ConsumerStatefulWidget {
  final String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  NewMainUI({
    super.key,
  });

  @override
  ConsumerState<NewMainUI> createState() => _NewMainUIState();
}

class _NewMainUIState extends ConsumerState<NewMainUI>
    with TickerProviderStateMixin {
  final bloc = RappiBloc();
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  List<VariattionTitleModel>? titleVariationList = [];
  bool isTabControllerReady = false; // Track initialization
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
      if (value != null && mounted) {
        setState(() {
          allcategories = value.cast<Categories>();
          print(allcategories[0].category_name);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchcategoriesAnddishes(widget.restuid).then((value) {
          if (allcategories.isNotEmpty) {
            setState(() {
              // bloc.tabController =
              //     TabController(length: allcategories.length, vsync: this);
              // print('Number of tabs: ${bloc.tabs.length}');
              // print('TabController length: ${bloc.tabController?.length}');
              // Initialize TabController once categories are fetched
              bloc.tabController =
                  TabController(length: allcategories.length, vsync: this);

              isTabControllerReady = true; // Mark as ready
            });
          }

          bloc.init(this, dishes: dishes, categories: allcategories);
          bloc.scrollController!.addListener(() {
            // onScroll();
          });
        });
      }
    });

    // ref.read(DummyLogicProvider).fetchCart(ref, userId!).then((value) {
    //   cartFetched = true;
    //   final cart = ref.read(cartProvider.notifier).state;
    //   if (cart.isNotEmpty) {
    //     print('${cart[0].tprice}');
    // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      body: CustomScrollView(
        controller: bloc.scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            collapsedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  color: Colors.pink,
                  height: 60,
                  width: double.maxFinite,
                  child: isTabControllerReady // Only build when ready
                      ? TabBar(
                          padding: EdgeInsets.zero,
                          dividerColor: Colors.transparent,
                          indicatorColor: Colors.transparent,
                          onTap: bloc.onCategoryTab,
                          isScrollable: true,
                          controller: bloc.tabController,
                          tabs: bloc.tabs
                              .map((e) => Rappi_tab_widget(category: e))
                              .toList())
                      : CircularProgressIndicator()),
              background: Image.network(
                'https://mrqaapzhzeqvarrtfkgv.supabase.co/storage/v1/object/public/Restaurant_Registeration//8d019a6b-b66a-466e-99b9-c66f9745ba70/Restaurant_covers',
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: bloc.items.length, (context, index) {
            final cartIndex = cart.firstWhere(
                (dish) => dish.dish_id == bloc.items[index].product?.dishid,
                orElse: () => CartModelNew(dish_id: 0, quantity: 0));
            if (bloc.items[index].isCategory) {
              return RappiCategory(category: bloc.items[index].category);
            } else {
              return RappiProduct(
                dish: bloc.items[index].product!,
                cartItem: cartIndex,
                // qunatityindex: quantityindex,
                userId: supabaseClient.auth.currentUser!.id,
                titleVariationList: titleVariationList,
                // variattionTitle: titleVariation,
              );
            }
          }))
        ],
      ),
    );
  }
}
