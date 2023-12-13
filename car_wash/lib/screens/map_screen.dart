import 'dart:async';

import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  bool display = true;
  String mapTheme = '';

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

  Future<void> checkLocationPermission() async {
    await Geolocator.requestPermission();
    if ((await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) ||
        (await Geolocator.checkPermission() == LocationPermission.denied)) {
      userLocation = false;
    } else {
      userLocation = true;
    }
    getUserLocation().then((cameraPosition) {
      setState(() {
        _cameraPosition = cameraPosition;
        display = false;
      });
    });
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
                    padding: const EdgeInsets.only(bottom: 60, top: 30),
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(mapTheme);
                      _controller.complete(controller);
                    },
                  ),
          ],
        ));
  }
}
