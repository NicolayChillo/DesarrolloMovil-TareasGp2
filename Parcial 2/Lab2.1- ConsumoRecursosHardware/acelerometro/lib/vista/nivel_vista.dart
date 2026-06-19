import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controlador/acelerometro_controlador.dart';
import '../tema/colores_app.dart';

class NivelVista extends StatefulWidget {
  const NivelVista({super.key});

  @override
  State<NivelVista> createState() => _NivelVistaState();
}

class _NivelVistaState extends State<NivelVista> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AcelerometroControlador>().iniciar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AcelerometroControlador>(
      builder: (context, ctrl, _) {
        final m = ctrl.modelo;
        final esHorizontal = m.esHorizontal;

        final bubbleX = ((m.x / 9.8) * 100 + 120).clamp(10.0, 230.0);
        final bubbleY = ((-m.y / 9.8) * 100 + 120).clamp(10.0, 230.0);

        return Scaffold(
          appBar: AppBar(title: const Text('Nivelador Digital')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (ctrl.ultimaAccion != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColoresApp.secundario.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColoresApp.secundario),
                    ),
                    child: Text(
                      ctrl.ultimaAccion!,
                      style: const TextStyle(color: ColoresApp.secundario),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                // Nivel visual
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: esHorizontal
                          ? ColoresApp.secundario.withValues(alpha: 0.15)
                          : ColoresApp.superficie,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: esHorizontal
                            ? ColoresApp.secundario
                            : ColoresApp.primario,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 1,
                            height: double.infinity,
                            color: ColoresApp.borde,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: ColoresApp.borde,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: ColoresApp.borde,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 80),
                          left: bubbleX,
                          top: bubbleY,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 80),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: esHorizontal
                                  ? ColoresApp.secundario
                                  : ColoresApp.acento,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (esHorizontal
                                          ? ColoresApp.secundario
                                          : ColoresApp.acento)
                                      .withValues(alpha: 0.6),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: esHorizontal
                        ? ColoresApp.secundario
                        : ColoresApp.superficie,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    esHorizontal ? '✓  Nivel Horizontal' : m.estadoInclinacion,
                    style: TextStyle(
                      color: esHorizontal
                          ? Colors.black87
                          : ColoresApp.textoBlanco,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Valores del Acelerómetro',
                            style: TextStyle(
                                color: ColoresApp.textoBlanco,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        const SizedBox(height: 16),
                        _buildEje('X', m.x, 'YouTube  →  inclina fuerte a los lados'),
                        _buildEje('Y', m.y, 'Chrome  →  inclina fuerte adelante/atrás'),
                        _buildEje('Z', m.z, 'Word  →  sacude arriba/abajo'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEje(String eje, double valor, String descripcion) {
    final intensidad = (valor.abs() / 9.8).clamp(0.0, 1.0);
    final activo = valor.abs() > 8.5;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activo ? ColoresApp.secundario : ColoresApp.primario,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(eje,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${valor.toStringAsFixed(2)} m/s²',
                        style: TextStyle(
                            color: activo
                                ? ColoresApp.secundario
                                : ColoresApp.textoBlanco,
                            fontWeight: FontWeight.bold)),
                    Text(descripcion,
                        style: const TextStyle(
                            color: ColoresApp.textoGrisClaro, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: intensidad,
              minHeight: 6,
              backgroundColor: ColoresApp.borde,
              valueColor: AlwaysStoppedAnimation<Color>(
                activo ? ColoresApp.secundario : ColoresApp.acento,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
