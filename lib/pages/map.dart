import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  // casablanca morocco
  final CameraPosition _defaultView = CameraPosition(
    target: LatLng(33.60354450405575, -7.6402076706290245),
    zoom: 12.129960060119629,
  );

  @override
  Widget build(BuildContext context) {
    var markers = Set<Marker>();
    // markers.add(Marker(markerId: MarkerId("aç&"), position: LatLng(31.7858381, -9.3939904)));
    return GoogleMap(
      mapToolbarEnabled: false,
      minMaxZoomPreference: MinMaxZoomPreference(6.3523268699646, 18.3396053314209),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: _defaultView,
      // onTap: (jj) => print('>>> ${jj}'),
      // onTap: (jj) => gzl(),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      compassEnabled: false,
      markers: markers,
    );
  }

  gzl() async {
    final GoogleMapController controller = await _controller.future;
    print('>>> ${await controller.getZoomLevel()}');
  }

  Future<void> _currentPosition() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // if (position != null) {
    //   positionCompleter.complete(position);
    //   print(">> ${position}");
    // }

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 20)));
  }
}
