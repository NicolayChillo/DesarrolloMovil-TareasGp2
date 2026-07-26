import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/usuarios_provider.dart';
import 'chat_privado_view.dart';

class ContactosView extends ConsumerWidget {
  const ContactosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar el usuario actual
    final currentUser = ref.watch(authProvider);

    // ✅ Cada vez que el usuario cambie, invalidar el caché de usuariosProvider
    ref.listen(authProvider, (previous, next) {
      ref.invalidate(usuariosProvider);
    });

    final usuariosAsync = ref.watch(usuariosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: usuariosAsync.when(
        data: (usuarios) {
          // Filtrar el usuario actual y aquellos que no tengan email
          final otrosUsuarios = usuarios.where((u) {
            final email = u['email'] as String?;
            return email != null && email != currentUser?.email;
          }).toList();

          if (otrosUsuarios.isEmpty) {
            return const Center(child: Text('No hay otros usuarios registrados'));
          }

          return ListView.builder(
            itemCount: otrosUsuarios.length,
            itemBuilder: (context, index) {
              final user = otrosUsuarios[index];
              final email = user['email'] as String;
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPrivadoView(receptor: email),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}