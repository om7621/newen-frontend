import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'services/azure_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Start automatic incremental sync every 5 seconds
    _startAutoSync();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startAutoSync() {
    // 5-second interval as requested
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      // This will only send data if something is unsynced (is_synced = 0)
      await AzureService.performIncrementalSync();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Final push on exit
      AzureService.performIncrementalSync();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newen Traceability System',
      theme: ThemeData(
        primaryColor: const Color(0xFF1B5E20),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
