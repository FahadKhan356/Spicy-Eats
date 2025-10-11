import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Providers.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/main.dart';

// class RestaurantContainer extends ConsumerStatefulWidget {
//   final String name;
//   final String price;
//   final String image;
//   final double ratings;
//   final int mindeliverytime;
//   final int maxdeliverytime;
//   final String restid;
//   final String userid;

//   const RestaurantContainer({
//     super.key,
//     required this.restid,
//     required this.userid,
//     required this.name,
//     required this.price,
//     required this.image,
//     required this.ratings,
//     required this.mindeliverytime,
//     required this.maxdeliverytime,
//   });

//   @override
//   ConsumerState<RestaurantContainer> createState() =>
//       _RestaurantContainerState();
// }

// class _RestaurantContainerState extends ConsumerState<RestaurantContainer> {
//   @override
//   Widget build(BuildContext context) {
//     bool isFav = ref.watch(favoriteProvider)[widget.restid] ?? false;

//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.maxFinite,
//             child: AspectRatio(
//               aspectRatio: 16 / 8,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       errorBuilder: (context, obj, stack) =>
//                           const Icon(Icons.image),
//                       widget.image,
//                       fit: BoxFit.cover,
//                       width: double.maxFinite,
//                     ),
//                   ),
//                   Positioned(
//                       right: size.width * 0.03,
//                       top: size.height * 0.02,
//                       child: GlassIconButton(
//                         height: 50,
//                         width: 50,
//                         icon: isFav
//                             ? Icons.favorite
//                             : Icons.favorite_outline_sharp,
//                         iconColor: isFav ? Colors.orange[900] : Colors.white,
//                         onTap: () => ref
//                             .read(registershoprepoProvider)
//                             .togglefavorites(
//                                 userid: supabaseClient.auth.currentUser!.id,
//                                 restid: widget.restid,
//                                 ref: ref,
//                                 context: context),
//                       ))
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.015,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.name,
//                         style: TextStyle(
//                             fontSize: size.width * 0.040,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis),
//                       ),

//                       Row(children: [
//                         Icon(
//                           Icons.access_time_sharp,
//                           color: Colors.black54,
//                           size: size.width * 0.05,
//                         ),
//                         Text(
//                           "${widget.mindeliverytime}-${widget.maxdeliverytime} mins",
//                           style: TextStyle(
//                               fontSize: size.width * 0.035,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           "\$${widget.price}",
//                           style: TextStyle(
//                               fontSize: size.width * 0.035,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ]),
                      
//                     ]),
//               ),
//               Container(
//                 height: size.width * 0.1,
//                 width: size.width * 0.1,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                                           colors: [
//                                             Colors.orange[500]!,
//                                             Colors.orange[100]!,
//                                           ],
//                                         ),
//                                          border: Border.all(
//                                           color: Colors.orange[600]!,
//                                           width: 2,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.orange[600]!,
//                                             blurRadius: 10,
//                                             offset: const Offset(0, 4),
//                                           ),
//                                         ],
//                     shape: BoxShape.circle,),
//                 child: Center(
//                   child: Text(
//                     widget.ratings.toString(),
//                     style: TextStyle(
//                         fontSize: size.width * 0.035,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


class RestaurantContainer extends ConsumerStatefulWidget {
  final String name;
  final String price;
  final String image;
  final double ratings;
  final int mindeliverytime;
  final int maxdeliverytime;
  final String restid;
  final String userid;

  const RestaurantContainer({
    super.key,
    required this.restid,
    required this.userid,
    required this.name,
    required this.price,
    required this.image,
    required this.ratings,
    required this.mindeliverytime,
    required this.maxdeliverytime,
  });

  @override
  ConsumerState<RestaurantContainer> createState() =>
      _RestaurantContainerState();
}

class _RestaurantContainerState extends ConsumerState<RestaurantContainer> {
  @override
  Widget build(BuildContext context) {
    bool isFav = ref.watch(favoriteProvider)[widget.restid] ?? false;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.w20px,
        vertical: Responsive.h10px,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image with Favorite Button
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, obj, stack) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.restaurant,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Gradient Overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
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

              // Favorite Button
              Positioned(
                right: 12,
                top: 12,
                child: GestureDetector(
                  onTap: () => ref.read(homeRepositoryController).togglefavorites(
                      userid: supabaseClient.auth.currentUser!.id,
                      restid: widget.restid,
                      ref: ref,
                      context: context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_outline,
                      color: isFav ? Colors.red : Colors.grey[700],
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Rating Badge
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.ratings.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Restaurant Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Name
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Delivery Info
                Row(
                  children: [
                    // Delivery Time
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[700],
                            size: size.width * 0.04,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.mindeliverytime}-${widget.maxdeliverytime} min",
                            style: TextStyle(
                              fontSize: size.width * 0.032,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Delivery Fee
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: Colors.green[700],
                            size: size.width * 0.04,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "\$${widget.price}",
                            style: TextStyle(
                              fontSize: size.width * 0.032,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}