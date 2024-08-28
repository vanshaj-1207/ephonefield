import 'package:flutter/material.dart';

import '../enums/country.dart';
import '../enums/country_picker_height.dart';
import '../enums/country_picker_menu.dart';
import 'country_card.dart';
import 'country_picker_menu.dart';

class CountryPickerButton extends StatelessWidget {
  const CountryPickerButton({
    super.key,
    required this.initialValue,
    required this.onValuePicked,
    required this.menuType,
    required this.isSearchable,
    required this.showFlag,
    required this.searchInputDecoration,
    required this.titlePadding,
    required this.title,
    required this.countries,
    required this.width,
    required this.icon,
    required this.pickerHeight,
    required this.textStyle,
  });

  final void Function(Country) onValuePicked;
  final Country initialValue;
  final List<Country> countries;
  final PickerMenuType menuType;
  final bool isSearchable;
  final bool showFlag;
  final InputDecoration searchInputDecoration;
  final EdgeInsetsGeometry titlePadding;
  final CountryPickerHeigth pickerHeight;
  final String? title;
  final double width;
  final IconData icon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openCountryPickerMenu(
          menuType,
          context,
          searchInputDecoration,
          title,
          titlePadding,
          pickerHeight,
          isSearchable,
          showFlag,
          countries,
          onValuePicked),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SizedBox(
          width: width,
          height: 20,
          child: Row(
            mainAxisAlignment: showFlag
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '+${initialValue.dialCode}',
                style: textStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: showFlag ? 4.0 : 0,
              ),
              showFlag
                  ? Image.asset(
                      initialValue.flagImagePath,
                      width: 20.0,
                      package: 'ephonefield',
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                width: showFlag ? 4.0 : 0,
              ),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}

void Function()? _openCountryPickerMenu(
    PickerMenuType menuType,
    BuildContext context,
    InputDecoration searchInputDecoration,
    String? title,
    EdgeInsetsGeometry titlePadding,
    CountryPickerHeigth pickerHeight,
    bool isSearchable,
    bool showFlag,
    List<Country> countries,
    void Function(Country) onValuePicked) {
  switch (menuType) {
    case PickerMenuType.dialog:
      return _openCountryPickerDialog(
          context,
          searchInputDecoration,
          title,
          titlePadding,
          isSearchable,
          showFlag,
          pickerHeight,
          countries,
          onValuePicked);
    case PickerMenuType.bottomSheet:
      return _openCountryPickerBottomSheet(
          context,
          searchInputDecoration,
          title,
          titlePadding,
          isSearchable,
          showFlag,
          pickerHeight,
          countries,
          onValuePicked);
    case PickerMenuType.page:
      return _openCountryPickerPage(context, searchInputDecoration, title,
          titlePadding, isSearchable, showFlag, countries, onValuePicked);
  }
}

void Function()? _openCountryPickerDialog(
    BuildContext context,
    InputDecoration searchInputDecoration,
    String? title,
    EdgeInsetsGeometry titlePadding,
    bool isSearchable,
    bool showFlag,
    CountryPickerHeigth pickerHeight,
    List<Country> countries,
    void Function(Country) onValuePicked) {
  return () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: titlePadding,
        content: SizedBox(
          height: pickerHeight.height(context),
          width: MediaQuery.of(context).size.width * 0.8,
          child: CountryPickerMenu(
            title: title,
            titlePadding: titlePadding,
            isSearchable: isSearchable,
            showFlag: showFlag,
            height: pickerHeight.height(context),
            searchInputDecoration: searchInputDecoration,
            onValuePicked: (Country country) {
              return onValuePicked(country);
            },
            itemBuilder: (Country country) {
              return CountryCard(
                country: country,
                showFlag: showFlag,
              );
            },
            countries: countries,
          ),
        ),
      ),
    );
  };
}

void Function()? _openCountryPickerBottomSheet(
  BuildContext context,
  InputDecoration searchInputDecoration,
  String? title,
  EdgeInsetsGeometry titlePadding,
  bool isSearchable,
  bool showFlag,
  CountryPickerHeigth pickerHeight,
  List<Country> countries,
  void Function(Country) onValuePicked,
) {
  return () {
    showModalBottomSheet(
      context: context,
      shape: pickerHeight != CountryPickerHeigth.h100
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            )
          : null,
      isScrollControlled: true,
      builder: (context) => CountryPickerMenu(
        title: title,
        showFlag: showFlag,
        titlePadding: titlePadding,
        isSearchable: isSearchable,
        height: pickerHeight.height(context),
        searchInputDecoration: searchInputDecoration,
        onValuePicked: (Country country) {
          return onValuePicked(country);
        },
        itemBuilder: (Country country) {
          return CountryCard(
            country: country,
            showFlag: showFlag,
          );
        },
        countries: countries,
      ),
    );
  };
}

void Function()? _openCountryPickerPage(
  BuildContext context,
  InputDecoration searchInputDecoration,
  String? title,
  EdgeInsetsGeometry titlePadding,
  bool isSearchable,
  bool showFlag,
  List<Country> countries,
  void Function(Country) onValuePicked,
) {
  return () {
    final CountryPickerMenu pickerMenu = CountryPickerMenu(
      title: null,
      titlePadding: titlePadding,
      isSearchable: isSearchable,
      showFlag: showFlag,
      height: MediaQuery.of(context).size.height,
      searchInputDecoration: searchInputDecoration,
      onValuePicked: (Country country) {
        return onValuePicked(country);
      },
      itemBuilder: (Country country) {
        return CountryCard(
          country: country,
          showFlag: showFlag,
        );
      },
      countries: countries,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Material(
          child: Scaffold(
            appBar: AppBar(
              title: Text(title ?? ""),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            body: pickerMenu,
          ),
        ),
      ),
    );
  };
}
