import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/commons/custommap.dart';

class MyMap extends ConsumerStatefulWidget {
  static const String routename = '/map';
  const MyMap({super.key});

  @override
  ConsumerState<MyMap> createState() => _MyMapState();
}

class _MyMapState extends ConsumerState<MyMap> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomMap(
            initialLatitude: 25.3936435,
            initialLongitude: 68.3838603,
            onPicked: (result) {
              print('Selected address: ${result.completeAddress}');
              print('Selected lat: ${result.latitude}');
              print('Selected long: ${result.longitude}');

              // you can get the location result here
              if (mounted) {
                ref.read(restaurantAddProvider.notifier).state =
                    result.completeAddress;
                ref.read(restaurantLatProvider.notifier).state =
                    result.latitude;
                ref.read(restaurantLongProvider.notifier).state =
                    result.longitude;
              }
              if (mounted) {
                Navigator.pop(context);
              }
            }),
      ),
    );
  }
}
