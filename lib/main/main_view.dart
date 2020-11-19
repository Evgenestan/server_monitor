import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:server_monitor/main/server_card.dart';
import 'package:server_monitor/servers/server_edit_view.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  void _addServer() {
    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) => ServerEditView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addServer,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: const [
          ServerCard(
            title: 'MyServer',
            isOnline: true,
            ipAddress: '192.168.0.1',
          ),
          ServerCard(title: 'Длинное название', isOnline: false, ipAddress: '164.135.204.6')
        ],
      ),
    );
  }
}
