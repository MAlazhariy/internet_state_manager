import 'package:flutter/material.dart';
import 'package:internet_state_manager/internet_state_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Required: Initialize before runApp
  await InternetStateManagerInitializer.initialize();

  runApp(
    InternetStateManagerInitializer(
      options: InternetStateOptions(
        checkConnectionPeriodic: const Duration(seconds: 5),
        disconnectionCheckPeriodic: const Duration(seconds: 2),
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
      title: 'Internet State Manager Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap your screen with InternetStateManager
    return InternetStateManager(
      onRestoreInternetConnection: () {
        // Called when connection is restored
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection restored! 🎉')),
        );
      },
      noInternetScreen: const NoInternetScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Internet State Manager'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'You are connected!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BuilderExample()),
                ),
                child: const Text('See Builder Example'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example using InternetStateManager.builder for custom UI
class BuilderExample extends StatelessWidget {
  const BuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetStateManager.builder(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Builder Example')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state.status.isConnected ? Icons.cloud_done : Icons.cloud_off,
                  size: 80,
                  color: state.status.isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  state.status.isConnected
                      ? '✅ Connected to internet'
                      : '❌ No internet connection',
                  style: const TextStyle(fontSize: 18),
                ),
                if (state.loading) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                  const Text('Checking connection...'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
