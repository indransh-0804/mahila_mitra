import 'package:flutter/material.dart';
import 'package:mahila_mitra/home/home.dart';
import 'package:mahila_mitra/utils/firebase_service.dart';
import 'package:mahila_mitra/utils/form_validator.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';

class MedInfoScreen extends StatefulWidget {
  const MedInfoScreen({super.key});

  @override
  State<MedInfoScreen> createState() => _MedInfoScreenState();
}

class _MedInfoScreenState extends State<MedInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _personalContactController =
  TextEditingController();
  final TextEditingController _emergencyContactController =
  TextEditingController();
  final TextEditingController _areaCodeController = TextEditingController();

  String? selectedBloodGroup;

  @override
  void dispose() {
    _personalContactController.dispose();
    _emergencyContactController.dispose();
    _areaCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    await FirebaseServices.saveMedInfo(
      personalContact: _personalContactController.text.trim(),
      emergencyContact: _emergencyContactController.text.trim(),
      bloodGroup: selectedBloodGroup ?? "",
      areaCode: _areaCodeController.text.trim(),
    );
  }
  void _handleSignin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _saveUserData();
        AppSnackbar.show(context, "Profile Saved");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } catch (e) {
        AppSnackbar.show(context, "Error: ${e.toString()}");
      }
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
            colors: [
              colorScheme.surface,
              colorScheme.onPrimary.withValues(alpha: 0.7)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Emergency Information!",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Information that might be needed during emergency",
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),

                  const SizedBox(height: 48),

                  // Personal Contact
                  TextFormField(
                    controller: _personalContactController,
                    validator: FormValidators.contact,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      labelText: 'Personal Contact',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Emergency Contact
                  TextFormField(
                    controller: _emergencyContactController,
                    validator: FormValidators.contact,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: 'Emergency Contact',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Blood Group
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.bloodtype),
                      labelText: 'Blood Group',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value: selectedBloodGroup,
                    items: [
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-'
                    ]
                        .map((bg) => DropdownMenuItem(
                      value: bg,
                      child: Text(bg),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedBloodGroup = value),
                    validator: FormValidators.bloodGroup,
                  ),
                  const SizedBox(height: 12),

                  // Area Code
                  TextFormField(
                    controller: _areaCodeController,
                    validator: FormValidators.areaCode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      labelText: 'Area Code',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _handleSignin,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Sign In",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
