import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:saloon_dashboard/providers/saloon_provider.dart';
import 'package:saloon_dashboard/screens/gallery/add_image.dart';
import 'package:saloon_dashboard/screens/gallery/view_image.dart';

class GalleryScreen extends StatefulWidget {
  static String id = 'gallery-screen';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  var loading = false;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<SaloonProvider>(context, listen: false)
          .getAllGalleryImages()
          .then((_) {
        setState(() {
          loading = false;
        });
      }).catchError((err) {
        setState(() {
          loading = false;
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
        key: _key,
        appBar: AppBar(
          title: Text('My Gallery'),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return saloonProvider.getAllGalleryImagesRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          imageUrl: galleryList[index]['url'],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteTransition(
                                      builder: (ctx) {
                                        return ViewImage(
                                          url: galleryList[index]['url'],
                                        );
                                      },
                                      animationType: AnimationType.scale,
                                      fullscreenDialog: true,
                                    ),
                                  );
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).errorColor,
                                ),
                                onPressed: () {
                                  saloonProvider
                                      .deleteImage(galleryList[index])
                                      .then((value) {
                                    _key.currentState.showSnackBar(SnackBar(
                                      content: Text("Deleted!"),
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                  });
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
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
// ClipRRect(
// borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
// child: CachedNetworkImage(
// fit: BoxFit.cover,
// placeholder: (ctx, url) {
// return Center(
// child: CircularProgressIndicator(),
// );
// },
// imageUrl: galleryList[index].url
// ),
// ),IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,), onPressed: (){})

// Container(
// height: 200,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// image: DecorationImage(
// fit: BoxFit.cover,
// image: NetworkImage(galleryList[index]['url'],
// scale: 1.5))),
// child: Align(
// alignment: Alignment.bottomRight,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// IconButton(
// icon: Icon(Icons.visibility),
// onPressed: () {
// Navigator.push(
// context,
// PageRouteTransition(
// builder: (ctx) {
// return ViewImage(
// url: galleryList[index]['url'],
// );
// },
// animationType: AnimationType.scale,
// fullscreenDialog: true,
// ),
// );
// }),
// IconButton(
// icon: Icon(
// Icons.delete,
// color: Theme.of(context).errorColor,
// ),
// onPressed: () {
// saloonProvider
//     .deleteImage(galleryList[index])
//     .then((value) {
// _key.currentState.showSnackBar(
// SnackBar(content: Text("Deleted!"),behavior: SnackBarBehavior.floating,));
// });
// }),
// ],
// ),
// )),
