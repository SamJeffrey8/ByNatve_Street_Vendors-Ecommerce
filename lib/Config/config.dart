import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TeleMed {
  static const String appName = 'ByNative';

  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static FirebaseUser admin;
  static FirebaseAuth adminauth;
  static Firestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String userGoodDeeds = 'score';
  static String subCollectionAddress = 'userAddress';

  static final String name = 'name';
  static final String phoneNumber = 'phoneNumber';
  static final String userEmail = 'email';

  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';

  static final String adminName = 'aname';
  static final String adminEmail = 'aemail';
  static final String adminPhotoUrl = 'photoUrl';
  static final String adminUID = 'aid';
  static final String adminAddress = 'adminAddress';
  static final String adminNPI = 'npi';
  static final String adminAvatarUrl = 'aurl';

  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
}
