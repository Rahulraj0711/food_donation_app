import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donation_app/constants.dart';
import 'package:food_donation_app/components/helper_functions.dart';

class DatabaseMethods {
  uploadUserDetails(userDetailsMap, userUid) async {
    FirebaseFirestore.instance.collection('users').doc(userUid).set(userDetailsMap);
  }

  uploadDonationDetails(donationDetailsMap) async {
    final docRef = await FirebaseFirestore.instance.collection('donations').add(donationDetailsMap);
    FirebaseFirestore.instance.collection('donations').doc(docRef.id).update({
      'DonationId': docRef.id,
    });
  }

  getUserInfo() async {
    Constants.myUid = await HelperFunctions.getUIdSharedPreference();
    var userDetails = await FirebaseFirestore.instance.collection('users').doc(Constants.myUid).get();
    Constants.myCity = userDetails.get('Address').toString().split(',')[0].trim();
    Constants.myName = userDetails.get('Name');
    Constants.myMobileNo = userDetails.get('Mobile');
    Constants.myType = userDetails.get('User Type');
    Constants.myEmail = userDetails.get('Email');
  }

  getUsers(uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  getDonors(String city) async {
    return FirebaseFirestore.instance.collection('donations').where('City', isEqualTo: city).where('Status', isEqualTo: 'Not Accepted').orderBy('Time', descending: true).snapshots();
  }

  getAcceptedDonationsVolunteer(String? userUid) async {
    return await FirebaseFirestore.instance.collection('users').doc(userUid).collection('accepted_donations').get();
  }

  getAvailableFood(String? userUid) async {
    return await FirebaseFirestore.instance.collection('users').doc(userUid).collection('realtime_accepted_donations').where('Qty', isGreaterThan: 0).get();
  }

  getAcceptedDonations(String? uid) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('realtime_accepted_donations').where('Qty', isGreaterThan: 0).snapshots();
  }

  getPendingDonations(userUid) async {
    return FirebaseFirestore.instance.collection('donations').where('Uid', isEqualTo: userUid).where('Status', isEqualTo: 'Not Accepted').orderBy('Time', descending: true).snapshots();
  }

  getAcceptedDonationsDonor(userUid) async {
    return FirebaseFirestore.instance.collection('donations').where('Uid', isEqualTo: userUid).where('Status', isEqualTo: 'Accepted').orderBy('Time', descending: true).snapshots();
  }

  uploadAcceptedDonations(acceptedDonationDetailsMap, userUid, donationId) async {
    FirebaseFirestore.instance.collection('users').doc(userUid).collection('accepted_donations').doc(donationId).set(acceptedDonationDetailsMap);
    FirebaseFirestore.instance.collection('users').doc(userUid).collection('realtime_accepted_donations').doc(donationId).set(acceptedDonationDetailsMap);
  }

  updateDonationStatus(String? donationId) async {
    FirebaseFirestore.instance.collection('donations').doc(donationId).update({
      'Status': 'Accepted',
    });
  }

  uploadVolunteersWithDonation(volunteerDetailsMap, userUid) async {
    var ref = await FirebaseFirestore.instance.collection('volunteers_with_donation').doc(userUid).get();
    if (!ref.exists) {
      FirebaseFirestore.instance.collection('volunteers_with_donation').doc(userUid).set(volunteerDetailsMap);
    }
  }

  getVolunteersWithDonation(String city) async {
    return FirebaseFirestore.instance.collection('volunteers_with_donation').where('City', isEqualTo: city).snapshots();
  }

  uploadFoodRequest(foodRequestDetailsMap1, foodRequestDetailsMap2, volunteerUid, myUid) async {
    final docRef1 = await FirebaseFirestore.instance.collection('users').doc(volunteerUid).collection('food_requests').add(foodRequestDetailsMap1);
    FirebaseFirestore.instance.collection('users').doc(volunteerUid).collection('food_requests').doc(docRef1.id).update({
      'RequestId': docRef1.id,
    });
    FirebaseFirestore.instance.collection('users').doc(myUid).collection('food_requests').doc(docRef1.id).set(foodRequestDetailsMap2);
    FirebaseFirestore.instance.collection('users').doc(myUid).collection('food_requests').doc(docRef1.id).update({
      'RequestId': docRef1.id,
    });
  }

  getPendingRequests(uid) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('food_requests').where('Status', isEqualTo: 'Not Received').snapshots();
  }

  getReceivedFoodHistory(uid) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('food_requests').where('Status', isEqualTo: 'Received').snapshots();
  }

  getFoodRequests(uid) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('food_requests').where('Status', isEqualTo: 'Pending').snapshots();
  }

  getDonatedFoodHistory(uid) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).collection('food_requests').where('Status', isEqualTo: 'Confirmed').snapshots();
  }

  confirmDonation(uid, receiverId, requestId, donationId, requestedQty) async {
    FirebaseFirestore.instance.collection('users').doc(uid).collection('food_requests').doc(requestId).update({
      'Status': 'Confirmed',
    });
    FirebaseFirestore.instance.collection('users').doc(receiverId).collection('food_requests').doc(requestId).update({
      'Status': 'Received',
    });
    var doc = await FirebaseFirestore.instance.collection('users').doc(uid).collection('realtime_accepted_donations').doc(donationId).get();
    int availableQty = doc.get('Qty');
    FirebaseFirestore.instance.collection('users').doc(uid).collection('realtime_accepted_donations').doc(donationId).update({
      'Qty': availableQty - requestedQty,
    });
  }
}
