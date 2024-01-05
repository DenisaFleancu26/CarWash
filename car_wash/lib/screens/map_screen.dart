import 'dart:async';
import 'dart:ui' as ui;

import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/models/review.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/auth.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int index = 0;
  final User? user = Auth().currentUser;
  bool userLocation = true;

  late CameraPosition _cameraPosition;
  final Completer<GoogleMapController> _controller = Completer();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final List<Marker> _marker = [];

  late BitmapDescriptor customIcon;

  bool display = true;
  String mapTheme = '';
  List<CarWash> carWashes = [];

  @override
  void initState() {
    checkLocationPermission();
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

  Future<Position> getUserCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error getting location: $e");
      return Future.error("Error getting location");
    }
  }

  Future<CameraPosition> getUserLocation() async {
    if (userLocation) {
      Position position = await getUserCurrentLocation();
      return CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );
    } else {
      return const CameraPosition(
        target: LatLng(45.7494, 21.2272),
        zoom: 13,
      );
    }
  }

  Future<List<Marker>> setCoordonates() async {
    var i = 1;
    for (var carwash in carWashes) {
      var address =
          await Geocoder.local.findAddressesFromQuery(carwash.address);

      final Uint8List markerIcon =
          await getBytesFromAssets('assets/images/carwash_mark.png', 100);
      _marker.add(Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: LatLng(address.first.coordinates.latitude!,
              address.first.coordinates.longitude!),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: ui.Color.fromARGB(218, 122, 122, 122),
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
                        SizedBox(
                          width: 140,
                          child: Text(
                            carwash.name,
                            style: TextStyle(
                              color:
                                  const ui.Color.fromARGB(223, 255, 255, 255),
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
                        RatingBar.builder(
                          initialRating: carwash.averageRating(
                              carwash.nrRatings, carwash.totalRatings),
                          itemSize: 20.0,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                        ),
                        SizedBox(
                          width: 140,
                          child: Text(
                            carwash.address,
                            style: TextStyle(
                              color:
                                  const ui.Color.fromARGB(198, 255, 255, 255),
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
                            onTap: () => {},
                            child: const SizedBox(
                              height: 20,
                              width: 70,
                              child: Center(
                                  child: Text(
                                "View more ➔",
                                style: TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                    color:
                                        ui.Color.fromARGB(255, 222, 222, 222)),
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
    return _marker;
  }

  Future<void> checkLocationPermission() async {
    await Geolocator.requestPermission();
    if ((await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) ||
        (await Geolocator.checkPermission() == LocationPermission.denied)) {
      userLocation = false;
    } else {
      userLocation = true;
    }
    await fetchCarWashesFromFirebase();
    await setCoordonates();
    getUserLocation().then((cameraPosition) {
      setState(() {
        _cameraPosition = cameraPosition;
        display = false;
      });
    });
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<List<CarWash>> fetchCarWashesFromFirebase() async {
    final managers =
        await FirebaseFirestore.instance.collection('Managers').get();

    if (managers.docs.isNotEmpty) {
      for (var manager in managers.docs) {
        var managerCarWashes = await FirebaseFirestore.instance
            .collection('Managers')
            .doc(manager.id)
            .collection('car-wash')
            .get();
        for (var element in managerCarWashes.docs) {
          List<Review> reviews = await getReviews(manager.id, element.id);
          CarWash carwash = CarWash(
            name: element['name'],
            hours: element['hours'],
            image: element['image'] ?? '',
            address: element['address'],
            facilities: element['facilities'],
            phone: element['phone'],
            smallVehicleSeats: element['small-vehicle'],
            bigVehicleSeats: element['big-vehicle'],
            price: (element['price']).toDouble(),
            nrRatings: element['nrRatings'],
            totalRatings: element['totalRatings'],
            reviews: reviews,
          );
          carWashes.add(carwash);
        }
      }
    }
    return carWashes;
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                break;
              case 2:
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                } else {
                  Navigator.pushReplacement(
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
                    initialCameraPosition: _cameraPosition,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: false,
                    markers: Set<Marker>.of(_marker),
                    padding: const EdgeInsets.only(bottom: 60, top: 30),
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(mapTheme);
                      _controller.complete(controller);
                      _customInfoWindowController.googleMapController =
                          controller;
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    onTap: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                  ),
            CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 150,
                width: 300),
          ],
        ));
  }
}
