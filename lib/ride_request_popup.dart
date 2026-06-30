import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class RideRequestPopup extends StatefulWidget {
  const RideRequestPopup({super.key});

  @override
  State<RideRequestPopup> createState() => _RideRequestPopupState();
}

class _RideRequestPopupState extends State<RideRequestPopup> {
  double progress = 1.0;
  Timer? timer;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _tocarVibracao();
    _tocarSom();

    timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) return;

      setState(() {
        progress -= 0.01;
      });

      if (progress <= 0) {
  t.cancel();

  if (mounted) {
    Navigator.of(context).maybePop();
  }
}
    });
  }

  void _tocarVibracao() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500);
    }
  }

  void _tocarSom() async {
    await _player.play(
      AssetSource('sounds/99Pop.mp3'),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 20,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "R\$38,00",
              style: TextStyle(
                color: Colors.white,
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "R\$1,62 por km",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffA36500),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "• R\$11,40 incluídos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 22),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 5,
                value: progress,
                backgroundColor: const Color(0xff2C3F71),
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xffFF7A00),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 11),
                const SizedBox(width: 8),
                const Text("4.57",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(width: 8),
                const Text("94 corridas",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Cartão Verif.",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 13),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "5Min (1.2km)",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "R. Floriano Peixoto 534, Varjota",
                        style:
                            TextStyle(color: Colors.white70, fontSize: 17),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, color: Colors.red, size: 13),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "16Min (1.5km)",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Av. Beira Mar 1524, Aldeota",
                        style:
                            TextStyle(color: Colors.white70, fontSize: 17),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}