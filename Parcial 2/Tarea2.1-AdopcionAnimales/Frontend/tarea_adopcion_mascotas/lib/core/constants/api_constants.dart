
class ApiConstants {
  static const String baseUrl = '192.168.0.103';

  static const String mascotas = '$baseUrl/mascotas';
  static const String solicitudes = '$baseUrl/solicitudes';

  static String mascotaDetalle(int id) => '$mascotas/$id';
  static String aprobarSolicitud(int id) => '$solicitudes/$id/aprobar';
  static String rechazarSolicitud(int id) => '$solicitudes/$id/rechazar';
}