import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tablet_tower_flutter/services/servicesPreferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _prefs = PreferenciasAdmin();
  PreferenciasAdmin preferenciasAdmin = PreferenciasAdmin();

  login() {
    return Scaffold(
      body: Center(
        child : Container(
          height: 200,
          width: 200,
          color: Colors.purple,
        )
      ),
    );
  }

  progress() {
    load();
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15,
      ),
    );
  }

  load() async {
    new Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (_) => false);
    });
  }

  check() {
    final token = _prefs.token;
    if (token.toString().length < 0) {
      return login();
    } else {
      return progress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return check();
  }
}
