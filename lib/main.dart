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
    RectDiagram2(
        color: Colors.lightBlue.shade200,
        size: const Size(200, 100),
        position: const Offset(10, 130)),
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

  var padding = 5.0;
  @override
  Widget build(State state) {
    return Positioned(
      left: position.dx - 2.5,
      top: position.dy - 2.5,
      child: Stack(children: [
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            state.setState(() {
              print("Body: " + details.localPosition.toString());
              position += details.delta;
            });
          },
          child: CustomPaint(
            size: Size(size.width + (padding / 2) * 3,
                size.height + (padding / 2) * 3),
            painter: ReactPainter(
              color: color,
              padding: padding,
            ),
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    state.setState(() {
                      print("TopLeft: " + details.localPosition.toString());
                      size += details.delta;
                    });
                  },
                  child: CustomPaint(
                    size: Size(padding * 2, padding * 2),
                    painter: ReactConerPainter(
                      color: color,
                    ),
                  ),
                ))),
        Positioned(
            left: size.width - padding,
            top: 0,
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    state.setState(() {
                      print("TopRight: " + details.localPosition.toString());
                      size += details.delta;
                    });
                  },
                  child: CustomPaint(
                    size: Size(padding * 2, padding * 2),
                    painter: ReactConerPainter(
                      color: color,
                    ),
                  ),
                ))),
        Positioned(
            left: 0,
            top: size.height - padding,
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    state.setState(() {
                      print("BottomLeft: " + details.localPosition.toString());
                      size += details.delta;
                    });
                  },
                  child: CustomPaint(
                    size: Size(padding * 2, padding * 2),
                    painter: ReactConerPainter(
                      color: color,
                    ),
                  ),
                ))),
        Positioned(
            left: size.width - padding,
            top: size.height - padding,
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    state.setState(() {
                      print("BottomRight: " + details.localPosition.toString());
                      size += details.delta;
                    });
                  },
                  child: CustomPaint(
                    size: Size(padding * 2, padding * 2),
                    painter: ReactConerPainter(
                      color: color,
                    ),
                  ),
                )))
      ]),
    );
  }
}

class ReactPainter extends CustomPainter {
  ReactPainter({
    required this.color,
    required this.padding,
  });
  final double padding;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var p = 5.0; // padding

    final paint = Paint();
    paint.color = color;
    canvas.drawRect(
        Rect.fromLTWH(p / 2, p / 2, size.width - 7.5, size.height - 7.5),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ReactConerPainter extends CustomPainter {
  ReactConerPainter({
    required this.color,
  });
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var p = size.width / 2;

    final paint = Paint();

    paint.color = Colors.blue;
    canvas.drawCircle(Offset(p, p), p, paint);
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

class RectDiagram2 extends Diagram {
  RectDiagram2(
      {required super.position, required super.size, required super.color});

  var isReize = false;
  @override
  Widget build(State state) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        child: CustomPaint(
          size: Size(size.width, size.height),
          painter: ReactPainterOld(
            color: color,
          ),
        ),
      ),
    );
  }
}

class ReactPainterOld extends CustomPainter {
  ReactPainterOld({
    required this.color,
  });
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
