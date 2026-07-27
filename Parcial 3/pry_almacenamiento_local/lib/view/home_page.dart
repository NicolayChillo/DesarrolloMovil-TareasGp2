import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/widgets/custom_icon.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/custom_text.dart';
import '../viewmodel/theme_viewmodel.dart';
import '../viewmodel/pin_viewmodel.dart';
import 'pin_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          // Botón de tema
          IconButton(
            icon: Icon(themeViewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeViewModel.toggleTheme();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    themeViewModel.isDarkMode
                        ? 'Modo oscuro activado'
                        : 'Modo claro activado',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Cambiar tema',
          ),
          // Botón de logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Limpiar PIN antes de salir
              context.read<PinViewModel>().clearPin();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PinPage()),
              );
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Center(
        child: CustomCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomIcon(icon: Icons.check_circle, size: 50),
              const SizedBox(height: 20),
              CustomText(
                text: '¡Bienvenido!',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CustomText(
                text: 'Has ingresado correctamente',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}