// lib/widgets/option_card.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OptionCard extends StatelessWidget {
  final String optionText;
  final int optionNumber;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showFeedback;
  final bool isCorrect;
  final Color subjectColor;

  const OptionCard({
    super.key,
    required this.optionText,
    required this.optionNumber,
    required this.onTap,
    this.isSelected = false,
    this.showFeedback = false,
    this.isCorrect = false,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor;
    Color backgroundColor;
    IconData? icon;

    // --- Feedback warna & ikon
    if (showFeedback) {
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        icon = Iconsax.tick_circle;
      } else {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        icon = Iconsax.close_circle;
      }
    } else if (isSelected) {
      borderColor = subjectColor;
      backgroundColor = subjectColor.withValues(alpha: 0.1);
      icon = null;
    } else {
      borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.2);
      backgroundColor = theme.cardColor;
      icon = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Nomor lingkaran
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: showFeedback
                        ? (isCorrect
                            ? Colors.green
                            : Colors.red)
                        : (isSelected
                            ? subjectColor
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.1)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(64 + optionNumber), // A, B, C, D
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: showFeedback || isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Teks opsi
                Expanded(
                  child: Text(
                    optionText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),

                // Ikon feedback
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    icon,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
