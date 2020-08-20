import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tablet_tower_flutter/database/database.dart';
import 'package:tablet_tower_flutter/profileInfo.dart';

/// Forces landscape-only mode application-wide
/// Use this Mixin on the main app widget i.e. app.Dart
/// Flutter's 'App' has to extend Stateless widget.
///
/// Call `super.build(context)` in the main build() method
/// to enable landscape only mode
mixin LandScapeModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _landScapeModeOnly();
    return null;
  }
}

/// Forces landscape-only mode on a specific screen
/// Use this Mixin in the specific screen you want to
/// block to landscape only mode.
///
/// Call `super.build(context)` in the State's build() method
/// and `super.dispose();` in the State's dispose() method
mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _landScapeModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
  }
}

/// blocks rotation; sets orientation to: landScape
void _landScapeModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget with LandScapeModeMixin {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      title: 'Tablet Tower',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {
        'home' :(_) => MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  void openLector() async {
    await new Future.delayed(const Duration(seconds: 5), () {
      marcationType();
    });
  }

  @override
  Widget build(BuildContext context) {
    openLector();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width - 30.0;
    final screenHeight = screenSize.height - 30.0;
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => marcationType(),
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: FittedBox(
              child: Image.asset('assets/logo_toweramdtower.png'),
            ),
          ),
        ),
      ),
    );
  }

  marcationType() async {
    String futureString = '';
    try {
      futureString = await BarcodeScanner.scan();
      if (futureString != null) {
        String contenido = futureString;
        print(contenido);

        // Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => ProfileInfo(contenido)),
        //     (_) => false);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfileInfo(contenido)));
      }
    } catch (e) {
      futureString = e.toString();
    }
  }
}
