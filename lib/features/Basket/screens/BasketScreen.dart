import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Cartmodel.dart';

import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/commons/basketcard.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Payment/PaymentScreen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

// class BasketScreen extends ConsumerStatefulWidget {
//   List<DishData> dishes = [];
//   static const String routename = "/Dummy_basket";

//   RestaurantModel restaurantData;
//   BasketScreen({
//     super.key,
//     //required this.cart,
//     required this.dishes,
//     required this.restaurantData,
//   });
//   // List<New> cart = [];

//   @override
//   ConsumerState<BasketScreen> createState() => _DummyBasketState();
// }

// class _DummyBasketState extends ConsumerState<BasketScreen> {
//   bool isloader = true;
//   @override
//   Widget build(BuildContext context) {
//     final dishesList = ref.watch(dishesListProvider);
//     final userId = supabaseClient.auth.currentUser!.id;
//     var carttotalamount = ref.read(cartReopProvider).getTotalPrice(ref);
//     final cart = ref.watch(cartProvider);
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.pushNamed(
//             context,
//             RestaurantMenuScreen.routename,
//             arguments: widget.restaurantData,
//           ),
//         ),
//         title: const Text(
//           'Your Basket',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: cart.isEmpty && carttotalamount == 0
//           ? const Center(
//               child: Text(
//               'No Item in cart',
//               style: TextStyle(fontSize: 24),
//             ))
//           : Column(
//               children: [
//                 // Scrollable ListView
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: cart.length,
//                           itemBuilder: (context, index) {
//                             final cartitem = cart[index];
//                             final dishindex = widget.dishes.firstWhere(
//                               (dish) => dish.dishid == cart[index].dish_id,
//                               orElse: () => DishData(isVariation: false),
//                             );
//                             return InkWell(
//                               onTap: () {
//                                 if (dishindex.isVariation) {
//                                   ref.read(isloaderProvider.notifier).state =
//                                       true;
//                                   ref.read(isloaderProvider.notifier).state =
//                                       true;
//                                   Navigator.pushNamed(
//                                       context, DishMenuVariation.routename,
//                                       arguments: {
//                                         'isdishscreen': false,
//                                         'dishes': dishesList,
//                                         'dish': dishindex,
//                                         'iscart': true,
//                                         'cartdish': cartitem,
//                                         'restaurantdata': widget.restaurantData,
//                                         'carts': cart,
//                                       });
//                                 } else {
//                                   ref.read(isloaderProvider.notifier).state =
//                                       true;
//                                   Navigator.pushNamed(
//                                       context, DishMenuScreen.routename,
//                                       arguments: {
//                                         'restaurantdata': widget.restaurantData,
//                                         'dishes': dishesList,
//                                         'dish': dishindex,
//                                         'iscart': true,
//                                         'cartdish': cartitem,
//                                         'isdishscreen': false
//                                       });
//                                 }
//                               },
//                               child: BasketCard(
//                                   titleVariationList: const [],
//                                   cardHeight: 150,
//                                   elevation: 0,
//                                   cardColor: Colors.white,
//                                   dish: dishindex,
//                                   imageHeight: 100,
//                                   imageWidth: 100,
//                                   cartItem: cartitem,
//                                   userId: userId,
//                                   isCartScreen: false,
//                                   quantityIndex: index),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Sticky "Total" Section at the Bottom

//                 Container(
//                   height: 180,
//                   width: double.maxFinite,
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: const [
//                         BoxShadow(
//                             color: Colors.black,
//                             offset: Offset(6, 6),
//                             spreadRadius: 1,
//                             blurRadius: 5)
//                       ],
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Column(
//                     children: [
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Total',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Platform fee'),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               color: Colors.black,
//                               child: const Text('\$2.0',
//                                   style: TextStyle(color: Colors.white)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('Total'),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 5),
//                               color: Colors.black,
//                               child: Text(
//                                 '\$$carttotalamount',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: SizedBox(
//                           height: 40,
//                           width: double.maxFinite,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: InkWell(
//                               onTap: () => Navigator.pushNamed(
//                                   context, PaymentScreen.routename),
//                               child: const Text(
//                                 "PROCEED TO CHECKOUT",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     ));
//   }
// }
class BasketScreen extends ConsumerStatefulWidget {
  List<DishData> dishes = [];
  static const String routename = "/Dummy_basket";
  RestaurantModel restaurantData;

  BasketScreen({
    super.key,
    required this.dishes,
    required this.restaurantData,
  });

  @override
  ConsumerState<BasketScreen> createState() => _DummyBasketState();
}

class _DummyBasketState extends ConsumerState<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    final dishesList = ref.watch(dishesListProvider);
    final userId = supabaseClient.auth.currentUser!.id;
    var carttotalamount = ref.read(cartReopProvider).getTotalPrice(ref);
    final cart = ref.watch(cartProvider);

    // Group cart items by restaurant_id
    Map<String, List<Cartmodel>> groupedByRestaurant = {};
    Map<String, String> restaurantNames = {}; // Store restaurant names
    
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
                          final restaurantId = entry.key;
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
                                        color: Colors.orange.withOpacity(0.4),
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
                                          color: Colors.white.withOpacity(0.25),
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
                                                    color: Colors.white.withOpacity(0.25),
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
                                  final dishindex = widget.dishes.firstWhere(
                                    (dish) => dish.dishid == cartitem.dish_id,
                                    orElse: () => DishData(isVariation: false),
                                  );
                                  final itemIndex = cart.indexOf(cartitem);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: InkWell(
                                      onTap: () {
                                        if (dishindex.isVariation) {
                                          ref.read(isloaderProvider.notifier).state = true;
                                          Navigator.pushNamed(
                                            context,
                                            DishMenuVariation.routename,
                                            arguments: {
                                              'isdishscreen': false,
                                              'dishes': dishesList,
                                              'dish': dishindex,
                                              'iscart': true,
                                              'cartdish': cartitem,
                                              'restaurantdata': widget.restaurantData,
                                              'carts': cart,
                                            },
                                          );
                                        } else {
                                          ref.read(isloaderProvider.notifier).state = true;
                                          Navigator.pushNamed(
                                            context,
                                            DishMenuScreen.routename,
                                            arguments: {
                                              'restaurantdata': widget.restaurantData,
                                              'dishes': dishesList,
                                              'dish': dishindex,
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
                                        dish: dishindex,
                                        imageHeight: 75,
                                        imageWidth: 75,
                                        cartItem: cartitem,
                                        userId: userId,
                                        isCartScreen: false,
                                        quantityIndex: itemIndex,
                                      ),
                                    ),
                                  );
                                }).toList(),
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
                          color: Colors.black.withOpacity(0.15),
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
                  color: Colors.orange.withOpacity(0.2),
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