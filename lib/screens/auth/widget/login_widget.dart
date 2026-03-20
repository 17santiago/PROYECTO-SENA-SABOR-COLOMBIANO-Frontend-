import 'package:flutter/material.dart';


Widget customInput({
  required String label,
  required TextEditingController controller,
  bool obscure = false,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFD4D3D3), // gris claro
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF76A6A6), // gris más claro
              width: 2,
            ),
          ),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    ],
  );
}
