import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/pin_model.dart';

class PinViewModel extends ChangeNotifier {
  static const String _pinClave = 'usuario_pin';
  
  // Crear una instancia de PinModel
  final PinModel _pinModel = PinModel.empty();
  String _entradaPin = '';
  String _mensaje = '';
  bool _esCorrecto = false;

  // Getters
  String get entradaPin => _entradaPin;
  String get mensaje => _mensaje;
  bool get esCorrecto => _esCorrecto;
  int get pinLength => _entradaPin.length;

  // Método para cargar el PIN guardado
  Future<void> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    String savedPin = prefs.getString(_pinClave) ?? '';
    
    if (savedPin.isEmpty) {
      savedPin = '1234';
      await prefs.setString(_pinClave, savedPin);
    }
    
    _pinModel.pin = savedPin;
    notifyListeners();
  }

  // Método para agregar números al PIN
  bool addNumber(String number) {
    if (_entradaPin.length < 4) {
      _entradaPin += number;
      _mensaje = '';
      _esCorrecto = false;
      notifyListeners();
      return validatePin(); // Retorna true si el PIN es correcto
    }
    return false;
  }

  // Método para validar el PIN
  bool validatePin() {
    if (_entradaPin.length < 4) {
      return false;
    }

    if (_entradaPin == _pinModel.pin) {
      _mensaje = 'El PIN es correcto';
      _esCorrecto = true;
      notifyListeners();
      return true;
    } else {
      _entradaPin = '';
      _mensaje = 'El PIN es incorrecto';
      _esCorrecto = false;
      notifyListeners();
      return false;
    }
  }

  // Método para eliminar el último número
  void deleteNumber() {
    if (_entradaPin.isNotEmpty) {
      _entradaPin = _entradaPin.substring(0, _entradaPin.length - 1);
      _mensaje = '';
      _esCorrecto = false;
      notifyListeners();
    }
  }

  // Método para olvidar el PIN
  void forgotPin() {
    _entradaPin = '';
    _mensaje = 'Usa la opción "Cambiar PIN" para establecer uno nuevo';
    _esCorrecto = false;
    notifyListeners();
  }

  // Método para cambiar el PIN (sin parámetros)
  void changePin() {
    if (_entradaPin.isEmpty) {
      _mensaje = 'Ingresa un PIN de 4 dígitos para cambiar';
      notifyListeners();
      return;
    }
    
    if (_entradaPin.length < 4) {
      _mensaje = 'El PIN debe tener exactamente 4 dígitos';
      notifyListeners();
      return;
    }
    
    // Cambiar el PIN usando el método con parámetro
    _changePinWithValue(_entradaPin);
  }

  // Método privado para cambiar el PIN con valor específico
  Future<void> _changePinWithValue(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinClave, newPin);
    _pinModel.pin = newPin;
    _entradaPin = '';
    _mensaje = 'El PIN ha sido cambiado correctamente';
    _esCorrecto = true;
    notifyListeners();
  }

  // Método para olvidar el PIN (versión async)
  Future<void> forgetPinAsync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinClave);
    _pinModel.pin = '';
    _entradaPin = '';
    _mensaje = 'El PIN ha sido olvidado';
    _esCorrecto = false;
    notifyListeners();
  }

  // Método para cambiar el PIN con valor (versión async)
  Future<void> changePinAsync(String newPin) async {
    if (newPin.length != 4) {
      _mensaje = 'El PIN debe tener exactamente 4 dígitos';
      notifyListeners();
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinClave, newPin);
    _pinModel.pin = newPin;
    _entradaPin = '';
    _mensaje = 'El PIN ha sido cambiado correctamente';
    _esCorrecto = true;
    notifyListeners();
  }

  // Agrega este método:
  void clearPin() {
    _entradaPin = '';
    _mensaje = '';
    _esCorrecto = false;
    notifyListeners();
  }
}