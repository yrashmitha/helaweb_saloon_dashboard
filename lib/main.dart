import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/providers/auth_provider.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/providers/saloon_setup_provider.dart';
import 'package:saloon_dashboard/screens/gallery/add_image.dart';
import 'package:saloon_dashboard/screens/gallery/gallery_screen.dart';
import 'file:///C:/Users/ADMIN/AndroidStudioProjects/saloon_dashboard/lib/screens/dashboard/dashboard_screen.dart';
import 'package:saloon_dashboard/screens/login_screen.dart';
import 'package:saloon_dashboard/screens/services_screen/add_service_screen.dart';
import 'package:saloon_dashboard/screens/services_screen/services_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=>AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => SaloonProvider()),
        ChangeNotifierProvider(create: (ctx) => SaloonSetupProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx,auth,_){
          return MaterialApp(
            title: 'Helaweb Saloon Vendor',
            theme: ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Montserrat'),
              primaryTextTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Montserrat',
              ),

              accentTextTheme: ThemeData.dark().accentTextTheme.apply(
                fontFamily: 'Montserrat',
              ),
              snackBarTheme: ThemeData.dark().snackBarTheme.copyWith(
                contentTextStyle: TextStyle(fontFamily: 'Montserrat',color: Colors.black)
              )
              // buttonTheme: ButtonThemeData(
              //   textTheme: Butt
              // )

            ),
            home: auth.isAuth ?  DashboardScreen() : LoginScreen(),
            routes: {
              LoginScreen.id: (ctx) => LoginScreen(),
              DashboardScreen.id : (ctx) => DashboardScreen(),
              ServicesScreen.id : (ctx) => ServicesScreen(),
              AddServiceScreen.id : (ctx) => AddServiceScreen(),
              GalleryScreen.id : (ctx) => GalleryScreen(),
              AddImageScreen.id : (ctx) => AddImageScreen(),
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('Hello world'),
            )
          ],
        ),
      ),
    );
  }
}
