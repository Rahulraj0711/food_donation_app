import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/constants.dart';
import 'package:food_donation_app/screens/volunteer_screens/volunteer_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AcceptDonationScreen extends StatefulWidget {
  final String? name;
  final String? foodType;
  final int? qty;
  final String? cookedTime;
  final String? mobile;
  final String date;
  final String? donationId;
  final String? city;
  AcceptDonationScreen(this.name,this.foodType,this.qty,this.cookedTime,this.mobile,this.date,this.donationId,this.city);

  @override
  _AcceptDonationScreenState createState() => _AcceptDonationScreenState();
}

class _AcceptDonationScreenState extends State<AcceptDonationScreen> {
  DatabaseMethods dbMethods=DatabaseMethods();

  @override
  void initState() {
    dbMethods.getUserInfo();
    super.initState();
  }

  showAlertDialogBox(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget acceptButton = TextButton(
      child: Text("Accept"),
      onPressed:  () async {
        await dbMethods.updateDonationStatus(widget.donationId);
        Map<String,dynamic> acceptedDonationDetailsMap=({
          'FoodType': widget.foodType,
          'Qty': widget.qty,
          'Name': widget.name,
          'Date': widget.date,
          'Status': 'Available',
          'DonationId': widget.donationId,
        });
        await dbMethods.uploadAcceptedDonations(acceptedDonationDetailsMap, Constants.myUid, widget.donationId);
        Map<String,dynamic> volunteerDetailsMap=({
          'Name': Constants.myName,
          'Mobile': Constants.myMobileNo,
          'City': Constants.myCity,
          'Uid': Constants.myUid,
        });
        await dbMethods.uploadVolunteersWithDonation(volunteerDetailsMap, Constants.myUid);
        Fluttertoast.showToast(msg: 'Donation Accepted Successfully!');
        Navigator.popAndPushNamed(context, VolunteerHomeScreen.id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Are you sure you want to accept donation?"),
      actions: [
        cancelButton,
        acceptButton,
      ],
      elevation: 10,
      backgroundColor: kPrimaryLightColor,

    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Donor Name:  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.name!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Food Type:  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.foodType!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Food Quantity:  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.qty.toString()+' kg',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cooked Time:  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.cookedTime!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mobile No.:  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.mobile!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Date:  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.date,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 26,),
            GestureDetector(
              onTap: () async {
                await Constants.makePhoneCall("tel: "+widget.mobile!);
              },
              child: Material(
                color: Colors.green,
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Call',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
            SizedBox(height: 26,),
            GestureDetector(
              onTap: () {
                showAlertDialogBox(context);
              },
              child: Material(
                color: kPrimaryColor,
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Accept Donation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
