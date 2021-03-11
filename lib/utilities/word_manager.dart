import 'dart:collection';
import 'package:flutter/foundation.dart';


class WordManager with ChangeNotifier
{
  WordManager._privateConstructor() {_debugNote('Private constructor is called.');}
  static final _singleWordManagerSingletonInstance = WordManager._privateConstructor();
  factory WordManager() => _singleWordManagerSingletonInstance;

  static int tWords = 0;
  int get nOfWords => tWords;

  //The words
  HashMap<int, List<String>> words = HashMap<int, List<String>>(); //New change

  Future<int> contains(String w) async
  {
    _debugNote('Called contains with: [$w]');
    for (int i = 1; i <= words.length; ++i) {
      for (int j = 0; j < words[i].length; ++j) {
        if (words[i][j].toLowerCase() == w) return i;
      }
    }
    return 0;
  }

  void notify() {notifyListeners();}
}

void _debugNote(String s)
{
  debugPrint('WordManager: $s');
}