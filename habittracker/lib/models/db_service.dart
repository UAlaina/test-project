import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habittracker/models/dbHelper.dart';

// Singleton pattern for global database access
class DbService {
  static final DbService _instance = DbService._internal();
  DbHelper? _dbHelper;
  String? _currentUserId;

  // Factory constructor
  factory DbService() => _instance;

  // Private constructor
  DbService._internal();

  // Initialize with userId
  Future<void> initialize(String userId) async {
    if (_dbHelper == null || _currentUserId != userId) {
      _currentUserId = userId;
      //!EXP Delete DB
      //await DbHelper.deleteDB(userId);
      //print('[!deleted] db');
      _dbHelper = DbHelper(userId: userId);
      print('DbService initialized with userId: $userId');

      // Optional: Pre-warm the database connection
      await _dbHelper!.database;
    }
  }

  // Access the database helper
  DbHelper get dbHelper {
    if (_dbHelper == null) {
      throw Exception('DbService not initialized. Call initialize() first with a valid userId');
    }
    return _dbHelper!;
  }

  //EXP
  bool _isInitialized = false;
  Future<void> ensureInitialized(String userId) async {
    if (_isInitialized) return;
    _dbHelper = DbHelper(userId: userId);
    _isInitialized = true;
    print('[DbService] Initialized for user $userId');
  }

  Future<void> addHabit(Habit habit) async {
    await dbHelper.insertHabit(habit);
  }

  // Check if initialized
  bool get isInitialized => _dbHelper != null;

  // Get current user ID
  String? get currentUserId => _currentUserId;
}