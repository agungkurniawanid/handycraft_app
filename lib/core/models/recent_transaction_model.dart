class RecentTransactionModel {
  final String id;
  final String tipe;
  final String deskripsi;
  final num jumlah;
  final int timestamp;

  RecentTransactionModel({
    required this.id,
    required this.tipe,
    required this.deskripsi,
    required this.jumlah,
    required this.timestamp,
  });
}
