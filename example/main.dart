import 'package:dio/dio.dart';
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
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DioInterceptorExample()),
                ),
                child: const Text('See Dio Interceptor Example'),
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

/// Example using InternetStateManagerInterceptor with Dio
class DioInterceptorExample extends StatefulWidget {
  const DioInterceptorExample({super.key});

  @override
  State<DioInterceptorExample> createState() => _DioInterceptorExampleState();
}

class _DioInterceptorExampleState extends State<DioInterceptorExample> {
  late final Dio _dio;
  List<dynamic>? _posts;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    // Add the optional interceptor to trigger connectivity checks
    _dio.interceptors.add(InternetStateManagerInterceptor());
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
        queryParameters: {'_limit': 5},
      );
      setState(() {
        _posts = response.data;
        _loading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = e.message ?? 'Request failed';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternetStateManager(
      child: Scaffold(
        appBar: AppBar(title: const Text('Dio Interceptor Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _loading ? null : _fetchPosts,
                icon: const Icon(Icons.download),
                label: const Text('Fetch Posts'),
              ),
              const SizedBox(height: 16),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $_error'),
                  ),
                )
              else if (_posts != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts!.length,
                    itemBuilder: (context, index) {
                      final post = _posts![index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${post['id']}')),
                          title: Text(
                            post['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            post['body'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Text('Press the button to fetch posts'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
