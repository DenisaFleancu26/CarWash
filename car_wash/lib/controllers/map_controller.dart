import 'dart:async';
import 'dart:ui';

import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController {
  bool userLocation = true;
  late CameraPosition cameraPosition;
  List<CarWash> carWashes = [];
  final CarWashController _carWashController = CarWashController();
  List<Marker> markers = [];

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

  Future<void> checkLocationPermission({
    required String location,
    required Function() displayInfo,
  }) async {
    await Geolocator.requestPermission();
    if ((await Geolocator.checkPermission() ==
            LocationPermission.deniedForever) ||
        (await Geolocator.checkPermission() == LocationPermission.denied)) {
      userLocation = false;
    } else {
      userLocation = true;
    }
    if (location == '') {
      await fetchCarWashesFromFirebase();
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
          List<Review> reviews = await _carWashController.getReviews(
              manager: manager.id, carwash: element.id);
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
}
