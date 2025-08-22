import 'package:flutter/material.dart';

class CancelButtonWidget extends StatelessWidget {
  final Function callback;

  const CancelButtonWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => callback(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade100, // Background color of the button
        foregroundColor: Colors.redAccent, // Color of the text and icon
        shadowColor: Colors.grey, // Color of the shadow
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ), // Padding// Text style
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text('Cancel'),
    );
  }
}
