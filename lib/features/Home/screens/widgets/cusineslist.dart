import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';
import 'package:spicy_eats/commons/Responsive.dart';

import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';

class CusinesList extends ConsumerStatefulWidget {
  final List<CusinesModel>? cusineList;
  const CusinesList({super.key, required this.cusineList});

  @override
  ConsumerState<CusinesList> createState() => _CusinesListState();
}



class _CusinesListState extends ConsumerState<CusinesList> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isloaderProvider);
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.width * 0.40,
      width: double.infinity,
      color: Colors.white,
      child: Skeletonizer(
        ignorePointers: true,
        ignoreContainers: true,
        enabled: isLoading,
        enableSwitchAnimation: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header with Reset
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w20px,
                vertical: Responsive.h8px,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Responsive.w6px),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: Colors.purple[700],
                          size: Responsive.w16px,
                        ),
                      ),
                      SizedBox(width: Responsive.w8px),
                      Text(
                        'Cuisines',
                        style: TextStyle(
                          fontSize: Responsive.w16px,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(isloaderProvider.notifier).state = true;
                      Future.delayed(const Duration(milliseconds: 500));
                      ref.read(restaurantDisplayListProvider.notifier).state =
                          ref.read(restaurantlistProvider);
                      ref.read(isloaderProvider.notifier).state = false;
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w12px,
                        vertical: Responsive.h6px,
                      ),
                      backgroundColor: Colors.orange[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: Responsive.w12px,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cuisines Horizontal List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w12px),
                scrollDirection: Axis.horizontal,
                itemCount: widget.cusineList?.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    await ref
                        .read(restaurantFilterProvider.notifier)
                        .filterByCuisine(widget.cusineList![index].id);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Responsive.w8px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Cuisine Image with Border
                        Container(
                          width: size.width * 0.16,
                          height: size.width * 0.16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange[400]!,
                                Colors.orange[600]!,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.cusineList![index].cusineImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.h8px),
                        // Cuisine Name
                        SizedBox(
                          width: size.width * 0.18,
                          child: Text(
                            widget.cusineList![index].cusineName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width * 0.028,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// providers/restaurant_filter_provider.dart

final restaurantFilterProvider =
    StateNotifierProvider<RestaurantFilterNotifier, List<RestaurantModel>>(
        (ref) => RestaurantFilterNotifier(ref));

class RestaurantFilterNotifier extends StateNotifier<List<RestaurantModel>> {
  final Ref ref;
  RestaurantFilterNotifier(this.ref) : super([]);

  Future<void> filterByCuisine(int cuisineId) async {
    ref.read(isloaderProvider.notifier).state = true;

    await Future.delayed(const Duration(milliseconds: 300));

    final restList = ref.read(restaurantlistProvider);
    final filtered = restList
        .where((restaurant) =>
            restaurant.cuisineIds != null &&
            restaurant.cuisineIds!.contains(cuisineId))
        .toList();

    await Future.delayed(const Duration(milliseconds: 300));
    // state = filtered;
      ref.read(restaurantDisplayListProvider.notifier).state = filtered;

    ref.read(isloaderProvider.notifier).state = false;
  }


}
