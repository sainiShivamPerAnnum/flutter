import 'package:flutter/material.dart';

class BackPressedSheet extends StatelessWidget {
  const BackPressedSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Icon(
            Icons.warning_amber_rounded,
            size: 40,
            color: Colors.orange,
          ),
          SizedBox(height: 16),
          Text(
            'End Streaming',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Leaving this session will end your current live stream and may cause you to miss out on valuable insights.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    // primary: Colors.black,
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add action for confirming
                  },
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                      // primary: Colors.red,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
