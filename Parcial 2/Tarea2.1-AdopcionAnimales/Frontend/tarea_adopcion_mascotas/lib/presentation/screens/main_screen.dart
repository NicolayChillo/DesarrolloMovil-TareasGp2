// presentation/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mascotas_grid_screen.dart';
import 'solicitudes_screen.dart';
import 'admin_gate_screen.dart';
import '../providers/mascotas_provider.dart';
import '../providers/solicitudes_provider.dart';
import '../providers/navigation_provider.dart'; // ✅ Nuevo import

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const MascotasGridScreen(),
    const SolicitudesScreen(),
    const AdminGateScreen(),
  ];

  final List<String> _titles = [
    'Mascotas disponibles',
    'Solicitudes',
    'Administrador',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_titles[navProvider.selectedIndex]),
            actions: [
              if (navProvider.selectedIndex == 0)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<MascotasProvider>().cargarMascotasDisponibles();
                  },
                ),
              if (navProvider.selectedIndex == 1)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<SolicitudesProvider>().cargarTodasLasSolicitudes();
                  },
                ),
            ],
          ),
          body: IndexedStack(
            index: navProvider.selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navProvider.selectedIndex,
            onTap: (index) {
              navProvider.setSelectedIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Solicitudes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
              ),
            ],
          ),
        );
      },
    );
  }
}