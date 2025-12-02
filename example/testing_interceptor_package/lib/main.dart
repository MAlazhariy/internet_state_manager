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
        autoCheckConnection: false,
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
      title: 'Dio Interceptor Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Dio _dio;
  List<Map<String, dynamic>>? _posts;
  bool _loading = false;
  String? _error;
  int _requestCount = 0;

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
      _requestCount++;
    });

    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
        queryParameters: {'_limit': 10},
      );
      setState(() {
        _posts = List<Map<String, dynamic>>.from(response.data);
        _loading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = e.message ?? 'Request failed';
        _loading = false;
      });
    }
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _loading = true;
      _error = null;
      _requestCount++;
    });

    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/users',
        queryParameters: {'_limit': 5},
      );
      setState(() {
        _posts = List<Map<String, dynamic>>.from(response.data);
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
      onRestoreInternetConnection: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection restored! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dio Interceptor Test'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connection status card
              Card(
                color: context.internetState.isConnected
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        context.internetState.isConnected
                            ? Icons.wifi
                            : Icons.wifi_off,
                        color: context.internetState.isConnected
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.internetState.isConnected
                                  ? 'Connected'
                                  : 'No Internet',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Requests made: $_requestCount',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _fetchPosts,
                      icon: const Icon(Icons.article),
                      label: const Text('Fetch Posts'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _fetchUsers,
                      icon: const Icon(Icons.people),
                      label: const Text('Fetch Users'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Content area
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Error: $_error',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : _posts == null
                    ? const Center(
                        child: Text(
                          'Press a button to fetch data\n'
                          'The interceptor will trigger connectivity checks',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _posts!.length,
                        itemBuilder: (context, index) {
                          final item = _posts![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${item['id'] ?? index}'),
                              ),
                              title: Text(
                                item['title'] ?? item['name'] ?? 'No title',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                item['body'] ??
                                    item['email'] ??
                                    'No description',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
