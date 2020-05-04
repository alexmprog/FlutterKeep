import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/blocs/notes_bloc.dart';
import 'package:flutterkeep/localization/localizations.dart';
import 'package:flutterkeep/models/note.dart';

class UserNotesScreen extends StatelessWidget {
  final String _emailAddress;

  UserNotesScreen(this._emailAddress);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotesBloc>(context);
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: StreamBuilder(
          stream: bloc.getUserNotes(_emailAddress),
          builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
            final localizations = AppLocalizations.of(context);
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return buildList(bloc, snapshot.data);
              } else {
                return Text(localizations.noNotes);
              }
            } else {
              return Text(localizations.noNotes);
            }
          }),
    );
  }

  ListView buildList(NotesBloc bloc, List<Note> notesList) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: notesList.length,
        itemBuilder: (context, index) {
          final item = notesList[index];
          return Dismissible(
              key: Key(item.title),
              onDismissed: (direction) {
                bloc.removeNote(item.title, _emailAddress);
              },
              background: Container(color: Colors.deepOrangeAccent),
              child: ListTile(
                title: Text(
                  notesList[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(notesList[index].message),
              ));
        });
  }
}
