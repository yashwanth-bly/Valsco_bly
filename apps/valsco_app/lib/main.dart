import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';

  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider<SplashCubit>(
        create: (context) => SplashCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: GlobalLoaderOverlay(
          overlayOpacity: 0.5,
          overlayColor: Colors.brown.withOpacity(0.5),
          useDefaultLoading: false,
          overlayWidget: const Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: MaterialApp(
            title: 'Valsco',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              primaryColor: Colors.blueGrey,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                color: Colors.white70,
              ),
            ),
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
