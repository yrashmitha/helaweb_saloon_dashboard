import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/screens/gallery/add_image.dart';

class GalleryScreen extends StatefulWidget {
  static String id = 'gallery-screen';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  var loading = false;

  @override
  void initState() {

    setState(() {
      loading=true;
    });
    Future.delayed(Duration.zero).then((_){
      Provider.of<SaloonProvider>(context,listen: false).getAllGalleryImages().then((_){
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
    final galleryList = saloonProvider.mySaloon.gallery;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Gallery'),
      ),
      body: RefreshIndicator(
        onRefresh: (){
          return saloonProvider.getAllGalleryImagesRefresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context,index){
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          imageUrl: galleryList[index].url
                      ),

                    ),
                    Positioned(
                        child: IconButton(icon: Icon(Icons.delete,), onPressed: (){}),
                    )
                  ],
                );
              },
            itemCount: galleryList.length,
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AddImageScreen.id),
          child: Icon(Icons.camera_alt),
        ));

  }
}
