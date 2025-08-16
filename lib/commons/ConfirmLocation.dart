import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spicy_eats/commons/custommap.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class Confirmlocation extends StatefulWidget {
  static const String routename = "/conformLocation";

  final LocationResult? locationResult;
  Confirmlocation({super.key, required this.locationResult});

  @override
  State<Confirmlocation> createState() => _ConfirmlocationState();
}

class _ConfirmlocationState extends State<Confirmlocation> {
  double? _latitude;
  double? _longitude;
  TextEditingController streetController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  Future<LocationResult> getLocationResult(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return LocationResult(
            latitude: latitude,
            longitude: longitude,
            locationName: getLocationName(placemark: placemarks.first),
            completeAddress: getCompleteAdress(placemark: placemarks.first),
            placemark: placemarks.first);
      } else {
        return LocationResult(
            latitude: latitude,
            longitude: longitude,
            completeAddress: null,
            placemark: null,
            locationName: null);
      }
    } catch (e) {
      return LocationResult(
          latitude: latitude,
          longitude: longitude,
          completeAddress: null,
          placemark: null,
          locationName: null);
    }
  }

  LocationResult? _locationResult;
  _getLocationResult() async {
    _locationResult =
        await getLocationResult(latitude: _latitude!, longitude: _longitude!);
    if (mounted) {
      setState(() {});
    }
  }

  MapType _mapType = MapType.normal;
  bool _move = false;

  @override
  void dispose() {
    floorController.dispose();
    streetController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _latitude = -6.984072660841485;
    _longitude = 110.40950678599624;
    // TODO: implement initState
    super.initState();
  }

  Timer? _timer;
  final MapController _controller = MapController();
  Widget viewLocationName() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _locationResult?.locationName ??
                        "Name not found. Tap close by.",
                  ),
                  Text(
                    _locationResult?.completeAddress ?? "-",
                  ),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.4,
              width: double.maxFinite,
              child: FlutterMap(
                mapController: _controller,
                options: MapOptions(
                  initialCenter: LatLng(
                      widget.locationResult?.latitude ?? _latitude!,
                      widget.locationResult?.longitude! ?? _longitude!),
                  initialZoom: 16,
                  maxZoom: 18,
                  onMapReady: () {
                    _controller.mapEventStream.listen((evt) async {
                      _timer?.cancel();
                      if (!_move) {
                        _timer = Timer(const Duration(milliseconds: 200), () {
                          _latitude = evt.camera.center.latitude;
                          _longitude = evt.camera.center.longitude;
                          _getLocationResult();
                        });
                      } else {
                        _move = false;
                      }

                      setState(() {});
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: _mapType == MapType.normal
                        ? "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=7b2RKYzYW5lBAVIkQzK3"
                        : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.jpg',
                    userAgentPackageName: 'com.example.app',
                  ),
                  Stack(
                    children: [
                      Center(
                          child: Icon(Icons.person_pin,
                              size: size.width * 0.1, color: Colors.black87)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Fit content
                    children: [
                      Text(
                        "Add details to help us find you",
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_locationResult?.locationName}",
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${_locationResult?.placemark!.locality}",
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: streetController,
                        decoration: InputDecoration(
                          suffixIcon: TextButton(
                            child: const Text('x'),
                            onPressed: () {
                              streetController.text = '';
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          label: const Text('Street Name/Number'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: floorController,
                        decoration: InputDecoration(
                          suffixIcon: TextButton(
                            child: const Text('x'),
                            onPressed: () {
                              floorController.text = '';
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          label: const Text('Floor'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Add a label",
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: size.height * 0.2,
                        width: double.maxFinite,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: labels.length,
                            itemBuilder: (context, index) => labels[index]),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(size.width * 0.14),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: size.height * 0.07,
                              width: double.maxFinite,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      color: Color.fromRGBO(230, 81, 0, 1),
                                      blurRadius: 2)
                                ],
                                color: Colors.orange[100],
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.14),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text("Confirm location",
                                      style: TextStyle(
                                          color: Colors.orange[900],
                                          overflow: TextOverflow.visible,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
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
    );
  }
}

List<label> labels = [
  const label(icon: Icons.home_outlined, title: "Home"),
  const label(icon: Icons.work_history_outlined, title: "Work"),
  const label(icon: Icons.favorite_border_outlined, title: "Partner"),
  const label(icon: Icons.more_horiz, title: "Others"),
];

class label extends StatelessWidget {
  final IconData icon;
  final String title;
  const label({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: size.width * 0.13,
            width: size.width * 0.13,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26, width: 1),
                borderRadius: BorderRadius.circular(size.width * 0.13 / 2)),
            child: Icon(
              icon,
              size: size.width * 0.06,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
