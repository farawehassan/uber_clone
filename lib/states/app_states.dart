import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberapp/networking/google_maps_request.dart';

class AppState with ChangeNotifier{

  AppState(){
    _getUserLocation();
   // _loadingInitialPosition();
  }

  GoogleMapController _mapController;
  Geolocator _geolocator;

  GoogleMapServices _googleMapServices = GoogleMapServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  bool locationServiceActive = true;
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;

  /*final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};*/

  GoogleMapController get mapController => _mapController;
  Geolocator get geolocator => _geolocator;
  GoogleMapServices get googleMapServices => _googleMapServices;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  /*Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  Set<Circle> get circles => _circles;*/

  // Google map on created
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // Google map on camera move
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    //_setCircle();
    notifyListeners();
  }

 /* void updateLocation(){
    geolocator
      .getPositionStream(LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000))
        .listen((position) {
          _lastPosition = LatLng(position.latitude, position.longitude);
         // Do something here
    });
  }*/

  // Setting circles on your initial position
  /*void _setCircle(){
    _circles.add(
      Circle(
        circleId: CircleId("00"),
        center: initialPosition,
        radius: 25,
        zIndex: -5,
        strokeWidth: 1,
        strokeColor: Colors.blue[100],
        fillColor: Colors.blue[100],
      )
    );
  }*/

  void _getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    final result = await location.getLocation();
    final coordinates = new Coordinates(result.latitude, result.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    _initialPosition = LatLng(result.latitude, result.longitude);
    locationController.text = addresses.first.addressLine;
    notifyListeners();
  }

  // This method gets user's current location
  /*void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(position);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    _initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = addresses.first.addressLine;
    print(locationController.text);
    notifyListeners();
  }*/

  void _loadingInitialPosition() async {
    if(_initialPosition == null){
      await Future.delayed(Duration(seconds: 3)).then((value) {
        if(_initialPosition == null){
          locationServiceActive = false;
          notifyListeners();
        }
      });
    }
  }

}


