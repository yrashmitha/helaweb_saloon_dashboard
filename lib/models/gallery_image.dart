import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryImage{
  String name;
  String url;
  Timestamp dateTime;

  GalleryImage(this.name,this.url,this.dateTime);
}