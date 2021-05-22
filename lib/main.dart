import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/components/auth_methods.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/screens/donor_screens/accepted_donations.dart';
import 'package:food_donation_app/screens/donor_screens/donate_screen.dart';
import 'package:food_donation_app/screens/Login/login_screen.dart';
import 'package:food_donation_app/screens/SignUp/signup_screen.dart';
import 'package:food_donation_app/screens/contact_screen.dart';
import 'package:food_donation_app/screens/donor_screens/pending_donations.dart';
import 'package:food_donation_app/screens/receiver_screens/receiver_home_screen.dart';
import 'package:food_donation_app/screens/receiver_screens/volunteers_list_screen.dart';
import 'package:food_donation_app/screens/volunteer_screens/donated_food_history.dart';
import 'package:food_donation_app/screens/volunteer_screens/donors_list_screen.dart';
import 'package:food_donation_app/screens/volunteer_screens/food_requests.dart';
import 'package:food_donation_app/screens/volunteer_screens/history_screen.dart';
import 'package:food_donation_app/screens/receiver_screens/received_food_history.dart';
import 'package:food_donation_app/screens/receiver_screens/receiver_pending_requests.dart';
import 'package:food_donation_app/screens/donor_screens/donor_home_screen.dart';
import 'package:food_donation_app/screens/volunteer_screens/volunteer_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/constants.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
AuthMethods _authMethods = AuthMethods(_auth);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? _user = await _authMethods.isCurrentUser();
  String? _userType;
  if (_user != null) {
    DocumentSnapshot users = await DatabaseMethods().getUsers(_user.uid);
    _userType = users.get('User Type');
  }

  Widget defaultScreen() {
    if (_user != null) {
      if (_userType == 'Donor') {
        return DonorHomeScreen();
      } else if (_userType == 'Receiver') {
        return ReceiverHomeScreen();
      } else {
        return VolunteerHomeScreen();
      }
    } else {
      return LoginScreen();
    }
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: defaultScreen(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        DonorHomeScreen.id: (context) => DonorHomeScreen(),
        VolunteerHomeScreen.id: (context) => VolunteerHomeScreen(),
        ReceiverHomeScreen.id: (context) => ReceiverHomeScreen(),
        AcceptedDonations.id: (context) => AcceptedDonations(),
        PendingDonations.id: (context) => PendingDonations(),
        DonateScreen.id: (context) => DonateScreen(),
        ContactScreen.id: (context) => ContactScreen(),
        DonorsListScreen.id: (context) => DonorsListScreen(),
        VolunteersListScreen.id: (context) => VolunteersListScreen(),
        ReceiverPendingRequests.id: (context) => ReceiverPendingRequests(),
        ReceivedFoodHistory.id: (context) => ReceivedFoodHistory(),
        HistoryScreen.id: (context) => HistoryScreen(),
        FoodRequests.id: (context) => FoodRequests(),
        DonatedFoodHistory.id: (context) => DonatedFoodHistory(),
      },
    ),
  );
}
