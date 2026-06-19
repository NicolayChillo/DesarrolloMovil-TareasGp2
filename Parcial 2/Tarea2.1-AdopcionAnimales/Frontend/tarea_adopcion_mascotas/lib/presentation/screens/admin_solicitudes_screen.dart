// presentation/screens/admin_solicitudes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/solicitud_adopcion.dart';
import '../providers/admin_provider.dart';
import 'admin_mascota_screen.dart';

class AdminSolicitudesScreen extends StatefulWidget {
  const AdminSolicitudesScreen({super.key});

  @override
  State<AdminSolicitudesScreen> createState() => _AdminSolicitudesScreenState();
}

class _AdminSolicitudesScreenState extends State<AdminSolicitudesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarSolicitudes();
    });
  }

  Future<void> _cargarSolicitudes() async {
    final provider = context.read<AdminProvider>();
    if (provider.isAuthenticated) {
      await provider.cargarTodasLasSolicitudes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Solicitudes'),
              Tab(text: 'Mascotas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Solicitudes
                Consumer<AdminProvider>(
                  builder: (context, provider, _) {
                    if (provider.estado == EstadoAdmin.cargando) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.estado == EstadoAdmin.error) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(provider.error ?? 'Error'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _cargarSolicitudes,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (provider.solicitudes.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No hay solicitudes'),
                          ],
                        ),
                      );
                    }
                    return _buildSolicitudList(provider.solicitudes);
                  },
                ),
                // Mascotas
                const AdminMascotasScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudList(List<SolicitudAdopcion> solicitudes) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: solicitudes.length,
      itemBuilder: (context, index) {
        final s = solicitudes[index];
        final isPendiente = s.estado == 'Pendiente';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getEstadoColor(s.estado),
              child: Icon(
                _getEstadoIcon(s.estado),
                color: Colors.white,
              ),
            ),
            title: Text(
              s.nombreSolicitante,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mascota: ${s.mascotaNombre ?? "#${s.mascotaId}"}'),
                Text('Teléfono: ${s.telefono}'),
                if (s.comentario != null)
                  Text(
                    'Comentario: ${s.comentario}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
            isThreeLine: true,
            trailing: isPendiente
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _aprobarSolicitud(s.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _rechazarSolicitud(s.id),
                      ),
                    ],
                  )
                : null,
            onTap: () => _mostrarDetalleSolicitud(context, s),
          ),
        );
      },
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Pendiente': return Colors.orange;
      case 'Aprobada': return Colors.green;
      case 'Rechazada': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'Pendiente': return Icons.pending;
      case 'Aprobada': return Icons.check_circle;
      case 'Rechazada': return Icons.cancel;
      default: return Icons.info;
    }
  }

  Future<void> _aprobarSolicitud(int id) async {
    final confirm = await _mostrarConfirmacion('Aprobar solicitud');
    if (confirm) {
      await context.read<AdminProvider>().aprobar(id);
      _cargarSolicitudes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Solicitud aprobada'), backgroundColor: Colors.green),
        );
      }
    }
  }

  Future<void> _rechazarSolicitud(int id) async {
    final confirm = await _mostrarConfirmacion('Rechazar solicitud');
    if (confirm) {
      await context.read<AdminProvider>().rechazar(id);
      _cargarSolicitudes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Solicitud rechazada'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<bool> _mostrarConfirmacion(String titulo) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text('¿Estás seguro de ${titulo.toLowerCase()} esta solicitud?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(titulo.contains('Aprobar') ? 'Aprobar' : 'Rechazar'),
            style: TextButton.styleFrom(
              foregroundColor: titulo.contains('Aprobar') ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _mostrarDetalleSolicitud(BuildContext context, SolicitudAdopcion s) {
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
            Text('Detalle de solicitud', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildDetailRow('Solicitante', s.nombreSolicitante),
            _buildDetailRow('Teléfono', s.telefono),
            _buildDetailRow('Mascota', s.mascotaNombre ?? '#${s.mascotaId}'),
            _buildDetailRow('Estado', s.estado),
            _buildDetailRow('Fecha', s.fechaSolicitud.toString().substring(0, 10)),
            if (s.comentario != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Comentario', s.comentario!),
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
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}