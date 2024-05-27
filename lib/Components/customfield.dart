import 'package:flutter/material.dart';
import 'package:morched/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: primaryColor),
        fillColor: Colors.white, // Set background color to white
        filled: true, // Fill the background with the specified color
        contentPadding: const EdgeInsets.all(16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(width: 2, color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
              width: 2, color: Colors.white), // White border when not focused
        ),
        // border: OutlineInputBorder(
        //   // Border when the field is focused
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: const BorderSide(width: 2, color: primaryColor),
        // ),
      ),
    );
  }
}
