import 'package:flutter/material.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:muscle_selector/src/size_controller.dart';

class MusclePainter extends CustomPainter {
  final Muscle muscle;
  final List<Muscle> selectedMuscles;
  final Color? strokeColor;
  final Color? selectedColor;
  final Color? dotColor;

  final sizeController = SizeController.instance;

  double _scale = 1.0;

  MusclePainter({
    required this.muscle,
    required this.selectedMuscles,
    this.selectedColor,
    this.strokeColor,
    this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = strokeColor ?? Colors.white60
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final selectedPen = Paint()
      ..color = selectedColor ?? Colors.blue
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    final redDot = Paint()
      ..color = dotColor ?? Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final bounds = muscle.path.getBounds();

    _scale = sizeController.calculateScale(size);
    canvas.scale(_scale);

    if (selectedMuscles.any((selected) => selected.id == muscle.id)) {
      canvas.drawPath(muscle.path, selectedPen);
    }
    canvas.drawCircle(bounds.center, 3.0, redDot);
    canvas.drawPath(muscle.path, pen);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    double inverseScale = sizeController.inverseOfScale(_scale);
    return muscle.path.contains(position.scale(inverseScale, inverseScale));
  }
}
