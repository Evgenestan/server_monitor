import 'dart:async';

import 'package:flutter/material.dart';
import 'package:server_monitor/globalVariable.dart';
import 'package:server_monitor/main/main_view.dart';
import 'package:server_monitor/servers/state/server_state.dart';

Timer _timer;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _timer = Timer.periodic(const Duration(seconds: 3), (timer) => _runUpdate());
  runApp(MyApp());
}

Future<void> _runUpdate() async {
  final ServerState _serverState = serverState;
  print('Update');
  await _serverState.getData();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainView(),
    );
  }
}
