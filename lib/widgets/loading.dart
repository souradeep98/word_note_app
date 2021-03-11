import 'package:flutter/material.dart';

class Loading extends StatelessWidget
{
  final String message;
  Loading({this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(message),
        ],
      ),
    );
  }
}