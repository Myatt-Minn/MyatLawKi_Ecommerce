import 'dart:math';

import 'package:flutter/material.dart';

import '../app/data/post_model.dart';
import 'my_cache_img.dart';

class PhotoGrid extends StatefulWidget {
  final int maxImages;
  final List<PostImage> imageUrls;
  final Function(int) onImageClicked;
  final Function onExpandClicked;
  const PhotoGrid(
      {super.key,
      required this.maxImages,
      required this.imageUrls,
      required this.onImageClicked,
      required this.onExpandClicked});

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    var images = buildImages();

    return GridView(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 1.3,
        maxCrossAxisExtent: 230,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      children: images,
    );
  }

  List<Widget> buildImages() {
    int numImages = widget.imageUrls.length;
    return List<Widget>.generate(min(numImages, widget.maxImages), (index) {
      String imageUrl = widget.imageUrls[index].path.toString();

      // If its the last image
      if (index == widget.maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(
            child: MyCacheImg(
                url: imageUrl,
                boxfit: BoxFit.cover,
                borderRadius: BorderRadius.zero),
            onTap: () => widget.onImageClicked(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '+$remaining',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: MyCacheImg(
              url: imageUrl,
              boxfit: BoxFit.cover,
              borderRadius: BorderRadius.zero),
          onTap: () => widget.onImageClicked(index),
        );
      }
    });
  }
}
