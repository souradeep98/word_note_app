import 'package:flutter/material.dart';

import 'package:word_note_app/structures/word_and_description.dart';

import 'package:word_note_app/utilities/word_manager.dart';
import 'package:word_note_app/utilities/database_helper.dart';
import 'package:word_note_app/utilities/string_utilities.dart';

import 'package:word_note_app/widgets/app_bar_title.dart';
import 'package:word_note_app/widgets/input_fields.dart';

import 'package:word_note_app/widgets/snackbar.dart';

class EditWord extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build().');
    WordAndDescription _word = ModalRoute.of(context).settings.arguments;
    _debugNote('Called EditWord with word: ${_word.words.length}, ${_word.descriptions.length}');
    return EditWordIFH(_word);
  }
}

class EditWordIFH extends StatefulWidget
{
  final WordAndDescription word;

  EditWordIFH(this.word);

  @override
  _EditWordIFHState createState() => _EditWordIFHState();
}

class _EditWordIFHState extends State<EditWordIFH>
{
  GlobalKey<ScaffoldMessengerState> _ewScaffoldMState = GlobalKey<ScaffoldMessengerState>();
  WordAndDescription _word;
  WordAndDescription _newWord;
  List<InputField> _wordFields = [];
  List<InputField> _descriptionFields = [];

  final DBHelper _wordDB = DBHelper();

  final WordManager _wordManager = WordManager();

  bool _prepare()
  {
    _debugNote('Called _prepare()');
    _wordFields.clear();
    _descriptionFields.clear();
    for (int i = 0; i <_word.words.length; ++i) {
      _wordFields.add(InputField(initialValue: _word.words[i], hintText: 'Word', labelText: 'Word', helperText: 'Make changes or erase content to delete',));
    }
    for (int i = 0; i < _word.descriptions.length; ++i) {
      _descriptionFields.add(InputField(initialValue: _word.descriptions[i], hintText: 'Description', labelText: 'Description', helperText: 'Make changes or erase content to delete', maxLines: null,));
    }
    return true;
  }

  bool _infProvided()
  {
    bool w, d;
    if (!(w = _wordProvided())) _wordFields.first.showError('At least one word is required');
    if (!(d = _descriptionProvided())) _descriptionFields.first.showError('At least one description is required');

    _debugNote('Info Provided: ${w && d}');
    return w && d;
  }

  bool _wordProvided()
  {
    for (var element in _wordFields)
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
    for (var element in _descriptionFields)
    {
      if (element.textEditingControllerText.isNotEmpty)
      {
        return true;
      }
    }
    return false;
  }

  bool _infUpdated()
  {
    _debugNote('Called _infUpdated()');
    Set<String> _w = Set();
    Set<String> _d = Set();
    _word.words.forEach((element) {_w.add(element);});
    _wordFields.forEach((element) {if(element.textEditingControllerText.isNotEmpty) {
        _w.add(element.textEditingControllerText);
      }
    });

    _word.descriptions.forEach((element) {_d.add(element);});
    _descriptionFields.forEach((element) {if(element.textEditingControllerText.isNotEmpty) {
        _d.add(element.textEditingControllerText.capitalizeAsSentence());
      }
    });

    bool res = ((_w.length != _word.words.length) || (_d.length != _word.descriptions.length));

    _debugNote('New #Words: ${_w.length}');
    _debugNote('New #Descriptions: ${_d.length}');
    
    _debugNote('_infUpdated result: $res');

    if (!res) {
      showSnack(_ewScaffoldMState, 'No field updated. You can exit by pressing back.');
    }
    
    return res;
  }

  bool _ifContainDuplicate()
  {
    bool _flag = false;
    for (int i = 0; i < _wordFields.length; ++i) {
      for (int j = 0; j < _wordFields.length; ++j) {
        if (i != j) {
          if (_wordFields[i].textEditingControllerText == _wordFields[j].textEditingControllerText) {
            _wordFields[i].showError('This field is duplicate');
            _wordFields[j].showError('This field is duplicate');
            _flag = true;
          }
        }
      }
    }
    return _flag;
  }

  Future<bool> _ifAlreadyAdded() async
  {
    bool _flag = false;
    var _res;
    for (int i = 0; i < _wordFields.length; ++i) {
      _res = await _wordManager.contains(_wordFields[i].textEditingControllerText.toLowerCase());
      if (_res != 0 && _res != _word.id)
      {
        _wordFields[i].showError('This word already exists in database');
        _wordFields[i].showLookup(_res);
        _flag = true;
      }
    }
    return _flag;
  }

  Future<bool> _ifEligible() async
  {
    return _infProvided() && _infUpdated() && (!(await _ifAlreadyAdded())) && (!_ifContainDuplicate());
  }

  void _toWord()
  {
    List<String> words = [];
    List<String> descriptions = [];

    _wordFields.forEach((element) {
      if (element.textEditingControllerText.isNotEmpty)
        //debugPrint(element.textEditingController.text); // DEBUG
        words.add(element.textEditingControllerText);
    });
    _descriptionFields.forEach((element) {
      if (element.textEditingControllerText.isNotEmpty)
        //debugPrint(element.textEditingController.text.capitalizeAsSentence()); // DEBUG
        descriptions.add(element.textEditingControllerText.capitalizeAsSentence());
    });
    _newWord = WordAndDescription(id: _word.id, words: words, descriptions: descriptions);
  }

  Future<bool> _showPopAlertDialog() async
  {
    if (!_infProvided()) return true;
    if (!_infUpdated()) return true;
    return (showDialog(context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Changes will not be saved.'),
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

  int printAndReturn(int i)
  {
    _debugNote('Called PrintAndReturn() with: $i');
    return i;
  }

  @override
  void initState()
  {
    _debugNote('Called initState(IFH)');
    super.initState();
    _word = widget.word;
    _prepare();
  }

  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build(IFH).');
    return WillPopScope(
      onWillPop: _showPopAlertDialog,

      child: ScaffoldMessenger(
        key: _ewScaffoldMState,
        child: Scaffold(

          appBar: AppBar(
            leading: const BackButton(),
            title: AppBarTitle('Edit Word'),
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
                _toWord();
                await _wordDB.updateWord(_newWord);
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
                itemCount: _wordFields.length,
                itemBuilder: (context, wIndex) => _wordFields[printAndReturn(wIndex)],
              ),

              TextButton(
                child: const Text('+ Add a synonym'),
                onPressed: ()
                {
                  setState(()
                  {
                    _wordFields.add(InputField(hintText: 'Word', labelText: 'Word', helperText: 'Enter new word',));
                  });
                },
              ),


              const Divider(height: 30),


              ListView.builder( // Descriptions
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _descriptionFields.length,
                itemBuilder: (context, dIndex) => _descriptionFields[printAndReturn(dIndex)],
              ),

              TextButton(
                child: const Text('+ Add another description'),
                onPressed: ()
                {
                  setState(()
                  {
                    _descriptionFields.add(InputField(hintText: 'Description', labelText: 'Description', helperText: 'Enter new description', maxLines: null,));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_debugNote(String s)
{
  debugPrint('EditWordPage: $s');
}
