import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/commons/Providers.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/commons/categoriesmodel.dart';
import 'package:spicy_eats/commons/bloc.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/GlassIconButton.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/RestaurantCategory.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/RestaurantProduct.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/sliverTabBar.dart';
import 'package:spicy_eats/features/cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

var restaurantProvider = StateProvider<RestaurantModel?>((ref) => null);

class RestaurantMenuScreen extends ConsumerStatefulWidget {
  static const String routename = 'RestaurantMenuScreen/';
  final RestaurantModel restaurantData;
  const RestaurantMenuScreen({
    super.key,
    required this.restaurantData,
  });

  @override
  ConsumerState<RestaurantMenuScreen> createState() =>
      _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState
    extends ConsumerState<RestaurantMenuScreen>
    with TickerProviderStateMixin {
  final bloc = RappiBloc();
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  List<VariattionTitleModel>? titleVariationList = [];
  bool showTabBar = false;
  bool isTabControllerReady = false; // Track initialization
  bool cartFetched = false;
  final userId = supabaseClient.auth.currentUser!.id;

  List<CusinesModel> displayCusine = [];
  Future<void> fetchCusinesForRestaurant(
      {required List<int>? cusinesIds}) async {
    if (cusinesIds != null) {
      final templist = ref
          .read(cusineListProvider.notifier)
          .state
          .where((element) => cusinesIds.contains(element.id))
          .toList();
      setState(() {
        displayCusine = templist;
      });
    }
  }

  Future fetchcategoriesAnddishes(String restuid) async {
    ref.read(isloaderProvider.notifier).state = true;

    await ref
        .read(homeControllerProvider)
        .getDishesData(widget.restaurantData.restuid!)
        .then((value) {
      setState(() {
        dishes = value;
      });
      ref.read(restaurantProvider.notifier).state = widget.restaurantData;
      ref.read(dishesListProvider.notifier).state = value;
    });
    await ref
        .read(homeControllerProvider)
        .fetchCategories(restuid: widget.restaurantData.restuid!)
        .then((value) {
      if (value != null && mounted) {
        setState(() {
          allcategories = value.cast<Categories>();
          print(allcategories[0].category_name);
        });
      }
    });
    await fetchCusinesForRestaurant(
        cusinesIds: widget.restaurantData.cuisineIds!);
    ref.read(isloaderProvider.notifier).state = false;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchcategoriesAnddishes(widget.restaurantData.restuid!).then((value) {
          if (allcategories.isNotEmpty) {
            setState(() {
              bloc.tabController =
                  TabController(length: allcategories.length, vsync: this);

              isTabControllerReady = true; // Mark as ready
            });
          }

          bloc.init(this, dishes: dishes, categories: allcategories);
          bloc.scrollController!.addListener(() {
            _scrollListener();
          });
        });
      }
    });

    ref.read(cartReopProvider).initializeCart(userId: userId, ref: ref);
  }

  void _scrollListener() {
    double offset = bloc.scrollController!.offset;
    double triggerOffset = 180; // Change based on your UI

    if (offset >= triggerOffset && !showTabBar) {
      setState(() {
        showTabBar = true;
      });
    } else if (offset < triggerOffset && showTabBar) {
      setState(() {
        showTabBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = ref.watch(isloaderProvider);
    final isfav =
        ref.watch(favoriteProvider)[widget.restaurantData.restuid] ?? false;
    final cart = ref.watch(cartProvider);
    var carttotalamount = ref.read(cartReopProvider).getTotalPrice(ref);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: cart.isEmpty
    ? const SizedBox()
    : Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, CartScreen.routename,
                    arguments: {
                      'dishes': dishes,
                      'restuid': widget.restaurantData.restuid,
                      'restdata': widget.restaurantData,
                    });
                cartFetched = false;
                ref.read(cartReopProvider).getTotalPrice(ref);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.black, Color(0xFF2C2C2C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Cart info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        cart.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cart.length} ${cart.length == 1 ? 'Item' : 'Items'}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${carttotalamount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Right side - View Cart button
                      Row(
                        children: [
                          const Text(
                            'View Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
     
              
        backgroundColor: Colors.white,
        body: Skeletonizer(
          enabled: isLoading,
          ignorePointers: true,
          ignoreContainers: true,
          enableSwitchAnimation: true,
          child: CustomScrollView(
            controller: bloc.scrollController,
            slivers: [
              SliverAppBar(
                leadingWidth: size.width * 0.15,
                centerTitle: true,
                leading: Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.03, top: size.width * 0.013),
                  child: GlassIconButton(
                    height: size.width * 0.1,
                    width: size.width * 0.1,
                    icon: Icons.arrow_back_ios_sharp,
                    onTap: () => Navigator.pushNamed(context, Home.routename),
                  ),
                ),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(
                          right: size.width * 0.03, top: size.width * 0.013),
                      child: GlassIconButton(
                        height: size.width * 0.12,
                        width: size.width * 0.12,
                        icon: isfav
                            ? Icons.favorite
                            : Icons.favorite_outline_sharp,
                        iconColor: isfav ? Colors.orange[900] : Colors.black,
                        onTap: () => ref
                            .read(homeRepositoryController)
                            .togglefavorites(
                                userid: supabaseClient.auth.currentUser!.id,
                                restid: widget.restaurantData.restuid!,
                                ref: ref,
                                context: context),
                      ))
                ],
                elevation: 10,
                surfaceTintColor: Colors.white,
                pinned: true,
                expandedHeight: 300,
                collapsedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16, top: 10),
                  title: SizedBox(
                    height: 60,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: showTabBar
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.restaurantData.restaurantName}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RatingBar.builder(
                                            ignoreGestures: true,
                                            allowHalfRating: true,
                                            initialRating: widget
                                                .restaurantData.averageRatings!
                                                .toDouble(),
                                            itemSize: 15,
                                            itemCount: 5,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                                  Icons.star,
                                                  size: 22,
                                                ),
                                            onRatingUpdate: (double) {}),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${widget.restaurantData.averageRatings}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.5),
                                          child: Center(
                                              child: Container(
                                            height: 7,
                                            width: 7,
                                            color: Colors.black,
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${widget.restaurantData.totalRatings} Ratings',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ]),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ),
                  background: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Image.network(
                      widget.restaurantData.restaurantImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              isTabControllerReady
                  ? SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverTabBar(
                        isshowtabbar: showTabBar,
                        isTabControllerReady: isTabControllerReady,
                        bloc: bloc,
                      ),
                    )
                  : const SliverToBoxAdapter(child: SizedBox()),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.025),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurantData.restaurantName!,
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.009),
                      Row(
                        children: List.generate(
                          displayCusine.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              displayCusine[index].cusineName,
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.009),
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.orange, size: size.width * 0.03),
                          Text(
                            ' ${widget.restaurantData.totalRatings}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(' • ',
                              style: TextStyle(fontSize: size.width * 0.025)),
                          Icon(Icons.access_time,
                              size: size.width * 0.03, color: Colors.grey),
                          Text(
                              ' ${widget.restaurantData.minTime} - ${widget.restaurantData.maxTime}',
                              style: TextStyle(fontSize: size.width * 0.025)),
                          const Spacer(),
                          const Icon(Icons.delivery_dining,
                              color: Colors.green),
                          widget.restaurantData.deliveryFee != null
                              ? Text('${widget.restaurantData.deliveryFee!} ',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold))
                              : Text(' Free Delivery',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: size.width * 0.025)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: bloc.items.length, (context, index) {
                final cartIndex = cart.firstWhere(
                    (dish) => (dish as Cartmodel).dish_id == bloc.items[index].product?.dishid,
                    orElse: () =>
                        Cartmodel(created_at: '', dish_id: 0, quantity: 0));
                if (bloc.items[index].isCategory) {
                  return RestaurantCategory(
                      category: bloc.items[index].category);
                } else {
                  return RestaurantProduct(
                    restaurantData: widget.restaurantData,
                    dishes: dishes,
                    dish: bloc.items[index].product!,
                    cartItem: cartIndex,
                    userId: supabaseClient.auth.currentUser!.id,
                    titleVariationList: titleVariationList,
                  );
                }
              }))
            ],
          ),
        ),
      ),
    );
  }
}


