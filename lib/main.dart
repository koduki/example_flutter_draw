import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Draw Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DrawPage(title: 'Flutter Draw Demo'),
    );
  }
}

class DrawPage extends StatefulWidget {
  const DrawPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  var diagrams = [
    RectDiagram(
        color: Colors.yellow.shade200,
        size: const Size(200, 100),
        position: const Offset(10, 10)),
    // RectDiagram(
    //     color: Colors.lightBlue.shade200,
    //     size: const Size(320, 320),
    //     position: const Offset(300, 10)),
    // CircleDiagram(
    //     color: Colors.lightGreen.shade200,
    //     size: const Size(200, 200),
    //     position: const Offset(10, 150)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: diagrams.map((x) => x.build(this)).toList()),
    );
  }
}

abstract class Diagram {
  Diagram({
    required this.position,
    required this.size,
    required this.color,
  });
  Offset position;
  Size size;
  Color color;

  Widget build(State state);
}

class RectDiagram extends Diagram {
  RectDiagram(
      {required super.position, required super.size, required super.color});

  var isReize = false;
  @override
  Widget build(State state) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          state.setState(() {
            print("OnpanUpdate: " + details.localPosition.toString());

            if (isReize) {
              size += details.delta;
            } else {
              position += details.delta;
            }
          });
        },
        onTapDown: (TapDownDetails details) {
          print("OnTap: " + details.localPosition.toString());
          var x = details.localPosition.dx;
          var y = details.localPosition.dy;
          var w = size.width;
          var h = size.height;

          var p = 5; // padding
          var isTopLeft = (0 <= x && x <= p && 0 <= y && y <= p);
          var isTopRight = (w - p <= x && x <= w && 0 <= y && y <= p);
          var isBottomLeft = (0 <= x && x <= p && h - p <= y && y <= h);
          var isBottomRight = (w - p <= x && x <= w && h - p <= y && y <= h);
          if (isTopLeft || isTopRight || isBottomLeft || isBottomRight) {
            isReize = true;
            print("isReize: true");
          }
        },
        onPanEnd: (DragEndDetails details) {
          if (isReize) {
            isReize = false;
            print("isReize: false");
          }
        },
        child: CustomPaint(
          size: Size(size.width + 5.0, size.height + 5.0),
          painter: ReactPainter(
            color: color,
          ),
        ),
      ),
    );
  }
}

class ReactPainter extends CustomPainter {
  ReactPainter({
    required this.color,
  });
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var p = 5.0; // padding

    final paint = Paint();
    paint.color = color;
    canvas.drawRect(
        Rect.fromLTWH(p / 2, p / 2, size.width - p / 2, size.height - p / 2),
        paint);

    paint.color = Colors.blue;
    canvas.drawCircle(Offset(p / 2, p / 2), p, paint);
    canvas.drawCircle(Offset(size.width, p), p, paint);
    canvas.drawCircle(Offset(p, size.height), p, paint);
    canvas.drawCircle(Offset(size.width, size.height), p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircleDiagram extends Diagram {
  CircleDiagram(
      {required super.position, required super.size, required super.color});

  @override
  Widget build(State state) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          state.setState(() {
            print("update: " + position.toString());

            position += details.delta;
          });
        },
        child: CustomPaint(
          size: size,
          painter: CirclePainter(
            color: color,
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.color,
  });
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final double radius = size.width / 2;

    paint.color = color;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
