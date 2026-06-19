import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'gmail_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewmodel>(context);
    final correoVm = Provider.of<CorreoViewmodel>(context, listen: false);

    if (authVm.status != AuthStatus.authenticated) {
      return _buildLoginScreen(context, authVm, correoVm);
    }

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
                    correoVm.buscar(controller.text);
                    Navigator.pop(context);
                  },
                  child: Text('Buscar'),
                ),
              ],
            ),
          );
        },
        onRedactarTap: () async {
          final paraCtrl = TextEditingController();
          final asuntoCtrl = TextEditingController();
          final cuerpoCtrl = TextEditingController();
          final result = await showDialog<bool>(
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
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (asuntoCtrl.text.isNotEmpty && paraCtrl.text.isNotEmpty) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          );

          if (result == true) {
            try {
              await authVm.gmailApiService.sendMessage(
                to: paraCtrl.text,
                subject: asuntoCtrl.text,
                body: cuerpoCtrl.text,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Correo enviado correctamente')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al enviar: $e')),
                );
              }
            }
          }
        },
        onNoLeidosTap: () {
          correoVm.marcarTodosLeidos();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Todos los correos marcados como leídos'),
            ),
          );
        },
        onRefresh: () => authVm.refreshEmails(correoVm),
        onSignOut: () => authVm.signOut(correoVm),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, AuthViewmodel authVm, CorreoViewmodel correoVm) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mail_outline, size: 80, color: Colors.red[400]),
              SizedBox(height: 24),
              Text(
                'Gmail Client',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Conecta tu cuenta de Gmail',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 32),
              if (authVm.status == AuthStatus.authenticating)
                CircularProgressIndicator()
              else ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => authVm.signIn(correoVm),
                    icon: Icon(Icons.login),
                    label: Text('Iniciar sesión con Google', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => _openGmailApp(context),
                  icon: Icon(Icons.open_in_new, size: 18),
                  label: Text('Abrir Gmail'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red[600]),
                ),
              ],
              if (authVm.status == AuthStatus.error)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    authVm.errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGmailApp(BuildContext context) async {
    final uri = Uri.parse('mailto:');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final webUri = Uri.parse('https://mail.google.com');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
