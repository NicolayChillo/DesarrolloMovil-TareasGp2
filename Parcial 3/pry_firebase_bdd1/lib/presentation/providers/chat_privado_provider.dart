import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mensaje.dart';
import '../../data/services/firebase_privado_service.dart';

final firebasePrivadoServiceProvider = Provider<FirebasePrivadoService>((ref) {
  return FirebasePrivadoService();
});

final chatPrivadoProvider = StreamProvider.family<List<Mensaje>, String>((ref, chatId) {
  final service = ref.watch(firebasePrivadoServiceProvider);
  return service.recibirMensajesPrivados(chatId);
});