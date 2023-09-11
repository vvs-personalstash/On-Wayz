import 'dart:convert';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/cupertino.dart';
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
  File? imageFile;
  String imageUrl = 'no data';
  final DefaultUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTHp7HDUzfrraXrobnp_eKUtNeFiq9E8NklA&usqp=CAU';

  Future<void> _uploadImage(XFile? image) async {
    //  final ImagePicker _picker = ImagePicker();
    //  XFile? image = await _picker.pickImage(source: ImageSource.gallery);

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

  XFile? MyPickedFile = null;
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        MyPickedFile = pickedFile;
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        MyPickedFile = pickedFile;
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: const Icon(CupertinoIcons.multiply,
                  color: Colors.grey, size: 30),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Image Upload',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageFile == null
                  ? Text('No image selected')
                  : Container(
                      height: 480, width: 480, child: Image.file(imageFile!)),
              ElevatedButton(
                onPressed: () {
                  _getFromGallery();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xFF1d2d59), // Background color
                ),
                child: Container(
                  width: dimensions.width * 0.55,
                  child: Row(
                    children: [
                      Icon(Icons.photo, color: Colors.white, size: 20),
                      SizedBox(
                        width: 3,
                      ),
                      Text("PICK FROM GALLERY"),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _getFromCamera();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xFF1d2d59), // Background color
                ),
                child: Container(
                  width: dimensions.width * 0.55,
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(
                        width: 3,
                      ),
                      Text("PICK FROM CAMERA"),
                    ],
                  ),
                ),
              ),
              imageFile == null
                  ? Container()
                  : CustomButton(
                      dimensions: dimensions,
                      label: 'Click to Choose this image',
                      action: () async {
                        await _uploadImage(MyPickedFile);
                        Navigator.pop(context,
                            imageUrl == 'no data' ? DefaultUrl : imageUrl);
                      })
            ],
          ),
        ),
      ),
    );
  }
}
