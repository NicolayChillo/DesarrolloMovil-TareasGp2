// presentation/screens/solicitudes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/solicitud_adopcion.dart';
import '../providers/solicitudes_provider.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarSolicitudes();
    });
  }

  Future<void> _cargarSolicitudes() async {
    final provider = context.read<SolicitudesProvider>();
    print('📤 Cargando solicitudes...');
    await provider.cargarTodasLasSolicitudes();
    print('📥 Solicitudes cargadas: ${provider.solicitudes.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SolicitudesProvider>(
        builder: (context, provider, _) {
          print('🔍 Estado: ${provider.estado}, Solicitudes: ${provider.solicitudes.length}');

          // ✅ Estado de carga
          if (provider.estado == EstadoSolicitudes.cargando) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando solicitudes...'),
                ],
              ),
            );
          }

          // ✅ Estado de error
          if (provider.estado == EstadoSolicitudes.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? 'Error al cargar solicitudes',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cargarSolicitudes,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // ✅ Sin solicitudes
          if (provider.solicitudes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay solicitudes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aún no se han realizado solicitudes de adopción',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // ✅ Lista de solicitudes
          return RefreshIndicator(
            onRefresh: _cargarSolicitudes,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = provider.solicitudes[index];
                return _buildSolicitudCard(context, solicitud);
              },
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // MÉTODOS DE CONSTRUCCIÓN DE UI
  // ============================================================

  Widget _buildSolicitudCard(BuildContext context, SolicitudAdopcion solicitud) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getEstadoColor(solicitud.estado),
          child: Icon(
            _getEstadoIcon(solicitud.estado),
            color: Colors.white,
          ),
        ),
        title: Text(
          solicitud.mascotaNombre ?? 'Mascota #${solicitud.mascotaId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solicitante: ${solicitud.nombreSolicitante}'),
            const SizedBox(height: 2),
            Text(
              'Fecha: ${_formatearFecha(solicitud.fechaSolicitud)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (solicitud.comentario != null) ...[
              const SizedBox(height: 2),
              Text(
                'Comentario: ${solicitud.comentario}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getEstadoColor(solicitud.estado).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            solicitud.estado,
            style: TextStyle(
              color: _getEstadoColor(solicitud.estado),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        isThreeLine: true,
        onTap: () => _mostrarDetalleSolicitud(context, solicitud),
      ),
    );
  }

  // ============================================================
  // MÉTODOS DE UTILIDAD
  // ============================================================

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Pendiente':
        return Colors.orange;
      case 'Aprobada':
        return Colors.green;
      case 'Rechazada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'Pendiente':
        return Icons.pending;
      case 'Aprobada':
        return Icons.check_circle;
      case 'Rechazada':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  // ============================================================
  // MÉTODO PARA MOSTRAR DETALLE
  // ============================================================

  void _mostrarDetalleSolicitud(BuildContext context, SolicitudAdopcion solicitud) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Detalle de solicitud',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Mascota', solicitud.mascotaNombre ?? '#${solicitud.mascotaId}'),
            _buildDetailRow('Solicitante', solicitud.nombreSolicitante),
            _buildDetailRow('Teléfono', solicitud.telefono),
            _buildDetailRow('Estado', solicitud.estado),
            _buildDetailRow('Fecha', _formatearFecha(solicitud.fechaSolicitud)),
            if (solicitud.comentario != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Comentario', solicitud.comentario!),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}