import 'package:flutter/material.dart';
import 'package:frontend/models/ranking.dart';
import 'package:frontend/widgets/ranking_card.dart';

class CustomRankingModal extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final VoidCallback onConfirm;
  final List<Ranking> rankingList; // ranking 리스트

  const CustomRankingModal({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText,
    required this.rankingList, // 리스트를 받아옴
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: screenHeight * 0.7,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rankingList.length,
              itemBuilder: (context, index) {
                final ranking = rankingList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: RankingCard(
                    name: ranking.member.nickname,
                    time: ranking.score,
                    imageUrl: ranking.member.memberImage?.url,
                    rank: index + 1,
                    isActive: false,
                    rankId: ranking.rankId,
                    courseId: ranking.rankId,
                    type: '',
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1C1516),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
              ),
              child: Text(
                confirmText ?? '확인',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
