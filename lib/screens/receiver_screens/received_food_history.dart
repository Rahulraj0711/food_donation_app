import 'package:food_donation_app/components/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/components/receiver_history_helper.dart';
import 'package:food_donation_app/constants.dart';

class ReceivedFoodHistory extends StatefulWidget {
  static const String id = 'received_food_history';

  @override
  _ReceivedFoodHistoryState createState() => _ReceivedFoodHistoryState();
}

Stream? receivedFoodStream;

class _ReceivedFoodHistoryState extends State<ReceivedFoodHistory> {
  DatabaseMethods dbMethods = DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getReceivedFoodHistory(Constants.myUid).then((val) {
      setState(() {
        receivedFoodStream = val;
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
          title: Text('Received Food'),
        ),
        body: Stack(
          children: [
            Container(
              child: RequestsList(receivedFoodStream),
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
