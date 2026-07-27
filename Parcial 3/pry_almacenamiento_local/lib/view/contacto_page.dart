import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/contacto_viewmodel.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_text.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_styles.dart';
import '../model/contacto_model.dart';
import '../viewmodel/pin_viewmodel.dart';
import '../viewmodel/theme_viewmodel.dart';
import 'pin_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ContactViewModel>().loadContacts());
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // SnackBar para mensajes de operación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.operationMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.operationMessage,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            backgroundColor: viewModel.isSuccess ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: viewModel.clearMessage,
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), viewModel.clearMessage);
      }
    });

    return Scaffold(
      // En el appBar, agrega los botones de tema y logout al final
      appBar: CustomAppBar(
        title: 'Contactos (${viewModel.contactCount})',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showContactDialog(context, viewModel),
            tooltip: 'Agregar contacto',
          ),
          // Botón de tema
          IconButton(
            icon: Icon(context.watch<ThemeViewModel>().isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              final themeViewModel = context.read<ThemeViewModel>();
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
                hintText: 'Buscar por nombre, teléfono o email',
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
                  CustomText(
                    text: viewModel.searchQuery.isNotEmpty
                        ? 'No se encontraron resultados'
                        : 'No hay contactos guardados',
                    style: AppStyles.subtitle,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: viewModel.searchQuery.isNotEmpty
                        ? 'Prueba con otra búsqueda'
                        : 'Presiona el botón + para agregar uno',
                    style: AppStyles.body.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: viewModel.contacts.length,
              itemBuilder: (context, index) {
                final contact = viewModel.contacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showContactDialog(context, viewModel, contact: contact),
                          tooltip: 'Editar contacto',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, viewModel, contact),
                          tooltip: 'Eliminar contacto',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(
      BuildContext context,
      ContactViewModel viewModel, {
        ContactModel? contact,
      }) {
    final isEditing = contact != null;
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');
    final emailController = TextEditingController(text: contact?.email ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isEditing ? Icons.edit : Icons.person_add,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(isEditing ? 'Editar contacto' : 'Nuevo contacto'),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre *',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      helperText: 'Mínimo 3 letras, solo texto',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      final trimmed = value.trim();
                      if (trimmed.length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      // Solo letras (incluyendo tildes y ñ) y espacios
                      final RegExp nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
                      if (!nameRegex.hasMatch(trimmed)) {
                        return 'Solo letras y espacios (sin números ni signos)';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Remover automáticamente caracteres no permitidos
                      final filtered = value.replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'), '');
                      if (value != filtered) {
                        nameController.value = TextEditingValue(
                          text: filtered,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: filtered.length),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono *',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      helperText: 'Ej: 0981725455 o (02)2387097',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El teléfono es obligatorio';
                      }
                      final trimmed = value.trim();
                      // Eliminar espacios, paréntesis y guiones para validar
                      final clean = trimmed.replaceAll(RegExp(r'[\s()\-]'), '');

                      // Validar celular: 10 dígitos empezando con 09
                      final RegExp cellRegex = RegExp(r'^09\d{8}$');
                      // Validar convencional: 9 dígitos (ej: 022387097) o 10 con prefijo 02
                      final RegExp phoneRegex = RegExp(r'^02\d{7}$|^0\d{9}$');

                      if (!cellRegex.hasMatch(clean) && !phoneRegex.hasMatch(clean)) {
                        return 'Teléfono inválido. Usa 10 dígitos (celular 09...) o (02)......';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Formatear automáticamente para mejor experiencia
                      String filtered = value.replaceAll(RegExp(r'[^0-9()\-]'), '');
                      if (value != filtered) {
                        phoneController.value = TextEditingValue(
                          text: filtered,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: filtered.length),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo *',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      helperText: 'ejemplo@dominio.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El correo es obligatorio';
                      }
                      final trimmed = value.trim();
                      // Regex estándar para correo electrónico
                      final RegExp emailRegex = RegExp(
                          r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
                      );
                      if (!emailRegex.hasMatch(trimmed)) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                viewModel.clearMessage();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newContact = ContactModel(
                    id: isEditing
                        ? contact!.id
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    phone: _formatPhone(phoneController.text.trim()),
                    email: emailController.text.trim(),
                  );

                  bool success;
                  if (isEditing) {
                    success = await viewModel.updateContact(newContact);
                  } else {
                    success = await viewModel.addContact(newContact);
                  }

                  if (success) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      ContactViewModel viewModel,
      ContactModel contact,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar contacto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de eliminar este contacto?'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('👤 ${contact.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('📱 ${contact.phone}'),
                    Text('📧 ${contact.email}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                viewModel.clearMessage();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await viewModel.deleteContact(contact.id);
                if (success) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
  String _formatPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[\s()\-]'), '');
    if (clean.startsWith('09')) {
      return clean; // Celular: 0981725455
    } else {
      // Convencional: (02)2387097
      if (clean.startsWith('02') && clean.length == 10) {
        return '(${clean.substring(0, 2)})${clean.substring(2)}';
      }
      return clean;
    }
  }
}