import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/components/already_have_an_account_check.dart';
import 'package:food_donation_app/components/auth_methods.dart';
import 'package:food_donation_app/components/helper_functions.dart';
import 'package:food_donation_app/components/rounded_button.dart';
import 'package:food_donation_app/constants.dart';
import 'package:food_donation_app/screens/Login/background.dart';
import 'package:food_donation_app/screens/SignUp/signup_screen.dart';
import 'package:food_donation_app/screens/donor_screens/donor_home_screen.dart';
import 'package:food_donation_app/screens/receiver_screens/receiver_home_screen.dart';
import 'package:food_donation_app/screens/volunteer_screens/volunteer_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  AuthMethods authMethods = AuthMethods(FirebaseAuth.instance);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserCredential _userCredential;
  User? _user;

  Future<void> login() async {
    try {
      _userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passController.text);
      _user = _userCredential.user;
      await HelperFunctions.setUIdSharedPreference(_user!.uid);
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      String? userType = users.get('User Type');
      Fluttertoast.showToast(msg: 'Login Successful!');
      if (userType == 'Donor')
        Navigator.pushReplacementNamed(context, DonorHomeScreen.id);
      else if (userType == 'Volunteer')
        Navigator.pushReplacementNamed(context, VolunteerHomeScreen.id);
      else
        Navigator.pushReplacementNamed(context, ReceiverHomeScreen.id);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Password Reset Email Sent');
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: Constants.onBackPressed,
      child: Scaffold(
        body: LoadingOverlay(
          opacity: 0.1,
          isLoading: isLoading,
          child: Background(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                            tag: 'Logo',
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Image.asset('assets/images/app_logo.png'),
                            )),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Your Email',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(Icons.visibility),
                            ),
                            hintText: 'Password',
                          ),
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                          text: 'Login',
                          press: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await login();
                          },
                        ),
                        SizedBox(height: size.height * 0.03),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await resetPassword(_emailController.text);
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        AlreadyHaveAnAccountCheck(
                          press: () {
                            Navigator.pushReplacementNamed(
                                context, SignupScreen.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
