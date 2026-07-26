import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/mensaje.dart';

class FirebasePrivadoService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('chats');

  Future<void> enviarMensajePrivado({
    required String chatId,
    required Mensaje mensaje,
  }) async {
    await _db.child(chatId).push().set(mensaje.toJson());
  }

  Stream<List<Mensaje>> recibirMensajesPrivados(String chatId) {
    return _db.child(chatId).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      final mensajes = data.values
          .map((e) => Mensaje.fromJson(e))
          .toList();
      mensajes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return mensajes;
    });
  }
}