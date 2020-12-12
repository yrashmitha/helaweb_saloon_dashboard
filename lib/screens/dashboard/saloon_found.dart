import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:saloon_dashboard/models/constants.dart';
import 'package:saloon_dashboard/providers/auth_provider.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/screens/appointments_screen/all_appointments.dart';
import 'package:saloon_dashboard/screens/gallery/gallery_screen.dart';
import 'package:saloon_dashboard/screens/services_screen/services_screen.dart';

class SaloonFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saloonProvider = Provider.of<SaloonProvider>(context);
    final mySaloon = saloonProvider.mySaloon;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            mySaloon.featuredImage['url']))),
              ),
              SizedBox(height: 10,),
              Text(
                'Welcome back ${mySaloon.name}',
                style: kSaloonName,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RatingBarIndicator(
                    rating: mySaloon.rating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: 20,),
                  Text('${mySaloon.rating} ratings (${mySaloon.ratingsCount})'),
                  OutlineButton(
                    splashColor: Theme.of(context).errorColor,
                    highlightedBorderColor: Theme.of(context).errorColor,
                    onPressed: (){
                      Provider.of<AuthProvider>(context,listen: false).signOutGoogle();
                    },
                    child: Row(
                    children: [
                      Icon(Icons.logout),
                      Text('Log out')
                    ],
                  ),)
                ],
              ),
              SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        child: Card(
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/appointment.png'),
                                        fit: BoxFit.contain)),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'My Appointments',
                                      style: const TextStyle(
                                          fontSize: 16, letterSpacing: 2),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageRouteTransition(
                                                  builder: (ctx) {
                                                    return AllAppointmentsScreen();
                                                  },
                                                  animationType:
                                                  AnimationType.fade));
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        child: Card(
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/gallery.png'),
                                        fit: BoxFit.contain)),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'My Gallery',
                                      style: const TextStyle(
                                          fontSize: 16, letterSpacing: 2),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageRouteTransition(
                                                  builder: (ctx) {
                                                    return GalleryScreen();
                                                  },
                                                  animationType:
                                                  AnimationType.fade));
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),

                  Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        child: Card(
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/services.png'),
                                        fit: BoxFit.contain)),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'My Services',
                                      style: const TextStyle(
                                          fontSize: 16, letterSpacing: 2),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageRouteTransition(
                                                  builder: (ctx) {
                                                    return ServicesScreen();
                                                  },
                                                  animationType:
                                                  AnimationType.fade));
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
        ));
  }
}
