// presentation/screens/admin_mascotas_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../core/constants/api_constants.dart';
import '../providers/mascotas_provider.dart';
import '../../domain/entities/mascota.dart';

class AdminMascotasScreen extends StatefulWidget {
  const AdminMascotasScreen({super.key});

  @override
  State<AdminMascotasScreen> createState() => _AdminMascotasScreenState();
}

class _AdminMascotasScreenState extends State<AdminMascotasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MascotasProvider>().cargarTodasLasMascotas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administrar Mascotas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Disponibles'),
              Tab(text: 'Adoptadas'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _mostrarFormularioCrear(context),
            ),
          ],
        ),
        body: Consumer<MascotasProvider>(
          builder: (context, provider, _) {
            if (provider.estadoCarga == EstadoCarga.cargando) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.estadoCarga == EstadoCarga.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(provider.errorMessage ?? 'Error al cargar'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.cargarTodasLasMascotas(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (provider.mascotas.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No hay mascotas registradas'),
                  ],
                ),
              );
            }

            return TabBarView(
              children: [
                _buildMascotaList(provider.mascotas),
                _buildMascotaList(
                  provider.mascotas.where((m) => m.estado == 'Disponible').toList(),
                ),
                _buildMascotaList(
                  provider.mascotas.where((m) => m.estado == 'Adoptada').toList(),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _mostrarFormularioCrear(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMascotaList(List<Mascota> mascotas) {
    if (mascotas.isEmpty) {
      return const Center(
        child: Text('No hay mascotas en esta categoría'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<MascotasProvider>().cargarTodasLasMascotas(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mascotas.length,
        itemBuilder: (context, index) {
          final mascota = mascotas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 2,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: mascota.imagenUrl != null
                    ? Image.network(
                        mascota.imagenUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 40),
                      )
                    : const Icon(Icons.pets, size: 40),
              ),
              title: Text(mascota.nombre),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mascota.especie),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: mascota.estado == 'Disponible' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mascota.estado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _mostrarFormularioEditar(context, mascota),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarEliminar(context, mascota.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _mostrarFormularioCrear(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const _MascotaForm(isEditing: false),
        ),
      ),
    );
  }

  void _mostrarFormularioEditar(BuildContext context, Mascota mascota) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _MascotaForm(
            isEditing: true,
            mascota: mascota,
          ),
        ),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, int id) async {
    // ✅ Diálogo de confirmación
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Text('Eliminar mascota'),
          ],
        ),
        content: const Text('¿Estás seguro de que deseas eliminar esta mascota? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      print('🗑️ Intentando eliminar mascota ID: $id');
      
      final provider = context.read<MascotasProvider>();
      final success = await provider.eliminarMascota(id);
      
      print('📥 Resultado: $success');
      
      // ✅ Verificar que el widget sigue montado
      if (!mounted) return;
      
      // ✅ Mostrar mensaje según el resultado
      if (success) {
        // ✅ Mensaje de éxito con SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text('✅ Mascota eliminada correctamente'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // ✅ Recargar la lista
        provider.cargarTodasLasMascotas();
        
      } else {
        // ❌ Mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text('❌ Error: ${provider.errorMessage ?? "No se pudo eliminar"}'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      
    } catch (e) {
      print('❌ Error al eliminar: $e');
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('❌ Error: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ============================================================
// FORMULARIO PARA CREAR/EDITAR MASCOTA
// ============================================================

class _MascotaForm extends StatefulWidget {
  final bool isEditing;
  final Mascota? mascota;

  const _MascotaForm({
    required this.isEditing,
    this.mascota,
  });

  @override
  State<_MascotaForm> createState() => _MascotaFormState();
}

class _MascotaFormState extends State<_MascotaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _especieController = TextEditingController();
  final _razaController = TextEditingController();
  final _sexoController = TextEditingController();
  final _edadController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? _imagen;
  String _estado = 'Disponible';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.mascota != null) {
      _nombreController.text = widget.mascota!.nombre;
      _especieController.text = widget.mascota!.especie;
      _razaController.text = widget.mascota!.raza ?? '';
      _sexoController.text = widget.mascota!.sexo ?? '';
      _edadController.text = widget.mascota!.edad?.toString() ?? '';
      _descripcionController.text = widget.mascota!.descripcion ?? '';
      _estado = widget.mascota!.estado;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _sexoController.dispose();
    _edadController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagen = File(picked.path));
    }
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<MascotasProvider>();
    bool success = false;

    try {
      if (widget.isEditing) {
        success = await provider.actualizarMascota(
          id: widget.mascota!.id,
          nombre: _nombreController.text.trim(),
          especie: _especieController.text.trim(),
          raza: _razaController.text.trim().isEmpty ? null : _razaController.text.trim(),
          sexo: _sexoController.text.trim().isEmpty ? null : _sexoController.text.trim(),
          edad: int.tryParse(_edadController.text.trim()),
          descripcion: _descripcionController.text.trim(),
          estado: _estado,
          imagen: _imagen,
        );
      } else {
        success = await provider.crearMascota(
          nombre: _nombreController.text.trim(),
          especie: _especieController.text.trim(),
          raza: _razaController.text.trim().isEmpty ? null : _razaController.text.trim(),
          sexo: _sexoController.text.trim().isEmpty ? null : _sexoController.text.trim(),
          edad: int.tryParse(_edadController.text.trim()) ?? 0,
          descripcion: _descripcionController.text.trim(),
          imagen: _imagen,
        );
      }

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.pop(context);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Mascota guardada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          provider.cargarTodasLasMascotas();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error al guardar: ${provider.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmarEliminar(BuildContext context, int id) async {
    // ✅ Diálogo de confirmación simple
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar mascota?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final provider = context.read<MascotasProvider>();
      final success = await provider.eliminarMascota(id);
      
      // ✅ Verificar mounted ANTES de mostrar cualquier cosa
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Mascota eliminada correctamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        provider.cargarTodasLasMascotas();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${provider.errorMessage}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // ✅ Verificar mounted ANTES de mostrar error
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditing ? 'Editar Mascota' : 'Nueva Mascota',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Imagen
              GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imagen != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_imagen!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey,
                              ),
                              Text(
                                widget.isEditing ? 'Cambiar imagen' : 'Seleccionar imagen',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _especieController,
                decoration: const InputDecoration(
                  labelText: 'Especie *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _razaController,
                decoration: const InputDecoration(
                  labelText: 'Raza (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
              const SizedBox(height: 8),
              
              // ✅ Corregido: Reemplazar Icons.male_female por Icons.person
              TextFormField(
                controller: _sexoController,
                decoration: const InputDecoration(
                  labelText: 'Sexo (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Requerido';
                  if (int.tryParse(v!) == null) return 'Número válido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<String>(
                value: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info),
                ),
                items: ['Disponible', 'Adoptada'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (v) => setState(() => _estado = v!),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Guardar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}