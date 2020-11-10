
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melba/screens/home_screen.dart';
import '../constants.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    await Firebase.initializeApp();
    User result = FirebaseAuth.instance.currentUser;

    Future.delayed(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(userType: result != null ? UserType.user : UserType.guest, email: result != null ? result.email : null)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Center(
        child: Image.asset('assets/images/logo.png', height: 150, width: 150,),
      ),
    );
  }
}
