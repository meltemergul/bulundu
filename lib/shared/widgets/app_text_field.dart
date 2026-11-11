import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      cursorColor: colors.primary,
      style: TextStyle(
        color: colors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        errorText: errorText,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
