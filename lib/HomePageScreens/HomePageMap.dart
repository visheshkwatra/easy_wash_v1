import 'dart:core';
import 'package:easy_wash_v1/HomePageScreens/CarTypeSelection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'appointment_creation.dart';

LatLng? _selectedLocation;
class HomePageMap extends StatefulWidget {
  final bool isBikeSelected;
  final int selectedCarType;
  HomePageMap({required this.isBikeSelected,required this.selectedCarType});
  @override
  _HomePageMapState createState() => _HomePageMapState();
}

class _HomePageMapState extends State<HomePageMap> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  LatLng? _pickedLocation;
  bool _isPickedLocationCurrent = true;
  final BitmapDescriptor greenMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  @override
  void initState() {
    super.initState();
    _getLocationAndInitializeMap();
  }

  Future<void> _getLocationAndInitializeMap() async {
    final location = Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
        _pickedLocation = LatLng(
          currentLocation.latitude ?? 0.0,
          currentLocation.longitude ?? 0.0,
        );
      });
      _initializeMap();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _initializeMap() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
    _initializeMap();
  }

  void _onMapTap(LatLng tappedLocation) {
    setState(() {
      if (_isPickedLocationCurrent) {
        _pickedLocation = tappedLocation;
      } else {
        _pickedLocation = LatLng(
          _currentLocation?.latitude ?? 0.0,
          _currentLocation?.longitude ?? 0.0,
        );
      }
      _isPickedLocationCurrent = !_isPickedLocationCurrent;
    });

    // Check if the tapped marker is the "Current Location" marker
    if (_isPickedLocationCurrent) {
      // Set picked location to the current location
      _pickedLocation = LatLng(
        _currentLocation?.latitude ?? 0.0,
        _currentLocation?.longitude ?? 0.0,
      );
    }
    _selectedLocation=_pickedLocation;
    // Show a toast message with the updated picked location
    Fluttertoast.showToast(
      msg: 'Picked Location: ${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }

  void _confirmLocation() {
    // Handle storing the picked location
    if (_pickedLocation != null) {
      // Show a toast message
      Fluttertoast.showToast(
        msg: 'Picked Location: ${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {

            return AppointmentCreationScreen(
              selectedLocation: _pickedLocation,isBikeSelected: widget.isBikeSelected ,carTypeSelected: carTypeSelected, // Pass the selected location
            );
          },
        ),
      );
    }
  }

  void _moveToCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      // If tapping on the current location icon, set picked location as current location
      if (!_isPickedLocationCurrent) {
        _pickedLocation = LatLng(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
        );
        setState(() {
          _isPickedLocationCurrent = true;
        });
      }
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
        ),
      );
    }
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      onTap: _onMapTap,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentLocation?.latitude ?? 0.0,
          _currentLocation?.longitude ?? 0.0,
        ),
        zoom: 15.0,
      ),
      markers: {
        if (_currentLocation != null)
          Marker(
            markerId: MarkerId('Current Location'),
            position: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            icon: greenMarkerIcon,
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        if (_pickedLocation != null)
          Marker(
            markerId: MarkerId('Selected Location'),
            position: _pickedLocation!,
            infoWindow: InfoWindow(title: 'Picked Location'),
          ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select pickup location'),
      ),
      body: _buildMap(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 26, bottom: 18), // Adjust the padding as needed
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: _confirmLocation,
                child: Icon(Icons.check),
              ),
              SizedBox(height: 16),
              FloatingActionButton(
                onPressed: _moveToCurrentLocation,
                child: Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );

  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePageMap(isBikeSelected: false, selectedCarType: carTypeSelected,),
  ));
}
