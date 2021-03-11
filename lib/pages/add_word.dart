import 'package:flutter/material.dart';

import 'package:word_note_app/widgets/app_bar_title.dart';
import 'package:word_note_app/widgets/input_fields.dart';

import 'package:word_note_app/structures/word_and_description.dart';

import 'package:word_note_app/utilities/database_helper.dart';
import 'package:word_note_app/utilities/string_utilities.dart';
import 'package:word_note_app/utilities/word_manager.dart';


class AddWord extends StatefulWidget
{
  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWord>
{
  List<InputField> _wordInputFields = [];
  List<InputField> _descriptionInputFields = [];

  final DBHelper _wordDB = DBHelper();
  final WordManager _wordManager = WordManager();

  WordAndDescription _toWord()
  {
    List<String> _words = [];
    List<String> _descriptions = [];

    _wordInputFields.forEach((element) {
      if (element.textEditingControllerText.isNotEmpty)
        _words.add(element.textEditingControllerText);
    });
    _descriptionInputFields.forEach((element) {
      if (element.textEditingControllerText.isNotEmpty)
        _descriptions.add(element.textEditingControllerText.capitalizeAsSentence());
    });
    return WordAndDescription(words: _words, descriptions: _descriptions);
  }

  bool _ifContainDuplicate()
  {
    bool _flag = false;
    for (int i = 0; i < _wordInputFields.length; ++i) {
      for (int j = 0; j < _wordInputFields.length; ++j){
        if (i != j) {
          if (_wordInputFields[i].textEditingControllerText == _wordInputFields[j].textEditingControllerText) {
            _wordInputFields[i].showError('This field is duplicate');
            _wordInputFields[j].showError('This field is duplicate');
            _flag = true;
          }
        }
      }
    }
    _debugNote('Contains duplicate: $_flag');
    return _flag;
  }

  Future<bool> _ifAlreadyAdded() async
  {
    bool _flag = false;
    var _res;
    for (int i = 0; i < _wordInputFields.length; ++i) {
      _res = await _wordManager.contains(_wordInputFields[i].textEditingControllerText.toLowerCase());
      if (_res != 0) {
        _wordInputFields[i].showError('This word already exists in database');
        _wordInputFields[i].showLookup(_res);
        _flag = true;
      }
    }
    _debugNote('Already added: $_flag');
    return _flag;
  }

  bool _infProvided()
  {
    bool w, d;
    if (!(w = _wordProvided())) _wordInputFields.first.showError('At least one word is required');
    if (!(d = _descriptionProvided())) _descriptionInputFields.first.showError('At least one description is required');

    _debugNote('Info Provided: ${w && d}');
    return w && d;
  }

  bool _wordProvided()
  {
    for (final element in _wordInputFields)
    {
      if (element.textEditingControllerText.isNotEmpty)
      {
        return true;
      }
    }
    return false;
  }

  bool _descriptionProvided()
  {
    for (final element in _descriptionInputFields)
    {
      if (element.textEditingControllerText.isNotEmpty)
      {
        return true;
      }
    }
    return false;
  }

  Future<bool> _ifEligible() async
  {
    return _infProvided() && (!(await _ifAlreadyAdded())) && (!_ifContainDuplicate());
  }

  Future<bool> _showPopAlertDialog() async
  {
    if ((!_wordProvided()) && (!_descriptionProvided())) return true;
    return (showDialog(context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Information inserted in the fields will not be saved.'),
          actions: [
            TextButton(
              child: Text('Yes',
                style: TextStyle(
                  color: Colors.red[700],
                ),
              ),
              onPressed: ()
              {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: ()
              {
                Navigator.pop(context, false);
              }
            ),
          ], // actions
        )
    )) ?? false; // showDialog
  }


  @override
  void initState()
  {
    super.initState();
    _wordInputFields.clear();
    _descriptionInputFields.clear();
    _wordInputFields.add(InputField(hintText: 'Word', labelText: 'Word', helperText: 'Enter word',));
    _descriptionInputFields.add(InputField(hintText: 'Description', labelText: 'Description', helperText: 'Enter description', maxLines: null,));
  }



  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build().');
    return WillPopScope(
      onWillPop: _showPopAlertDialog,

      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: AppBarTitle('Add Word'),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Save'),
          icon: const Icon(Icons.done),
          tooltip: 'Save',
          onPressed: () async
          {
            if (await _ifEligible())
            {
              await _wordDB.addWord(_toWord());
              Navigator.pop(context, true);
            }
          },
        ),

        body: ListView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          children: [
            ListView.builder( // Words
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _wordInputFields.length,
              itemBuilder: (context, index) => _wordInputFields[index],
            ),
            TextButton(
              child: const Text('+ Add a synonym'),
              onPressed: ()
              {
                setState(()
                {
                  _wordInputFields.add(InputField(hintText: 'Word', labelText: 'Word', helperText: 'Enter word', ));
                });
              },
            ),

            const Divider(height: 30),

            ListView.builder( // Descriptions
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _descriptionInputFields.length,
              itemBuilder: (context, index) => _descriptionInputFields[index],
            ),

            TextButton(
              child: const Text('+ Add another description'),
              onPressed: ()
              {
                setState(()
                {
                  _descriptionInputFields.add(InputField(hintText: 'Description', labelText: 'Description', helperText: 'Enter description', maxLines: null, ));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _debugNote(String s)
{
  debugPrint('AddWordPage: $s');
}