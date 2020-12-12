import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/common_functions/functions.dart';
import 'package:saloon_dashboard/models/appointment.dart';
import 'package:saloon_dashboard/providers/appointment_provider.dart';
import 'package:saloon_dashboard/screens/appointments_screen/tab_content.dart';


class AllAppointmentsScreen extends StatefulWidget {
  static String id = 'all-appointment-screen';

  @override
  _AllAppointmentsScreenState createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {
  bool loading = false;

  // CustomPopupMenu _selectedChoices = choices[0];
  final _key = GlobalKey<ScaffoldState>();

  List<SaloonAppointment> upComingList = [];

  List<SaloonAppointment> todayList = [];

  List<SaloonAppointment> pastList = [];

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  void filter(List<SaloonAppointment> list) {
    todayList.clear();
    pastList.clear();
    upComingList.clear();
    list.forEach((element) {
      var x = calculateDifference(element.dateTime.toDate());
      print('${element.dateTime.toDate()}  ${x}');
      if (x == 0) {
        todayList.add(element);
      } else if (x > 0) {
        upComingList.add(element);
      } else if (x < 0) {
        pastList.add(element);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppointmentProvider>(context);
    final appointmentList = appProvider.getAppointments;
    filter(appointmentList);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Appointments'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Today'),
                Tab(text: 'Upcoming',),
                Tab(text: 'Passed',),
              ],
            ),
          ),
          key: _key,
          body: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              :TabBarView(
            children: [

              TabContent(list: todayList, state: _key.currentState),
              TabContent(list: upComingList, state: _key.currentState),
              TabContent(list: pastList, state: _key.currentState),
            ],
          ),

        ),
      ),
    );
  }
}

// SafeArea(
// child: Scaffold(
// appBar: AppBar(
// title: Text("Select date and time"),
// ),
// body: loading
// ? Center(
// child: CircularProgressIndicator())
// : Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Container(
// height: MediaQuery.of(context).size.height * .7,
// child:
// SfCalendar(
// view: CalendarView.month,
// dataSource: MeetingDataSource(_getDataSource()),
// appointmentTimeTextFormat: 'HH:mm',
// monthViewSettings: MonthViewSettings(
// showAgenda: true,
// showTrailingAndLeadingDates: true,
// appointmentDisplayMode: MonthAppointmentDisplayMode.indicator
//
// ),
// ),
//
// // SfCalendar(
// //   specialRegions: _getTimeRegions(),
// //   showNavigationArrow: true,
// //   headerStyle: CalendarHeaderStyle(
// //     textStyle: TextStyle(
// //       fontFamily: 'Montserrat',
// //     ),
// //   ),
// //   // dataSource: MeetingDataSource(_getDataSource()),
// //   onTap: (CalendarTapDetails details) {
// //
// //   },
// //   view: CalendarView.workWeek,
// //   timeSlotViewSettings: TimeSlotViewSettings(
// //       timeInterval: Duration(
// //           minutes:
// //           Provider.of<SaloonProvider>(context).mySaloon.appointmentInterval),
// //       timeFormat: 'hh:mm',
// //       startHour: Provider.of<SaloonProvider>(context).mySaloon.openTime.toDouble(),
// //       endHour: Provider.of<SaloonProvider>(context).mySaloon.closeTime.toDouble(),
// //       nonWorkingDays: <int>[
// //         DateTime.sunday,
// //         DateTime.saturday
// //       ]),
// // ),
// ),
// // SizedBox(
// //   height: contextSize.height * 0.1,
// // ),
//
// ],
// ),
// ),
// )),
// );
