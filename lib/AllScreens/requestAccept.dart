import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui'as ui;
import 'package:client_app/AllScreens/MechanicScreen.dart';
import 'package:client_app/AllScreens/reached_dis.dart';
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

class RequestAccept extends StatefulWidget {
  RequestAccept ({super.key,required this.rid});
  late String rid;
  static const String idScreen = "Accept";

  @override
  State<RequestAccept> createState() => _RequestAcceptState(rid: rid);
}

class _RequestAcceptState extends State<RequestAccept> {
  late String rid;
  _RequestAcceptState({required this.rid});

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
  String distanceInKm="0.5";

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

  Timer? timer;


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
    getlines();
  }

  void startTimer(){
    timer = Timer.periodic(Duration (seconds: 1), (timer) {
      polylineCoordinates.clear();
     locatePosition();
      // setState(() {
      //
      // });

      if(0.05>(double.parse(distanceInKm))){
        stopTimer();

      }


    });
  }

  void stopTimer(){
    timer?.cancel();
    print("--------reached________");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Reached_dis()));
  }




  Future<Uint8List> getBytesFromAssets(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight:width );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  var mechanicMarker = "Null";
  var polylineId= "poly";

  loadmarkers(user) async{
    final Uint8List markerIcon = await getBytesFromAssets("images/user_pin.png", 100);
    Map<dynamic,dynamic> mark = user;
    var lat = double.parse(mark['lat']);
    var lng = double.parse(mark['lng']);

    polylineCoordinates.clear();
    polylineId = reqmap['uid'].toString();
    _getPolyline(double.parse(reqmap['lat']), double.parse(reqmap['lng']));
    getDistance(double.parse(reqmap['lat']), double.parse(reqmap['lng']));

    _markers.add(
      Marker(markerId: MarkerId(mark['uid'].toString()),
          position: LatLng(lat, lng),
          onTap: (){

            polylineCoordinates.clear();
            polylineId = reqmap['uid'].toString();
            _getPolyline(double.parse(reqmap['lat']), double.parse(reqmap['lng']));
            getDistance(double.parse(reqmap['lat']), double.parse(reqmap['lng']));
            setState(() {

            });

          },
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: mark['userName'],
              snippet: mark['distance']
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
      polylineCoordinates.clear();
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

  void initState() {
    // TODO: implement initState
    locatePosition();
    reqData();
    super.initState();
  }

  Map<dynamic,dynamic> reqmap = {'uid': "", 'problem': "", 'distance': "", 'vehicleDetails': "", 'mechanic': "", 'userLocation': "", 'userContact': "", 'userName': "", 'vehicleType': "", 'timestamp': "", 'lat': "", 'lng': ""};
  void reqData() async{
     RequestsRef.child(rid).once().then((event){
        final snap = event.snapshot;
        if(snap.value != null){
          reqmap= snap.value as Map<dynamic,dynamic>;
          print("id---------");
          print(reqmap['lat']);
          loadmarkers(reqmap);

          setState(() {

          });
        }
        else{
          print("error");
        }
      });

  }

  void getlines() async{


    Future.delayed(Duration(milliseconds: 10), () {


      polylineId = reqmap['uid'].toString();
      _getPolyline(double.parse(reqmap['lat']), double.parse(reqmap['lng']));
      getDistance(double.parse(reqmap['lat']), double.parse(reqmap['lng']));

    });
  }

  //late String rid;
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

              startTimer();

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

                    color: Colors.pink,
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
                            color: Colors.pink,
                            child: Container(

                              width: 120,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Client Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Brand Bold",
                                )
                            ),
                            Row(
                              children: [
                                Text(distanceInKm,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: "Brand Bold",
                                    )
                                ),
                                Text('Km away',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: "Brand Bold",
                                    )
                                ),
                              ],
                            ),

                          ],
                        ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Name :',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: "Brand Bold",
                                          )
                                      ),
                                      SizedBox(width: 6,),
                                      Text(reqmap['userName'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: "Brand-Regular",
                                          )
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Phone :',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: "Brand Bold",
                                          )
                                      ),
                                      SizedBox(width: 6,),
                                      Text(reqmap['userContact'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: "Brand-Regular",
                                          )
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              Column(
                                children: [
                                  Text('Address :',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "Brand Bold",
                                      )
                                  ),
                                  SizedBox(width: 6,),
                                  Text(reqmap['userLocation'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "Brand-Regular",
                                      )
                                  )
                                ],
                              )
                            ],
                          )
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

                            SizedBox(height: 5,),
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
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal:6 ,vertical:5 ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Vehicle Type :',
                                                      style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 14,
                                                        fontFamily: "Brand Bold",
                                                      )
                                                  ),
                                                  SizedBox(width: 6,),
                                                  Text(reqmap['vehicleType'],
                                                      style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 12,
                                                        fontFamily: "Brand-Regular",
                                                      )
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Text('Vehicle details :',
                                                      style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 14,
                                                        fontFamily: "Brand Bold",
                                                      )
                                                  ),
                                                  SizedBox(width: 6,),
                                                  Flexible(
                                                    child: Text(reqmap['vehicleDetails'],
                                                        style: TextStyle(
                                                          color: Colors.pink,
                                                          fontSize: 12,
                                                          fontFamily: "Brand-Regular",
                                                        )
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Text('Problem Details :',
                                                      style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 14,
                                                        fontFamily: "Brand Bold",
                                                      )
                                                  ),
                                                  SizedBox(width: 6,),
                                                  Flexible(
                                                    child: Text(reqmap['problem'],
                                                        style: TextStyle(
                                                          color: Colors.pink,
                                                          fontSize: 12,
                                                          fontFamily: "Brand-Regular",
                                                        )
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 50,),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: Colors.pink,
                                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 110),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                                  ),
                                                  onPressed: (){
                                                    print('oressed');

                                                  },
                                                  child: Text('cancel',
                                                      style: TextStyle( color:Colors.white, fontSize: 16))),
                                            ],
                                          ),
                                        );
                                      }  else {
                                        return
                                          const Text(
                                            "Client problem details will be shown here",
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
        color: Colors.pink,
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
                Navigator.pushNamedAndRemoveUntil(context, MechanicScreen.idScreen, (route) => false);

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
