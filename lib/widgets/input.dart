// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.icon,
    required this.hint,
    required this.editingController,
    this.obsecure,
    this.enable = true,
    this.onTapBox,
  });

  final String icon;
  final String hint;
  final TextEditingController editingController;
  final bool? obsecure;
  final bool enable;
  final VoidCallback? onTapBox;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBox,
      child: TextField(
        controller: editingController,
        enabled: enable,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xff070623),
        ),
        obscureText: obsecure ?? false,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff070623),
            ),
            fillColor: const Color(0xffffffff),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            isDense: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(width: 2, color: Color(0xff4a1dff)),
            ),
            prefixIcon: UnconstrainedBox(
              alignment: const Alignment(0.4, 0),
              child: Image.asset(
                icon,
                width: 24,
                height: 24,
              ),
            )),
      ),
    );
  }
}
