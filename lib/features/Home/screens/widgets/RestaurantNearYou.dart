import 'package:flutter/material.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';


class RestaurantNearYou extends StatelessWidget {
  final List<RestaurantModel> nearByRestaurants;

  const RestaurantNearYou({super.key, required this.nearByRestaurants});

  @override
  Widget build(BuildContext context) {


   return nearByRestaurants.isNotEmpty?
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      

        SizedBox(
          height: Responsive.h230px, // fixed height for horizontal list
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding:  EdgeInsets.symmetric(horizontal: Responsive.w16px),
            itemCount: nearByRestaurants.length,
            separatorBuilder: (context, index) =>  SizedBox(width: Responsive.w16px),
            itemBuilder: (context, index) {
              final restaurant = nearByRestaurants[index];
              return _RestaurantCard(restaurant: restaurant);
            },
          ),
        ),
      ],
    ) : const SizedBox();
  }
}

class _RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
   

    return Container(
      width: Responsive.w180px,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Restaurant Image
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    restaurant.restaurantImageUrl ??
                        'https://via.placeholder.com/300x200?text=Restaurant',
                    fit: BoxFit.cover,
                  ),
                ),
            
                // Gradient Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                ),
            
                // ⭐ Rating badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.averageRatings?.toStringAsFixed(1) ?? "4.5",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🏪 Restaurant Info
          Expanded(
            flex:4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.restaurantName ?? "Unnamed Restaurant",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Delivery Time
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${restaurant.minTime ?? 10}-${restaurant.maxTime ?? 30} min",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
            
                      // Delivery Fee
                      Row(
                        children: [
                          const Icon(Icons.delivery_dining,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            "\$${restaurant.deliveryFee?.toStringAsFixed(1) ?? "0"}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
