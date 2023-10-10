import 'dart:ui';

import 'package:flutter/material.dart';

/// A container with a frosted glass effect.
class FrostedContainer extends StatelessWidget {
  const FrostedContainer({
    super.key,
    required this.child,
    this.borderRadiusAmount = 16,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// The widget to display inside the container.
  final Widget child;

  /// The padding to apply to the container.
  final EdgeInsets padding;

  /// The amount of border radius to apply to the container.
  final double borderRadiusAmount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusAmount),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(borderRadiusAmount),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
