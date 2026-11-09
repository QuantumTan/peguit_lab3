import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class PasswordRequirementIndicator extends StatelessWidget {
  final int passwordLength;

  const PasswordRequirementIndicator({
    super.key,
    required this.passwordLength,
  });

  @override
  Widget build(BuildContext context) {
    final hasMinLength = passwordLength >= AppConstants.minPasswordLength;
    final statusColor =
        hasMinLength ? const Color(0xFF0D9488) : const Color(0xFFEF4444);

    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Row(
        children: [
          Icon(
            hasMinLength
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 6),
          Text(
            'At least ${AppConstants.minPasswordLength} characters ($passwordLength/${AppConstants.minPasswordLength})',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

