import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:melba/data_models/facebook_data_model.dart';
import 'package:melba/service/facebook_api_call.dart';
import 'package:melba/widgets/app_drawer.dart';
import 'package:melba/constants.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("inBackground");
  print(message);
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Data : $data");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("Notification : $notification");
  }

  if (message.containsKey('title')) {
    final dynamic title = message['title'];
    print("title : $title");
  }
  // Or do other work.
  print("Message : ${message.toString()}");
}

class HomeScreen extends StatefulWidget {
  final UserType userType;
  final String email;
  const HomeScreen({Key key, this.userType = UserType.guest, this.email}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<FacebookData> fbData = [];
  @override
  void initState() {
    super.initState();
    fetchData();
    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_stat_name');

    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        displayNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        onMessageArrive(message['data']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        onMessageArrive(message['data']);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics =
        new AndroidNotificationDetails("melba", 'Melba', 'Melba Notification Channel', importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: message['notification']['body'],
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification'),
        content: Text('$payload'),
      ),
    );
  }

  onMessageArrive(Map data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${data['title']}'),
        content: Text('${data['body']}'),
        actions: [
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Color(0xffb2232b)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();

              // On select iOS notification
            },
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    await FacebookAPICall.fetchFbData(limit: 1);
    if (mounted) {
      setState(() {
        fbData = FacebookAPICall.fbData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fbData.isEmpty) {
      return Container(
        decoration: kBackgroundDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: Center(
            child: SpinKitCircle(
              color: Colors.red[900],
              size: 50,
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: kBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: AppDrawer(userType: widget.userType),
        body: ListView(
          children: [
            Image.asset('assets/images/melba_bg.jpg', fit: BoxFit.fitWidth),
            SizedBox(
              height: 20,
            ),
            _buildPostItems(context, fbData[0]),
            SizedBox(
              height: 20,
            ),
            Image.asset('assets/images/melba_bg.jpg', fit: BoxFit.fitWidth),
          ],
        ),
      ),
    );
  }

  _buildPostItems(context, FacebookData post) {
    String message = post.message ?? null;
    String image = post.fullPicture ?? null;
    if(image == null){
      return Text(
        message,
        style: TextStyle(color: Colors.white),
      );
    } else if(message == null){
      return ClipRRect(
        child: Image.network(image),
        borderRadius: BorderRadius.circular(15),
      );
    }
    return Column(
      children: [
        ClipRRect(
          child: Image.network(image),
          borderRadius: BorderRadius.circular(15),
        ),
        SizedBox(height: 20,),
        Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
