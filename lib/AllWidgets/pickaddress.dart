import 'dart:async';

import 'package:client_app/Api/getLocation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

import '../selectMechanic.dart';




class Pickaddress extends StatefulWidget {
  const Pickaddress({super.key});

  @override
  State<Pickaddress> createState() => _PickaddressState();
}

class _PickaddressState extends State<Pickaddress> {

  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Position? currentPosition;
  var geoLocator = Geolocator();
  var location = "No Address...";
  LatLng _draggedLatLng = LatLng(37.42796133580664, -122.085749655962);
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

  void getDraggedAddress(draggedLatLng) async{

    LatLng latLngPosition = draggedLatLng;

    getloc loc = getloc();
    await loc.GetAddressForDraggedpin(latLngPosition);
    setState(() {
      location = loc.Address;
    });


    print(draggedLatLng);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {


    return Dialog(
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.all(5),
          width: double.infinity,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Stack(
              children: [

                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onCameraMove: (cameraPosition){
                         _draggedLatLng = cameraPosition.target;
                    },
                    onCameraIdle: (){
                      getDraggedAddress(_draggedLatLng);
                      //print(_draggedLatLng);
                    },
                    onMapCreated: (GoogleMapController controller){
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;

                      locatePosition();
                    },
                  ),
                ),

                Center(
                  child: Container(
                    width: 30,
                    child: Lottie.asset("images/pin.json"),
                  ),
                ),

                Positioned(

                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child:
                        Container(
                          width: 250,
                          height: 40,
                          padding: EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54, width: 3)
                          ),
                          child: Row(
                            children: [
                              Text("Address: ",style: TextStyle( color:Colors.black54, fontSize: 12)),
                              Flexible(child: Text(location,style: TextStyle( color:Colors.pink, fontSize: 10),)),
                            ],
                          ),
                        )
                    )
                ),

                Positioned(

                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){

                                updateMechanicLoc();
                                Navigator.pop(context);

                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 14,
                                    fontFamily: "Brand Bold"
                                ),
                              ))
                        ],
                      ),
                    )
                )

                  ],
                )

          ),
        )


    );
  }
   updateMechanicLoc() async{
     final lat = _draggedLatLng.latitude.toString();
     final lng = _draggedLatLng.longitude.toString();
     String uid = _firebaseAuth.currentUser!.uid.toString();

     MechanicRef.child(uid).update({
       "location": location,
       "lat": lat,
       "lng": lng,
     });
   }
}
