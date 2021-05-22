import 'package:food_donation_app/components/auth_methods.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/screens/volunteer_screens/donated_food_history.dart';
import 'package:food_donation_app/screens/volunteer_screens/volunteer_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';

class HistoryScreen extends StatefulWidget {
  static const String id='history_screen';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  AuthMethods authMethods=AuthMethods(FirebaseAuth.instance);
  DatabaseMethods dbMethods=DatabaseMethods();

  acceptedDonations() async {
    await dbMethods.getAcceptedDonationsVolunteer(Constants.myUid).then((val) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VolunteerHistory(val)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          height: 35,
          width: 35,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Image.asset("assets/images/app_logo.png"),
          ),
        ),
        title: Text('History'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: MaterialButton(
                  padding: EdgeInsets.all(30),
                  onPressed: () async {
                    await acceptedDonations();
                  },
                  color: Colors.tealAccent,
                  elevation: 10,
                  child: Text('Accepted History'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: MaterialButton(
                  padding: EdgeInsets.all(30),
                  onPressed: () {
                    Navigator.pushNamed(context, DonatedFoodHistory.id);
                  },
                  color: Colors.tealAccent,
                  elevation: 10,
                  child: Text('Donated History'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}