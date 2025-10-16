import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final Function()? onPressed;
  final bool isIcon;
  final bool isEdit; // 👈 new flag

  const MyButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.onPressed,
    this.foregroundColor = Colors.white,
    this.isIcon = false,
    this.isEdit = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: backgroundColor,
        side: BorderSide.none,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isIcon) ...[
            Icon(
              isEdit ? Icons.edit_outlined : Icons.save_outlined, // 👈 change icon here
              color: foregroundColor,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}
