
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../providers/admin_provider.dart';

class AdminGateScreen extends StatefulWidget {
  const AdminGateScreen({super.key});
  @override
  State<AdminGateScreen> createState() => _AdminGateScreenState();
}

class _AdminGateScreenState extends State<AdminGateScreen> {
  final _pinController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _validar() {
    final ok = context.read<AdminProvider>().validarPin(_pinController.text);
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.adminSolicitudes);
    } else {
      setState(() => _error = 'PIN incorrecto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acceso administrador')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'PIN', errorText: _error),
              onSubmitted: (_) => _validar(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _validar, child: const Text('Ingresar')),
            ),
          ],
        ),
      ),
    );
  }
}