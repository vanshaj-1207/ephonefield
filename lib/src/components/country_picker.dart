import 'package:flutter/material.dart';


import '../enums/country.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({
    super.key,
    required this.onValuePicked,
    required this.itemBuilder,
    required this.searchInputDecoration,
    required this.isSearchable,
    required this.countries,
     this.showFlag = false,
  });
  final void Function(Country) onValuePicked;
  final Widget Function(Country) itemBuilder;
  final InputDecoration searchInputDecoration;
  final bool isSearchable;
  final bool showFlag;
  final List<Country> countries;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  late List<Country> _filteredCountries;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(() {
      final text = _controller.text;
      if (text.isEmpty) {
        setState(() {
          _filteredCountries = widget.countries;
        });
      } else {
        setState(() {
          _filteredCountries = widget.countries
              .where((country) =>
                  country.alpha2.toLowerCase().contains(text.toLowerCase()) ||
                  country.name.toLowerCase().contains(text.toLowerCase()) ||
                  country.dialCode
                      .toString()
                      .toLowerCase()
                      .contains(text.toLowerCase()))
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: const Key('search-field'),
        focusNode: _focusNode,
        controller: _controller,
        decoration: widget.searchInputDecoration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.isSearchable) _buildSearchField(),
        _filteredCountries.isNotEmpty
            ? Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    key: const Key('country-picker-list'),
                    itemCount: _filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      return InkWell(
                        onTap: () {
                          widget.onValuePicked(country);
                          Navigator.pop(context);
                        },
                        child: widget.itemBuilder(country),
                      );
                    },
                  ),
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  "No countries found",
                 style: TextStyle(
                   fontSize: 18,
                 ),
                )),
      ],
    );
  }
}
