import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/gallery_image.dart';
import 'package:saloon_dashboard/models/saloon.dart';
import 'package:saloon_dashboard/models/service.dart';
import 'package:saloon_dashboard/providers/appointment_provider.dart';
import 'package:saloon_dashboard/providers/auth_provider.dart';

class SaloonProvider with ChangeNotifier {
  CollectionReference _saloons =
      FirebaseFirestore.instance.collection('saloons');

  Saloon mySaloon;

  List<dynamic> allGalleryImages=[];

  Saloon get myShowRoom {
    return mySaloon;
  }

  List<Service> returnMyServicesArray(List arr) {
    List<Service> sList = [];
    arr.forEach((element) {
      sList.add(Service(
          name: element['name'],
          description: element['description'],
          price: element['price']));
    });
    return sList;
  }

  List<GalleryImage> returnMyGalleryImagesArray(List arr) {
    List<GalleryImage> sList = [];
    arr.forEach((element) {
      sList.add(GalleryImage(element['name'],element['url'],element['date_time']));
    });
    return sList;
  }

  void hey(context) {
    print(Provider.of<AuthProvider>(context, listen: false).loggedInUser.uId);
    print(Provider.of<AuthProvider>(context, listen: false).loggedInUser.name);
  }

  Future<void> getMySaloonData(context) async {
    final userId =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser.uId;
    final saloon = await _saloons.where('user_id', isEqualTo: userId).get();
    if (saloon.docs.isNotEmpty) {
      //getting user saloon from list in here we assume only one document is available
      final doc = saloon.docs.first;
      mySaloon = Saloon(
        doc.id,
        doc.data()["name"],
        doc.data()["main-image_url"],
        "",
        doc.data()["base_location"],
        doc.data()["address"],
        doc.data()["gender"],
        doc.data()['contact_number'].toString(),
        {},
        00,
        00,
        doc.data()['rating'].toDouble(),
        doc.data()['ratings_count'],
        00,
        [],
        [],
        0,
        [],
      );
      //getting saloon data from data sub collection
      final saloonData = await FirebaseFirestore.instance
          .collection('saloons/${doc.id}/data')
          .doc(doc.id)
          .get();
      mySaloon.description = saloonData.data()['description'];
      mySaloon.additionalData = saloonData.data()["additional_data"];
      mySaloon.contactNumber = saloonData.data()['contact_number'].toString();
      mySaloon.openTime = saloonData.data()['open_time'];
      mySaloon.closeTime = saloonData.data()['close_time'];
      mySaloon.appointmentInterval = saloonData.data()['appointment_interval'];
      mySaloon.services = returnMyServicesArray(saloonData.data()["services"]);
      mySaloon.gallery = saloonData.data()['gallery'] == null
          ? []
          : saloonData.data()['gallery'];
      mySaloon.galleryLimit = saloonData.data()['gallery_limit'];
      mySaloon.reviews = saloonData.data()['reviews'] == null
          ? []
          : saloonData.data()['reviews'];


      final appointments = await Provider.of<AppointmentProvider>(context,listen: false)
          .getAppointmentsFromDb('sFJLjuDIiT6ZyxeGQ8IA');

      print('saloon data getting finished');
      print(FirebaseAuth.instance.currentUser.uid);

    } else {
      print('we have no document');
    }

    notifyListeners();
  }

  Future<void> addServiceArray(List<Service> list) async {
    if (list.length > 0) {
      print('add services running');
      List<Service> newList = mySaloon.services + list;
      newList.sort((a, b) => a.price.compareTo(b.price));
      mySaloon.services = newList;
      List<Map<dynamic, dynamic>> data = [];

      newList.forEach((element) {
        final map = {
          'name': element.name,
          'price': element.price,
          'description': element.description
        };
        data.add(map);
      });

      await FirebaseFirestore.instance
          .collection('saloons')
          .doc(mySaloon.id)
          .collection('data')
          .doc(mySaloon.id)
          .update({'services': data});
      notifyListeners();
    }
  }

  Future<void> refreshSaloonServices() async {
    print('refresh  services running');

    await FirebaseFirestore.instance
        .collection('saloons')
        .doc(mySaloon.id)
        .collection('data')
        .doc(mySaloon.id)
        .get()
        .then((snap) {
      mySaloon.services = returnMyServicesArray(snap.data()["services"]);
    });
    notifyListeners();
  }

  Future<void> deleteService(List<dynamic> list) async {
    print('delete services running');
    List<Service> newList = list;
    newList.sort((a, b) => a.price.compareTo(b.price));
    List<Map<dynamic, dynamic>> data = [];

    newList.forEach((element) {
      final map = {
        'name': element.name,
        'price': element.price,
        'description': element.description
      };
      data.add(map);
    });

    await FirebaseFirestore.instance
        .collection('saloons')
        .doc(mySaloon.id)
        .collection('data')
        .doc(mySaloon.id)
        .update({'services': data});
  }

  Future<void> updateServiceArray(List<Service> list) async {
    print('update services running');

    list.sort((a, b) => a.price.compareTo(b.price));
    List<Map<dynamic, dynamic>> data = [];

    list.forEach((element) {
      final map = {
        'name': element.name,
        'price': element.price,
        'description': element.description
      };
      data.add(map);
    });

    await FirebaseFirestore.instance
        .collection('saloons')
        .doc(mySaloon.id)
        .collection('data')
        .doc(mySaloon.id)
        .update({'services': data});
  }

  int _getGalleryCount=0;

  Future<void> getAllGalleryImages() async {
    if(_getGalleryCount == 0){
      try{
        await FirebaseFirestore.instance
            .collection('saloons')
            .doc(mySaloon.id)
            .collection('all_images')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            allGalleryImages
                .add(GalleryImage(element.data()['name'], element.data()['url'],element.data()['date_time']));
          });
        });
      } on PlatformException catch(e){
        print(e.message);
      }
    }
    _getGalleryCount++;

    notifyListeners();


  }

  Future<void> getAllGalleryImagesRefresh() async {
    log('gallery images refreshing');
    allGalleryImages = [];
      try{
        final saloonData = await FirebaseFirestore.instance
            .collection('saloons/${mySaloon.id}/data')
            .doc(mySaloon.id)
            .get();
        mySaloon.description = saloonData.data()['description'];
        mySaloon.additionalData = saloonData.data()["additional_data"];
        mySaloon.contactNumber = saloonData.data()['contact_number'].toString();
        mySaloon.openTime = saloonData.data()['open_time'];
        mySaloon.closeTime = saloonData.data()['close_time'];
        mySaloon.appointmentInterval = saloonData.data()['appointment_interval'];
        mySaloon.services = returnMyServicesArray(saloonData.data()["services"]);
        mySaloon.gallery = saloonData.data()['gallery'] == null
            ? []
            : saloonData.data()['gallery'];
        mySaloon.galleryLimit = saloonData.data()['gallery_limit'];
        mySaloon.reviews = saloonData.data()['reviews'] == null
            ? []
            : saloonData.data()['reviews'];
        print('saloon data getting finished');
      } on PlatformException catch(e){
        print(e.message);
      }
    notifyListeners();
  }

  Future<bool> addImageToTheGallery(File image)async{
    print('upload running');
    final currentGallerySize = mySaloon.gallery.length;
    final currentGallery = mySaloon.gallery;


    // currentGallery.add({
    //   'name' : "galleryImageName",
    //   'url' : "url",
    //   'date_time' : "time"
    // });

    //print(currentGallery);

    if(currentGallerySize < mySaloon.galleryLimit){
      final user = FirebaseAuth.instance.currentUser;
      final time = DateTime.now();
      final currentGallery = mySaloon.gallery;
      try{
        final galleryImageName = 'gallery_image_'+"$time";
        final ref = FirebaseStorage.instance.ref().child(user.uid).child(galleryImageName);

        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        print('##########################################upload complete###################################');
        print("*******************************************");
        final List<dynamic> arr=[...mySaloon.gallery];
        arr.add({
          'name' : galleryImageName,
          'url' : url,
          'date_time' : time
        });
        print(arr);
        log('writting url to db');
        await _saloons.doc(mySaloon.id).collection('data').doc(mySaloon.id)
            .update({
          'gallery' : arr
        }).then((value){
          log('db updated');
        });

        mySaloon.gallery = arr;
        notifyListeners();
        return true;
      }on FirebaseException catch(e){
        print("This is error you got"+e.message);
        throw e;
      }
    }
    else{
      return false;
    }


  }

  Future<void> deleteImage(dynamic object)async{

    final user = FirebaseAuth.instance.currentUser;
    try{
      final ref = await FirebaseStorage.instance.ref().child(user.uid).child(object['name']).delete();
      mySaloon.gallery.remove(object);

      await _saloons.doc(mySaloon.id).collection('data').doc(mySaloon.id)
          .update({
        'gallery' : mySaloon.gallery
      }).then((value){
        log('db updated');
      });


        notifyListeners();
      }on FirebaseException catch(e){
        print("This is error you got"+e.message);
        throw e;
      }



  }

}
