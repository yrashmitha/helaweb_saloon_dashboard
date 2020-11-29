class Saloon{
  String id;
  String name;
  Map<dynamic,dynamic> featuredImage;
  String description;
  String baseLocation;
  String address;
  String gender;
  String contactNumber;
  int appointmentInterval;
  Map additionalData;
  int openTime;
  int closeTime;
  double rating;
  int ratingsCount;
  List<dynamic> services;
  List<dynamic> gallery;
  int galleryLimit;
  List<dynamic> reviews;


  Saloon(this.id, this.name, this.featuredImage, this.description,
      this.baseLocation, this.address, this.gender,this.contactNumber,
      this.additionalData,this.openTime,this.closeTime,
      this.rating,this.ratingsCount,this.appointmentInterval,
      this.services,this.gallery,this.galleryLimit,this.reviews);





}