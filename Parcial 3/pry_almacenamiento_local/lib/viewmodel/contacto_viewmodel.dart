// lib/viewmodel/contact_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/contacto_model.dart';

class ContactViewModel extends ChangeNotifier {
  static const String _contactsKey = 'contacts_list';
  List<ContactModel> _contacts = [];
  List<ContactModel> _filteredContacts = [];
  String _searchQuery = '';
  String _operationMessage = '';
  bool _isSuccess = false;

  // Getters
  List<ContactModel> get contacts => _filteredContacts;
  String get searchQuery => _searchQuery;
  String get operationMessage => _operationMessage;
  bool get isSuccess => _isSuccess;

  // Cargar contactos desde SharedPreferences
  Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsJson = prefs.getString(_contactsKey);

    if (contactsJson != null) {
      final List<dynamic> decoded = json.decode(contactsJson);
      _contacts = decoded.map((item) => ContactModel.fromJson(item)).toList();
    } else {
      // Datos de ejemplo
      _contacts = [
        ContactModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Juan Pérez',
          phone: '123456789',
          email: 'juan@example.com',
        ),
        ContactModel(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          name: 'María García',
          phone: '987654321',
          email: 'maria@example.com',
        ),
      ];
      await _saveContacts();
    }
    _applyFilter();
    notifyListeners();
  }

  // Guardar contactos en SharedPreferences
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
    _contacts.map((contact) => contact.toJson()).toList();
    await prefs.setString(_contactsKey, json.encode(jsonList));
  }

  // Agregar contacto
  Future<bool> addContact(ContactModel contact) async {
    try {
      // Validar que no exista un contacto con el mismo nombre o teléfono
      final exists = _contacts.any((c) =>
      c.name.toLowerCase() == contact.name.toLowerCase() ||
          c.phone == contact.phone
      );

      if (exists) {
        _operationMessage = 'Ya existe un contacto con ese nombre o teléfono';
        _isSuccess = false;
        notifyListeners();
        return false;
      }

      _contacts.add(contact);
      await _saveContacts();
      _applyFilter();

      _operationMessage = 'Contacto "${contact.name}" agregado correctamente';
      _isSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _operationMessage = 'Error al agregar el contacto';
      _isSuccess = false;
      notifyListeners();
      return false;
    }
  }

  // Actualizar contacto
  Future<bool> updateContact(ContactModel updatedContact) async {
    try {
      final index = _contacts.indexWhere((c) => c.id == updatedContact.id);
      if (index != -1) {
        // Validar que no haya duplicados (excepto el mismo contacto)
        final exists = _contacts.any((c) =>
        c.id != updatedContact.id &&
            (c.name.toLowerCase() == updatedContact.name.toLowerCase() ||
                c.phone == updatedContact.phone)
        );

        if (exists) {
          _operationMessage = 'Ya existe otro contacto con ese nombre o teléfono';
          _isSuccess = false;
          notifyListeners();
          return false;
        }

        final oldName = _contacts[index].name;
        _contacts[index] = updatedContact;
        await _saveContacts();
        _applyFilter();

        _operationMessage = 'Contacto "$oldName" actualizado correctamente';
        _isSuccess = true;
        notifyListeners();
        return true;
      }
      _operationMessage = 'Contacto no encontrado';
      _isSuccess = false;
      notifyListeners();
      return false;
    } catch (e) {
      _operationMessage = 'Error al actualizar el contacto';
      _isSuccess = false;
      notifyListeners();
      return false;
    }
  }

  // Eliminar contacto
  Future<bool> deleteContact(String id) async {
    try {
      final contactToDelete = _contacts.firstWhere((c) => c.id == id);
      _contacts.removeWhere((contact) => contact.id == id);
      await _saveContacts();
      _applyFilter();

      _operationMessage = 'Contacto "${contactToDelete.name}" eliminado correctamente';
      _isSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _operationMessage = 'Error al eliminar el contacto';
      _isSuccess = false;
      notifyListeners();
      return false;
    }
  }

  // Buscar contactos
  void searchContacts(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  // Aplicar filtro de búsqueda
  void _applyFilter() {
    List<ContactModel> filtered;
    if (_searchQuery.isEmpty) {
      filtered = List.from(_contacts);
    } else {
      filtered = _contacts.where((contact) =>
      contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.phone.contains(_searchQuery) ||
          contact.email.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    // Ordenar alfabéticamente por nombre (case insensitive)
    filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _filteredContacts = filtered;
  }

  // Limpiar búsqueda
  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
    notifyListeners();
  }

  // Obtener contacto por ID
  ContactModel? getContactById(String id) {
    try {
      return _contacts.firstWhere((contact) => contact.id == id);
    } catch (e) {
      return null;
    }
  }

  // Limpiar mensaje
  void clearMessage() {
    _operationMessage = '';
    _isSuccess = false;
    notifyListeners();
  }

  // Contar contactos
  int get contactCount => _contacts.length;
  int get filteredCount => _filteredContacts.length;
}