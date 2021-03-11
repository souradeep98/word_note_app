import 'package:flutter/material.dart';
import 'package:word_note_app/constants.dart';
import 'package:word_note_app/device_properties.dart';

class PopupView extends StatelessWidget
{
  final String title;
  final Widget child;

  PopupView({@required this.title, @required this.child});

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(roundedCornerRadius),
      ),
      child: ListView( //Outer
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding( //Header
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 15),
            child: Center(
              child: Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),

          const Divider(height: 0,),

          //child
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.7,
            ),
            child: child,
          ),

          //button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                  bottomLeft: const Radius.circular(roundedCornerRadius),
                  bottomRight: const Radius.circular(roundedCornerRadius),
                ),
              ),
              side: const BorderSide(width: 1, color: Colors.transparent),
            ),

            onPressed: () {Navigator.pop(context);},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: const Text('Dismiss',
                style: const TextStyle(
                  fontSize: 20,
                ),),
            ),
          ),
        ],
      ),
    );
  }
}
