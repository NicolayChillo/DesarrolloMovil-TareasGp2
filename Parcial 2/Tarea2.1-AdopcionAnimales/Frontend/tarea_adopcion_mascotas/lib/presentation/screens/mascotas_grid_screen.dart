// presentation/screens/mascotas_grid_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../providers/mascotas_provider.dart';
import '../widgets/mascota_card.dart';

class MascotasGridScreen extends StatefulWidget {
  const MascotasGridScreen({super.key});
  @override
  State<MascotasGridScreen> createState() => _MascotasGridScreenState();
}

class _MascotasGridScreenState extends State<MascotasGridScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MascotasProvider>().cargarMascotasDisponibles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.adminGate),
          ),
        ],
      ),
      body: Consumer<MascotasProvider>(
        builder: (context, provider, _) {
          if (provider.estadoCarga == EstadoCarga.cargando ||
              provider.estadoCarga == EstadoCarga.inicial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.estadoCarga == EstadoCarga.error) {
            return Center(child: Text(provider.errorMessage ?? 'Error'));
          }
          if (provider.mascotas.isEmpty) {
            return const Center(child: Text('No hay mascotas disponibles por ahora.'));
          }
          return RefreshIndicator(
            onRefresh: provider.cargarMascotasDisponibles,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: provider.mascotas.length,
              itemBuilder: (context, index) {
                final mascota = provider.mascotas[index];
                return MascotaCard(
                  mascota: mascota,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.detalle,
                    arguments: mascota,
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