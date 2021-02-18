import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jood/disposable_widget.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:jood/pages/homeless_card_item.dart';
import 'package:jood/services/homeless_crud.dart';
import 'package:jood/size_config.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with DisposableWidget {
  Completer<GoogleMapController> _controller = Completer();

  // casablanca morocco
  final CameraPosition _defaultView = CameraPosition(
    target: LatLng(33.60354450405575, -7.6402076706290245),
    zoom: 12.129960060119629,
  );

  List<Marker> markers = [];

  @override
  void dispose() {
    super.dispose();
    cancelSubscriptions();
  }

  @override
  void initState() {
    super.initState();
  }

  addMarkers() {
    // Database().markers.listen((List<LatLong> e) {
    //   markers.addAll(e);
    //   if (!mounted) return;
    //   setState(() {});
    // }).canceledBy(this);
  }

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers2 = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  void _onMarkerTapped(MarkerId markerId, HomelessManifest homeless) {
    final Marker tappedMarker = markers2[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers2.containsKey(selectedMarker)) {
          final Marker resetOld =
              markers2[selectedMarker].copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers2[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers2[markerId] = newMarker;
      });

      // show bottom sheet
      _settingModalBottomSheet(homeless);
    }
  }

  void _settingModalBottomSheet(HomelessManifest homeless) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.screenHeight * .9,
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12, bottom: 10),
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: HomelessCardItem(
                            homeless: homeless,
                            showShadow: false,
                            initialExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _attachMarkers() {
    Database().homelessManifestsStream().listen((List<HomelessManifest> list) {
      for (var e in list) {
        final String markerIdVal = e.id;
        _markerIdCounter++;
        final MarkerId markerId = MarkerId(markerIdVal);

        final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(e.gpsCoordinates.latitude, e.gpsCoordinates.longitude),
          infoWindow: InfoWindow(title: "Requirements", snippet: e.shortDescription()),
          onTap: () {
            _onMarkerTapped(markerId, e);
          },
        );

        markers2[markerId] = marker;
      }

      if (!mounted) return;
      setState(() {});
    }).canceledBy(this);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // markers.add(Marker(markerId: MarkerId("aç&"), position: LatLng(31.7858381, -9.3939904)));
    return GoogleMap(
      mapToolbarEnabled: false,
      minMaxZoomPreference: MinMaxZoomPreference(6.3523268699646, 18.3396053314209),
      myLocationEnabled: true,
      // onTap: (dd) => addMarkers(),
      // onTap: (dd) => _add(),
      zoomControlsEnabled: false,
      initialCameraPosition: _defaultView,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _attachMarkers();
      },
      compassEnabled: false,
      // markers: Set<Marker>.of(markers),
      markers: Set<Marker>.of(markers2.values),
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
