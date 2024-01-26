import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/map_controller.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: CustomNavigationBar(index: index),
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
