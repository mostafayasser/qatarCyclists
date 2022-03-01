import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

mixin Validator {
  // String phoneValidator(String value, BuildContext context) {
  //   if (value == null || value.isEmpty) {
  //     return AppLocalizations.of(context).translate("phone_validator");
  //   }
  //   return null;
  // }

  String namelValidator(String value, BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return locale.get('Name is empty') ?? 'Name is empty';
    } else if (value.length < 2) {
      return locale.get('Too short name') ?? 'Too short name';
    }
    return null;
  }

  String textFieldValidator(String value, BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return locale.get('field is empty') ?? 'field is empty';
    } else if (value.length < 2) {
      return locale.get('Too short text') ?? 'Too short text';
    }
    return null;
  }

  String emailValidator(String value, BuildContext context) {
    final locale = AppLocalizations.of(context);

    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return locale.get('Inavalid Email Adress') ?? 'Inavalid Email Adress';
    }
    return null;
  }

  String passwordValidator(String value, BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (value.length < 8) {
      return locale.get('Password must be at least 8 characters.') ??
          'Password must be at least 8 characters.';
    }
    return null;
  }

  String mobileValidator(String value, BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (value.isEmpty) {
      return locale.get('Mobile is empty') ?? 'Mobile is empty';
    }
    return null;
  }

  String userNameValidator(String value, BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return locale.get('Username is empty') ?? 'Username is empty';
    } else if (value.length < 2) {
      return locale.get('Too short username') ?? 'Too short username';
    }
    return null;
  }
}
