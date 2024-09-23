import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderScreen(), 
    );
  }
}


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final player = AudioPlayer(); 
  String selectedDay = 'Monday';
  String selectedActivity = 'Wake up';
  TimeOfDay selectedTime = TimeOfDay.now();

 
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep'
  ];

 
  void scheduleReminder() {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    if (reminderDateTime.isBefore(now)) {
      
      final tomorrow = now.add(Duration(days: 1));
      scheduleReminderForDate(DateTime(tomorrow.year, tomorrow.month,
          tomorrow.day, selectedTime.hour, selectedTime.minute));
    } else {
      scheduleReminderForDate(reminderDateTime);
    }

   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reminder Set"),
          content: Text(
              "Reminder for $selectedActivity on $selectedDay at ${selectedTime.format(context)} has been set."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  // Schedule the sound to play at a specific time
  void scheduleReminderForDate(DateTime reminderDateTime) {
    final now = DateTime.now();
    final durationUntilReminder = reminderDateTime.difference(now);

    Future.delayed(durationUntilReminder, () {
      playSound();
    });
  }

  
  void playSound() async {
    await player.play('assets/sounds/chime5.mp3'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Center(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              DropdownButton<String>(
                value: selectedDay,
                items: daysOfWeek.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (String? newDay) {
                  setState(() {
                    selectedDay = newDay!;
                  });
                },
              ),
              DropdownButton<String>(
                value: selectedActivity,
                items: activities.map((String activity) {
                  return DropdownMenuItem<String>(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (String? newActivity) {
                  setState(() {
                    selectedActivity = newActivity!;
                  });
                },
              ),
              SizedBox(height: 16), 
              ElevatedButton(
                child: Text("Select Time"),
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null && pickedTime != selectedTime) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
              ),
              SizedBox(height: 16), 
              ElevatedButton(
                child: Text("Set Reminder"),
                onPressed: () {
                  scheduleReminder();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
