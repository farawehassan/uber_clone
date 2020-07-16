import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uberapp/networking/google_maps_request.dart';
import 'package:uberapp/ui/home.dart';
import 'package:uberapp/utils/maps_apiKey.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetDestination extends StatefulWidget {

  static const id = "set_destination_page";

  final LatLng position;

  SetDestination({@required this.position});

  @override
  _SetDestinationState createState() => _SetDestinationState();
}

class _SetDestinationState extends State<SetDestination> {

  GoogleMapServices _googleMapServices = GoogleMapServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  var mapDetails = {};

  @override
  void initState() {
    super.initState();
    _initialPosition = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                _inputDetails(),
                _addDetails(),
                _showList(),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _inputDetails(){
    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.popAndPushNamed(context, MyHomePage.id);
                        },
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Text(
                            'For Me',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: new BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 1.0,
                            height: 50,
                            color: Colors.grey[400],
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: new BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 6.0, right: 37.0),
                                    height: 35.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.grey[100],
                                    ),
                                    child: TextField(
                                      onTap: () async {
                                      },
                                      cursorColor: Colors.blue[700],
                                      controller: locationController,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                      textInputAction: TextInputAction.go,
                                      onSubmitted: (value) {
                                        //appState.sendRequest(value);
                                      },
                                      decoration: InputDecoration(
                                          hintText: '14, Leigh Street, Ojuelegba',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[800],
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 15.0)
                                      ),
                                    ),
                                  ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 6.0),
                                  height: 35.0,
                                  //width: 515,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.grey[200],
                                  ),
                                  child: TextField(
                                    onTap: () async {
                                      Prediction p = await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: Constants.ApiKey,
                                        mode: Mode.overlay,
                                        language: 'en',
                                        components: [
                                          Component(Component.country, 'ng'),
                                        ]
                                      );
                                      if(p != null){
                                        setState(() {
                                          destinationController.text = p.description;
                                        });
                                      }
                                    },
                                    cursorColor: Colors.blue[700],
                                    controller: destinationController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                    textInputAction: TextInputAction.go,
                                    onSubmitted: (value) {
                                      sendRequest(value);
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Where to?',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 11.0)
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, right: 2.0, left: 6.0, bottom: 2.0),
                                child: Icon(
                                  FontAwesomeIcons.plus,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addDetails(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: new BoxDecoration(
                  color: Colors.blue[800],
                  shape: BoxShape.circle,
                ),
                child:Icon(
                  Icons.home,
                  size: 20,
                  color: Colors.grey[200],
                ),
              ),
              SizedBox(width: 15.0,),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Add Home',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[200],
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: new BoxDecoration(
                  color: Colors.blue[800],
                  shape: BoxShape.circle,
                ),
                child:Icon(
                  Icons.work,
                  size: 20,
                  color: Colors.grey[200],
                ),
              ),
              SizedBox(width: 15.0,),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Add Work',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[200],
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: new BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child:Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Saved Places',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:Icon(
                  FontAwesomeIcons.angleRight,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: double.infinity,
            height: 5.0,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Widget _showList(){
    return Column(
      children: [
        _listLayout(Icons.pin_drop, 'Set Location on Map'),
        _lineBreak(),
        _listLayout(Icons.skip_next, 'Enter destination later'),
      ],
    );
  }

  Widget _listLayout(IconData iconData, String details){
    return Container(
      padding: EdgeInsets.all(12.0),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: new BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child:Icon(
              iconData,
              size: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 15.0,),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '$details',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineBreak(){
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[200],
      ),
    );
  }



  // This method add markers on the map
  void _addMarker(LatLng location, String address) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(
          title: '$address',
          snippet: 'Your destination',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      mapDetails['Markers'] = markers;
      mapDetails['Destination'] = location;
    });
  }

  // This method sends requests to the google map service
  // when the destination is set
  void sendRequest(String intendedLocation) async {
    List<Placemark> placeMark = await Geolocator().placemarkFromAddress(intendedLocation);
    double l1 = placeMark[0].position.latitude;
    double l2 = placeMark[0].position.longitude;
    LatLng destination = LatLng(l1, l2);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapServices.getRouteFromCordinates(_initialPosition, destination);
    _createRoutes(route);
  }

  // This method create routes from a given polyline string
  void _createRoutes(String encodedPoly){
    setState(() {
      polylines.add(Polyline(polylineId: PolylineId(_lastPosition.toString()),
          width: 5,
          points: _convertToLatLng(_decodePoly(encodedPoly)),
          color: Colors.black)
      );
      mapDetails['Polyline'] = polylines;
    });
    Navigator.pop(context, mapDetails);
  }

  // This method converts list of polylines double to LatLng
  List<LatLng> _convertToLatLng (List points){
    List<LatLng> result = <LatLng>[];
    for(int i = 0; i < points.length; i++){
      if(i % 2 != 0){
        result.add(LatLng(points[i-1], points[i]));
      }
    }
    return result;
  }

  // This method decode polyline to list of doubles
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    // Repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // For decoding values on one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /** If value is negative, bitwise not the value **/
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /** Adding to previous value as done in encoding **/
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }
    print(lList.toString());
    return lList;
  }

}
