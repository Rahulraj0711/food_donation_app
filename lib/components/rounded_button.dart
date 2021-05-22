import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press as void Function()?,
          child: Text(
            text!,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
