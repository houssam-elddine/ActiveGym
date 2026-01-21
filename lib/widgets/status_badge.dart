import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  StatusBadge({required this.status});

  Color get bgColor {
    switch (status) {
      case 'confirmer':
        return Colors.green.shade100;
      case 'annuler':
        return Colors.red.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  Color get textColor {
    switch (status) {
      case 'confirmer':
        return Colors.green.shade800;
      case 'annuler':
        return Colors.red.shade800;
      default:
        return Colors.orange.shade800;
    }
  }

  IconData get icon {
    switch (status) {
      case 'confirmer':
        return Icons.check_circle;
      case 'annuler':
        return Icons.cancel;
      default:
        return Icons.hourglass_bottom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
