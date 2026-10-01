import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart' show cartProvider, cartReopProvider;
import 'package:spicy_eats/features/Cart/widgets/BasketCard.dart';
import 'package:spicy_eats/features/Payment/PaymentScreen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Restaurants/services/RestaurantLocalDataBase.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/main.dart';

import '../../Home/model/restaurant_model.dart';


class CartScreen extends ConsumerStatefulWidget {
  static const String routename = "/basket";

  /// Optional hints for callers that already have a menu open. The screen
  /// rebuilds everything it needs from the cart rows and the restaurant cache,
  /// so it also works with no arguments at all - which is what lets it be used
  /// as a tab and reached from the home cart button.
  final List<DishData>? dishes;
  final RestaurantModel? restaurantData;

  const CartScreen({
    super.key,
    this.dishes,
    this.restaurantData,
  });

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  List<RestaurantModel> _restaurantCache = [];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      final restaurants =
          await RestaurantLocalDatabase.instance.getRestaurants();
      if (mounted) setState(() => _restaurantCache = restaurants);
    } catch (e) {
      debugPrint('Failed To Load Restaurants For Cart $e');
    }
  }

  /// A cart row already carries everything a card and its detail screen need,
  /// so a dish is rebuilt from the row instead of hunting the menu cache for a
  /// match that may not be loaded yet.
  DishData _dishFor(Cartmodel item) {
    for (final dish in widget.dishes ?? const <DishData>[]) {
      if (dish.dishid == item.dish_id) return dish;
    }

    return DishData(
      dishid: item.dish_id,
      id: item.dish_id,
      dish_name: item.name ?? '',
      dish_description: item.description ?? '',
      dish_imageurl: item.image ?? '',
      dish_price: item.itemprice ?? item.tprice ?? 0,
      isVariation:
          item.variation != null && item.variation!.isNotEmpty,
      restuid: item.restaurant_id,
    );
  }

  /// Resolves the restaurant a group belongs to, falling back to a stub built
  /// from the ids the cart row already holds.
  RestaurantModel _restaurantFor(List<Cartmodel> items) {
    final restaurantId = items.first.restaurant_id ?? '';
    for (final restaurant in _restaurantCache) {
      if (restaurant.restuid == restaurantId) return restaurant;
    }
    if (widget.restaurantData?.restuid == restaurantId) {
      return widget.restaurantData!;
    }

    return RestaurantModel(
      restuid: restaurantId,
      restaurantName: items.first.restaurant_name ?? 'Restaurant',
      // Downstream screens dereference these with `!`, so a stub has to carry
      // real values rather than nulls.
      averageRatings: 0,
      totalRatings: 0,
      minTime: 0,
      maxTime: 0,
      deliveryFee: 0,
      restaurantImageUrl: '',
      cuisineIds: const [],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The cart is local-first, so it is readable before (or without) a signed
    // in user. BasketCard does not need the id, and the screen is also a tab,
    // so it must not assume auth.currentUser is non-null.
    final userId = supabaseClient.auth.currentUser?.id ?? '';
    var carttotalamount = ref.read(cartReopProvider).getTotalPrice(ref);
    final cart = ref.watch(cartProvider);

    // Group cart items by restaurant_id
    Map<String, List<Cartmodel>> groupedByRestaurant = {};
    
    for (var cartItem in cart) {
      final restaurantId = cartItem.restaurant_id ?? 'unknown';
      
      if (!groupedByRestaurant.containsKey(restaurantId)) {
        groupedByRestaurant[restaurantId] = [];
        // Get restaurant name from first item (you might want to fetch from DB)
    
        // restaurantNames[restaurantId] = widget.restaurantData.restaurantName ?? 'Restaurant';
      }
      groupedByRestaurant[restaurantId]!.add(cartItem);
       
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Column(
            children: [
              const Text(
                'Your Basket',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Text(
                '${cart.length} item${cart.length != 1 ? 's' : ''} from ${groupedByRestaurant.length} restaurant${groupedByRestaurant.length != 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: cart.isEmpty && carttotalamount == 0
            ? _buildEmptyCart()
            : Column(
                children: [
                  // Scrollable Restaurant Groups with Items
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Column(
                        children: groupedByRestaurant.entries.map((entry) {
                        
                          final restaurantItems = entry.value;
                          final restaurantName = restaurantItems.first.restaurant_name ?? "Restaurant";
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
                                // Restaurant Header Card
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.orange[600]!,
                                        Colors.orange[400]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withValues(alpha: 0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.restaurant,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                               restaurantName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withValues(alpha: 0.25),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    '${restaurantItems.length} item${restaurantItems.length != 1 ? 's' : ''}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Items for this restaurant
                                ...restaurantItems.map((cartitem) {
                                  final dish = _dishFor(cartitem);
                                  final itemIndex = cart.indexOf(cartitem);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: InkWell(
                                      onTap: () {
                                        if (dish.isVariation) {
                                          ref.read(isloaderProvider.notifier).state = true;
                                          Navigator.pushNamed(
                                            context,
                                            DishMenuVariation.routename,
                                            arguments: {
                                              'isdishscreen': false,
                                              'dishes': [
                                                dish,
                                                ...restaurantItems
                                                    .where((e) =>
                                                        e.dish_id !=
                                                            cartitem.dish_id)
                                                    .map(_dishFor),
                                              ],
                                              'dish': dish,
                                              'iscart': true,
                                              'cartdish': cartitem,
                                              'restaurantdata':
                                                  _restaurantFor(restaurantItems),
                                              'carts': cart,
                                            },
                                          );
                                        } else {
                                          ref.read(isloaderProvider.notifier).state = true;
                                          Navigator.pushNamed(
                                            context,
                                            DishMenuScreen.routename,
                                            arguments: {
                                              'restaurantdata':
                                                  _restaurantFor(restaurantItems),
                                              'dishes': restaurantItems
                                                  .map(_dishFor)
                                                  .toList(),
                                              'dish': dish,
                                              'iscart': true,
                                              'cartdish': cartitem,
                                              'isdishscreen': false
                                            },
                                          );
                                        }
                                      },
                                      child: BasketCard(
                                        titleVariationList: const [],
                                        cardHeight: null,
                                        elevation: 0,
                                        cardColor: Colors.white,
                                        dish: dish,
                                        imageHeight: 75,
                                        imageWidth: 75,
                                        cartItem: cartitem,
                                        userId: userId,
                                        isCartScreen: false,
                                        quantityIndex: itemIndex,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Compact Sticky Total Section
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${(carttotalamount ).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.green[200]!,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer,
                                      color: Colors.green[700],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Incl. taxes',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                PaymentScreen.routename,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[700],
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'PROCEED TO CHECKOUT',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: Colors.orange[300],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Your basket is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add delicious items to get started',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.restaurant_menu, size: 22),
            label: const Text('Browse Menu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}