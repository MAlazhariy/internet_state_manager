import 'package:flutter/material.dart';
import 'package:internet_state_manager/internet_state_manager.dart';

void main() {
  runApp(
    InternetStateManagerInitializer.init(
      options: InternetStateOptions(
        checkConnectionPeriodic: const Duration(seconds: 3),
        disconnectionCheckPeriodic: const Duration(seconds: 1),
        showLogs: true,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet state manager',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => InternetStateManager(child: child!),
      home: const MyHomePage(),
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
            const Btn(
              title: "Go to first screen",
              screen: FirstScreen(),
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

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First screen'),
      ),
      body: const Btn(
        title: "Go to second screen",
        screen: SecondScreen(),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String title = 'Second screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: InternetStateManager(
        child: const FirstScreen(),
        onRestoreInternetConnection: (){
          setState(() {
            title = "Internet connection restored";
          });
        },
      ),
    );
  }
}

class Btn extends StatelessWidget {
  const Btn({
    super.key,
    required this.title,
    required this.screen,
  });

  final String title;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        },
        child: Text(title),
      ),
    );
  }
}
