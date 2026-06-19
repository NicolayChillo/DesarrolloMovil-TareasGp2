import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controlador/camara_controlador.dart';
import '../modelo/foto_modelo.dart';
import '../tema/colores_app.dart';

class CamaraVista extends StatelessWidget {
  const CamaraVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CamaraControlador>(
      builder: (context, ctrl, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Cámara Turística')),
          body: ctrl.cargando
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (ctrl.error != null)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColoresApp.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColoresApp.error),
                        ),
                        child: Text(ctrl.error!,
                            style:
                                const TextStyle(color: ColoresApp.textoBlanco)),
                      ),
                    if (ctrl.fotoSeleccionada != null)
                      _detallesFoto(context, ctrl.fotoSeleccionada!, ctrl),
                    Expanded(
                      child: ctrl.fotos.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 64, color: ColoresApp.textoGrisClaro),
                                  SizedBox(height: 12),
                                  Text('Toma una foto para comenzar',
                                      style: TextStyle(
                                          color: ColoresApp.textoGrisClaro)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: ctrl.fotos.length,
                              itemBuilder: (_, i) =>
                                  _fotoCard(context, ctrl.fotos[i], ctrl, i),
                            ),
                    ),
                  ],
                ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'galeria',
                onPressed: ctrl.seleccionarDeGaleria,
                backgroundColor: ColoresApp.superficie,
                child: const Icon(Icons.photo_library),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.extended(
                heroTag: 'camara',
                onPressed: ctrl.tomarFoto,
                backgroundColor: ColoresApp.acento,
                foregroundColor: Colors.black87,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar Foto'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detallesFoto(
      BuildContext context, FotoModelo foto, CamaraControlador ctrl) {
    return Container(
      width: double.infinity,
      color: ColoresApp.superficieOscura,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(foto.imagenPath),
                width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(foto.fechaTexto,
                    style: const TextStyle(
                        color: ColoresApp.textoGrisClaro, fontSize: 12)),
                const SizedBox(height: 4),
                Text('Lat: ${foto.latitud.toStringAsFixed(6)}',
                    style: const TextStyle(
                        color: ColoresApp.textoBlanco, fontSize: 13)),
                Text('Lng: ${foto.longitud.toStringAsFixed(6)}',
                    style: const TextStyle(
                        color: ColoresApp.textoBlanco, fontSize: 13)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _abrirMaps(foto.urlMaps),
                  child: const Text('Ver en Google Maps →',
                      style: TextStyle(
                          color: ColoresApp.secundario,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: ColoresApp.secundario)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: ColoresApp.textoGrisClaro),
            onPressed: ctrl.cerrarDetalle,
          ),
        ],
      ),
    );
  }

  Widget _fotoCard(BuildContext context, FotoModelo foto,
      CamaraControlador ctrl, int index) {
    return Card(
      child: ListTile(
        onTap: () => ctrl.seleccionarFoto(foto),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(foto.imagenPath),
              width: 56, height: 56, fit: BoxFit.cover),
        ),
        title: Text(foto.coordenadasTexto,
            style: const TextStyle(color: ColoresApp.textoBlanco, fontSize: 13)),
        subtitle: Text(foto.fechaTexto,
            style: const TextStyle(
                color: ColoresApp.textoGrisClaro, fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon:
                  const Icon(Icons.map_outlined, color: ColoresApp.secundario),
              onPressed: () => _abrirMaps(foto.urlMaps),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: ColoresApp.error),
              onPressed: () => ctrl.eliminarFoto(index),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _abrirMaps(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
