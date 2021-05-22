import 'package:flutter/material.dart';
import 'package:food_donation_app/components/text_field_container.dart';
import 'package:food_donation_app/constants.dart';

class RoundedInputField extends StatefulWidget {
  final String? hintText;
  final TextInputType? textInputType;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.textInputType})
      : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
