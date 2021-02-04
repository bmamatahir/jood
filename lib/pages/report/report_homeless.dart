import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/disposable_widget.dart';
import 'package:jood/pages/report/form.dart';
import 'package:jood/pages/report/form_group_header.dart';
import 'package:jood/pages/report/state.dart';
import 'package:jood/report_button.dart';

class ReportHomeless extends HookWidget with DisposableWidget {
  static String routeName = "/report_homeless";
  Stream<Position> positionUpdates;

  bool _equalPositions(p1, p2) => p1.latitude == p2.latitude && p1.longitude == p2.longitude;

  @override
  Widget build(BuildContext context) {
    useProvider(formStateProvider.state);
    useEffect(
      () {
        positionUpdates = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high);

        positionUpdates.distinct(_equalPositions).listen((p) {
          context.read(formStateProvider).setGPSCoordinates(p.latitude, p.longitude);
        }).canceledBy(this);

        return () {
          cancelSubscriptions();
          _mapController.dispose();
        };
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Report homeless'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'better well being for the candidate depending on data you provides us.',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                SizedBox(height: 20),
                ReportForm(),
                // location preview
                FormGroupHeader('Location Preview'),
                locationPreview(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: ReportButton(
                      onPressed: () async {
                        await takeSnapshot(context);
                        context.read(formStateProvider).submit(() {
                          Navigator.pop(context);
                          BotToast.showText(text: "Take care of yourself 😘");
                        }, error: (error) {
                          BotToast.showText(text: error);
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GoogleMapController _mapController;

  takeSnapshot(BuildContext context) async {
    final imageBytes = await _mapController?.takeSnapshot();
    await context.read(formStateProvider).setMapScreenshotData(imageBytes);
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  locationPreview() {
    return StreamBuilder<Position>(
        stream: positionUpdates,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Position p = snapshot.hasData ? snapshot.data : null;
          return p == null
              ? Text("...")
              : SizedBox(
                  height: 180,
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    // minMaxZoomPreference: MinMaxZoomPreference(),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    onMapCreated: onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(p.latitude, p.longitude), zoom: 15),
                  ),
                );
        });
  }
}
