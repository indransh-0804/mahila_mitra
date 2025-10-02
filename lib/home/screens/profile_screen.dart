import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("Not signed in")),
      );
    }
    
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("No profile data found"));
              }

              final data = snapshot.data!.data() ?? {};
              final firstName = data["firstName"] ?? "";
              final lastName = data["lastName"] ?? "";
              final email = data["email"] ?? "";
              final gender = data["gender"] ?? "";
              final dob = data["dob"] ?? "";
              final bloodGroup = data["bloodGroup"] ?? "";
              final personalContact = data["personalContact"] ?? "";
              final emergencyContact = data["emergencyContact"] ?? "";
              final areaCode = data["areaCode"] ?? "";

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .tertiaryContainer,
                      child: Text(
                        firstName.isNotEmpty
                            ? firstName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "$firstName $lastName",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                    const SizedBox(height: 8),

                    Text(email, style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium),
                    const SizedBox(height: 24),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _infoRow(Icons.wc, "Gender", gender),
                            _infoRow(Icons.calendar_today, "Date of Birth", dob),
                            _infoRow(Icons.bloodtype, "Blood Group", bloodGroup),
                            _infoRow(Icons.phone, "Personal Contact", personalContact),
                            _infoRow(Icons.contact_phone, "Emergency Contact", emergencyContact),
                            _infoRow(Icons.location_city, "Area Code", areaCode)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        )
    );
  }
}

Widget _infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value.isNotEmpty ? value : "Not provided"),
            ],
          ),
        ),
      ],
    ),
  );
}
