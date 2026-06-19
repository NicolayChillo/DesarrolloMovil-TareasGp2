
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/solicitud_adopcion_model.dart';

abstract class SolicitudRemoteDataSource {
  Future<SolicitudAdopcionModel> crearSolicitud(SolicitudAdopcionModel solicitud);
  Future<List<SolicitudAdopcionModel>> obtenerSolicitudes({int? mascotaId, String? estado});
  Future<void> aprobarSolicitud(int id);
  Future<void> rechazarSolicitud(int id);
}

class SolicitudRemoteDataSourceImpl implements SolicitudRemoteDataSource {
  final http.Client client;
  SolicitudRemoteDataSourceImpl({required this.client});

  @override
  Future<SolicitudAdopcionModel> crearSolicitud(SolicitudAdopcionModel solicitud) async {
    final response = await client.post(
      Uri.parse(ApiConstants.solicitudes),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(solicitud.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SolicitudAdopcionModel.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'No se pudo crear la solicitud');
    }
    throw Exception('Error al crear solicitud: ${response.statusCode}');
  }

  @override
  Future<List<SolicitudAdopcionModel>> obtenerSolicitudes({int? mascotaId, String? estado}) async {
    final params = <String, String>{};
    if (mascotaId != null) params['mascota_id'] = mascotaId.toString();
    if (estado != null) params['estado'] = estado;
    final uri = Uri.parse(ApiConstants.solicitudes)
        .replace(queryParameters: params.isEmpty ? null : params);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SolicitudAdopcionModel.fromJson(json)).toList();
    }
    throw Exception('Error al obtener solicitudes: ${response.statusCode}');
  }

  @override
  Future<void> aprobarSolicitud(int id) async {
    final response = await client.post(Uri.parse(ApiConstants.aprobarSolicitud(id)));
    if (response.statusCode != 200) {
      throw Exception('Error al aprobar solicitud: ${response.statusCode}');
    }
  }

  @override
  Future<void> rechazarSolicitud(int id) async {
    final response = await client.post(Uri.parse(ApiConstants.rechazarSolicitud(id)));
    if (response.statusCode != 200) {
      throw Exception('Error al rechazar solicitud: ${response.statusCode}');
    }
  }
}