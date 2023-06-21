import 'dart:math';

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
  double _x = pi;
  double _y = pi;
  Size _size = Size.zero;
  GlobalKey _key = GlobalKey();

  void _getSizes() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    _size = renderBox.size;
  }

  void _afterLayout(_) {
    _getSizes();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MouseRegion(
              key: _key,
              cursor: SystemMouseCursors.move,
              onHover: (event) => setState(() => {
                    _getSizes(),
                    _x = -0.01 * (event.localPosition.dy - _size.width / 2),
                    _y = 0.01 * (event.localPosition.dx - _size.height / 2),
                    // Adjust the range of x and y from
                    //[-(size.x/y * 0.005), (size.x/y * 0.005)] to [-1, 1]
                    _x = _x / (_size.width / 200),
                    _y = _y / (_size.height / 200),
                  }),
              onExit: (event) => setState(() => {
                    _x = 0,
                    _y = 0,
                  }),
              child: Transform(
                transform: Matrix4.inverted(Matrix4.identity()
                  ..rotateX(_x)
                  ..rotateY(_y)),
                alignment: FractionalOffset.center,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 100,
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: RadialGradient(
                        colors: [
                          const Color.fromARGB(255, 153, 235, 194),
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
