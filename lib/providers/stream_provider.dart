import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

//1. Providers

final streamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (count) => count);
});

final timeStreamProvider = StreamProvider<DateTime>((ref) {
  const tic = Duration(seconds: 1);
  return Stream.periodic(tic, (_) => DateTime.now());
});

//2. Consumer

class ClockScreen extends ConsumerWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(timeStreamProvider);
    return Center(
      child: stream.when(
        data: (time) => 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: const Size(300, 300),
              painter: ClockPainter(time: time),
            ),
            const SizedBox(height: 20),
            Text(
              '${time.hour}:${time.minute}:${time.second}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}

//3. Creation du painter

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = Colors.black12
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

      final hourHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

      final minuteHand = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

      final secondsHand = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paintCircle);

    //Angles
    final hourAngle = (time.hour % 12 + time.minute / 60) * 30 * 3.14 / 180;
    canvas.drawLine(
      center, 
      center + Offset(
        radius * 0.5 * cos(
          hourAngle - 3.14 / 2), 
          radius * 0.5 * sin(
            hourAngle - pi / 2),), 
            hourHand);

    final minuteAngle = (time.minute + time.second / 60) * 6 * 3.14 / 180;
    canvas.drawLine(
      center, 
      center + Offset(
        radius * 0.7 * cos(
          minuteAngle - 3.14 / 2), 
          radius * 0.7 * sin(
            minuteAngle - pi / 2),), 
            minuteHand);

    final secondsAngle = time.second * 6 * 3.14 / 180;
    canvas.drawLine(
      center, 
      center + Offset(
        radius * 0.8 * cos(
          secondsAngle - 3.14 / 2), 
          radius * 0.7 * sin(
            secondsAngle - pi / 2),), 
            secondsHand);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
