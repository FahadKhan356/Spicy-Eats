import 'package:flutter/material.dart';
import 'package:flutter_map_location_picker/flutter_map_location_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';

class MyMap extends ConsumerStatefulWidget {
  static const String routename = '/map';
  MyMap({super.key});

  @override
  ConsumerState<MyMap> createState() => _MyMapState();
}

class _MyMapState extends ConsumerState<MyMap> {
  @override
  Widget build(BuildContext context) {
    final lat = ref.watch(restaurantLatProvider);
    final long = ref.watch(restaurantLongProvider);
    final address = ref.watch(restaurantAddProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Select Restaurant Location'),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: MapLocationPicker(
            initialLatitude: 25.3936435,
            initialLongitude: 68.3838603,
            onPicked: (result) {
              // you can get the location result here
              if (mounted) {
                ref.read(restaurantAddProvider.notifier).state =
                    result.completeAddress;
                ref.read(restaurantLatProvider.notifier).state =
                    result.latitude;
                ref.read(restaurantLongProvider.notifier).state =
                    result.longitude;
              }

              print(address);
              print(lat);
              print(long);
              // print(result.completeAddress);
              // print(result.latitude);
              // print(result.longitude);
            }),
        bottomNavigationBar: address != null
            ? Text('$address (Lat: $lat, Long: $long)')
            : const Text('Loading location...'),
      ),
    );
  }
}
