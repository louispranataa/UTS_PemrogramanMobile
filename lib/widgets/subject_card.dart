// lib/widgets/subject_card.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SubjectCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.lightColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isDark ? color.withValues(alpha: 0.2) : lightColor,
                  isDark
                      ? color.withValues(alpha: 0.1)
                      : lightColor.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.3 : 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: color,
                  ),
                ),
                const SizedBox(width: 20),

                // Text info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Iconsax.arrow_right_3,
                  color: color,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
