import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ViewAllImagesScreen extends StatefulWidget {
  final List<PostImage>? images;
  final int indexImg;
  const ViewAllImagesScreen(
      {super.key, required this.images, required this.indexImg});

  @override
  State<ViewAllImagesScreen> createState() => _ViewAllImagesScreenState();
}

class _ViewAllImagesScreenState extends State<ViewAllImagesScreen> {
  late String imgUrl = "";
  PageController pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.indexImg);
      imgUrl = widget.images![widget.indexImg].path.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  downloadImage(imgUrl);
                });
              },
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.white,
              ))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: pageController,
        itemCount: widget.images!.length, // Can be null
        itemBuilder: (context, position) {
          imgUrl = widget.images![position].path.toString();

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight / 3,
                child: PhotoView(
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.transparent),
                    loadingBuilder: (context, event) => const Center(
                          child: CircularProgressIndicator(
                            color: ConstsConfig.primarycolor,
                          ),
                        ),
                    imageProvider:
                        NetworkImage(widget.images![position].path.toString())),
              ),
              Text(
                "   ${widget.images![position].description}",
                style: TextStyle(color: Colors.white),
              )
            ],
          );
        },
      ),
      /*body: Container(
        height: Dimesion.screenHeight,
        width: Dimesion.screeWidth,
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images!.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Dimesion.screeWidth,
                    height: Dimesion.screenHeight/3,
                    child: PhotoView(
                        backgroundDecoration:
                        const BoxDecoration(color: Colors.transparent),
                        loadingBuilder: (context, event) => const AppLoadingWidget(),
                        imageProvider: NetworkImage(widget.images![index].path.toString())),
                  ),
                  Text("   "+widget.images![index].description.toString(),style: TextStyle(color: Colors.white),)
                ],
              );
            }),
      ),*/
    );
  }

  Future<void> downloadImage(String url) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final permission = await Permission.storage.request();
    if (permission.isGranted) {
      GallerySaver.saveImage(url, albumName: ConstsConfig.appname)
          .then((value) => {Get.snackbar("Success", "Image is Saved")});
    } else {
      Get.snackbar("Fail", "Permission denied");
    }
    /*AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 34 || Platform.isIOS) {

    } else {
      GallerySaver.saveImage(widget.imgUrl, albumName: AppConfig.appName)
          .then((value) => BotToast.showText(text: "Downloaded"));
    }*/
  }
}
