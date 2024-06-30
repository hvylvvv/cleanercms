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
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _infoController,
              decoration: InputDecoration(labelText: 'Info'),
            ),
            Row(
              children: [
                Text('Resolved:'),
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
            ElevatedButton(
              onPressed: _navigateToMap,
              child: Text('Select Location'),
            ),
          ],
        ),
      ),
    );
  }
}
