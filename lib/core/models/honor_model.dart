import 'package:firebase_database/firebase_database.dart';

class Honor {
  final String id;
  final String jenisPekerjaan;
  final double gaji;
  final String satuan;
  final String statusKaryawan;

  Honor({
    required this.id,
    required this.jenisPekerjaan,
    required this.gaji,
    required this.satuan,
    required this.statusKaryawan,
  });

  factory Honor.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Honor(
      id: snapshot.key ?? '',
      jenisPekerjaan: data['jenisPekerjaan'] as String,
      gaji: (data['gaji'] as num).toDouble(),
      satuan: data['satuan'] as String,
      statusKaryawan: data['statusKaryawan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jenisPekerjaan': jenisPekerjaan,
      'gaji': gaji,
      'satuan': satuan,
      'statusKaryawan': statusKaryawan,
    };
  }
}

extension HonorExtension on Honor {
  Honor copyWith({
    String? id,
    String? jenisPekerjaan,
    double? gaji,
    String? satuan,
    String? statusKaryawan,
  }) {
    return Honor(
      id: id ?? this.id,
      jenisPekerjaan: jenisPekerjaan ?? this.jenisPekerjaan,
      gaji: gaji ?? this.gaji,
      satuan: satuan ?? this.satuan,
      statusKaryawan: statusKaryawan ?? this.statusKaryawan,
    );
  }
}