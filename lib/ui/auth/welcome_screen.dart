import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/auth_bloc.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/blocs/notes_bloc.dart';
import 'package:flutterkeep/localization/localizations.dart';
import 'package:flutterkeep/models/auth.dart';
import 'package:flutterkeep/ui/home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.welcome,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment(0.0, 0.0),
        child: AuthForm(),
      ),
    );
  }
}

class AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        emailField(context),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        passwordField(context),
        Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
        submitButton(context)
      ],
    );
  }

  Widget passwordField(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          final localizations = AppLocalizations.of(context);
          var error;
          if (snapshot.error is AuthValidationError) {
            error = _getAuthValidationErrorMessage(
                localizations, snapshot.error as AuthValidationError);
          }
          return TextField(
            onChanged: bloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
                hintText: localizations.passwordHint,
                errorText: error),
          );
        });
  }

  Widget emailField(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return StreamBuilder(
        stream: bloc.email,
        builder: (context, snapshot) {
          final localizations = AppLocalizations.of(context);
          var error;
          if (snapshot.error is AuthValidationError) {
            error = _getAuthValidationErrorMessage(
                localizations, snapshot.error as AuthValidationError);
          }
          return TextField(
            onChanged: bloc.changeEmail,
            decoration: InputDecoration(
                hintText: localizations.emailHint, errorText: error),
          );
        });
  }

  Widget submitButton(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return StreamBuilder(
        stream: bloc.signInStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              (snapshot.hasData && !snapshot.data)) {
            return button(context);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    final localizations = AppLocalizations.of(context);
    return RaisedButton(
        child: Text(localizations.submit),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          if (bloc.validateFields()) {
            authenticateUser(context);
          } else {
            final snackbar = SnackBar(
                content: Text(localizations.errorMessage),
                duration: new Duration(seconds: 2));
            Scaffold.of(context).showSnackBar(snackbar);
          }
        });
  }

  void authenticateUser(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    bloc.showProgressBar(true);
    bloc.login().then((value) {
      if (!value) {
        bloc.signUp().then((value) {
          _openHomeScreen(context);
        });
      } else {
        _openHomeScreen(context);
      }
    });
  }

  void _openHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider<NotesBloc>(
                  bloc: NotesBloc(),
                  child: HomeScreen(),
                )));
  }

  // ignore: missing_return
  String _getAuthValidationErrorMessage(
      AppLocalizations localizations, AuthValidationError error) {
    switch (error) {
      case AuthValidationError.wrongEmail:
        {
          return localizations.emailValidateMessage;
        }
      case AuthValidationError.wrongPassword:
        {
          return localizations.passwordValidateMessage;
        }
    }
  }
}
