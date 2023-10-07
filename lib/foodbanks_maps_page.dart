import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:no_more_waste/dto/foodbank.dart';

class FoodbanksMapsScreen extends StatefulWidget {

  const FoodbanksMapsScreen({Key? key, required this.foodbanks}) : super(key: key);

  final List<Foodbank> foodbanks;

  @override
  _FoodbanksMapsScreen createState() => _FoodbanksMapsScreen();
}

class _FoodbanksMapsScreen extends State<FoodbanksMapsScreen> {

  LatLng _initialcameraposition = LatLng(20.5937, 20.9629);
  late GoogleMapController _controller;
  Location _location = Location();
  Set<Marker> _markers = {};
  bool _initialCameraMovementDone = false;

  @override
  void initState() {
    super.initState();

    initMarkers();
  }

  void initMarkers() {
    int i = 0;
    widget.foodbanks.forEach((element) {
        _markers.add(
            Marker(
                markerId: MarkerId('$i'),
                position: LatLng(element.latitude, element.longitude)
            )
        );
    });
    i++;
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      if (!_initialCameraMovementDone) {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
          ),
        );
      }
      _initialCameraMovementDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Near Foodbanks', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent, // make this transparent
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black, // set color of back button
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              markers: _markers,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}