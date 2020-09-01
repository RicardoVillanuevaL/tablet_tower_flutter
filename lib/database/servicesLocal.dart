import 'package:tablet_tower_flutter/database/database.dart';
import 'package:tablet_tower_flutter/models/MarcationModel.dart';
import 'package:tablet_tower_flutter/models/NotificacionModel.dart';
import 'package:tablet_tower_flutter/models/PerfilModel.dart';


class RepositoryServicesLocal {
  static Future<PerfilModel> consultarEmpleado(String dni) async {
    PerfilModel result = PerfilModel();
    try {
      final query = '''SELECT * FROM ${DatabaseCreator.tableEmpleado}
              WHERE ${DatabaseCreator.empleado_dni} = ? ''';
      List<dynamic> params = [dni];
      final data = await db.rawQuery(query, params);
      result = PerfilModel.fromJsonLocal(data.first);
    } catch (e) {
      print(e);
      result.empleadoNombre = dni;
      result.empleadoDni = dni;
      result.empleadoApellido = ' ';
      result.empleadoTelefono = ' ';
      result.horaInicio = '10:00:00';
      result.horaFin = '23:00:00';
    }
    return result;
  }

  static Future<List<PerfilModel>> updatesEmployee() async {
    final query = '''SELECT * FROM ${DatabaseCreator.tableEmpleado} 
        WHERE ${DatabaseCreator.empleado_dni} = ${DatabaseCreator.empleado_nombre}''';
    final data = await db.rawQuery(query);

    List<PerfilModel> listEmployee = List();
    for (final nodo in data) {
      final temp = PerfilModel.fromJsonLocal(nodo);
      listEmployee.add(temp);
    }
    return listEmployee;
  }

    static Future<List<PerfilModel>> selectAllEmployee() async {
    final query = '''SELECT * FROM ${DatabaseCreator.tableEmpleado}''';
    final data = await db.rawQuery(query);

    List<PerfilModel> listEmployee = List();
    for (final nodo in data) {
      final temp = PerfilModel.fromJsonLocal(nodo);
      listEmployee.add(temp);
    }
    return listEmployee;
  }

  static Future<bool> actualizarData(PerfilModel model) async {
    bool success;
    try {
      final sql = '''UPDATE ${DatabaseCreator.tableEmpleado} 
      SET ${DatabaseCreator.empleado_nombre} = ?,
      ${DatabaseCreator.empleado_apellido} = ?,
      ${DatabaseCreator.empleado_telefono} = ?
      WHERE ${DatabaseCreator.empleado_dni} = ?
      ''';
      List<dynamic> params = [
        model.empleadoNombre,
        model.empleadoApellido,
        model.empleadoTelefono,
        model.empleadoDni
      ];
      final result = await db.rawUpdate(sql, params);
      DatabaseCreator.databaseLog(
          'actualizar empleado', sql, null, result, params);
      success = true;
    } catch (e) {
      print(e);
      success = false;
    }
    return success;
  }

  static Future<void> addEmpleado(PerfilModel model) async {
    final query = '''INSERT INTO ${DatabaseCreator.tableEmpleado} (
      ${DatabaseCreator.empleado_dni},
      ${DatabaseCreator.empleado_nombre},
      ${DatabaseCreator.empleado_apellido},
      ${DatabaseCreator.empleado_telefono},
      ${DatabaseCreator.hora_inicio},
      ${DatabaseCreator.hora_fin}
      ) VALUES (?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.empleadoDni,
      model.empleadoNombre,
      model.empleadoApellido,
      model.empleadoTelefono,
      model.horaInicio,
      model.horaFin
    ];
    try {
      final result = await db.rawInsert(query, params);
      DatabaseCreator.databaseLog('Add Empleado', query, null, result, params);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addMarcado(MarcationModel model) async {
    final query = '''INSERT INTO ${DatabaseCreator.tableMarcado} (
      ${DatabaseCreator.marcado_id_telefono},
      ${DatabaseCreator.marcado_dni},
      ${DatabaseCreator.marcado_latitud},
      ${DatabaseCreator.marcado_longitud},
      ${DatabaseCreator.marcado_dataQR},
      ${DatabaseCreator.marcado_fecha_hora},
      ${DatabaseCreator.marcado_tipo},
      ${DatabaseCreator.marcado_motivo},
      ${DatabaseCreator.marcado_temperatura},
      ${DatabaseCreator.marcado_tiempo}
    ) VALUES (?,?,?,?,?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.marcadoIdTelefono,
      model.marcadoDni,
      model.marcadoLatitud,
      model.marcadoLongitud,
      model.marcadoDataQr,
      model.marcadoFechaHora,
      model.marcadoTipo,
      model.marcadoMotivo,
      model.marcadoTemperatura,
      model.marcadoTiempo
    ];
    final result = await db.rawInsert(query, params);
    DatabaseCreator.databaseLog('Add Marcado', query, null, result, params);
  }

  static Future<void> addNotificacion(NotificationModel model) async {
    final query = '''INSERT INTO ${DatabaseCreator.tableNotificacion} (
      ${DatabaseCreator.dni_user_notification},
      ${DatabaseCreator.fecha_notification},
      ${DatabaseCreator.latitud_notification},
      ${DatabaseCreator.longtitud_notification},
      ${DatabaseCreator.titulo_notification},
      ${DatabaseCreator.cuerpo_notification}
    ) VALUES (?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.idTelefono,
      model.fechahora,
      model.latitud,
      model.longitud,
      model.titulo,
      model.cuerpo
    ];
    final result = await db.rawInsert(query, params);
    DatabaseCreator.databaseLog(
        'Add Notificacion', query, null, result, params);
  }
}

final localServices = RepositoryServicesLocal();
