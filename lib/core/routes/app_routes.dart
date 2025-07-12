import 'package:flutter/material.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';
import 'package:handycraft_app/core/models/supplier_model.dart';
import 'package:handycraft_app/screens/karyawan/karyawan_screen.dart';
import 'package:handycraft_app/screens/karyawan/add_karyawan_screen.dart';
import 'package:handycraft_app/screens/karyawan/add_honor_screen.dart';
import 'package:handycraft_app/screens/pelanggan/add_pelanggan_screen.dart';
import 'package:handycraft_app/screens/pelanggan/pelanggan_detail_screen.dart';
import 'package:handycraft_app/screens/pelanggan/pelanggan_screen.dart';
import 'package:handycraft_app/screens/product/add_bahan_screen.dart';
import 'package:handycraft_app/screens/product/add_product_screen.dart';
import 'package:handycraft_app/screens/product/product_screen.dart';
import 'package:handycraft_app/screens/supplier/add_supplier_screen.dart';
import 'package:handycraft_app/screens/supplier/supplier_detail_screen.dart';
import 'package:handycraft_app/screens/supplier/supplier_screen.dart';
import 'package:handycraft_app/widgets/navbottom.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String product = '/product';
  static const String addBahan = '/product/add-bahan';
  static const String addProduct = '/product/add-product';
  static const String supplier = '/supplier';
  static const String addSupplier = '/supplier/add';
  static const String supplierDetail = '/supplier/detail';
  static const String pelanggan = '/pelanggan';
  static const String addPelanggan = '/pelanggan/add';
  static const String pelangganDetail = '/pelanggan/detail';
  static const String karyawan = '/karyawan';
  static const String addKaryawan = '/karyawan/add';
  static const String addHonor = '/karyawan/add-honor';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      case product:
        return MaterialPageRoute(builder: (_) => const ProductScreen());
      case addBahan:
        return MaterialPageRoute(builder: (_) => const AddBahanScreen());
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      case supplier:
        return MaterialPageRoute(builder: (_) => const SupplierScreen());
      case addSupplier:
        return MaterialPageRoute(builder: (_) => const AddSupplierScreen());
      case supplierDetail:
        final supplier = settings.arguments as Supplier;
        return MaterialPageRoute(
          builder: (_) => SupplierDetailScreen(supplier: supplier),
        );
      case pelanggan:
        return MaterialPageRoute(builder: (_) => const PelangganScreen());
      case addPelanggan:
        return MaterialPageRoute(builder: (_) => const AddPelangganScreen());
      case karyawan:
        return MaterialPageRoute(builder: (_) => const KaryawanScreen());
      case addKaryawan:
        return MaterialPageRoute(builder: (_) => const AddKaryawanScreen());
      case addHonor:
        return MaterialPageRoute(builder: (_) => const AddHonorScreen());
      case pelangganDetail:
        final pelanggan = settings.arguments as Pelanggan;
        return MaterialPageRoute(
          builder: (_) => PelangganDetailScreen(pelanggan: pelanggan),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
