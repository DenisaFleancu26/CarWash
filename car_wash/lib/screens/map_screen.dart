import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/map_controller.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _mapController.checkLocationPermission(
        location: widget.address ?? '',
        displayInfo: () => setState(() => display = false),
        context: context);
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
                      _mapController.customInfoWindowController
                          .googleMapController = controller;
                    },
                    onCameraMove: (position) {
                      _mapController.customInfoWindowController.onCameraMove!();
                    },
                    onTap: (position) {
                      _mapController
                          .customInfoWindowController.hideInfoWindow!();
                    },
                  ),
            CustomInfoWindow(
                controller: _mapController.customInfoWindowController,
                height: 150,
                width: 300),
          ],
        ));
  }
}
