import 'package:mahila_mitra/sign/sign_up/credentials.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahila_mitra/utils/firebase_service.dart';
import 'package:mahila_mitra/utils/form_validator.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';
import 'package:mahila_mitra/home/home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final emailError = FormValidators.email(_emailController.text.trim());
    final passwordError = FormValidators.password(_passwordController.text.trim());

    if (emailError != null) {
      AppSnackbar.show(context, emailError, isError: true);
      return;
    }
    if (passwordError != null) {
      AppSnackbar.show(context, passwordError, isError: true);
      return;
    }

    try {
      final user = await FirebaseServices.signIn(
          email: _emailController.text,
          password: _passwordController.text
      );

      if (user != null) {
        AppSnackbar.show(context, "Login Successful!");
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (_) => const HomeScreen()
            )
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          AppSnackbar.show(context, "No user found with that email.", isError: true);
          break;
        case 'wrong-password':
          AppSnackbar.show(context, "Wrong password.", isError: true);
          break;
        case 'invalid-credential':
          AppSnackbar.show(context, "Invalid credentials. Please try again.", isError: true);
          break;
        default:
          AppSnackbar.show(context, e.message ?? "Something went wrong.", isError: true);
      }
    } catch (_) {
      AppSnackbar.show(context, "An unexpected error occurred.", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.surface, colorScheme.onPrimary.withValues(alpha: 0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 120),
              Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Enter your credentials to continue",
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Form Fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _emailController,
                        validator: FormValidators.email,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _emailController.clear(),
                          ),
                          labelText: 'Email',
                          hintText: 'ramesh@email.com',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          helperText: 'Only enter a working email id',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _passwordController,
                        validator: FormValidators.password,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          labelText: 'Password',
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          helperText: 'Password should be 8 characters',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 24,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      AppSnackbar.show(context, "Unavailable", isError: true);
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12),
                      ),
                      minimumSize: const WidgetStatePropertyAll(Size.zero),
                    ),
                    child: Text(
                      "Forgot your Password?",
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handleSignIn,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Divider(color: colorScheme.onSurface),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "or",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: colorScheme.onSurface),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    AppSnackbar.show(context, "Unavailable", isError: true);
                  },
                  child: const Text("Continue with Google"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
