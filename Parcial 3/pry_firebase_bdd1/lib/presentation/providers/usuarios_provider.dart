import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usuariosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  print('🔄 Cargando usuarios desde la base de datos...');
  final DatabaseReference refDb = FirebaseDatabase.instance.ref('usuarios');
  final DataSnapshot snapshot = await refDb.get();

  if (snapshot.value == null) {
    print('❌ No hay usuarios en la base de datos');
    return [];
  }

  final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  print('📦 Total de usuarios encontrados: ${data.length}');

  final lista = data.values
      .where((e) => e is Map && e.containsKey('email') && e['email'] != null)
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  print('✅ Usuarios válidos: ${lista.map((e) => e['email']).toList()}');
  return lista;
});