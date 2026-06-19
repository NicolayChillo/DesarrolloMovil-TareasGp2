// presentation/providers/navigation_provider.dart
import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      print('🔀 Cambiando pestaña: $_selectedIndex -> $index');
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void goToMascotas() {
    print('🏠 Navegando a Mascotas (tab 0)');
    setSelectedIndex(0);
  }

  void goToSolicitudes() {
    print('📋 Navegando a Solicitudes (tab 1)');
    setSelectedIndex(1);
  }

  void goToAdmin() {
    print('🔒 Navegando a Admin (tab 2)');
    setSelectedIndex(2);
  }
}