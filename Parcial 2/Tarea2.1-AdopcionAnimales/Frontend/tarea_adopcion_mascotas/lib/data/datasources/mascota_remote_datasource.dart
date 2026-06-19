// data/datasources/mascota_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/mascota_model.dart';

abstract class MascotaRemoteDataSource {
  Future<List<MascotaModel>> obtenerMascotas({String? estado});
  Future<MascotaModel> obtenerMascotaPorId(int id);
}

class MascotaRemoteDataSourceImpl implements MascotaRemoteDataSource {
  final http.Client client;
  MascotaRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MascotaModel>> obtenerMascotas({String? estado}) async {
    final uri = Uri.parse(ApiConstants.mascotas).replace(
      queryParameters: estado != null ? {'estado': estado} : null,
    );
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MascotaModel.fromJson(json)).toList();
    }
    throw Exception('Error al obtener mascotas: ${response.statusCode}');
  }

  @override
  Future<MascotaModel> obtenerMascotaPorId(int id) async {
    final response = await client.get(Uri.parse(ApiConstants.mascotaDetalle(id)));
    if (response.statusCode == 200) {
      return MascotaModel.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 404) throw Exception('Mascota no encontrada');
    throw Exception('Error al obtener mascota: ${response.statusCode}');
  }
}