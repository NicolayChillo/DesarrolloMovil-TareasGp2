// presentation/screens/admin_gate_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/navigation_provider.dart';
import 'admin_solicitudes_screen.dart';

class AdminGateScreen extends StatefulWidget {
  const AdminGateScreen({super.key});

  @override
  State<AdminGateScreen> createState() => _AdminGateScreenState();
}

class _AdminGateScreenState extends State<AdminGateScreen> {
  final TextEditingController _pinController = TextEditingController();
  String? _error;
  final FocusNode _focusNode = FocusNode();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _limpiarPIN() {
    _pinController.clear();
    _error = null;
    setState(() {});
  }

  void _ocultarTeclado() {
    FocusScope.of(context).unfocus();
  }

  void _validar() {
    _ocultarTeclado();
    
    final pin = _pinController.text.trim();
    final ok = context.read<AdminProvider>().validarPin(pin);
    
    if (ok) {
      setState(() {
        _isAuthenticated = true;
      });
      _limpiarPIN();
    } else {
      setState(() {
        _error = 'PIN incorrecto';
        _pinController.clear();
      });
    }
  }

  void _cerrarSesion() {
    context.read<AdminProvider>().cerrarSesion();
    setState(() {
      _isAuthenticated = false;
    });
    _limpiarPIN();
  }

  void _volverAlInicio() {
    // ✅ Cambiar a la pestaña de Mascotas (tab 0)
    final navProvider = context.read<NavigationProvider>();
    navProvider.goToMascotas();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Deshabilitar el back button del sistema
    return WillPopScope(
      onWillPop: () async {
        // ✅ Cuando se presiona back, ir a Mascotas
        final navProvider = context.read<NavigationProvider>();
        navProvider.goToMascotas();
        return false; // ✅ Prevenir que el sistema cierre la pantalla
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isAuthenticated ? 'Administrar' : 'Acceso administrador'),
          // ✅ Eliminar el botón de retroceso
          automaticallyImplyLeading: false,
          actions: [
            // ✅ Botón para volver al inicio (siempre visible)
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: _volverAlInicio,
              tooltip: 'Volver al inicio',
            ),
            if (_isAuthenticated)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _cerrarSesion,
                tooltip: 'Cerrar sesión',
              ),
          ],
        ),
        body: _isAuthenticated
            ? const AdminSolicitudesScreen()
            : _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return GestureDetector(
      onTap: _ocultarTeclado,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.admin_panel_settings,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Ingresa el PIN de administrador',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                focusNode: _focusNode,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  errorText: _error,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _limpiarPIN,
                    splashRadius: 20,
                  ),
                ),
                onSubmitted: (_) => _validar(),
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: _error != null ? Colors.red : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Ingresar'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}