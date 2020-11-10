import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:melba/constants.dart';
import 'package:melba/utils/fb_access_token.dart';

class Uploader extends StatefulWidget {
  final File firstImage;
  final File secondImage;
  final File thirdImage;

  const Uploader({@required this.firstImage, @required this.secondImage, @required this.thirdImage});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  List<File> files;

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['published'] = 'true';
    request.fields['access_token'] = FB_ACCESS_TOKEN;
    request.files.add(await http.MultipartFile.fromPath('$filename', filename));
    var res = await request.send();
    print(res.reasonPhrase);
    return res.reasonPhrase;
  }

  int imageCount;
  int totalImages;
  bool isImagesUploaded = false;
  void postImages() {
    files.forEach((element) async{
      String response = await uploadImage(element.path, "https://graph.facebook.com/me/photos");
      if(response == "OK"){
        setState(() {
          if(files.indexOf(element) + 2 <= files.length){
            imageCount = files.indexOf(element) + 2;
          }else{
            imageCount = files.length;
          }
        });
        if(imageCount == files.length+1){
          imageCount = files.length;
          Future.delayed(Duration(seconds: 1), (){
            setState(() {
              isImagesUploaded = true;
            });
          });
        }
      }
      else if(response == "Forbidden"){
        print('You don\'t have permission');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    files = [widget.firstImage, widget.secondImage, widget.thirdImage];
    totalImages = files.length;
    imageCount = 1;
    postImages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Uploading...'),
        ),
        body: Center(
          child: isImagesUploaded ? Text('All images uploaded') : Text('Uploading image ${imageCount.toString()} of ${totalImages.toString()}'),
        ),
      ),
    );
  }
}
