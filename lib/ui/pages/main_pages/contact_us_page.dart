import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeaderColor(context),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Barzan Park, Umm Salal Ali, Al Shamal Road"),
                SizedBox(
                  height: 10,
                ),
                Text("Contact: +97455377677"),
                SizedBox(
                  height: 10,
                ),
                Text("Email: qatarcyclists@gmail.com"),
              ],
            ),
          )
        ],
      ),
    );
  }

  HeaderColor buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      hasTitle: true,
      hasBack: true,
      title: locale.get('Contact Us') ?? 'Contact Us',
    );
  }
}
