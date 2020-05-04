class Note {
  final String _email;
  final String _title;
  final String _message;

  Note(this._email, this._title, this._message);

  String get email => _email;

  String get title => _title;

  String get message => _message;
}

enum NoteValidationError { wrongTitle, wrongMessage }