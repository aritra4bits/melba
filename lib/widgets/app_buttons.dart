import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const AppButton({Key key, @required this.label, @required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffb2232b), Color(0xffea5b28)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
          ),
          child: FlatButton(
            color: Colors.transparent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
            child: Text(label, style: TextStyle(color: Colors.white, fontSize: 18),),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
