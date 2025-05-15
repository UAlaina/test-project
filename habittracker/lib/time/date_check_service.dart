import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/models/dbHelper.dart';

class DateCheckService {
  // Singleton setup
  static final DateCheckService _instance = DateCheckService._internal();
  factory DateCheckService() => _instance;
  DateCheckService._internal();

  Timer? _timer;

  void initialize({Duration interval = const Duration(seconds: 5)}) {
    print('[!Service] Initialized with interval: ${interval.inSeconds} seconds');
    final DbHelper dbHelper = DbService().dbHelper;
    print('!MADE IT');
    runDateCheck();



    _timer?.cancel(); // clear previous timer if any

    _timer = Timer.periodic(interval, (_) {
      print('[!Service] Tick at ${DateTime.now()}');
      runDateCheck();
    });
  }

  void dispose() {
    _timer?.cancel();
    print('[!Service] Disposed');
  }


  void runDateCheck() {
    print('[!rundatecheck] start');
    dateCheck('Daily');
    dateCheck('Weekly');
    dateCheck('Monthly');
    print('[!rundatecheck] end');
  }

  Future<void> dateCheck(String intervalString) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int interval;
    DateTime startOf;

    switch (intervalString) {
      case 'Daily':
        interval = 24 * 60 * 60 * 1000; //24hrs
        startOf = startOfDay(DateTime.now());
        break;
      case 'Weekly':
        interval = 7 * 24 * 60 * 60 * 1000; //7days
        startOf = startOfWeek(DateTime.now());
        break;
      case 'Monthly':
        interval = 30 * 24 * 60 * 60 * 1000; //30days
        startOf = startOfMonth(DateTime.now());
        break;
      default:
        print('[!Intervalswitch] wrong value (d|w|m)');
        return;
    }

    print('[!datecheck] left switch with $interval');
    List<Task>? tasks = await DbService().dbHelper.getTasksByInterval(intervalString);

    int completeCount = 0;
    int totalTaskCount = 0;
    int lateTasks = 0;

    for (var task in tasks) {
      print('[!printtask] $intervalString $task');
      if ((currentTime - task.startTime) > interval) {
        if (task.completed == 1) {
          completeCount++;
        }
        //update task
        task.completed = 0;
        task.startTime += interval;
        await DbService().dbHelper.updateTask(task);
        lateTasks++;
      }
      totalTaskCount++;
    }
    if (lateTasks <= 0) {
      print('![!late] no tasks are late!');
      return;
    }
    print('[!late] we have $lateTasks late tasks');
    double completePercent = completeCount/totalTaskCount;
    if (completePercent.isNaN) {
      completePercent = 0;
    }
    //generate report
    await generateReport(completePercent, startOf, intervalString);
    //repeat until caught up
    dateCheck(intervalString);
  }

  Future<void> generateReport(double completePercent, DateTime startOf, String intervalString) async {
    int startTime = startOf.millisecondsSinceEpoch;
    final report = Report(
      id: 0, //is ignored, should auto increment
      score: completePercent,
      startTime: startTime,
      interval: intervalString,
    );

    try {
      print('[!generated] report $report');
      await DbService().dbHelper.insertReport(report);
      print('[!report] ADDED success!!');
    } catch (e) {
      print('[!report] fail');
    }
  }



  //========= STATIC TIME FUNCTIONS ============
  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime startOfWeek(DateTime date) {
    int difference = date.weekday - DateTime.monday;
    DateTime monday = date.subtract(Duration(days: difference));
    return DateTime(monday.year, monday.month, monday.day);
  }

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);






}






//fetching from db (UNIX timemillis) (int)
// DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisFromDb);

//converting datenow to millis
// DateTime now = DateTime.now();
// int unixMillis = now.millisecondsSinceEpoch;

/*
//substracting date time
void main() {
  DateTime start = DateTime.now().subtract(Duration(hours: 20));
  DateTime now = DateTime.now();

  Duration difference = now.difference(start);
  print(difference); // Output: 20:00:00.000000
}

//compare directly
if (now.isAfter(start)) {
print('Now is after start');
}

if (now.isBefore(start)) {
print('Now is before start');
}

if (now.isAtSameMomentAs(start)) {
print('They are exactly equal');
}

//compare against duration
if (now.difference(start) < Duration(hours: 24)) {
print('Less than a day has passed');
}
//or
final withinDay = now.difference(start).inHours < 24;
*/





















/*
class DateCheckService {
  // Singleton pattern
  static final DateCheckService _instance = DateCheckService._internal();
  factory DateCheckService() => _instance;
  DateCheckService._internal();

  // Timer for periodic checks
  Timer? _timer;

  // Event callbacks
  VoidCallback? onDayEnd;
  VoidCallback? onWeekEnd;
  VoidCallback? onMonthEnd;

  // Last checked date (to detect changes)
  DateTime _lastCheckedDate = DateTime.now();

  // Initialize the service
  void initialize({
    VoidCallback? onDayEnd,
    VoidCallback? onWeekEnd,
    VoidCallback? onMonthEnd,
    Duration checkInterval = const Duration(hours: 1),
  }) {
    print('!interval in datecheckservice');

    this.onDayEnd = onDayEnd;
    this.onWeekEnd = onWeekEnd;
    this.onMonthEnd = onMonthEnd;

    // Check immediately on startup
    checkDateEvents();

    // Set up periodic checking
    _timer?.cancel();
    _timer = Timer.periodic(checkInterval, (_) {
      checkDateEvents();
    });
  }

  // Cancel timer when not needed
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  // The core date checking logic
  void checkDateEvents() {
    DateTime now = DateTime.now();

    // Check if day changed since last check
    bool dayChanged = _lastCheckedDate.day != now.day ||
        _lastCheckedDate.month != now.month ||
        _lastCheckedDate.year != now.year;

    // Check if week changed (crossed Monday boundary)
    bool weekChanged = _lastCheckedDate.weekday > now.weekday &&
        now.weekday == DateTime.monday;

    // Check if month changed
    bool monthChanged = _lastCheckedDate.month != now.month ||
        _lastCheckedDate.year != now.year;

    // Trigger appropriate callbacks
    if (dayChanged && onDayEnd != null) {
      onDayEnd!();
    }

    if (weekChanged && onWeekEnd != null) {
      onWeekEnd!();
    }

    if (monthChanged && onMonthEnd != null) {
      onMonthEnd!();
    }

    // Update last checked date
    _lastCheckedDate = now;
  }

  // Helper methods you might want to use
  bool isEndOfDay() {
    final now = DateTime.now();
    return now.hour >= 23 && now.minute >= 0;
  }

  bool isEndOfMonth() {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    return now.day == lastDayOfMonth;
  }
}

 */