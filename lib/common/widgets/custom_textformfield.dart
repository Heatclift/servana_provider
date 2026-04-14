import 'package:flutter/material.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChange;
  final void Function()? onTap;
  final bool isEnable;
  final bool? readOnly;

  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.fillColor,
    this.controller,
    this.validator,
    this.onChange,
    this.isEnable = true,
    this.prefixIcon,
    this.focusNode,
    this.onTap,
    this.readOnly,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      onChanged: onChange,
      onTap: onTap,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: labelText,
        prefixIcon: prefixIcon,
        hintStyle: TextStyle(
          color: ColorPalette.greyLightText,
        ),
        filled: true,
        enabled: isEnable,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: ColorPalette.primaryColorLight.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: ColorPalette.primaryColorLight.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: ColorPalette.primaryColorLight,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
