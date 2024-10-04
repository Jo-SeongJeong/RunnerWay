// import 'package:flutter/material.dart';
// import 'package:frontend/controllers/course_controller.dart';
// import 'package:get/get.dart';
// import '../../models/ranking.dart';
// import '../../widgets/ranking_card.dart'; // RankingCard 위젯을 import
//
// class RankingListView extends StatelessWidget {
//   RankingListView({super.key});
//
//   final CourseController courseController = Get.find<CourseController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ranking List')),
//       body: Obx(() {
//         // Reactive to ranking changes in the controller
//         List<Ranking> ranking = courseController.ranking.value;
//
//         if (ranking.isEmpty) {
//           return const Center(child: Text('No ranking data available.'));
//         }
//
//         return ListView.builder(
//           itemCount: ranking.length,
//           itemBuilder: (context, index) {
//             final user = ranking[index];
//             final memberDto = user.member;
//             final memberImage = memberDto.memberImage;
//
//             return RankingCard(
//               name: memberDto.nickname ?? 'Unknown',
//               time: user.score ?? '00:00:00',
//               imageUrl: memberImage != null ? memberImage.url : null,
//               rank: index + 1,
//               isActive: true, // Adjust based on your logic for active state
//             );
//           },
//         );
//       }),
//     );
//   }
// }
