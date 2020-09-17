import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:progress_painter/progress_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custon Painter',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Custon Painter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _percentage;
  double _nextPercentage;
  Timer _timer;
  bool isDone;

  AnimationController _animController;

  publishProgress() {
    setState(() {
      _percentage = _nextPercentage;
      _nextPercentage += 0.5;
      if (_nextPercentage > 100.0) {
        _percentage = 0.0;
        _nextPercentage = 0.0;
      }
      _animController.forward(from: 0.0);
    });
  }

  startProgress() {
    if (null != _timer && _timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _percentage = 0.0;
      _nextPercentage = 0.0;
      isDone = false;
      start();
    });
  }

  handleTikecter(Timer timer) {
    _timer = timer;
    if (_nextPercentage < 100) {
      publishProgress();
    } else {
      setState(() {
        isDone = true;
      });
      timer.cancel();
    }
  }

  start() {
    Timer.periodic(Duration(milliseconds: 30), handleTikecter);
  }

  initAnim() {
    _animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000))
      ..addListener(
        () {
          setState(() {
            _percentage =
                lerpDouble(_percentage, _nextPercentage, _animController.value);
          });
        },
      );
  }

  getPercentage() {
    return Text(
      _nextPercentage == 0 ? '' : '${_nextPercentage.toInt()}',
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  progressView() {
    return CustomPaint(
      child: Center(
        child: isDone
            ? Text(
                'Full',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            : getPercentage(),
      ),
      foregroundPainter: ProgressPainter(
        defaultCircleColor: Colors.amber,
        percentageCompletedCircleColor: Colors.green,
        completedPercentage: _percentage,
        circleW: 50.0,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _percentage = 0.0;
    _nextPercentage = 0.0;
    _timer = null;
    isDone = false;
    initAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200.0,
              width: 200.0,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(30.0),
              child: progressView(),
            ),
            OutlineButton(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Start'),
              ),
              onPressed: () {
                startProgress();
              },
            )
          ],
        ),
      ),
    );
  }
}
