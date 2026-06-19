
import '../entities/mascota.dart';
import '../repositories/mascota_repository.dart';

class ObtenerMascotasUseCase {
  final MascotaRepository repository;
  ObtenerMascotasUseCase(this.repository);

  Future<List<Mascota>> call({String? estado}) =>
      repository.obtenerMascotas(estado: estado);
}