// data/datasources/mascota_remote_datasource.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../core/constants/api_constants.dart';
import '../models/mascota_model.dart';

abstract class MascotaRemoteDataSource {
  // 📋 READ - Obtener todas
  Future<List<MascotaModel>> obtenerMascotas({String? estado});
  
  // 🔍 READ - Obtener por ID
  Future<MascotaModel> obtenerMascotaPorId(int id);
  
  // ➕ CREATE - Crear nueva
  Future<MascotaModel> crearMascota({
    required String nombre,
    required String especie,
    required int edad,
    required String descripcion,
    String? raza,
    String? sexo,
    File? imagen,
  });
  
  // ✏️ UPDATE - Actualizar
  Future<MascotaModel> actualizarMascota({
    required int id,
    String? nombre,
    String? especie,
    String? raza,
    String? sexo,
    int? edad,
    String? descripcion,
    String? estado,
    File? imagen,
  });
  
  // 🗑️ DELETE - Eliminar
  Future<void> eliminarMascota(int id);
}

class MascotaRemoteDataSourceImpl implements MascotaRemoteDataSource {
  final http.Client client;
  MascotaRemoteDataSourceImpl({required this.client});

  // ============================================================
  // 📋 READ - Obtener todas las mascotas
  // ============================================================
  @override
  Future<List<MascotaModel>> obtenerMascotas({String? estado}) async {
    try {
      final uri = Uri.parse(ApiConstants.getMascotas()).replace(
        queryParameters: estado != null ? {'estado': estado} : null,
      );
      
      print('📤 GET: $uri');
      final response = await client.get(uri);
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MascotaModel.fromJson(json)).toList();
      }
      throw Exception('Error al obtener mascotas: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // 🔍 READ - Obtener mascota por ID
  // ============================================================
  @override
  Future<MascotaModel> obtenerMascotaPorId(int id) async {
    try {
      final url = ApiConstants.mascotaDetalle(id);
      print('📤 GET: $url');
      
      final response = await client.get(Uri.parse(url));
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return MascotaModel.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 404) {
        throw Exception('Mascota no encontrada');
      }
      throw Exception('Error al obtener mascota: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // ➕ CREATE - Crear nueva mascota
  // ============================================================
  @override
  Future<MascotaModel> crearMascota({
    required String nombre,
    required String especie,
    required int edad,
    required String descripcion,
    String? raza,
    String? sexo,
    File? imagen,
  }) async {
    try {
      final url = ApiConstants.crearMascota();
      print('📤 POST: $url');
      print('📝 nombre: $nombre');
      print('📝 especie: $especie');
      print('📝 edad: $edad');
      print('📁 imagen: ${imagen?.path}');

      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Añadir campos de texto
      request.fields['nombre'] = nombre;
      request.fields['especie'] = especie;
      request.fields['edad'] = edad.toString();
      request.fields['descripcion'] = descripcion;
      if (raza != null && raza.isNotEmpty) request.fields['raza'] = raza;
      if (sexo != null && sexo.isNotEmpty) request.fields['sexo'] = sexo;
      
      // Añadir imagen si existe
      if (imagen != null) {
        print('📸 Añadiendo imagen...');
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imagen.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MascotaModel.fromJson(jsonDecode(responseBody));
      }
      throw Exception('Error al crear mascota: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // ✏️ UPDATE - Actualizar mascota
  // ============================================================
  @override
  Future<MascotaModel> actualizarMascota({
    required int id,
    String? nombre,
    String? especie,
    String? raza,
    String? sexo,
    int? edad,
    String? descripcion,
    String? estado,
    File? imagen,
  }) async {
    try {
      final url = ApiConstants.actualizarMascota(id);
      print('📤 PUT: $url');
      print('📝 Campos a enviar:');
      print('  nombre: $nombre');
      print('  especie: $especie');
      print('  raza: $raza');
      print('  sexo: $sexo');
      print('  edad: $edad');
      print('  descripcion: $descripcion');
      print('  estado: $estado');
      print('  imagen: ${imagen?.path}');

      var request = http.MultipartRequest('PUT', Uri.parse(url));
      
      // Añadir campos que no sean nulos
      if (nombre != null) request.fields['nombre'] = nombre;
      if (especie != null) request.fields['especie'] = especie;
      if (raza != null) request.fields['raza'] = raza;
      if (sexo != null) request.fields['sexo'] = sexo;
      if (edad != null) request.fields['edad'] = edad.toString();
      if (descripcion != null) request.fields['descripcion'] = descripcion;
      if (estado != null) request.fields['estado'] = estado;
      
      // Añadir imagen si existe
      if (imagen != null) {
        print('📸 Actualizando imagen...');
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imagen.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return MascotaModel.fromJson(jsonDecode(responseBody));
      }
      throw Exception('Error al actualizar mascota: ${response.statusCode}');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // 🗑️ DELETE - Eliminar mascota
  // ============================================================
  @override
  Future<void> eliminarMascota(int id) async {
    try {
      final url = ApiConstants.eliminarMascota(id);
      print('📤 DELETE: $url');
      
      final response = await client.delete(Uri.parse(url));
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar mascota: ${response.statusCode}');
      }
      print('✅ Mascota eliminada');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}