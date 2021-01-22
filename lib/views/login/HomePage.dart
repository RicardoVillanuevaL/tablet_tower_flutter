import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tablet_tower_flutter/views/administracion/adminDashBoard.dart';
import 'package:tablet_tower_flutter/views/marcaciones/dashBoard.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width - 30.0;
    final screenHeight = screenSize.height - 30.0;
    return Scaffold(
      body: Center(child: tableDashBoard(screenWidth, screenHeight)),
    );
  }

  tableDashBoard(double width, double height) {
    return Table(
      children: <TableRow>[
        TableRow(children: [
          itemTable(
              width / 2, height / 2, 'assets/search.png', 'Marcaciones', 0),
          itemTable(width / 2, height / 2, 'assets/admin.png',
              'Administrar Personal', 1)
        ])
      ],
    );
  }

  itemTable(double width, double height, String image, String texto, int fn) {
    return InkWell(
      onTap: () => action(fn),
      child: Container(
        width: width,
        child: Column(
          children: [
            Image(
              height: height - 50,
              image: AssetImage(image),
            ),
            Text(
              texto,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  void action(int fn) {
    //0 search
    //1 admin
    switch (fn) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
        break;
      case 1:
        showDialog(
            context: context,
            barrierDismissible: false,
            child: DialogSecurity());
        break;
      default:
    }
  }
}

class DialogSecurity extends StatefulWidget {
  DialogSecurity({Key key}) : super(key: key);

  @override
  _DialogSecurityState createState() => _DialogSecurityState();
}
// 1.ARMAR EL SERVICIO DE BAJADA
// 2.RELLENAR CORRECTAMENTE LA BD LOCAL
// 3.ARREGLAR LOS MODELOS DE LA BASE DE DATOS Y ESTADO DE LOS LISTADOS
// 4.TERMINAR LA SEGURIDAD

class _DialogSecurityState extends State<DialogSecurity> {
  int stateView;
  List<String> listImagenes = [
    'assets/password.png', // 0 normal
    'assets/userError.png', //1 error
    'assets/userCheck.png' // 2 exito!
  ];
  @override
  void initState() {
    stateView = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: dialogContent(context));
  }

  Future<bool> verificationToken(String token) async {
    bool result;
    final preferences = await SharedPreferences.getInstance();
    String tokenPref = preferences.get('dni') ?? null;
    if (token == tokenPref) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  dialogContent(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(
                      image: AssetImage(listImagenes[stateView]),
                      height: 100,
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controller,
                      obscureText: true,
                      maxLines: 1,
                      onEditingComplete: () async {
                        bool result = await verificationToken(_controller.text);
                        if (result) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminDashBoard()));
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('CANCEL',
                              style: TextStyle(color: Colors.red))),
                      FlatButton(
                          onPressed: () async {
                            bool result =
                                await verificationToken(_controller.text);
                            if (result) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminDashBoard()));
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.blueAccent),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
