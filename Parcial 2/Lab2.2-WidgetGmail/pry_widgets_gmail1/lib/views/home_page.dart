import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/correo_viewmodel.dart';
import 'gmail_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CorreoViewmodel>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: GmailWidget(
        onBuscarTap: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Buscar correos'),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar por asunto o remitente',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    vm.buscar(controller.text);
                    Navigator.pop(context);
                  },
                  child: Text('Buscar'),
                ),
              ],
            ),
          );
        },
        onRedactarTap: () {
          final paraCtrl = TextEditingController();
          final asuntoCtrl = TextEditingController();
          final cuerpoCtrl = TextEditingController();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Redactar correo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: paraCtrl,
                    decoration: InputDecoration(
                      labelText: 'Para',
                      hintText: 'destinatario@email.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: asuntoCtrl,
                    decoration: InputDecoration(
                      labelText: 'Asunto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: cuerpoCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Mensaje',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (asuntoCtrl.text.isNotEmpty) {
                      vm.agregarCorreo(
                        paraCtrl.text.isEmpty
                            ? 'Destinatario'
                            : paraCtrl.text,
                        asuntoCtrl.text,
                        cuerpoCtrl.text,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Correo enviado')),
                      );
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          );
        },
        onNoLeidosTap: () {
          vm.marcarTodosLeidos();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Todos los correos marcados como leídos'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.recibirNuevoCorreo(),
        child: Icon(Icons.add),
      ),
    );
  }
}
