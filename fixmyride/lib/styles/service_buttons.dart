import 'package:flutter/material.dart';

// A reusable button widget
Widget customButtonLayout({
  required String label,
  required VoidCallback onTap,
  IconData? icon,
  double width = double.infinity,
}) {
  return SizedBox(
    width: width,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.black54),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildProfileItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
