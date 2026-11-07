import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;
  final String name;
  final List<String> selectedHabits;

  const HabitTrackerScreen({
    super.key,
    this.username = '',
    this.name = '',
    this.selectedHabits = const [],
  });

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  String name = '';
  final List<String> _colors = ['#2196F3', '#4CAF50', '#FF9800', '#9C27B0', '#F44336', '#00BCD4'];

  @override
  void initState() {
    super.initState();
    name = widget.name.isNotEmpty ? widget.name : widget.username;
    for (var h in widget.selectedHabits) {
      selectedHabitsMap[h] = _colors[selectedHabitsMap.length % _colors.length];
    }
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToDo = prefs.getString('todo_${widget.username}');
    final savedDone = prefs.getString('done_${widget.username}');
    final savedName = prefs.getString('name_${widget.username}');
    setState(() {
      if (savedToDo != null) {
        selectedHabitsMap = Map<String, String>.from(json.decode(savedToDo));
      }
      if (savedDone != null) {
        completedHabitsMap = Map<String, String>.from(json.decode(savedDone));
      }
      if (savedName != null && savedName.isNotEmpty) name = savedName;
      if (name.isEmpty) name = widget.username;
    });
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todo_${widget.username}', json.encode(selectedHabitsMap));
    await prefs.setString('done_${widget.username}', json.encode(completedHabitsMap));
    await prefs.setString('name_${widget.username}', name);
  }

  void _showAddHabitDialog() {
    final ctrl = TextEditingController();
    String chosenColor = _colors[0];
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Habit name')),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _colors.map((c) {
                  return GestureDetector(
                    onTap: () => setDialogState(() => chosenColor = c),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _getColorFromHex(c),
                        shape: BoxShape.circle,
                        border: chosenColor == c ? Border.all(color: Colors.black, width: 2) : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (ctrl.text.trim().isEmpty) return;
                setState(() {
                  selectedHabitsMap[ctrl.text.trim()] = chosenColor;
                  _saveHabits();
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse('0x$hexColor'));
  }

  Color _getHabitColor(String habit, Map<String, String> habitsMap) {
    String? colorHex = habitsMap[habit];
    if (colorHex != null) {
      try { return _getColorFromHex(colorHex); } catch (e) { print('Error parsing color for $habit: $e'); }
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          name.isNotEmpty ? name : 'Loading...',
          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('To Do 📝', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          selectedHabitsMap.isEmpty
              ? const Expanded(
                  child: Center(child: Text('Use the + button to create some habits!', style: TextStyle(fontSize: 18, color: Colors.grey))),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: selectedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = selectedHabitsMap.keys.elementAt(index);
                      Color habitColor = _getHabitColor(habit, selectedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            String color = selectedHabitsMap.remove(habit)!;
                            completedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text('Swipe to Complete', style: TextStyle(color: Colors.white)), SizedBox(width: 10), Icon(Icons.check, color: Colors.white)],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor),
                      );
                    },
                  ),
                ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Done ✅🎉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          completedHabitsMap.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Swipe right on an activity to mark as done.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: completedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = completedHabitsMap.keys.elementAt(index);
                      Color habitColor = _getHabitColor(habit, completedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            String color = completedHabitsMap.remove(habit)!;
                            selectedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(children: [Icon(Icons.undo, color: Colors.white), SizedBox(width: 10), Text('Swipe to Undo', style: TextStyle(color: Colors.white))]),
                        ),
                        child: _buildHabitCard(habit, habitColor, isCompleted: true),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Add Habits',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitCard(String title, Color color, {bool isCompleted = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: SizedBox(
        height: 60,
        child: ListTile(
          title: Text(title.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          trailing: isCompleted ? const Icon(Icons.check_circle, color: Colors.green, size: 28) : null,
        ),
      ),
    );
  }
}