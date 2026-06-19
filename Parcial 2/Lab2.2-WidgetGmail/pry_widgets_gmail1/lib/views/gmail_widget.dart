import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../models/correo_model.dart';

class GmailWidget extends StatelessWidget {
  final void Function()? onBuscarTap;
  final void Function()? onRedactarTap;
  final void Function()? onNoLeidosTap;

  GmailWidget({this.onBuscarTap, this.onRedactarTap, this.onNoLeidosTap});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CorreoViewmodel>(context);
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
                Text(
                  '${vm.noLeidos} no leídos',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
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
            child: correos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          'No se encontraron correos',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: correos.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (_, i) => _EmailItem(
                      correo: correos[i],
                      vm: vm,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;

  _ActionButton({
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

  _EmailItem({required this.correo, required this.vm});

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
                correo.remitente[0].toUpperCase(),
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
                          correo.remitente,
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
                    correo.asunto,
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

  void _mostrarDetalle(BuildContext context, CorreoModel correo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[100],
              child: Text(
                correo.remitente[0].toUpperCase(),
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                correo.remitente,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              correo.asunto,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              _formatearFecha(correo.fecha),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            Divider(),
            Text(correo.cuerpo, style: TextStyle(fontSize: 15)),
          ],
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
