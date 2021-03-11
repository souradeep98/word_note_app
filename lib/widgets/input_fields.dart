import 'package:flutter/material.dart';
import 'package:word_note_app/widgets/quick_lookup.dart';

class InputField extends StatefulWidget
{
  final int maxLines;
  final String initialValue, hintText, labelText, helperText;
  InputField({this.initialValue = '', this.hintText = '', this.labelText = '', this.helperText = '', this.maxLines = 1});

  String get textEditingControllerText => _ifs.textEditingController.text;
  void showError(String errorM)
  {
    _ifs._showError(errorM);
  }
  void showLookup(int lookUpID)
  {
    _ifs._showLookup(lookUpID);
  }

  final _InputFieldState _ifs = _InputFieldState();

  @override
  _InputFieldState createState() => _ifs;
}

class _InputFieldState extends State<InputField>
{
  String _errorMsg;
  int _lookUp;

  final TextEditingController textEditingController = TextEditingController();

  void _showError(String errorMessage)
  {
    _debugNote('Calling Word TextField showError($errorMessage)');
    this.setState(() {
      _errorMsg = errorMessage;
    });
  }
  void _showLookup(int lookUpID)
  {
    _debugNote('Called showLookup($lookUpID)');
    this.setState(() {
      _lookUp = lookUpID;
    });
  }

  void _clearError(value)
  {
    this.setState(() {
      _errorMsg = null;
      _lookUp = null;
    });
  }

  @override
  void initState()
  {
    super.initState();
    textEditingController.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 20),
      child: TextField(
        maxLines: widget.maxLines,
        controller: textEditingController,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        autocorrect: true,
        //onTap: _clearError,
        autofocus: true,
        onChanged: _clearError,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          helperText: widget.helperText,
          border: const OutlineInputBorder(),
          errorText: _errorMsg,
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              (_lookUp == null) ? const SizedBox(width: 0, height: 0,) : IconButton(
                  tooltip: 'Quick Lookup existing word',
                  icon: const Icon(Icons.open_in_new_rounded),
                  onPressed: ()
                  {
                    showDialog(context: context,
                      builder: (context) => QuickLookup(_lookUp),
                    );
                  }
              ),
              (textEditingController.text.isEmpty) ? const SizedBox(height: 0, width: 0,) : IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.clear),
                onPressed: () async
                {
                  if (await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Content of this field will be cleared.'),
                        actions: [
                          TextButton(
                            onPressed: () {Navigator.pop(context, false);},
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {Navigator.pop(context, true);},
                            child: const Text('Yes'),
                          ),
                        ],
                      )
                  ) ?? false)
                  {
                    setState(()
                    {
                      textEditingController.clear();
                      _errorMsg = null;
                      _lookUp = null;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose()
  {
    // Clean up the controller when the widget is disposed
    textEditingController.dispose();
    _debugNote('TextField disposed');
    super.dispose();
  }
}

void _debugNote(String s)
{
  debugPrint('InputFieldsWidget: $s');
}
