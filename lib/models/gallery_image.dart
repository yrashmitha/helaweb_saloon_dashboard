import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryImage{
  String name;
  String url;
  DateTime dateTime;

  GalleryImage(this.name,this.url,this.dateTime);
}