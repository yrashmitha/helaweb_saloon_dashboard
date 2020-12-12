import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/common_functions/functions.dart';
import 'package:saloon_dashboard/models/appointment.dart';
import 'package:saloon_dashboard/providers/appointment_provider.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final bool fromBookingPage;
  final String appointmentId;

  AppointmentDetailsScreen({this.fromBookingPage = false, this.appointmentId});

  static String id = "appointment-details-screen";

  @override
  _AppointmentDetailsScreenState createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  var cancelButton = false;
  var localReviewed = false;
  var isComplete = false;
  var loading = false;
  var isCancelled = false;

  var accepting = false;
  var completing = false;

  SaloonAppointment app;

  @override
  void initState() {
    app = SaloonAppointment(
        "", "", "", "", "", "", "", "", 0, "", "", null, false, []);
    print('init called');
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        loading = true;
      });
      Provider.of<AppointmentProvider>(context, listen: false)
          .getThisAppointmentDetails(widget.appointmentId)
          .then((value) {
        setState(() {
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final provider = Provider.of<AppointmentProvider>(context);
    final app = provider.dummyAppointment;

    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Details"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : app.appointmentId != ""
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(overflow: Overflow.visible, children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${DateFormat.yMMMMEEEEd().format(app.dateTime.toDate()).toString()} at ${DateFormat('kk:mm a').format(app.dateTime.toDate())}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: getColor(app.status),
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  getIcon(app.status),
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                Text(
                                                  app.status,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            NetworkImage(app.saloonImage),
                                      ),
                                      title: Text(
                                        app.saloonName,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(app.saloonContactNumber,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.link,
                                      color: Colors.white,
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            NetworkImage(app.userImage),
                                      ),
                                      title: Text(
                                        app.userName,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(app.userContactNumber,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -25,
                              right: 0,
                              child: Container(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                      ),
                                      child: Builder(
                                        builder: (ctx) {
                                          return Row(
                                            children: [
                                              app.status == "PENDING"
                                                  ? FloatingActionButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          accepting = true;
                                                        });
                                                        provider
                                                            .acceptAppointment(
                                                                widget
                                                                    .appointmentId)
                                                            .then((_) {
                                                          Scaffold.of(ctx)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "Appointment Accepted."),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ));
                                                        });
                                                      },
                                                      heroTag: null,
                                                      backgroundColor:
                                                          Colors.greenAccent,
                                                      tooltip:
                                                          'Accept Appointment',
                                                      child: accepting
                                                          ? CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      Colors
                                                                          .white),
                                                            )
                                                          : Icon(Icons.check),
                                                    )
                                                  : SizedBox(
                                                      width: 0,
                                                    ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              app.status == "PENDING"
                                                  ? FloatingActionButton(
                                                      onPressed: () {
                                                        provider
                                                            .cancelAppointment(
                                                                widget
                                                                    .appointmentId)
                                                            .then((_) {
                                                          setState(() {
                                                            isCancelled = true;
                                                          });
                                                          Scaffold.of(ctx)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "Appointment cancelled."),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ));
                                                        });
                                                      },
                                                      heroTag: null,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      tooltip:
                                                          'Cancel Appointment',
                                                      child: cancelButton
                                                          ? CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      Colors
                                                                          .white),
                                                            )
                                                          : Icon(Icons.clear),
                                                    )
                                                  : SizedBox(
                                                      width: 0,
                                                    ),

                                              app.status == "ACCEPTED"
                                                  ? FloatingActionButton(
                                                      onPressed: () {
                                                        provider.markAsCompleteAppointment(widget.appointmentId)
                                                            .then(
                                                          (_) {
                                                            setState(() {
                                                              completing = true;
                                                            });
                                                            Scaffold.of(ctx)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "Appointment Completed."),
                                                                behavior:
                                                                SnackBarBehavior.floating,
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      heroTag: null,
                                                      backgroundColor: Theme.of(context).accentColor,
                                                      tooltip:
                                                          'Complete Appointment',
                                                      child: completing
                                                          ? CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      Colors
                                                                          .white),
                                                            )
                                                          : Icon(Icons.thumb_up_alt_sharp),
                                                    )
                                                  : SizedBox(
                                                      width: 0,
                                                    ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 400,
                            child: ListView.builder(
                                itemCount: app.bookedServices.length,
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            app.bookedServices[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          trailing: Text(
                                              "Rs. ${app.bookedServices[index]['price'].toInt().toStringAsFixed(2)}"),
                                        ),
                                        Divider(
                                          indent: 20,
                                          thickness: .5,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * .09,
          child: Center(
              child: app.appointmentId != ""
                  ? Text(
                      "Rs. ${app.price.toInt().toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(""))),
    );
  }
}

Future<bool> _showMarkAsCompleteAlert(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Are you sure to mark this as complete?"),
          actions: [
            RaisedButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            RaisedButton(
                child: Text("Nope"),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
      });
}
