import 'package:intl/intl.dart';

class Auth {
  final String email;
  final String nickname;
  final DateTime? birth;
  final int? gender; // 0 또는 1로 구분
  final int? height;
  final int? weight;
  final MemberImage? memberImage;
  final String joinType;

  Auth({
    required this.email,
    required this.nickname,
    this.birth,
    this.gender,
    this.height,
    this.weight,
    this.memberImage,
    required this.joinType,
  });

  // copyWith 메서드 추가
  Auth copyWith({
    String? email,
    String? nickname,
    DateTime? birth,
    int? gender,
    int? height,
    int? weight,
    MemberImage? memberImage,
    String? joinType,
  }) {
    return Auth(
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      memberImage: memberImage ?? this.memberImage,
      joinType: joinType ?? this.joinType,
    );
  }

  // JSON 변환 및 파싱은 그대로 유지
  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      // TODO
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      joinType: json['joinType'],
      memberImage: json['memberImage'] != null
          ? MemberImage.fromJson(json['memberImage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickname': nickname,
      'birth': birth != null
          ? DateFormat('yyyy-MM-dd').format(birth!) // 올바르게 포맷 적용
          : null,
      'gender': gender,
      'height': height,
      'weight': weight,
      'joinType': joinType,
      'memberImage': memberImage?.toJson(),
      // 'memberImage': memberImage != null ? memberImage!.toJson() : null,
    };
  }
}

class MemberImage {
  final int? memberId;
  final String? url;
  final String? path;

  MemberImage({
    this.memberId,
    this.url,
    this.path,
  });

  // JSON 변환을 위한 fromJson 메서드
  factory MemberImage.fromJson(Map<String, dynamic> json) {
    return MemberImage(
      memberId: json['memberId'],
      url: json['url'],
      path: json['path'],
    );
  }

  // JSON으로 변환하기 위한 toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'url': url,
      'path': path,
    };
  }
}
