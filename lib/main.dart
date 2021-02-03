import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:flutter_amazon_s3/flutter_amazon_s3.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  String imageUrl;
  final picker = ImagePicker();

  Future uploadFile() async {
    debugPrint('in a upload file function');
    String BUCKET_NAME = "flutter-demo";
    String IDENTITY_POOL_ID = "ap-south-1:e08ddd20-6ae1-45bc-a5c9-e03d5562b929";
    String IMAGE_NAME = imageUrl;
    String REGION = 'ap-south-1';
    
   // String uploadedImageUrl = await AmazonS3Cognito.uploadImage(
    //      _image.path, BUCKET_NAME, IDENTITY_POOL_ID);
   
    // String uploadedImageUrl = await AmazonS3Cognito.upload(
    //         _image.path,
    //         BUCKET_NAME,
    //         IDENTITY_POOL_ID,
    //         IMAGE_NAME,
    //         AwsRegion.AP_SOUTH_1,
    //         AwsRegion.AP_SOUTH_1);

    String uploadedImageUrl = await FlutterAmazonS3.uploadImage(
          _image.path, BUCKET_NAME, IDENTITY_POOL_ID, REGION);

    debugPrint('uploadedImageUrl: $uploadedImageUrl');

  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // notify the framework that internal state of obj is changed
    setState(() {
      debugPrint('movieTitle: $pickedFile.path');
      imageUrl = pickedFile.path;
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            child: _image == null ? Text("image is not Loaded") : Image.file(_image),
          ),
           RaisedButton(
             onPressed: uploadFile,
              child: Text("Upload"),
             )
        ],
      ),
      

      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Increment',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
