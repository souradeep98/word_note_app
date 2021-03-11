import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget
{
  final Widget child;
  CenteredView({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          child,
        ],
      ),
    );
  }
}
