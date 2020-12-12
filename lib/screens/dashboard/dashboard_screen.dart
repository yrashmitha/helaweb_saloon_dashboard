import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/constants.dart';
import 'package:saloon_dashboard/providers/auth_provider.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/screens/appointments_screen/all_appointments.dart';
import 'package:saloon_dashboard/screens/dashboard/saloon_found.dart';
import 'package:saloon_dashboard/screens/gallery/gallery_screen.dart';
import 'package:saloon_dashboard/screens/services_screen/services_screen.dart';
import 'package:saloon_dashboard/screens/dashboard/no_saloon_found.dart';

class DashboardScreen extends StatefulWidget {
  static String id= 'dashboard-screen';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var loading=false;

  Future<void> _refresh()async{
    await Provider.of<SaloonProvider>(context,listen: false).getMySaloonData(context);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_){
      setState(() {
        loading=true;
      });
      Provider.of<SaloonProvider>(context,listen: false).getMySaloonData(context).then((_){
        setState(() {
          loading=false;
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final saloonProvider = Provider.of<SaloonProvider>(context);
    final mySaloon = saloonProvider.mySaloon;
    final media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hela salon Vendor'),
        ),
        body: loading ? Center(child: CircularProgressIndicator(),) :
        RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            child: mySaloon !=null ? SaloonFound()
                : NoSaloonFound(),
          ),
        ),

      ),
    );
  }
}
