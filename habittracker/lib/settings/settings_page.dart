import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/notifications/notification_service.dart';
import 'package:habittracker/settings/ChangePasswordPage.dart';
import 'package:timezone/timezone.dart' as tz;

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
  void initState() {
    super.initState();
    NotificationService().init(); // Initialize the notification service
  }

  void toggleDailyReminder(bool value) async {
    setState(() {
      dailyReminder = value;
    });

    if (value) {
      // Schedule a daily notification
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = TimeOfDay(hour: 8, minute: 0); // Set the desired time here

      // Calculate the next occurrence of the time
      var nextDaily = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );

      if (nextDaily.isBefore(now)) {
        nextDaily = nextDaily.add(const Duration(days: 1));
      }

      await NotificationService().scheduleNotification(
        1, // Unique ID for the notification
        'Daily Reminder',
        'It’s time to check your habits!',
        nextDaily,
      );
    } else {
      // Cancel the daily notification
      await NotificationService().cancelNotification(1);
    }
  }

  void toggleWeeklyReminder(bool value) async {
    setState(() {
      weeklyReminder = value;
    });

    if (value) {
      // Schedule a weekly notification
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = TimeOfDay(hour: 9, minute: 0); // Set the desired time here

      // Calculate the next occurrence of the specified day and time
      final nextWeek = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + (7 - now.weekday), // Adds days to reach the next same day of the week
        scheduledTime.hour,
        scheduledTime.minute,
      );

      await NotificationService().scheduleNotification(
        2, // Unique ID for the notification
        'Weekly Reminder',
        'Review your weekly habits!',
        nextWeek,
      );
    } else {
      // Cancel the weekly notification
      await NotificationService().cancelNotification(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ListTile(
          //   title: const Text('Daily Reminder'),
          //   trailing: Switch(
          //     value: dailyReminder,
          //     activeColor: Colors.lightBlue,
          //     onChanged: toggleDailyReminder,
          //   ),
          // ),
          // const Divider(),
          // ListTile(
          //   title: const Text('Weekly Reminder'),
          //   trailing: Switch(
          //     value: weeklyReminder,
          //     activeColor: Colors.lightBlue,
          //     onChanged: toggleWeeklyReminder,
          //   ),
          // ),
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