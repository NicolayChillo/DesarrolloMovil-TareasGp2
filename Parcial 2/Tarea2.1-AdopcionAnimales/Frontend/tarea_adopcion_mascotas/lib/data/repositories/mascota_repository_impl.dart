import '../../domain/entities/mascota.dart';
import '../../domain/repositories/mascota_repository.dart';
import '../datasources/mascota_remote_datasource.dart';

class MascotaRepositoryImpl implements MascotaRepository {
  final MascotaRemoteDataSource remoteDataSource;

  MascotaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Mascota>> obtenerMascotas({String? estado}) {
    return remoteDataSource.obtenerMascotas(estado: estado);
  }

  @override
  Future<Mascota> obtenerMascotaPorId(int id) {
    return remoteDataSource.obtenerMascotaPorId(id);
  }
}
