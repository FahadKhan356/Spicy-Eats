import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

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
  const MyFinalScrollScreen({super.key});

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
  String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  bool isTabPinned = false;
  late AnimationController _opacityController;
  late Animation _opacityAnimation;
  double _imageHeight = 300;
  double _imageOpacity = 1;
  double _titletabOpacity = 0;
  double _tabOpacity = 0;

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

    fetchcategoriesAnddishes(restuid).then((value) {
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
    double newImatgeHeight = (300 - myOffset).clamp(80, 300);
    double newImageOpacity = 1 - (myOffset / 100).clamp(0.3, 1);
    double newTitleTabOpacity = (myOffset > 200) ? 1.00 : 0.0;
    double newtabOpacity = (myOffset > 200) ? 1.0 : 0.0;
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
    return Scaffold(
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
                      color: Colors.white,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _imageOpacity,
                        curve: Curves.easeIn,
                        child: Image.network(
                          'https://mrqaapzhzeqvarrtfkgv.supabase.co/storage/v1/object/public/Restaurant_Registeration//8d019a6b-b66a-466e-99b9-c66f9745ba70/Restaurant_covers',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                      animation: bloc,
                      builder: (_, __) {
                        updateOffset();
                        return Positioned(
                          top: 0,
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
                                      .map((e) => Rappi_tab_widget(category: e))
                                      .toList()),
                            ),
                          ),
                        );
                      }),
                  Positioned.fill(
                    top: _imageHeight,
                    child: SingleChildScrollView(
                        controller: bloc.scrollController,
                        child: Column(
                            children: List.generate(bloc.items.length, (index) {
                          if (bloc.items[index].isCategory) {
                            return RappiCategory(
                                category: bloc.items[index].category);
                          } else {
                            return RappiProduct(
                                dish: bloc.items[index].product!);
                          }
                        }).toList())),
                  ),
                ],
              ));
  }
}
