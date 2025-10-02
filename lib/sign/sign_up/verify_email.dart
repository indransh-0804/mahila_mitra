import 'package:mahila_mitra/sign/sign_up/user_entry.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _pollTimer;
  Timer? _resendCooldownTimer;
  int _resendCooldownSeconds = 0;
  bool _isSending = false;
  static const int _pollIntervalSeconds = 5;
  static const int _resendCooldownInitial = 30;

  User? get _user => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    if (_user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      });
      return;
    }

    if (_user!.emailVerified) {
      _onVerified();
    } else {
      _startPolling();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _resendCooldownTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: _pollIntervalSeconds),
          (_) => _checkEmailVerified(),
    );
  }

  Future<void> _checkEmailVerified() async {
    try {
      await _user?.reload();
      final reloaded = _auth.currentUser;
      if (reloaded != null && reloaded.emailVerified) {
        _pollTimer?.cancel();
        if (!mounted) return;
        AppSnackbar.show(context, "Email verified");
        _onVerified();
      }
    } catch (e) {}
  }

  void _onVerified() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UserEntryScreen()),
    );
  }

  Future<void> _sendVerificationEmail() async {
    final user = _user;
    if (user == null) return;

    if (_resendCooldownSeconds > 0) {
      AppSnackbar.show(context, 'Please wait $_resendCooldownSeconds s before resending.', isError: true);
      return;
    }

    try {
      setState(() => _isSending = true);
      await user.sendEmailVerification();
      _startResendCooldown();

      if (!mounted) return;
      AppSnackbar.show(context,'Verification email sent. Check inbox or spam.');
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'too-many-requests' => 'Too many requests. Try again later.',
        _ => 'Failed to send verification email. Try again.',
      };
      if (mounted) {
        AppSnackbar.show(context,message, isError: true);
      }
    } catch (e) {
      if (mounted) {
          AppSnackbar.show(context, 'Unexpected error while sending verification.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _startResendCooldown() {
    _resendCooldownTimer?.cancel();
    _resendCooldownSeconds = _resendCooldownInitial;
    setState(() {});

    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _resendCooldownSeconds -= 1);
      if (_resendCooldownSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  Future<void> _manualCheckNow() async {
    await _checkEmailVerified();
    if (mounted) {
        AppSnackbar.show(context, 'Checked verification status.');
    }
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userEmail = _user?.email ?? 'your email';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.surfaceDim, colorScheme.onPrimary.withValues( alpha: 0.7)],
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
                "Verify Yourself!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 104),
              Text(
                "We sent a verification link to:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 6),
              Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Open your email and click the verification link. If it landed in spam, mark it Not spam or add the sender to your contacts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 104),
              Text(
                "Still didn't get the email?",
                style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (_isSending || _resendCooldownSeconds > 0) ? null : _sendVerificationEmail,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: colorScheme.primary
                  ),
                  child: _isSending
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(
                    _resendCooldownSeconds > 0 ? 'Resend Email in $_resendCooldownSeconds s' : 'Resend Email',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _manualCheckNow,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Already Verified"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
