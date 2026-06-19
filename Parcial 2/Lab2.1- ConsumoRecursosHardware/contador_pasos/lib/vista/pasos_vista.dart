import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controlador/pasos_controlador.dart';
import '../modelo/paso_modelo.dart';
import '../tema/colores_app.dart';

class PasosVista extends StatelessWidget {
  const PasosVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PasosControlador>(
      builder: (context, ctrl, _) {
        final m = ctrl.modelo;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Contador de Pasos'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Reiniciar y guardar',
                onPressed: ctrl.reiniciar,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Anillo de progreso principal
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: CircularProgressIndicator(
                          value: ctrl.progresoMetaDiaria,
                          strokeWidth: 16,
                          backgroundColor: ColoresApp.borde,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ctrl.progresoMetaDiaria >= 1.0
                                ? ColoresApp.secundario
                                : ColoresApp.acento,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${m.pasos}',
                            style: const TextStyle(
                              color: ColoresApp.textoBlanco,
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('pasos',
                              style: TextStyle(
                                  color: ColoresApp.textoGrisClaro,
                                  fontSize: 16)),
                          Text(
                            '${(ctrl.progresoMetaDiaria * 100).toStringAsFixed(0)}% meta',
                            style: TextStyle(
                              color: ctrl.progresoMetaDiaria >= 1.0
                                  ? ColoresApp.secundario
                                  : ColoresApp.acento,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Tarjetas de stats
                Row(
                  children: [
                    Expanded(
                        child: _statCard(
                            Icons.local_fire_department,
                            '${m.calorias.toStringAsFixed(1)} cal',
                            'Calorías',
                            ColoresApp.error)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _statCard(Icons.straighten, m.distanciaTexto,
                            'Distancia', ColoresApp.secundario)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _statCard(Icons.flag, '10,000', 'Meta diaria',
                            ColoresApp.acento)),
                  ],
                ),
                const SizedBox(height: 24),
                // Botón iniciar/pausar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        ctrl.activo ? ctrl.pausar : ctrl.iniciar,
                    icon: Icon(ctrl.activo ? Icons.pause : Icons.play_arrow),
                    label: Text(ctrl.activo ? 'Pausar' : 'Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ctrl.activo
                          ? ColoresApp.error
                          : ColoresApp.secundario,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Historial
                if (m.historial.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Historial Diario',
                        style: TextStyle(
                            color: ColoresApp.textoBlanco,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: m.historial.length,
                    itemBuilder: (_, i) => _historialCard(m.historial[i]),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(
      IconData icon, String valor, String label, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(valor,
                style: const TextStyle(
                    color: ColoresApp.textoBlanco,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text(label,
                style: const TextStyle(
                    color: ColoresApp.textoGrisClaro, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _historialCard(RegistroDiario r) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: ColoresApp.acento),
        title: Text(r.fecha,
            style: const TextStyle(color: ColoresApp.textoBlanco)),
        subtitle: Text('${r.pasos} pasos · ${r.calorias.toStringAsFixed(1)} cal',
            style: const TextStyle(color: ColoresApp.textoGrisClaro)),
        trailing: Text(
          r.distanciaKm < 1
              ? '${(r.distanciaKm * 1000).toStringAsFixed(0)} m'
              : '${r.distanciaKm.toStringAsFixed(2)} km',
          style: const TextStyle(color: ColoresApp.secundario),
        ),
      ),
    );
  }
}
