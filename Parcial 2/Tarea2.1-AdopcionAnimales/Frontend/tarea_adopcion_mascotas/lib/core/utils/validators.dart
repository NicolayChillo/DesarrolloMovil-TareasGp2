
class Validators {
  static final RegExp _telefonoRegex = RegExp(r'^[0-9]{7,10}$');

  static bool esTelefonoValido(String value) =>
      _telefonoRegex.hasMatch(value.trim());

  static String? validarTelefono(String? value) {
    if (value == null || !esTelefonoValido(value)) {
      return 'Ingresa un teléfono válido (7 a 10 dígitos)';
    }
    return null;
  }

  static String? validarNombre(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }
}