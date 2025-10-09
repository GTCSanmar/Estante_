import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: currentIndex == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Theme.of(context).colorScheme.primary
                // ignore: deprecated_member_use
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
