import 'package:food_donation_app/components/auth_methods.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/constants.dart';
import 'package:food_donation_app/screens/Login/login_screen.dart';
import 'package:food_donation_app/screens/receiver_screens/received_food_history.dart';
import 'package:food_donation_app/screens/receiver_screens/receiver_pending_requests.dart';
import 'package:food_donation_app/screens/receiver_screens/volunteers_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_app/screens/contact_screen.dart';

class ReceiverHomeScreen extends StatefulWidget {
  static const String id='receiver_home_screen';

  @override
  _ReceiverHomeScreenState createState() => _ReceiverHomeScreenState();
}

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  AuthMethods authMethods=AuthMethods(FirebaseAuth.instance);
  DatabaseMethods dbMethods=DatabaseMethods();

  List<Choice> choices = const <Choice>[
    // const Choice(title: 'Profile', icon: Icons.info_outline, color: Colors.green),
    const Choice(title: 'Sign Out', icon: Icons.exit_to_app, color: Colors.red),
  ];

  void onItemMenuPress(Choice choice) async {
    if (choice.title=='Sign Out') {
      await authMethods.signOut();
      Fluttertoast.showToast(msg: 'Signed Out Successfully!');
      Navigator.popAndPushNamed(context, LoginScreen.id);
    } else {
    }
  }

  @override
  void initState() {
    dbMethods.getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Constants.onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            height: 35,
            width: 35,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Image.asset("assets/images/app_logo.png"),
            ),
          ),
          title: Text('Receiver Home Screen'),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: [
                          Icon(
                            choice.icon,
                            color: choice.color,
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            choice.title!,
                            style: TextStyle(color: Color(0xff203152)),
                          ),
                        ],
                      )
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(40),
                  child: MaterialButton(
                    padding: EdgeInsets.all(30),
                    onPressed: () {
                      Navigator.pushNamed(context, VolunteersListScreen.id);
                    },
                    color: Colors.tealAccent,
                    elevation: 10,
                    child: Text('Request Food'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: MaterialButton(
                    padding: EdgeInsets.all(30),
                    onPressed: () {
                      Navigator.pushNamed(context, ReceiverPendingRequests.id);
                    },
                    color: Colors.tealAccent,
                    elevation: 10,
                    child: Text('Pending Requests'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: MaterialButton(
                    padding: EdgeInsets.all(30),
                    onPressed: () {
                      Navigator.pushNamed(context, ReceivedFoodHistory.id);
                    },
                    color: Colors.tealAccent,
                    elevation: 10,
                    child: Text('Received History'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: MaterialButton(
                    padding: EdgeInsets.all(30),
                    onPressed: () {
                      Navigator.pushNamed(context, ContactScreen.id);
                    },
                    color: Colors.tealAccent,
                    elevation: 10,
                    child: Text('Contact'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.color});

  final String? title;
  final IconData? icon;
  final Color? color;
}