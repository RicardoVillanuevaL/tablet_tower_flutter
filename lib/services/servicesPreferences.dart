import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasAdmin {
  static final PreferenciasAdmin _instancia = new PreferenciasAdmin._internal();

  factory PreferenciasAdmin() {
    return _instancia;
  }

  PreferenciasAdmin._internal();

  SharedPreferences _preferences;

  initPrefs() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  get token {
    return _preferences.getString('dni') ?? '';
  }

  set token(String value){
    _preferences.setString('dni', value);
  }
  
  get nombreUsuario {
    return _preferences.getString('nombreAdmin');
  }

  set nombreUsuario(String value) {
    _preferences.setString('nombreAdmin', value);
  }
}
