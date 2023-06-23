import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _shadowEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: const Text('Enable shadow'),
              value: _shadowEnabled,
              onChanged: (value) {
                setState(() {
                  _shadowEnabled = value;
                });
              },
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  _shadowEnabled
                      ? 'Shadow is enabled. Scroll the stickers list... not so smooth isn\'t it'
                      : 'Shadow is disabled. Scroll the stickers list. You should not see any issue at all scrolling the list',
                )),
            CarouselSlider.builder(
              options: CarouselOptions(
                  height: 240,
                  pauseAutoPlayOnTouch: true,
                  pauseAutoPlayOnManualNavigate: true,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.70,
                  clipBehavior: Clip.none,
                  autoPlay: false),
              itemCount: 100,
              itemBuilder: (context, index, _) {
                return AspectRatio(
                    aspectRatio: 1.0,
                    child: FittedBox(
                        child: SizedBox(
                            width: 600,
                            height: 600,
                            child: Stack(children: [
                              Positioned.fill(
                                  child: Image.network(
                                'https://i.imgur.com/BI3KDwm.jpeg',
                                fit: BoxFit.cover,
                              )),
                              Positioned.fill(
                                  left: 200,
                                  right: 200,
                                  top: 200,
                                  child: Sticker(
                                    showShadow: _shadowEnabled,
                                    child: const FancyGradient(),
                                  ))
                            ]))));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Sticker extends StatelessWidget {
  final Widget child;
  final bool showShadow;

  final clipper = const StickerClipper();

  const Sticker({
    super.key,
    required this.child,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showShadow) {
      return CustomPaint(
          painter: CustomPathShadowPainter(clipper: clipper),
          child: ClipPath(clipper: clipper, child: child));
    }
    return ClipPath(clipper: clipper, child: child);
  }
}

class StickerClipper extends CustomClipper<Path> {
  const StickerClipper();

  static const nSpokes = 28;

  @override
  Path getClip(Size size) {
    final path = Path();
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.90;
    const spokeAngle = 2 * pi / nSpokes;

    final startX = outerRadius;
    final startY = outerRadius - innerRadius;
    path.moveTo(startX, startY);
    for (var i = 0; i < nSpokes; i++) {
      final outerSpokeAngle = i * spokeAngle + spokeAngle / 2;
      final innerSpokeAngle = outerSpokeAngle + spokeAngle / 2;
      final outerSpokeX = outerRadius + outerRadius * sin(outerSpokeAngle);
      final outerSpokeY = outerRadius - outerRadius * cos(outerSpokeAngle);
      final innerSpokeX = outerRadius + innerRadius * sin(innerSpokeAngle);
      final innerSpokeY = outerRadius - innerRadius * cos(innerSpokeAngle);

      path.lineTo(outerSpokeX, outerSpokeY);
      path.lineTo(innerSpokeX, innerSpokeY);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomPathShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double elevation;
  final CustomClipper<Path> clipper;

  const CustomPathShadowPainter({
    required this.clipper,
    this.shadowColor = const Color(0xFF000000),
    this.elevation = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stickerPath = clipper.getClip(size);
    canvas.drawShadow(stickerPath, shadowColor, elevation, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FancyGradient extends StatelessWidget {
  const FancyGradient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF941016),
            Color(0xFF103593),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
