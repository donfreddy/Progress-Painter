import 'dart:convert';
import 'dart:io';

import 'package:face_recognition/screens/%20login.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:face_recognition/style.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File _imageFile;
  String base64Image;
  String name;
  List<int> imageBytes;

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
        var imagelength = _imageFile.lengthSync();
        print("hey**********************************************");
        print(imagelength);
        print("hey**********************************************");
        imageBytes = _imageFile.readAsBytesSync();
        print("**********************Image File********************");
        print(imageBytes.length);
        print("**********************Image File********************");
      });
    } else
      return;
  }

  upload(context, File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://2352a82c3edc.ngrok.io/api/register");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);
    var data = {"username": name};
    // request.fields.addAll(data);
    request.headers.addAll(data);
    request.fields['username'] = name;

    // send
    var response = await request.send();

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
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
              'Register Page',
              style: TextStyle(
                  color: whiteColor, fontSize: 40, fontWeight: FontWeight.bold),
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
              height: 30.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  icon: Icon(Icons.person),
                  border: InputBorder.none,
                ),
                onChanged: (String value) {
                  setState(() {
                    name = value;
                    print(name);
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
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
                    upload(context, _imageFile);
                  },
                  child: Text(
                    "Register",
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
