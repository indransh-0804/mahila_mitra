import 'package:flutter/material.dart';
import 'package:mahila_mitra/widgets/cards.dart';
import 'package:url_launcher/url_launcher.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  _makePhoneCall(String phoneNumber) async {
    var url = Uri.parse("tel:$phoneNumber");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Emergency Assistance",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Cards(
                tag: "police",
                title: "Police Assistance",
                subtitle: "Call the nearest Police Station",
                height: 150,
                onTap: () {
                  _makePhoneCall("100");
                },
                gradientStartColor: Colors.indigoAccent,
                gradientEndColor: Colors.indigo,
                actions: const [
                  Icon(Icons.call, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.local_police, color: Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              Cards(
                tag: "hotline",
                title: "Woman Hotline",
                subtitle: "Call the national Woman Hotline",
                height: 150,
                onTap: () {
                  _makePhoneCall("1091");
                },
                gradientStartColor: Colors.purpleAccent,
                gradientEndColor: Colors.purple,
                actions: const [
                  Icon(Icons.call, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.woman, color: Colors.white), // updated icon
                ],
              ),
              const SizedBox(height: 16),
              Cards(
                tag: "medical",
                title: "Medical Assistance",
                subtitle: "Call an Ambulance",
                height: 150,
                onTap: () {
                  _makePhoneCall("102");
                },
                gradientStartColor: Colors.tealAccent,
                gradientEndColor: Colors.teal,
                actions: const [
                  Icon(Icons.call, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.local_hospital, color: Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              Cards(
                tag: "fire",
                title: "Fire Assistance",
                subtitle: "Call the nearest Fire Station",
                height: 150,
                onTap: () {
                  _makePhoneCall("101");
                },
                gradientStartColor: Colors.deepOrangeAccent,
                gradientEndColor: Colors.deepOrange,
                actions: const [
                  Icon(Icons.call, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.local_fire_department, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
