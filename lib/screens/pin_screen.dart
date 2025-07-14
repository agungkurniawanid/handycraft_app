import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/widgets/navbottom.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final String _correctPin = "123456";
  String _enteredPin = "";
  bool _isError = false;
  bool _isLoading = false;

  void _onNumberPressed(String number) {
    if (_enteredPin.length < 6) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin += number;
        _isError = false;
      });

      if (_enteredPin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    if (_enteredPin == _correctPin) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainNavigation(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _isError = true;
        _enteredPin = "";
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = isDarkMode
        ? Colors.grey.shade900
        : Colors.grey.shade50;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Hero(
                  tag: 'app-logo',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Iconsax.lock, size: 36, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'HandyCraft',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keuangan UMKM Perkayuan',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      'Masukkan PIN Anda',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(6, (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    width: _enteredPin.length > index ? 20 : 16,
                                    height: _enteredPin.length > index
                                        ? 20
                                        : 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _enteredPin.length > index
                                          ? _isError
                                                ? Colors.red.shade400
                                                : primaryColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: _isError
                                            ? Colors.red.shade400
                                            : theme.colorScheme.onSurface
                                                  .withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: _enteredPin.length > index
                                        ? Icon(
                                            Icons.circle,
                                            size: 12,
                                            color: Colors.white,
                                          )
                                        : null,
                                  );
                                }),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isError
                          ? Text(
                              'PIN tidak sesuai',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.red.shade400,
                              ),
                            )
                          : const SizedBox(height: 20),
                    ),
                  ],
                ),

                const Spacer(),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    for (int i = 1; i <= 9; i++)
                      _PinNumberButton(
                        number: i.toString(),
                        onPressed: _onNumberPressed,
                        primaryColor: primaryColor,
                      ),
                    const SizedBox.shrink(),
                    _PinNumberButton(
                      number: "0",
                      onPressed: _onNumberPressed,
                      primaryColor: primaryColor,
                    ),
                    _PinBackButton(
                      onPressed: _onBackspacePressed,
                      isActive: _enteredPin.isNotEmpty && !_isLoading,
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinNumberButton extends StatelessWidget {
  final String number;
  final Function(String) onPressed;
  final Color primaryColor;

  const _PinNumberButton({
    required this.number,
    required this.onPressed,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => onPressed(number),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const _PinBackButton({required this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: isActive ? onPressed : null,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: Icon(
              Iconsax.back_square,
              size: 24,
              color: isActive
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}
