import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewScheduleScreen extends StatefulWidget {
  @override
  _NewScheduleScreenState createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();

  // Checkbox states for days of the week
  Map<String, bool> _days = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  // Function to capitalize the first letter of each word
  String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word; // Handle empty words
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _submitSchedule() async {
    final String location = _locationController.text;
    final String zone = _zoneController.text;

    if (location.isNotEmpty && zone.isNotEmpty) {
      // Capitalize location and zone
      String capitalizedLocation = capitalizeWords(location);
      String capitalizedZone = capitalizeWords(zone);

      List<String> selectedDays = _days.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      try {
        // Use set() to create a document with the location name as the document ID
        await FirebaseFirestore.instance.collection('locations').doc(capitalizedLocation).set({
          'zone': capitalizedZone,
          'days': selectedDays,
        });

        // Show a snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Schedule added successfully!'),
            duration: Duration(seconds: 2), // You can adjust the duration
          ),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        print('Error adding schedule: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding schedule: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Please fill in both location and zone.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both location and zone.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a new garbage pickup schedule here. Fill in the location, zone, and select the pickup days.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _zoneController,
              decoration: InputDecoration(
                labelText: 'Zone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Pickup Days:',
              style: TextStyle(fontSize: 16.0),
            ),
            Column(
              children: _days.keys.map((day) {
                return Row(
                  children: [
                    Checkbox(
                      value: _days[day],
                      onChanged: (bool? value) {
                        setState(() {
                          _days[day] = value ?? false;
                        });
                      },
                    ),
                    Text(day),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _submitSchedule,
                child: Text('Submit Schedule'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
