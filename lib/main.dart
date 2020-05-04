import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/ui/auth/auth_screen.dart';
import 'blocs/auth_bloc.dart';
import 'localization/localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: AuthBloc(),
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.black,
          primaryColor: Colors.orange,
        ),
        localizationsDelegates: [
          AppLocalizationsDelegate(),
        ],
        home: AuthScreen(),
      ),
    );
  }
}
