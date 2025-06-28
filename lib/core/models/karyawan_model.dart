class Karyawan {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String status;
  final String position;

  const Karyawan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    required this.position,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) {
    return Karyawan(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      position: json['position'],
    );
  }
}

class Honor {
  final String id;
  final String karyawanId;
  final String jenisPekerjaan;
  final double gaji;
  final String satuan;
  final String statusKaryawan;

  const Honor({
    required this.id,
    required this.karyawanId,
    required this.jenisPekerjaan,
    required this.gaji,
    required this.satuan,
    required this.statusKaryawan,
  });

  factory Honor.fromJson(Map<String, dynamic> json) {
    return Honor(
      id: json['id'],
      karyawanId: json['karyawanId'],
      jenisPekerjaan: json['jenisPekerjaan'],
      gaji: json['gaji'].toDouble(),
      satuan: json['satuan'],
      statusKaryawan: json['statusKaryawan'],
    );
  }
}