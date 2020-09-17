import 'dart:convert';
import 'dart:io';

import 'package:face_recognition/style.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  File _imageFile;
  Object data;
  String name;

  Future<void> _pickImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(
      source: source,
      maxHeight: 240.0,
      maxWidth: 240.0,
    );

    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      // String fileName = path.basename(_imageFile.path);

      setState(() {
        _imageFile = croppedFile;
      });
    } else
      return;
  }

  upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://2352a82c3edc.ngrok.io/api/verify");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {}

    print("*************hey*******************");
    // listen for response
    print("this is my response " + "$response");
    response.stream.transform(utf8.decoder).listen(
      (value) {
        print("value" + value.toString());

        setState(() {
          data = value;
          //name = data
        });
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A9E8E),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: 80.0,
            ),
            Text(
              'Login Page',
              style: TextStyle(
                  color: whiteColor, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: screenHeight(context) * 0.4,
              decoration: BoxDecoration(
                //color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Center(
                child: _imageFile != null
                    ? Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      )
                    : Image.asset("assets/img/user.png"),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: CircleAvatar(
                child: IconButton(
                    icon: Icon(
                      Icons.camera,
                      color: whiteColor,
                    ),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    }),
                backgroundColor: orangeColor,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              width: screenWidth(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      //borderRadius: Radius.circular()
                      ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  color: orangeColor,
                  onPressed: () {
                    upload(_imageFile);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
