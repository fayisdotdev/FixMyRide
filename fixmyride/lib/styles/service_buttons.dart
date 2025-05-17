import 'package:flutter/material.dart';

// A reusable button widget function
Widget customButtonLayout({
  required String label,
  required VoidCallback onTap,
  IconData? icon, // New optional icon param
  double width = double.infinity,
}) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 8),
          Expanded(
            // or Flexible
            child: Text(
              label,
              overflow: TextOverflow.ellipsis, // optional
              softWrap: true, // optional
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
