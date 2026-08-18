import 'package:flutter/material.dart';
import 'package:biocheck/biocheck.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Liveness Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterialDesign3: true,
      ),
      home: const MyHomePage(title: 'Face Liveness Demo'),
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
  LivenessResult? _result;

  Future<void> _startLiveness() async {
    final result = await BioCheck.startLivenessCheck(
      context,
      actions: [
        LivenessAction.blink,
        LivenessAction.smile,
        LivenessAction.turnLeft,
        LivenessAction.turnRight,
      ],
    );

    if (mounted) {
      setState(() {
        _result = result;
      });
    }
  }

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
            if (_result != null) ...[
              Text(
                _result!.isLive ? 'Liveness Success!' : 'Liveness Failed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _result!.isLive ? Colors.green : Colors.red,
                ),
              ),
              if (_result!.failureReason != null)
                Text('Reason: ${_result!.failureReason}'),
              const SizedBox(height: 20),
              Text('Completed Actions: ${_result!.completedActions.length}'),
            ] else
              const Text('Press the button to start liveness check'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startLiveness,
        tooltip: 'Start',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
