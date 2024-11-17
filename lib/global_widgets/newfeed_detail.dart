import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_image/circular_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myat_ecommerence/app/data/comment_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/Feeds/controllers/feeds_controller.dart';
import 'package:myat_ecommerence/app/modules/account/controllers/account_controller.dart';
import 'package:myat_ecommerence/global_widgets/view_all_images.dart';

import '../app/data/post_model.dart';

class NewfeedDetailPage extends StatefulWidget {
  final int id;
  final Post postData;
  final FeedsController controller;
  const NewfeedDetailPage(
      {super.key,
      required this.id,
      required this.controller,
      required this.postData});

  @override
  State<NewfeedDetailPage> createState() => _NewFeedDetailPageState();
}

class _NewFeedDetailPageState extends State<NewfeedDetailPage> {
  final AccountController accountController=Get.put(AccountController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.postData.value = widget.postData;
      widget.controller.isReply.value = false;
      widget.controller.commentController.text = "";
      widget.controller.parent_id.value = -1;
    });

    /*WidgetsBinding.instance.addPostFrameCallback((_){

      widget.controller.getPostDetail(post_id: widget.id);

    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedsController>(builder: (builder) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() => widget.controller.isPostLoading.value == false
            ? Stack(
                children: [
                  CustomScrollView(
                    // controller: controller.scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                height: 4,
                                width: 40,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),*/
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(
                                        CupertinoIcons.back,
                                        color: ConstsConfig.primarycolor,
                                        size: 26,
                                      )),
                                  CircularImage(
                                    source: 'assets/icon.png',
                                    radius: 15,
                                    borderWidth: 1,
                                    borderColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    widget.controller.postData.value.poster
                                        .toString(),
                                    style: GoogleFonts.outfit(
                                        textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.controller.postData.value.description
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (widget
                                  .controller.postData.value.images!.isNotEmpty)
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.controller.postData.value
                                        .images!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(ViewAllImagesScreen(
                                            images: widget.controller.postData
                                                .value.images,
                                            indexImg: index,
                                          ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          color: ConstsConfig.bgColor,
                                          padding: EdgeInsets.only(bottom: 6),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 6,
                                              ),
                                              CachedNetworkImage(
                                                imageUrl: widget
                                                    .controller
                                                    .postData
                                                    .value
                                                    .images![index]
                                                    .path
                                                    .toString(),
                                                fit: BoxFit.fill,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                widget.controller.postData.value
                                                    .images![index].description
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Divider(
                                                color: Colors.white,
                                                height: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              Container(
                                margin: EdgeInsets.only(bottom: 45),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.controller.postData.value
                                        .comments!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      CommentModel comData = widget.controller
                                          .postData.value.comments![index];
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundImage: NetworkImage(
                                                  widget
                                                      .controller
                                                      .postData
                                                      .value
                                                      .comments![index]
                                                      .image
                                                      .toString()),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: ConstsConfig.bgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget
                                                            .controller
                                                            .postData
                                                            .value
                                                            .comments![index]
                                                            .poster
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        widget
                                                            .controller
                                                            .postData
                                                            .value
                                                            .comments![index]
                                                            .body
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal))
                                                  ],
                                                ),
                                              ),
                                              CupertinoButton(
                                                  child: Text(
                                                      widget
                                                              .controller
                                                              .postData
                                                              .value
                                                              .comments![index]
                                                              .replies!
                                                              .isNotEmpty
                                                          ? "View ${widget.controller.postData.value.comments![index].replies!.length} Reply"
                                                          : "Reply",
                                                      style: GoogleFonts.outfit(
                                                          textStyle: TextStyle(
                                                              color: widget.controller.postData.value.comments![index].replyShow ==
                                                                          true &&
                                                                      widget.controller.postData.value.comments![index].id ==
                                                                          widget
                                                                              .controller
                                                                              .parent_id
                                                                              .value
                                                                  ? ConstsConfig
                                                                      .primarycolor
                                                                  : Colors
                                                                      .black45,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))),
                                                  onPressed: () {
                                                    setState(() {
                                                      widget.controller.replyID
                                                              .value =
                                                          widget
                                                              .controller
                                                              .postData
                                                              .value
                                                              .comments![index]
                                                              .id!;
                                                      if (widget
                                                              .controller
                                                              .postData
                                                              .value
                                                              .comments![index]
                                                              .id ==
                                                          widget
                                                              .controller
                                                              .parent_id
                                                              .value) {
                                                        widget.controller
                                                                .isReply.value =
                                                            !widget.controller
                                                                .isReply.value;
                                                        widget
                                                                .controller
                                                                .postData
                                                                .value
                                                                .comments![index]
                                                                .replyShow =
                                                            !widget
                                                                .controller
                                                                .postData
                                                                .value
                                                                .comments![
                                                                    index]
                                                                .replyShow!;
                                                      } else {
                                                        widget
                                                            .controller
                                                            .isReply
                                                            .value = true;
                                                        widget
                                                            .controller
                                                            .postData
                                                            .value
                                                            .comments![index]
                                                            .replyShow = true;
                                                      }
                                                      widget
                                                          .controller
                                                          .parent_id
                                                          .value = comData.id!;

                                                      widget
                                                          .controller
                                                          .postData
                                                          .value
                                                          .comments!
                                                          .length;
                                                      /*
                                                    widget.controller.isReply.value=!widget.controller.isReply.value;
                                                    widget.controller.replyID.value=widget.controller.postData.value.comments![index].id!;
                                                    widget.controller.parent_id.value=comData.id!;
                                                    widget.controller.postData.value.comments![index].replyShow=!widget.controller.postData.value.comments![index].replyShow!;*/
                                                    });

                                                    //Get.toNamed(RouteHelper.team_see_more,arguments: TeamSeeMore(homeController: controller,));
                                                  }),
                                              Visibility(
                                                  visible: widget
                                                      .controller
                                                      .postData
                                                      .value
                                                      .comments![index]
                                                      .replyShow!,
                                                  child: ListView.builder(
                                                      itemCount: widget
                                                          .controller
                                                          .postData
                                                          .value
                                                          .comments![index]
                                                          .replies!
                                                          .length,
                                                      physics:
                                                          ClampingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        return Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 30,
                                                              height: 30,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 30.0,
                                                                backgroundImage: NetworkImage(widget
                                                                    .controller
                                                                    .postData
                                                                    .value
                                                                    .comments![
                                                                        index]
                                                                    .replies![i]
                                                                    .image
                                                                    .toString()),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                            ),
                                                            //  Icon(Icons.person_outline,color: AppColor.black,),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Flexible(
                                                                child:
                                                                    Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          6),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              decoration: BoxDecoration(
                                                                  color: ConstsConfig
                                                                      .bgColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      widget
                                                                          .controller
                                                                          .postData
                                                                          .value
                                                                          .comments![
                                                                              index]
                                                                          .replies![
                                                                              i]
                                                                          .poster
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      widget
                                                                          .controller
                                                                          .postData
                                                                          .value
                                                                          .comments![
                                                                              index]
                                                                          .replies![
                                                                              i]
                                                                          .body
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.normal))
                                                                ],
                                                              ),
                                                            ))
                                                          ],
                                                        );
                                                      })),
                                            ],
                                          ))
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ])),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      color: ConstsConfig.primarycolor,
                      height: 56,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 48),
                            child: IntrinsicWidth(
                              child: Container(
                                alignment: Alignment.center,
                                height: 53,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: ConstsConfig.bgColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: TextField(
                                  autofocus: false,
                                  controller:
                                      widget.controller.commentController,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText:
                                        widget.controller.isReply.value == false
                                            ? "Write a comment..."
                                            : "Write a Reply...",
                                    labelStyle: TextStyle(
                                        fontSize: 12,
                                        color: ConstsConfig.primarycolor),
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          SizedBox(
                            width: 6,
                          ),
                          IconButton(
                              onPressed: () async {
                                if (await widget.controller
                                    .checkAndPromptLogin()) {
                                  widget.controller.comment(
                                      post_id:
                                          builder.postData.value.id!.toInt(),
                                      userID: accountController.currentUser.value!.id,
                                      body: builder.commentController.text,
                                      parient_id: builder.parent_id.value);
                                }

                                //           if(widget.authController.appToken.isNotEmpty){
                                //   widget.controller.comment(post_id: builder.postData.value.id!.toInt(), user_id: builder.postData.value.userId!.toInt(), body: builder.commentController.text, parient_id: builder.parent_id.value);

                                // }else{
                                //   Get.toNamed(RouteConstant.login);
                                // }
                              },
                              icon: Icon(
                                Icons.send,
                                size: 25,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container()),
      );
    });
  }
}
