import 'package:flutter/material.dart';
import 'package:word_note_app/utilities/string_utilities.dart';

class WordDetailsWidget extends StatelessWidget
{
  final String word;
  WordDetailsWidget(this.word);

  @override
  Widget build(BuildContext context)
  {
    return Card(
      elevation: 0,
      margin: const EdgeInsetsDirectional.only(bottom: 2),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text(word.capitalizeFirst(),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class DescriptionDetailsWidget extends StatelessWidget
{
  final String description;
  DescriptionDetailsWidget(this.description);

  @override
  Widget build(BuildContext context)
  {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(description,
          style: const TextStyle(
              fontSize: 18,
          ),
        ),
      ),
    );
  }
}
