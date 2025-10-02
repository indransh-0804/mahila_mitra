import 'package:flutter/material.dart';
import 'package:mahila_mitra/sign/sign_up/med_info.dart';
import 'package:mahila_mitra/utils/firebase_service.dart';
import 'package:mahila_mitra/utils/form_validator.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';

class UserEntryScreen extends StatefulWidget {
  const UserEntryScreen({super.key});

  @override
  State<UserEntryScreen> createState() => _UserEntryScreenState();
}

class _UserEntryScreenState extends State<UserEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Save user info to Firestore
  Future<void> _saveUserData() async {
    await FirebaseServices.saveUserInfo(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: selectedGender ?? "",
      dob: selectedDate,
    );
  }

  void _continue() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dobError = FormValidators.dob(selectedDate);
      if (dobError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dobError)),
        );
        return;
      }

      try {
        await _saveUserData();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MedInfoScreen()));
      } catch (e) {
        AppSnackbar.show(context, "ERROR: ${e.toString()}", isError: true);
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
            colors: [colorScheme.surface, colorScheme.onPrimary.withValues(alpha: 0.7)],
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
                    "Almost There!",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text("Tell us about yourself", style: TextStyle(color: colorScheme.onSurfaceVariant)),

                  const SizedBox(height: 48),

                  TextFormField(
                    controller: _firstNameController,
                    validator: FormValidators.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: 'First Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _lastNameController,
                    validator: FormValidators.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: 'Last Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.wc),
                      labelText: 'Gender (optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    value: selectedGender,
                    items: ['Male', 'Female', 'Other', 'Prefer not to Say']
                        .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedGender = value),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: selectedDate == null
                          ? ''
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    validator: (_) => FormValidators.dob(selectedDate),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _continue,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
