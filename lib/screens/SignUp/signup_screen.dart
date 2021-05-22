import 'package:flutter/widgets.dart';
import 'package:food_donation_app/components/already_have_an_account_check.dart';
import 'package:food_donation_app/components/auth_methods.dart';
import 'package:food_donation_app/components/database_methods.dart';
import 'package:food_donation_app/components/helper_functions.dart';
import 'package:food_donation_app/components/rounded_button.dart';
import 'package:food_donation_app/screens/Login/login_screen.dart';
import 'package:food_donation_app/screens/donor_screens/donor_home_screen.dart';
import 'package:food_donation_app/screens/receiver_screens/receiver_home_screen.dart';
import 'package:food_donation_app/screens/volunteer_screens/volunteer_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_app/screens/SignUp/background.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_app/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignupScreen extends StatefulWidget {
  static const String id='signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? dropDownValue='Donor';
  bool _obscureText1=true;
  bool _obscureText2=true;
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  TextEditingController _nameController=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passController=TextEditingController();
  TextEditingController _cpassController=TextEditingController();
  TextEditingController _mobileController=TextEditingController();
  TextEditingController _addressController=TextEditingController();
  AuthMethods authMethods=AuthMethods(FirebaseAuth.instance);
  DatabaseMethods dbMethods=DatabaseMethods();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  bool isLoading=false;
  late UserCredential _userCredential;
  User? _user;

  Future<void> validateAndSignup() async{
    if(_formKey.currentState!.validate()) {
      try {
        _userCredential=await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passController.text);
        _user=_userCredential.user;
        Map<String,dynamic> userDetails= {
          'UId': _user!.uid,
          'Name': _nameController.text,
          'Email': _emailController.text,
          'Mobile': _mobileController.text,
          'Address': _addressController.text,
          'User Type': dropDownValue,
        };
        await HelperFunctions.setUserLoggedInSharedPreference(true);
        await HelperFunctions.setUIdSharedPreference(_user!.uid);
        await HelperFunctions.setUserNameSharedPreference(_nameController.text);
        await HelperFunctions.setUserEmailSharedPreference(_emailController.text);
        await HelperFunctions.setMobileSharedPreference(_mobileController.text);
        await HelperFunctions.setCitySharedPreference(_addressController.text);
        await HelperFunctions.setUserTypeSharedPreference(dropDownValue!);
        await dbMethods.uploadUserDetails(userDetails, _user!.uid);
        Fluttertoast.showToast(msg: 'Welcome '+_nameController.text+'!');
        if(dropDownValue=='Donor')
          Navigator.pushReplacementNamed(context, DonorHomeScreen.id);
        else if(dropDownValue=='Volunteer')
          Navigator.pushReplacementNamed(context, VolunteerHomeScreen.id);
        else
          Navigator.pushReplacementNamed(context, ReceiverHomeScreen.id);
      } on FirebaseAuthException catch(e)  {
        setState(() {
          isLoading=false;
        });
        Fluttertoast.showToast(msg: e.message!);
      }
    }
    setState(() {
      isLoading=false;
    });
    print('Not Validated');
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: Constants.onBackPressed,
      child: Scaffold(
        body: Scrollbar(
          isAlwaysShown: true,
          thickness: 6,
          child: LoadingOverlay(
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
                                height: MediaQuery.of(context).size.height*0.12,
                                child: Image.asset('assets/images/app_logo.png'),
                              )
                          ),
                          // Text(
                          //   Constants.appName,
                          //   style: TextStyle(
                          //     color: kPrimaryColor,
                          //     fontSize: 60,
                          //     fontWeight: FontWeight.bold,
                          //     fontStyle: FontStyle.italic,
                          //   ),
                          // ),
                          SizedBox(height: size.height * 0.03),
                          Text(
                            "SIGNUP",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableSuggestions: true,
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Enter Your Name',
                            ),
                            validator: (value) {
                              if(value!.length<3) {
                                return 'Name must have more than 3 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableSuggestions: true,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Your Email',
                            ),
                            validator: (value) {
                              if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)) {
                                return null;
                              }
                              return 'Enter a valid email';
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _passController,
                            obscureText: _obscureText1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText1=!_obscureText1;
                                  });
                                },
                                child: Icon(Icons.visibility),
                              ),
                              hintText: 'Password',
                            ),
                            validator: (value) {
                              if(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value!)) {
                                return null;
                              }
                              return 'Should contain at least:\n1 Uppercase\n1 Lowercase\n1 Digit\n1 Special character';
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _cpassController,
                            obscureText: _obscureText2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText2=!_obscureText2;
                                  });
                                },
                                child: Icon(Icons.visibility),
                              ),
                              hintText: 'Confirm Password',
                            ),
                            validator: (value) {
                              if(value==_passController.text) {
                                return null;
                              }
                              return 'Passwords do not match';
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableSuggestions: true,
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Mobile Number',
                            ),
                            validator: (value) {
                              if(RegExp(r"^[6-9][0-9]{9}$").hasMatch(value!)) {
                                return null;
                              }
                              return 'Mobile Number is not valid';
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableSuggestions: true,
                            controller: _addressController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                              hintText: 'City, State',
                            ),
                            validator: (value) {
                              if(value!.isEmpty) {
                                return 'Address cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          DropdownButton(
                            dropdownColor: Colors.yellow,
                            value: dropDownValue,
                            elevation: 20,
                            underline: Container(
                              height: 2,
                              color: kPrimaryColor,
                            ),
                            onTap: () {FocusScope.of(context).unfocus();},
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue=newValue;
                              });
                            },
                            items: <String>['Donor','Volunteer','Receiver'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 20,),
                          RoundedButton(
                            text: 'Signup',
                            press: () async {
                              setState(() {
                                isLoading=true;
                              });
                              await validateAndSignup();
                            },
                          ),
                          SizedBox(height: size.height * 0.01),
                          AlreadyHaveAnAccountCheck(
                            login: false,
                            press: () {
                              Navigator.pushReplacementNamed(context, LoginScreen.id);
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
      ),
    );
  }
}
