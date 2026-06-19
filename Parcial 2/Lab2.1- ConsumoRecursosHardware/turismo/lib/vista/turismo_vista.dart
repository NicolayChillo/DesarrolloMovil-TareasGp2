import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controlador/turismo_controlador.dart';
import '../modelo/lugar_modelo.dart';
import '../tema/colores_app.dart';

class TurismoVista extends StatefulWidget {
  const TurismoVista({super.key});

  @override
  State<TurismoVista> createState() => _TurismoVistaState();
}

class _TurismoVistaState extends State<TurismoVista> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TurismoControlador>().iniciar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TurismoControlador>(
      builder: (context, ctrl, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Turismo Ecuador')),
          body: ctrl.cargando
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Obteniendo ubicación...',
                          style:
                              TextStyle(color: ColoresApp.textoGrisClaro)),
                    ],
                  ),
                )
              : ctrl.error != null
                  ? _errorWidget(ctrl)
                  : _contenidoPorPagina(ctrl),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ctrl.paginaActual,
            onTap: ctrl.cambiarPagina,
            backgroundColor: ColoresApp.superficieOscura,
            selectedItemColor: ColoresApp.acento,
            unselectedItemColor: ColoresApp.textoGrisClaro,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Lugares'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: 'Brújula'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.my_location), label: 'Mi Ubicación'),
            ],
          ),
        );
      },
    );
  }

  Widget _errorWidget(TurismoControlador ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: ColoresApp.error),
            const SizedBox(height: 16),
            Text(ctrl.error!,
                style: const TextStyle(color: ColoresApp.textoBlanco),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: ctrl.iniciar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contenidoPorPagina(TurismoControlador ctrl) {
    switch (ctrl.paginaActual) {
      case 0:
        return _listaLugares(ctrl);
      case 1:
        return _brujula(ctrl);
      case 2:
        return _miUbicacion(ctrl);
      default:
        return _listaLugares(ctrl);
    }
  }

  Widget _listaLugares(TurismoControlador ctrl) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ctrl.lugares.length,
      itemBuilder: (_, i) => _lugarCard(ctrl.lugares[i]),
    );
  }

  Widget _lugarCard(LugarModelo lugar) {
    return Card(
      child: ListTile(
        onTap: () => _abrirMaps(lugar.urlMaps),
        leading: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColoresApp.primario,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(lugar.emoji, style: const TextStyle(fontSize: 28)),
        ),
        title: Text(lugar.nombre,
            style: const TextStyle(
                color: ColoresApp.textoBlanco, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lugar.descripcion,
                style: const TextStyle(
                    color: ColoresApp.textoGrisClaro, fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.category,
                    size: 12, color: ColoresApp.acento),
                const SizedBox(width: 4),
                Text(lugar.categoria,
                    style: const TextStyle(
                        color: ColoresApp.acento, fontSize: 11)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.near_me, color: ColoresApp.secundario, size: 18),
            Text(lugar.distanciaTexto,
                style: const TextStyle(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _brujula(TurismoControlador ctrl) {
    final grados = ctrl.brujula ?? 0.0;
    final gradosNorm = grados < 0 ? grados + 360 : grados;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: -gradosNorm * pi / 180,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColoresApp.superficie,
                border: Border.all(color: ColoresApp.primario, width: 3),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned(
                      top: 16,
                      child: Text('N',
                          style: TextStyle(
                              color: ColoresApp.error,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))),
                  const Positioned(
                      bottom: 16,
                      child: Text('S',
                          style: TextStyle(
                              color: ColoresApp.textoBlanco, fontSize: 20))),
                  const Positioned(
                      right: 16,
                      child: Text('E',
                          style: TextStyle(
                              color: ColoresApp.textoBlanco, fontSize: 20))),
                  const Positioned(
                      left: 16,
                      child: Text('O',
                          style: TextStyle(
                              color: ColoresApp.textoBlanco, fontSize: 20))),
                  Container(
                    width: 4,
                    height: 80,
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: 40,
                        width: 4,
                        color: ColoresApp.error),
                  ),
                  Container(
                    width: 4,
                    height: 80,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 40,
                        width: 4,
                        color: ColoresApp.textoBlanco),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: ColoresApp.acento,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            ctrl.brujula != null
                ? '${gradosNorm.toStringAsFixed(0)}°  ${ctrl.direccionBrujula}'
                : 'Calibrando brújula...',
            style: const TextStyle(
                color: ColoresApp.textoBlanco,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _miUbicacion(TurismoControlador ctrl) {
    final pos = ctrl.ubicacionActual;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mi Ubicación Actual',
              style: TextStyle(
                  color: ColoresApp.textoBlanco,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: pos == null
                  ? const Text('Sin ubicación',
                      style: TextStyle(color: ColoresApp.textoGrisClaro))
                  : Column(
                      children: [
                        _coordRow(
                            'Latitud', pos.latitude.toStringAsFixed(6)),
                        const Divider(color: ColoresApp.borde),
                        _coordRow(
                            'Longitud', pos.longitude.toStringAsFixed(6)),
                        const Divider(color: ColoresApp.borde),
                        _coordRow('Precisión',
                            '±${pos.accuracy.toStringAsFixed(0)} m'),
                      ],
                    ),
            ),
          ),
          if (pos != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _abrirMaps(
                    'https://maps.google.com/?q=${pos.latitude},${pos.longitude}'),
                icon: const Icon(Icons.map),
                label: const Text('Ver en Google Maps'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _coordRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: ColoresApp.textoGrisClaro)),
          Text(valor,
              style: const TextStyle(
                  color: ColoresApp.textoBlanco,
                  fontWeight: FontWeight.bold)),
        ],
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
