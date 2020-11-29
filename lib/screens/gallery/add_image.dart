import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';

class AddImageScreen extends StatefulWidget {
  static String id = 'add-image-screen';

  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {

  var loading=false;

  File _image;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              setState(() {
                loading=true;
              });
              Provider.of<SaloonProvider>(context,listen: false).addImageToTheGallery(_image)
              .then((_){
                setState(() {
                  loading=false;
                });
              });
            },
          )
        ],
      ),
      body: ListView(
        children: [
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
            height: 100,
          ),
          loading ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Hold on.. Upload in progress'),
              SizedBox(height: 10,),
              CircularProgressIndicator()
            ],
          )
              : SizedBox()


        ],
      ),
    );
  }
}
