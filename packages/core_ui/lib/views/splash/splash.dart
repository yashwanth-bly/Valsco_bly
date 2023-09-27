import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        bloc: context.read<SplashCubit>()..load(),
        listener: (context, state) {
          if (state is SplashNavigateToLogin) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => LoginCubit(
                      authRepository: context.read<AuthRepository>(),
                    ),
                    child: const LoginScreen(),
                  ),
                ),
                (route) => false);
          }
          if (state is SplashNavigateToHome) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
                (route) => false);
          }
        },
        child: const Center(
          child: Text(
            'Valsco\nby\nYashwanth',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
