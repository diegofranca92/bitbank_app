// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BlockButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Function()? onPress;
  final btnStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: const EdgeInsets.all(16));

  BlockButton({
    Key? key,
    this.icon,
    required this.label,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPress,
        icon: Icon(icon),
        style: btnStyle,
        label: Text(label));
  }
}
