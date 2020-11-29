import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/constants.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';

class SaloonSetupProvider with ChangeNotifier {


  final saloonRef = FirebaseFirestore.instance.collection('saloons');

  Future<void> addSaloon(String saloonName, File image,
      String saloonDescription,
      String saloonBaseLocation, String saloonAddress, String saloonGender,
      String saloonContactNumber,
      bool saloonWashRooms, bool saloonParking, num openTime, num closeTime,
      num appointmentInterval,
      List closedDays, List categories,BuildContext context) async {

    final user = FirebaseAuth.instance.currentUser;

    // print(saloonName);
    // print(saloonDescription);
    // print(saloonBaseLocation);
    // print(saloonAddress);
    // print(saloonGender);
    // print(saloonContactNumber);
    // print(saloonWashRooms);
    // print(saloonParking);
    // print(openTime);
    // print(closeTime);
    // print(appointmentInterval);
    // print(closedDays);
    // print(getOpenHours(closedDays, openTime, closeTime));
    // print(categories);

    try{
      final featureImageName = 'feature_image_'+"${DateTime.now()}";
      final ref = FirebaseStorage.instance.ref().child(user.uid).child(featureImageName);

      await ref.putFile(image).whenComplete(() async {
        final url = await ref.getDownloadURL();

        final firstCollectionData = {
          'address': saloonAddress,
          'base_location': saloonBaseLocation,
          'categories': categories,
          'gender': saloonGender,
          'lower_case': saloonName.toLowerCase(),
          'main-image_url': {
            'name': featureImageName,
            'url': url,
          },
          'name' : saloonName,
          'rating' : 0,
          'ratings_count' : 0,
          'user_id' : user.uid
        };

        final res = await saloonRef.add(firstCollectionData);

        final secondCollectionData  = {
          'additional_data' : {
            'is_verified' : false,
            'membership_type' : 'Freemium',
            'parking' : saloonParking,
            'washroom' :saloonWashRooms,
            'open_hours' : getOpenHours(closedDays, openTime, closeTime)
          },
          'appointment_interval' : appointmentInterval,
          'close_time' :closeTime,
          'open_time' : openTime,
          'contact_number' : saloonContactNumber,
          'description' : saloonDescription,
          'gallery' : [],
          'gallery_limit' : 10,
          'reviews' : [],
          'services' : [],
          'closed_days' : closedDays
        };

        await saloonRef.doc(res.id).collection('data').doc(res.id).set(secondCollectionData);

        Provider.of<SaloonProvider>(context,listen: false).getMySaloonData(context);

      });

    }
    on PlatformException catch(e){
      print('we got error $e');
    }

    // FirebaseStorage.instance.ref().child(user.uid).child(name).delete().then((_) => print('Successfully deleted  storage item' ));
  }


  List<Map> getOpenHours(List closedDays,num openTime,num closeTime){
    List<Map> arr = [];
    kDays.forEach((element) {
      final val = int.parse(element['value'].toString());
      if(val > 0){
        if(! closedDays.contains(element['value'])){
          Map map = {};
          final day = element['day'];
          map.addAll({
            '${day}' : '${openTime}:00 AM - ${closeTime%12}:00 PM'
          });
          arr.add(map);
        }

      }
    });
    return arr;
  }





}