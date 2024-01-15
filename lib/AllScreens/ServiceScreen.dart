import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui'as ui;
import 'package:client_app/AllScreens/requestService.dart';
import 'package:client_app/Api/getLocation.dart';
import 'package:client_app/configMaps.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../selectMechanic.dart';
import 'mainscreen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  static const String idScreen = "Service";

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  
  final List<Marker> _markers = <Marker>[];

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Uint8List? markerImage;

  Position? currentPosition;
  var geoLocator = Geolocator();
  var location = "No Address...";
  var originlat = 0.000;
  var originlng = 0.000;
  double distanceInMeter = 0.0;
  String distanceInKm="0.0";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  void locatePosition() async{
    Position position = await _determinePosition();
    currentPosition = position;

    originlat = position.latitude;
    originlng = position.longitude;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);


    CameraPosition cameraPosition =  CameraPosition(target: latLngPosition,zoom: 15);
    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    getloc loc = getloc();
    await loc.GetAddressFromLatLong(position);

    setState(() {
      location = loc.Address;
    });
    print(location);
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight:width );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  var mechanicMarker = "Null";
  var polylineId= "poly";
  
  loadmarkers(mech) async{

    final Uint8List markerIcon = await getBytesFromAssets("images/servicePin.png", 100);
      Map<dynamic,dynamic> mark = mech;
      var lat = double.parse(mark['lat']);
      var lng = double.parse(mark['lng']);

      _markers.add(
        Marker(markerId: MarkerId(mark['phone'].toString()),
          position: LatLng(lat, lng),
           onTap: (){
             mechanicMarker = mark['phone'].toString();

             setState(() {

             });
             polylineCoordinates.clear();
             polylineId = mark['phone'].toString();
             _getPolyline(lat, lng);
             getDistance(lat,lng);
           },
           icon: BitmapDescriptor.fromBytes(markerIcon),
           infoWindow: InfoWindow(
             title: mark['name'],
               snippet: distanceInKm
           )
        ),

      );

    print("markers: "+_markers.toString());
  }

  double _top = 465.3;
  double changeTop = 0;
  double limit = 465.3;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  _addPolyLine() {
    PolylineId id = PolylineId(polylineId);
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.deepPurple, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(destLatitude, destLongitude) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(originlat, originlng),
        PointLatLng(destLatitude, destLongitude),
        travelMode: TravelMode.driving,
       // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  getDistance(destLatitude, destLongitude) async{

    distanceInMeter = await Geolocator.distanceBetween(originlat, originlng, destLatitude, destLongitude);
    distanceInKm = ((distanceInMeter.round())/1000).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {

    print(distanceInKm);

      if(MediaQuery.of(context).viewInsets.bottom == 0){
        limit = 465.3;
      }
      else{
        limit = 175;
      }

    return Scaffold(
      appBar: AppBar(title: Text("Mechanic Service"),),
      body: Stack(
        children: [
          GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              markers: Set<Marker>.of(_markers),
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller){
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;



              },
          ),
          Positioned(
              top: _top,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,

              child: Container(

               clipBehavior: Clip.antiAlias,
                height: 245.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ]
                ),
                child: Column(
                  children: [
                       Container(

                        color: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(height: 1,),
                            GestureDetector(
                              onPanUpdate: (details){

                                changeTop = _top + details.delta.dy;
                                if(changeTop <= limit){
                                  _top = max(0, changeTop);
                                }


                                setState(() {

                                });

                              },
                              child: Container(
                                padding: EdgeInsets.only(bottom: 15),
                                height: 19,
                                width: 120,
                                color: Colors.deepPurple,
                                child: Container(

                                  width: 120,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Where are you?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: "Brand Bold",
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.my_location,color: Colors.white),
                                    style: IconButton.styleFrom(
                                        backgroundColor: Colors.cyan,
                                        padding: EdgeInsets.symmetric(vertical: 1,horizontal: 9),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                    ),
                                    onPressed: () {
                                      locatePosition();
                                    },
                                  ),

                                   Container(
                                      clipBehavior: Clip.antiAlias,
                                      width: 250,
                                      height: 40,
                                      padding: EdgeInsets.only(left: 3),
                                      decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                               border: Border.all(color: Colors.white, width: 3)
                                           ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        SizedBox(
                                          width: 150,
                                          child: TextField(
                                            onTap: (){
                                              _top = 0;

                                              setState(() {

                                              });
                                            },
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(bottom: 12),
                                                    border: InputBorder.none,
                                                    hintText: "Enter Your Location",
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  style: TextStyle(fontSize: 14,),
                                                ),
                                        ),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: Colors.cyan,
                                                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)))

                                        ),
                                              onPressed: (){
                                                _top = 10;
                                                setState(() {

                                                });
                                              },
                                              child: Text('Search',
                                                  style: TextStyle( color:Colors.white, fontSize: 14))),
                                        ],
                                      ),
                                    ),

                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),

                      ),


                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 10),
                        padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              Container(
                                //width: 250,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black54, width: 3)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on),
                                    //Text("Address: ",style: TextStyle( color:Colors.black54, fontSize: 12)),
                                    Flexible(child: Text(location,style: TextStyle( color:Colors.pink, fontSize: 10),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                               GestureDetector(
                                 onTap: (){
                                   mechanicMarker = "Null";

                                   setState(() {

                                   });
                                 },
                                 child: Text(
                                  "List of all availabe mechanics close to you",
                                  style: TextStyle(color: Colors.deepPurple,fontSize: 10,fontFamily: "Brand-Regular"),
                                  textAlign: TextAlign.center,
                              ),
                               ),
                              SizedBox(height: 10,),
                              Container(
                                width: double.infinity,
                                //height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black54, width: 3)
                                ),
                                child:
                                    StreamBuilder(
                                    stream: MechanicRef.onValue,
                                    builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                                      List<dynamic> list = [];
                                      list.clear();
                                      list= map.values.toList();

                                      for(final mech in list){
                                        loadmarkers(mech);
                                      }

                                      if(mechanicMarker != "Null"){
                                        return
                                          Column(
                                            children: [
                                              for(final li in list)...[
                                                if(li['phone']==mechanicMarker)...[
                                                Container(
                                                  width: double.infinity,
                                                  //height: 40,
                                                  margin: EdgeInsets.symmetric(vertical: 2),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6, vertical: 5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(8),
                                                      border: Border.all(
                                                          color: Colors.deepPurple,
                                                          width: 3)
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 40.0,
                                                                height: 40.0,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "images/mechanic1.png"),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          70.0)),
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    width: 3.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    left: 8),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(li['name'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontSize: 14)),
                                                                    Text(
                                                                        "Contact: "+li['phone'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize: 10)),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Rating: ",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .grey,
                                                                                fontSize: 10)),
                                                                        Icon(Icons.star_rate_rounded,color: Colors.yellow,size: 16),
                                                                        Text(
                                                                            "4.5/5",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .grey,
                                                                                fontSize: 10)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          Container(

                                                            child: TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                    backgroundColor: Colors
                                                                        .deepPurple,
                                                                    //padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(Radius
                                                                            .circular(
                                                                            8)))
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pushNamedAndRemoveUntil(context, RequestService.idScreen, (route) => true, arguments: {'distance': distanceInKm,'email': li['email'],'location': location,'userlat':originlat,'userlng':originlng});
                                                                },
                                                                child: Text('Request',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 12))),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                                ]
                                              ],
                                            ],
                                          );

                                      }

                                      else {
                                        return Column(
                                          children: [
                                            for(final li in list)...[
                                              GestureDetector(
                                                onTap: (){
                                                  //print(li["name"]);
                                                  mechanicMarker = li['phone'].toString();
                                                  LatLng latLngPosition = LatLng(double.parse(li['lat']), double.parse(li['lng']));

                                                  CameraPosition cameraPosition =  CameraPosition(target: latLngPosition,zoom: 15);
                                                  newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

                                                  polylineCoordinates.clear();
                                                  polylineId = li['phone'].toString();
                                                  _getPolyline(double.parse(li['lat']), double.parse(li['lng']));

                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  //height: 40,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6, vertical: 5),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(8),
                                                      border: Border.all(
                                                          color: Colors
                                                              .deepPurple,
                                                          width: 3)
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 40.0,
                                                                height: 40.0,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "images/mechanic1.png"),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                      Radius
                                                                          .circular(
                                                                          70.0)),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    width: 3.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                    left: 8),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                        li['name'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontSize: 14)),
                                                                    Text(
                                                                        "Contact: " +
                                                                            li['phone'],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize: 10)),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Rating: ",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .grey,
                                                                                fontSize: 10)),
                                                                        Icon(Icons.star_rate_rounded,color: Colors.yellow,size: 16),
                                                                        Text(
                                                                            "4.5/5",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .grey,
                                                                                fontSize: 10)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          Container(

                                                            child: TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                    backgroundColor: Colors
                                                                        .deepPurple,
                                                                    //padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius
                                                                            .all(
                                                                            Radius
                                                                                .circular(
                                                                                8)))
                                                                ),
                                                                onPressed: () {},
                                                                child: Text(
                                                                    'Request',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 12))),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ],
                                        );
                                      }
                                      }  else {
                                        return
                                          const Text(
                                            "Mechanics which are available and close to you will be listed here.",
                                            style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: "Brand-Regular"),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                        })

                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          )
        ],

      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () {
                },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
