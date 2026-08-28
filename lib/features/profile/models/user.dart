class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final String complement;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.complement,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? complement,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      complement: complement ?? this.complement,
    );
  }
}