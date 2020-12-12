import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/common_functions/functions.dart';
import 'package:saloon_dashboard/providers/appointment_provider.dart';

class TabContent extends StatelessWidget {
  final list;
  final ScaffoldState state;
  TabContent({this.list,this.state});
  
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppointmentProvider>(context);
    final appointmentList = appProvider.getAppointments;
    return RefreshIndicator(
      onRefresh: () {
        return appProvider
            .getAppointmentsFromDb('sFJLjuDIiT6ZyxeGQ8IA')
            .then((value) {
          state.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Refreshed!"),
            ),
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Container(
          child: list.length == 0
              ? Center(
            child: Column(
              children: [
                Text("No appointments!"),
                Text("Pull down to refresh.")
              ],
            ),
          )
              : ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, right: 8, left: 8),
                  child: Card(
                    borderOnForeground: true,
                    child: Container(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              list[index].saloonImage),
                        ),
                        title: Text(
                          "${DateFormat.yMMMMEEEEd().format(list[index].dateTime.toDate()).toString()} at ${DateFormat('kk:mm a').format(list[index].dateTime.toDate())}",
                        ),
                        subtitle: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(list[index].userName),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: getColor(
                                      list[index].status),
                                  borderRadius:
                                  BorderRadius.circular(40)),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Icon(
                                      getIcon(list[index]
                                          .status),
                                      size: 20,
                                    ),
                                    Text(
                                      list[index].status,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     PageRouteTransition(
                            //         animationType:
                            //         AnimationType.slide_right,
                            //         builder: (ctx) {
                            //           return AppointmentDetailsScreen(
                            //             appointmentId:
                            //             list[index].appointmentId,
                            //             fromBookingPage: false,
                            //           );
                            //         }));
                          },
                          child: Icon(
                            Icons.arrow_forward,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
