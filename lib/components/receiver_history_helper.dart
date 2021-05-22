import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/constants.dart';

class RequestsList extends StatelessWidget {
  final Stream? requestsStream;
  RequestsList(this.requestsStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: requestsStream as Stream<QuerySnapshot<Object>>?,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final requests = snapshot.data!.docs;
        List<Widget> requestTiles = [];
        for (var request in requests) {
          final foodType = request.get('FoodType');
          final qty = request.get('Qty');
          // final status=request.get('Status');
          final volunteerName = request.get('VolunteerName');
          final volunteerMobile = request.get('VolunteerMobile');
          final donationOne = RequestTile(
            foodType,
            qty,
            volunteerName,
            volunteerMobile,
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
  final String? volunteerName;
  final String? volunteerMobile;
  RequestTile(
      this.foodType, this.qty, this.volunteerName, this.volunteerMobile);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kPrimaryColor))),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                foodType!,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              Text(
                qty.toString() + ' kg',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volunteer Name: ' + volunteerName!,
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
              Text(
                'Contact: ' + volunteerMobile!,
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ],
          )
        ],
      ),
    );
  }
}
