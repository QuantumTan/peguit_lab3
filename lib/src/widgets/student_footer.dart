import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class StudentFooter extends StatelessWidget {
  const StudentFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.badge_outlined,
            size: 16,
            color: Color(0xFF64748B),
          ),
          SizedBox(width: 8),
          Text(
            AppConstants.studentNameAndSection,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

