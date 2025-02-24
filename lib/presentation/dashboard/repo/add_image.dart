import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class ReciptImage {
  final String clientId = "9142a9da32949ae";

  Future<String?> uploadImage(File image) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      Response response = await dio.post(
        'https://api.imgur.com/3/image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Client-ID $clientId',
          },
        ),
      );
      if (response.statusCode == 200) {
        log(response.data.toString());
        // saveImageUrlToFirestore(uid, response.data['data']['link']);
        return response.data['data']['link']; // image url
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
