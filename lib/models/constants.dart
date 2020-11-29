import 'package:flutter/material.dart';
// import 'package:helawebdesign_saloon/models/category.dart';

var kSubTitleColor = Colors.grey;
var kTextBoldWeight = FontWeight.w600;

var kTitleStyle = TextStyle(fontSize: 20);
var kMainYellowColor = Color(0xFFfcd581);
var kSaloonName = TextStyle(fontSize: 25, fontWeight: FontWeight.w600);
var kDeepBlue = Color(0xFF101928);
var imageList = [
  'assets/images/saloon_gallery/image1.jpg',
  'assets/images/saloon_gallery/image2.jpg',
  'assets/images/saloon_gallery/image3.jpg',
  'assets/images/saloon_gallery/image4.jpg',
  'assets/images/saloon_gallery/image5.jpg',
];

var kAppointmentDurations = [30, 60, 90, 120];
var kHours = [
  {'text': '5 AM', 'value': 5},
  {'text': '6 AM', 'value': 6},
  {'text': '7 AM', 'value': 7},
  {'text': '8 AM', 'value': 8},
  {'text': '9 AM', 'value': 9},
  {'text': '10 AM', 'value': 10},
  {'text': '11 AM', 'value': 11},
  {'text': '12 AM', 'value': 12},
  {'text': '1 PM', 'value': 13},
  {'text': '2 PM', 'value': 14},
  {'text': '3 PM', 'value': 15},
  {'text': '4 PM', 'value': 16},
  {'text': '5 PM', 'value': 17},
  {'text': '6 PM', 'value': 18},
  {'text': '7 PM', 'value': 19},
  {'text': '8 PM', 'value': 20},
];

var kDays = [
  {
    "day": "I have no close days",
    "value": -1,
  },
  {
    "day": "Monday",
    "value": 1,
  },
  {
    "day": "Tuesday",
    "value": 2,
  },
  {
    "day": "Wednesday",
    "value": 3,
  },
  {
    "day": "Thursday",
    "value": 4,
  },
  {
    "day": "Friday",
    "value": 5,
  },
  {
    "day": "Saturday",
    "value": 6,
  },
  {
    "day": "Sunday",
    "value": 7,
  },
];

var kCityList = [
  'Kandana',
  'Colombo',
  'Kottawa',
  'Nuwara Eliya',
  'Kandy',
  'Kolonnawa',
  'Peradeniya',
  'Kotte',
  'Anuradhapura',
  'Jaffna',
];


var kCategoryList = [
  {
    "name" : "Hair Cutting",
    "value" : "HAIRCUT"
  },
  {
    "name" : "Waxing",
    "value" : "WAXING"
  },
  {
    "name" : "Make up",
    "value" : "MAKEUP"
  },
  {
    "name" : "Nail care",
    "value" : "NAILCARE"
  },
  {
    "name" : "Eye care",
    "value" : "EYECARE"
  },

];

// List<Category> catList=[
//   Category(title:"Hair Cutting",path: "assets/images/categories/hair_cut.png",color: Colors.green,key: "HAIR CUT"),
//   Category(title:"Makeup",path: "assets/images/categories/makeup.png",color: Colors.green,key: "MAKEUP"),
//   Category(title:"Cleaning",path: "assets/images/categories/cleaning.png",color: Colors.green,key: "CLEANING"),
//   Category(title:"Waxing",path: "assets/images/categories/waxing.png",color: Colors.green,key: "WAXING"),
//   Category(title:"Nail Care",path: "assets/images/categories/nail.png",color: Colors.green,key: "NAILCARE"),
//   Category(title:"Eye Care",path: "assets/images/categories/eyecare.png",color: Colors.green,key: "EYECARE"),
// ];
