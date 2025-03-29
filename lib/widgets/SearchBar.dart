import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSearch(String value) {
    widget.onSearch(value); // Call the onSearch callback with the search query
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // Make the search bar slightly smaller
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Type your ingredients',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0), // Fully rounded corners
            ),
            filled: true,
            fillColor: Colors.white, // Add color to the search field
          ),
          onChanged: _handleSearch, // Trigger search logic on text change
        ),
      ),
    );
  }
}
