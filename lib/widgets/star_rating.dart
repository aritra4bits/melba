import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int value;
  final IconData filledStar;
  final IconData unfilledStar;
  final Color activeColor;
  final Color inActiveColor;
  final void Function(int index) onChanged;
  const StarRating({
    Key key,
    this.value = 0,
    this.filledStar,
    this.unfilledStar, @required this.onChanged, this.activeColor = const Color(0xffb1232f), this.inActiveColor = const Color(0x33000000),
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).accentColor;
    final size = 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: onChanged != null
              ? () {
            onChanged(value == index + 1 ? index : index + 1);
          }
              : null,
          color: index < value ? activeColor : inActiveColor,
          iconSize: size,
          icon: Icon(
            index < value
                ? filledStar ?? Icons.star
                : unfilledStar ?? Icons.star,
          ),
          padding: EdgeInsets.zero,
          tooltip: "${index + 1} of 5",
        );
      }),
    );
  }
}
