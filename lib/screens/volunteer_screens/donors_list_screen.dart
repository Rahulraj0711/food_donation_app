import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/screens/volunteer_screens/accept_donation_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';
import 'package:intl/intl.dart';

class DonorsListScreen extends StatefulWidget {
  static const String id='donors_list_screen';

  @override
  _DonorsListScreenState createState() => _DonorsListScreenState();
}

Stream? donationsStream;

class _DonorsListScreenState extends State<DonorsListScreen> {
  DatabaseMethods dbMethods=DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getDonors(Constants.myCity).then((val) {
      setState(() {
        donationsStream=val;
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
        title: Text('Donations'),
      ),
      body: Stack(
        children: [
          Container(
            child: DonationsList(),
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
      )
    );
  }
}

class DonationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: donationsStream as Stream<QuerySnapshot<Object>>?,
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final donations=snapshot.data!.docs;
        List<Widget> donationTiles=[];
        for (var donation in donations) {
          final foodType=donation.get('FoodType');
          final qty=donation.get('Quantity');
          final name=donation.get('Name');
          final mobile=donation.get('Mobile');
          final cookedTime=donation.get('CookedTime');
          final timestamp=donation.get('Timestamp');
          final donationId=donation.get('DonationId');
          final city=donation.get('City');
          final donationOne=DonationTile(
            foodType,
            qty,
            name,
            mobile,
            cookedTime,
            timestamp,
            donationId,
            city,
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

class DonationTile extends StatelessWidget {
  final String? foodType;
  final int? qty;
  final String? name;
  final String? mobile;
  final String? cookedTime;
  final Timestamp? timestamp;
  final String? donationId;
  final String? city;
  DonationTile(this.foodType,this.qty,this.name,this.mobile,this.cookedTime,this.timestamp,this.donationId,this.city);

  @override
  Widget build(BuildContext context) {
    var date=DateFormat.yMMMMd('en_US').format(timestamp!.toDate());
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AcceptDonationScreen(name,foodType,qty,cookedTime,mobile,date,donationId,city)));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: kPrimaryColor)
            )
        ),
        padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
        child: Column(
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
                      fontSize: 16.0
                  ),
                ),
              ],
            ),
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name!,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}