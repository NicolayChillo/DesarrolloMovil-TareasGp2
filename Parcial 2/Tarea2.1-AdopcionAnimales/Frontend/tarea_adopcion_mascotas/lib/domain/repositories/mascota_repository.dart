
import '../entities/mascota.dart';

abstract class MascotaRepository {
  Future<List<Mascota>> obtenerMascotas({String? estado});
  Future<Mascota> obtenerMascotaPorId(int id);
}