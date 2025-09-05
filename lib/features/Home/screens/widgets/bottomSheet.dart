import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/widgets/map.dart';
import 'package:spicy_eats/commons/ConfirmLocation.dart';
import 'package:spicy_eats/commons/custommap.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/main.dart';

class CustomBottomSheet extends ConsumerStatefulWidget {
  List<AddressModel?> allAdress;
  bool? isEdit = false;
  CustomBottomSheet({super.key, required this.allAdress, this.isEdit});

  @override
  ConsumerState<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends ConsumerState<CustomBottomSheet> {
  double? latitude;

  double? longitude;

  LocationResult? locationResult;

  @override
  Widget build(BuildContext context) {
    onCurrentLocation() async {
      locationResult =
          await getLocationResult(latitude: latitude!, longitude: longitude!);
      if (mounted) {
        // setState(() {});
        var address = AddressModel(
            userId: supabaseClient.auth.currentUser!.id,
            address: locationResult!.completeAddress,
            lat: locationResult!.latitude!,
            long: locationResult!.longitude!);

        ref.read(pickedAddressProvider.notifier).state = address;
      }
    }

    final width = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, ref, _) {
      final selectedIndex = ref.watch(selectedIndexProvider);

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min, // Fit content
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Where’s your food going? 🍕",
                style: TextStyle(
                    fontSize: width * 0.05, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  // Check for location permission
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }

                  if (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever) {
                    // Handle permission denied case
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Location permission denied")),
                    );
                    return;
                  }

                  // Get the current location
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );

                    latitude = position.latitude;
                    longitude = position.longitude;

                    // Optionally, you can fetch the location details here
                    await onCurrentLocation();
                    Navigator.pop(context);
                  } catch (e) {
                    // Handle error (e.g., GPS not available)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error getting location: $e")),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: width * 0.04,
                    ),
                    Text(
                      "Choose current location",
                      style: TextStyle(
                          fontSize: width * 0.04, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.allAdress.length,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Radio<int>(
                                  fillColor: WidgetStateProperty.all(
                                      Colors.orange[900]),
                                  value:
                                      index, // each radio gets its index as value
                                  groupValue: selectedIndex, // selected one
                                  onChanged: (value) {
                                    // setStateModal(() {
                                    //   selectedAddressIndex = value!;
                                    // });
                                    ref
                                        .read(selectedIndexProvider.notifier)
                                        .state = value;

                                    ref
                                        .read(pickedAddressProvider.notifier)
                                        .state = widget.allAdress[value!];

                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.allAdress[index]?.label != null ||
                                          widget.allAdress[index]!.label!
                                              .isNotEmpty
                                      ? Text(
                                          widget.allAdress[index]?.label ?? '',
                                          style: TextStyle(
                                              overflow: TextOverflow.visible,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.04),
                                        )
                                      : const SizedBox(),
                                  InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                                selectedIndexProvider.notifier)
                                            .state = index;

                                        ref
                                            .read(
                                                pickedAddressProvider.notifier)
                                            .state = widget.allAdress[index];
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '${widget.allAdress[index]?.address} ',
                                        style: TextStyle(
                                            fontSize: width * 0.03,
                                            overflow: TextOverflow.visible,
                                            fontWeight: selectedIndex == index
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      )),
                                ],
                              ),
                            ]),
                        widget.isEdit!
                            ? IconButton(
                                onPressed: () {
                                  var locationresult = LocationResult(
                                      latitude: widget.allAdress[index]!.lat,
                                      longitude: widget.allAdress[index]!.long,
                                      completeAddress:
                                          widget.allAdress[index]!.address,
                                      placemark: null,
                                      locationName: '');
                                  Navigator.pushNamed(
                                      context, Confirmlocation.routename,
                                      arguments: {
                                        'locationResult': locationresult,
                                        'isEdit': true,
                                        'addressModel': widget.allAdress[index],
                                      });
                                },
                                icon: Icon(
                                  Icons.edit_location_alt,
                                  color: Colors.orange[900],
                                ))
                            : const SizedBox(),
                      ]);
                },
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 2,
                color: Colors.black26,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                      arguments: true, context, MyMap.routename),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: width * 0.03,
                      ),
                      Text("Add new address",
                          style: TextStyle(
                              fontSize: width * 0.04,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              // const Divider(
              //   color: Colors.black,
              //   height: 1,
              // ),
              // const SizedBox(height: 20),
              // InkWell(
              //   borderRadius: BorderRadius.circular(width * 0.14),
              //   onTap: () {},
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //         height: 50,
              //         width: double.maxFinite,
              //         padding: const EdgeInsets.all(10),
              //         decoration: BoxDecoration(
              //           boxShadow: const [
              //             BoxShadow(
              //                 spreadRadius: 2,
              //                 color: Color.fromRGBO(230, 81, 0, 1),
              //                 blurRadius: 2)
              //           ],
              //           color: Colors.orange[100],
              //           borderRadius: BorderRadius.circular(width * 0.14),
              //         ),
              //         child: Padding(
              //           padding:
              //               const EdgeInsets.symmetric(horizontal: 10),
              //           child: Center(
              //             child: Text("Confirm location",
              //                 style: TextStyle(
              //                     fontSize: width * 0.03,
              //                     color: Colors.orange[900],
              //                     overflow: TextOverflow.visible,
              //                     fontWeight: FontWeight.bold)),
              //           ),
              //         )),
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
