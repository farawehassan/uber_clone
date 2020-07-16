import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uberapp/states/app_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'set_destination.dart';

/// https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=YOUR_API_KEY

class MyHomePage extends StatefulWidget {

  static const id = "home_page";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  //var uuid = Uuid();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LatLng _currentPosition;

  CameraTargetBounds targetBounds;
  double cameraZoom = 18.0;

  Set<Marker> mark = {};
  Set<Polyline> poly = {};


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    _currentPosition = appState.initialPosition;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      //drawerScrimColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: (){

              },
              child: UserAccountsDrawerHeader(
                accountName: Text("Farawe Taiwo"),
                accountEmail: Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          '5.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 2.0,),
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 33,
                      ),
                    ),
                  ],
                ),
                currentAccountPicture: Container(
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 50.0,
                    color: Colors.grey[400],
                  ),
                ),
                onDetailsPressed: (){

                },
              ),
            ),
            ListTile(
              title: Text('Your Trips'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Payment'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Get Discounts'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: appState.initialPosition == null
          ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
              ],
            ),
          )
          : Column(
            children: [
              Flexible(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      //height: (MediaQuery.of(context).size.height) / 1.55,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: appState.initialPosition, zoom: cameraZoom,),
                        onMapCreated: appState.onCreated,
                        //onCameraMoveStarted: appState.updateLocation,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        mapType: MapType.normal,
                        cameraTargetBounds: targetBounds,
                        compassEnabled: true,
                        // trafficEnabled: true,
                        markers: mark, //appState.markers,
                        onCameraMove: appState.onCameraMove,
                        polylines: poly,//appState.polylines,
                        //circles: appState.circles,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 15,
                      child: GestureDetector(
                        onTap: (){
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Icon(
                          FontAwesomeIcons.bars,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
                        child: Center(
                          child: Text(
                            "Good Morning, Taiwo",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 2.0,
                        color: Colors.grey[200],
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            FlatButton(
                              onPressed: () async {
                                setState(() {
                                  mark.clear();
                                  poly.clear();
                                });
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SetDestination(position: appState.initialPosition)),
                                );
                                setState(() {
                                  mark = result['Markers'];
                                  poly = result['Polyline'];
                                  if(result['Destination'].latitude <= appState.initialPosition.latitude){
                                    targetBounds = CameraTargetBounds(new LatLngBounds(
                                        northeast: appState.initialPosition,
                                        southwest: result['Destination']
                                    ));
                                  }else{
                                    targetBounds = CameraTargetBounds(new LatLngBounds(
                                        northeast: result['Destination'],
                                        southwest: appState.initialPosition
                                    ));
                                  }
                                  cameraZoom = 9.0;
                                });
                              },
                              child: Container(
                                height: 60.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                                  color: Colors.grey[200],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 15.0, top: 16.0, bottom: 6.0),
                                        child: Text(
                                          'Where to?',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        print('5');
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(8.0),
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Icon(
                                                Icons.watch_later,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                              child: Text(
                                                'Now',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w600
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child:Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                          child: Text(
                                            'UNILAG Nigeria',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 12.0),
                                          child: Text(
                                            'University of Lagos, Akoka Rd, Yaba, Lagos',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:Icon(
                                    FontAwesomeIcons.angleRight,
                                    color: Colors.grey[500],
                                    size: 23,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 40.0, bottom: 8.0),
                            child: Container(
                              height: 2.0,
                              color: Colors.grey[200],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child:Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                                          child: Text(
                                            'Airport Road',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 12.0),
                                          child: Text(
                                            'Airport Road, Ajao Estate Lagos',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:Icon(
                                    FontAwesomeIcons.angleRight,
                                    color: Colors.grey[500],
                                    size: 23,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

}

