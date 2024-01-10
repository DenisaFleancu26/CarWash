import 'dart:typed_data';

import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/map_controller.dart';
import 'package:car_wash/screens/carwash_screen.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String? address;
  const MapScreen({Key? key, this.address}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int index = 0;
  final User? user = AuthController().currentUser;
  final MapController _mapController = MapController();
  bool display = true;
  String mapTheme = '';
  List<Marker> markers = [];
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    changeMarks();
    DefaultAssetBundle.of(context)
        .loadString('assets/mapTheme/night_theme.json')
        .then((value) {
      mapTheme = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final items = const <Widget>[
    Icon(Icons.map_rounded, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.account_circle, size: 30),
  ];

  void changeMarks() async {
    await _mapController.checkLocationPermission(
        location: widget.address ?? '',
        displayInfo: () => setState(() => display = false));
    print(_mapController.displayMarkers);
    if (_mapController.displayMarkers == true) {
      await setCoordonates();
      setState(() {
        _mapController.markers = markers;
      });
    }
  }

  Future<List<Marker>> setCoordonates() async {
    var i = 1;
    for (var carwash in _mapController.carWashes) {
      var address =
          await Geocoder.local.findAddressesFromQuery(carwash.address);

      final Uint8List markerIcon = await _mapController.getBytesFromAssets(
          'assets/images/carwash_mark.png', 100);
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: LatLng(address.first.coordinates.latitude!,
              address.first.coordinates.longitude!),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Color.fromARGB(218, 122, 122, 122),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        image: DecorationImage(
                          image:
                              FirebaseImageProvider(FirebaseUrl(carwash.image)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating: carwash.averageRating(
                                    carwash.nrRatings, carwash.totalRatings),
                                itemSize: 20.0,
                                unratedColor:
                                    const Color.fromARGB(195, 255, 255, 255),
                                itemBuilder: (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                                onRatingUpdate: (rating) {},
                                ignoreGestures: true,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${carwash.nrRatings})',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(195, 190, 190, 190),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 30,
                                ),
                              ),
                            ]),
                        SizedBox(
                          width: 140,
                          child: Text(
                            carwash.name,
                            style: TextStyle(
                              color: const Color.fromARGB(223, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              shadows: [
                                Shadow(
                                  offset: const Offset(3.0, 3.0),
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.30),
                                ),
                              ],
                            ),
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: Text(
                            carwash.address,
                            style: TextStyle(
                              color: const Color.fromARGB(198, 255, 255, 255),
                              fontSize: 8,
                              shadows: [
                                Shadow(
                                  offset: const Offset(3.0, 3.0),
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.30),
                                ),
                              ],
                            ),
                            softWrap: true,
                            maxLines: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CarWashScreen(carwash: carwash)),
                              ),
                            },
                            child: const SizedBox(
                              height: 20,
                              width: 70,
                              child: Center(
                                  child: Text(
                                "View more ➔",
                                style: TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                    color: Color.fromARGB(255, 222, 222, 222)),
                              )),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              LatLng(
                address.first.coordinates.latitude!,
                address.first.coordinates.longitude!,
              ),
            );
          }));
      i++;
    }
    print(markers);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: const Color.fromARGB(255, 255, 255, 255),
          animationDuration: const Duration(milliseconds: 300),
          height: 45,
          index: index,
          items: items,
          onTap: (index) => setState(() {
            this.index = index;
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                break;
              case 2:
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }
                break;
            }
          }),
        ),
        body: Stack(
          children: [
            display
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          color: const Color.fromARGB(255, 18, 18, 18),
                          child: const CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        )
                      ],
                    ),
                  )
                : GoogleMap(
                    initialCameraPosition: _mapController.cameraPosition,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: false,
                    markers: Set<Marker>.of(_mapController.markers),
                    padding: const EdgeInsets.only(bottom: 60, top: 30),
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(mapTheme);
                      _mapController.controller.complete(controller);
                      customInfoWindowController.googleMapController =
                          controller;
                    },
                    onCameraMove: (position) {
                      customInfoWindowController.onCameraMove!();
                    },
                    onTap: (position) {
                      customInfoWindowController.hideInfoWindow!();
                    },
                  ),
            CustomInfoWindow(
                controller: customInfoWindowController,
                height: 150,
                width: 300),
          ],
        ));
  }
}
