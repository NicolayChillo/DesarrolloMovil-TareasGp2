// presentation/screens/mascota_detalle_screen.dart
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/entities/mascota.dart';

class MascotaDetalleScreen extends StatelessWidget {
  final Mascota mascota;
  const MascotaDetalleScreen({super.key, required this.mascota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mascota.nombre),
        // ✅ Botón de retroceder
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mascota.imagenUrl != null
                ? Image.network(
                    mascota.imagenUrl!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 48),
                    ),
                  )
                : Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.pets, size: 64),
                  ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mascota.nombre, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('${mascota.especie}${mascota.raza != null ? " · ${mascota.raza}" : ""}'),
                  if (mascota.edad != null) Text('Edad: ${mascota.edad} años'),
                  if (mascota.sexo != null) Text('Sexo: ${mascota.sexo}'),
                  const SizedBox(height: 12),
                  if (mascota.descripcion != null) Text(mascota.descripcion!),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: mascota.estaDisponible
                          ? () => Navigator.pushNamed(
                                context,
                                AppRoutes.formulario,
                                arguments: mascota,
                              )
                          : null,
                      child: Text(
                        mascota.estaDisponible 
                            ? 'Solicitar adopción' 
                            : 'Ya no disponible'
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}