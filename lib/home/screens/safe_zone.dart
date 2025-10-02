import 'package:flutter/material.dart';

class SafeZoneScreen extends StatelessWidget {
  const SafeZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 32),
            const Text(
              "Police Stations",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: const [
                    _InfoRow(
                        icon: Icons.local_police_outlined,
                        label: "Varachha Police Station",
                        distance: "7 km"),
                    _InfoRow(
                        icon: Icons.local_police_outlined,
                        label: "Podar Police Station",
                        distance: "4 km"),
                    _InfoRow(
                        icon: Icons.local_police_outlined,
                        label: "Kapodara Police Station",
                        distance: "12 km"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Hospitals",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: const [
                    _InfoRow(
                        icon: Icons.local_hospital_outlined,
                        label: "Apollo Hospital",
                        distance: "3 km"),
                    _InfoRow(
                        icon: Icons.local_hospital_outlined,
                        label: "Citi Hospital",
                        distance: "5 km"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String distance;

  const _InfoRow(
      {required this.icon, required this.label, required this.distance});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: colorScheme.onSurface),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
              color: colorScheme.onSurface),
            ),
          ),
          Text(distance, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
