import 'package:core_ui/core_ui.dart';
import 'package:core_ui/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }

        if (state is RegistrationSuccess || state is LoginSuccessful) {
          UtilFunctions.showInSnackBar(
            context,
            (state is RegistrationSuccess)
                ? 'User Registration Successful'
                : 'Login successful',
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
                (route) => false,
          );
        }
        if (state is LoginError) {
          _showError(state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Valsco'),),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login with',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<LoginCubit>().googleSignIn();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.yellowAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/img.png'),
                        const Text('Google',style: TextStyle(fontSize: 18),)
                      ],
                    )),
              ),
            ],
          ),
        )

      ),
    );
  }
  void _showError(String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(
          error,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.cyan, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

