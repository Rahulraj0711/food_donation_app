import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

class Constants {
  static String? myName = '';
  static String? myUid = '';
  static String? myEmail = '';
  static String? myMobileNo = '';
  static String myCity = '';
  static String? myType = '';
  static String appName = 'DonateFood';

  static Future<bool> onBackPressed(){
    return SystemNavigator.pop().then((value) => value as bool);
  }

  static Future<void> makePhoneCall(String url) async {
    if(await canLaunch(url)) {
      await launch(url);
    }
    else {
      print(url);
      Fluttertoast.showToast(msg: "Could not launch");
    }
  }

  static Widget callButton({required mobileNo}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 140),
      child: ElevatedButton(
        onPressed: () async {
          await Constants.makePhoneCall("tel: "+mobileNo);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.call,
              size: 20,
            ),
            SizedBox(width: 10,),
            Text(
              "Call",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget callButtonTile({required mobileNo}) {
    return ElevatedButton(
      onPressed: () async {
        await Constants.makePhoneCall("tel: "+mobileNo);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      child: Icon(
        Icons.call,
        size: 20,
      ),
    );
  }
}
