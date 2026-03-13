import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({
    super.key,
    required this.color,
    this.borderColor,
    required this.child,
    required this.onPressed,
  });

  final Color color;
  final Color? borderColor;
  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor != null
            ? borderColor!
            : color
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(2, 2),
            spreadRadius: 1.2,
            blurRadius: 1,
          )
        ]
      ),
      child: InkWell(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
