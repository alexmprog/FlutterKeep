import 'dart:async';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/data/firebase_vision_api.dart';
import 'package:flutterkeep/models/note.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutterkeep/data/firestore_api.dart';

class EditNoteBloc implements BlocBase {
  final String loggedUserEmail;

  EditNoteBloc(this.loggedUserEmail);

  final _firestoreApi = FirestoreApi();
  final _firebaseVisionApi = FirebaseVisionApi();
  final _title = BehaviorSubject<String>();
  final _noteMessage = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();

  Stream<String> get name => _title.stream.transform(_validateName);

  Stream<String> get noteMessage =>
      _noteMessage.stream.transform(_validateMessage);

  Stream<bool> get showProgress => _showProgress.stream;

  Function(String) get changeName => _title.sink.add;

  Function(String) get changeGoalMessage => _noteMessage.sink.add;

  final _validateMessage = StreamTransformer<String, String>.fromHandlers(
      handleData: (goalMessage, sink) {
    if (goalMessage.length > 10) {
      sink.add(goalMessage);
    } else {
      sink.addError(NoteValidationError.wrongMessage);
    }
  });

  final _validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (String name, sink) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(name)) {
      sink.addError(NoteValidationError.wrongTitle);
    } else {
      sink.add(name);
    }
  });

  void submit() {
    _showProgress.sink.add(true);
    _firestoreApi
        .uploadNote(loggedUserEmail, _title.value, _noteMessage.value)
        .then((value) {
      _showProgress.sink.add(false);
    });
  }

  @override
  void dispose() async {
    await _noteMessage.drain();
    _noteMessage.close();
    await _title.drain();
    _title.close();
    await _showProgress.drain();
    _showProgress.close();
  }

  void extractText(var image) {
    _firebaseVisionApi.getImage(image).then((text) {
      _noteMessage.sink.add(text);
    });
  }
}
