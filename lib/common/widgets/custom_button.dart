import 'package:flutter/material.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.child,
    this.buttonHeight = 55,
    this.borderRadius = 15,
    this.buttonColor,
    this.gradient,
    this.boxBorder,
    required this.onTap,
    required this.buttonText,
  });

  final String buttonText;
  final Widget? child;
  final Function() onTap;
  final double? buttonHeight;
  final double? borderRadius;
  final Color? buttonColor;
  final Gradient? gradient;
  final BoxBorder? boxBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 15),
        border: boxBorder,
        color: buttonColor,
        gradient: buttonColor != null
            ? null
            : gradient ??
                LinearGradient(
                  begin: const Alignment(-1.2, 0.0),
                  end: const Alignment(1.0, 0.0),
                  colors: [
                    ColorPalette.primaryColorLight2,
                    ColorPalette.primaryColorLight,
                  ],
                ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child ??
              Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
