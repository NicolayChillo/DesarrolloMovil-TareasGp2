// domain/usecases/obtener_mascota_por_id_usecase.dart
import '../../entities/mascota.dart';
import '../../repositories/mascota_repository.dart';

class ObtenerMascotaPorIdUseCase {
  final MascotaRepository repository;
  
  ObtenerMascotaPorIdUseCase(this.repository);
  
  Future<Mascota> call(int id) {
    return repository.obtenerMascotaPorId(id);
  }
}