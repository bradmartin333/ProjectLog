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
  double _x = pi;
  double _y = pi;
  double _dragx = 0;
  double _dragy = 0;
  Size _size = Size.zero;
  final GlobalKey _key = GlobalKey();

  void _getSize() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    _size = renderBox.size;
    _dragx = 0;
    _dragy = 0;
  }

  void _getDragPosition(DragUpdateDetails details) {
    final RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    _dragx = localOffset.dx;
    _dragy = localOffset.dy;
    setState(() => {
          _x = _dragy - _size.width / 2,
          _y = _dragx - _size.height / 2,
        });
  }

  void _afterLayout(_) {
    _getSize();
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
      body: GestureDetector(
        onVerticalDragUpdate: (details) => _getDragPosition(details),
        onHorizontalDragUpdate: (details) => _getDragPosition(details),
        onVerticalDragEnd: (details) => setState(() => {_x = 0, _y = 0}),
        onHorizontalDragEnd: (details) => setState(() => {_x = 0, _y = 0}),
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
                  cursor: SystemMouseCursors.move,
                  onHover: (event) => setState(() => {
                        if (!context.isPhone)
                          {
                            _getSize(),
                            _x = event.localPosition.dy - _size.width / 2,
                            _y = event.localPosition.dx - _size.height / 2,
                            // Adjust the range of x and y from
                            //[-(size.x/y * 0.005), (size.x/y * 0.005)] to [-1, 1]
                            _x = _x / (_size.width / 200),
                            _y = _y / (_size.height / 200),
                          }
                      }),
                  onExit: (event) => setState(() => {
                        _x = 0,
                        _y = 0,
                      }),
                  child: Transform(
                    transform: Matrix4.inverted(Matrix4.identity()
                      ..rotateX(_x * -0.01)
                      ..rotateY(_y * 0.01)),
                    alignment: FractionalOffset.center,
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 50,
                      child: Container(
                        // Set height and width to be 0.5 the min dimension of the screen
                        height: MediaQuery.of(context).size.shortestSide * 0.5,
                        width: MediaQuery.of(context).size.shortestSide * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 235, 194),
                              blurRadius: 20,
                              offset: Offset(-_y / 2, -_x / 2),
                            ),
                          ],
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
