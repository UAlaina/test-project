import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // Future<void> scheduleNotification(
  //     int id,
  //     String title,
  //     String body,
  //     tz.TZDateTime scheduledDate, {
  //       DateTimeComponents? matchDateTimeComponents,
  //     }) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     scheduledDate,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'reminder_channel',
  //         'Reminders',
  //         channelDescription: 'Habit reminders',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: matchDateTimeComponents,
  //   );

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      tz.TZDateTime scheduledDate, {
        DateTimeComponents? matchDateTimeComponents,
        bool testEveryMinute = false,  // New optional parameter for testing
      }) async {
    // If testing, override scheduledDate to 1 minute from now and set recurrence to every minute
    if (testEveryMinute) {
      final now = tz.TZDateTime.now(tz.local);
      scheduledDate = now.add(const Duration(minutes: 1));
      matchDateTimeComponents = DateTimeComponents.time;
    }

  await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Daily habit reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          // Other Android-specific properties here
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //uiLocalNotificationDateInterpretation:
      //UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: null,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}