import 'dart:async';

import 'package:flutter/material.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
  }

  String get appTitle => "Flutter Keep";
  String get noteValidateMessage => "Your note should have min of 10 characters";
  String get nameValidateMessage => "Only alphabets are allowed";
  String get emailValidateMessage => "Enter a valid email";
  String get passwordValidateMessage => "Password must be at least 4 characters";
  String get passwordHint => "Enter Password";
  String get emailHint => "Enter Email ID";
  String get submit => "Submit";
  String get errorMessage => "Please fix all the errors";
  String get noteListTitle => "Notes";
  String get noNotes => "No Notes";
  String get addNote => "Add Note";
  String get enterNoteName => "Enter name";
  String get enterNoteMessage => "Enter your note";
  String get scanNote => "Scan note";
  String get allTab => "All";
  String get myTab => "Me";
  String get welcome => "Welcome";

}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {

  @override
  Future<AppLocalizations> load(Locale locale) => Future(() => AppLocalizations());

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}