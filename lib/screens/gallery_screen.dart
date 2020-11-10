import 'dart:io';

import 'package:flutter/material.dart';
import 'package:melba/constants.dart';
import 'package:melba/service/facebook_api_call.dart';
import 'package:melba/widgets/image_capture.dart';
import 'package:melba/widgets/image_picker_button.dart';
import 'package:melba/widgets/uploader.dart';
import 'package:photo_view/photo_view.dart';

class GalleryScreen extends StatefulWidget {
  final UserType userType;

  const GalleryScreen({Key key, this.userType}) : super(key: key);
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> fbImages = [];
  Future<void> fetchData() async{
    await FacebookAPICall.fetchFbData(limit: 20);
    int count = 0;
    for(int i = 0; i < FacebookAPICall.fbData.length; i++){
      if(FacebookAPICall.fbData[i].fullPicture != null){
        fbImages.insert(count, FacebookAPICall.fbData[i].fullPicture);
        if(count == numberOfImagesInGallery-1){
          break;
        }
        count++;
      }
    }
    setState(() {});
  }

  File firstFile;
  File secondFile;
  File thirdFile;

  imageCallback1(image){
    setState(() {
      firstFile = image;
    });
  }
  imageCallback2(image){
    setState(() {
      secondFile = image;
    });
  }
  imageCallback3(image){
    setState(() {
      thirdFile = image;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Gallery'),
        ),
        body: _galleryView(),
      ),
    );
  }

  Widget _galleryView(){
    Orientation orientation = MediaQuery.of(context).orientation;
    if(widget.userType == UserType.user || widget.userType == UserType.guest){
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
        itemCount: fbImages.length,
        itemBuilder: (context, index) {
          return _galleryItem(fbImages[index]);
        },
      );
    } else {
      return ListView(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
            itemCount: fbImages.length,
            itemBuilder: (context, index) {
              return _galleryItem(fbImages[index]);
            },
          ),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImagePickerButton(file: firstFile, callback: imageCallback1),
                ImagePickerButton(file: secondFile, callback: imageCallback2),
                ImagePickerButton(file: thirdFile, callback: imageCallback3),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              color: Color(0xff3d5a98),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/facebook_logo.png', width: 18, height: 18,),
                  SizedBox(width: 5,),
                  Text('Share', style: TextStyle(color: Colors.white, fontSize: 18),),
                  SizedBox(width: 5,),
                ],
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Uploader(firstImage: firstFile, secondImage: secondFile, thirdImage: thirdFile),));
              },
            ),
          ),
          SizedBox(height: 20,),
        ],
      );
    }
  }

  Widget _galleryItem(String postImages){
    return Hero(
      tag: postImages,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: Image.network(postImages).image , fit: BoxFit.cover,),
        ),
        child: FlatButton(
          child: SizedBox(),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroPhotoViewRouteWrapper(
                  imageProvider: NetworkImage(postImages),
                  tag: postImages,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale, this.tag,
  });

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: PhotoViewHeroAttributes(tag: tag),
      ),
    );
  }
}
