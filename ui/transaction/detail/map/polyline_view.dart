import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../config/ps_colors.dart';
import '../../../../provider/point/point_provider.dart';
import '../../../../viewobject/intersection.dart';

class PolylinePage extends StatefulWidget {
  const PolylinePage
      ({
    required this.pointProvider,
    required this.customerLatLng,
    required this.deliveryBoyLatLng
  });
  final PointProvider pointProvider;
  final LatLng customerLatLng;
  final LatLng deliveryBoyLatLng;

  @override
  _PolylinePageState createState() => _PolylinePageState();
}

List<LatLng> points = <LatLng>[];
LatLng? firstPointStringFormat;
LatLng? secPointStringFormat;
LatLng? thirdPointStringFormat;
LatLng? centerPointStringFormat;

class _PolylinePageState extends State<PolylinePage> {

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PointProvider>(
        builder: (BuildContext context, PointProvider provider, Widget? child) {

      if (
          widget.pointProvider.mainPoint.data != null) {
        points = <LatLng>[];
        if (widget.pointProvider.mainPoint.data!.trips!.isNotEmpty) {
          for (int c = 0;
              c <
                  widget.pointProvider.mainPoint.data!.trips![0].legList![0]
                      .stepList!.length;
              c++) {

            if (widget.pointProvider.mainPoint.data?.trips != null &&
                widget.pointProvider.mainPoint.data!.trips![0].legList != null &&
                widget.pointProvider.mainPoint.data!.trips![0].legList![0].stepList != null) {
              for (Intersection intersection in
              widget.pointProvider.mainPoint.data!.trips![0].legList![0].stepList![c].intersectionList!) {
                points.add(LatLng(
                    intersection.locationList![1],
                    intersection.locationList![0]
                )
                );
                //print(intersection.locationList);
              }
            }

          }
        }
        // }
        centerPointStringFormat = LatLng(
            widget
                .pointProvider
                .mainPoint
                .data!
                .trips![0]
                .legList![0]
                .stepList![widget.pointProvider.mainPoint.data!.trips![0]
                        .legList![0].stepList!.length ~/
                    2]
                .maneuver!
                .locationList![1],
            widget
                .pointProvider
                .mainPoint
                .data!
                .trips![0]
                .legList![0]
                .stepList![widget.pointProvider.mainPoint.data!.trips![0]
                        .legList![0].stepList!.length ~/
                    2]
                .maneuver!
                .locationList![0]);
      } else {
        points = <LatLng>[];
        points.add(widget.customerLatLng);
        centerPointStringFormat = widget.customerLatLng;
      }
      // Calculate the bounding box of the markers and polylines
      List<LatLng> bounds = [];
      for (LatLng point in points) {
        bounds.add(point);
      }
      bounds.add(widget.customerLatLng);
      bounds.add(widget.deliveryBoyLatLng);

          const double paddingPixels = 50;
          double paddingDegreesX = paddingPixels * (360 / (256 * (1 << 15)));
          double paddingDegreesY = paddingPixels * (180 / (256 * (1 << 15)));
          LatLngBounds paddedBounds = LatLngBounds.fromPoints(bounds);
          paddedBounds.extend(LatLng(paddedBounds.north + paddingDegreesY, paddedBounds.east + paddingDegreesX));
          paddedBounds.extend(LatLng(paddedBounds.south - paddingDegreesY, paddedBounds.west - paddingDegreesX));

          LatLng temp = widget.customerLatLng;
      final List<Marker> markers = [];

          return Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  bounds: paddedBounds,

                ),
                mapController: mapController,
                children: <Widget>[

                  TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const <String>['a', 'b', 'c']),
                  PolylineLayer(
                    polylines: <Polyline>[
                      Polyline(
                          points: points,
                          strokeWidth: 6.0,
                          color: Colors.blue),
                    ],
                  ),
                  MarkerLayer(
                      markers: <Marker>
                      [
                        Marker(
                          width: 50,
                          height: 50,
                          point: temp,
                          builder: (BuildContext context)
                          {
                            return Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.home,
                                  color: PsColors.discountColor,
                                ),
                                iconSize: 25,
                                onPressed: () {
                                  setState(() {
                                    mapController.move(mapController.center, mapController.zoom -1);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        Marker(
                          width: 50,
                          height: 50,
                          point: widget.deliveryBoyLatLng,
                          builder: (BuildContext context)
                          {
                            return Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.directions_car_filled_rounded,
                                  color: PsColors.discountColor,
                                ),
                                iconSize: 25,
                                onPressed: () {
                                  setState(() {
                                    temp = LatLng(53.626312,-1.782274);
                                    mapController.move(mapController.center, mapController.zoom +1);
                                  });
                                },
                              ),
                            );
                          },
                        )
                      ]
                  ),
                  Positioned(
                    bottom: 10, right: 10,
                    child:
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: PsColors.mainColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: PsColors.discountColor,
                            ),
                            iconSize: 25,
                            onPressed: () {
                              setState(() {
                                mapController.move(mapController.center, mapController.zoom + 1);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: PsColors.mainColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: PsColors.discountColor,
                            ),
                            iconSize: 25,
                            onPressed: () {
                              setState(() {
                                mapController.move(mapController.center, mapController.zoom - 1);
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
List<Marker> _markers = [
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(53.626312,-1.782274),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(53.626312,-1.782274),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(53.626312,-1.782274),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
];

class MovingMarker extends StatefulWidget {
  @override
  _MovingMarker createState() {
    return _MovingMarker();
  }
}

class _MovingMarker extends State<MovingMarker> {
  late Marker _marker;
  late Timer _timer;
  int _markerIndex = 0;

  @override
  void initState() {
    super.initState();
    _marker = _markers[_markerIndex];
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [_marker],
    );
  }
}
