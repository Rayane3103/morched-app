import 'package:flutter/material.dart';
import 'package:morched/Constants/constants.dart';

class Dropyy extends StatelessWidget {
  final List<String> dropItems;
  final String hintText;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;

  const Dropyy({
    super.key,
    required this.hintText,
    required this.dropItems,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DropdownButtonFormField<String>(
        items: dropItems.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          onChanged?.call(value!);
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          fillColor: Colors.white, // Set background color to white
          filled: true, // Fill the background with the specified color
          contentPadding: const EdgeInsets.all(14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(width: 2, color: primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(width: 2),
          ),
        ),
      )
    ]);
  }
}
