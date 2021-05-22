import 'package:food_donation_app/components/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/components/donor_history_helper.dart';
import 'package:food_donation_app/constants.dart';

class AcceptedDonations extends StatefulWidget {
  static const String id = 'accepted_donations';

  @override
  _AcceptedDonationsState createState() => _AcceptedDonationsState();
}

Stream? donationsStream;

class _AcceptedDonationsState extends State<AcceptedDonations> {
  DatabaseMethods dbMethods = DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getAcceptedDonationsDonor(Constants.myUid).then((val) {
      setState(() {
        donationsStream = val;
      });
    });
    isLoading = false;
    super.initState();
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
          title: Text('Accepted Donations'),
        ),
        body: Stack(
          children: [
            Container(
              child: DonationsList(donationsStream),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ));
  }
}
