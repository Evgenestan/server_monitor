import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/main/main_view.dart';
import 'package:server_monitor/servers/state/server_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ServerState _serverState = ServerState();

  Future<void> _runUpdate() async {
    await _serverState.getData();
    print('Updated');
  }

  void _initUpdate() {
    final Timer _timer = Timer.periodic(const Duration(seconds: 3), (timer) => _runUpdate());
  }

  @override
  Widget build(BuildContext context) {
    _initUpdate();
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
