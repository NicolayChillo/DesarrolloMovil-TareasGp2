// presentation/providers/mascotas_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../domain/entities/mascota.dart';
import '../../domain/usecases/mascotas_usescases/obtener_mascotas_usecase.dart';
import '../../domain/usecases/mascotas_usescases/obtener_mascota_por_id_usecase.dart';
import '../../domain/usecases/mascotas_usescases/crear_mascota_usecase.dart';
import '../../domain/usecases/mascotas_usescases/actualizar_mascota_usecase.dart';
import '../../domain/usecases/mascotas_usescases/eliminar_mascota_usecase.dart';

enum EstadoCarga { inicial, cargando, listo, error }

class MascotasProvider extends ChangeNotifier {
  final ObtenerMascotasUseCase obtenerMascotasUseCase;
  final ObtenerMascotaPorIdUseCase obtenerMascotaPorIdUseCase;
  final CrearMascotaUseCase crearMascotaUseCase;
  final ActualizarMascotaUseCase actualizarMascotaUseCase;
  final EliminarMascotaUseCase eliminarMascotaUseCase;

  MascotasProvider({
    required this.obtenerMascotasUseCase,
    required this.obtenerMascotaPorIdUseCase,
    required this.crearMascotaUseCase,
    required this.actualizarMascotaUseCase,
    required this.eliminarMascotaUseCase,
  });

  // ============================================================
  // ESTADO
  // ============================================================
  
  EstadoCarga _estadoCarga = EstadoCarga.inicial;
  List<Mascota> _mascotas = [];
  Mascota? _mascotaSeleccionada;
  String? _errorMessage;

  EstadoCarga get estadoCarga => _estadoCarga;
  List<Mascota> get mascotas => _mascotas;
  Mascota? get mascotaSeleccionada => _mascotaSeleccionada;
  String? get errorMessage => _errorMessage;

  // ============================================================
  // 📋 READ - Obtener todas las mascotas
  // ============================================================
  
  Future<void> cargarMascotasDisponibles() async {
    _setLoading();
    try {
      _mascotas = await obtenerMascotasUseCase(estado: 'Disponible');
      _setReady();
      print('✅ Mascotas disponibles cargadas: ${_mascotas.length}');
    } catch (e) {
      print('❌ Error al cargar mascotas disponibles: $e');
      _setError('No se pudieron cargar las mascotas disponibles');
    }
  }

  Future<void> cargarTodasLasMascotas() async {
    _setLoading();
    try {
      _mascotas = await obtenerMascotasUseCase();
      _setReady();
      print('✅ Todas las mascotas cargadas: ${_mascotas.length}');
    } catch (e) {
      print('❌ Error al cargar todas las mascotas: $e');
      _setError('No se pudieron cargar las mascotas');
    }
  }

  // ============================================================
  // 🔍 READ - Obtener mascota por ID
  // ============================================================
  
  Future<void> cargarMascotaPorId(int id) async {
    _setLoading();
    try {
      _mascotaSeleccionada = await obtenerMascotaPorIdUseCase(id);
      _setReady();
    } catch (e) {
      _setError('No se pudo cargar la mascota');
    }
  }

  // ============================================================
  // ➕ CREATE - Crear nueva mascota
  // ============================================================
  
  Future<bool> crearMascota({
    required String nombre,
    required String especie,
    required int edad,
    required String descripcion,
    String? raza,
    String? sexo,
    File? imagen,
  }) async {
    _setLoading();
    try {
      print('📤 Creando mascota...');
      print('📝 nombre: $nombre');
      print('📝 especie: $especie');
      print('📝 edad: $edad');
      print('📁 imagen: ${imagen?.path}');
      
      final nuevaMascota = await crearMascotaUseCase(
        nombre: nombre,
        especie: especie,
        edad: edad,
        descripcion: descripcion,
        raza: raza,
        sexo: sexo,
        imagen: imagen,
      );
      
      _mascotas.insert(0, nuevaMascota);
      _setReady();
      print('✅ Mascota creada: ${nuevaMascota.id} - ${nuevaMascota.nombre}');
      return true;
    } catch (e) {
      print('❌ Error al crear mascota: $e');
      _setError('No se pudo crear la mascota: ${e.toString()}');
      return false;
    }
  }

  // ============================================================
  // ✏️ UPDATE - Actualizar mascota
  // ============================================================
  
  // presentation/providers/mascotas_provider.dart
  Future<bool> actualizarMascota({
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
    _setLoading();
    try {
      print('📤 Actualizando mascota en Provider...');
      
      final mascotaActualizada = await actualizarMascotaUseCase(
        id: id,
        nombre: nombre,
        especie: especie,
        raza: raza,
        sexo: sexo,
        edad: edad,
        descripcion: descripcion,
        estado: estado,
        imagen: imagen,
      );
      
      print('✅ Mascota actualizada: ${mascotaActualizada.id} - ${mascotaActualizada.nombre}');
      
      // ✅ Actualizar en la lista local
      final index = _mascotas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _mascotas[index] = mascotaActualizada;
      } else {
        // Si no está en la lista, recargar todo
        await cargarTodasLasMascotas();
      }
      
      _setReady();
      return true;
    } catch (e) {
      print('❌ Error al actualizar: $e');
      _setError('No se pudo actualizar la mascota: ${e.toString()}');
      return false;
    }
  }
  // ============================================================
  // 🗑️ DELETE - Eliminar mascota
  // ============================================================
  
  Future<bool> eliminarMascota(int id) async {
    _setLoading();
    try {
      print('📤 Eliminando mascota ID: $id');
      await eliminarMascotaUseCase(id);
      _mascotas.removeWhere((m) => m.id == id);
      _setReady();
      print('✅ Mascota eliminada: $id');
      return true;
    } catch (e) {
      print('❌ Error al eliminar mascota: $e');
      _setError('No se pudo eliminar la mascota: ${e.toString()}');
      return false;
    }
  }

  // ============================================================
  // MÉTODOS PRIVADOS
  // ============================================================
  
  void _setLoading() {
    _estadoCarga = EstadoCarga.cargando;
    _errorMessage = null;
    notifyListeners();
  }

  void _setReady() {
    _estadoCarga = EstadoCarga.listo;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _estadoCarga = EstadoCarga.error;
    _errorMessage = message;
    notifyListeners();
  }

  // ============================================================
  // MÉTODOS DE UTILIDAD
  // ============================================================
  
  void limpiarMascotaSeleccionada() {
    _mascotaSeleccionada = null;
    notifyListeners();
  }

  void actualizarMascotaLocal(Mascota mascota) {
    final index = _mascotas.indexWhere((m) => m.id == mascota.id);
    if (index != -1) {
      _mascotas[index] = mascota;
      notifyListeners();
    }
  }
}