import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // App logo or icon placeholder
            CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.phone_iphone, size: 50, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 24),

            Text(
              "Mahila Mitra",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              "Your trusted companion in times of emergency.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Text(
                      "About Mahila Mitra",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Mahila Mitra is designed to empower women by providing quick access to help during emergencies. "
                          "The app enables live location sharing, automated SOS messages, safe area identification, and "
                          "direct connections to first responders. It also offers a virtual friend for comfort and support. "
                          "Our goal is to make safety more accessible, reliable, and immediate.",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              onTap: () {
                // TODO: link to privacy policy page
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Terms of Service"),
              onTap: () {
                // TODO: link to terms page
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("App Version"),
              subtitle: const Text("0.1.0"),
            ),
          ],
        ),
      ),
    );
  }
}
