import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Lists.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';

class HomeBannersCrousel extends StatelessWidget {
  const HomeBannersCrousel({
    super.key,
    required this.ref,
    required this.crouselIndicator,
  });

  final WidgetRef ref;
  final int crouselIndicator;

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, r) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(crouselIndicatorProvider.notifier).state = index;
              });
            },
            height: 160.0,
            autoPlay: true,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
          items: bannerImages.map((e) {
            return Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    e,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerImages.length, (index) {
            final isActive = crouselIndicator == index;
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.bounceIn,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: Responsive.h5px,
              width: isActive ? Responsive.w14px : Responsive.w7px,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.orange),
            );
          }),
        )
      ],
    );
  }
}
