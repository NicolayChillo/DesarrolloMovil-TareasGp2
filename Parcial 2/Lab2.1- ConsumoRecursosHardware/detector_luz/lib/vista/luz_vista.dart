import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controlador/luz_controlador.dart';
import '../tema/colores_app.dart';

class LuzVista extends StatefulWidget {
  const LuzVista({super.key});

  @override
  State<LuzVista> createState() => _LuzVistaState();
}

class _LuzVistaState extends State<LuzVista> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LuzControlador>().iniciar();
    });
  }

  @override
  void dispose() {
    context.read<LuzControlador>().detener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LuzControlador>(
      builder: (context, ctrl, _) {
        final m = ctrl.modelo;
        final esOscuro = m.lux < 10;
        final esMuyIluminado = m.lux >= 200;

        final Color colorEstado = esMuyIluminado
            ? ColoresApp.advertencia
            : esOscuro
                ? ColoresApp.textoGrisClaro
                : ColoresApp.secundario;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detector de Luz'),
            actions: [
              // Indicador de estado del sensor
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ctrl.activo && ctrl.sensorDisponible
                              ? ColoresApp.secundario
                              : ColoresApp.error,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ctrl.activo ? 'Activo' : 'Inactivo',
                        style: const TextStyle(
                            color: ColoresApp.textoGrisClaro, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Error del sensor (si no está disponible)
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
                                  color: ColoresApp.textoBlanco, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),

                // Indicador visual principal
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorEstado.withValues(alpha: 0.15),
                    border: Border.all(color: colorEstado, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: colorEstado.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(m.icono, style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(
                        '${m.lux.toStringAsFixed(0)} lux',
                        style: TextStyle(
                          color: colorEstado,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sensor real',
                        style: TextStyle(
                          color: colorEstado.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Barra de progreso
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Nivel de iluminación',
                                style: TextStyle(
                                    color: ColoresApp.textoBlanco,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              m.clasificacion,
                              style: TextStyle(
                                  color: colorEstado,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: m.progreso,
                            minHeight: 16,
                            backgroundColor: ColoresApp.borde,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(colorEstado),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0 lux',
                                style: TextStyle(
                                    color: ColoresApp.textoGrisClaro,
                                    fontSize: 11)),
                            Text('500+ lux',
                                style: TextStyle(
                                    color: ColoresApp.textoGrisClaro,
                                    fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Recomendación
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: colorEstado),
                            const SizedBox(width: 8),
                            const Text('Recomendación',
                                style: TextStyle(
                                    color: ColoresApp.textoBlanco,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(m.recomendacion,
                            style: const TextStyle(
                                color: ColoresApp.textoGrisClaro,
                                height: 1.5)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Clasificaciones de referencia
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rangos de Referencia',
                            style: TextStyle(
                                color: ColoresApp.textoBlanco,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _clasificBadge('Oscuro', '< 10 lux', ColoresApp.textoGrisClaro),
                            _clasificBadge('Normal', '10–200', ColoresApp.secundario),
                            _clasificBadge('Brillante', '> 200', ColoresApp.advertencia),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón start/stop
                SizedBox(
                  width: double.infinity,
                  child: ctrl.activo
                      ? OutlinedButton.icon(
                          onPressed: ctrl.detener,
                          icon: const Icon(Icons.pause_circle),
                          label: const Text('Pausar sensor'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColoresApp.textoGrisClaro,
                            side: const BorderSide(color: ColoresApp.borde),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: ctrl.iniciar,
                          icon: const Icon(Icons.play_circle),
                          label: const Text('Iniciar sensor'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _clasificBadge(String label, String rango, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(height: 2),
        Text(rango,
            style: const TextStyle(
                color: ColoresApp.textoGrisClaro, fontSize: 10)),
      ],
    );
  }
}
