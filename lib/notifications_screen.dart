import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  Map<String, String> allHabitsMap = {};
  List<String> selectedHabits = [];
  List<String> selectedTimes = [];

  final List<String> times = ['Morning', 'Afternoon', 'Night'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      allHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'));
      selectedHabits = prefs.getStringList('notificationHabits') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
    });
  }

  Future<void> _saveNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationHabits', selectedHabits);
    await prefs.setStringList('notificationTimes', selectedTimes);
  }

  void _sendTestNotification() {
    if (html.Notification.permission != "granted") {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification("Habit Reminder",
              body: "It's time to work on your habits!");
          print('Notification permission granted. Notification sent.');
        } else {
          print('Notification permission denied.');
        }
      });
    } else {
      html.Notification("Habit Reminder",
          body: "It's time to work on your habits!");
      print('Notification sent directly.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveNotificationSettings();
              },
            ),
            SizedBox(height: 16),
            Text('Pick habits to get notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: allHabitsMap.keys.map((habit) {
                return FilterChip(
                  label: Text(habit),
                  selected: selectedHabits.contains(habit),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedHabits.add(habit);
                      } else {
                        selectedHabits.remove(habit);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Set time to get notifications at',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: times.map((time) {
                return FilterChip(
                  label: Text(time),
                  selected: selectedTimes.contains(time),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTimes.add(time);
                      } else {
                        selectedTimes.remove(time);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _sendTestNotification();
              },
              child: Text('Send Test Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}