import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/modules/Feeds/controllers/feeds_controller.dart';
import 'package:myat_ecommerence/app/modules/postCard/controllers/post_card_controller.dart';
import 'package:myat_ecommerence/global_widgets/newfeed_detail.dart';

import '../../../../global_widgets/comment_alert.dart';
import '../../../../global_widgets/my_cache_img.dart';
import '../../../../global_widgets/photo_grid.dart';
import '../../../../global_widgets/view_all_images.dart';

class PostCardView extends GetView<FeedsController> {
  final Post post;
  const PostCardView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    RxInt commentLength = post.comments!.length.obs;
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Get.to(NewfeedDetailPage(id: post.id!, controller: controller, postData: post));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF4C312E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 10),
            _buildDescriptionSection(),
            const SizedBox(height: 10),
            if(post.images!.length==1)
              InkWell(
                onTap: (){
                  Get.to(ViewAllImagesScreen(images: post.images, indexImg: 0,));

                },
                child: Container(
                  height: screenHeight/4,
                  child: MyCacheImg(url: post.images![0].path.toString(), boxfit: BoxFit.fill, borderRadius: BorderRadius.zero),
                ),
              ),
            if(post.images!.length!=3 && post.images!.length==2 && post.images!.length!=1)
              Container(
                height: screenHeight/5.1,
                child: Row(
                  children: [
                    Flexible(child: InkWell(
                      onTap: (){
                        Get.to(ViewAllImagesScreen(images: post.images, indexImg: 0,));
                      },
                      child: MyCacheImg(url: post.images![0].path.toString(), boxfit: BoxFit.fill, borderRadius: BorderRadius.zero,height: screenHeight/6),
                    )),
                    const SizedBox(height: 3),
                    Flexible(child: InkWell(
                      onTap: (){
                        Get.to(ViewAllImagesScreen(images: post.images, indexImg: 1,));
                      },
                      child: MyCacheImg(url: post.images![1].path.toString(), boxfit: BoxFit.fill, borderRadius: BorderRadius.zero,height: screenHeight/6),
                    ))
                  ],
                ),
              ),
            if(post.images!.length==3 && post.images!.length!=1)
              Flexible(child: Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Get.to(ViewAllImagesScreen(images: post.images, indexImg: 0,));

                      },
                      child: MyCacheImg(url: post.images![0].path.toString(), boxfit: BoxFit.fill, borderRadius: BorderRadius.zero,width: screenWidth,height: screenHeight/4),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(child: InkWell(
                          onTap: (){
                            Get.to(ViewAllImagesScreen(images: post.images, indexImg: 1,));

                          },
                          child: MyCacheImg(url: post.images![1].path.toString(), boxfit: BoxFit.cover, borderRadius: BorderRadius.zero,height: screenHeight/6),
                        )),
                        const SizedBox(height: 3),
                        Flexible(child: InkWell(
                          onTap: (){
                            Get.to(ViewAllImagesScreen(images: post.images, indexImg: 2,));


                          },
                          child: MyCacheImg(url: post.images![2].path.toString(), boxfit: BoxFit.cover, borderRadius: BorderRadius.zero,height: screenHeight/6),
                        )),
                      ],
                    )
                  ],
                ),
              )),
            if(post.images!.length>3)
              Container(
                height: screenHeight/2.7,
                child: PhotoGrid(
                  imageUrls: post.images!,
                  onImageClicked: (i) => {
                   Get.to(ViewAllImagesScreen(images: post.images, indexImg: i,))

                  },
                  onExpandClicked: () => {
                  Get.toNamed('/comments', arguments: post)

                  },
                  maxImages: 4,
                ),
              ),
           // _buildImageSection(),
            const SizedBox(height: 10),
            Obx(
              () => _buildBottomSection(post, commentLength.value,context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/icon.png'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            post.poster!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Text(
      post.description!,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }

  Widget _buildImageSection() {
    return post.images!.isEmpty
        ? const SizedBox(height: 0)
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              post.images![0].path!,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildBottomSection(Post post, int cmtLength,BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Text(
              '$cmtLength Comments',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => CommentAlertWidget(postData: post, controller: controller),
              );
             // Get.toNamed('/comments', arguments: post);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: ConstsConfig.secondarycolor),
            child: Row(
              children: [
                Icon(Icons.message),
                SizedBox(
                  width: 4,
                ),
                Text("Comment")
              ],
            ))
      ],
    );
  }
}
