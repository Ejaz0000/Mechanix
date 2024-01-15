import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class getloc{
  String location ='Null';
  String Address = 'Null';



  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Placemark place = placemarks[0];
    // Address = '${place.street}, ${place.subLocality}, ${place.locality}';


    Address = placemarks.reversed.last.street.toString() +" "+ placemarks.reversed.last.subLocality.toString() +" "+ placemarks.reversed.last.locality.toString();


  }

  Future<void> GetAddressForDraggedpin(latlng)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latlng.latitude, latlng.longitude);


    Address = placemarks.reversed.last.street.toString() +" "+ placemarks.reversed.last.subLocality.toString() +" "+ placemarks.reversed.last.locality.toString();

  }
}