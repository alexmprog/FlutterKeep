import 'package:flutter/material.dart';
import 'package:flutterkeep/blocs/auth_bloc.dart';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/localization/localizations.dart';
import 'package:flutterkeep/ui/auth/welcome_screen.dart';
import 'package:flutterkeep/ui/notes/edit_note_screen.dart';
import 'package:flutterkeep/ui/notes/all_notes_screen.dart';
import 'package:flutterkeep/ui/notes/user_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.noteListTitle,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              bloc.logout().then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => WelcomeScreen()));
              });
            },
          )
        ],
        backgroundColor: Colors.orange,
        elevation: 0.0,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Tab>[
            Tab(text: localizations.allTab),
            Tab(text: localizations.myTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          AllNotesScreen(),
          UserNotesScreen(bloc.loggedUserEmail),
        ],
      ),
      floatingActionButton: _bottomButtons(),
    );
  }

  Widget _bottomButtons() {
    if (_tabController.index == 1) {
      return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditNoteScreen()));
          });
    } else {
      return null;
    }
  }
}
