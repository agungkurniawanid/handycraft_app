import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/settings_model.dart';
import 'package:iconsax/iconsax.dart';

final settingsModelListProvider = FutureProvider<List<SettingsModel>>((
  ref,
) async {
  return [
    SettingsModel(
      id: '1',
      name: 'Atur Sandi PIN',
      icon: Iconsax.lock_1,
      description:
          'Kelola PIN Anda untuk mengaktifkan, nonaktifkan, atau atur ulang dengan mudah.',
    ),
  ];
});
