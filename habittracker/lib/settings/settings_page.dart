import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/settings/ChangePasswordPage.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleDarkMode;

  const SettingsPage({Key? key, required this.isDarkMode, required this.toggleDarkMode}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dailyReminder = false;
  bool weeklyReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Settings'),
        // backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Daily Reminder'),
            trailing: Switch(
              value: dailyReminder,
              activeColor: Colors.lightBlue,
              onChanged: (value) {
                setState(() {
                  dailyReminder = value;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Weekly Reminder'),
            trailing: Switch(
              value: weeklyReminder,
              activeColor: Colors.lightBlue,
              onChanged: (value) {
                setState(() {
                  weeklyReminder = value;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: widget.isDarkMode,
              onChanged: (value) {
                widget.toggleDarkMode();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error logging out: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }
}