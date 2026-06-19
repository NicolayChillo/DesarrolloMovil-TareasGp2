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
    // ✅ NO USAR SCAFFOLD AQUÍ - ya está en MainScreen
    return Consumer<MascotasProvider>(
      builder: (context, provider, _) {
        if (provider.estadoCarga == EstadoCarga.cargando ||
            provider.estadoCarga == EstadoCarga.inicial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.estadoCarga == EstadoCarga.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(provider.errorMessage ?? 'Error al cargar'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<MascotasProvider>().cargarMascotasDisponibles();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (provider.mascotas.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No hay mascotas disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text('Vuelve más tarde', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<MascotasProvider>().cargarMascotasDisponibles(),
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
    );
  }
}