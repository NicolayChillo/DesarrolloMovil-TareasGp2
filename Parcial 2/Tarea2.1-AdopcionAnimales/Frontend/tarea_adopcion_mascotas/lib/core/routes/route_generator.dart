// core/routes/route_generator.dart
import 'package:flutter/material.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/mascota_detalle_screen.dart';
import '../../presentation/screens/solicitud_form_screen.dart';
import '../../presentation/screens/admin_gate_screen.dart';
import '../../presentation/screens/admin_solicitudes_screen.dart';
import '../../domain/entities/mascota.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
        
      case AppRoutes.detalle:
        final mascota = settings.arguments as Mascota;
        return MaterialPageRoute(
          builder: (_) => MascotaDetalleScreen(mascota: mascota),
        );
        
      case AppRoutes.formulario:
        final mascota = settings.arguments as Mascota;
        return MaterialPageRoute(
          builder: (_) => SolicitudFormScreen(mascota: mascota),
        );
        
      case AppRoutes.adminGate:
        return MaterialPageRoute(builder: (_) => const AdminGateScreen());
        
      case AppRoutes.adminSolicitudes:
        return MaterialPageRoute(builder: (_) => const AdminSolicitudesScreen());
        
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
        );
    }
  }
}