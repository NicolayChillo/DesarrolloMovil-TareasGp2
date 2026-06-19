
import 'package:flutter/material.dart';
import '../../domain/entities/mascota.dart';

class MascotaCard extends StatelessWidget {
  final Mascota mascota;
  final VoidCallback onTap;
  const MascotaCard({super.key, required this.mascota, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: mascota.imagenUrl != null
                  ? Image.network(
                mascota.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              )
                  : Container(
                color: Colors.grey[300],
                child: const Icon(Icons.pets, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mascota.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(mascota.especie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}