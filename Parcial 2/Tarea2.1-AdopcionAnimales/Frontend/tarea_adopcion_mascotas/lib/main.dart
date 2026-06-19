// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/theme/tema_general.dart';
import 'data/datasources/mascota_remote_datasource.dart';
import 'data/datasources/solicitud_remote_datasource.dart';
import 'data/repositories/mascota_repository_impl.dart';
import 'data/repositories/solicitud_repository_impl.dart';

// UseCases de Mascotas
import 'domain/usecases/mascotas_usescases/obtener_mascotas_usecase.dart';
import 'domain/usecases/mascotas_usescases/obtener_mascota_por_id_usecase.dart';
import 'domain/usecases/mascotas_usescases/crear_mascota_usecase.dart';
import 'domain/usecases/mascotas_usescases/actualizar_mascota_usecase.dart';
import 'domain/usecases/mascotas_usescases/eliminar_mascota_usecase.dart';

// UseCases de Solicitudes
import 'domain/usecases/solicitudes_usecases/crear_solicitud_usecase.dart';
import 'domain/usecases/solicitudes_usecases/obtener_solicitudes_usecase.dart';
import 'domain/usecases/solicitudes_usecases/obtener_solicitud_por_id_usecase.dart';
import 'domain/usecases/solicitudes_usecases/aprobar_solicitud_usecase.dart';
import 'domain/usecases/solicitudes_usecases/rechazar_solicitud_usecase.dart';
import 'domain/usecases/solicitudes_usecases/actualizar_solicitud_usecase.dart';
import 'domain/usecases/solicitudes_usecases/eliminar_solicitud_usecase.dart';

// Providers
import 'presentation/providers/mascotas_provider.dart';
import 'presentation/providers/solicitud_form_provider.dart';
import 'presentation/providers/admin_provider.dart';
import 'presentation/providers/solicitudes_provider.dart';
import 'presentation/providers/navigation_provider.dart';

void main() {
  final httpClient = http.Client();

  // ============================================================
  // REPOSITORIOS
  // ============================================================
  
  final mascotaRepository = MascotaRepositoryImpl(
    remoteDataSource: MascotaRemoteDataSourceImpl(client: httpClient),
  );
  
  final solicitudRepository = SolicitudRepositoryImpl(
    remoteDataSource: SolicitudRemoteDataSourceImpl(client: httpClient),
  );

  // ============================================================
  // USECASES DE MASCOTAS
  // ============================================================
  
  final obtenerMascotasUseCase = ObtenerMascotasUseCase(mascotaRepository);
  final obtenerMascotaPorIdUseCase = ObtenerMascotaPorIdUseCase(mascotaRepository);
  final crearMascotaUseCase = CrearMascotaUseCase(mascotaRepository);
  final actualizarMascotaUseCase = ActualizarMascotaUseCase(mascotaRepository);
  final eliminarMascotaUseCase = EliminarMascotaUseCase(mascotaRepository);

  // ============================================================
  // USECASES DE SOLICITUDES
  // ============================================================
  
  final crearSolicitudUseCase = CrearSolicitudUseCase(solicitudRepository);
  final obtenerSolicitudesUseCase = ObtenerSolicitudesUseCase(solicitudRepository);
  final obtenerSolicitudPorIdUseCase = ObtenerSolicitudPorIdUseCase(solicitudRepository);
  final actualizarSolicitudUseCase = ActualizarSolicitudUseCase(solicitudRepository);
  final eliminarSolicitudUseCase = EliminarSolicitudUseCase(solicitudRepository);
  final aprobarSolicitudUseCase = AprobarSolicitudUseCase(solicitudRepository);
  final rechazarSolicitudUseCase = RechazarSolicitudUseCase(solicitudRepository);

  // ============================================================
  // RUN APP
  // ============================================================
  
  runApp(
    MultiProvider(
      providers: [
        // ✅ Provider de Mascotas
        ChangeNotifierProvider(
          create: (_) => MascotasProvider(
            obtenerMascotasUseCase: obtenerMascotasUseCase,
            obtenerMascotaPorIdUseCase: obtenerMascotaPorIdUseCase,
            crearMascotaUseCase: crearMascotaUseCase,
            actualizarMascotaUseCase: actualizarMascotaUseCase,
            eliminarMascotaUseCase: eliminarMascotaUseCase,
          ),
        ),
        
        // ✅ Provider de SolicitudForm
        ChangeNotifierProvider(
          create: (_) => SolicitudFormProvider(
            crearSolicitudUseCase: crearSolicitudUseCase,
          ),
        ),
        
        // ✅ Provider de Admin
        ChangeNotifierProvider(
          create: (_) => AdminProvider(
            obtenerSolicitudesUseCase: obtenerSolicitudesUseCase,
            aprobarSolicitudUseCase: aprobarSolicitudUseCase,
            rechazarSolicitudUseCase: rechazarSolicitudUseCase,
          ),
        ),

        // ✅ NUEVO Provider de Solicitudes (sin autenticación)
        ChangeNotifierProvider(
          create: (_) => SolicitudesProvider(
            obtenerSolicitudesUseCase: obtenerSolicitudesUseCase,
          ),
        ),

        // ✅ NUEVO Provider de Navegación
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Adopción de Mascotas',
        debugShowCheckedModeBanner: false,
        theme: TemaGeneral.temaClaro,
        darkTheme: TemaGeneral.temaOscuro,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  );
}