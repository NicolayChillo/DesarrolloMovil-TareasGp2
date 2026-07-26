import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_privado_provider.dart';
import '../../domain/models/mensaje.dart';

class ChatPrivadoView extends ConsumerStatefulWidget {
  final String receptor;
  const ChatPrivadoView({super.key, required this.receptor});

  @override
  ConsumerState<ChatPrivadoView> createState() => _ChatPrivadoViewState();
}

class _ChatPrivadoViewState extends ConsumerState<ChatPrivadoView> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider);
    final String autor = currentUser?.email ?? 'Anónimo';

    final List<String> emails = [autor, widget.receptor]..sort();
    final String chatId = '${emails[0].replaceAll('.', '_').replaceAll('@', '_')}_${emails[1].replaceAll('.', '_').replaceAll('@', '_')}';

    final mensajesAsync = ref.watch(chatPrivadoProvider(chatId));
    final service = ref.read(firebasePrivadoServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con ${widget.receptor}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) {
                // ✅ Cuando los mensajes cambian, hacer scroll al final
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: mensajes.length,
                  itemBuilder: (_, i) {
                    final m = mensajes[i];
                    final esMio = m.autor == autor;
                    return Align(
                      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: esMio ? Colors.blueAccent : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: esMio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.texto,
                              style: TextStyle(
                                color: esMio ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m.autor,
                              style: TextStyle(
                                fontSize: 11,
                                color: esMio ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () async {
                      final texto = controller.text.trim();
                      final messenger = ScaffoldMessenger.of(context);
                      if (texto.isEmpty) return;
                      try {
                        await service.enviarMensajePrivado(
                          chatId: chatId,
                          mensaje: Mensaje(
                            texto: texto,
                            autor: autor,
                            receptor: widget.receptor,
                            timestamp: DateTime.now().millisecondsSinceEpoch,
                          ),
                        );
                        controller.clear();
                        // ✅ Al enviar, los datos se actualizan y el callback hará scroll
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}