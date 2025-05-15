import 'package:flutter/material.dart';
import 'package:habittracker/habits/habit_calendar.dart';
import 'package:habittracker/habits/habitlist_page.dart';
import 'package:habittracker/notes/listNotesPage.dart';
import 'package:habittracker/notes/postit_page.dart';
import 'package:habittracker/profile/profile_page.dart';
import 'package:habittracker/profile/user.dart';
import 'package:habittracker/settings/settings_page.dart';
import 'package:habittracker/reports/report_page.dart';
import 'package:habittracker/profile/fetchUserDataSomehow.dart';
import 'time/date_check_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleDarkMode;

  const HomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.toggleDarkMode,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _pageName = "Habits";
  int _selectedIndex = 0;

  late List<Widget> _pages;
  bool _isLoading = true;
  UserDatas? _userData;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    DateCheckService().initialize(
      interval: const Duration(minutes: 30),
    );
    _initializePages();
  }

  Future<void> _initializeUserData() async {
    try {
      UserDatas userData = await fetchUserDataSomehow();
      setState(() {
        _userData = userData;
        _isLoading = false;
        _initializePages();
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializePages() {
    _pages = [
      const HabitlistPage(),
      HabitCalendarScreen(),
      ReportPage(),
      const NotesListPage(),
      PostItCanvasPage(),
      SettingsPage(
        isDarkMode: widget.isDarkMode,
        toggleDarkMode: widget.toggleDarkMode,
      ),
      _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ProfilePage(userData: _userData!),
    ];
  }

  @override
  void dispose() {
    DateCheckService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageName),
        backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: Container(
          color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.grey[900] : Colors.pinkAccent,
                ),
                child: Image.asset('assets/habit_tracker_icon.png'),
              ),
              _buildDrawerItem(Icons.home, 'Habits', 0),
              _buildDrawerItem(Icons.calendar_today, 'Calendar', 1),
              _buildDrawerItem(Icons.note_alt, 'Progress', 2),
              _buildDrawerItem(Icons.note, 'Notes', 3),
              _buildDrawerItem(Icons.sticky_note_2, 'Post-It', 4),
              _buildDrawerItem(Icons.settings, 'Settings', 5),
              _buildDrawerItem(Icons.person, 'Profile', 6),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: widget.isDarkMode ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () {
        setState(() {
          _pageName = title;
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}