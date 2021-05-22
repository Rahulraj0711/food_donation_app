import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';

class ContactScreen extends StatelessWidget {
  static const String id='contact_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: kPrimaryColor, width: 5),
              right: BorderSide(color: kPrimaryColor, width: 5),
              top: BorderSide(color: kPrimaryColor, width: 5),
              bottom: BorderSide(color: kPrimaryColor, width: 5),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    child: Image.asset("assets/images/app_logo.png"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  child: Text(
                    'Rahul',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  '177r1a05m9@gmail.com',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 8,),
            ],
          )
        ),
      ),
    );
  }
}
