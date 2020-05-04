import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/auth_bloc.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/blocs/notes_bloc.dart';
import 'package:flutterkeep/ui/auth/welcome_screen.dart';
import 'package:flutterkeep/ui/home/home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() {
    return new AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return FutureBuilder(
        future: bloc.isLogged(),
        builder: (BuildContext context, AsyncSnapshot<bool> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            if (asyncSnapshot.data) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider<NotesBloc>(
                              bloc: NotesBloc(),
                              child: HomeScreen(),
                            )));
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => WelcomeScreen()));
              });
            }
          }
          return Container();
        });
  }
}
