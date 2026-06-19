
import '../../core/errors/exceptions.dart';
import '../../core/utils/validators.dart';
import '../entities/mascota.dart';
import '../entities/solicitud_adopcion.dart';
import '../repositories/solicitud_repository.dart';

class CrearSolicitudUseCase {
  final SolicitudRepository repository;
  CrearSolicitudUseCase(this.repository);

  Future<SolicitudAdopcion> call({
    required Mascota mascota,
    required String nombreSolicitante,
    required String telefono,
    String? comentario,
  }) {
    if (!mascota.estaDisponible) {
      throw const SolicitudInvalidaException(
        'Esta mascota ya no está disponible para adopción.',
      );
    }
    if (Validators.validarNombre(nombreSolicitante) != null) {
      throw const SolicitudInvalidaException('El nombre es obligatorio.');
    }
    if (!Validators.esTelefonoValido(telefono)) {
      throw const SolicitudInvalidaException('El teléfono no es válido.');
    }

    return repository.crearSolicitud(SolicitudAdopcion(
      id: 0,
      mascotaId: mascota.id,
      nombreSolicitante: nombreSolicitante.trim(),
      telefono: telefono.trim(),
      fechaSolicitud: DateTime.now(),
      estado: 'Pendiente',
      comentario: comentario?.trim(),
    ));
  }
}