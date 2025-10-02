import 'package:mahila_mitra/home/screens/edit_contact.dart';
import 'package:mahila_mitra/sign/sign_in/sign_in.dart';
import 'package:mahila_mitra/sign/sign_up/credentials.dart';
import 'package:mahila_mitra/utils/firebase_service.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';
import 'package:mahila_mitra/home/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<void> _handleAuthAction({required bool delete}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    try {
      if (delete) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) await user.delete();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
              (route) => false,
        );
      } else {
        await FirebaseServices.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      AppSnackbar.show(context, "Error: ${e.toString()}", isError: true);
    }
  }

  Future<void> _signOutAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const SingleChildScrollView(
            child: Text('Are you sure you want to sign out?'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await _handleAuthAction(delete: false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccountAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const SingleChildScrollView(
            child: Text('Are you sure you want to delete your account?'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                await _handleAuthAction(delete: true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "About",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About Mahila Mitra"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          Text(
            "Safety",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.contact_phone),
                  title: const Text("Manage Emergency Contacts"),
                  subtitle: const Text("Add or edit your trusted contacts"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditContactScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Location Settings"),
                  subtitle: const Text("Enable live location sharing"),
                  onTap: () {
                    AppSnackbar.show(
                      context,
                      "Location settings screen unavailable!",
                      isError: true,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            "Account",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sign Out"),
                  onTap: _signOutAlert,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete Account"),
                  onTap: _deleteAccountAlert,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
