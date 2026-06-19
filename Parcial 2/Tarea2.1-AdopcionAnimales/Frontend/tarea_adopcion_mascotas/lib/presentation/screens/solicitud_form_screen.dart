// presentation/screens/solicitud_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/mascota.dart';
import '../providers/solicitud_form_provider.dart';

class SolicitudFormScreen extends StatefulWidget {
  final Mascota mascota;
  const SolicitudFormScreen({super.key, required this.mascota});

  @override
  State<SolicitudFormScreen> createState() => _SolicitudFormScreenState();
}

class _SolicitudFormScreenState extends State<SolicitudFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _comentarioController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SolicitudFormProvider>();
    final exito = await provider.enviarSolicitud(
      mascota: widget.mascota,
      nombre: _nombreController.text,
      telefono: _telefonoController.text,
      comentario: _comentarioController.text,
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud enviada correctamente')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Error al enviar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adoptar a ${widget.mascota.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: Validators.validarNombre,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: Validators.validarTelefono,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _comentarioController,
                decoration: const InputDecoration(labelText: 'Comentario (opcional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Consumer<SolicitudFormProvider>(
                builder: (context, provider, _) {
                  final enviando = provider.estado == EstadoEnvio.enviando;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: enviando ? null : _enviar,
                      child: enviando
                          ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Enviar solicitud'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}