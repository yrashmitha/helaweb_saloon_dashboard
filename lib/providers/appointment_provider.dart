import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:saloon_dashboard/models/appointment.dart';

class AppointmentProvider with ChangeNotifier {
  List<SaloonAppointment> _appointmentList = [];

  List<SaloonAppointment> get getAppointments {
    return [..._appointmentList];
  }

  Future<void> getAppointmentsFromDb(String saloonId) async {
    List<SaloonAppointment> appList = [];
    await FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('date_time')
        // .where('date_time',
        // isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
        .where('saloon_id', isEqualTo: 'sFJLjuDIiT6ZyxeGQ8IA')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                log(doc.data().toString());
                appList.add(SaloonAppointment(
                    doc.id,
                    doc.data()['saloon_id'],
                    doc.data()['saloon_name'],
                    doc.data()['saloon_contact_number'],
                    doc.data()['user_id'],
                    doc.data()['user_name'],
                    doc.data()['user_contact_number'],
                    doc.data()['status'],
                    doc.data()['price'],
                    doc.data()['user_image'],
                    doc.data()['saloon_image'],
                    doc.data()['date_time'],
                    doc.data()['is_reviewed'] != null
                        ? doc.data()['is_reviewed']
                        : false,
                    doc.data()['services']));
              })
            })
        .catchError((err) {
      print(err);
    });

    _appointmentList = appList;

    notifyListeners();
  }


  Future<bool> markAsCompleteAppointment(String id) async {
    try {
      var res = await FirebaseFirestore.instance.collection('appointments')
          .doc(id)
          .update({'status': 'COMPLETED'})
          .then((_) {
        return true;
      })
          .catchError((e) {
        throw e;
      });
      await getThisAppointmentDetails(id);
      if(res){
        return true;
      }
      else {
        return false;
      }

    } on PlatformException catch (e) {
      throw e;
    }

  }


  SaloonAppointment dummyAppointment = SaloonAppointment(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      "",
      "",
      null,
      false,
      []);
  Future<void> getThisAppointmentDetails(String id) async {
    log("Appointment getting running");

    var res = await FirebaseFirestore.instance.collection('appointments').doc(id).get().then((doc) {
      dummyAppointment.appointmentId = doc.id;
      dummyAppointment.saloonId = doc.data()['saloon_id'];
      dummyAppointment.saloonName = doc.data()['saloon_name'];
      dummyAppointment.saloonContactNumber = doc.data()['saloon_contact_number'];
      dummyAppointment.userId = doc.data()['user_id'];
      dummyAppointment.userName = doc.data()['user_name'];
      dummyAppointment.userContactNumber = doc.data()['user_contact_number'];
      dummyAppointment.status = doc.data()['status'];
      dummyAppointment.price = doc.data()['price'];
      dummyAppointment.userImage = doc.data()['user_image'];
      dummyAppointment.saloonImage = doc.data()['saloon_image'];
      dummyAppointment.dateTime = doc.data()['date_time'];
      dummyAppointment.isReviewed = doc.data()['is_reviewed'] != null ? doc.data()['is_reviewed'] : false;
      dummyAppointment.bookedServices = doc.data()['services'];
      log("Appointment getting over");
      notifyListeners();
    }).catchError((err) {
      print(err);
    });
  }

  Future<bool> cancelAppointment(String id) async {
    log("hi");
    try {
      await FirebaseFirestore.instance.collection('appointments')
          .doc(id)
          .update({'status': 'CANCELLED'})
          .then((_) {
        return true;
      })
          .catchError((e) {
        throw e;
      });
    } on PlatformException catch (e) {
      throw e;
    }
    return false;
  }

  Future<bool> acceptAppointment(String id) async {
    log("hi");
    try {
      await FirebaseFirestore.instance.collection('appointments')
          .doc(id)
          .update({'status': 'ACCEPTED'})
          .then((_) {
        return true;
      })
          .catchError((e) {
        throw e;
      });

      await getThisAppointmentDetails(id);
    } on PlatformException catch (e) {
      throw e;
    }
    return false;
  }

}


Map x = {
  'saloon_id': 'sFJLjuDIiT6ZyxeGQ8IA',
  'user_email': 'y.sethunga@gmail.com',
  'saloon_contact_number': 752110342,
  'user_image':
      ' https://lh3.googleusercontent.com/a-/AOh14GisKMJqFzpllMyWngqy50HzJtCS-0zHkmMLvps=s96-c',
  'user_name': 'Yohan Rashmitha',
  'services': [
    {'price': 1000, 'name': 'Waxing'}
  ],
  'saloon_image':
      'https://firebasestorage.googleapis.com/v0/b/saloonapp-c93ca.appspot.com/o/wedding.jpg?alt=media&token=d1283eb7-99dc-4d2a-a53a-eda50cc99af0',
  'user_contact_number': 'Not Provided',
  'saloon_name': 'Nipuni Fashion',
  'is_reviewed': true,
  'date_time': DateTime.now(),
  'user_id': 'F7kLhnclAJfMM7nuax6reh1CGYG2',
  'price': 1000,
  'review': {
    'date': DateTime.now(),
    'star': 5,
    'user_name': 'Yohan Rashmitha',
    'user_profile_avatar':
        'https://lh3.googleusercontent.com/a-/AOh14GisKMJqFzpllMyWngqy50HzJtCS-0zHkmMLvps=s96-c',
    'appointment_id': '2020-11-23 10:00:00.000@sFJLjuDIiT6ZyxeGQ8IA',
    'customer_review': 'great'
  },
  'user_token':
      'e7TjAG64TdOCklqzpLlMXr:APA91bFkJN6i8RLxRdGM7OmGEeVc6ajjnyykC8MXK00DfqqhS9T-HxczWgPlAsER8jBevXCnnanIny_s0XwUX4DDDRJbuKW9rm2vydIOQtQHw4D4QXxFIA-_ij28abCSehko8BvZWoLM',
  'status': 'COMPLETED'
};
