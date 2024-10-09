import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:frontend/utils/env.dart';

class S3ImageUpload {
  final String bucketName = Env.s3Name;
  final String region = Env.s3Region;
  final String accessKey = Env.s3AccessKeyId;
  final String secretKey = Env.s3SecretAccessKey;

  S3ImageUpload();

  Dio dio = Dio();

  // 이미지 업로드 함수
  Future<String?> uploadImage(File imageFile, String folderPath) async {
    try {
      String fileName =
          'uploaded_image_${DateTime.now().millisecondsSinceEpoch}.png';
      String host = '$bucketName.s3.$region.amazonaws.com';
      String url =
          'https://${bucketName}.s3.$region.amazonaws.com/$folderPath/$fileName';

      // AWS 요구사항에 맞는 날짜 생성
      String isoDate =
          DateFormat("yyyyMMdd'T'HHmmss'Z'").format(DateTime.now().toUtc());
      String shortDate = DateFormat('yyyyMMdd').format(DateTime.now().toUtc());

      // 파일 크기와 해시값 계산
      int contentLength = imageFile.lengthSync();
      String contentSha256 =
          sha256.convert(imageFile.readAsBytesSync()).toString();

      // 헤더 생성
      Map<String, String> headers = {
        'Content-Type': 'image/png',
        'Content-Length': contentLength.toString(),
        'Host': host,
        'X-Amz-Content-Sha256': contentSha256,
        'X-Amz-Date': isoDate,
      };

      // 서명 생성 로직
      String signature = _generateSignature(
          isoDate, shortDate, contentSha256, folderPath, fileName);

      // Authorization 헤더 추가
      headers['Authorization'] =
          'AWS4-HMAC-SHA256 Credential=$accessKey/$shortDate/$region/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=$signature';

      // 헤더 및 URL 로그로 출력
      developer.log('Image Upload URL: $url');
      headers.forEach((key, value) {
        developer.log('Header - $key: $value');
      });

      // Dio 요청
      Dio dio = Dio();
      Response response = await dio.put(
        url,
        data: imageFile.openRead(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        developer.log('Image uploaded successfully: $url');
        return url;
      } else {
        developer.log(
            'Image upload failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      developer.log('Image upload failed: $e');
      return null;
    }
  }

  Future<String?> uploadImage2(File imageFile, String folderPath) async {
    try {
      String fileName =
          'uploaded_image_${DateTime.now().millisecondsSinceEpoch}.png';
      String url =
          'https://${bucketName}.s3.$region.amazonaws.com/$folderPath/$fileName';
      developer.log('아아아Image Upload URL: $url');

      // Get the length of the file
      int contentLength = await imageFile.length();

      Response response = await dio.put(
        url,
        data: imageFile.openRead(),
        options: Options(headers: {
          'Content-Type': 'image/png',
          'Content-Length': contentLength, // Set Content-Length
        }),
      );

      if (response.statusCode == 200) {
        developer.log('Image uploaded successfully: $url');
        return url;
      } else {
        developer.log(
            'Image upload failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      developer.log('Image upload failed: $e');
      return null;
    }
  }

  Future<dynamic> uploadRankingLog(File log) async {
    // TODO rankingid.json으로 변경 해야 함
    try {
      String fileName = '${DateTime.now().microsecondsSinceEpoch}';
      String url =
          'https://${bucketName}.s3.${region}.amazonaws.com/upload/ranking/${fileName}.json';
      int contentLength = await log.length();
      Response response = await dio.put(
        url,
        data: log.openRead(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Content-Length': contentLength, // Set Content-Length
        }),
      );
      if (response.statusCode == 200) {
        developer.log('RankingLog uploaded successfully: $url');
        return url;
      } else {
        developer.log(
            'RankingLog upload failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      developer.log('RankingLog upload failed: $e');
      return null;
    }

    return 1;
  }

  // 서명 생성 함수
  String _generateSignature(String isoDate, String shortDate,
      String contentSha256, String folderPath, String fileName) {
    // 여기서 AWS4 서명 생성 로직을 구현해야 합니다.
    // 예시로 서명 로직을 단순화한 것입니다.
    String signingKey = 'your_signing_key'; // 실제 서명 생성 로직 구현 필요
    String stringToSign =
        '$isoDate\n$shortDate\n$region/s3/aws4_request\n$contentSha256';
    List<int> hmacSha256 = Hmac(sha256, utf8.encode(signingKey))
        .convert(utf8.encode(stringToSign))
        .bytes;
    return base64Encode(hmacSha256);
  }
}
