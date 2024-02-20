import 'dart:async';
import 'dart:ui';

import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/widgets/custom_window.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController {
  bool userLocation = true;
  late CameraPosition cameraPosition;
  final CarWashController _carWashController = CarWashController();
  List<Marker> markers = [];
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  bool displayMarkers = true;

  final Completer<GoogleMapController> controller = Completer();

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
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        Position position = await getUserCurrentLocation();
        return CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 12.5,
        );
      }
    }
    return const CameraPosition(
      target: LatLng(45.7494, 21.2272),
      zoom: 12.5,
    );
  }

  Future<void> checkLocationPermission(
      {required String location,
      required Function() displayInfo,
      required BuildContext context}) async {
    await Geolocator.requestPermission();
    if ((await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) ||
        (await Geolocator.checkPermission() == LocationPermission.denied)) {
      userLocation = false;
    } else {
      userLocation = true;
    }
    if (location == '') {
      if (_carWashController.carWashes.isEmpty) {
        await _carWashController.fetchCarWashesFromFirebase(displayInfo: () {});
      }
      await setCoordonates();
    } else {
      displayMarkers = false;
      var address = await Geocoder.local.findAddressesFromQuery(location);
      final Uint8List markerIcon =
          await getBytesFromAssets('assets/images/carwash_mark.png', 100);
      markers.add(Marker(
        markerId: const MarkerId('destination'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: LatLng(address.first.coordinates.latitude!,
            address.first.coordinates.longitude!),
      ));
    }
    getUserLocation().then((position) {
      cameraPosition = position;
      displayInfo();
    });
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future setCoordonates() async {
    var i = 1;

    final Uint8List markerIcon =
        await getBytesFromAssets('assets/images/carwash_mark.png', 100);
    for (var carwash in _carWashController.carWashes.entries) {
      var address =
          await Geocoder.local.findAddressesFromQuery(carwash.value.address);
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: LatLng(address.first.coordinates.latitude!,
              address.first.coordinates.longitude!),
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              CustomWindow(
                carwash: carwash,
                isManager: _carWashController.authController.isManager,
              ),
              LatLng(address.first.coordinates.latitude!,
                  address.first.coordinates.longitude!),
            );
          }));
      i++;
    }
  }
}
