import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:helawebdesign_saloon/models/app_user.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/constants.dart';
import 'package:saloon_dashboard/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //AppUser user;
  AuthProvider auth;
  bool  loading=false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final media = MediaQuery.of(context).size;
    final double vertical = media.height * 0.1;
    auth = Provider.of<AuthProvider>(context);
    // print(auth.currentUser.name);
    // user = auth.currentUser;
    return SafeArea(
      child: Scaffold(
          body: loading ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kMainYellowColor),
              ),
              Text("Hold on just a second...")
            ],
          )) :Container(
            width: double.infinity,
            decoration: BoxDecoration(

              image: DecorationImage(
                image: AssetImage('assets/images/makeup.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),

              ),
              // gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [kMainYellowColor,Colors.white])
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: media.height* .05,),
                  Text(
                    "Helaweb Saloon Vendor", textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: media.height* .05,),
                  CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('assets/images/login-back.png')),

                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: RaisedButton(
                          color: kMainYellowColor,
                          onPressed: () {
                            print("pressed");
                            setState(() {
                              loading=true;

                              auth.handleSignIn().then((value) {
                                setState(() {
                                  loading=false;
                                });
                              });
                            });

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.google),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Log in with GOOGLE',style: const TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

