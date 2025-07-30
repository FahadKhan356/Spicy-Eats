import 'package:flutter/material.dart';
//import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';

class QuantityButton1 extends StatefulWidget {
  const QuantityButton1({super.key});

  @override
  _QuantityButton1State createState() => _QuantityButton1State();
}

class _QuantityButton1State extends State<QuantityButton1> {
  int _quantity = 0;
  bool _isAdding = true;

  final player = AudioPlayer();

  // void _playSound() async {
  //   await player.setAsset('lib/assets/pop-on-269286.mp3');
  //   await player.play();
  // }
  void _playSound() async {
    try {
      if (player.playing) {
        await player.stop(); // Stop any currently playing sound
      }
      await player.setAsset('lib/assets/pop-on-269286.mp3');
      await player.play();
    } catch (e) {
      print("Error playing sound: $e"); // Handle error safely
    }
  }

  // final AudioPlayer _audioPlayer = AudioPlayer();

  // // Play sound
  // void _playSound() async {
  //   await _audioPlayer.play(AssetSource(
  //       'lib/assets/pop-on-269286.mp3')); // Add your sound file in assets
  // }

  // Handle vibration
  // void _vibrate() {
  //   if (Vibration.hasVibrator() != null) {
  //     Vibration.vibrate();
  //   }
  // }

  // Add button pressed
  void _increment() {
    setState(() {
      _quantity++;
      _isAdding = false;
      _playSound();
      //  _vibrate();
    });
  }

  // Remove button pressed
  void _decrement() {
    setState(() {
      if (_quantity > 0) _quantity--;
      if (_quantity == 0) _isAdding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isAdding
            ? ElevatedButton(
                key: ValueKey<int>(_quantity),
                onPressed: _increment,
                child: const Text('+', style: TextStyle(fontSize: 30)),
              )
            : Row(
                key: ValueKey<int>(_quantity),
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _increment,
                    child: const Text('+', style: TextStyle(fontSize: 30)),
                  ),
                  const SizedBox(width: 20),
                  Text('$_quantity', style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _decrement,
                    child: const Text('-', style: TextStyle(fontSize: 30)),
                  ),
                ],
              ),
      ),
    );
  }
}
