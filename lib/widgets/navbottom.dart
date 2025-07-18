import 'package:flutter/material.dart';
import 'package:handycraft_app/screens/dashboard/dashboard_screen.dart';
import 'package:handycraft_app/screens/karyawan/karyawan_screen.dart';
import 'package:handycraft_app/screens/pelanggan/pelanggan_screen.dart';
import 'package:handycraft_app/screens/product/product_screen.dart';
import 'package:handycraft_app/screens/supplier/supplier_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style7,
    );
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardScreen(),
      const ProductScreen(),
      const SupplierScreen(),
      const PelangganScreen(),
      const KaryawanScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.home),
        title: "Dashboard",
        activeColorPrimary: Colors.orange,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.box),
        title: "Produk",
        activeColorPrimary: Colors.orange,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.shop),
        title: "Supplier",
        activeColorPrimary: Colors.orange,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.profile_2user),
        title: "Pelanggan",
        activeColorPrimary: Colors.orange,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.people),
        title: "Karyawan",
        activeColorPrimary: Colors.orange,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}