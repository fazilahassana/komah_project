import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Indikator progres berupa titik yang dihubungkan garis.
/// [currentStep] dimulai dari 1. Langkah <= currentStep berwarna oranye.
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 1; i <= totalSteps; i++) {
      final done = i <= currentStep;
      items.add(
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
      );
      if (i < totalSteps) {
        items.add(
          Container(
            width: 28,
            height: 2,
            color: i < currentStep ? AppColors.primary : AppColors.cardBorder,
          ),
        );
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }
}