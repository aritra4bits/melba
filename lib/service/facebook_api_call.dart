import 'package:flutter/cupertino.dart';
import 'package:melba/data_models/facebook_data_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:melba/utils/fb_access_token.dart';

class FacebookAPICall{
  static List<FacebookData> fbData = [];
  static Client client = Client();
  static Future fetchFbData({@required int limit}) async{
    String _fbUrl = "https://graph.facebook.com/me?fields=id,name,posts.limit($limit){full_picture,message}&access_token=$FB_ACCESS_TOKEN";
    try{
      final response = await client.get(_fbUrl);
      if(response.statusCode == 200){
        Iterable l = json.decode(response.body)['posts']['data'];
        print(response.body);
        fbData = l.map((i) => FacebookData.fromJson(i)).toList();
      }
    }catch(_){
      print(_.toString());
    }
  }
}