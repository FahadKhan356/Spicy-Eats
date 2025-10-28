import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/dish%20menu/controller/dish-menu_controller.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/features/dish%20menu/widget/customBottomBar.dart';
import 'package:spicy_eats/features/dish%20menu/widget/freqDishesList.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';

final isloaderProvider = StateProvider<bool>((ref) => false);
var quantityPrvider = StateProvider<int>((ref) => 1);
var updatedQuantityProvider = StateProvider<int>((ref) => 1);
final freqnewListProvider = StateProvider<List<DishData>?>((ref) => null);




// Enhanced DishMenuScreen with professional UI
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  bool isCart = false;
  Cartmodel? cartDish;
  bool isbasket = false;
  List<DishData>? freqList = [];
  RestaurantModel? restaurantData;
  bool? isdishscreen = false;

  DishMenuScreen({
    super.key,
    required this.dish,
    this.cartDish,
    required this.isCart,
    required this.isdishscreen,
    required this.restaurantData,
  });

  @override
  ConsumerState<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuScreen>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  AnimationController? _animationController;
  Animation<double>? _opacityanimation;
  Animation<Offset>? _offsetanimation;
  bool isExpanded = false;
  bool? withvariation;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  void _scrollListener() {
    if (!mounted) return;
    final offset =
        _scrollController!.hasClients ? _scrollController!.offset : 0.0;

    if (offset > 50) {
      _animationController!.forward();
    } else {
      _animationController!.reverse();
    }
  }

  Future<void> fetchInitialData() async {
    final list = await ref
        .read(dishMenuControllerProvider)
        .fetchfrequentlybought(freqId: widget.dish!.frequentlyid, ref: ref);
    setState(() {
      widget.freqList = list;
    });

    setState(() {
      withvariation = false;
    });

    if (widget.isCart) {
      ref.read(updatedQuantityProvider.notifier).state =
          widget.cartDish!.quantity;
    }
    ref.read(quantityPrvider.notifier).state = 1;

    ref.read(isloaderProvider.notifier).state = false;

    if (widget.isCart) {
      for (int i = 0; i < ref.watch(cartProvider).length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == ref.read(cartProvider)[i].dish_id);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeOut));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController!, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(isloaderProvider);
    final screen = MediaQuery.of(context).size;
    final width = screen.width;
    final height = screen.height;
    final quantity = ref.watch(quantityPrvider);
    final updatedQuantity = ref.watch(updatedQuantityProvider);
    final cartData = ref.watch(cartProvider);
    

    final totalquantity = ref
        .read(cartReopProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid ?? 0);

    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: Colors.grey[50],
      body: Skeletonizer(
        ignorePointers: true,
        ignoreContainers: true,
        enabled: loader,
        enableSwitchAnimation: true,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 1.0,
                minChildSize: 1.0,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  if (_scrollController != scrollController) {
                    _scrollController?.removeListener(_scrollListener);
                    _scrollController = scrollController;
                    _scrollController!.addListener(_scrollListener);
                  }
                  return Stack(
                    children: [
                      CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        slivers: [
                          // Enhanced SliverAppBar with professional styling
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            elevation: 0,
                            leading: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            // actions: [
                              // Container(
                              //   margin: const EdgeInsets.all(8),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     shape: BoxShape.circle,
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.black.withOpacity(0.1),
                              //         blurRadius: 8,
                              //         offset: const Offset(0, 2),
                              //       ),
                              //     ],
                              //   ),
                              //   child: IconButton(
                              //     icon: const Icon(Icons.favorite_border, color: Colors.red),
                              //     onPressed: () {},
                              //   ),
                              // ),
                            //   const SizedBox(width: 8),
                            // ],
                            title: AnimatedBuilder(
                              animation: _animationController!,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: _offsetanimation!.value,
                                  child: Opacity(
                                    opacity: _opacityanimation!.value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                widget.dish!.dish_name ?? "Dish",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            expandedHeight: height * 0.4,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      widget.dish!.dish_imageurl ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        color: Colors.grey[200],
                                        child: Icon(Icons.image_not_supported,
                                            size: 64, color: Colors.grey[400]),
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay for better text visibility
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Dish Details Section
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                              ),
                              child: Column(
                                children: [
                                  // Main Info Card
                                  Container(
                                    margin: const EdgeInsets.all(16),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Dish Name
                                        Text(
                                          widget.dish!.dish_name!,
                                          style: TextStyle(
                                            fontSize: width * 0.06,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Price Section
                                        Row(
                                          children: [
                                            if (widget.dish!.dish_discount != null) ...[
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'Rs \$${widget.dish!.dish_discount}',
                                                  style: TextStyle(
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green[700],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                '\$${widget.dish!.dish_price}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  decoration: TextDecoration.lineThrough,
                                                  decorationColor: Colors.red,
                                                  decorationThickness: 2,
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${(((widget.dish!.dish_price! - widget.dish!.dish_discount!) / widget.dish!.dish_price!) * 100).toStringAsFixed(0)}% OFF',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ] else
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'Rs \$${widget.dish!.dish_price}',
                                                  style: TextStyle(
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green[700],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        if (!widget.isCart && cartData.any((e) => (e as Cartmodel).dish_id == widget.dish!.dishid)) ...[
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange[50],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.orange[200]!,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.orange[900],
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Already in your cart',
                                                  style: TextStyle(
                                                    color: Colors.orange[900],
                                                    fontSize: width * 0.035,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],

                                        const SizedBox(height: 16),
                                        const Divider(),
                                        const SizedBox(height: 16),

                                        // Description
                                        const Text(
                                          'Description',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          widget.dish!.dish_description!,
                                          style: TextStyle(
                                            fontSize: width * 0.038,
                                            color: Colors.grey[700],
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Cart Info Card (if applicable)
                                  if (widget.isdishscreen! && widget.cartDish?.name != null)
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.orange[100]!,
                                            Colors.orange[50]!,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.orange[300]!,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${totalquantity}x',
                                              style: TextStyle(
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange[900],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '${widget.cartDish!.name}',
                                              style: TextStyle(
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              CartScreen.routename,
                                              arguments: {
                                                'dishes': ref
                                                    .read(dishesListProvider.notifier)
                                                    .state,
                                                'restdata': widget.restaurantData,
                                              },
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange[900],
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      fontSize: width * 0.035,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Frequently Bought Together Section
                                  if (widget.freqList != null &&
                                      widget.freqList!.isNotEmpty) ...[
                                    const SizedBox(height: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.purple.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.shopping_basket,
                                              color: Colors.purple[700],
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Frequently Bought Together',
                                            style: TextStyle(
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ]else...[
                                    const SizedBox(),
                                  ]
                                ],
                              ),
                            ),
                          ),

                          // Frequently Bought Items Grid
                          if (widget.freqList != null && widget.freqList!.isNotEmpty)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              sliver: SliverToBoxAdapter(
                                child: Freqdisheslist(
                                  screenSize: width,
                                  freqList: widget.freqList!,
                                ),
                              ),
                            ),

                          const SliverToBoxAdapter(
                            child: SizedBox(height: 120),
                          ),
                        ],
                      ),

                      // Bottom Action Bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: customBottomBar(
                            true,
                            mounted,
                            scaffoldMessengerKey,
                            false,
                            false,
                            ref,
                            width,
                            widget.isCart,
                            updatedQuantity,
                            context,
                            widget.dish!,
                            quantity,
                            widget.restaurantData!,
                            height,
                            _debouncer,
                            onAction: () {
                              ref.read(isloaderProvider.notifier).state = true;
                              ref.read(dishMenuRepoProvider).dishesCrud(
                                restaurantName: widget.restaurantData!.restaurantName!,
                                restaurantId: widget.restaurantData!.restuid!,
                                  cart: widget.cartDish!,
                                  context: context,
                                  ref: ref,
                                  isCart: widget.isCart,
                                  updatedQuantity: updatedQuantity,
                                  dish: widget.dish!,
                                  quantity: quantity);

                              ref
                                  .read(dishMenuRepoProvider)
                                  .addAllFreqBoughtItems(ref: ref,restaurantId: widget.restaurantData!.restuid!,restaurantName: widget.restaurantData!.restaurantName!);

                              Navigator.pushNamed(
                                context,
                                RestaurantMenuScreen.routename,
                                arguments: widget.restaurantData,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}