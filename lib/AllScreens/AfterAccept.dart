import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:client_app/AllScreens/MechanicScreen.dart';
import 'package:client_app/AllScreens/reached_dis.dart';
import 'package:client_app/AllScreens/reached_dis_user.dart';
import 'package:client_app/AllScreens/requestService.dart';
import 'package:client_app/Api/getLocation.dart';
import 'package:client_app/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../selectMechanic.dart';
import 'ServiceScreen.dart';
import 'mainscreen.dart';

class AfterAccept extends StatefulWidget {
  AfterAccept({super.key});
  late String reqid;
  static const String idScreen = "After";

  @override
  State<AfterAccept> createState() => _AfterAcceptState();
}

class _AfterAcceptState extends State<AfterAccept> {
  late String reqid;
  late String uid;

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
  String distanceInKm = "0.5";

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

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }


  void locatePosition() async {
    Position position = await _determinePosition();
    currentPosition = position;

    originlat = position.latitude;
    originlng = position.longitude;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    getloc loc = getloc();
    await loc.GetAddressFromLatLong(position);

    setState(() {
      location = loc.Address;
    });
    print(location);

  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  var mechanicMarker = "Null";
  var polylineId = "poly";


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
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  getDistance(destLatitude, destLongitude) async {
    distanceInMeter = await Geolocator.distanceBetween(
        originlat, originlng, destLatitude, destLongitude);
    distanceInKm = ((distanceInMeter.round()) / 1000).toStringAsFixed(2);
    if (0.06 > (double.parse(distanceInKm))) {
      Navigator.pushNamedAndRemoveUntil(context, Reached_dis_user.idScreen, (route) => true, arguments: {'reqid': reqid,});

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    locatePosition();
    loadmarkers();
    //reqData();
    super.initState();
  }
  late Uint8List markerIcon;
  loadmarkers() async {
    markerIcon =
    await getBytesFromAssets("images/gear.png", 60);
  }



  void getlines(destLat,destLng) async {
    Future.delayed(Duration(milliseconds: 10), () {
      polylineId = reqid.toString();
      _getPolyline(destLat,destLng);
      getDistance(destLat, destLng);
    });
  }
  late String mechName;

  void canceled() async{


    Future.delayed(Duration(milliseconds: 1000), () {


      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? reqData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    reqid = reqData?['reqid'];
    print(distanceInKm);

    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      limit = 465.3;
    } else {
      limit = 175;
    }

    return StreamBuilder(
        stream: UpdateReqRef.orderByChild('req_id').equalTo(reqid).onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.snapshot.value == null){
             //Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
              canceled();
              return Scaffold(
                appBar: AppBar(
                  title: Center(child: Text("Track Mechanic")),
                ),
                body: Center(child: CircularProgressIndicator()),
                bottomNavigationBar: Container(
                  color: Colors.deepPurple,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.white, size: 30),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, MainScreen.idScreen, (route) => false);
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
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            List<dynamic> list = [];
            list.clear();
            list= map.values.toList();
            mechName = list[0]['mechanic'];
            getlines(double.parse(list[0]['lat']), double.parse(list[0]['lng']));
            return Scaffold(
              appBar: AppBar(
                title: Text("Track Mechanic"),
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    markers: Set<Marker>.of([
                      Marker(
                          markerId: MarkerId((list[0]['email']).toString()),
                          position: LatLng(double.parse(list[0]['lat']), double.parse(list[0]['lng'])),
                          icon: BitmapDescriptor.fromBytes(markerIcon),
                      ),
                    ]),
                    polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;
                      locatePosition();
                      //startTimer();
                    },
                  ),
                  Positioned(

                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 20,top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        child: Row(
                                          children: [
                                            Text(distanceInKm,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 24,
                                                  fontFamily: "Brand Bold",
                                                )
                                            ),
                                            SizedBox(width: 5,),
                                            Text('Km away',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 10,
                                                  fontFamily: "Brand Bold",
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(list[0]['mechanic'],
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontFamily: "Brand Bold",
                                          ),
                                      ),
                                      Text(list[0]['contact'],
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontFamily: "Brand-Regular",
                                          )
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              "Rating: ",
                                              style: TextStyle(
                                                  color: Colors
                                                      .grey,
                                                  fontSize: 12)),
                                          Icon(Icons.star_rate_rounded,color: Colors.yellow,size: 16),
                                          Text(
                                              "4.5/5",
                                              style: TextStyle(
                                                  color: Colors
                                                      .grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.call),
                                          SizedBox(width: 12,),
                                          Icon(Icons.message),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: (){
                                      updateRequest();
                                      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
                                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));

                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 14,
                                          fontFamily: "Brand Bold"
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )
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
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, MainScreen.idScreen, (route) => false);
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text("Track Mechanic")),
              ),
              body: Center(child: CircularProgressIndicator()),
              bottomNavigationBar: Container(
                color: Colors.deepPurple,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white, size: 30),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, MainScreen.idScreen, (route) => false);
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
        });
  }
  updateRequest() async{

    // MechanicRef.orderByChild('name').equalTo(mechName).once().then((event){
    //   final snap = event.snapshot;
    //   if(snap.value != null){
    //     Map<dynamic,dynamic> mechmap= snap.value as Map<dynamic,dynamic>;
    //     MechanicRef.child(mechmap['id']).update({
    //       "status": "unoccupied",
    //     });
    //
    //   }
    //   else{
    //     print("error");
    //   }
    // });
    //
    // UpdateReqRef.orderByChild('req_id').equalTo(reqid).once().then((event){
    //   final snap = event.snapshot;
    //   if(snap.value != null){
    //     Map<dynamic,dynamic> upmap= snap.value as Map<dynamic,dynamic>;
    //     UpdateReqRef.child(upmap['id']).remove();
    //
    //   }
    //   else{
    //     print("error");
    //   }
    // });


    RequestsRef.child(reqid)..update({
            "status": "canceled",
          });
  }
}
