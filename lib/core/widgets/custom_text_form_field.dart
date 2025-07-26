import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
