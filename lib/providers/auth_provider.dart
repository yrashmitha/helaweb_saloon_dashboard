import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saloon_dashboard/models/user.dart';

class AuthProvider with ChangeNotifier {

  AppUser _loggedUser;
  bool _isAuth = false;

  UserCredential _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');


  AppUser get loggedInUser{
    return _loggedUser;
  }


  bool get isAuth {
    if(_auth.currentUser!=null){
      _loggedUser = AppUser(_auth.currentUser.uid, _auth.currentUser.displayName, _auth.currentUser.email
          , _auth.currentUser.photoURL, _auth.currentUser.phoneNumber,false, _auth.currentUser.metadata.creationTime, _auth.currentUser.metadata.lastSignInTime);
      return true;
    }
    _loggedUser=null;
    return  false;
  }





  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> handleSignIn() async {

    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _user = await _auth.signInWithCredential(credential);

      _loggedUser = AppUser(
          _user.user.uid,
          _user.user.displayName,
          _user.user.email,
          _user.user.photoURL,
          _user.user.phoneNumber,
          _user.additionalUserInfo.isNewUser,
          _user.user.metadata.lastSignInTime,
          _user.user.metadata.lastSignInTime
      );

      if(_user.additionalUserInfo.isNewUser){
        await addUser(_user.user.uid, _user.user.displayName, _user.user.photoURL, _user.user.phoneNumber,_user.user.email);
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut().then((GoogleSignInAccount acc) => print(acc));
    await _auth.signOut();
    _isAuth = false;
    _loggedUser=null;
    notifyListeners();
  }

  Future<void> addUser(String uid, String name, String photoUrl,String phoneNumber,String email) {
    return users
        .doc(uid)
        .set({
      'id': uid,
      'name': name,
      'email' :email,
      'photo_url' : photoUrl,
      'phone_number' : phoneNumber
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void printUserData(){
    print(loggedInUser.uId);
    print(loggedInUser.name);
  }

}
