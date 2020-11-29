import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/service.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/screens/services_screen/widgets/add_service_alertbox.dart';

class AddServiceScreen extends StatefulWidget {
  static String id = 'add-service-screen';

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  List<Service> tempList;

  var loading = false;

  void deleteItem(Service s) {
    setState(() {
      tempList.remove(s);
    });
  }

  @override
  void initState() {
    tempList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final saloonProvider = Provider.of<SaloonProvider>(context);
    final mySaloon = saloonProvider.mySaloon;
    final services = saloonProvider.mySaloon.services;

    return Scaffold(
        appBar: AppBar(
          title: Text('Add service'),
          actions: [
            Builder(
              builder: (ctx) {
                return IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await saloonProvider.addServiceArray(tempList)
                      .then((_){
                        if(tempList.length>0){
                          Scaffold.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text('Services added successfully!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        setState(() {
                          tempList.clear();
                          loading = false;
                        });

                      });

                    });
              },
            )
          ],
        ),
        body: loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Please wait...')
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(tempList[index].name),
                            subtitle: Text(tempList[index].description),
                            trailing: Text('Rs. ' +
                                tempList[index].price.toStringAsFixed(2)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteItem(tempList[index]),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: tempList.length,
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final x = await AddServiceAlert.showAlert(context);
            print(x);
            if (x != false) {
              setState(() {
                tempList.add(x);
              });
            }
          },
          child: Icon(Icons.add),
        ));
  }
}

// Future<bool> _showAlert(BuildContext context) async {
//   String _serviceName = '';
//   String _description = '';
//   int _price = 0;
//   final _form = GlobalKey<FormState>();
//   return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Enter your service details"),
//           content: ListView(
//             shrinkWrap: true,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Form(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10.0),
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               hintText: 'Service Name',
//                               labelText: 'Service Name',
//                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                               contentPadding: EdgeInsets.all(0),
//                             ),
//                             keyboardType: TextInputType.phone,
//                             autofocus: false,
//                             validator: (value) {
//                               if (value.length < 5 || value.isEmpty) {
//                                 return 'Enter valid name';
//                               }
//                               return null;
//                             },
//                             onChanged: (val) {
//                               _serviceName = val;
//                             },
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10.0),
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               hintText: 'Service Description',
//                               labelText: 'Service Description',
//                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                               contentPadding: EdgeInsets.all(0),
//                             ),
//                             keyboardType: TextInputType.multiline,
//                             maxLines: 5,
//                             autofocus: false,
//                             validator: (value) {
//                               if (value.length < 5 || value.isEmpty) {
//                                 return 'Enter valid description';
//                               }
//                               return null;
//                             },
//                             onChanged: (val) {
//                               _description = val;
//                             },
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10.0),
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               hintText: 'Service Price',
//                               labelText: 'Service Price',
//                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                               contentPadding: EdgeInsets.all(0),
//                             ),
//                             keyboardType: TextInputType.number,
//                             autofocus: false,
//                             validator: (value) {
//                               if (value.length < 1 || value.isEmpty) {
//                                 return 'Enter valid price';
//                               }
//                               return null;
//                             },
//                             onChanged: (val) {
//                               _price = int.parse(val);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             RaisedButton(
//                 child: Text("Okay, I got It"),
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 }),
//             RaisedButton(
//                 child: Text("I'll do it later"),
//                 color: Theme.of(context).errorColor,
//                 onPressed: () {
//                   Navigator.pop(context, false);
//                 })
//           ],
//         );
//       });
// }
