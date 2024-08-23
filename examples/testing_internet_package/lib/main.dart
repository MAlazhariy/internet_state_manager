import 'package:flutter/material.dart';
import 'package:internet_state_manager/internet_state_manager.dart';

void main() {
  runApp(
    InternetStateManagerInitializer.init(
      options: InternetStateOptions(
        checkConnectionPeriodic: const Duration(seconds: 5),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet state manager',
      debugShowCheckedModeBanner: false,
      home: InternetStateManager(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title = 'Internet state manager',
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    // onStreamConncetionRestored.listen((status){
    //   // some code;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return InternetStateManager.builder(
    //   builder: (context, state){
    //     return Scaffold(
    //       appBar: AppBar(...),
    //       body: Center(...),
    //     );
    //   },
    // child: Scaffold(
    //   appBar: AppBar(...),
    //   body: Center(...),
    // ),
    // );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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
