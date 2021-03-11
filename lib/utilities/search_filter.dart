import 'package:flutter/foundation.dart';

class SearchFilter with ChangeNotifier
{
  String _filter = '';

  String get getFilter => _filter;

  void setFilter(String filter)
  {
    _filter = filter;
    notifyListeners();
  }
}