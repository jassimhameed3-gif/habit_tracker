import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_habit_screen.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'personal_info_screen.dart';
import 'reports_screen.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;

  const HabitTrackerScreen({super.key, required this.username});

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      selectedHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'));
      completedHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('completedHabitsMap') ?? '{}'));
    });
  }

  Future<void> _saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selectedHabitsMap', jsonEncode(selectedHabitsMap));
    await prefs.setString(
        'completedHabitsMap', jsonEncode(completedHabitsMap));
  }

  void _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildHabitCard(String title, Color color,
      {bool isCompleted = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: Container(
        height: 60,
        child: ListTile(
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
              : null,
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $name'),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: Text(
                'Hello, $name',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Personal Info'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalInfoScreen()),
                ).then((_) => _loadUserData());
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                _signOut(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Habits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: selectedHabitsMap.isEmpty
                  ? const Center(child: Text('No habits yet. Add one!'))
                  : ListView(
                      children: selectedHabitsMap.entries.map((entry) {
                        bool isCompleted =
                            completedHabitsMap.containsKey(entry.key);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isCompleted) {
                                completedHabitsMap.remove(entry.key);
                              } else {
                                completedHabitsMap[entry.key] = entry.value;
                              }
                            });
                            _saveHabits();
                          },
                          child: _buildHabitCard(
                            entry.key,
                            _getColorFromHex(entry.value),
                            isCompleted: isCompleted,
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
          if (result != null) {
            _loadUserData();
          }
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}