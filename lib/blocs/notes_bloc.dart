import 'dart:async';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/data/firestore_api.dart';
import 'package:flutterkeep/models/note.dart';

class NotesBloc implements BlocBase {
  final _firestoreApi = FirestoreApi();

  Stream<List<Note>> getUserNotes(String email) =>
      _firestoreApi.getUserNotes(email);

  Stream<List<Note>> getAllUserWithNotes() =>
      _firestoreApi.getAllUserWithNotes();

  @override
  void dispose() {}

  Future removeNote(String title, String email) =>
      _firestoreApi.removeNote(title, email);
}
