import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = Colors.amber; // Default color
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load habits from both maps
      selectedHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'));
      completedHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('completedHabitsMap') ?? '{}'));
    });
  }

  Future<void> _saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedHabitsMap', jsonEncode(selectedHabitsMap));
    await prefs.setString('completedHabitsMap', jsonEncode(completedHabitsMap));
  }

  void _addHabit() {
    if (_habitController.text.trim().isNotEmpty) {
      setState(() {
        selectedHabitsMap[_habitController.text.trim()] =
            selectedColor.value.toRadixString(16);
        _habitController.clear();
      });
      _saveHabits();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Add Habit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _habitController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Color', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _habitColors.entries.map((entry) {
                final isSelected = selectedColor == entry.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = entry.value;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _addHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                ),
                child: const Text(
                  'Add Habit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: selectedHabitsMap.entries.map((entry) {
                  final habitName = entry.key;
                  final habitColor = _getColorFromHex(entry.value);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: habitColor,
                    ),
                    title: Text(habitName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          // Remove habit from both maps if it exists
                          selectedHabitsMap.remove(habitName);
                          completedHabitsMap.remove(habitName);
                          _saveHabits();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveHabits();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }
}