import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: Colors.grey.shade400,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}