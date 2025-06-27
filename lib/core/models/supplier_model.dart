class Supplier {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String description;

  const Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      description: json['description'],
    );
  }
}