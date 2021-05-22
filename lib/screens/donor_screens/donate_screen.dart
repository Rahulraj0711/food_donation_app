import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/components/rounded_button.dart';
import 'package:food_donation_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DonateScreen extends StatefulWidget {
  static const String id = 'donate_screen';
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  TextEditingController _typeController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _cookTimeController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  DatabaseMethods dbMethods = DatabaseMethods();
  late bool isLoading;

  @override
  void initState() {
    isLoading=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
        title: Text('Donate Food'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        controller: _typeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Food Type',
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Food Quantity (In kgs)',
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        controller: _cookTimeController,
                        onTap: () async {
                          final selectedTime = await _selectTime(context);
                          setState(() {
                            _cookTimeController.text =
                                selectedTime!.format(context);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Cooked Time',
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(height: size.height * 0.1),
                      RoundedButton(
                        text: 'Donate',
                        press: () async {
                          if (_typeController.text == '' ||
                              _typeController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'No Food to Donate!');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            Map<String, dynamic> donationDetailsMap = {
                              'Name': Constants.myName,
                              'FoodType': _typeController.text,
                              'Quantity': int.parse(_qtyController.text),
                              'CookedTime': _cookTimeController.text,
                              'City': Constants.myCity,
                              'Mobile': Constants.myMobileNo,
                              'Uid': Constants.myUid,
                              'DonationId': '',
                              'Status': 'Not Accepted',
                              'Timestamp': DateTime.now().toLocal(),
                              'Time':
                              DateTime.now().toLocal().millisecondsSinceEpoch,
                            };
                            await dbMethods.uploadDonationDetails(donationDetailsMap);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'Food Donation Succeeded!');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<TimeOfDay?> _selectTime(BuildContext context) {
  final now = DateTime.now();
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
  );
}
