import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/constants.dart';
import 'package:saloon_dashboard/providers/saloon_setup_provider.dart';
import 'file:///C:/Users/ADMIN/AndroidStudioProjects/saloon_dashboard/lib/screens/dashboard/dashboard_screen.dart';
import 'package:saloon_dashboard/screens/services_screen/services_screen.dart';

class MainSaloonDataSetupScreen extends StatefulWidget {
  @override
  _MainSaloonDataSetupScreenState createState() =>
      _MainSaloonDataSetupScreenState();
}

class _MainSaloonDataSetupScreenState extends State<MainSaloonDataSetupScreen> {
  final _form = GlobalKey<FormState>();
  List _myActivities;
  String _myActivitiesResult;

  List _myCategories;
  String _myCategoriesResult;

  String saloonName = "";

  String saloonAddress = "";

  String saloonBaseLocation = "";

  String saloonGender = "";

  String saloonContactNumber = "";

  File _image;

  String saloonDescription = "";

  num saloonAppointmentInterval = 30;

  num openTime = 8;
  num closeTime = 18;

  bool saloonParking = false;

  bool saloonWashRooms = false;


  var loading=false;



  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight: 200);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  void saveForm(BuildContext ctx) {
    bool isValid = _form.currentState.validate();
    if (_image == null) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Please choose a image.'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    if (isValid) {
      setState(() {
        loading = true;
      });
      Provider.of<SaloonSetupProvider>(context,listen: false).addSaloon(saloonName,_image,saloonDescription
      ,saloonBaseLocation,saloonAddress,saloonGender,saloonContactNumber,saloonWashRooms,saloonParking,
      openTime,closeTime,saloonAppointmentInterval,_myActivities,_myCategories,context).then((_){
        _myActivities = [];
        _myCategories = [];
        _image = null;
        setState(() {
          loading = false;
        });
        _showAlert(context);
      });
    }
  }

  List<Widget> locationList() {
    List<DropdownMenuItem> list = [];
    kCityList.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.toString()),
        value: element.toString(),
      ));
    });
    return list;
  }

  List<Widget> times() {
    List<DropdownMenuItem> list = [];
    kHours.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element['text']),
        value: element['value'],
      ));
    });
    return list;
  }

  List<Widget> appointmentDurationList() {
    List<DropdownMenuItem> list = [];
    kAppointmentDurations.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.toString()+" Minutes"),
        value: element,
      ));
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myActivitiesResult = '';
    _myCategories = [];
    _myCategoriesResult = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: loading? Center(child: CircularProgressIndicator(),)
      : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Let's make your saloon"),
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: _image != null
                                  ? FileImage(_image)
                                  : AssetImage(
                                      'assets/images/empty.png',
                                    ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        child: FloatingActionButton(
                          onPressed: getImage,
                          child: Icon(Icons.camera_alt),
                        ),
                        bottom: -20,
                        right: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Builder(
                    builder: (context) {
                      return Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Primary Information',style: kSaloonName,),
                            Divider(),
                            //name
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Saloon Name',
                                  labelText: 'Saloon Name',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value.length < 5 || value.isEmpty) {
                                    return 'Enter valid name';
                                  }
                                  return null;
                                },
                                onChanged: (val){
                                  saloonName = val;
                                },
                                onFieldSubmitted: (val) {
                                  saloonName = val;
                                },
                              ),
                            ),
                            // address
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Saloon Address',
                                  labelText: 'Saloon Address',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value.length < 5 || value.isEmpty) {
                                    return 'Enter valid address';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (val) {
                                  saloonAddress = val;
                                },
                              ),
                            ),
                            // base location
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  saloonBaseLocation = val;
                                  print(saloonBaseLocation);
                                },
                                items: locationList(),
                                decoration: InputDecoration(
                                  hintText: 'Select Your location',
                                  labelText: 'Saloon Location',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value ==null) {
                                    return 'Select your saloon Location';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // gender
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  saloonGender = val;
                                  print(saloonGender);
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 'MALE',
                                    child: Text("Male"),
                                  ),
                                  DropdownMenuItem(
                                    value: 'FEMALE',
                                    child: Text("Female"),
                                  ),
                                  DropdownMenuItem(
                                    value: 'BOTH',
                                    child: Text("Both"),
                                  )
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Select Gender',
                                  labelText: 'Saloon Gender',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value == null) {
                                    return 'Select Gender';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //description
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Tell something about your saloon',
                                  labelText: 'Saloon Introduction',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                maxLines: 10,

                                validator: (value) {
                                  if (value.length < 5 || value.isEmpty) {
                                    return 'You must introduce your self to your customers';
                                  }
                                  return null;
                                },
                                onChanged: (val){
                                  saloonDescription = val;
                                },
                                onFieldSubmitted: (val) {
                                  saloonDescription = val;
                                },
                              ),
                            ),
                            //contact number
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Your contact number',
                                  labelText: 'Saloon Contact Number',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                keyboardType: TextInputType.phone,
                                autofocus: false,
                                validator: (value) {
                                  if (value.length < 10 || value.isEmpty) {
                                    return 'Enter valid contact number';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (val) {
                                  saloonContactNumber = val;
                                },
                              ),
                            ),

                            Divider(),
                            Text('Additional Information',style: kSaloonName,),

                            // appointment time
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  saloonAppointmentInterval = val;
                                },
                                items: appointmentDurationList(),
                                decoration: InputDecoration(
                                  hintText: 'Your appointment duration in minutes approximately',
                                  labelText: 'Your appointment duration in minutes approximately',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value ==null) {
                                    return 'Select appointment duration';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //open Time
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  openTime = val;
                                },
                                items: times(),
                                decoration: InputDecoration(
                                  hintText: 'Saloon open time',
                                  labelText: 'Saloon open time',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value ==null) {
                                    return 'Select your open time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //close time
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  closeTime = val;
                                },
                                items: times(),
                                decoration: InputDecoration(
                                  hintText: 'Saloon close time',
                                  labelText: 'Saloon close time',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value ==null) {
                                    return 'Select your close time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // have parking
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  saloonParking = val;
                                },
                                items: [
                                  DropdownMenuItem(child: Text('Yes'),value: true,),
                                  DropdownMenuItem(child: Text('No'),value: false,),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Do you have parking?',
                                  labelText: 'Do you have parking?',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value ==null) {
                                    return 'Select an option';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //have washrooms
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                              child: DropdownButtonFormField(
                                onChanged: (val) {
                                  saloonWashRooms = val;
                                },
                                items: [
                                  DropdownMenuItem(child: Text('Yes'),value: true,),
                                  DropdownMenuItem(child: Text('No'),value: false,),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Do you have washrooms in your saloon?',
                                  labelText: 'Do you have washrooms in your saloon?',
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  contentPadding: EdgeInsets.all(0),
                                ),

                                validator: (value) {
                                  if (value ==null) {
                                    return 'Select an option';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //closed days
                            MultiSelectFormField(
                              autovalidate: false,

                              dialogShapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              title: Text(
                                "Closed Days",
                                style: TextStyle(fontSize: 16),
                              ),
                              dataSource: kDays,
                              textField: 'day',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: Text('Please choose one or more'),
                              initialValue: _myActivities,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myActivities = value;
                                });
                              },
                              validator: (val){
                                if(_myActivities.length == 0){
                                  return 'This field is required';
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                            //categories
                            MultiSelectFormField(
                              autovalidate: false,

                              dialogShapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              title: Text(
                                "Your Service Categories",
                                style: TextStyle(fontSize: 16),
                              ),
                              dataSource: kCategoryList,
                              textField: 'name',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: Text('Please Select Your Service Categories'),
                              initialValue: _myActivities,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myCategories = value;
                                });
                              },
                              validator: (val){
                                if(_myCategories.length == 0){
                                  return 'This field is required';
                                }
                                else{
                                  return null;
                                }
                              },
                            ),

                            //submit
                            RaisedButton(
                              onPressed: () {
                                saveForm(context);
                              },
                              child: Text('Crate saloon'),
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showAlert(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Your saloon is successfully created"),
          content: Text("Congratulations! Your saloon is successfully created. Just one more step."
              "Now you have to add your services, otherwise customers can't to for you."),
          actions: [
            RaisedButton(
                child: Text("Okay, I got It"),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pushReplacementNamed(context, ServicesScreen.id);
                }),
            RaisedButton(
                child: Text("I'll do it later"),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  Navigator.pop(context, false);
                  Navigator.pushReplacementNamed(context, DashboardScreen.id);
                })
          ],
        );
      });
}