import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/auth_bloc.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/blocs/edit_note_bloc.dart';
import 'package:flutterkeep/localization/localizations.dart';
import 'package:flutterkeep/models/note.dart';
import 'package:image_picker/image_picker.dart';

class EditNoteScreen extends StatefulWidget {
  @override
  EditNoteState createState() {
    return EditNoteState();
  }
}

class EditNoteState extends State<EditNoteScreen> {
  EditNoteBloc _bloc;
  TextEditingController myController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authBloc = BlocProvider.of<AuthBloc>(context);
    _bloc = EditNoteBloc(authBloc.loggedUserEmail);
  }

  @override
  void dispose() {
    _bloc.dispose();
    myController.dispose();
    super.dispose();
  }

  //Handing back press
  Future<bool> _onWillPop() {
    Navigator.pop(context, false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations.addNote,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.orange,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment(0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              nameField(context),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              noteField(),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              buttons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameField(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.name,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          final localizations = AppLocalizations.of(context);
          var error;
          if (snapshot.error is NoteValidationError) {
            error = _getNoteValidationErrorMessage(
                localizations, snapshot.error as NoteValidationError);
          }
          return TextField(
            onChanged: _bloc.changeName,
            decoration: InputDecoration(
                hintText: localizations.enterNoteName,
                errorText: error),
          );
        });
  }

  Widget noteField() {
    return StreamBuilder(
        stream: _bloc.noteMessage,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          final localizations = AppLocalizations.of(context);
          var error;
          if (snapshot.error is NoteValidationError) {
            error = _getNoteValidationErrorMessage(
                localizations, snapshot.error as NoteValidationError);
          }
          myController.value = myController.value.copyWith(text: snapshot.data);
          return TextField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            onChanged: _bloc.changeGoalMessage,
            decoration: InputDecoration(
                hintText: localizations.enterNoteMessage,
                errorText: error),
          );
        });
  }

  Widget buttons() {
    return StreamBuilder(
        stream: _bloc.showProgress,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                submitButton(context),
                Container(margin: EdgeInsets.only(left: 5.0, right: 5.0)),
                scanButton(context),
              ],
            );
          } else {
            if (!snapshot.data) {
              //hide progress bar
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  submitButton(context),
                  Container(margin: EdgeInsets.only(left: 5.0, right: 5.0)),
                  scanButton(context),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Widget submitButton(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return RaisedButton(
        textColor: Colors.white,
        color: Colors.black,
        child: Text(localizations.submit),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          _bloc.submit();
        });
  }

  Widget scanButton(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return RaisedButton.icon(
        icon: Icon(Icons.add_a_photo),
        label: Text(localizations.scanNote),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          getImage();
        });
  }

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _bloc.extractText(image);
  }

  // ignore: missing_return
  String _getNoteValidationErrorMessage(
      AppLocalizations localizations, NoteValidationError error) {
    switch (error) {
      case NoteValidationError.wrongMessage:
        {
          return localizations.enterNoteMessage;
        }
      case NoteValidationError.wrongTitle:
        {
          return localizations.noteValidateMessage;
        }
    }
  }
}
