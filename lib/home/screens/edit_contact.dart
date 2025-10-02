import 'package:mahila_mitra/utils/form_validator.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key});

  @override
  State<EditContactScreen> createState() =>
      _EditContactScreenState();
}

class _EditContactScreenState
    extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentContact();
  }

  Future<void> _loadCurrentContact() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc =
      await _firestore.collection('users').doc(uid).get();
      final contact = doc.data()?['emergencyContact'] as String?;
      if (contact != null) {
        _contactController.text = contact;
      }
    } catch (e) {}
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('users').doc(uid).update({
        'emergencyContact': _contactController.text.trim(),
      });

      if (mounted) {
        AppSnackbar.show(context, "Emergency contact updated!");
        Navigator.pop(context); // close screen after saving
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, "Error saving contact: $e");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 64),
              Text("Emergency Contact",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary
                ),
              ),
              const SizedBox(height: 48),
              Text("You can change the Emergency Contact from here. Just Enter below the new contact number",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16
              ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _contactController,
                  validator: FormValidators.contact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _contactController.clear(),
                    ),
                    labelText: 'Emergency Contact',
                    hintText: '',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    helperText: 'Dont add country code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                    onPressed: _isLoading ? null : _saveContact,
                    icon: Icon(Icons.edit),
                  label: Text("Modify Contact",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  ),),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
