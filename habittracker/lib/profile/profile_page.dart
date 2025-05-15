import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habittracker/profile/EditProfilePage.dart';
import 'package:habittracker/profile/fetchUserDataSomehow.dart';
import 'package:habittracker/profile/user.dart';

class ProfilePage extends StatefulWidget {
  final UserDatas userData;

  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserDatas _userData; // Local state for user data

  @override
  void initState() {
    super.initState();
    _userData = widget.userData; // Initialize local state with passed user data
  }

  void _loadUser() async {
    try {
      UserDatas updatedUser = await fetchUserDataSomehow();
      setState(() {
        _userData = updatedUser; // Replace with the updated instance
      });
    } catch (e) {
      // Handle errors (e.g., user not logged in, data fetch failed)
      print("Error loading user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Profile"),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${_userData.name ?? "No name provided"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Email: ${_userData.email ?? "No email provided"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                  _loadUser(); // Reload user after edit
                },
                child: const Text("Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
