import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankingCard extends StatelessWidget {
  final String name;
  final String time;
  final String? imageUrl;
  final int rank;
  final bool isActive;
  final int rankId;
  final int courseId;
  final String type;

  const RankingCard(
      {super.key,
      required this.name,
      required this.time,
      required this.imageUrl,
      required this.rank,
      required this.isActive,
      required this.rankId,
      required this.courseId,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl ?? 'assets/images/auth/default_profile.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xffE4E4E4), width: 2),
                        ),
                        child: Image.asset(
                          'assets/images/auth/default_profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (rank <= 3)
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: rank == 1
                          ? Image.asset(
                              'assets/images/medals/gold_medal.png',
                              height: 30,
                              fit: BoxFit.cover,
                            )
                          : rank == 2
                              ? Image.asset(
                                  'assets/images/medals/silver_medal.png',
                                  height: 30,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/medals/bronze_medal.png',
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                    ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Color(0xff6C7072),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isActive)
            ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  '/running/${type}/${courseId}/$rankId',
                  parameters: {'varid': rankId.toString()},
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
