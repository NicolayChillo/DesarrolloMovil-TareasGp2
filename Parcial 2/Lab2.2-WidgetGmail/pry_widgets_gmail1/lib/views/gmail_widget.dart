import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/correo_model.dart';

class GmailWidget extends StatelessWidget {
  final void Function()? onBuscarTap;
  final void Function()? onRedactarTap;
  final void Function()? onNoLeidosTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onSignOut;

  const GmailWidget({
    super.key,
    this.onBuscarTap,
    this.onRedactarTap,
    this.onNoLeidosTap,
    this.onRefresh,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CorreoViewmodel>(context);
    final authVm = Provider.of<AuthViewmodel>(context);
    final correos = vm.correos;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Color(0xFFD32F2F),
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.mail_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Inbox',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                if (authVm.userPhotoUrl != null)
                  GestureDetector(
                    onTap: () => _showUserMenu(context, authVm),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(authVm.userPhotoUrl!),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _showUserMenu(context, authVm),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white24,
                      child: Text(
                        authVm.userEmail[0].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: GestureDetector(
              onTap: onBuscarTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 12),
                    Text(
                      'Buscar en el correo',
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.edit,
                  label: 'Redactar',
                  onTap: onRedactarTap,
                ),
                _ActionButton(
                  icon: Icons.drafts_outlined,
                  label: 'No leídos',
                  badge: '${vm.noLeidos}',
                  onTap: onNoLeidosTap,
                ),
              ],
            ),
          ),
          Divider(height: 24),
          if (vm.busqueda.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Resultados para "${vm.busqueda}": ${correos.length} correos',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          Expanded(
            child: vm.cargando
                ? Center(child: CircularProgressIndicator())
                : correos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                            SizedBox(height: 8),
                            Text(
                              'No hay correos',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: onRefresh,
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text('Recargar'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => onRefresh?.call(),
                        child: ListView.separated(
                          itemCount: correos.length,
                          separatorBuilder: (_, _) => Divider(height: 1),
                          itemBuilder: (_, i) => _EmailItem(
                            correo: correos[i],
                            vm: vm,
                            authVm: authVm,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showUserMenu(BuildContext context, AuthViewmodel authVm) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  if (authVm.userPhotoUrl != null)
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(authVm.userPhotoUrl!),
                    )
                  else
                    CircleAvatar(
                      radius: 24,
                      child: Text(authVm.userEmail[0].toUpperCase()),
                    ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(authVm.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(authVm.userEmail, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Recargar correos'),
              onTap: () {
                Navigator.pop(context);
                onRefresh?.call();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onSignOut?.call();
              },
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.red[700], size: 24),
              ),
              if (badge != null && badge != '0')
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ],
      ),
    );
  }
}

class _EmailItem extends StatelessWidget {
  final CorreoModel correo;
  final CorreoViewmodel vm;
  final AuthViewmodel authVm;

  const _EmailItem({required this.correo, required this.vm, required this.authVm});

  @override
  Widget build(BuildContext context) {
    final bold = !correo.leido;
    return GestureDetector(
      onTap: () {
        vm.marcarLeido(correo.id);
        _mostrarDetalle(context, correo);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: bold ? Colors.blue[50] : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red[100],
              child: Text(
                correo.remitente.isNotEmpty ? correo.remitente[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          correo.remitente.isNotEmpty ? correo.remitente : '(Sin remitente)',
                          style: TextStyle(
                            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        _formatearFecha(correo.fecha),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    correo.asunto.isNotEmpty ? correo.asunto : '(Sin asunto)',
                    style: TextStyle(
                      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    correo.cuerpo,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (bold)
              Container(
                margin: EdgeInsets.only(left: 8, top: 6),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final now = DateTime.now();
    final diff = now.difference(fecha);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${fecha.day}/${fecha.month}';
  }

  Future<void> _mostrarDetalle(BuildContext context, CorreoModel correo) async {
    String cuerpoCompleto = correo.cuerpo;

    if (cuerpoCompleto.length < 100) {
      try {
        final fullBody = await authVm.gmailApiService.getMessageBody(correo.id);
        if (fullBody != null && fullBody.isNotEmpty && fullBody != '(sin contenido)') {
          cuerpoCompleto = fullBody;
        }
      } catch (_) {}
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[100],
              child: Text(
                correo.remitente.isNotEmpty ? correo.remitente[0].toUpperCase() : '?',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    correo.remitente,
                    style: TextStyle(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    correo.asunto,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatearFecha(correo.fecha),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(cuerpoCompleto, style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
