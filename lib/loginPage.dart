import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tablet_tower_flutter/HomePage.dart';
import 'package:tablet_tower_flutter/utils/notifications.dart' as util;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String dni, nombre;
  int stateView;
  TextEditingController controllerDNI, controllerNombre;
  bool obscureText;

  @override
  void initState() {
    controllerDNI = TextEditingController();
    controllerNombre = TextEditingController();
    obscureText = true;
    stateView = 0;
    obtenerLogin();
    super.initState();
  }

  void goHome() async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyHomePage()), (_) => false);
    });
  }

  obtenerLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dni = preferences.get('dni') ?? null;
    if (dni == null) {
      setState(() {
        stateView = 1;
      });
    } else {
      setState(() {
        stateView = 2;
      });
    }
  }

  guardarLogin() async {
    try {
      String dniData = controllerDNI.text.trim().toLowerCase();
      String nombreData = controllerNombre.text.trim();
      if (dniData.length == 0 && nombreData.length == 0) {
        //mensaje de error en data en blanco
        util.alertaConImagen(context, 'Oh no!',
            'Error al registrar, datos incompleto', 'assets/userError.png');
      } else {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('dni', dniData);
        preferences.setString('user', nombreData);
        util.alertaConImagen(context, 'Exitó!', 'Datos guardados correctamente',
            'assets/userCheck.png');
        goHome();
      }
    } catch (e) {
      print(e);
      util.alertaConImagen(context, 'Oh no!',
          'Error al registrar, datos incompleto', 'assets/userError.png');
    }
  }

  viewChange(double height, double width) {
    if (stateView == 0) {
      return CupertinoActivityIndicator(
        radius: 15,
      );
    } else if (stateView == 1) {
      return viewLogin(height, width);
    } else if (stateView == 2) {
      return viewVerification(height, width);
    }
  }

  viewLogin(double height, double width) {
    return Center(
      child: Container(
        width: width - 100,
        height: height / 1.25,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 100,
                      child: Image(
                        image: AssetImage('assets/userAdmin.png'),
                        fit: BoxFit.fill,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Nombre',
                      labelText: 'Nombre del Administrador:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_pin)),
                  controller: controllerNombre,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'DNI',
                              labelText: 'DNI de Administrador:',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outline)),
                          controller: controllerDNI,
                          obscureText: obscureText,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton.icon(
                    shape: StadiumBorder(),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    onPressed: () {
                      guardarLogin();
                    },
                    icon: Icon(Icons.check_circle),
                    label: Text('Registrar'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  viewVerification(double height, double width) {
    goHome();
    return Center(
      child: Container(
        width: width - 100,
        height: height - 100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 100,
                      child: Image(
                        image: AssetImage('assets/userCheck.png'),
                        fit: BoxFit.fill,
                      )),
                ),
                Text(
                  'Acceso Verificado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Scaffold(
      body: Center(child: viewChange(screenHeight, screenWidth)),
    );
  }
}
