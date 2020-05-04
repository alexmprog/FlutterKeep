import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterkeep/models/note.dart';

class FirestoreApi {
  static const String usersCollection = 'users';
  static const String emailField = 'email';
  static const String passwordField = 'password';
  static const String notesField = 'notes';
  static const String hasNotesField = 'hasNotes';

  Firestore _firestore = Firestore.instance;

  Future signUp(String email, String password) async {
    return _firestore.collection(usersCollection).document(email).setData(
        {emailField: email, passwordField: password, hasNotesField: false});
  }

  Future<bool> login(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection(usersCollection)
        .where(emailField, isEqualTo: email)
        .getDocuments();
    return result.documents.isNotEmpty;
  }

  Stream<List<Note>> getUserNotes(String email) {
    return _firestore
        .collection(usersCollection)
        .document(email)
        .snapshots()
        .map((DocumentSnapshot snapshot) => _parseSnapshot(email, snapshot));
  }

  Stream<List<Note>> getAllUserWithNotes() {
    return _firestore
        .collection(usersCollection)
        .where(hasNotesField, isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot snapshot) =>
            _parseListOfSnapshot(snapshot.documents));
  }

  Future uploadNote(String email, String title, String note) async {
    DocumentSnapshot doc =
        await _firestore.collection(usersCollection).document(email).get();
    Map<String, String> notes = doc.data[notesField] != null
        ? doc.data[notesField].cast<String, String>()
        : Map();
    notes[title] = note;
    return _firestore
        .collection(usersCollection)
        .document(email)
        .setData({notesField: notes, hasNotesField: true}, merge: true);
  }

  Future removeNote(String title, String email) async {
    DocumentSnapshot doc =
        await _firestore.collection(usersCollection).document(email).get();
    Map<String, String> notes = doc.data[notesField].cast<String, String>();
    notes.remove(title);
    dynamic newNotes = notes.isNotEmpty ? notes : FieldValue.delete();
    return _firestore
        .collection(usersCollection)
        .document(email)
        .updateData({notesField: newNotes, hasNotesField: notes.isNotEmpty});
  }

  List<Note> _parseSnapshot(String email, DocumentSnapshot document) {
    List<Note> noteList = [];
    if (!document.exists) return noteList;
    Map<String, String> notes = document.data[notesField] != null
        ? document.data[notesField].cast<String, String>()
        : null;
    if (notes != null) {
      notes.forEach((title, message) {
        noteList.add(Note(email, title, message));
      });
    }
    return noteList;
  }

  List<Note> _parseListOfSnapshot(List<DocumentSnapshot> list) {
    List<Note> noteList = [];
    if (list.isEmpty) return noteList;
    list.forEach((document) {
      if (document.exists) {
        String email = document.data[emailField];
        var notes = _parseSnapshot(email, document);
        if (notes != null && notes.isNotEmpty) {
          noteList.addAll(notes);
        }
      }
    });
    return noteList;
  }
}
