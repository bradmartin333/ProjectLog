import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Log',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Project Log'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _tapshadow = 0;

  double _x = pi;
  double _y = pi;

  Size _size = Size.zero;
  final GlobalKey _key = GlobalKey();

  void _getSize() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    _size = renderBox.size;
  }

  void _getDragPosition(DragUpdateDetails details) {
    final RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    double dragx = localOffset.dx;
    double dragy = localOffset.dy;
    setState(() => {
          _x = dragy - _size.width / 2,
          _y = dragx - _size.height / 2,
          if (!context.isPhone)
            {
              _x = _x / (_size.width / 200),
              _y = _y / (_size.height / 200),
            }
        });
  }

  void _endDrag(DragEndDetails details) {
    if (context.isPhone) {
      setState(() => {_x = 0, _y = 0});
    }
  }

  void _afterLayout(_) {
    _getSize();
  }

  void _performTap() {
    setState(() {
      _counter++;
      _tapshadow = 50;
    });
  }

  void _relieveTap() {
    // Async loop to reduce shadow to 0 over 0.5 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      setState(() {
        if (_tapshadow > 0) {
          _tapshadow -= 1;
        }
      });
      return _tapshadow > 0;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTapDown: (_) => _performTap(),
        onTapUp: (_) => _relieveTap(),
        onVerticalDragUpdate: (details) => _getDragPosition(details),
        onHorizontalDragUpdate: (details) => _getDragPosition(details),
        onVerticalDragEnd: (details) => _endDrag(details),
        onHorizontalDragEnd: (details) => _endDrag(details),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MouseRegion(
                  key: _key,
                  cursor: SystemMouseCursors.click,
                  onHover: (event) => setState(() => {
                        if (!context.isPhone)
                          {
                            _getSize(),
                            _x = event.localPosition.dy - _size.width / 2,
                            _y = event.localPosition.dx - _size.height / 2,
                            _x = _x / (_size.width / 200),
                            _y = _y / (_size.height / 200),
                          }
                      }),
                  onExit: (event) => setState(() => {
                        _x = 0,
                        _y = 0,
                      }),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..rotateX(_x * -0.01)
                      ..rotateY(_y * 0.01),
                    alignment: FractionalOffset.center,
                    child: Container(
                      height: MediaQuery.of(context).size.shortestSide * 0.5,
                      width: MediaQuery.of(context).size.shortestSide * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.shortestSide * 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 153, 235, 194),
                            blurRadius: 20,
                            offset: Offset(-_y / 2, -_x / 2),
                            spreadRadius: _tapshadow,
                          ),
                        ],
                        color: const Color.fromARGB(62, 33, 149, 243),
                      ),
                      child: Center(
                        child: Text(
                          '$_counter',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
