import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';

class VolunteerHistory extends StatefulWidget {
  final QuerySnapshot? donorsSnapshot;
  VolunteerHistory(this.donorsSnapshot);

  @override
  _VolunteerHistoryState createState() => _VolunteerHistoryState();
}

class _VolunteerHistoryState extends State<VolunteerHistory> {

  Widget acceptedDonationsList() {
    return widget.donorsSnapshot != null ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: widget.donorsSnapshot!.docs.length,
        itemBuilder: (context,index) {
          return acceptedDonationTile(
            foodType: widget.donorsSnapshot!.docs[index].get('FoodType'),
            qty: widget.donorsSnapshot!.docs[index].get('Qty'),
            name: widget.donorsSnapshot!.docs[index].get('Name'),
            date: widget.donorsSnapshot!.docs[index].get('Date'),
          );
        }) :
    Container();
  }

  Widget acceptedDonationTile({required String foodType,int? qty,required String name,required String date}) {
    return Container(
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
              Flexible(
                child: Text(
                  foodType,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0
                  ),
                ),
              ), 
              Flexible(
                child: Text(
                  qty.toString()+' kg',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0
                  ),
                ),
              ), 
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  date,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      body: Container (
        child: acceptedDonationsList(),
      ),
    );
  }
}
