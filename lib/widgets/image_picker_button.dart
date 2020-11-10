import 'dart:io';

import 'package:flutter/material.dart';
import 'package:melba/widgets/image_capture.dart';

class ImagePickerButton extends StatelessWidget {
  final File file;
  final Function callback;

  const ImagePickerButton({@required this.file, @required this.callback});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: file != null ? Colors.transparent : Colors.grey,
        image: file != null ? DecorationImage(image: Image.file(file,).image , fit: BoxFit.cover,) : null,
      ),
      child: FlatButton(
        child: file == null ? Icon(Icons.add) : SizedBox(),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCapture(imageCallback: callback,),));
        },
      ),
    );
  }
}
