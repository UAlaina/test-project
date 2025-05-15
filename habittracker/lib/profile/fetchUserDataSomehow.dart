import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habittracker/profile/user.dart';

Future<UserDatas> fetchUserDataSomehow() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("No user logged in");
  }

  DocumentSnapshot userDoc =
  await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (!userDoc.exists) {
    throw Exception("User data not found");
  }

  final data = userDoc.data() as Map<String, dynamic>;
  return UserDatas(
    name: data['name'] as String?,
    email: data['email'] as String?,
  );
}