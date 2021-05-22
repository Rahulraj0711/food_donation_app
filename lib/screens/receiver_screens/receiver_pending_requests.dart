import 'package:food_donation_app/components/database_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/components/receiver_history_helper.dart';
import 'package:food_donation_app/constants.dart';

class ReceiverPendingRequests extends StatefulWidget {
  static const String id = 'receiver_pending_requests';

  @override
  _ReceiverPendingRequestsState createState() =>
      _ReceiverPendingRequestsState();
}

Stream? requestsStream;

class _ReceiverPendingRequestsState extends State<ReceiverPendingRequests> {
  DatabaseMethods dbMethods = DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getPendingRequests(Constants.myUid).then((val) {
      setState(() {
        requestsStream = val;
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
          title: Text('Pending Requests'),
        ),
        body: Stack(
          children: [
            Container(
              child: RequestsList(requestsStream),
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
