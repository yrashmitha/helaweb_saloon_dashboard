import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:saloon_dashboard/screens/create_saloon/saloon_main_data_setup.dart';

class NoSaloonFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/no_saloon.png'),
              radius: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Huh! Seems still you don\'t have a saloon, click here to make one!',
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteTransition(builder: (ctx) {
                    return MainSaloonDataSetupScreen();
                  },animationType: AnimationType.slide_right),
                );
              },
              child: Text('Create a saloon'),
            )
          ],
        ),
      ),
    );
  }
}
