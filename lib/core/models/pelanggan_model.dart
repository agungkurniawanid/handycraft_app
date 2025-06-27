class Pelanggan {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String description;

  const Pelanggan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      description: json['description'],
    );
  }
}