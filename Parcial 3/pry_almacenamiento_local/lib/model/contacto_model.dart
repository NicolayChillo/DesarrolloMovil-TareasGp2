class ContactModel {
  String id;
  String name;
  String phone;
  String email;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  // Convertir a mapa para guardar en SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
  };

  // Crear desde mapa
  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
  );
}