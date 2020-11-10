import 'package:flutter/material.dart';
import 'package:melba/screens/splash_screen.dart';



main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melba',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(color: Color(0xffb82228),),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
