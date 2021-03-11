import 'package:flutter/foundation.dart';

@immutable
class OnlyWords
{
  final int id;
  final List<String> words;

  OnlyWords({@required this.id, @required this.words});
}