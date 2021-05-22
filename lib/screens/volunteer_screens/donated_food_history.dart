import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';

class DonatedFoodHistory extends StatefulWidget {
  static const String id='donated_food_history';

  @override
  _DonatedFoodHistoryState createState() => _DonatedFoodHistoryState();
}

Stream? donatedFoodStream;

class _DonatedFoodHistoryState extends State<DonatedFoodHistory> {
  DatabaseMethods dbMethods=DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getDonatedFoodHistory(Constants.myUid).then((val) {
      setState(() {
        donatedFoodStream=val;
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
          title: Text('Confirmed Donations'),
        ),
        body: Stack(
          children: [
            Container(
              child: DonatedFoodList(),
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

class DonatedFoodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: donatedFoodStream as Stream<QuerySnapshot<Object>>?,
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final donatedFood=snapshot.data!.docs;
        List<Widget> donatedFoodTiles=[];
        for (var food in donatedFood) {
          final foodType=food.get('FoodType');
          final qty=food.get('Qty');
          // final status=request.get('Status');
          final receiverName=food.get('ReceiverName');
          final receiverMobile=food.get('ReceiverNo');
          final donationOne=DonatedFoodTile(
            foodType,
            qty,
            receiverName,
            receiverMobile,
          );
          donatedFoodTiles.add(donationOne);
        }
        return Scrollbar(
          child: ListView(
            reverse: false,
            children: donatedFoodTiles,
          ),
        );
      },
    );
  }
}

class DonatedFoodTile extends StatelessWidget {
  final String? foodType;
  final int? qty;
  final String? receiverName;
  final String? receiverMobile;
  DonatedFoodTile(this.foodType,this.qty,this.receiverName,this.receiverMobile);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    fontSize: 16.0
                ),
              ),
            ],
          ),
          SizedBox(height: 6,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Receiver Name: '+receiverName!,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0
                ),
              ),
              Text(
                'Contact: '+receiverMobile!,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
