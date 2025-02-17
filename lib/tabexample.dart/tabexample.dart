import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/DummyBasket.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/main.dart';

class CustomScrollTransition extends StatefulWidget {
  @override
  _CustomScrollTransitionState createState() => _CustomScrollTransitionState();
}

class _CustomScrollTransitionState extends State<CustomScrollTransition> {
  ScrollController _scrollController = ScrollController();
  double _imageHeight = 300; // Initial height
  double _opacity = 1.0; // Opacity for fade effect
  double _titleOpacity = 0.0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    double newHeight = (300 - offset).clamp(100, 300); // Shrink image smoothly
    double newOpacity = (1 - (offset / 150)).clamp(0.3, 1); // Fade effect
    double newTitleOpacity = (offset > 100) ? 1.0 : 0.0; // Title fades in

    setState(() {
      _imageHeight = newHeight;
      _opacity = newOpacity;
      _titleOpacity = newTitleOpacity;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ✅ Image that shrinks and fades smoothly
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              color: Colors.black,
              duration: Duration(milliseconds: 200),
              height: _imageHeight,
              curve: Curves.easeInOut,
              child: Opacity(
                opacity: _opacity,
                child: Image.network(
                  'https://mrqaapzhzeqvarrtfkgv.supabase.co/storage/v1/object/public/Restaurant_Registeration//8d019a6b-b66a-466e-99b9-c66f9745ba70/Restaurant_covers',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _titleOpacity,
              child: Text(
                "AlBaik",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),

          /// ✅ Main content scrolls under the image
          Positioned.fill(
            top: _imageHeight,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: List.generate(
                  20,
                  (index) => ListTile(
                    title: Text('Item $index'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyFinalScrollScreen extends ConsumerStatefulWidget {
  static const String routename = '/MyFinalScreen';
  final String? restuid;
  const MyFinalScrollScreen({super.key, this.restuid});

  @override
  ConsumerState<MyFinalScrollScreen> createState() =>
      _MyFinalScrollScreenState();
}

class _MyFinalScrollScreenState extends ConsumerState<MyFinalScrollScreen>
    with TickerProviderStateMixin {
  final bloc = RappiBloc();
  double myOffset = 0.0;
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  // String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  bool isTabPinned = false;
  late AnimationController _opacityController;
  late Animation _opacityAnimation;
  double _imageHeight = 200;
  double _imageOpacity = 1;
  double _titletabOpacity = 0;
  double _tabOpacity = 0;
  double _imageContainerRadius = 30;
  double _imageContainerSlide = 0.0;

  // void onScroll() {
  //   print('inside the onscroll');
  //   //bloc.scrollController = ScrollController();
  //   //double offset1 = bloc.scrollController!.offset;
  //   double newImatgeHeight = (300 - myOffset).clamp(150, 300);
  //   double newImageOpacity = 1 - (myOffset / 100).clamp(0.3, 1);
  //   double newTitleTabOpacity = (myOffset > 200) ? 1.00 : 0.0;
  //   double newtabOpacity = (myOffset > 200) ? 1.0 : 0.0;
  //   print('offset1 onscroll ${myOffset}');

  //   if (bloc.scrollController!.hasClients) {
  //     if (mounted) {
  //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //         setState(() {
  //           print('offset1 onscroll ${myOffset}');
  //           _imageHeight = newImatgeHeight;
  //           _imageOpacity = newImageOpacity;
  //           _titletabOpacity = newTitleTabOpacity;
  //           _tabOpacity = newtabOpacity;
  //         });
  //       });
  //     }
  //   }
  // }

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
    // bloc.scrollController = ScrollController();
    // bloc.scrollController!.addListener(() {
    //   updateOffset();
    //   // onScroll();
    // });
    // _opacityController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 500));
    // _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //     CurvedAnimation(parent: _opacityController, curve: Curves.easeIn));
    // TODO: implement initState
    super.initState();

    fetchcategoriesAnddishes(widget.restuid!).then((value) {
      if (allcategories.isNotEmpty) {
        setState(() {
          bloc.tabController =
              TabController(length: allcategories.length, vsync: this);
          print('Number of tabs: ${bloc.tabs.length}');
          print('TabController length: ${bloc.tabController?.length}');
          // bloc.tabController =
          //     TabController(length: bloc.tabs.length, vsync: this);
        });
      }

      bloc.init(this, dishes: dishes, categories: allcategories);
      bloc.scrollController!.addListener(() {
        updateOffset();
        // onScroll();
      });
    });

    // bloc.scrollController = ScrollController();
    // bloc.scrollController!.addListener(() {
    //   updateOffset();
    //   onScroll();
    // }); // Update the offset when scrolling
  }

  void updateOffset() {
    double newImatgeHeight = (200 - myOffset).clamp(100, 200);
    double newImageOpacity = 1 - (myOffset / 100).clamp(0.1, 1);
    double newTitleTabOpacity = (myOffset > 200) ? 1.00 : 0.0;
    double newtabOpacity = (myOffset > 100) ? 1.0 : 0.0;
    double newContainerRadius = (300 - myOffset).clamp(10, 30);
    // double newContainerSlide = (300 - myOffset).clamp(10, 270);
    // double newContainerSlide = (myOffset / 300).clamp(0.0, 3);
    // Safely check if the scrollController is attached to the scroll view
    if (bloc.scrollController!.hasClients && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          myOffset = bloc.scrollController!.offset;

          print('offset1 onscroll ${myOffset}');
          _imageHeight = newImatgeHeight;
          _imageOpacity = newImageOpacity;
          _titletabOpacity = newTitleTabOpacity;
          _tabOpacity = newtabOpacity;
          _imageContainerRadius = newContainerRadius;
          // _imageContainerSlide = newContainerSlide;

          print("Scroll Offset: $myOffset");
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.tabController!.dispose();
    bloc.dispose();
    // bloc.scrollController!.dispose();
    // _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final size = MediaQuery.of(context).size;
    // final centeredOffset = (size.width / 150) - 2;
    return SafeArea(
      child: Scaffold(
          floatingActionButton: cart.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        Text(
                          cart.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ), // Dynamic cart count
                      ],
                    ),
                    onPressed: () => Navigator.popAndPushNamed(
                        context, DummyBasket.routename),
                  ),
                )
              : const SizedBox(),
          backgroundColor: Colors.white,
          body: allcategories.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: _imageHeight,
                          color: Colors.black,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _imageOpacity,
                            curve: Curves.easeIn,
                            child: Image.network(
                              'https://mrqaapzhzeqvarrtfkgv.supabase.co/storage/v1/object/public/Restaurant_Registeration//8d019a6b-b66a-466e-99b9-c66f9745ba70/Restaurant_covers',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    Positioned(
                      top: 0,
                      left: 10,
                      child: myOffset < 70
                          ? IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            )
                          : SizedBox(),
                    ),

                    AnimatedBuilder(
                        animation: bloc,
                        builder: (_, __) {
                          // print(size.width);
                          updateOffset();
                          return Positioned(
                            top: 40,
                            right: 0,
                            left: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _tabOpacity,
                              child: Container(
                                height: 60,
                                width: double.maxFinite,
                                child: TabBar(
                                    dividerColor: Colors.transparent,
                                    indicatorColor: Colors.transparent,
                                    onTap: bloc.onCategoryTab,
                                    isScrollable: true,
                                    controller: bloc.tabController,
                                    tabs: bloc.tabs
                                        .map((e) =>
                                            Rappi_tab_widget(category: e))
                                        .toList()),
                              ),
                            ),
                          );
                        }),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Positioned.fill(
                      top: _imageHeight,
                      child: SingleChildScrollView(
                          controller: bloc.scrollController,
                          child: Column(children: [
                            const SizedBox(
                              height: 30,
                            ),
                            // Container(
                            //   // height: 100,
                            //   width: double.maxFinite,
                            //   color: Colors.black87,
                            // child:
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Icon(
                            //       Icons.watch_later_outlined,
                            //       color: Colors.black,
                            //       size: 25,
                            //     ),
                            //     Text(
                            //       '20-40 mins |',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Row(
                            //       children: [
                            //         Icon(
                            //           Icons.star,
                            //           color: Colors.yellow,
                            //           size: 25,
                            //         ),
                            //         Text('4.2',
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold)),
                            //       ],
                            //     )
                            //   ],
                            // ),
                            // // ),
                            // const SizedBox(
                            //   height: 30,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Expanded(
                            //       child: Padding(
                            //         padding:
                            //             EdgeInsets.symmetric(horizontal: 10),
                            //         child: Container(
                            //           height: 5,
                            //           color: Colors.black26,
                            //         ),
                            //       ),
                            //     ),
                            //     Text(
                            //       'Menu',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Expanded(
                            //       child: Padding(
                            //         padding:
                            //             EdgeInsets.symmetric(horizontal: 10),
                            //         child: Container(
                            //           height: 5,
                            //           color: Colors.black26,
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 30,
                            // ),
                            ...List.generate(bloc.items.length, (index) {
                              final items = bloc.items[index];
                              final cartIndex = cart.firstWhere(
                                  (dish) =>
                                      dish.dish_id ==
                                      bloc.items[index].product?.dishid,
                                  orElse: () =>
                                      CartModelNew(dish_id: 0, quantity: 0));
                              final quantityindex = cart.indexWhere((dish) =>
                                  dish.dish_id == items.product?.dishid);
                              if (bloc.items[index].isCategory) {
                                return RappiCategory(
                                    category: bloc.items[index].category);
                              } else {
                                return RappiProduct(
                                  dish: bloc.items[index].product!,
                                  cartItem: cartIndex,
                                  qunatityindex: quantityindex,
                                  userId: supabaseClient.auth.currentUser!.id,
                                );
                              }
                            }),
                          ])),
                    ),
                    // Positioned(
                    //     top: myOffset <= 300
                    //         ? _imageHeight - 30
                    //         : _imageHeight - 145,
                    //     // right: (60 - 60) / 2,
                    //     left: (MediaQuery.of(context).size.width - 60) / 2,
                    //     child: AnimatedContainer(
                    //       duration: const Duration(milliseconds: 400),
                    //       curve: Curves.easeInOut,
                    //       child: ClipRRect(
                    //         borderRadius:
                    //             BorderRadius.circular(_imageContainerRadius),
                    //         child: Container(
                    //           height: 60,
                    //           width: 60,
                    //           color: Colors.amber,
                    //         ),
                    //       ),
                    //     ),

                    //     ),
                    Positioned(
                      top: 0,
                      left: 5,
                      child: AnimatedOpacity(
                        curve: Curves.bounceIn,
                        opacity: myOffset >= 110 ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 25,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Positioned(
                      top: myOffset >= 100
                          ? _imageHeight - 90
                          : _imageHeight - 145,
                      // top: myOffset <= 50
                      //     ? _imageHeight - 30
                      //     : _imageHeight - 145,
                      //right: (MediaQuery.of(context).size.width - 60) / 1.1,
                      left: myOffset >= 110
                          ? (MediaQuery.of(context).size.width - 80) / 1
                          : (MediaQuery.of(context).size.width - 60) / 5,
                      child: AnimatedSlide(
                        offset: Offset(myOffset >= 110 ? -4.2 : 0, 0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                        child: Text(
                          'AlBaiq',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: myOffset >= 110
                                  ? Colors.white
                                  : Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
