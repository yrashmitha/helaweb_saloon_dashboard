import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String url;

  const ViewImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.contain
            )
          ),
        ),
      ),
      appBar: AppBar(),
    );
  }
}
