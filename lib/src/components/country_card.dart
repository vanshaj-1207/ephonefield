import 'package:flutter/material.dart';

import '../enums/country.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({super.key, required this.country, this.showFlag = false});
  final Country country;
  final bool showFlag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: showFlag
          ? Image.asset(
              country.flagImagePath,
              width: 32.0,
              package: 'ephonefield',
            )
          : const SizedBox.shrink(),
      minLeadingWidth: showFlag ? 40 : 0,
      title: Text(country.name),
      subtitle: Text(country.alpha3),
      trailing: Text(
        '+${country.dialCode}',
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
