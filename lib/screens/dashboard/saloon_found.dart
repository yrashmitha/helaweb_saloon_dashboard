import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/constants.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';

class SaloonFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saloonProvider = Provider.of<SaloonProvider>(context);
    final mySaloon = saloonProvider.mySaloon;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text('Welcome back',style: kSaloonName,),
            Text(mySaloon.name,style: kSaloonName,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 150,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('New Appointments',textAlign: TextAlign.center,),
                            OutlineButton(onPressed: (){},
                            child: Text("View"),)
                          ],
                        ),
                      ),
                    )
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 100,
                      color: Theme.of(context).accentColor,
                      child: Text('Today Appointments'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 100,
                      color: Theme.of(context).accentColor,
                      child: Text('Today Appointments'),
                    ),
                  ),
                ),

              ],
            )
          ],
        )
      ),
    );
  }
}
