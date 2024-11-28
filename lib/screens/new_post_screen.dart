
import 'package:flutter/material.dart';
import 'map_screen.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  bool _resolved = false;

  void _navigateToMap() {
    final String title = _titleController.text;
    final String info = _infoController.text;

    if (title.isNotEmpty && info.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(
            title: title,
            info: info,
            resolved: _resolved,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a new community post here. You must fill in a title and details before selecting the location.',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _infoController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resolved:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Checkbox(
                  value: _resolved,
                  onChanged: (bool? value) {
                    setState(() {
                      _resolved = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: _navigateToMap,
                icon: Icon(Icons.location_pin),
                label: Text('Select Location'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Adjusted padding for a smaller button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
