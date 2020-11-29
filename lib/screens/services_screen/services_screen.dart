import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/models/service.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/screens/services_screen/add_service_screen.dart';
import 'package:saloon_dashboard/screens/services_screen/widgets/edit_service_alertbox.dart';

class ServicesScreen extends StatefulWidget {
  static String id = 'services-screen';

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  void deleteItem(Service s){

  }




  @override
  Widget build(BuildContext context) {
    final saloonProvider = Provider.of<SaloonProvider>(context);
    final mySaloon = saloonProvider.mySaloon;

    final services = saloonProvider.mySaloon.services;

    return Scaffold(
        appBar: AppBar(
          title: Text('Your services'),
        ),
        body: RefreshIndicator(
          onRefresh: (){
            return saloonProvider.refreshSaloonServices();
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(services[index].name),
                        subtitle: Text(services[index].description),
                        trailing: Text('Rs. '+services[index].price.toStringAsFixed(2)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(icon: Icon(Icons.edit),
                              onPressed: ()async{
                            final s = await EditServiceAlert.showAlert(context,services[index]);
                            if(s!=false && s[1]==true){
                              services[index].name = s[0].name;
                              services[index].description = s[0].description;
                              services[index].price = s[0].price;
                              await saloonProvider.updateServiceArray(services)
                              .then((value){
                                setState(() {

                                });
                                Scaffold.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text('Service edited successfully!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              });
                                }
                              }),
                          IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),
                            onPressed: ()async{
                              services.remove(services[index]);
                              await saloonProvider.deleteService(services).then((value){
                                setState(() {

                                });
                              });

                          },),
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: services.length,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AddServiceScreen.id),
          child: Icon(Icons.add),
        ));
  }
}

Future<bool> _showAlert(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Your saloon is successfully created"),
          content: Text(
              "Congratulations! Your saloon is successfully created. Just one more step."
              "Now you have to add your services, otherwise customers can't to for you."),
          actions: [
            RaisedButton(
                child: Text("Okay, I got It"),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            RaisedButton(
                child: Text("I'll do it later"),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ],
        );
      });
}
