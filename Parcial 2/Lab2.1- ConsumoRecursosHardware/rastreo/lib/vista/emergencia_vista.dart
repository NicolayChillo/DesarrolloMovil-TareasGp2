import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controlador/emergencia_controlador.dart';
import '../tema/colores_app.dart';

class EmergenciaVista extends StatelessWidget {
  const EmergenciaVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergenciaControlador>(
      builder: (context, ctrl, _) {
        final m = ctrl.modelo;
        return Scaffold(
          appBar: AppBar(title: const Text('Sistema de Emergencia')),
          body: ctrl.cargando
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Obteniendo datos...',
                          style: TextStyle(color: ColoresApp.textoGrisClaro)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Error
                      if (ctrl.error != null)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColoresApp.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ColoresApp.error),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber,
                                  color: ColoresApp.error, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(ctrl.error!,
                                    style: const TextStyle(
                                        color: ColoresApp.textoBlanco)),
                              ),
                            ],
                          ),
                        ),

                      // Boton SOS
                      GestureDetector(
                        onTap: ctrl.activarSOS,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 190,
                          height: 190,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ctrl.sosActivado
                                ? ColoresApp.error
                                : const Color(0xFF8B0000),
                            boxShadow: [
                              BoxShadow(
                                color: ColoresApp.error.withValues(
                                    alpha: ctrl.sosActivado ? 0.9 : 0.5),
                                blurRadius: ctrl.sosActivado ? 50 : 25,
                                spreadRadius: ctrl.sosActivado ? 12 : 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.sos,
                                  size: 70, color: Colors.white),
                              const SizedBox(height: 4),
                              Text(
                                ctrl.sosActivado ? 'ENVIANDO...' : 'SOS',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pulsa para enviar tu ubicacion',
                        style: TextStyle(
                            color: ColoresApp.textoGrisClaro, fontSize: 12),
                      ),

                      const SizedBox(height: 28),

                      // Coordenadas GPS
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: ColoresApp.acento, size: 20),
                                  SizedBox(width: 8),
                                  Text('Coordenadas GPS',
                                      style: TextStyle(
                                          color: ColoresApp.textoBlanco,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _filaCoord('Latitud', m.latitudTexto),
                              const SizedBox(height: 8),
                              _filaCoord('Longitud', m.longitudTexto),
                              if (m.tieneUbicacion) ...[
                                const SizedBox(height: 14),
                                const Divider(color: ColoresApp.borde),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: ctrl.abrirEnMaps,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: ColoresApp.primario,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.link,
                                            color: ColoresApp.secundario,
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            m.urlMaps,
                                            style: const TextStyle(
                                              color: ColoresApp.secundario,
                                              fontSize: 11,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ColoresApp.secundario,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Foto del entorno
                      if (m.tieneFoto)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.photo_camera,
                                        color: ColoresApp.acento, size: 20),
                                    SizedBox(width: 8),
                                    Text('Foto del Entorno',
                                        style: TextStyle(
                                            color: ColoresApp.textoBlanco,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(16)),
                                child: Image.file(
                                  File(m.imagenPath!),
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Botones de accion
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: ctrl.obtenerUbicacion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColoresApp.primario,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              icon: const Icon(Icons.gps_fixed,
                                  color: ColoresApp.secundario),
                              label: const Text('Obtener GPS',
                                  style:
                                      TextStyle(color: ColoresApp.secundario)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: ctrl.tomarFoto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColoresApp.primario,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              icon: const Icon(Icons.camera_alt,
                                  color: ColoresApp.acento),
                              label: const Text('Tomar Foto',
                                  style: TextStyle(color: ColoresApp.acento)),
                            ),
                          ),
                        ],
                      ),

                      if (m.tieneUbicacion) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: ctrl.abrirEnMaps,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.secundario,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.map),
                            label: const Text('Ver en Google Maps',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _filaCoord(String label, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: ColoresApp.textoGrisClaro, fontSize: 13)),
          Text(valor,
              style: const TextStyle(
                  color: ColoresApp.textoBlanco,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
