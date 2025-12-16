import 'package:flutter/material.dart';
import 'package:estante/src/shared/theme/app_theme.dart';

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;

  const DotsIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotsCount,
        (index) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: index == position ? AppTheme.gold : AppTheme.darkGreen.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: index == position ? AppTheme.gold : Colors.transparent, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}