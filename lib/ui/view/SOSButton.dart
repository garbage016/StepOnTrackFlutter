import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosButton extends StatelessWidget {
  final double size;

  const SosButton({Key? key, this.size = 65}) : super(key: key);

  void _callEmergency() async {
    final Uri telUri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      debugPrint('Impossibile avviare la chiamata');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: _callEmergency,
        backgroundColor: const Color(0xFFFF4C4C), // Red100 equivalente
        foregroundColor: Colors.white,             // StandardWhite
        child: const Text(
          'SOS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
