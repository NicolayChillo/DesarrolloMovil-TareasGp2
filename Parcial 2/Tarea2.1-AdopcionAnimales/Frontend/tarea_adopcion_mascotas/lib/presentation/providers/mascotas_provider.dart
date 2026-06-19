// presentation/providers/mascotas_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/mascota.dart';
import '../../domain/usecases/obtener_mascotas_usecase.dart';

enum EstadoCarga { inicial, cargando, listo, error }

class MascotasProvider extends ChangeNotifier {
  final ObtenerMascotasUseCase obtenerMascotasUseCase;
  MascotasProvider(this.obtenerMascotasUseCase);

  EstadoCarga _estadoCarga = EstadoCarga.inicial;
  List<Mascota> _mascotas = [];
  String? _errorMessage;

  EstadoCarga get estadoCarga => _estadoCarga;
  List<Mascota> get mascotas => _mascotas;
  String? get errorMessage => _errorMessage;

  Future<void> cargarMascotasDisponibles() async {
    _estadoCarga = EstadoCarga.cargando;
    notifyListeners();
    try {
      _mascotas = await obtenerMascotasUseCase(estado: 'Disponible');
      _estadoCarga = EstadoCarga.listo;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las mascotas. Verifica tu conexión.';
      _estadoCarga = EstadoCarga.error;
    }
    notifyListeners();
  }
}