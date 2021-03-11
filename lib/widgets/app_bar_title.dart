import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget
{
  final title;
  AppBarTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
