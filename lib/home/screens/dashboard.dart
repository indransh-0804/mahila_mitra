import 'package:mahila_mitra/home/screens/edit_contact.dart';
import 'package:mahila_mitra/home/screens/safe_zone.dart';
import 'package:mahila_mitra/utils/firebase_service.dart';
import 'package:mahila_mitra/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:mahila_mitra/home/screens/card_list.dart';
import 'package:mahila_mitra/widgets/small_cards.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mahila_mitra/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TwilioFlutter twilioFlutter;
  String firstName = '';
  String lastName ='';
  String emergencyContact ='';

  @override
  void initState() {
    super.initState();
    _loadUserData();

    twilioFlutter = TwilioFlutter(
        accountSid: dotenv.env['TWILIO_ACCOUNT_SID'] ?? '',
        authToken: dotenv.env['TWILIO_AUTH_TOKEN'] ?? '',
        twilioNumber: dotenv.env['TWILIO_PHONE'] ?? '',
    );
  }

  Future<void> _loadUserData() async {
    try {
      final data = await FirebaseServices.getUserData();
      if (data != null) {
        setState(() {
          firstName = data['firstName'] ?? '';
          lastName = data['lastName'] ?? '';
          emergencyContact = data['emergencyContact'] ?? '';
        });
      }
    } catch (e) {}
  }
  Future<Position> _getLiveLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission permanently denied';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Build SOS message with live coordinates
  Future<String> _buildSOSMessage() async {
    final pos = await _getLiveLocation();
    final locationUrl =
        "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";

    return "SOS ALERT\n"
        "I need immediate help!\n"
        "My location: $locationUrl\n"
        "Sent via Mahila Mitra.";
  }

  /// Send SOS via Twilio
  Future<void> sendSOS() async {
    final message = await _buildSOSMessage();
    twilioFlutter.sendSMS(
      toNumber: "$emergencyContact",
      messageBody: message,
    );
    AppSnackbar.show(context, "Sending SOS to $emergencyContact");
  }

  /// Launch Google Maps from small card
  Future<void> openGoogleMaps() async {
    final pos = await _getLiveLocation();
    final locationUrl =
        "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";
    final uri = Uri.parse(locationUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16, top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome !",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$firstName $lastName",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      child: Text(
                        firstName.isNotEmpty
                            ? firstName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(padding: EdgeInsets.symmetric(horizontal: 24),
                child: Cards(
                  title: "Emergency Assistance",
                  height: 125,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CardScreen(),
                      ),
                    );
                  },
                  gradientStartColor: Color(0xff30cfd0),
                  gradientEndColor: Color(0xff330867),

                  actions: [
                    Icon(Icons.call, color: Colors.white),
                    SizedBox(width: 12),
                    Icon(Icons.local_police, color: Colors.white),
                    SizedBox(width: 12,),
                    Icon(Icons.local_hospital, color: Colors.white),
                    SizedBox(width: 12),
                    Icon(Icons.local_fire_department, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Text(
                  "Trigger SOS by double tab",
                  style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: GestureDetector(
                  onDoubleTap: () => sendSOS(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.redAccent, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Icon(
                          Icons.sos,
                          size: 48,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: colorScheme.onSurface),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Quick Actions",
                        style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 24),
                  child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisExtent:  112,
                      mainAxisSpacing: 16
                  ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SmallCard(
                        onTap: () => openGoogleMaps(),
                        icon: Icon(Icons.location_on),
                        title: "Live\n""Location",
                      ),
                      SmallCard(
                        onTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditContactScreen()));
                        },
                        icon: Icon(Icons.phone),
                        title: "Edit\n""Contact",
                        bgcolor: Colors.indigo,
                        ),
                      SmallCard(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SafeZoneScreen()));
                        },
                        icon: Icon(Icons.map),
                        title: "Nearby\n""Safe Zones",
                        bgcolor: Colors.indigo,
                        ),
                      SmallCard(
                        onTap: (){},
                        icon: Icon(Icons.newspaper),
                        title: "Current\n""News Feed",
                        ),
                    ],
                  )
              ),
            ]
        ),
      ),
    );
  }
}
