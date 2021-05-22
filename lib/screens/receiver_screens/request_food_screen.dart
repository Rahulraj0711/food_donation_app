import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RequestFoodScreen extends StatefulWidget {
  final String? uid;
  final String? name;
  final String? mobile;
  RequestFoodScreen(this.uid,this.name,this.mobile);

  @override
  _RequestFoodScreenState createState() => _RequestFoodScreenState();
}

Stream? acceptedDonationsStream;
DatabaseMethods dbMethods=DatabaseMethods();

class _RequestFoodScreenState extends State<RequestFoodScreen> {
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getAcceptedDonations(widget.uid).then((val) {
      setState(() {
        acceptedDonationsStream=val;
      });
    });
    isLoading=false;
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
        title: Text('Available Food'),
      ),
      body: Stack(
        children: [
          Container(
            child: AcceptedDonationsList(widget.uid,widget.name,widget.mobile),
          ),
          Positioned(
            child: isLoading ?
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.8),
            ) :
            Container(),
          ),
        ],
      ),
    );
  }
}

class AcceptedDonationsList extends StatelessWidget {
  final String? volunteerUid;
  final String? volunteerName;
  final String? volunteerMobile;
  AcceptedDonationsList(this.volunteerUid,this.volunteerName,this.volunteerMobile);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: acceptedDonationsStream as Stream<QuerySnapshot<Object>>?,
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final acceptedDonations=snapshot.data!.docs;
        List<Widget> donationTiles=[];
        for (var acceptedDonation in acceptedDonations) {
          final foodType=acceptedDonation.get('FoodType');
          final qty=acceptedDonation.get('Qty');
          final name=acceptedDonation.get('Name');
          final donationId=acceptedDonation.get('DonationId');
          final donationOne=AcceptedDonationTile(
            foodType,
            qty,
            name,
            donationId,
            volunteerUid,
            volunteerName,
            volunteerMobile,
          );
          donationTiles.add(donationOne);
        }
        return Scrollbar(
          child: ListView(
            reverse: false,
            children: donationTiles,
          ),
        );
      },
    );
  }
}

class AcceptedDonationTile extends StatelessWidget {
  final String? foodType;
  final int? qty;
  final String? name;
  final String? donationId;
  final String? volunteerUid;
  final String? volunteerName;
  final String? volunteerMobile;
  AcceptedDonationTile(this.foodType,this.qty,this.name,this.donationId,this.volunteerUid,this.volunteerName,this.volunteerMobile);

  @override
  Widget build(BuildContext context) {

    int? _chosenValue;
    List<int> options=[];

    for(int i=1;i<=qty!;i++) {
      options.add(i);
    }

    requestFood() async {
      Map<String,dynamic> foodRequestDetailsMap1= {
        'FoodType': foodType,
        'Qty': _chosenValue,
        'DonationId': donationId,
        'ReceiverName': Constants.myName,
        'ReceiverNo': Constants.myMobileNo,
        'ReceiverId': Constants.myUid,
        'Status': 'Pending',
        'RequestId':'',
      };
      Map<String,dynamic> foodRequestDetailsMap2= {
        'FoodType': foodType,
        'Qty': _chosenValue,
        'DonationId': donationId,
        'VolunteerName': volunteerName,
        'VolunteerMobile': volunteerMobile,
        'Status': 'Not Received',
        'RequestId':'',
      };
      await dbMethods.uploadFoodRequest(foodRequestDetailsMap1, foodRequestDetailsMap2, volunteerUid, Constants.myUid);
    }

    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          duration: Duration.zero,
          enableDrag: true,
          isDismissible: true,
          animationCurve: Curves.easeOutCirc,
          backgroundColor: kPrimaryLightColor,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context,setState) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      DropdownButton<int>(
                        iconEnabledColor:Colors.black,
                        focusColor:Colors.white,
                        value: _chosenValue,
                        items: options.map<DropdownMenuItem<int>>((int val) {
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text(val.toString()),
                          );
                        }).toList(),
                        hint: Text(
                          "Select quantity of food",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        onChanged: (newVal) {
                          setState(() {
                            _chosenValue=newVal;
                          });
                        },
                      ),
                      SizedBox(height: 30,),
                      MaterialButton(
                        onPressed: () async {
                          await requestFood();
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'Food Request Successfully Sent!');
                          Navigator.pop(context);
                        },
                        color: kPrimaryColor,
                        elevation: 20,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Request Food',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                );
              },
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: kPrimaryColor)
            )
        ),
        padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  foodType!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0
                  ),
                ),
                Text(
                  qty.toString()+' kg',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0
                  ),
                ),
              ],
            ),
            SizedBox(height: 6,),
            Text(
              'Donor Name: '+name!,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0
              ),
            ),
          ],
        ),
      ),
    );
  }
}
