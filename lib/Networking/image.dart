import 'dart:convert';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:on_ways/utilities/custom_button.dart';

class ImageUploadScreen extends StatefulWidget {
  static const routename = '/image_upload';
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  String imageUrl = 'no data';
  final DefaultUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTHp7HDUzfrraXrobnp_eKUtNeFiq9E8NklA&usqp=CAU';

  Future<void> _uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    String cloudinaryUrl =
        'https://api.cloudinary.com/v1_1/${dotenv.env['CLOUDINARY_CLOUD_NAME']}/upload';
    String apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    String apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

    var stream = http.ByteStream(Stream.castFrom(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse(cloudinaryUrl);

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: image.path.split('/').last);

    request.files.add(multipartFile);
    request.fields['upload_preset'] =
        'o29qplvp'; // Add your upload preset name from Cloudinary

    var response = await request.send();
    var result = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(result.body);
      setState(() {
        imageUrl = responseData['secure_url'];
        print(imageUrl);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Image Upload')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl != 'no data'
                ? Image.network(imageUrl)
                : Text('No image selected'),
            imageUrl != 'no data'
                ? ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Select and Upload Image 1 time only'),
                  )
                : CustomButton(
                    dimensions: dimensions,
                    label: 'Click to Choose this image',
                    action: () {
                      Navigator.pop(context,
                          imageUrl == 'no data' ? DefaultUrl : imageUrl);
                    })
          ],
        ),
      ),
    );
  }
}
