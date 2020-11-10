import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:melba/widgets/uploader.dart';

import 'app_buttons.dart';
class ImageCapture extends StatefulWidget {
  final Function(File) imageCallback;

  const ImageCapture({this.imageCallback});
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  final picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(toolbarTitle: 'Crop Image'),
      iosUiSettings: IOSUiSettings(title: 'Crop Image'),
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera, color: Color(0xffef4726),),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo_library, color: Color(0xffef4726),),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),

        // Preview the image and crop it
        body: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              if (_imageFile != null) ...[

                Container(
                  alignment: Alignment.center,
                  child: Image.file(_imageFile, fit: BoxFit.cover,),
                ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.crop, color: Color(0xffef4726),),
                        onPressed: _cropImage,
                      ),
                      FlatButton(
                        child: Icon(Icons.refresh, color: Color(0xffef4726),),
                        onPressed: _clear,
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: AppButton(
                    label: 'Done',
                    onPressed: (){
                      widget.imageCallback(_imageFile);
                      Navigator.pop(context);
                    },
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
