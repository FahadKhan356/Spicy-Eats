import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spicy_eats/commons/map.dart';
import 'package:spicy_eats/features/Location/Widgets/ConfirmLocation.dart';
import 'package:spicy_eats/features/Location/Widgets/custommap.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Sqlight%20Database/onBoarding/services/OnBoardingLocalDatabase.dart';
import 'package:spicy_eats/main.dart';



// Enhanced CustomBottomSheet with professional UI
class CustomBottomSheet extends ConsumerStatefulWidget {
  final List<AddressModel?> allAdress;
  final bool? isEdit;
  final String? lastLocation;
   const CustomBottomSheet({super.key, required this.allAdress, required this.lastLocation, this.isEdit=false});

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
        var address = AddressModel(
            userId: supabaseClient.auth.currentUser!.id,
            address: locationResult!.completeAddress,
            lat: locationResult!.latitude!,
            long: locationResult!.longitude!);

        ref.read(pickedAddressProvider.notifier).state = address;
      }
    }

    final width = MediaQuery.of(context).size.width;
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.orange[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Location",
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Where should we deliver your order?",
                          style: TextStyle(
                            fontSize: width * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Current Location Button
              InkWell(
                onTap: () async {
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }

                  if (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Location permission denied"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );

                    latitude = position.latitude;
                    longitude = position.longitude;

                    await onCurrentLocation();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error getting location: $e"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[400]!,
                        Colors.grey[300]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Use Current Location",
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Quick & accurate delivery",
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Saved Addresses Section
              if (widget.allAdress.isNotEmpty) ...[
                Row(
                  children: [
                    Text(
                      "Saved Addresses",
                      style: TextStyle(
                        fontSize: width * 0.042,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${widget.allAdress.length}",
                        style: TextStyle(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Address List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.allAdress.length,
                  itemBuilder: (context, index) {
                    final isSelected =  selectedIndex!=null? selectedIndex == index : widget.lastLocation!=null? widget.lastLocation== widget.allAdress[index]!.address : false ;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange[50] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.orange[300]!
                              : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref.read(selectedIndexProvider.notifier).state =
                                index;
                            ref.read(pickedAddressProvider.notifier).state =
                                widget.allAdress[index];
                                LocationLocalDatabase.instance.setLocationWithFlag('LocationData', false, widget.allAdress[index]!.address!);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Radio Button
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.orange[700]!
                                          : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? Colors.orange[700]
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),

                                // Address Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.allAdress[index]?.label !=
                                              null &&
                                          widget.allAdress[index]!.label!
                                              .isNotEmpty)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 6),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.orange[100]
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getIconForLabel(
                                                    widget.allAdress[index]
                                                            ?.label ??
                                                        ''),
                                                size: 12,
                                                color: isSelected
                                                    ? Colors.orange[900]
                                                    : Colors.grey[700],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                widget.allAdress[index]
                                                        ?.label ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? Colors.orange[900]
                                                      : Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Text(
                                        widget.allAdress[index]?.address ?? '',
                                        style: TextStyle(
                                          fontSize: width * 0.035,
                                          color: isSelected
                                              ? Colors.black87
                                              : Colors.grey[700],
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // Edit Button
                                if (widget.isEdit!)
                                  IconButton(
                                    onPressed: () {
                                      var locationresult = LocationResult(
                                        latitude: widget.allAdress[index]!.lat,
                                        longitude:
                                            widget.allAdress[index]!.long,
                                        completeAddress:
                                            widget.allAdress[index]!.address,
                                        placemark: null,//widget.allAdress[index]!.placemark,
                                        locationName: widget.allAdress[index]!.address,
                                     
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        Confirmlocation.routename,
                                        arguments: {
                                          'locationResult': locationresult,
                                          'isEdit': true,
                                          'addressModel':
                                              widget.allAdress[index],
                                        },
                                      );
                                    debugPrint('checking data coming from bottomsheet : completeaddresas : ${locationresult.completeAddress} locationname ${widget.allAdress[index]!.address}');
                                 
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.orange[700],
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 16),

              // Add New Address Button
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  MyMap.routename,
                  arguments: true,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.orange[300]!,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Add New Address",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'office':
        return Icons.business;
      case 'other':
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }
}