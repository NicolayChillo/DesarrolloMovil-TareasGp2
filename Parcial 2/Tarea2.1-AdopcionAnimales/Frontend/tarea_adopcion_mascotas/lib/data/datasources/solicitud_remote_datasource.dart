// data/datasources/solicitud_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/solicitud_adopcion_model.dart';

abstract class SolicitudRemoteDataSource {
  // 📋 READ
  Future<List<SolicitudAdopcionModel>> obtenerSolicitudes({int? mascotaId, String? estado});
  Future<SolicitudAdopcionModel> obtenerSolicitudPorId(int id);
  
  // ➕ CREATE
  Future<SolicitudAdopcionModel> crearSolicitud(SolicitudAdopcionModel solicitud);
  
  // ✏️ UPDATE
  Future<SolicitudAdopcionModel> actualizarSolicitud({
    required int id,
    String? nombreSolicitante,
    String? telefono,
    String? comentario,
    String? estado,
  });
  
  // 🗑️ DELETE
  Future<void> eliminarSolicitud(int id);
  
  // ✅ ACCIONES
  Future<void> aprobarSolicitud(int id);
  Future<void> rechazarSolicitud(int id);
}

class SolicitudRemoteDataSourceImpl implements SolicitudRemoteDataSource {
  final http.Client client;
  SolicitudRemoteDataSourceImpl({required this.client});

  // ============================================================
  // 📋 READ - Obtener todas las solicitudes
  // ============================================================
  @override
  Future<List<SolicitudAdopcionModel>> obtenerSolicitudes({int? mascotaId, String? estado}) async {
    try {
      final params = <String, String>{};
      if (mascotaId != null) params['mascota_id'] = mascotaId.toString();
      if (estado != null) params['estado'] = estado;
      
      final uri = Uri.parse(ApiConstants.getSolicitudes())
          .replace(queryParameters: params.isEmpty ? null : params);
      
      print('📤 GET: $uri');
      final response = await client.get(uri);
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SolicitudAdopcionModel.fromJson(json)).toList();
      }
      throw Exception('Error al obtener solicitudes: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // 📋 READ - Obtener solicitud por ID
  // ============================================================
  @override
  Future<SolicitudAdopcionModel> obtenerSolicitudPorId(int id) async {
    try {
      final url = ApiConstants.getSolicitudById(id);
      print('📤 GET: $url');
      
      final response = await client.get(Uri.parse(url));
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return SolicitudAdopcionModel.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 404) {
        throw Exception('Solicitud no encontrada');
      }
      throw Exception('Error al obtener solicitud: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // ➕ CREATE - Crear solicitud
  // ============================================================
  @override
  Future<SolicitudAdopcionModel> crearSolicitud(SolicitudAdopcionModel solicitud) async {
    try {
      // ✅ Usa la URL correcta con la barra final
      final url = ApiConstants.crearSolicitud();
      print('📤 POST: $url');
      print('📝 Body: ${solicitud.toJson()}');
      
      final response = await client.post(
        Uri.parse(url), // ✅ URL ya tiene la barra final
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(solicitud.toJson()),
      );
      
      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SolicitudAdopcionModel.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 400) {
        final body = jsonDecode(response.body);
        throw Exception(body['detail'] ?? 'No se pudo crear la solicitud');
      }
      throw Exception('Error al crear solicitud: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }    

  // ============================================================
  // ✏️ UPDATE - Actualizar solicitud
  // ============================================================
  @override
  Future<SolicitudAdopcionModel> actualizarSolicitud({
    required int id,
    String? nombreSolicitante,
    String? telefono,
    String? comentario,
    String? estado,
  }) async {
    try {
      final url = ApiConstants.actualizarSolicitud(id);
      print('📤 PUT: $url');
      
      final body = <String, dynamic>{};
      if (nombreSolicitante != null) body['nombre_solicitante'] = nombreSolicitante;
      if (telefono != null) body['telefono'] = telefono;
      if (comentario != null) body['comentario'] = comentario;
      if (estado != null) body['estado'] = estado;
      
      print('📝 Body: $body');
      
      final response = await client.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return SolicitudAdopcionModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Error al actualizar solicitud: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // 🗑️ DELETE - Eliminar solicitud
  // ============================================================
  @override
  Future<void> eliminarSolicitud(int id) async {
    try {
      final url = ApiConstants.eliminarSolicitud(id);
      print('📤 DELETE: $url');
      
      final response = await client.delete(Uri.parse(url));
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar solicitud: ${response.statusCode}');
      }
      print('✅ Solicitud eliminada');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // ✅ APROBAR solicitud
  // ============================================================
  @override
  Future<void> aprobarSolicitud(int id) async {
    try {
      final url = ApiConstants.aprobarSolicitud(id);
      print('📤 PATCH: $url');
      
      final response = await client.patch(Uri.parse(url));
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Error al aprobar solicitud: ${response.statusCode}');
      }
      print('✅ Solicitud aprobada');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // ❌ RECHAZAR solicitud
  // ============================================================
  @override
  Future<void> rechazarSolicitud(int id) async {
    try {
      final url = ApiConstants.rechazarSolicitud(id);
      print('📤 PATCH: $url');
      
      final response = await client.patch(Uri.parse(url));
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Error al rechazar solicitud: ${response.statusCode}');
      }
      print('✅ Solicitud rechazada');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}