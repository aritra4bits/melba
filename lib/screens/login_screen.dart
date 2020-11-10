import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:melba/screens/home_screen.dart';
import 'package:melba/screens/signup_screen.dart';
import 'package:melba/utils/user_controller.dart';
import 'package:melba/widgets/app_buttons.dart';
import 'package:melba/widgets/app_drawer.dart';
import 'package:melba/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _loginKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  String email;
  String password;

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
            key: _loginKey,
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
                  decoration: textFieldDecoration.copyWith(hintText: 'Password'),
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
                FlatButton(
                  color: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text('Forgot or Reset password?', style: TextStyle(color: Colors.white, fontSize: 14),),
                  onPressed: (){},
                ),
                SizedBox(height: 30,),
                AppButton(
                  label: 'Log in',
                  onPressed: (){
                    if (_loginKey.currentState.validate()){
                      logInToFirebase();
                    }
                  },
                ),
                SizedBox(height: 15,),
                FlatButton(
                  color: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text('Not a member? Click here to Sign-Up', style: TextStyle(color: Colors.white, fontSize: 14),),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> logInToFirebase() async {
    try{
      EasyLoading.show();
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password
      );
      print(result.user.uid);
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userType: UserType.user, email: result.user.email,)),
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
}
