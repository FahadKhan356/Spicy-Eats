import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Restaurants/services/RestaurantLocalDataBase.dart';
import 'package:spicy_eats/features/promotions/controller/promotions_controller.dart';
import 'package:spicy_eats/features/promotions/models/banner_slot_model.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';
import 'package:spicy_eats/main.dart';

class HomeBannersCrousel extends ConsumerWidget {
  const HomeBannersCrousel({
    super.key,
    required this.ref,
    required this.crouselIndicator,
  });

  final WidgetRef ref;
  final int crouselIndicator;

  Future<void> _handleBannerTap(BuildContext context, HomeBannerItem item) async {
    if (item.restaurantId == null || item.restaurantId!.isEmpty) return;

    try {
      // First check local restaurant cache
      final cachedRestaurants =
          await RestaurantLocalDatabase.instance.getRestaurants();
      RestaurantModel? restaurant;
      for (final r in cachedRestaurants) {
        if (r.restuid == item.restaurantId) {
          restaurant = r;
          break;
        }
      }

      // If not in cache, query Supabase
      if (restaurant == null) {
        final res = await supabaseClient
            .from('restaurants')
            .select()
            .eq('rest_uid', item.restaurantId!)
            .maybeSingle();

        if (res != null) {
          restaurant = RestaurantModel.fromJson(res);
        }
      }

      if (restaurant != null && context.mounted) {
        ref.read(isloaderProvider.notifier).state = true;
        Navigator.pushNamed(
          context,
          RestaurantMenuScreen.routename,
          arguments: restaurant,
        );
      }
    } catch (e) {
      debugPrint('Error navigating to restaurant from banner: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isloaderProvider);
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          height: 160,
          width: double.maxFinite,
        ),
      );
    }

    final bannersAsync = ref.watch(homeBannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();

        final safeIndicator =
            crouselIndicator >= banners.length ? 0 : crouselIndicator;

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                onPageChanged: (index, _) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(crouselIndicatorProvider.notifier).state = index;
                  });
                },
                height: 165.0,
                autoPlay: true,
                viewportFraction: 0.85,
                enlargeCenterPage: true,
                enlargeFactor: 0.25,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
              items: banners.map((banner) {
                return Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => _handleBannerTap(context, banner),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            banner.isNetwork
                                ? Image.network(
                                    banner.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'lib/assets/images/banners/banner1.png',
                                      fit: BoxFit.cover,
                                    ),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    banner.imageUrl,
                                    fit: BoxFit.cover,
                                  ),

                            // Overlay gradient & info for sponsored or promo banners
                            if (banner.title != null ||
                                banner.discountTag != null) ...[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.75),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 14,
                                right: 14,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (banner.discountTag != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[700],
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          banner.discountTag!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    if (banner.title != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        banner.title!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                final isActive = safeIndicator == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: Responsive.h5px,
                  width: isActive ? Responsive.w14px : Responsive.w7px,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isActive ? Colors.orange : Colors.grey[300],
                  ),
                );
              }),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          height: 160,
          width: double.maxFinite,
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
