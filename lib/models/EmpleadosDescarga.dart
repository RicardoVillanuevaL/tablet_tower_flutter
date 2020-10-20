import 'dart:convert';

List<DownloadEmployee> downloadEmployeeFromJson(String str) => List<DownloadEmployee>.from(json.decode(str).map((x) => DownloadEmployee.fromJson(x)));

String downloadEmployeeToJson(List<DownloadEmployee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DownloadEmployee {
    DownloadEmployee({
        this.empleadoDni,
        this.empleadoNombre,
        this.empleadoApellido,
        this.empleadoTelefono,
        this.idEmpresa,
    });

    String empleadoDni;
    String empleadoNombre;
    String empleadoApellido;
    String empleadoTelefono;
    String idEmpresa;

    factory DownloadEmployee.fromJson(Map<String, dynamic> json) => DownloadEmployee(
        empleadoDni: json["empleado_dni"],
        empleadoNombre: json["empleado_nombre"],
        empleadoApellido: json["empleado_apellido"],
        empleadoTelefono: json["empleado_telefono"] == null ? null : json["empleado_telefono"],
        idEmpresa: json["id_empresa"] == null ? null : json["id_empresa"],
    );

    Map<String, dynamic> toJson() => {
        "empleado_dni": empleadoDni,
        "empleado_nombre": empleadoNombre,
        "empleado_apellido": empleadoApellido,
        "empleado_telefono": empleadoTelefono == null ? null : empleadoTelefono,
        "id_empresa": idEmpresa == null ? null : idEmpresa,
    };
}
