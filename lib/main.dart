import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahila_mitra/sign/sign_up/verify_email.dart';
import 'utils/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mahila_mitra/utils/theme.dart';
import 'package:mahila_mitra/home/home.dart';
import 'package:mahila_mitra/onboard/onboarding.dart';
import 'package:mahila_mitra/sign/sign_in/sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('onboarding_seen') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mahila Mitra',
      theme: MyTheme.theme(MyTheme.lightScheme()),
      darkTheme: MyTheme.theme(MyTheme.darkScheme()),
      home: AuthGate(seenOnboarding: seenOnboarding),
    );
  }
}

class AuthGate extends StatelessWidget {
  final bool seenOnboarding;

  const AuthGate({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (!seenOnboarding) {
          return const OnboardScreen();
        } else if (user == null) {
          // No user → go to SignIn
          return const SignInScreen();
        } else if (!user.emailVerified) {
          // User exists but not verified → go to VerifyEmail
          return const VerifyEmailScreen();
        } else {
          // Fully logged-in user → go to Home
          return const HomeScreen();
        }
      },
    );
  }
}
