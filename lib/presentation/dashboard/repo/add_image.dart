import 'dart:developer';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';

class ReciptImage {
  // Imgur use gareko imit cross vayo re aaba google photos use garna lako
  final String clientId = "9142a9da32949ae";
  Dio dio = Dio();

  Future<String?> uploadImage(File image) async {
    try {
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
      log(e.toString());
      rethrow;
    }
    return null;
  }

  Future<String?> uploadPhotoUsingCloudinary({required File imageFile}) async {
    final cloudinary = Cloudinary.signedConfig(
      apiKey: '986446797262225',
      apiSecret: 'zEas8k1R6lghFS57FQIaWwy-aSs',
      cloudName: 'dekt3muqv',
    );

    try {
      CloudinaryResponse response = await cloudinary.upload(
        file: imageFile.path,
        folder: 'flutter_app_images/',
      );
      if (response.isSuccessful) {
        log(response.secureUrl.toString());

        return response.secureUrl;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
