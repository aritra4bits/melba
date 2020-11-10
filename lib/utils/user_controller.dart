import 'package:flutter/material.dart';
import 'package:melba/constants.dart';
import 'package:melba/screens/home_screen.dart';

class UserController{
  UserType userType = UserType.guest;

  loginUser({userEmail, password, context}){
    if(userEmail == "user@email.com" && password == "user@123"){
      userType = UserType.user;
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userType: UserType.user,),));
    } else if(userEmail == "admin@email.com" && password == "admin@123"){
      userType = UserType.admin;
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userType: UserType.admin,),));
    } else {
      return 'Wrong credentials, try again';
    }
  }
}