import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_note_app/utilities/search_filter.dart';

class SearchBar extends StatefulWidget
{
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
{
  final TextEditingController _searchField = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    final _filter = Provider.of<SearchFilter>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchField,
        textInputAction: TextInputAction.done,
        autocorrect: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: 'Search',
          hintText: 'Search',
          helperText: 'Enter some text to search',
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
          ),
          suffixIcon: Consumer<SearchFilter>(
            builder: (context, _sFilter, _) => (_sFilter.getFilter.isNotEmpty) ? IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.clear),
                onPressed: ()
                {
                  setState(()
                  {
                    _searchField.clear();
                    _sFilter.setFilter('');
                  });
                }
            ) : const SizedBox(height: 0, width: 0,),
          ),
        ),
        onChanged: (value) {_filter.setFilter(value);},
      ),
    );
  }

  @override
  void dispose()
  {
    _searchField.dispose();
    super.dispose();
  }
}
