import 'package:flutter/material.dart';
import 'package:saloon_dashboard/models/service.dart';

class EditServiceAlert{
  static Future<dynamic> showAlert(BuildContext context,Service service) async {
    String _serviceName = service.name;
    String _description = service.description;
    int _price = service.price;

    bool _anyThingChanged=false;
    final _form = GlobalKey<FormState>();

    bool saveForm() {
      bool isValid = _form.currentState.validate();
      return isValid;
    }




    return await showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter your service details"),
            content: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Service Name',
                                labelText: 'Service Name',
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                contentPadding: EdgeInsets.all(0),
                              ),
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              initialValue: _serviceName,
                              validator: (value) {
                                if (value.length < 5 || value.isEmpty) {
                                  return 'Enter valid name';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                _anyThingChanged=true;
                                _serviceName = val;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Service Description',
                                labelText: 'Service Description',
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                contentPadding: EdgeInsets.all(0),
                              ),
                              initialValue: _description,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              autofocus: false,
                              validator: (value) {
                                if (value.length < 5 || value.isEmpty) {
                                  return 'Enter valid description';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                _anyThingChanged=true;
                                _description = val;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Service Price',
                                labelText: 'Service Price',
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                contentPadding: EdgeInsets.all(0),
                              ),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              initialValue: _price.toString(),
                              validator: (value) {
                                if (value.length < 1 || value.isEmpty) {
                                  return 'Enter valid price';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                _anyThingChanged=true;
                                _price = int.parse(val);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            actions: [
              RaisedButton(
                  child: Text("Okay"),
                  onPressed: () {
                    bool x = saveForm();
                    if(x){
                      Navigator.pop(context, [Service(name: _serviceName, description: _description, price: _price),_anyThingChanged]);
                    }

                  }),
              RaisedButton(
                  child: Text("Cancel"),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    Navigator.pop(context, false);
                  })
            ],
          );
        }
    );

  }
}