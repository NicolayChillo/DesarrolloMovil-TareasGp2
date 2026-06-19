import 'package:flutter/material.dart';
import '../models/correo_model.dart';
import '../services/gmail_api_service.dart';

class CorreoViewmodel extends ChangeNotifier {
  List<CorreoModel> _correos = [];
  List<CorreoModel> _correosFiltrados = [];
  String _busqueda = '';
  bool _cargando = false;
  bool _usaMock = true;

  List<CorreoModel> get correos =>
      _busqueda.isEmpty ? _correos : _correosFiltrados;

  int get noLeidos => _correos.where((c) => !c.leido).length;

  String get busqueda => _busqueda;

  bool get cargando => _cargando;
  bool get usaMock => _usaMock;

  Future<void> cargarCorreos(GmailApiService apiService) async {
    _cargando = true;
    _usaMock = false;
    notifyListeners();

    try {
      _correos = await apiService.listMessages();
      _aplicarFiltro();
    } catch (e) {
      debugPrint('Error al cargar correos: $e');
    }

    _cargando = false;
    notifyListeners();
  }

  void limpiarCorreos() {
    _correos = [];
    _correosFiltrados = [];
    _usaMock = true;
    notifyListeners();
  }

  void buscar(String query) {
    _busqueda = query;
    _aplicarFiltro();
    notifyListeners();
  }

  void _aplicarFiltro() {
    if (_busqueda.isEmpty) {
      _correosFiltrados = List.from(_correos);
    } else {
      _correosFiltrados = _correos
          .where((c) =>
              c.asunto.toLowerCase().contains(_busqueda.toLowerCase()) ||
              c.remitente.toLowerCase().contains(_busqueda.toLowerCase()))
          .toList();
    }
  }

  void marcarLeido(String id) {
    final index = _correos.indexWhere((c) => c.id == id);
    if (index != -1) {
      _correos[index].leido = true;
      notifyListeners();
    }
  }

  void marcarTodosLeidos() {
    for (var c in _correos) {
      c.leido = true;
    }
    notifyListeners();
  }

  void agregarCorreoMock(String remitente, String asunto, String cuerpo) {
    final nuevoId = (_correos.length + 1).toString();
    _correos.insert(
      0,
      CorreoModel(
        id: nuevoId,
        remitente: remitente,
        asunto: asunto,
        cuerpo: cuerpo,
        leido: false,
        fecha: DateTime.now(),
      ),
    );
    _aplicarFiltro();
    notifyListeners();
  }
}
