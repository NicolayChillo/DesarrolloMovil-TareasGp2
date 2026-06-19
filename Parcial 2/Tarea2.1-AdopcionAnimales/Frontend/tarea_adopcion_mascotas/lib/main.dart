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
import 'domain/usecases/obtener_mascotas_usecase.dart';
import 'domain/usecases/crear_solicitud_usecase.dart';
import 'domain/usecases/obtener_solicitudes_usecase.dart';
import 'presentation/providers/mascotas_provider.dart';
import 'presentation/providers/solicitud_form_provider.dart';
import 'presentation/providers/admin_provider.dart';

void main() {
  final httpClient = http.Client();

  // Repositorios
  final mascotaRepository = MascotaRepositoryImpl(
    remoteDataSource: MascotaRemoteDataSourceImpl(client: httpClient),
  );
  final solicitudRepository = SolicitudRepositoryImpl(
    remoteDataSource: SolicitudRemoteDataSourceImpl(client: httpClient),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MascotasProvider(
          ObtenerMascotasUseCase(mascotaRepository),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => SolicitudFormProvider(
          CrearSolicitudUseCase(solicitudRepository),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => AdminProvider(
          obtenerSolicitudesUseCase: ObtenerSolicitudesUseCase(solicitudRepository),
          aprobarSolicitudUseCase: AprobarSolicitudUseCase(solicitudRepository),
          rechazarSolicitudUseCase: RechazarSolicitudUseCase(solicitudRepository),
        ),
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
  ));
}
