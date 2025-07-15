import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';

final List<PenerimaanModel> dummyPenerimaan = [
  PenerimaanModel(
    id: '1',
    tanggal: '2023-10-01',
    transaksi: 'Penjualan Produk A',
    pelanggan: 'Toko Maju',
    kuantitas: 10,
    satuan: 'pcs',
    hargaSatuan: 50000,
    total: 500000,
    keterangan: 'Pembayaran lunas',
  ),
];

final List<Pengeluaran> dummyPengeluaran = [
  Pengeluaran(
    id: '1',
    tanggal: '2023-10-02',
    transaksi: 'Pembelian Bahan Baku',
    supplierName: 'Supplier ABC',
    kuantitas: 20,
    satuan: 'kg',
    hargaSatuan: 25000,
    total: 500000,
    keterangan: 'Bahan baku utama',
  ),
];

final totalPenerimaan = dummyPenerimaan.fold(
  0,
  (sum, item) => sum + item.total.toInt(),
);
final totalPengeluaran = dummyPengeluaran.fold(
  0,
  (sum, item) => sum + item.total.toInt(),
);
