import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MusicPlayerUI(),
  ));
}

class MusicPlayerUI extends StatefulWidget {
  const MusicPlayerUI({super.key});

  @override
  State<MusicPlayerUI> createState() => _MusicPlayerUIState();
}

class _MusicPlayerUIState extends State<MusicPlayerUI>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  late AnimationController _rotationController;
  double progress = 0.0;
  Timer? _progressTimer;

  final String albumUrl =
      'https://play-lh.googleusercontent.com/PdndnWPEaztvwVnYJh7GbSwDJ9xDJOwLonmx6klDL3uy0NE-X_YQttQ_z0166Wi1zsY';

  @override
  void initState() {
    super.initState();
    _rotationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
    _rotationController.stop();
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _rotationController.repeat();
      _progressTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        setState(() {
          progress += 0.005;
          if (progress >= 1.0) {
            progress = 0.0;
            isPlaying = false;
            _rotationController.stop();
            _progressTimer?.cancel();
          }
        });
      });
    } else {
      _rotationController.stop();
      _progressTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background blur over gradient
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rotating album art with glow
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.6),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: RotationTransition(
                        turns: _rotationController,
                        child: ClipOval(
                          child: Image.network(
                            albumUrl,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Song Title
                    const Text(
                      "Ethereal Dreams",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Artist Name
                    const Text(
                      "Lofi Chillhop Beats",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Progress bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: (screenWidth - 60) * progress,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Play / Pause Button with glow
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: IconButton(
                        key: ValueKey<bool>(isPlaying),
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 90,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.pinkAccent.withOpacity(0.8),
                            ),
                          ],
                        ),
                        onPressed: togglePlayPause,
                      ),
                    ),
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
