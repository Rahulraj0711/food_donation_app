import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FoodRequests extends StatefulWidget {
  static const String id='food_requests';

  @override
  _FoodRequestsState createState() => _FoodRequestsState();
}

Stream? requestsStream;
DatabaseMethods dbMethods=DatabaseMethods();

class _FoodRequestsState extends State<FoodRequests> {
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getFoodRequests(Constants.myUid).then((val) {
      setState(() {
        requestsStream=val;
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
          title: Text('Food Requests'),
        ),
        body: Stack(
          children: [
            Container(
              child: RequestsList(),
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

class RequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: requestsStream as Stream<QuerySnapshot<Object>>?,
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final requests=snapshot.data!.docs;
        List<Widget> requestTiles=[];
        for (var request in requests) {
          final foodType=request.get('FoodType');
          final qty=request.get('Qty');
          final receiverName=request.get('ReceiverName');
          final receiverMobile=request.get('ReceiverNo');
          final receiverId=request.get('ReceiverId');
          final donationId=request.get('DonationId');
          final requestId=request.get('RequestId');
          final donationOne=RequestTile(
            foodType,
            qty,
            receiverName,
            receiverMobile,
            receiverId,
            donationId,
            requestId,
          );
          requestTiles.add(donationOne);
        }
        return Scrollbar(
          child: ListView(
            reverse: false,
            children: requestTiles,
          ),
        );
      },
    );
  }
}

class RequestTile extends StatelessWidget {
  final String? foodType;
  final int? qty;
  final String? receiverName;
  final String? receiverMobile;
  final String? receiverId;
  final String? donationId;
  final String? requestId;
  RequestTile(this.foodType,this.qty,this.receiverName,this.receiverMobile,this.receiverId,this.donationId,this.requestId);

  showAlertDialogBox(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmButton = TextButton(
      child: Text("Confirm"),
      onPressed:  () async {
        Navigator.pop(context);
        await dbMethods.confirmDonation(Constants.myUid, receiverId, requestId, donationId, qty);
        Fluttertoast.showToast(msg: 'Food Successfully Donated!');
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("Confirm Donation?"),
      actions: [
        cancelButton,
        confirmButton,
      ],
      elevation: 10,
      backgroundColor: kPrimaryLightColor,

    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAlertDialogBox(context);
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
                      fontSize: 16.0
                  ),
                ),
              ],
            ),
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
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
                  ),
                ),
                Flexible(
                  child: Constants.callButtonTile(mobileNo: receiverMobile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
