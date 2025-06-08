class NotInitializedException implements Exception {
  const NotInitializedException();

  @override
  String toString() => '''

❌ InternetStateManager is not initialized.

Before using `InternetStateManager`, you must initialize the package using `InternetStateManagerInitializer`.

✅ Correct setup in your `main()` should look like this:

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚠️ REQUIRED: Initialize the package
  await InternetStateManagerInitializer.initialize();

  runApp(
    InternetStateManagerInitializer(
      // options: .. (Optional)
      child: MyApp(),
    ),
  );
}

Make sure to wrap your root widget with `InternetStateManagerInitializer` and call `initialize()` before `runApp()`.
''';
}
