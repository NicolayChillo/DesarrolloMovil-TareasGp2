// core/constants/api_constants.dart
class ApiConstants {
  // ⚠️ URL BASE - Actualiza cuando ngrok cambie
  static const String baseUrl = 'https://consensus-syrup-bogus.ngrok-free.dev';
  
  // 📋 Endpoints - CON BARRA FINAL
  static const String mascotas = '/mascotas/';
  static const String solicitudes = '/solicitudes/';
  
  // ============================================================
  // MÉTODOS PARA MASCOTAS
  // ============================================================
  
  static String getMascotas() => '$baseUrl$mascotas';
  static String mascotaDetalle(int id) => '$baseUrl$mascotas$id';
  static String crearMascota() => '$baseUrl$mascotas';
  static String actualizarMascota(int id) => '$baseUrl$mascotas$id';
  static String eliminarMascota(int id) => '$baseUrl$mascotas$id';
  
  // ============================================================
  // MÉTODOS PARA SOLICITUDES
  // ============================================================
  
  static String getSolicitudes() => '$baseUrl$solicitudes';
  static String getSolicitudById(int id) => '$baseUrl$solicitudes$id';
  static String crearSolicitud() => '$baseUrl$solicitudes';
  static String actualizarSolicitud(int id) => '$baseUrl$solicitudes$id';
  static String eliminarSolicitud(int id) => '$baseUrl$solicitudes$id';
  static String aprobarSolicitud(int id) => '$baseUrl$solicitudes$id/aprobar';
  static String rechazarSolicitud(int id) => '$baseUrl$solicitudes$id/rechazar';
  
  // ============================================================
  // DEBUG
  // ============================================================
  
  static void printUrls() {
    print('🔍 ===== API URLs =====');
    print('📡 Base URL: $baseUrl');
    print('📋 GET Mascotas: ${getMascotas()}');
    print('📋 GET Solicitudes: ${getSolicitudes()}');
    print('📋 POST Solicitud: ${crearSolicitud()}');
    print('📋 PATCH Aprobar: ${aprobarSolicitud(1)}');
    print('📋 PATCH Rechazar: ${rechazarSolicitud(1)}');
    print('🔍 ====================');
  }
}