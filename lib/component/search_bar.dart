
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final TextEditingController searchController;

  CustomSearchBar({
    required this.onSearch,
    required this.searchController,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 35,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: TextFormField(
          controller: widget.searchController,
          maxLines: 1,
          minLines: 1,
          cursorColor: Theme.of(context).colorScheme.tertiary,
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w300,
          ),
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search chats by: UserID, Message",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontFamily: "Gilmer",
              fontWeight: FontWeight.w500,
            ),
            focusColor: Theme.of(context).colorScheme.tertiary,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 0,
              ),
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
