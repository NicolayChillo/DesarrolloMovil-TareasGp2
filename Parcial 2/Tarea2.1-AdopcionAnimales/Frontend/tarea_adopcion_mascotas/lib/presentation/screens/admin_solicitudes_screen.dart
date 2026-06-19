
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

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
      context.read<AdminProvider>().cargarPendientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes pendientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AdminProvider>().cerrarSesion();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, _) {
          if (provider.cargando) return const Center(child: CircularProgressIndicator());
          if (provider.error != null) return Center(child: Text(provider.error!));
          if (provider.solicitudes.isEmpty) {
            return const Center(child: Text('No hay solicitudes pendientes.'));
          }
          return RefreshIndicator(
            onRefresh: provider.cargarPendientes,
            child: ListView.builder(
              itemCount: provider.solicitudes.length,
              itemBuilder: (context, index) {
                final s = provider.solicitudes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(s.nombreSolicitante),
                    subtitle: Text(
                      'Mascota: ${s.mascotaNombre ?? "#${s.mascotaId}"}\nTel: ${s.telefono}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => context.read<AdminProvider>().aprobar(s.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => context.read<AdminProvider>().rechazar(s.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}