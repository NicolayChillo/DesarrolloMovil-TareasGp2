import 'package:flutter/material.dart';
import '../models/correo_model.dart';

class CorreoViewmodel extends ChangeNotifier {
  List<CorreoModel> _correos = [];
  List<CorreoModel> _correosFiltrados = [];
  String _busqueda = '';

  CorreoViewmodel() {
    _inicializarCorreos();
  }

  void _inicializarCorreos() {
    _correos = [
      CorreoModel(
        id: '1',
        remitente: 'Google',
        asunto: 'Alerta de seguridad',
        cuerpo: 'Detectamos un inicio de sesión en tu cuenta desde un nuevo dispositivo.',
        leido: false,
        fecha: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CorreoModel(
        id: '2',
        remitente: 'GitHub',
        asunto: 'Tu repositorio ha sido actualizado',
        cuerpo: 'Se ha realizado un push al repositorio pry_widgets_gmail1.',
        leido: false,
        fecha: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CorreoModel(
        id: '3',
        remitente: 'Flutter Weekly',
        asunto: 'Flutter 3.27 ya está disponible',
        cuerpo: 'Descubre las nuevas características de Flutter 3.27.',
        leido: true,
        fecha: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CorreoModel(
        id: '4',
        remitente: 'LinkedIn',
        asunto: 'Tienes 5 nuevas ofertas de trabajo',
        cuerpo: 'Empresas están interesadas en tu perfil profesional.',
        leido: false,
        fecha: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    _aplicarFiltro();
  }

  List<CorreoModel> get correos =>
      _busqueda.isEmpty ? _correos : _correosFiltrados;

  int get noLeidos => _correos.where((c) => !c.leido).length;

  String get busqueda => _busqueda;

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

  void recibirNuevoCorreo() {
    final nuevoId = (_correos.length + 1).toString();
    _correos.insert(
      0,
      CorreoModel(
        id: nuevoId,
        remitente: 'Nuevo Remitente',
        asunto: 'Correo nuevo #$nuevoId',
        cuerpo: 'Este es un correo simulado recibido.',
        leido: false,
        fecha: DateTime.now(),
      ),
    );
    _aplicarFiltro();
    notifyListeners();
  }

  void agregarCorreo(String remitente, String asunto, String cuerpo) {
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
