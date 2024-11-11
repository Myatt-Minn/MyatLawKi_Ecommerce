// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:myat_ecommerence/app/data/consts_config.dart';
// import 'package:myat_ecommerence/app/data/post_model.dart';

// import 'package:myat_ecommerence/app/modules/postCard/controllers/post_card_controller.dart';

// class PostCardView extends GetView<PostCardController> {
//   final Post post;
//   const PostCardView({super.key, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     var userId = FirebaseAuth.instance.currentUser!.uid;
    
//     return GestureDetector(
//       onTap: () {
//         Get.toNamed('/comments', arguments: post);
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Color(0xFF4C312E),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeaderSection(),
//             const SizedBox(height: 10),
//             _buildDescriptionSection(),
//             const SizedBox(height: 10),
//             _buildImageSection(),
//             const SizedBox(height: 10),
//             Obx(
//               () => _buildBottomSection(
//                   post, userId, controller.commentLength.value),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Row(
//       children: [
//         CircleAvatar(
//           backgroundImage: NetworkImage(post.profImg),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             post.username,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDescriptionSection() {
//     return Text(
//       post.description,
//       maxLines: 3,
//       overflow: TextOverflow.ellipsis,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 14,
//       ),
//     );
//   }

//   Widget _buildImageSection() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Image.network(
//         post.postUrl,
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   Widget _buildBottomSection(Post post, String userId, int cmtLength) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: 12,
//             ),
//             Text(
//               '$cmtLength Comments',
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: ConstsConfig.secondarycolor),
//             child: Row(
//               children: [
//                 Icon(Icons.message),
//                 SizedBox(
//                   width: 4,
//                 ),
//                 Text("Comment")
//               ],
//             ))
//       ],
//     );
//   }
// }
