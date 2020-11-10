import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:melba/data_models/sign_up_response_model.dart';
import 'package:melba/screens/home_screen.dart';
import 'package:melba/screens/login_screen.dart';
import 'package:melba/widgets/app_buttons.dart';
import 'package:melba/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final _signUpKey = GlobalKey<FormState>();
  String email;
  String password;
  String repeatPassword;
  bool willSendNotifications = false;
  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: Container(
        decoration: kBackgroundDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Login'),
          ),
          drawer: AppDrawer(userType: UserType.guest,),
          body: Form(
            key: _signUpKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              children: [
                Image.asset('assets/images/logo.png', height: 100, width: 100,),
                SizedBox(height: 30,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.blue,
                  cursorHeight: 22,
                  decoration: textFieldDecoration.copyWith(hintText: 'Your email ID'),
                  validator: (value) {
                    if(value.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                      return 'Bad email format, correct format is user@domain.com';
                    }
                    email = value;
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.blue,
                  cursorHeight: 22,
                  decoration: textFieldDecoration.copyWith(hintText: 'New password'),
                  validator: (value) {
                    // Pattern pattern =
                    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$';
                    // RegExp regex = new RegExp(pattern);
                    if (value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    // if (!regex.hasMatch(value)) {
                    //   return 'Password must contain at least a upper case and lowercase letter, a number and a special character';
                    // }
                    password = value;
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: Colors.blue,
                  cursorHeight: 22,
                  decoration: textFieldDecoration.copyWith(hintText: 'Re-enter password'),
                  validator: (value) {
                    // Pattern pattern =
                    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$';
                    // RegExp regex = new RegExp(pattern);
                    if (value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if(value != password){
                      return 'Passwords don\'t match';
                    }
                    // if (!regex.hasMatch(value)) {
                    //   return 'Password must contain at least a upper case and lowercase letter, a number and a special character';
                    // }
                    repeatPassword = value;
                    return null;
                  },
                ),
                SizedBox(height: 15,),
                StatefulBuilder(
                  builder: (context, setState) {
                    return CheckboxListTile(
                      title: Text('Send Messages / Notifications', style: TextStyle(color: Colors.white, fontSize: 14),),
                      checkColor: Colors.red[900],
                      activeColor: Colors.red[400],
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      value: willSendNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          willSendNotifications = value;
                        });
                      },
                    );
                  }
                ),
                SizedBox(height: 30,),
                AppButton(
                  label: 'Sign Up',
                  onPressed: (){
                    if(_signUpKey.currentState.validate()){
                      registerToFirebase(context);
                    }
                  },
                ),
                SizedBox(height: 10,),
                FlatButton(
                  color: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text('Existing member? Click here to Sign-In', style: TextStyle(color: Colors.white, fontSize: 14),),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> registerToFirebase(context) async {
    try{
      EasyLoading.show();
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      print(result.user.uid);
      SignUpResponseModel response = await addMemberDetails(email: email, opted: willSendNotifications, userId: result.user.uid);
      print(response.result);
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userType: UserType.user, email: email,)),
      );
    }catch(err){
      EasyLoading.dismiss();
      print(err.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(err.message),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }
  Future<SignUpResponseModel> addMemberDetails({String email, bool opted, userId}) async{
    final http.Response response = await http.post(
      'https://us-central1-melba-flutter.cloudfunctions.net/app/addMemberDetails',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email_id" : email,
        "member_type" : "registered",
        "opted_notification" : opted ? "YES" : "NO",
        "device_token" : userId,
        "status": "logged-in",
        "e-wallet": "array of ewallet items"
      }),
    );
    print('StatusCode: ${response.statusCode}');
    print('ResponseBody : ${response.body}');

    if (response.statusCode == 200) {
      return SignUpResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return SignUpResponseModel.fromJson(jsonDecode(response.body));
      //throw Exception('Failed to store details');
    }
  }
}

