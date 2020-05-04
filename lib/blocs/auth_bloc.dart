import 'dart:async';
import 'package:flutterkeep/blocs/bloc_provider.dart';
import 'package:flutterkeep/data/firestore_api.dart';
import 'package:flutterkeep/models/auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc implements BlocBase {
  static const String loggedUserKey = 'loggedUserKey';

  String _loggedUserEmail;

  final _firebaseApi = FirestoreApi();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Stream<String> get email => _email.stream.transform(_validateEmail);

  Stream<String> get password => _password.stream.transform(_validatePassword);

  Stream<bool> get signInStatus => _isSignedIn.stream;

  String get loggedUserEmail => _loggedUserEmail;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty || email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError(AuthValidationError.wrongEmail);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.isEmpty || password.length > 3) {
      sink.add(password);
    } else {
      sink.addError(AuthValidationError.wrongPassword);
    }
  });

  Future<bool> login() =>
      _firebaseApi.login(_email.value, _password.value).then((value) {
        if (value) {
          _setLogged(_email.value);
        }
        return value;
      });

  Future signUp() =>
      _firebaseApi.signUp(_email.value, _password.value).then((value) {
        _setLogged(_email.value);
      });

  Future logout() async {
    changeEmail("");
    changePassword("");
    showProgressBar(false);
    _setLogged(null);
  }

  Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loggedUserEmail = prefs.getString(loggedUserKey);
    return _loggedUserEmail != null;
  }

  void _setLogged(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loggedUserEmail = email;
    prefs.setString(loggedUserKey, _loggedUserEmail);
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 3) {
      return true;
    } else {
      return false;
    }
  }
}
