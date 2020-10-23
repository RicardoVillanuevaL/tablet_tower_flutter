import 'package:tablet_tower_flutter/database/database.dart';
import 'package:tablet_tower_flutter/models/InnerJoinModel.dart';
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

  static Future<bool> actualizarTipodeUsuario(var dni, var value) async {
    bool success;
    try {
      final query = '''UPDATE ${DatabaseCreator.tableEmpleado}
      SET ${DatabaseCreator.id_empresa} = $value
      WHERE ${DatabaseCreator.empleado_dni} = ?''';
      // List<String> params = [value.toString(), dni];
      List<String> params = [dni];
      // final result = await db.rawUpdate(query);
      final result = await db.rawUpdate(query, params);
      DatabaseCreator.databaseLog(
          'actualizar tipo empleado', query, null, result, params);
      success = true;
    } catch (e) {
      print('ERROR' + e);
      success = false;
    }
    return success;
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

  static Future<List<PerfilModel>> sincroEmployee() async {
    final query = '''SELECT * FROM ${DatabaseCreator.tableEmpleado} 
        WHERE ${DatabaseCreator.empleado_dni} <> ${DatabaseCreator.empleado_nombre}''';
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

  static Future<List<ReporteModel>> selectReporte() async {
    final query =
        '''SELECT M.marcado_dni, E.empleado_nombre, E.empleado_apellido,
            M.marcado_fecha_hora, M.marcado_tiempo, M.marcado_latitud,M.marcado_longitud,
            M.marcado_tipo,M.marcado_temperatura FROM marcado	M
            INNER JOIN empleado E ON M.marcado_dni = E.empleado_dni''';

    final data = await db.rawQuery(query);

    List<ReporteModel> listaReporte = List();
    for (final node in data) {
      final temp = ReporteModel.fromJsonLocal(node);
      listaReporte.add(temp);
    }
    print(listaReporte);
    return listaReporte;
  }

  static Future<bool> generarIndicadorEmpleado() async {
    bool success;
    try {
      final sql = '''UPDATE ${DatabaseCreator.tableEmpleado} 
      SET ${DatabaseCreator.id_turno} = 1''';
      final result = await db.rawUpdate(sql);
      DatabaseCreator.databaseLog(
          'indicador creado empleado', sql, null, result);
      success = true;
    } catch (e) {
      print(e);
      success = false;
    }
    return success;
  }

  static Future<bool> generarIndicadorMarcado() async {
    bool success;
    try {
      final sql = '''UPDATE ${DatabaseCreator.tableMarcado} 
      SET ${DatabaseCreator.marcado_dataQR} = ?''';
      List<dynamic> params = ['REGISTRO SUBIDO EXITOSO'];
      final result = await db.rawUpdate(sql, params);
      DatabaseCreator.databaseLog(
          'indicador creado MARCADO', sql, null, result, params);
      success = true;
    } catch (e) {
      print(e);
      success = false;
    }
    return success;
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
      ${DatabaseCreator.hora_fin},
      ${DatabaseCreator.id_empresa}
      ) VALUES (?,?,?,?,?,?,?)''';
    List<dynamic> params = [
      model.empleadoDni,
      model.empleadoNombre,
      model.empleadoApellido,
      model.empleadoTelefono,
      model.horaInicio,
      model.horaFin,
      model.idEmpresa
    ];
    try {
      final result = await db.rawInsert(query, params);
      DatabaseCreator.databaseLog('Add Empleado', query, null, result, params);
    } catch (e) {
      print(e);
    }
  }

  static Future<List<MarcationModel>> listarMarcaciones() async {
    final query = '''SELECT * FROM ${DatabaseCreator.tableMarcado}''';
    final data = await db.rawQuery(query);

    List<MarcationModel> listMarcaciones = List();
    for (final nodo in data) {
      final temp = MarcationModel.fromJsonLocal(nodo);
      listMarcaciones.add(temp);
    }
    print(listMarcaciones.length);
    return listMarcaciones;
  }

  static Future<List<NotificationModel>> listaNotificaciones() async {
    final query = '''SELECT * FROM ${DatabaseCreator.tableNotificacion}''';
    final data = await db.rawQuery(query);

    List<NotificationModel> listNotificaciones = List();
    for (final nodo in data) {
      final temp = NotificationModel.fromJsonLocal(nodo);
      listNotificaciones.add(temp);
    }
    return listNotificaciones;
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
