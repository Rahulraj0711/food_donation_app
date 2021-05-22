import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/screens/receiver_screens/request_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';

class VolunteersListScreen extends StatefulWidget {
  static const String id='volunteers_list_screen';

  @override
  _VolunteersListScreenState createState() => _VolunteersListScreenState();
}

Stream? volunteersStream;

class _VolunteersListScreenState extends State<VolunteersListScreen> {
  DatabaseMethods dbMethods=DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    dbMethods.getVolunteersWithDonation(Constants.myCity).then((val) {
      setState(() {
        volunteersStream=val;
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
          title: Text('Volunteers'),
        ),
        body: Stack(
          children: [
            Container(
              child: VolunteersList(),
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

class VolunteersList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: volunteersStream as Stream<QuerySnapshot<Object>>?,
      builder: (context,snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final volunteers=snapshot.data!.docs;
        List<Widget> volunteerTiles=[];
        for (var volunteer in volunteers) {
          final name=volunteer.get('Name');
          final mobile=volunteer.get('Mobile');
          final uid=volunteer.get('Uid');
          final volunteerOne=VolunteerTile(
            name,
            mobile,
            uid,
          );
          volunteerTiles.add(volunteerOne);
        }
        return Scrollbar(
          child: ListView(
            reverse: false,
            children: volunteerTiles,
          ),
        );
      },
    );
  }
}

class VolunteerTile extends StatelessWidget {
  final String? name;
  final String? mobile;
  final String? uid;
  VolunteerTile(this.name,this.mobile,this.uid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RequestFoodScreen(uid,name,mobile)));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: kPrimaryColor)
            )
        ),
        padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0
                      ),
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 18,
                          color: Colors.green,
                        ),
                        SizedBox(width: 6,),
                        Text(
                          mobile!,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Constants.callButtonTile(mobileNo: mobile),
              ),
            ],
          )
      ),
    );
  }
}
