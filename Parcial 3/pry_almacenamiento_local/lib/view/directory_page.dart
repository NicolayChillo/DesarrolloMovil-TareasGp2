import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodel/contacto_viewmodel.dart';
import '../core/widgets/custom_app_bar.dart';
import '../model/contacto_model.dart';
import '../viewmodel/theme_viewmodel.dart';
import '../viewmodel/pin_viewmodel.dart';
import 'pin_page.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = context.read<ContactViewModel>();
      if (viewModel.contactCount == 0) viewModel.loadContacts();
    });
    _searchController.addListener(() {
      context.read<ContactViewModel>().searchContacts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Directorio (${viewModel.contactCount})',
        actions: [
          IconButton(
            icon: Icon(themeViewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeViewModel.toggleTheme();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    themeViewModel.isDarkMode
                        ? 'Modo oscuro activado'
                        : 'Modo claro activado',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Cambiar tema',
          ),
          // Botón de logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<PinViewModel>().clearPin();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PinPage()),
              );
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar contacto...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    viewModel.clearSearch();
                  },
                )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
              ),
              onChanged: (value) => viewModel.searchContacts(value),
            ),
          ),
          Expanded(
            child: viewModel.contacts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contacts_outlined,
                    size: 80,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.searchQuery.isNotEmpty
                        ? 'No se encontraron resultados'
                        : 'No hay contactos guardados',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: viewModel.contacts.length,
              itemBuilder: (context, index) {
                final contact = viewModel.contacts[index];
                return _buildContactTile(contact, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(ContactModel contact, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📱 ${contact.phone}'),
            Text('📧 ${contact.email}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de llamada (teléfono)
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _makePhoneCall(contact.phone),
              tooltip: 'Llamar',
            ),
          ],
        ),
      ),
    );
  }

  // Método para realizar la llamada
  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número inválido')),
      );
      return;
    }

    // Solicitar permiso si no está concedido
    final status = await Permission.phone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de llamada denegado: $status')),
      );
      return;
    }

    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);
    try {
      // Intentar lanzar sin verificar canLaunch (para algunos dispositivos)
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Si falla, mostrar mensaje con el error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se puede llamar: ${e.toString()}')),
      );
    }
  }
}