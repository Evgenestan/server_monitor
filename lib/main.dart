import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/main/main_view.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ServerState _serverState = ServerState();

  Future<void> _runUpdate() async {
    await _serverState.getData();
  }

  Future<void> _initUpdate() async {
    await _serverState.init();
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _serverState.endpoints = sharedPreferences.getStringList('hosts') ?? [];
    Timer.periodic(const Duration(seconds: 3), (timer) => _runUpdate());
  }

  @override
  void initState() {
    super.initState();
    _initUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServerState>(create: (_) => _serverState),
      ],
      child: MaterialApp(
        title: 'Server Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainView(),
      ),
    );
  }
}
