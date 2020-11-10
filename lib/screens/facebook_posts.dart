import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class FacebookPosts extends StatefulWidget {
  @override
  _FacebookPostsState createState() => _FacebookPostsState();
}

class _FacebookPostsState extends State<FacebookPosts> {
  @override
  void initState() {
    super.initState();
    fetchFacebookPosts();
  }

  var posts;

  Future fetchFacebookPosts() async{
    final response = await http.get(
        'https://www.facebook.com/MelbourneBengaliAssociation/');
    var document = parse(response.body);
    setState(() {
      posts = document.getElementsByClassName('_5pbx userContent _3576');
    });
    print(removeAllHtmlTags(posts[0].innerHtml.toString()));
    print(removeAllHtmlTags(posts[1].innerHtml.toString()));
    print(removeAllHtmlTags(posts[2].innerHtml.toString()));
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: posts == null ? Center(child: Text('Loading...'),) : ListView(
        children: List.generate(2, (index) {
          String post = removeAllHtmlTags(posts[index].innerHtml.toString());
          return Text(post);
        }),
      ),
    );
  }
}
