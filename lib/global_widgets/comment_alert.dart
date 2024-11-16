import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myat_ecommerence/app/data/comment_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/Feeds/controllers/feeds_controller.dart';

import '../app/data/post_model.dart';

class CommentAlertWidget extends StatefulWidget {
  final Post postData;
  final FeedsController controller;
  const CommentAlertWidget(
      {super.key, required this.postData, required this.controller});

  @override
  State<CommentAlertWidget> createState() => _CommentAlertWidgetState();
}

class _CommentAlertWidgetState extends State<CommentAlertWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.postData.value = widget.postData;
      widget.controller.isReply.value = false;
      widget.controller.commentController.text = "";
      widget.controller.parent_id.value = -1;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedsController>(builder: (value) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() => Stack(
              children: [
                CustomScrollView(
                  // controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 4,
                          width: 40,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                      if (widget.controller.postData.value.comments!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(bottom: 40),
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .controller.postData.value.comments!.length,
                              itemBuilder: (BuildContext context, int index) {
                                CommentModel comData = widget
                                    .controller.postData.value.comments![index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: NetworkImage(widget
                                            .controller
                                            .postData
                                            .value
                                            .comments![index]
                                            .image
                                            .toString()),
                                        backgroundColor: Colors.transparent,
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
                                        SizedBox(height: 5),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: ConstsConfig.bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
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
                                                          FontWeight.bold)),
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
                                                          FontWeight.normal))
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
                                                        color: widget
                                                                        .controller
                                                                        .postData
                                                                        .value
                                                                        .comments![
                                                                            index]
                                                                        .replyShow ==
                                                                    true &&
                                                                widget
                                                                        .controller
                                                                        .postData
                                                                        .value
                                                                        .comments![index]
                                                                        .id ==
                                                                    widget.controller.parent_id.value
                                                            ? ConstsConfig.primarycolor
                                                            : Colors.black45,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.normal))),
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
                                                    widget.controller.parent_id
                                                        .value) {
                                                  widget.controller.isReply
                                                          .value =
                                                      !widget.controller.isReply
                                                          .value;
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
                                                          .comments![index]
                                                          .replyShow!;
                                                } else {
                                                  widget.controller.isReply
                                                      .value = true;
                                                  widget
                                                      .controller
                                                      .postData
                                                      .value
                                                      .comments![index]
                                                      .replyShow = true;
                                                }
                                                widget.controller.parent_id
                                                    .value = comData.id!;

                                                widget.controller.postData.value
                                                    .comments!.length;
                                              });
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
                                                        child: CircleAvatar(
                                                          radius: 30.0,
                                                          backgroundImage:
                                                              NetworkImage(widget
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
                                                      SizedBox(width: 5),
                                                      Flexible(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 6),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            EdgeInsets.all(4),
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
                                                                    .replies![i]
                                                                    .poster
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            Text(
                                                                widget
                                                                    .controller
                                                                    .postData
                                                                    .value
                                                                    .comments![
                                                                        index]
                                                                    .replies![i]
                                                                    .body
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal))
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
                              height: 63,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                left: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: ConstsConfig.bgColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                controller: widget.controller.commentController,
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
                          width: 5,
                        ),
                        IconButton(
                            onPressed: () {
                              //       setState(() {
                              //         widget.controller.comment(
                              //             post_id: widget
                              //                 .controller.postData.value.id!
                              //                 .toInt(),
                              //             user_id: widget
                              //                 .controller.postData.value.userId!
                              //                 .toInt(),
                              //             body: widget
                              //                 .controller.commentController.text,
                              //             parient_id:
                              //                 widget.controller.parent_id.value);

                              //         /* if(widget.authController.appToken.isNotEmpty){
                              //   widget.controller.comment(post_id: widget.controller.postData.value.id!.toInt(), user_id: widget.controller.postData.value.userId!.toInt(), body: widget.controller.commentController.text, parient_id: widget.controller.parent_id.value);

                              // }else{
                              //   Get.toNamed(RouteConstant.login);
                              // }*/
                              //       });
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
            )),
      );
    });
  }
}
