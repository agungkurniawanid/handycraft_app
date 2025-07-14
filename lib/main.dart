import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/constants/app_constant.dart';
import 'package:handycraft_app/core/providers/theme_provider.dart';
import 'package:handycraft_app/core/routes/app_routes.dart';
import 'package:handycraft_app/screens/splash_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handycraft_app/firebase_options.dart' hide Firebase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Firebase Apps: ${Firebase.apps}");
  await Firebase.initializeApp(
    name: 'MyAppInstance',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Firebase Apps: ${Firebase.apps}");

  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 600, name: 'MOBILE_SMALL'),
          const Breakpoint(start: 600, end: 768, name: 'MOBILE_LARGE'),
          const Breakpoint(start: 768, end: 1024, name: 'TABLET'),
          const Breakpoint(start: 1024, end: 1280, name: 'LAPTOP_SMALL'),
          const Breakpoint(start: 1280, end: 1536, name: 'LAPTOP_MEDIUM'),
          const Breakpoint(start: 1536, end: 1920, name: 'LAPTOP_LARGE'),
          const Breakpoint(start: 1920, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: theme,
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
