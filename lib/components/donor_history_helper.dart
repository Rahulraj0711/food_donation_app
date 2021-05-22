import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/constants.dart';
import 'package:intl/intl.dart';

class DonationsList extends StatelessWidget {
  final Stream? donationsStream;
  DonationsList(this.donationsStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: donationsStream as Stream<QuerySnapshot<Object>>?,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final donations = snapshot.data!.docs;
        List<Widget> donationTiles = [];
        for (var donation in donations) {
          final foodType = donation.get('FoodType');
          final qty = donation.get('Quantity');
          final status = donation.get('Status');
          final timestamp = donation.get('Timestamp');
          final donationOne = DonationTile(
            foodType,
            qty,
            status,
            timestamp,
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
  final String? status;
  final Timestamp? timestamp;
  DonationTile(this.foodType, this.qty, this.status, this.timestamp);

  @override
  Widget build(BuildContext context) {
    var date = DateFormat.yMMMMd('en_US').format(timestamp!.toDate());
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kPrimaryColor))),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
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
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            date,
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
