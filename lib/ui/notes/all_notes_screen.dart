import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/blocs/notes_bloc.dart';
import 'package:flutterkeep/localization/localizations.dart';
import 'package:flutterkeep/models/note.dart';

class AllNotesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotesBloc>(context);
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: StreamBuilder(
        stream: bloc.getAllUserWithNotes(),
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
        },
      ),
    );
  }

  ListView buildList(NotesBloc bloc, List<Note> noteList) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              noteList[index].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(noteList[index].message),
            trailing: Text(
              noteList[index].email,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
              ),
            ),
          );
        });
  }
}
