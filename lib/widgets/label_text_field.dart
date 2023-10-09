import 'package:flutter/material.dart';

import '../../constant.dart';

// ignore: must_be_immutable
class LabelTextField extends StatelessWidget {
  LabelTextField(
      {required this.text,
      required this.hintText,
      required this.controller,
      this.maxLength = TextField.noMaxLength,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.enabled = true,
      super.key});

  final String text;
  final String hintText;
  final TextEditingController controller;
  int maxLength;

  TextInputType keyboardType;
  bool obscureText;
  bool enabled;

  Widget labelText() {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputBorder inputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: greenMainColor),
    borderRadius: BorderRadius.circular(borderRadius * 4),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // labelText(),
        // const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.white70,
            hintText: hintText,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder,

            // labelText: text,
            label: Padding(
              padding: const EdgeInsets.only(left: padding * 2),
              child: Text(
                text,
                style: const TextStyle(color: greenMainColor),
              ),
            ),
            prefix: const SizedBox(width: 16),
          ),
          maxLength: maxLength,
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
        ),
      ],
    );
  }
}
